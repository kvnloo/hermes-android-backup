/// A small RFB (VNC) client for the Bot Desktop viewer.
///
/// The gateway's `/api/display/ws` splices the bot's Xvnc socket into a
/// WebSocket as binary frames (`hermes_cli/web_routers/display.py`). Xvnc runs
/// with `-SecurityTypes None`, so the handshake is version, security type and
/// ClientInit. This client asks for 32-bit true colour and the Raw, CopyRect
/// and DesktopSize encodings only: enough to show the screen and to send the
/// pointer and keyboard the gateway forwards from the lease holder.
library;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// The byte pipe to one bot's screen.
abstract interface class BotDisplayChannel {
  /// Binary frames from the screen. Done when the pipe closes.
  Stream<List<int>> get incoming;
  void add(List<int> bytes);
  Future<void> close([int code = WebSocketStatus.normalClosure]);

  /// The close code the gateway sent (4000 control taken, 4001 screen gone,
  /// 4401 ticket refused), once closed.
  int? get closeCode;
}

final class WebSocketDisplayChannel implements BotDisplayChannel {
  WebSocketDisplayChannel(this._socket);
  final WebSocket _socket;

  @override
  late final Stream<List<int>> incoming = _socket
      .where((frame) => frame is List<int>)
      .cast<List<int>>();

  @override
  void add(List<int> bytes) {
    if (_socket.readyState == WebSocket.open) _socket.add(bytes);
  }

  @override
  Future<void> close([int code = WebSocketStatus.normalClosure]) async {
    try {
      await _socket.close(code);
    } catch (_) {}
  }

  @override
  int? get closeCode => _socket.closeCode;
}

final class BotDisplayRfbException implements Exception {
  const BotDisplayRfbException(this.message);
  final String message;
  @override
  String toString() => message;
}

class _ByteQueue {
  final _chunks = Queue<Uint8List>();
  int _head = 0;
  int length = 0;

  void add(List<int> data) {
    if (data.isEmpty) return;
    _chunks.add(data is Uint8List ? data : Uint8List.fromList(data));
    length += data.length;
  }

  /// The next [count] bytes, or null until that many have arrived.
  Uint8List? take(int count) {
    if (count > length) return null;
    final out = Uint8List(count);
    var filled = 0;
    while (filled < count) {
      final chunk = _chunks.first;
      final available = chunk.length - _head;
      final want = count - filled;
      final step = available < want ? available : want;
      out.setRange(filled, filled + step, chunk, _head);
      filled += step;
      _head += step;
      if (_head == chunk.length) {
        _chunks.removeFirst();
        _head = 0;
      }
    }
    length -= count;
    return out;
  }
}

enum _Phase {
  version,
  security,
  securityResult,
  failureLength,
  failureText,
  serverInit,
  serverName,
  message,
  updateHeader,
  rectHeader,
  rectRaw,
  rectCopy,
  cutTextHeader,
  colourMapHeader,
  skip,
}

class BotDisplayRfb {
  BotDisplayRfb(this._channel, {this.onFrame, this.onClosed}) {
    // A handshake nobody awaited must not surface as an unhandled error.
    ready.ignore();
    _subscription = _channel.incoming.listen(
      _onData,
      onError: (Object _) => _shutdown('The screen connection failed'),
      onDone: () => _shutdown(null),
      cancelOnError: true,
    );
  }

  static const maxDimension = 8192;
  static const maxFramebufferBytes = 96 * 1024 * 1024;
  static const _maxSkip = 1024 * 1024;

  static const keyBackspace = 0xff08;
  static const keyTab = 0xff09;
  static const keyReturn = 0xff0d;
  static const keyEscape = 0xff1b;
  static const keyDelete = 0xffff;

  final BotDisplayChannel _channel;

  /// Called after each complete framebuffer update.
  void Function()? onFrame;

  /// Called once when the stream ends; [error] is null for a plain close.
  void Function(String? error)? onClosed;

  late final StreamSubscription<List<int>> _subscription;
  final _in = _ByteQueue();
  final _ready = Completer<void>();
  var _phase = _Phase.version;
  var _minor = 8;
  int? _securityCount;
  var _pending = 0;
  var _rectsLeft = 0;
  var _rectX = 0;
  var _rectY = 0;
  var _rectW = 0;
  var _rectH = 0;
  var _live = false;
  var _closed = false;
  String? _error;
  int _width = 0;
  int _height = 0;
  Uint8List _framebuffer = Uint8List(0);
  int _frames = 0;
  String _name = '';

  /// Completes once the server's screen size is known and the first frame
  /// has been asked for; fails if the handshake is refused or the pipe closes.
  Future<void> get ready => _ready.future;
  bool get isLive => _live && !_closed;
  bool get isClosed => _closed;
  String? get error => _error;
  int get width => _width;
  int get height => _height;
  int get frames => _frames;
  String get desktopName => _name;
  int? get closeCode => _channel.closeCode;

  /// RGBA, `width * height * 4` bytes, updated in place.
  Uint8List get framebuffer => _framebuffer;

  void _send(List<int> bytes) {
    if (!_closed) _channel.add(bytes);
  }

  void _onData(List<int> data) {
    if (_closed) return;
    _in.add(data);
    try {
      while (!_closed && _advance()) {}
    } on BotDisplayRfbException catch (e) {
      _shutdown(e.message);
    } catch (_) {
      _shutdown('The screen sent data the viewer could not read');
    }
  }

  Never _refuse(String message) => throw BotDisplayRfbException(message);

  /// Consumes one protocol element. False when more bytes are needed.
  bool _advance() {
    switch (_phase) {
      case _Phase.version:
        final raw = _in.take(12);
        if (raw == null) return false;
        final match = RegExp(
          r'^RFB (\d{3})\.(\d{3})\n$',
        ).firstMatch(ascii.decode(raw, allowInvalid: true));
        if (match == null || int.parse(match.group(1)!) != 3) {
          _refuse('This is not a screen the viewer can read');
        }
        final minor = int.parse(match.group(2)!);
        _minor = minor >= 8 ? 8 : (minor == 7 ? 7 : 3);
        _send(ascii.encode('RFB 003.00$_minor\n'));
        _phase = _Phase.security;
        return true;
      case _Phase.security:
        if (_minor == 3) {
          final raw = _in.take(4);
          if (raw == null) return false;
          final type = ByteData.sublistView(raw).getUint32(0);
          if (type == 0) {
            _phase = _Phase.failureLength;
          } else if (type == 1) {
            _clientInit();
          } else {
            _refuse('The screen asks for a password the viewer cannot give');
          }
          return true;
        }
        if (_securityCount == null) {
          final raw = _in.take(1);
          if (raw == null) return false;
          _securityCount = raw[0];
          if (raw[0] == 0) _phase = _Phase.failureLength;
          return true;
        }
        final types = _in.take(_securityCount!);
        if (types == null) return false;
        if (!types.contains(1)) {
          _refuse('The screen asks for a password the viewer cannot give');
        }
        _send(const [1]);
        if (_minor >= 8) {
          _phase = _Phase.securityResult;
        } else {
          _clientInit();
        }
        return true;
      case _Phase.securityResult:
        final raw = _in.take(4);
        if (raw == null) return false;
        if (ByteData.sublistView(raw).getUint32(0) == 0) {
          _clientInit();
        } else {
          _phase = _Phase.failureLength;
        }
        return true;
      case _Phase.failureLength:
        final raw = _in.take(4);
        if (raw == null) return false;
        _pending = ByteData.sublistView(raw).getUint32(0);
        if (_pending > 4096) _refuse('The screen refused the connection');
        _phase = _Phase.failureText;
        return true;
      case _Phase.failureText:
        final raw = _in.take(_pending);
        if (raw == null) return false;
        final reason = utf8.decode(raw, allowMalformed: true).trim();
        _refuse(reason.isEmpty ? 'The screen refused the connection' : reason);
      case _Phase.serverInit:
        final raw = _in.take(24);
        if (raw == null) return false;
        final view = ByteData.sublistView(raw);
        _resize(view.getUint16(0), view.getUint16(2));
        _pending = view.getUint32(20);
        if (_pending > 4096) _refuse('The screen sent an invalid name');
        _phase = _Phase.serverName;
        return true;
      case _Phase.serverName:
        final raw = _in.take(_pending);
        if (raw == null) return false;
        _name = utf8.decode(raw, allowMalformed: true);
        // 32 bits per pixel, little-endian, red in the low byte: the bytes
        // arrive as R, G, B, unused, which is the RGBA the canvas takes once
        // the unused byte is made opaque.
        _send(const [
          0, 0, 0, 0, //
          32, 24, 0, 1,
          0, 255, 0, 255, 0, 255,
          0, 8, 16,
          0, 0, 0,
        ]);
        final encodings = ByteData(4 + 3 * 4)
          ..setUint8(0, 2)
          ..setUint16(2, 3)
          ..setInt32(4, 1) // CopyRect
          ..setInt32(8, 0) // Raw
          ..setInt32(12, -223); // DesktopSize
        _send(encodings.buffer.asUint8List());
        _requestUpdate(incremental: false);
        _live = true;
        _phase = _Phase.message;
        if (!_ready.isCompleted) _ready.complete();
        return true;
      case _Phase.message:
        final raw = _in.take(1);
        if (raw == null) return false;
        _phase = switch (raw[0]) {
          0 => _Phase.updateHeader,
          1 => _Phase.colourMapHeader,
          2 => _Phase.message, // Bell
          3 => _Phase.cutTextHeader,
          _ => _refuse('The screen sent a message the viewer does not know'),
        };
        return true;
      case _Phase.updateHeader:
        final raw = _in.take(3);
        if (raw == null) return false;
        _rectsLeft = ByteData.sublistView(raw).getUint16(1);
        if (_rectsLeft == 0) {
          _finishUpdate();
        } else {
          _phase = _Phase.rectHeader;
        }
        return true;
      case _Phase.rectHeader:
        final raw = _in.take(12);
        if (raw == null) return false;
        final view = ByteData.sublistView(raw);
        _rectX = view.getUint16(0);
        _rectY = view.getUint16(2);
        _rectW = view.getUint16(4);
        _rectH = view.getUint16(6);
        switch (view.getInt32(8)) {
          case 0:
            _checkRect(_rectX, _rectY);
            _pending = _rectW * _rectH * 4;
            if (_pending == 0) {
              _rectDone();
            } else {
              _phase = _Phase.rectRaw;
            }
          case 1:
            _checkRect(_rectX, _rectY);
            _phase = _Phase.rectCopy;
          case -223:
            _resize(_rectW, _rectH);
            _rectDone();
          default:
            _refuse('The screen used an encoding the viewer did not ask for');
        }
        return true;
      case _Phase.rectRaw:
        final raw = _in.take(_pending);
        if (raw == null) return false;
        final row = _rectW * 4;
        for (var y = 0; y < _rectH; y++) {
          final to = ((_rectY + y) * _width + _rectX) * 4;
          _framebuffer.setRange(to, to + row, raw, y * row);
          for (var alpha = to + 3; alpha < to + row; alpha += 4) {
            _framebuffer[alpha] = 255;
          }
        }
        _rectDone();
        return true;
      case _Phase.rectCopy:
        final raw = _in.take(4);
        if (raw == null) return false;
        final view = ByteData.sublistView(raw);
        final fromX = view.getUint16(0);
        final fromY = view.getUint16(2);
        _checkRect(fromX, fromY);
        final row = _rectW * 4;
        final copy = Uint8List(row * _rectH);
        for (var y = 0; y < _rectH; y++) {
          final from = ((fromY + y) * _width + fromX) * 4;
          copy.setRange(y * row, (y + 1) * row, _framebuffer, from);
        }
        for (var y = 0; y < _rectH; y++) {
          final to = ((_rectY + y) * _width + _rectX) * 4;
          _framebuffer.setRange(to, to + row, copy, y * row);
        }
        _rectDone();
        return true;
      case _Phase.cutTextHeader:
        // The bot's clipboard is not copied onto this device.
        final raw = _in.take(7);
        if (raw == null) return false;
        _skip(ByteData.sublistView(raw).getUint32(3));
        return true;
      case _Phase.colourMapHeader:
        final raw = _in.take(5);
        if (raw == null) return false;
        _skip(ByteData.sublistView(raw).getUint16(3) * 6);
        return true;
      case _Phase.skip:
        if (_in.take(_pending) == null) return false;
        _phase = _Phase.message;
        return true;
    }
  }

  void _skip(int count) {
    if (count > _maxSkip) _refuse('The screen sent an oversized message');
    _pending = count;
    _phase = _Phase.skip;
  }

  void _clientInit() {
    _send(const [1]); // shared: other viewers stay connected
    _phase = _Phase.serverInit;
  }

  void _resize(int width, int height) {
    if (width < 1 ||
        height < 1 ||
        width > maxDimension ||
        height > maxDimension ||
        width * height * 4 > maxFramebufferBytes) {
      _refuse('The screen is a size the viewer cannot show');
    }
    if (width == _width && height == _height) return;
    _width = width;
    _height = height;
    _framebuffer = Uint8List(width * height * 4);
  }

  void _checkRect(int x, int y) {
    if (x + _rectW > _width || y + _rectH > _height) {
      _refuse('The screen sent a region outside itself');
    }
  }

  void _rectDone() {
    _rectsLeft--;
    if (_rectsLeft > 0) {
      _phase = _Phase.rectHeader;
    } else {
      _finishUpdate();
    }
  }

  void _finishUpdate() {
    _frames++;
    _phase = _Phase.message;
    _requestUpdate(incremental: true);
    onFrame?.call();
  }

  void _requestUpdate({required bool incremental}) {
    final request = ByteData(10)
      ..setUint8(0, 3)
      ..setUint8(1, incremental ? 1 : 0)
      ..setUint16(6, _width)
      ..setUint16(8, _height);
    _send(request.buffer.asUint8List());
  }

  /// Moves the pointer to ([x], [y]) on the bot's screen. [buttons] is the
  /// RFB mask: 1 left, 2 middle, 4 right, 8 wheel up, 16 wheel down.
  void pointer(int x, int y, int buttons) {
    if (!isLive) return;
    final event = ByteData(6)
      ..setUint8(0, 5)
      ..setUint8(1, buttons & 0xff)
      ..setUint16(2, x.clamp(0, _width - 1))
      ..setUint16(4, y.clamp(0, _height - 1));
    _send(event.buffer.asUint8List());
  }

  void key(int keysym, {required bool down}) {
    if (!isLive) return;
    final event = ByteData(8)
      ..setUint8(0, 4)
      ..setUint8(1, down ? 1 : 0)
      ..setUint32(4, keysym);
    _send(event.buffer.asUint8List());
  }

  void tapKey(int keysym) {
    key(keysym, down: true);
    key(keysym, down: false);
  }

  /// The X11 keysym of one typed character.
  static int keysymFor(int rune) => switch (rune) {
    0x0a || 0x0d => keyReturn,
    0x09 => keyTab,
    0x08 => keyBackspace,
    0x1b => keyEscape,
    < 0x100 => rune,
    _ => 0x01000000 | rune,
  };

  void typeText(String text) {
    for (final rune in text.runes) {
      tapKey(keysymFor(rune));
    }
  }

  void _shutdown(String? error) {
    if (_closed) return;
    _closed = true;
    _error = error;
    unawaited(_subscription.cancel());
    unawaited(_channel.close());
    if (!_ready.isCompleted) {
      _ready.completeError(
        BotDisplayRfbException(error ?? 'The screen closed the connection'),
      );
    }
    onClosed?.call(error);
  }

  /// A clean close: the gateway reads it as the viewer window closing.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _subscription.cancel();
    if (!_ready.isCompleted) {
      _ready.completeError(const BotDisplayRfbException('Viewer closed'));
    }
    await _channel.close();
  }
}
