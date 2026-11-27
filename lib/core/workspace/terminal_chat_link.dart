import 'package:flutter/widgets.dart';

import '../models/connection.dart';
import '../services/remote_workspace.dart';

/// Scoped to one mounted chat in one parallel workspace. No draft queue,
/// global selection, persisted shell handle, or delivery after tab closure.
class TerminalChatLink {
  TerminalChatLink(this.connection, this.sessionId);
  final SavedConnection connection;
  final String sessionId;
  TerminalChatAttachment? attachment;
}

class TerminalChatAttachment {
  TerminalChatAttachment(this.owner, this.insert, this.current);
  final RemoteWorkspaceOwner? owner;
  final void Function(String text) insert;
  final bool Function() current;
}

class TerminalChatSlot extends InheritedWidget {
  const TerminalChatSlot({required this.link, required super.child, super.key});
  final TerminalChatLink link;
  @override
  bool updateShouldNotify(TerminalChatSlot oldWidget) => oldWidget.link != link;
}

/// Attach only the chat actually rendering the terminal's originating row.
/// Persisted layouts can restore a tools page without restoring its chat.
mixin TerminalComposerAttachment<T extends StatefulWidget> on State<T> {
  TerminalChatLink? _link;
  TerminalChatAttachment? _attachment;
  SavedConnection get terminalConnection;
  String? get terminalSession;
  RemoteWorkspaceOwner? get terminalOwner;
  TextEditingController get terminalComposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attach();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _attach();
  }

  void _attach() {
    final slot = context
        .dependOnInheritedWidgetOfExactType<TerminalChatSlot>()
        ?.link;
    final link =
        slot?.sessionId == terminalSession &&
            identical(slot?.connection, terminalConnection)
        ? slot
        : null;
    if (identical(_link, link) &&
        identical(_attachment?.owner, terminalOwner)) {
      return;
    }
    _release();
    if (link == null) return;
    final owner = terminalOwner;
    bool current() =>
        mounted &&
        identical(_link, link) &&
        identical(link.attachment, _attachment) &&
        identical(terminalConnection, link.connection) &&
        terminalSession == link.sessionId &&
        identical(owner, terminalOwner);
    _link = link;
    _attachment = link.attachment = TerminalChatAttachment(owner, (text) {
      if (!current() || text.isEmpty) return;
      final previous = terminalComposer.text;
      final draft = previous.isEmpty ? text : '$previous\n$text';
      terminalComposer.value = TextEditingValue(
        text: draft,
        selection: TextSelection.collapsed(offset: draft.length),
      );
    }, current);
  }

  void _release() {
    if (identical(_link?.attachment, _attachment)) _link?.attachment = null;
    _link = null;
    _attachment = null;
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }
}
