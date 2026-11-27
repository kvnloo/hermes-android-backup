part of 'connection_manager.dart';

/// Closed catalogue: @ is the transport's own canonical profile, # is a
/// single opaque path component. Neither the caller nor a server response can
/// select an HTTP method, origin or arbitrary endpoint.
enum ProfileDashboardOp {
  rename('PATCH', 'profiles/@'),
  remove('DELETE', 'profiles/@'),
  soul('GET', 'profiles/@/soul'),
  desktopOverlay('GET', 'profiles/@/desktop-overlay'),
  saveSoul('PUT', 'profiles/@/soul'),
  export('POST', 'profiles/@/export'),
  importArchive('POST', 'profiles/import'),
  channels('GET', 'messaging/platforms'),
  channel('PUT', 'messaging/platforms/#'),
  pairs('GET', 'pairing'),
  approve('POST', 'pairing/approve'),
  revoke('POST', 'pairing/revoke'),
  telegramStart('POST', 'messaging/telegram/onboarding/start'),
  telegramStatus('GET', 'messaging/telegram/onboarding/#'),
  telegramApply('POST', 'messaging/telegram/onboarding/#/apply'),
  telegramCancel('DELETE', 'messaging/telegram/onboarding/#'),
  hooks('GET', 'webhooks'),
  enableHooks('POST', 'webhooks/enable'),
  createHook('POST', 'webhooks'),
  toggleHook('PUT', 'webhooks/#/enabled'),
  deleteHook('DELETE', 'webhooks/#'),
  backup('POST', 'ops/backup'),
  backupStatus('GET', 'actions/backup/status'),
  cloudAgents('GET', 'cloud/agents'),
  transferCapability('GET', 'status'),
  backupChunk('GET', 'ops/backup/chunk'),
  uploadChunk('POST', 'ops/transfer/chunk'),
  restoreUpload('POST', 'ops/transfer/restore'),
  importStatus('GET', 'actions/import/status'),
  undoImport('POST', 'ops/import');

  const ProfileDashboardOp(this.method, this.template);
  final String method, template;
}

extension ProfileDashboardTransport on DashboardClient {
  Future<Uint8List> downloadAgentBackup(
    String archive,
    void Function() check,
  ) => _profileBytes(
    http.Request(
      'GET',
      Uri.parse('$_baseUrl/api/ops/backup/download').replace(
        queryParameters: {'archive': archive, 'profile': gatewayProfile!},
      ),
    ),
    32 * 1024 * 1024,
    check,
  );
  // Bound the response as it arrives; no auth replay or credential redirects.
  Future<Uint8List> _profileBytes(
    http.BaseRequest request,
    int limit,
    void Function() check,
  ) async {
    check();
    request.followRedirects = false;
    final auth = await _authHeaders();
    auth.remove('Content-Type');
    request.headers.addAll(auth);
    check();
    final res = await _http.send(request).timeout(ApiClient.requestTimeout);
    final out = BytesBuilder(copy: false);
    await for (final chunk in res.stream.timeout(ApiClient.requestTimeout)) {
      check();
      if (res.statusCode != 200) throw DashboardHttpException(res.statusCode);
      if ((res.contentLength ?? 0) > limit ||
          out.length + chunk.length > limit) {
        throw const FormatException('Archive too large');
      }
      out.add(chunk);
    }
    check();
    if (res.statusCode != 200) throw DashboardHttpException(res.statusCode);
    return out.takeBytes();
  }

  Future<Uint8List> downloadProfileExport(
    String archive,
    void Function() check,
  ) => _profileBytes(
    http.Request(
      'GET',
      Uri.parse(
        '$_baseUrl/api/files/download',
      ).replace(queryParameters: {'path': archive}),
    ),
    16 * 1024 * 1024,
    check,
  );
  Future<Map> stageProfileBundle(Uint8List bytes, void Function() check) async {
    if (bytes.isEmpty ||
        bytes.length > 16 * 1024 * 1024 ||
        gatewayProfile == null) {
      throw const FormatException('Invalid profile upload');
    }
    final req =
        http.MultipartRequest(
            'POST',
            Uri.parse(
              '$_baseUrl/api/chat/file-upload',
            ).replace(queryParameters: {'profile': gatewayProfile!}),
          )
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              bytes,
              filename: 'profile.tar.gz',
            ),
          );
    return jsonDecode(utf8.decode(await _profileBytes(req, 16384, check)))
        as Map;
  }

  Future<Object?> profileOperation(
    ProfileDashboardOp op, {
    required void Function() check,
    String? key,
    Map<String, Object?>? fields,
    Map<String, String> query = const {},
  }) {
    final profile = gatewayProfile;
    if (profile == null ||
        profile == 'current' ||
        !RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$').hasMatch(profile) ||
        fields?.containsKey('profile') == true ||
        query.containsKey('profile')) {
      throw const FormatException('Invalid profile scope');
    }
    final bodyScope = const {
      ProfileDashboardOp.approve,
      ProfileDashboardOp.revoke,
      ProfileDashboardOp.telegramApply,
    }.contains(op);
    return _workspaceExchange(
      [
        for (final segment in op.template.split('/'))
          switch (segment) {
            '@' => profile,
            '#' => key ?? '',
            _ => segment,
          },
      ],
      query: {
        ...query,
        'profile': profile,
        if (op == ProfileDashboardOp.backupStatus ||
            op == ProfileDashboardOp.importStatus)
          'lines': '1',
      },
      method: op.method,
      check: check,
      body: bodyScope ? {...?fields, 'profile': profile} : fields,
    );
  }
}
