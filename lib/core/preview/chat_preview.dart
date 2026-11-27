import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../models/attachment_draft.dart';
import '../services/attachment_draft_service.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/preview_peer.dart';
import '../services/remote_workspace.dart';
import 'preview_evidence.dart';
import 'preview_messages.dart';
import 'reader_canvas.dart';
import 'reader_document.dart';

/// Kept by the originating chat State; never resolve a pending operation via
/// a different current chat, a persisted ID alone or a global controller.
class PreviewSlot {
  RemoteWorkspaceOwner? _owner;
  WorkspaceRoute? _route;
  bool visible = false;
  void open(RemoteWorkspaceOwner owner, String storedId) {
    _owner = owner;
    _route = owner.route(storedSessionId: storedId);
    visible = true;
  }

  void hide() => visible = false;
  void close() {
    hide();
    _owner = null;
    _route = null;
  }

  Widget layout({
    required Widget chat,
    required String? storedId,
    required AttachmentDraftService service,
    required List<AttachmentDraft> existing,
    required CommitPreviewDraft commit,
    required StateSetter update,
  }) {
    final owner = _owner, route = _route;
    final valid =
        owner != null && route != null && route.storedSessionId == storedId;
    return ChatPreviewLayout(
      chat: chat,
      visible: valid && visible,
      preview: !valid
          ? null
          : ChatPreview(
              owner: owner,
              route: route,
              service: service,
              existing: existing,
              visible: visible,
              commit: (text, crops) {
                if (!identical(_route, route) || !visible) {
                  throw const WorkspaceException(WorkspaceFailure.stale);
                }
                commit(text, crops);
              },
              hide: () => update(hide),
              close: () => update(close),
            ),
    );
  }
}

void appendPreviewText(TextEditingController controller, String text) {
  final next = controller.text.isEmpty ? text : '${controller.text}\n\n$text';
  controller.value = TextEditingValue(
    text: next,
    selection: TextSelection.collapsed(offset: next.length),
  );
}

/// An independently mounted page per chat; the narrow overlay does not tear
/// down the composer, and hiding the pane does not recreate its document.
class ChatPreviewLayout extends StatelessWidget {
  const ChatPreviewLayout({
    super.key,
    required this.chat,
    required this.preview,
    required this.visible,
  });
  final Widget chat;
  final Widget? preview;
  final bool visible;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, b) {
      final width = b.maxWidth >= 850
          ? (b.maxWidth * .44).clamp(360.0, 650.0)
          : b.maxWidth;
      return Stack(
        children: [
          Positioned.fill(
            right: visible && width < b.maxWidth ? width : 0,
            child: ExcludeFocus(
              excluding: visible && width == b.maxWidth,
              child: chat,
            ),
          ),
          if (preview != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: width,
              child: Offstage(
                offstage: !visible,
                child: Material(elevation: 4, child: preview),
              ),
            ),
        ],
      );
    },
  );
}

class ChatPreview extends StatefulWidget {
  ChatPreview({
    required this.owner,
    required this.route,
    required this.service,
    required this.existing,
    required this.commit,
    required this.visible,
    required this.hide,
    required this.close,
  }) : super(key: ValueKey(route));
  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final AttachmentDraftService service;
  final List<AttachmentDraft> existing;
  final CommitPreviewDraft commit;
  final bool visible;
  final VoidCallback hide, close;
  @override
  State<ChatPreview> createState() => _ChatPreviewState();
}

class _ChatPreviewState extends State<ChatPreview> {
  late final _pane = widget.owner.pane();
  late final _policy = PreviewPolicy(Uri.parse(widget.owner.expectedBaseUrl));
  late final _loader = ReaderLoad(_policy);
  final _address = TextEditingController();
  final _scroll = ScrollController();
  final _history = <Uri>[];
  final _pins = <PreviewPin>[];
  final _log = PreviewConsoleLog();
  WorkspaceTarget? _target;
  ReaderDocument? _document;
  Timer? _monitor;
  Object? _status;
  int _index = -1, _pin = 0, _revision = 0;
  bool _busy = false, _annotate = false, _console = false;
  VoidCallback? _release;

  @override
  void initState() {
    super.initState();
    ConnectionMutationBarrier.addListener(_revokeStale);
    _monitor = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _revokeStale(),
    );
    _bind();
  }

  void _revokeStale() {
    if (_target?.isCurrent == false) {
      setState(() {
        _clear();
        _status = PreviewNotice.chatChanged;
      });
    }
  }

  void _unshare() {
    _release?.call();
    _release = null;
  }

  void _clear() {
    _revision++;
    _unshare();
    _loader.cancel();
    _pane.invalidate();
    _target = null;
    _history.clear();
    _index = -1;
    _address.clear();
    _document = null;
    _pins.clear();
    _log.clear();
    _busy = false;
    _console = false;
    _annotate = false;
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_revokeStale);
    _monitor?.cancel();
    _unshare();
    _loader.cancel();
    _pane.close();
    _address.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _bind() async {
    final rev = ++_revision;
    setState(() {
      _busy = true;
      _status = PreviewNotice.authenticating;
    });
    try {
      if (widget.route.storedSessionId == null) {
        throw const WorkspaceException(WorkspaceFailure.unbound);
      }
      final target = await _pane.bind(widget.route);
      if (!mounted || _revision != rev) return;
      target.checkCurrent();
      setState(() {
        _target = target;
        _status = null;
      });
    } on WorkspaceException catch (e) {
      if (mounted && _revision == rev) {
        setState(() => _status = e);
      }
    } finally {
      if (mounted && _revision == rev) setState(() => _busy = false);
    }
  }

  void _check(int rev) {
    if (!mounted || rev != _revision || _target == null) {
      throw const WorkspaceException(WorkspaceFailure.stale);
    }
    _target!.checkCurrent();
  }

  void _fail(Object e, int rev) {
    if (!mounted || rev != _revision) return;
    _revokeStale();
    if (rev != _revision) return;
    setState(() => _status = e);
  }

  Future<void> _open(
    String address, {
    int? historyIndex,
    bool typed = false,
  }) async {
    if (_busy || _target == null) return;
    final rev = ++_revision;
    final old = _document;
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final url = _policy.accept(
        address,
        requiredOrigin: typed || historyIndex != null ? null : old?.url.origin,
      );
      if (old?.url.origin != url.origin && historyIndex == null) {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(ctx.sharedL10n.release_preview_open_site_title),
            content: Text(
              ctx.sharedL10n.release_preview_open_site_body(url.origin),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.sharedL10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(ctx.sharedL10n.release_preview_open_site),
              ),
            ],
          ),
        );
        _check(rev);
        if (ok != true) return;
      }
      if (_pins.isNotEmpty && mounted) {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(ctx.sharedL10n.release_preview_discard_pins_title),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.sharedL10n.release_preview_keep_pins),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(ctx.sharedL10n.ng_models_discard),
              ),
            ],
          ),
        );
        _check(rev);
        if (ok != true) return;
      }
      _unshare();
      await _target!.verifySession();
      _check(rev);
      final next = await _loader.load(
        url.toString(),
        approvedOrigin: url.origin,
        check: () => _check(rev),
      );
      await _target!.verifySession();
      _check(rev);
      if (_scroll.hasClients) _scroll.jumpTo(0);
      setState(() {
        if (historyIndex != null) {
          _index = historyIndex;
        } else {
          _history.removeRange(_index + 1, _history.length);
          _history.add(url);
          if (_history.length > 40) _history.removeAt(0);
          _index = _history.length - 1;
        }
        _document = next;
        _address.text = url.toString();
        _pins.clear();
        _pin = 0;
        _annotate = false;
        _status = null;
        _log.addRequest(url.origin, next.blocks.length);
      });
    } catch (e) {
      _fail(e, rev);
    } finally {
      if (mounted && rev == _revision) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    if (_release != null) {
      setState(_unshare);
      return;
    }
    final doc = _document, target = _target;
    if (doc == null || target == null || _busy) return;
    final rev = _revision;
    setState(() => _busy = true);
    try {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(ctx.sharedL10n.release_preview_share_page_title),
          content: Text(
            ctx.sharedL10n.release_preview_share_page_body(doc.url.origin),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.sharedL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(ctx.sharedL10n.release_preview_share_page),
            ),
          ],
        ),
      );
      _check(rev);
      if (accepted != true) return;
      final release = await target.sharePreview((
        action, {
        required start,
        required count,
        required amount,
        required direction,
      }) {
        if (!mounted ||
            _release == null ||
            _document != doc ||
            _busy ||
            !target.isCurrent) {
          return null;
        }
        final text = doc.blocks.map((b) => b.text).join('\n');
        final from = start.clamp(0, text.length),
            end = (start + count).clamp(from, text.length);
        return switch (action) {
          PreviewAction.read => {
            'kind': 'url',
            'title': doc.title,
            'url': doc.url.origin,
            'start': from,
            'end': end,
            'total_chars': text.length,
            'text': text.substring(from, end),
          },
          PreviewAction.elements => {
            'success': true,
            'elements': [
              for (final b in doc.blocks.take(60))
                {
                  'selector': b.selector,
                  'tag': b.tag,
                  'text': b.text.substring(0, b.text.length.clamp(0, 100)),
                },
            ],
          },
          PreviewAction.scroll => _scrollPage(amount, direction),
        };
      });
      if (!mounted || rev != _revision || !target.isCurrent) {
        release();
        return;
      }
      setState(() => _release = release);
    } catch (e) {
      _fail(e, rev);
    } finally {
      if (mounted && rev == _revision) setState(() => _busy = false);
    }
  }

  Map<String, dynamic>? _scrollPage(int amount, String direction) {
    if (!widget.visible ||
        _annotate ||
        _console ||
        _scroll.positions.length != 1 ||
        !['up', 'down', 'top', 'bottom'].contains(direction)) {
      return null;
    }
    final max = _scroll.position.maxScrollExtent;
    final pos = switch (direction) {
      'top' => 0.0,
      'bottom' => max,
      'up' => _scroll.offset - amount.abs(),
      _ => _scroll.offset + amount.abs(),
    };
    _scroll.jumpTo(pos.clamp(0.0, max));
    return {'success': true};
  }

  Future<void> _addPin(Rect rect, String selector, Uint8List crop) async {
    if (_busy || _pins.length >= 10 || !widget.visible) return;
    final rev = _revision;
    String note = '';
    setState(() => _busy = true);
    try {
      final accept = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(ctx.sharedL10n.release_preview_comment_number(_pin + 1)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.memory(crop, height: 90),
                TextField(
                  autofocus: true,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: ctx.sharedL10n.release_preview_note,
                  ),
                  onChanged: (v) => note = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.sharedL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(ctx.sharedL10n.release_preview_keep_pin),
            ),
          ],
        ),
      );
      _check(rev);
      if (accept != true || note.trim().isEmpty) return;
      setState(
        () => _pins.add(PreviewPin(++_pin, rect, selector, note.trim(), crop)),
      );
    } catch (e) {
      _fail(e, rev);
    } finally {
      if (mounted && rev == _revision) setState(() => _busy = false);
    }
  }

  Future<void> _stage(String prompt, List<PreviewPin> pins) async {
    if (_busy || !widget.visible) return;
    final rev = _revision;
    setState(() => _busy = true);
    try {
      await _target!.verifySession();
      _check(rev);
      await stagePreviewEvidence(
        prompt: prompt,
        pins: pins,
        service: widget.service,
        existing: widget.existing,
        check: () => _check(rev),
        commit: widget.commit,
      );
      _check(rev);
      setState(() {
        if (pins.isNotEmpty) _pins.clear();
        _status = PreviewNotice.addedToDraft;
      });
      widget.hide();
    } catch (e) {
      _fail(e, rev);
    } finally {
      if (mounted && rev == _revision) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final doc = _document;
    Widget tool(String label, IconData icon, VoidCallback? action) =>
        IconButton(tooltip: label, onPressed: action, icon: Icon(icon));
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.release_preview_title)),
              tool(
                l10n.release_preview_hide,
                Icons.visibility_off_outlined,
                widget.hide,
              ),
              tool(
                l10n.release_preview_close_and_forget,
                Icons.close,
                widget.close,
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _address,
                  key: const Key('preview-address'),
                  enabled: !_busy && _target != null,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: l10n.release_preview_site_address,
                  ),
                  onSubmitted: (v) => _open(v, typed: true),
                ),
              ),
              tool(
                l10n.release_preview_go_to_address,
                Icons.arrow_forward,
                _busy || _target == null
                    ? null
                    : () => _open(_address.text, typed: true),
              ),
            ],
          ),
          if (doc != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  tool(
                    MaterialLocalizations.of(context).backButtonTooltip,
                    Icons.arrow_back,
                    _busy || _index < 1
                        ? null
                        : () => _open(
                            _history[_index - 1].toString(),
                            historyIndex: _index - 1,
                          ),
                  ),
                  tool(
                    l10n.release_preview_forward,
                    Icons.arrow_forward,
                    _busy || _index + 1 >= _history.length
                        ? null
                        : () => _open(
                            _history[_index + 1].toString(),
                            historyIndex: _index + 1,
                          ),
                  ),
                  tool(
                    l10n.release_preview_reload,
                    Icons.refresh,
                    _busy
                        ? null
                        : () => _open(doc.url.toString(), historyIndex: _index),
                  ),
                  tool(
                    _release == null
                        ? l10n.release_preview_share_with_hermes
                        : l10n.release_preview_stop_sharing,
                    _release == null
                        ? Icons.visibility_outlined
                        : Icons.visibility,
                    _busy ? null : _share,
                  ),
                  tool(
                    l10n.release_preview_annotate,
                    _annotate ? Icons.edit : Icons.edit_outlined,
                    _busy
                        ? null
                        : () => setState(() {
                            _annotate = !_annotate;
                            _console = false;
                          }),
                  ),
                  tool(
                    l10n.release_preview_reader_console,
                    Icons.terminal,
                    _busy ? null : () => setState(() => _console = !_console),
                  ),
                ],
              ),
            ),
          if (_busy) const LinearProgressIndicator(),
          if (_status != null) Text(previewNoticeText(l10n, _status!)),
          if (!_busy && _target == null)
            TextButton(
              onPressed: _bind,
              child: Text(l10n.release_preview_reconnect),
            ),
          if (doc == null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.release_preview_reader_mode_help),
                ),
              ),
            )
          else ...[
            if (_release != null)
              Text(l10n.release_preview_sharing_origin(doc.url.origin)),
            if (_annotate && !_console)
              Text(l10n.release_preview_annotation_help),
            Expanded(
              child: _console
                  ? Column(
                      children: [
                        Text(
                          _log.selected.isEmpty
                              ? l10n.release_preview_reader_requests
                              : l10n.release_preview_selected_requests(
                                  _log.selected.length,
                                ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              for (final line in _log.lines)
                                ListTile(
                                  key: ValueKey('preview-log-${line.id}'),
                                  selected: _log.selected.contains(line.id),
                                  onTap: () =>
                                      setState(() => _log.toggle(line.id)),
                                  title: Text(_log.lineText(line, l10n)),
                                ),
                            ],
                          ),
                        ),
                        Wrap(
                          children: [
                            TextButton(
                              onPressed: _log.isEmpty
                                  ? null
                                  : () => Clipboard.setData(
                                      ClipboardData(
                                        text: _log
                                            .export(l10n: l10n)
                                            .join('\n'),
                                      ),
                                    ),
                              child: Text(
                                _log.selected.isEmpty
                                    ? l10n.release_preview_copy_all
                                    : l10n.release_preview_copy_selected,
                              ),
                            ),
                            TextButton(
                              onPressed: _log.isEmpty
                                  ? null
                                  : () => setState(_log.clear),
                              child: Text(l10n.ng_clear),
                            ),
                            TextButton(
                              onPressed: _busy || _log.isEmpty
                                  ? null
                                  : () => _stage(
                                      l10n.release_preview_requests_draft(
                                        _log.export(l10n: l10n).join('\n'),
                                      ),
                                      const [],
                                    ),
                              child: Text(
                                l10n.release_preview_add_log_to_draft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : ReaderCanvas(
                      document: doc,
                      annotate: _annotate && !_busy,
                      pins: _pins,
                      scroll: _scroll,
                      onLink: (url) => _open(url.toString()),
                      onCrop: _addPin,
                      onError: () => _fail(
                        const PreviewError(PreviewFailure.capture),
                        _revision,
                      ),
                    ),
            ),
            if (_pins.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilledButton(
                      onPressed: _busy
                          ? null
                          : () => _stage(
                              annotationPrompt(
                                doc.url.origin,
                                _pins,
                                introduction:
                                    l10n.release_preview_annotation_intro,
                              ),
                              List.of(_pins),
                            ),
                      child: Text(
                        l10n.release_preview_add_pins_to_draft(_pins.length),
                      ),
                    ),
                    for (final p in _pins)
                      InputChip(
                        label: Text(
                          l10n.rel_chat_preview_pin_label(p.number, p.note),
                          overflow: TextOverflow.ellipsis,
                        ),
                        onDeleted: _busy
                            ? null
                            : () => setState(() => _pins.remove(p)),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// A retained row with typed metadata for client-authored reader log copy.
typedef PreviewConsoleLine = ({
  int id,
  String text,
  ({String origin, int count})? request,
});

class PreviewConsoleLog {
  final lines = <PreviewConsoleLine>[];
  final selected = <int>{};
  var _next = 0;

  bool get isEmpty => lines.isEmpty;
  int get length => lines.length;

  void add(String text) => _add(text, null);

  void addRequest(String origin, int count) =>
      _add('HTTP 200 · $origin · $count', (origin: origin, count: count));

  void _add(String text, ({String origin, int count})? request) {
    lines.add((id: _next++, text: text, request: request));
    if (lines.length > 50) {
      selected.remove(lines.first.id);
      lines.removeAt(0);
    }
  }

  void toggle(int id) {
    if (!selected.remove(id)) selected.add(id);
  }

  void clear() {
    lines.clear();
    selected.clear();
  }

  String lineText(PreviewConsoleLine line, AppLocalizations l10n) {
    final request = line.request;
    return request == null
        ? line.text
        : l10n.release_preview_request_loaded(request.origin, request.count);
  }

  List<String> export({AppLocalizations? l10n}) {
    String text(PreviewConsoleLine line) =>
        l10n == null ? line.text : lineText(line, l10n);
    final picked = [
      for (final line in lines)
        if (selected.contains(line.id)) text(line),
    ];
    if (picked.isNotEmpty) return picked;
    return [for (final line in lines) text(line)];
  }
}
