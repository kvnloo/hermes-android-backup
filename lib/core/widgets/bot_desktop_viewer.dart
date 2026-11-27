import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/bot_desktop_session.dart';
import '../services/bot_display_rfb.dart';
import '../l10n/l10n.dart';

/// The live Bot Desktop while the user holds it: the bot's screen, with the
/// pointer, hardware keys and a line for typing on a phone. Closing the page
/// (or Hand back) ends the take-over; [session] releases the lease.
class BotDesktopViewerPage extends StatefulWidget {
  const BotDesktopViewerPage({
    super.key,
    required this.session,
    required this.botName,
  });

  final BotDesktopSession session;
  final String botName;

  @override
  State<BotDesktopViewerPage> createState() => _BotDesktopViewerPageState();
}

class _BotDesktopViewerPageState extends State<BotDesktopViewerPage> {
  final _text = TextEditingController();
  final _keys = FocusNode(debugLabel: 'bot-desktop-keys');
  ui.Image? _image;
  bool _decoding = false;
  bool _stale = false;
  Timer? _paint;
  int _buttons = 0;

  BotDisplayRfb get _rfb => widget.session.rfb;

  @override
  void initState() {
    super.initState();
    widget.session.addListener(_onSession);
    _rfb.onFrame = _onFrame;
    if (_rfb.frames > 0) _onFrame();
  }

  @override
  void dispose() {
    widget.session.removeListener(_onSession);
    if (_rfb.onFrame == _onFrame) _rfb.onFrame = null;
    _paint?.cancel();
    _image?.dispose();
    _text.dispose();
    _keys.dispose();
    super.dispose();
  }

  void _onSession() {
    if (mounted) setState(() {});
  }

  /// Frames arrive faster than they are worth painting: one decode at a
  /// time, the next no sooner than 60 ms later.
  void _onFrame() {
    if (!mounted) return;
    if (_decoding || _paint != null) {
      _stale = true;
      return;
    }
    _decode();
  }

  void _decode() {
    final width = _rfb.width;
    final height = _rfb.height;
    if (width == 0 || height == 0) return;
    _decoding = true;
    _stale = false;
    ui.decodeImageFromPixels(
      _rfb.framebuffer,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (image) {
        _decoding = false;
        if (!mounted) {
          image.dispose();
          return;
        }
        final previous = _image;
        setState(() => _image = image);
        previous?.dispose();
        _paint = Timer(const Duration(milliseconds: 60), () {
          _paint = null;
          if (_stale && mounted) _decode();
        });
      },
    );
  }

  bool get _live => !widget.session.isClosed && _rfb.isLive;

  void _pointer(PointerEvent event, Size box, {int? buttons}) {
    if (!_live || box.isEmpty) return;
    final x = (event.localPosition.dx / box.width * _rfb.width).floor();
    final y = (event.localPosition.dy / box.height * _rfb.height).floor();
    _rfb.pointer(x, y, buttons ?? _buttons);
  }

  /// Flutter's button bits to RFB's: left 1, middle 2, right 4.
  static int _mask(PointerEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return 1;
    var mask = 0;
    if (event.buttons & kPrimaryMouseButton != 0) mask |= 1;
    if (event.buttons & kMiddleMouseButton != 0) mask |= 2;
    if (event.buttons & kSecondaryMouseButton != 0) mask |= 4;
    return mask;
  }

  static final _special = <LogicalKeyboardKey, int>{
    LogicalKeyboardKey.enter: BotDisplayRfb.keyReturn,
    LogicalKeyboardKey.numpadEnter: BotDisplayRfb.keyReturn,
    LogicalKeyboardKey.backspace: BotDisplayRfb.keyBackspace,
    LogicalKeyboardKey.tab: BotDisplayRfb.keyTab,
    LogicalKeyboardKey.escape: BotDisplayRfb.keyEscape,
    LogicalKeyboardKey.delete: BotDisplayRfb.keyDelete,
    LogicalKeyboardKey.home: 0xff50,
    LogicalKeyboardKey.arrowLeft: 0xff51,
    LogicalKeyboardKey.arrowUp: 0xff52,
    LogicalKeyboardKey.arrowRight: 0xff53,
    LogicalKeyboardKey.arrowDown: 0xff54,
    LogicalKeyboardKey.pageUp: 0xff55,
    LogicalKeyboardKey.pageDown: 0xff56,
    LogicalKeyboardKey.end: 0xff57,
    LogicalKeyboardKey.shiftLeft: 0xffe1,
    LogicalKeyboardKey.shiftRight: 0xffe2,
    LogicalKeyboardKey.controlLeft: 0xffe3,
    LogicalKeyboardKey.controlRight: 0xffe4,
    LogicalKeyboardKey.altLeft: 0xffe9,
    LogicalKeyboardKey.altRight: 0xffea,
    LogicalKeyboardKey.metaLeft: 0xffeb,
    LogicalKeyboardKey.metaRight: 0xffec,
  };

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_live) return KeyEventResult.ignored;
    final special = _special[event.logicalKey];
    if (special != null) {
      _rfb.key(special, down: event is! KeyUpEvent);
      return KeyEventResult.handled;
    }
    final character = event.character;
    if (event is! KeyUpEvent && character != null && character.isNotEmpty) {
      _rfb.typeText(character);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _sendText() {
    if (!_live || _text.text.isEmpty) return;
    _rfb.typeText(_text.text);
    _text.clear();
  }

  String _status() => switch (widget.session.closedBecause) {
    null => context.sharedL10n.ng_bots_viewer_you_control,
    BotDesktopClose.handedBack => context.sharedL10n.ng_bots_viewer_handed_back,
    BotDesktopClose.background => context.sharedL10n.ng_bots_viewer_background,
    BotDesktopClose.controlTaken => context.sharedL10n.ng_bots_viewer_taken,
    BotDesktopClose.viewerLost => context.sharedL10n.ng_bots_viewer_lost,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final closed = widget.session.isClosed;
    final image = _image;
    return Scaffold(
      key: const Key('bots-viewer'),
      appBar: AppBar(
        title: Text(
          context.sharedL10n.ng_bots_viewer_title(widget.botName),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            key: const Key('bots-viewer-hand-back'),
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(
              closed
                  ? context.sharedL10n.close
                  : context.sharedL10n.ng_bots_hand_back,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Material(
              color: closed ? scheme.errorContainer : scheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _status(),
                        key: const Key('bots-viewer-status'),
                        style: TextStyle(
                          color: closed
                              ? scheme.onErrorContainer
                              : scheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: scheme.surfaceContainerHighest,
                child: Center(
                  child: image == null
                      ? const CircularProgressIndicator()
                      : AspectRatio(
                          aspectRatio: image.width / image.height,
                          child: LayoutBuilder(
                            builder: (context, box) {
                              final size = box.biggest;
                              return Focus(
                                focusNode: _keys,
                                autofocus: true,
                                onKeyEvent: _onKey,
                                child: Listener(
                                  key: const Key('bots-viewer-surface'),
                                  behavior: HitTestBehavior.opaque,
                                  onPointerDown: (event) {
                                    _keys.requestFocus();
                                    _buttons = _mask(event);
                                    // A touch has no hover: move first, so
                                    // the press lands where the finger is.
                                    _pointer(event, size, buttons: 0);
                                    _pointer(event, size);
                                  },
                                  onPointerMove: (event) =>
                                      _pointer(event, size),
                                  onPointerHover: (event) =>
                                      _pointer(event, size, buttons: 0),
                                  onPointerUp: (event) {
                                    _buttons = 0;
                                    _pointer(event, size);
                                  },
                                  onPointerCancel: (event) {
                                    _buttons = 0;
                                    _pointer(event, size);
                                  },
                                  onPointerSignal: (event) {
                                    if (event is! PointerScrollEvent) return;
                                    final wheel = event.scrollDelta.dy < 0
                                        ? 8
                                        : 16;
                                    _pointer(event, size, buttons: wheel);
                                    _pointer(event, size, buttons: 0);
                                  },
                                  child: RawImage(
                                    image: image,
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.medium,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('bots-viewer-text'),
                      controller: _text,
                      enabled: !closed,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendText(),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: context.sharedL10n.ng_bots_viewer_type_hint,
                        hintMaxLines: 1,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('bots-viewer-send-text'),
                    tooltip: context.sharedL10n.ng_bots_viewer_type,
                    icon: const Icon(Icons.keyboard_outlined),
                    onPressed: closed ? null : _sendText,
                  ),
                  IconButton(
                    key: const Key('bots-viewer-enter'),
                    tooltip: context.sharedL10n.ng_bots_viewer_enter,
                    icon: const Icon(Icons.keyboard_return),
                    onPressed: closed
                        ? null
                        : () => _rfb.tapKey(BotDisplayRfb.keyReturn),
                  ),
                  IconButton(
                    key: const Key('bots-viewer-backspace'),
                    tooltip: context.sharedL10n.ng_bots_viewer_backspace,
                    icon: const Icon(Icons.backspace_outlined),
                    onPressed: closed
                        ? null
                        : () => _rfb.tapKey(BotDisplayRfb.keyBackspace),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
