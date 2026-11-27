/// The quick-entry child window: entry point and panel.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../workspace/popout_protocol.dart' show watchPopoutPipe;
import 'desktop_os.dart';
import 'quick_entry.dart';

/// Entry point for a process started with [quickEntryMarker]. Other modes
/// never open the pipe. The window exits when the primary closes the pipe,
/// after a hand-back, or on Cancel / Escape.
void runQuickEntryChild(List<String> args) {
  if (args.length != 1 ||
      args.single != quickEntryMarker ||
      !isDesktopOs ||
      stdioType(stdin) != StdioType.pipe) {
    exit(1);
  }
  final timeout = Timer(const Duration(seconds: 45), () => exit(1));
  runApp(const SizedBox.shrink());
  unawaited(
    watchPopoutPipe(
      stdin,
      onLaunch: (frame) {
        try {
          final launch = QuickEntryLaunch.decode(frame);
          timeout.cancel();
          runApp(
            QuickEntryApp(
              launch: launch,
              onSubmit: (prefill) async {
                stdout.writeln(prefill.encode());
                await stdout.flush();
                exit(0);
              },
              onCancel: () => exit(0),
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            stdout.writeln(quickEntryReady);
          });
        } catch (_) {
          stdout.writeln(quickEntryFailed);
          unawaited(stdout.flush().whenComplete(() => exit(1)));
        }
      },
      // EOF: the primary closed the window or exited.
      onRevoked: () => exit(0),
    ),
  );
}

class QuickEntryApp extends StatelessWidget {
  const QuickEntryApp({
    required this.launch,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  final QuickEntryLaunch launch;
  final ValueChanged<QuickEntryPrefill> onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final parts = launch.locale.split(RegExp('[_-]'));
    final locale = Locale(parts.first, parts.length > 1 ? parts[1] : null);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ares',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: preferredSupportedLocales(),
      locale: AppLocalizations.delegate.isSupported(locale) ? locale : null,
      home: Scaffold(
        body: QuickEntryPanel(
          chats: launch.chats,
          onSubmit: onSubmit,
          onCancel: onCancel,
        ),
      ),
    );
  }
}

/// The composer row and target picker. Pressing Enter or the button hands
/// the text back for the main window's composer; it never sends.
class QuickEntryPanel extends StatefulWidget {
  const QuickEntryPanel({
    required this.chats,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  final List<QuickEntryChat> chats;
  final ValueChanged<QuickEntryPrefill> onSubmit;
  final VoidCallback onCancel;

  @override
  State<QuickEntryPanel> createState() => _QuickEntryPanelState();
}

class _QuickEntryPanelState extends State<QuickEntryPanel> {
  final _text = TextEditingController();
  final _focus = FocusNode();
  String? _target; // null: a new chat
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final text = _text.text.trim();
    return !_done && text.isNotEmpty && text.length <= quickEntryMaxText;
  }

  void _submit() {
    if (!_canSubmit) return;
    _done = true;
    widget.onSubmit(
      QuickEntryPrefill(text: _text.text.trim(), sessionId: _target),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final theme = Theme.of(context);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): widget.onCancel,
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CallbackShortcuts(
                bindings: {
                  // Enter hands the text back; Shift+Enter is a new line.
                  const SingleActivator(LogicalKeyboardKey.enter): _submit,
                  const SingleActivator(LogicalKeyboardKey.numpadEnter):
                      _submit,
                },
                child: TextField(
                  key: const Key('quick-entry-text'),
                  controller: _text,
                  focusNode: _focus,
                  autofocus: true,
                  expands: true,
                  maxLines: null,
                  maxLength: quickEntryMaxText,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: l.quick_entry_hint,
                    border: const OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String?>(
                    key: const Key('quick-entry-target'),
                    isExpanded: true,
                    value: _target,
                    underline: const SizedBox.shrink(),
                    onChanged: (value) => setState(() => _target = value),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l.desktop_tray_new_chat),
                      ),
                      for (final chat in widget.chats)
                        DropdownMenuItem<String?>(
                          value: chat.id,
                          child: Text(
                            chat.title.isEmpty ? chat.id : chat.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  key: const Key('quick-entry-cancel'),
                  onPressed: widget.onCancel,
                  child: Text(l.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('quick-entry-submit'),
                  onPressed: _canSubmit ? _submit : null,
                  child: Text(l.quick_entry_submit),
                ),
              ],
            ),
            Text(
              l.quick_entry_never_sends,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
