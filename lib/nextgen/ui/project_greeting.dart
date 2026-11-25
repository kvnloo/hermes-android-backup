// Kyllene-style pending-chat place picker; no remote mutation until first send.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models/hermes_project.dart';
import '../data/chat_controller.dart';
import '../data/nextgen_projects.dart';
import '../nextgen_l10n.dart';
import '../theme/nextgen_theme.dart';
import 'nextgen_scope.dart';

class NgProjectGreeting extends StatefulWidget {
  const NgProjectGreeting({super.key, required this.chat});
  final NgChatController chat;

  @override
  State<NgProjectGreeting> createState() => _NgProjectGreetingState();
}

class _NgProjectGreetingState extends State<NgProjectGreeting> {
  NgProjects? _projects;
  StreamSubscription<dynamic>? _changes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = NgScope.of(context);
    final projects = scope.gateway.projects(scope.prefs);
    if (identical(projects, _projects)) return;
    unawaited(_changes?.cancel());
    _projects = projects;
    _changes = projects.repository.changes.listen((_) {
      if (mounted) setState(() {});
    });
    unawaited(projects.load());
  }

  @override
  void dispose() {
    unawaited(_changes?.cancel());
    super.dispose();
  }

  bool _samePath(String a, String b) =>
      a.replaceFirst(RegExp(r'[/\\]+$'), '') ==
      b.replaceFirst(RegExp(r'[/\\]+$'), '');

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final c = NgColors.of(context);
    final projects =
        _projects?.repository.current.projects
            .where(
              (p) =>
                  !p.archived && p.workingDirectory?.trim().isNotEmpty == true,
            )
            .toList() ??
        const <HermesProject>[];
    final cwd = chat.workingDirectory;
    final enabled =
        chat.canPickProject &&
        identical(chat.gateway, NgScope.of(context).gateway);
    final show = enabled && (projects.isNotEmpty || cwd != null);
    final label = cwd == null
        ? ngL.ng_project_home
        : projects
                  .where((p) => _samePath(p.workingDirectory!, cwd))
                  .firstOrNull
                  ?.name ??
              cwd
                  .replaceFirst(RegExp(r'[/\\]+$'), '')
                  .split(RegExp(r'[/\\]'))
                  .last;

    final projectLabel = label.isEmpty ? cwd! : label;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Text(
          ngL.ng_what_should_we_work_on,
          textAlign: TextAlign.center,
          style: NgType.heading.copyWith(color: c.text),
        ),
        if (show)
          PopupMenuButton<String>(
            key: const Key('nextgen-project-picker'),
            tooltip: ngL.ng_choose_project,
            onSelected: (folder) {
              // A popup can outlive its greeting, selected profile or session.
              if (!mounted ||
                  !identical(chat.gateway, NgScope.of(context).gateway)) {
                return;
              }
              chat.startIn(folder.isEmpty ? null : folder);
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: '',
                checked: cwd == null,
                child: Text(ngL.ng_project_home),
              ),
              for (final project in projects)
                CheckedPopupMenuItem(
                  value: project.workingDirectory!,
                  checked:
                      cwd != null && _samePath(project.workingDirectory!, cwd),
                  child: Text(project.name),
                ),
            ],
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260, minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      projectLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NgType.heading.copyWith(color: c.accentText),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.expand_more, color: c.accentText, size: 20),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
