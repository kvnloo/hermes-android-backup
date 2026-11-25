// One Projects authority per NextGen gateway (connection + Hermes profile).
import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/project_folder_discovery.dart';
import '../../core/services/project_folder_provisioner.dart';
import '../../core/services/projects_gateway_client.dart';
import '../../core/services/projects_repository.dart';
import '../../core/services/projects_root_preference.dart';
import '../../core/services/projects_root_resolver.dart';
import '../../core/services/remote_files_client.dart';
import '../../core/services/ws_client.dart';
import 'nextgen_gateway.dart';

class NgProjects {
  NgProjects(this.gateway, SharedPreferences preferences) {
    final connection = gateway.connection;
    final roots = ProjectsRootPreference(preferences);
    String? readConfiguredRoot() => roots.read(
      connectionIdentity: ProjectsRootPreference.identityOf(connection),
    );
    final cacheScope = sha256.convert(
      utf8.encode(
        jsonEncode([
          connection.toMap(),
          connection.apiKey,
          connection.dashboardPassword,
          connection.clientCertificate?.privateKeyPassword,
        ]),
      ),
    );
    repository = ProjectsRepository(
      client: ProjectsGatewayClient(_call),
      preferences: preferences,
      connectionId: 'nextgen_$cacheScope',
      folderProvisioner: DashboardFolderProvisioner(
        gateway.dashboard,
        readConfiguredRoot: readConfiguredRoot,
      ),
    );
    final files = RemoteFilesClient(
      dashboard: gateway.dashboard,
      profile: gateway.profile,
    );
    folderDiscovery = DashboardProjectFolderDiscovery(
      listDirectory: files.listDirectory,
      roots: ProjectsRootResolver(
        dashboard: gateway.dashboard,
        readConfiguredRoot: readConfiguredRoot,
      ),
    );
  }

  final NextGenGateway gateway;
  late final ProjectsRepository repository;
  late final ProjectFolderDiscovery folderDiscovery;
  bool _closed = false;
  Future<void>? _loading;

  // Non-blocking greeting discovery shares the browser's cache and transport.
  Future<void> load() =>
      _loading ??= _load().whenComplete(() => _loading = null);
  Future<void> _load() async {
    if (repository.current.support == ProjectsSupport.unknown) {
      await repository.loadCached();
    }
    if (!_closed) await repository.refresh();
  }

  Future<Map<String, dynamic>> _call(
    String method,
    Map<String, dynamic> params,
  ) async {
    if (_closed) throw StateError('Projects scope is no longer selected');
    await gateway.connected();
    if (_closed) throw StateError('Projects scope is no longer selected');
    try {
      return {'result': await gateway.call(method, params)};
    } on JsonRpcError catch (error) {
      return {
        'error': {
          'code': error.code,
          'message': error.message,
          'data': error.data,
        },
      };
    }
  }

  void close() {
    _closed = true;
    unawaited(repository.close());
    // All clients above borrow the gateway's authenticated dashboard/socket.
  }
}
