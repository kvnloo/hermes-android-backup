// Classic's server-owned Projects browser on the selected NextGen connection.
// Keep its nested navigation and repository in one gateway-owned subtree: a
// changed connection/profile discards both drill-in routes and pending reads.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/hermes_project.dart';
import '../../core/models/session.dart';
import '../../core/services/project_folder_discovery.dart';
import '../../core/services/projects_repository.dart';
import '../../core/widgets/project_detail_screen.dart';
import '../../core/widgets/projects_pane.dart';
import '../data/nextgen_gateway.dart';
import 'nextgen_scope.dart';

class NgProjectsPage extends StatelessWidget {
  const NgProjectsPage({
    super.key,
    required this.onOpenSession,
    required this.onNewProjectChat,
  });

  final ValueChanged<Session> onOpenSession;
  final ValueChanged<HermesProject>? onNewProjectChat;

  @override
  Widget build(BuildContext context) {
    final scope = NgScope.of(context);
    return _ProjectsBrowser(
      key: ObjectKey(scope.gateway),
      gateway: scope.gateway,
      preferences: scope.prefs,
      onOpenSession: onOpenSession,
      onNewProjectChat: onNewProjectChat,
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

class _ProjectsBrowser extends StatefulWidget {
  const _ProjectsBrowser({
    super.key,
    required this.gateway,
    required this.preferences,
    required this.onOpenSession,
    required this.onNewProjectChat,
    required this.onBack,
  });

  final NextGenGateway gateway;
  final SharedPreferences preferences;
  final ValueChanged<Session> onOpenSession;
  final ValueChanged<HermesProject>? onNewProjectChat;
  final VoidCallback onBack;

  @override
  State<_ProjectsBrowser> createState() => _ProjectsBrowserState();
}

class _ProjectsBrowserState extends State<_ProjectsBrowser> {
  final _navigator = GlobalKey<NavigatorState>();
  late final ProjectsRepository _repository;
  late final ProjectFolderDiscovery _folderDiscovery;

  bool get _isCurrent =>
      mounted && identical(NgScope.of(context).gateway, widget.gateway);

  @override
  void initState() {
    super.initState();
    final projects = widget.gateway.projects(widget.preferences);
    _repository = projects.repository;
    _folderDiscovery = projects.folderDiscovery;
  }

  void _openSession(Session session) {
    if (!_isCurrent) return;
    // The normal main-page owner retains its cached controllers, notifications
    // and stored-id routing. Do not mount a second chat under the browser.
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.onOpenSession(session);
  }

  Future<void> _newChat(HermesProject project) async {
    if (!_isCurrent || widget.onNewProjectChat == null) return;
    if (project.workingDirectory?.trim().isNotEmpty != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.this_project_has_no_folder_to_open_the_chat_in,
          ),
          duration: const Duration(seconds: 6),
        ),
      );
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.onNewProjectChat!(project);
  }

  Future<void> _openProject(String projectId) async {
    if (!_isCurrent) return;
    final project = _repository.current.projects
        .where((project) => project.id == projectId)
        .firstOrNull;
    if (project == null) return;
    await _navigator.currentState!.push<void>(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(
          projectId: project.id,
          projectName: project.name,
          loadSessions: ({required refresh}) =>
              _repository.projectSessions(project.id, refresh: refresh),
          onOpenSession: _openSession,
          onNewChat: widget.onNewProjectChat == null
              ? null
              : () => _newChat(project),
          projects: _repository.current.projects,
          onMoveSession: (session, destination) =>
              _repository.moveSessionToProject(session.id, destination),
          onRenameProject: (name) => _repository.rename(project.id, name),
          onArchiveProject: () => _repository.archive(project.id),
          onDeleteProject: () => _repository.delete(project.id),
        ),
      ),
    );
    // ProjectsPane refreshes the overview after this future completes, just
    // as it does in Classic (the detail's chat count is a separate read).
  }

  @override
  Widget build(BuildContext context) => NavigatorPopHandler(
    onPopWithResult: (_) => _navigator.currentState?.maybePop(),
    child: Navigator(
      key: _navigator,
      onGenerateInitialRoutes: (_, _) => [
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: widget.onBack),
              title: Text(context.l10n.projects),
            ),
            body: ProjectsPane(
              repository: _repository,
              folderDiscovery: _folderDiscovery,
              onProjectSelected: _openProject,
            ),
          ),
        ),
      ],
    ),
  );
}
