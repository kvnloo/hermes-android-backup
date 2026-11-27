import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xterm/xterm.dart';

import '../l10n/l10n.dart';
import '../services/device_terminal.dart';
import '../services/remote_workspace.dart' as remote;
import 'ssh_terminal_dialog.dart';
import 'terminal_chat_link.dart';
import 'workspace_registry.dart';

Widget buildTerminalPage(BuildContext context, WorkspaceTarget target) =>
    TerminalPage(target: target);

class _ReviewPasteIntent extends Intent {
  const _ReviewPasteIntent();
}

/// xterm's [Terminal.paste] writes straight to the shell. Hold that write
/// until the page has shown the paste and the user has confirmed it.
class _ReviewedTerminal extends Terminal {
  _ReviewedTerminal() : super(maxLines: 2000);

  void Function(String text)? onUnreviewedPaste;
  bool _committing = false;

  @override
  void paste(String text) {
    if (_committing) {
      super.paste(text);
      return;
    }
    onUnreviewedPaste?.call(text);
  }

  void commitPaste(String text) {
    _committing = true;
    try {
      super.paste(text);
    } finally {
      _committing = false;
    }
  }
}

/// Replace every platform paste chord xterm binds. Copy and select-all stay.
Map<ShortcutActivator, Intent> _reviewedShortcuts() {
  final shortcuts = Map<ShortcutActivator, Intent>.of(defaultTerminalShortcuts);
  const review = _ReviewPasteIntent();
  for (final key in shortcuts.keys.toList()) {
    if (shortcuts[key] is PasteTextIntent) shortcuts[key] = review;
  }
  return shortcuts;
}

class TerminalPage extends StatefulWidget {
  const TerminalPage({required this.target, super.key});
  final WorkspaceTarget target;
  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _Tab {
  _Tab(this.label, this.source, {this.process});
  final String Function(BuildContext context) label;
  final TerminalChatAttachment? source;
  final String? process;
  final emulator = _ReviewedTerminal();
  final selection = TerminalController();
  DeviceTerminal? device;
  remote.GatewayTerminal? gateway;
  remote.WorkspacePane? pane;
  StreamSubscription<String>? subscription;
  String Function(BuildContext context) status = (context) =>
      context.sharedL10n.rel_ops_term_connecting;
  bool live = false, feeding = false;
  void feed(String s) {
    feeding = true;
    try {
      emulator.write(s);
    } finally {
      feeding = false;
    }
  }

  String get selected => selection.selection == null
      ? ''
      : emulator.buffer.getText(selection.selection);
  void dispose() {
    subscription?.cancel();
    device?.close().ignore();
    gateway?.dispose();
    pane?.close();
    selection.dispose();
  }
}

class _TerminalPageState extends State<TerminalPage> {
  final tabs = <_Tab>[];
  final dismissed = <String>{};
  _Tab? active;
  String Function(BuildContext context)? message;
  bool busy = false;
  int serial = 0;
  remote.WorkspacePane? monitorPane;
  void Function()? stopMonitoring;
  bool get current => mounted && widget.target.current();
  TerminalChatAttachment? get source => widget.target.chatLink?.attachment;
  String get gatewayLabel =>
      Uri.tryParse(source?.owner?.expectedBaseUrl ?? '')?.authority ?? '';
  void check(_Tab tab) {
    if (!current ||
        !tabs.contains(tab) ||
        (tab.source != null &&
            (!identical(tab.source, source) || !tab.source!.current()))) {
      throw const remote.WorkspaceException(remote.WorkspaceFailure.stale);
    }
  }

  void show(String Function(BuildContext context) text) {
    if (current) setState(() => message = text);
  }

  String failureReason(BuildContext context, remote.WorkspaceFailure reason) =>
      switch (reason) {
        remote.WorkspaceFailure.stale =>
          context.sharedL10n.rel_ops_term_reason_stale,
        remote.WorkspaceFailure.mismatch =>
          context.sharedL10n.rel_ops_term_reason_mismatch,
        remote.WorkspaceFailure.unbound =>
          context.sharedL10n.rel_ops_term_reason_unbound,
        remote.WorkspaceFailure.unsupported =>
          context.sharedL10n.rel_ops_term_reason_unsupported,
        remote.WorkspaceFailure.denied =>
          context.sharedL10n.rel_ops_term_reason_denied,
        remote.WorkspaceFailure.ineligible =>
          context.sharedL10n.rel_ops_term_reason_ineligible,
        remote.WorkspaceFailure.unavailable =>
          context.sharedL10n.rel_ops_term_reason_unavailable,
        remote.WorkspaceFailure.invalid =>
          context.sharedL10n.rel_ops_term_reason_invalid,
        remote.WorkspaceFailure.insecure =>
          context.sharedL10n.rel_ops_term_reason_insecure,
      };

  Future<void> run(Future<void> Function() task) async {
    if (busy || !current) return;
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await task();
    } catch (e) {
      show(
        (context) => switch (e) {
          remote.WorkspaceException(reason: remote.WorkspaceFailure.unbound) =>
            context.sharedL10n.rel_ops_term_unbound,
          remote.WorkspaceException(
            reason: remote.WorkspaceFailure.unsupported,
          ) =>
            context.sharedL10n.rel_ops_term_unsupported,
          remote.WorkspaceException() =>
            context.sharedL10n.rel_ops_term_refused(
              failureReason(context, e.reason),
            ),
          UnsupportedError() =>
            context.sharedL10n.rel_ops_term_local_pty_unavailable,
          _ => context.sharedL10n.rel_ops_term_operation_failed,
        },
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  _Tab add(String Function(BuildContext context) label, {String? process}) {
    if (tabs.length >= 12) throw StateError('Tab limit');
    final tab = _Tab(label, source, process: process);
    tab.emulator.onOutput = (s) {
      if (!tab.live || tab.feeding || process != null) return;
      try {
        check(tab);
        tab.device?.write(s);
        tab.gateway?.write(s);
      } catch (_) {
        show((context) => context.sharedL10n.rel_ops_term_input_refused);
      }
    };
    tab.emulator.onResize = (cols, rows, _, _) {
      if (!tab.live || process != null) return;
      try {
        check(tab);
        tab.device?.resize(cols, rows);
        tab.gateway?.resize(cols, rows);
      } catch (_) {
        /* stale: resize cannot be redirected */
      }
    };
    tab.emulator.onUnreviewedPaste = (text) {
      unawaited(run(() => paste(tab, text)));
    };
    setState(() {
      tabs.add(tab);
      active = tab;
    });
    return tab;
  }

  void remove(_Tab t) {
    if (!mounted || !tabs.contains(t)) return;
    setState(() {
      tabs.remove(t);
      if (active == t) active = tabs.lastOrNull;
    });
    t.dispose();
  }

  Future<bool> confirm(String title, String body) async =>
      await showDialog<bool>(
        context: context,
        useRootNavigator: false,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.sharedL10n.rel_ops_term_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.sharedL10n.rel_ops_term_confirm),
            ),
          ],
        ),
      ) ==
      true;
  Future<void> startDevice(bool ssh) async {
    final origin = widget.target;
    final login = ssh
        ? await showDialog<SshLogin>(
            context: context,
            useRootNavigator: false,
            builder: (_) => const SshTerminalDialog(),
          )
        : null;
    if (!mounted || !current || !origin.current()) return;
    if (ssh && login == null) return;
    if (!ssh &&
        !await confirm(
          context.sharedL10n.rel_ops_term_open_device_title,
          context.sharedL10n.rel_ops_term_open_device_body(
            origin.connection.label,
          ),
        )) {
      return;
    }
    if (!current || !origin.current()) return;
    final number = ++serial;
    final t = add(
      (context) => ssh
          ? context.sharedL10n.rel_ops_term_ssh_tab(
              login!.user,
              login.host,
              login.port,
              number,
            )
          : context.sharedL10n.rel_ops_term_device_tab(number),
    );
    try {
      final dev = ssh
          ? await VerifiedSshTerminal.open(
              host: login!.host,
              port: login.port,
              user: login.user,
              fingerprint: login.pin,
              password: login.password,
              check: () => check(t),
            )
          : await LocalTerminal.start(check: () => check(t));
      t.device = dev;
      try {
        check(t);
      } catch (_) {
        await dev.close();
        rethrow;
      }
      t.live = true;
      t.status = (context) => ssh
          ? context.sharedL10n.rel_ops_term_ssh_shell
          : context.sharedL10n.rel_ops_term_local_shell;
      t.subscription = dev.output
          .transform(const Utf8Decoder(allowMalformed: true))
          .listen(
            (s) {
              if (current && tabs.contains(t)) t.feed(s);
            },
            onError: (Object _) => ended(
              t,
              (context) => context.sharedL10n.rel_ops_term_connection_lost,
            ),
            onDone: () => ended(
              t,
              (context) => context.sharedL10n.rel_ops_term_shell_ended,
            ),
          );
      dev.resize(t.emulator.viewWidth, t.emulator.viewHeight);
    } catch (_) {
      remove(t);
      rethrow;
    }
  }

  void ended(_Tab t, String Function(BuildContext context) why) {
    if (current && tabs.contains(t)) {
      setState(() {
        t.live = false;
        t.status = why;
      });
    }
  }

  Future<void> startGateway() async {
    final origin = widget.target, chat = source, owner = source?.owner;
    if (owner == null || chat == null || !chat.current()) {
      show((context) => context.sharedL10n.rel_ops_term_no_owner);
      return;
    }
    final route = owner.route(storedSessionId: origin.session!.id);
    if (!await confirm(
      context.sharedL10n.rel_ops_term_open_gateway_title,
      context.sharedL10n.rel_ops_term_open_gateway_body(gatewayLabel),
    )) {
      return;
    }
    if (!current || !origin.current() || !chat.current()) return;
    final host = gatewayLabel;
    final number = ++serial;
    final t = add(
      (context) => context.sharedL10n.rel_ops_term_gateway_tab(host, number),
    );
    try {
      final p = t.pane = owner.pane();
      final target = await p.bind(route);
      check(t);
      t.gateway = target.terminal(checkPane: () => check(t));
      await connect(t);
    } catch (_) {
      if (t.gateway?.retained != true) remove(t);
      rethrow;
    }
  }

  Future<void> connect(_Tab t) async {
    check(t);
    // The replay callback may outlive this widget; capture its display copy.
    final trimmedNotice =
        context.sharedL10n.rel_ops_term_earlier_output_trimmed;
    await t.gateway!.connect(
      output: t.feed,
      reset: (trimmed) {
        t.selection.clearSelection();
        t.feed('\x1bc${trimmed ? '$trimmedNotice\r\n' : ''}');
      },
      disconnected: (code) => ended(
        t,
        (context) => code == 4410
            ? context.sharedL10n.rel_ops_term_shell_expired
            : context.sharedL10n.rel_ops_term_disconnected,
      ),
    );
    check(t);
    setState(() {
      t.live = true;
      t.status = (context) => context.sharedL10n.rel_ops_term_gateway_shell;
    });
    // A trimmed replay can begin inside a full-screen program. Step one row
    // away and back so that program sees a size change, matching the host.
    final cols = t.emulator.viewWidth;
    final rows = t.emulator.viewHeight;
    if (t.gateway!.replayTrimmed) {
      t.gateway!.resize(cols, rows > 2 ? rows - 1 : rows + 1);
    }
    t.gateway!.resize(cols, rows);
  }

  Future<void> closeTab(_Tab t) async {
    if (t.process == null &&
        (t.live || t.gateway?.retained == true) &&
        !await confirm(
          context.sharedL10n.rel_ops_term_close_tab_title(t.label(context)),
          context.sharedL10n.rel_ops_term_close_body,
        )) {
      return;
    }
    // The user owns this shell. Closing it must not depend on the originating
    // chat still being open. New input still goes through check().
    if (t.process != null) dismissed.add(t.process!);
    if (t.gateway?.retained == true) {
      ended(t, (context) => context.sharedL10n.rel_ops_term_closing);
      try {
        await t.gateway!.closeShell(requirePane: false);
      } catch (_) {
        ended(
          t,
          (context) => context.sharedL10n.rel_ops_term_close_unconfirmed,
        );
        rethrow;
      }
    }
    remove(t);
  }

  Future<void> monitors() async {
    final chat = source, owner = source?.owner;
    if (chat == null || owner == null || !chat.current()) {
      show((context) => context.sharedL10n.rel_ops_term_processes_require_chat);
      return;
    }
    stopMonitoring?.call();
    monitorPane?.close();
    dismissed.clear();
    final pane = monitorPane = owner.pane(),
        target = await pane.bind(
          owner.route(storedSessionId: widget.target.session!.id),
        );
    bool valid() =>
        current &&
        chat.current() &&
        target.isCurrent &&
        identical(pane, monitorPane);
    if (!valid()) return;
    _Tab? mirror(String id) => tabs.where((t) => t.process == id).firstOrNull;
    _Tab? ensure(String id) {
      if (dismissed.contains(id)) return null;
      return mirror(id) ??
          (tabs.length < 12
              ? add((context) => '$gatewayLabel · $id', process: id)
              : null);
    }

    void change(remote.ProcessChange e) {
      if (!valid()) return;
      final t = mirror(e.id);
      if (e.chunk == null) {
        if (t != null) remove(t);
        return;
      }
      ensure(e.id)?.feed(e.chunk!);
    }

    // Subscribe first; a snapshot can already include some of the buffered
    // chunks. Reconcile the snapshot's suffix once, never all later output.
    var waiting = true;
    final pending = <remote.ProcessChange>[];
    int buffered = 0;
    bool overflow = false;
    final stop = stopMonitoring = target.watchProcesses((e) {
      if (!valid()) return;
      if (waiting) {
        buffered += (e.chunk?.length ?? 0) + 64;
        if (buffered <= 131072) {
          pending.add(e);
        } else {
          overflow = true;
        }
      } else {
        change(e);
      }
    });
    try {
      final rows = await target.processSnapshot();
      if (!valid()) return;
      if (overflow) {
        throw const remote.WorkspaceException(
          remote.WorkspaceFailure.unavailable,
        );
      }
      for (final old in tabs.where((t) => t.process != null).toList()) {
        remove(old);
      }
      for (final r in rows) {
        final t = ensure(r.id);
        if (t != null) {
          t.status = (context) =>
              context.sharedL10n.rel_ops_term_read_only_status(r.status);
          t.feed(r.tail);
        }
      }
      waiting = false;
      for (final id in pending.map((e) => e.id).toSet()) {
        final events = pending.where((e) => e.id == id).toList();
        if (events.any((e) => e.chunk == null)) {
          for (final e in events) {
            change(e);
          }
          continue;
        }
        final arrived = events.map((e) => e.chunk!).join();
        final snapshot = rows.where((r) => r.id == id).firstOrNull?.tail ?? '';
        int overlap = arrived.length.clamp(0, snapshot.length);
        while (overlap > 0 &&
            !snapshot.endsWith(arrived.substring(0, overlap))) {
          overlap--;
        }
        change((id: id, chunk: arrived.substring(overlap)));
      }
      show((context) => context.sharedL10n.rel_ops_term_watching_processes);
    } catch (_) {
      stop();
      rethrow;
    }
  }

  @override
  void dispose() {
    stopMonitoring?.call();
    monitorPane?.close();
    for (final t in tabs) {
      final gateway = t.gateway;
      // Closing the workspace tab ends a retained host shell. Hiding the
      // pane never reaches dispose, so that shell keeps its connection.
      if (gateway != null && gateway.retained) {
        unawaited(
          gateway.closeShell(requirePane: false).whenComplete(() {
            gateway.dispose();
          }),
        );
        t.gateway = null;
      }
      t.dispose();
    }
    super.dispose();
  }

  Future<void> paste(_Tab t, String text) async {
    if (text.isEmpty || !t.live || t.process != null) return;
    // A paste may contain a newline/escape that executes immediately. Never
    // stream a platform paste/drop to stdin without reviewing the payload.
    if (text.length > 16384) {
      show((context) => context.sharedL10n.rel_ops_term_paste_limit);
      return;
    }
    if (!await confirm(
      context.sharedL10n.rel_ops_term_paste_title(t.label(context)),
      text,
    )) {
      return;
    }
    check(t);
    if (identical(active, t) && t.live) t.emulator.commitPaste(text);
  }

  Future<void> pasteClipboard(_Tab t) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (current && data?.text != null) await paste(t, data!.text!);
  }

  Future<void> pasteMenu(_Tab t, TapUpDetails details) async {
    if (!current || !t.live || t.process != null) return;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          details.globalPosition.dx,
          details.globalPosition.dy,
          0,
          0,
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 'paste',
          child: Text(context.sharedL10n.rel_ops_term_paste),
        ),
      ],
    );
    if (selected == 'paste' && current) await run(() => pasteClipboard(t));
  }

  void insert(_Tab t, String text) {
    check(t);
    if (text.isEmpty) {
      show((context) => context.sharedL10n.rel_ops_term_select_first);
      return;
    }
    final chat = t.source;
    if (chat == null || !chat.current()) {
      show((context) => context.sharedL10n.rel_ops_term_open_chat_to_insert);
      return;
    }
    chat.insert(text);
    show((context) => context.sharedL10n.rel_ops_term_added_to_draft);
  }

  Future<void> selectOutput(_Tab t) async {
    final text = t.emulator.buffer.getText();
    String selected = '';
    final selection = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          context.sharedL10n.rel_ops_term_output_title(t.label(context)),
        ),
        content: SizedBox(
          width: 540,
          child: SingleChildScrollView(
            child: SelectableText(
              text,
              onSelectionChanged: (s, _) =>
                  selected = s.isValid ? s.textInside(text) : '',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.sharedL10n.rel_ops_term_close),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, selected),
            child: Text(context.sharedL10n.rel_ops_term_add_selection),
          ),
        ],
      ),
    );
    if (current && selection != null) insert(t, selection);
  }

  @override
  Widget build(BuildContext context) {
    final t = active;
    Widget action(String label, IconData icon, Future<void> Function() cb) =>
        IconButton(
          tooltip: label,
          icon: Icon(icon),
          onPressed: busy ? null : () => run(cb),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          children: [
            PopupMenuButton<String>(
              tooltip: context.sharedL10n.rel_ops_term_new_terminal,
              enabled: !busy && tabs.length < 12,
              icon: const Icon(Icons.add),
              onSelected: (v) => run(
                v == 'gateway' ? startGateway : () => startDevice(v == 'ssh'),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'gateway',
                  child: Text(context.sharedL10n.rel_ops_term_gateway_terminal),
                ),
                PopupMenuItem(
                  value: 'ssh',
                  child: Text(
                    context.sharedL10n.rel_ops_term_verified_ssh_terminal,
                  ),
                ),
                PopupMenuItem(
                  value: 'local',
                  enabled: LocalTerminal.supported,
                  child: Text(
                    LocalTerminal.supported
                        ? context.sharedL10n.rel_ops_term_device_local_shell
                        : context
                              .sharedL10n
                              .rel_ops_term_local_unavailable_mobile,
                  ),
                ),
              ],
            ),
            action(
              context.sharedL10n.rel_ops_term_watch_processes,
              Icons.monitor_heart_outlined,
              monitors,
            ),
            if (t != null) ...[
              action(
                context.sharedL10n.rel_ops_term_select_output,
                Icons.select_all,
                () => selectOutput(t),
              ),
              action(
                context.sharedL10n.rel_ops_term_add_selected_output,
                Icons.note_add_outlined,
                () async => insert(t, t.selected),
              ),
              if (t.live && t.process == null)
                action(
                  context.sharedL10n.rel_ops_term_review_paste,
                  Icons.content_paste,
                  () => pasteClipboard(t),
                ),
              if (!t.live && t.gateway?.retained == true)
                action(
                  context.sharedL10n.rel_ops_term_reconnect,
                  Icons.refresh,
                  () => connect(t),
                ),
              action(
                t.process != null
                    ? context.sharedL10n.rel_ops_term_close_mirror
                    : context.sharedL10n.rel_ops_term_close_shell,
                Icons.close,
                () => closeTab(t),
              ),
            ],
          ],
        ),
        if (tabs.isNotEmpty)
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final tab in tabs)
                  ChoiceChip(
                    selected: tab == t,
                    label: Text(tab.label(context)),
                    onSelected: (_) => setState(() => active = tab),
                  ),
              ],
            ),
          ),
        if (message != null)
          Text(message!(context), maxLines: 4, overflow: TextOverflow.ellipsis),
        if (busy) const LinearProgressIndicator(),
        if (t == null)
          Expanded(
            child: Center(child: Text(context.sharedL10n.rel_ops_term_empty)),
          )
        else ...[
          Text(
            t.process != null
                ? context.sharedL10n.rel_ops_term_mirror_status(
                    t.label(context),
                  )
                : context.sharedL10n.rel_ops_term_status_label(
                    t.status(context),
                    t.label(context),
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: DragTarget<String>(
              onAcceptWithDetails: (d) => run(() => paste(t, d.data)),
              builder: (context, _, _) => Actions(
                actions: <Type, Action<Intent>>{
                  _ReviewPasteIntent: CallbackAction<Intent>(
                    onInvoke: (_) {
                      unawaited(run(() => pasteClipboard(t)));
                      return null;
                    },
                  ),
                },
                child: TerminalView(
                  t.emulator,
                  key: ObjectKey(t),
                  controller: t.selection,
                  readOnly: t.process != null || !t.live,
                  autofocus: false,
                  shortcuts: _reviewedShortcuts(),
                  onSecondaryTapUp: (details, _) {
                    unawaited(pasteMenu(t, details));
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
