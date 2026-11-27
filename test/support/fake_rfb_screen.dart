import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hermes_android/core/services/bot_display_rfb.dart';

/// An Xvnc behind the gateway's `/api/display/ws` bridge, in memory: RFB 3.8
/// with `-SecurityTypes None`, one Raw framebuffer of [width] x [height]
/// pixels of [colour] (R, G, B), and a log of what the viewer sent.
class FakeRfbScreen implements BotDisplayChannel {
  FakeRfbScreen({
    this.width = 4,
    this.height = 2,
    this.colour = const [10, 20, 30],
    this.refuse,
    this.chunk,
    this.onLive,
  }) {
    _emit(ascii.encode('RFB 003.008\n'));
  }

  final int width;
  final int height;
  final List<int> colour;

  /// When set, the security handshake fails with this reason.
  final String? refuse;

  /// When set, every server message is delivered in pieces of this size.
  final int? chunk;

  /// Called when the viewer asks for its first frame (the screen is live).
  final void Function()? onLive;

  final _out = StreamController<List<int>>();
  final _in = BytesBuilder(copy: false);
  var _stage = 0;

  /// (x, y, buttons) of each PointerEvent the viewer sent.
  final pointers = <List<int>>[];

  /// (keysym, down) of each KeyEvent the viewer sent.
  final keys = <List<int>>[];
  var updateRequests = 0;
  List<int>? pixelFormat;
  final encodings = <int>[];

  @override
  int? closeCode;
  bool get isClosed => closeCode != null;

  @override
  Stream<List<int>> get incoming => _out.stream;

  void _emit(List<int> bytes) {
    if (_out.isClosed) return;
    final size = chunk;
    if (size == null) {
      _out.add(bytes);
      return;
    }
    for (var i = 0; i < bytes.length; i += size) {
      _out.add(
        bytes.sublist(i, i + size > bytes.length ? bytes.length : i + size),
      );
    }
  }

  /// The gateway closing the socket: 4000 control taken, 4001 screen gone,
  /// 1006 for a dropped link.
  void drop(int code) {
    if (isClosed) return;
    closeCode = code;
    unawaited(_out.close());
  }

  @override
  Future<void> close([int code = WebSocketStatus.normalClosure]) async {
    if (isClosed) return;
    closeCode = code;
    unawaited(_out.close());
  }

  /// One Raw rectangle covering the whole screen.
  void sendFrame([List<int>? rgb]) {
    final c = rgb ?? colour;
    final frame = BytesBuilder()
      ..add([0, 0, 0, 1])
      ..add(_u16(0))
      ..add(_u16(0))
      ..add(_u16(width))
      ..add(_u16(height))
      ..add([0, 0, 0, 0]);
    for (var i = 0; i < width * height; i++) {
      frame.add([c[0], c[1], c[2], 0]);
    }
    _emit(frame.takeBytes());
  }

  static List<int> _u16(int v) => [(v >> 8) & 0xff, v & 0xff];

  /// Bytes exactly as given: for frames a real screen would never send.
  void sendRaw(List<int> bytes) => _emit(bytes);

  @override
  void add(List<int> bytes) {
    if (isClosed) return;
    _in.add(bytes);
    var data = _in.takeBytes();
    var at = 0;
    bool has(int n) => data.length - at >= n;
    while (true) {
      if (_stage == 0) {
        if (!has(12)) break;
        at += 12;
        _stage = 1;
        if (refuse != null) {
          final reason = utf8.encode(refuse!);
          _emit([0, 0, 0, 0, reason.length, ...reason]);
          drop(1000);
          return;
        }
        _emit([1, 1]);
      } else if (_stage == 1) {
        if (!has(1)) break;
        at += 1;
        _stage = 2;
        _emit([0, 0, 0, 0]);
      } else if (_stage == 2) {
        if (!has(1)) break;
        at += 1;
        _stage = 3;
        const name = 'bot';
        _emit([
          ..._u16(width),
          ..._u16(height),
          ...List.filled(16, 0),
          0,
          0,
          0,
          name.length,
          ...ascii.encode(name),
        ]);
      } else {
        if (!has(1)) break;
        final type = data[at];
        if (type == 0) {
          if (!has(20)) break;
          pixelFormat = data.sublist(at + 4, at + 20);
          at += 20;
        } else if (type == 2) {
          if (!has(4)) break;
          final count = (data[at + 2] << 8) | data[at + 3];
          if (!has(4 + count * 4)) break;
          final view = ByteData.sublistView(data, at + 4, at + 4 + count * 4);
          for (var i = 0; i < count; i++) {
            encodings.add(view.getInt32(i * 4));
          }
          at += 4 + count * 4;
        } else if (type == 3) {
          if (!has(10)) break;
          final incremental = data[at + 1] == 1;
          at += 10;
          updateRequests++;
          if (!incremental) {
            onLive?.call();
            sendFrame();
          }
        } else if (type == 4) {
          if (!has(8)) break;
          final view = ByteData.sublistView(data, at, at + 8);
          keys.add([view.getUint32(4), data[at + 1]]);
          at += 8;
        } else if (type == 5) {
          if (!has(6)) break;
          final view = ByteData.sublistView(data, at, at + 6);
          pointers.add([view.getUint16(2), view.getUint16(4), data[at + 1]]);
          at += 6;
        } else {
          throw StateError('unexpected client message $type');
        }
      }
    }
    if (at < data.length) _in.add(data.sublist(at));
  }
}
