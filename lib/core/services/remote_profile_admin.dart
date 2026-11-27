part of 'remote_workspace.dart';

bool isProfileId(String value) =>
    value != 'current' && RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$').hasMatch(value);

class ProfileRoster {
  static final _choices = Expando<({String name, String install})>();

  /// A UI preference only. Always bind/verify a fresh scoped owner before
  /// using it. It is never shared with chat or another constructed gateway.
  String? get appliesTo {
    final choice = _choices[target.route.issuer];
    return choice != null &&
            choice.install == installId &&
            names.containsKey(choice.name)
        ? choice.name
        : null;
  }

  void rememberSettings(String name) {
    target.checkCurrent();
    if (installId != null && names.containsKey(name)) {
      _choices[target.route.issuer] = (name: name, install: installId!);
    }
  }

  void chooseAgain() => _choices[target.route.issuer] = null;
  const ProfileRoster._(this.target, this.installId, this.names, this._homes);
  final Map<String, String> _homes;
  final WorkspaceTarget target;
  final String? installId;
  final Map<String, String> names;
  static Future<ProfileRoster> read(WorkspaceTarget target) async {
    final result = await target.read(WorkspaceRead.profiles) as Map;
    final names = <String, String>{};
    final homes = <String, String>{};
    for (final row in result['profiles'] as List) {
      final name = row['name'] as String;
      if (!isProfileId(name) || names.containsKey(name)) {
        _fail(WorkspaceFailure.invalid);
      }
      names[name] = row['display_name'] as String? ?? '';
      final path = row['path'];
      if (path is String && _canonicalPath(path)) homes[name] = path;
    }
    return ProfileRoster._(
      target,
      result['install_id'] as String?,
      Map.unmodifiable(names),
      Map.unmodifiable(homes),
    );
  }

  Future<ProfileRoster> refresh() async {
    final result = await read(target);
    if (result.installId != installId) _fail(WorkspaceFailure.mismatch);
    return result;
  }

  Future<void> create(String name, {String? clone}) async {
    if (!isProfileId(name) || name == 'default') {
      _fail(WorkspaceFailure.invalid);
    }
    final before = await refresh();
    if (before.names.containsKey(name) ||
        clone != null && !before.names.containsKey(clone)) {
      _fail(WorkspaceFailure.mismatch);
    }
    final result = await target._withOwner(
      () => target._rpc('profiles.create', {
        'name': name,
        'clone_from': ?clone,
        'clone_all': false,
        'clone_channels': false,
        'no_alias': true,
        'mirror_credentials': false,
        'share_auth': false,
      }),
    );
    if (result['ok'] != true ||
        result['name'] != name ||
        !(await refresh()).names.containsKey(name)) {
      _fail(WorkspaceFailure.mismatch);
    }
  }

  Future<RemoteProfileAdmin> settings(
    WorkspaceTarget selected,
    String name,
  ) async {
    target.checkCurrent();
    selected.checkCurrent();
    if (target.route.storedSessionId != null ||
        selected.route.storedSessionId != null ||
        !names.containsKey(name) ||
        selected.effectiveProfile != name ||
        selected.route.connectionId != target.route.connectionId ||
        selected._owner.expectedBaseUrl != target._owner.expectedBaseUrl) {
      _fail(WorkspaceFailure.mismatch);
    }
    final other = await read(selected);
    target.checkCurrent();
    if (installId == null ||
        installId!.isEmpty ||
        other.installId != installId ||
        other._homes[name] != _homes[name] ||
        !other.names.containsKey(name)) {
      _fail(WorkspaceFailure.mismatch);
    }
    return RemoteProfileAdmin._(this, selected, name);
  }
}

typedef ProfileSoul = ({String content, bool exists});
typedef ProfileField = ({String key, bool isSet, String? listValue});

class ProfileChannel {
  ProfileChannel._(Map row)
    : id = row['id'] as String,
      name = row['name'] as String,
      enabled = row['enabled'] as bool,
      state = row['state'] as String? ?? 'unknown',
      fields = List.unmodifiable([
        for (final f in row['env_vars'] as List)
          (
            key: f['key'] as String,
            isSet: f['is_set'] as bool,
            listValue: f['is_list'] == true && f['is_password'] == false
                ? (f['value'] as String? ?? '')
                : null,
          ),
      ]);
  final String id, name, state;
  final bool enabled;
  final List<ProfileField> fields;
}

typedef ProfilePair = ({
  String platform,
  String user,
  String? request,
  bool pending,
});
typedef ProfileHook = ({
  String name,
  String signature,
  String url,
  bool enabled,
});

final class TelegramSetup {
  TelegramSetup._(this._owner, this.id, this.payload, this.expires);
  final RemoteProfileAdmin _owner;
  final String id, payload;
  final DateTime expires;
}

final class ProfileBackup {
  ProfileBackup._(this._owner, this.pid, this.archive);
  final RemoteProfileAdmin _owner;
  final int pid;
  final String archive;
}

class RemoteProfileAdmin {
  RemoteProfileAdmin._(this.roster, this._target, this.name);
  final ProfileRoster roster;
  final WorkspaceTarget _target;
  final String name;
  void check() {
    roster.target.checkCurrent();
    _target.checkCurrent();
  }

  Future<Map> _request(
    ProfileDashboardOp op, {
    String? key,
    Map<String, Object?>? fields,
    Map<String, String> query = const {},
    void Function()? peerCheck,
  }) {
    void fence() {
      check();
      peerCheck?.call();
    }

    return _guard(fence, () async {
      final response = await _target._owner._dashboard.profileOperation(
        op,
        check: fence,
        key: key,
        fields: fields,
        query: query,
      );
      if (response is! Map) _fail(WorkspaceFailure.invalid);
      return response;
    });
  }

  Future<void> _ok(
    ProfileDashboardOp op, {
    String? key,
    Map<String, Object?>? fields,
  }) async {
    if ((await _request(op, key: key, fields: fields))['ok'] != true) {
      _fail(WorkspaceFailure.unavailable);
    }
  }

  Future<ProfileSoul> soul() async {
    final r = await _request(ProfileDashboardOp.soul);
    return (content: r['content'] as String, exists: r['exists'] as bool);
  }

  Future<void> saveSoul(ProfileSoul before, String value) async {
    if (await soul() != before) _fail(WorkspaceFailure.mismatch);
    await _ok(ProfileDashboardOp.saveSoul, fields: {'content': value});
    if ((await soul()).content != value) _fail(WorkspaceFailure.mismatch);
  }

  Future<void> rename(String value) async {
    if (value.isEmpty ||
        value.trim() != value ||
        value.length > 64 ||
        (name != 'default' && (!isProfileId(value) || value == 'default'))) {
      _fail(WorkspaceFailure.invalid);
    }
    final before = await roster.refresh();
    if (!before.names.containsKey(name) ||
        name != 'default' && before.names.containsKey(value)) {
      _fail(WorkspaceFailure.mismatch);
    }
    final r = await _request(
      ProfileDashboardOp.rename,
      fields: {'new_name': value},
    );
    final after = await roster.refresh();
    if (r['ok'] != true ||
        (name == 'default'
            ? r['name'] != 'default' || after.names[name] != value
            : r['name'] != value ||
                  !after.names.containsKey(value) ||
                  after.names.containsKey(name))) {
      _fail(WorkspaceFailure.mismatch);
    }
  }

  Future<bool> remove() async {
    if (name == 'default' ||
        !(await roster.refresh()).names.containsKey(name)) {
      _fail(WorkspaceFailure.mismatch);
    }
    final r = await _request(ProfileDashboardOp.remove);
    if (r['ok'] != true || (await roster.refresh()).names.containsKey(name)) {
      _fail(WorkspaceFailure.mismatch);
    }
    return r['settlement_pending'] != true;
  }

  Future<String> exportProfile() async {
    final r = await _request(ProfileDashboardOp.export, fields: {});
    final path = r['archive'];
    if (r['ok'] != true ||
        path is! String ||
        !_canonicalPath(path) ||
        !path.endsWith('.tar.gz')) {
      _fail(WorkspaceFailure.invalid);
    }
    return path;
  }

  Future<PortableProfileBundle> portableExport(void Function() view) async {
    void fence() {
      view();
      check();
    }

    final r = await _request(
      ProfileDashboardOp.export,
      fields: {},
      peerCheck: view,
    );
    final path = r['archive'];
    if (r['ok'] != true ||
        path is! String ||
        !_canonicalPath(path) ||
        !RegExp(
          '^$name-[0-9]{8}-[0-9]{6}\\.tar\\.gz\u0024',
        ).hasMatch(path.split(RegExp(r'[/\\]')).last)) {
      _fail(WorkspaceFailure.invalid);
    }
    return _guard(fence, () async {
      final bytes = await _target._owner._dashboard.downloadProfileExport(
        path,
        fence,
      );
      final bundle = await PortableProfileBundle.inspect(bytes);
      if (bundle.profile != name) _fail(WorkspaceFailure.mismatch);
      return bundle;
    });
  }

  Future<Object?> bundledPresentation() async {
    final r = await _request(ProfileDashboardOp.desktopOverlay);
    if (r['exists'] is! bool) _fail(WorkspaceFailure.invalid);
    return r['exists'] == true ? r['desktop'] : null;
  }

  Future<Object?> importPortable(
    PortableProfileBundle bundle,
    Set<String> reviewed,
    String dest,
    void Function() view,
  ) async {
    void fence() {
      view();
      check();
    }

    if (!isProfileId(dest) ||
        dest == 'default' ||
        (await roster.refresh()).names.containsKey(dest)) {
      _fail(WorkspaceFailure.invalid);
    }
    final expectedHome = roster._homes[name];
    if (expectedHome == null ||
        (await roster.refresh())._homes[name] != expectedHome) {
      _fail(WorkspaceFailure.mismatch);
    }
    final bytes = bundle.encode(reviewed);
    final r = await _guard(
      fence,
      () => _target._owner._dashboard.stageProfileBundle(bytes, fence),
    );
    final desc = r['staged_upload'], path = r['path'];
    if (r['ok'] != true ||
        r['size'] != bytes.length ||
        path is! String ||
        !_canonicalPath(path) ||
        desc is! Map ||
        desc['install_id'] != roster.installId ||
        desc['path'] != path ||
        desc['profile_home'] != expectedHome) {
      _fail(WorkspaceFailure.mismatch);
    }
    final home = (desc['profile_home'] as String).replaceAll('\\', '/');
    final canonical = path.replaceAll('\\', '/');
    if (!canonical.startsWith('$home/uploads/') ||
        !RegExp(
          r'^web-[0-9a-f]{16}-profile\.tar\.gz$',
        ).hasMatch(canonical.substring('$home/uploads/'.length))) {
      _fail(WorkspaceFailure.mismatch);
    }
    return importProfile(path, dest, view: view);
  }

  Future<Object?> importProfile(
    String archive,
    String dest, {
    void Function()? view,
  }) async {
    if (!isProfileId(dest) ||
        dest == 'default' ||
        !_canonicalPath(archive) ||
        !archive.endsWith('.tar.gz')) {
      _fail(WorkspaceFailure.invalid);
    }
    if ((await roster.refresh()).names.containsKey(dest)) {
      _fail(WorkspaceFailure.mismatch);
    }
    final r = await _request(
      ProfileDashboardOp.importArchive,
      fields: {'archive': archive, 'name': dest},
      peerCheck: view,
    );
    if (r['ok'] != true ||
        r['name'] != dest ||
        !(await roster.refresh()).names.containsKey(dest)) {
      _fail(WorkspaceFailure.mismatch);
    }
    return r['desktop'];
  }

  Future<List<ProfileChannel>> channels() async => [
    for (final row
        in (await _request(ProfileDashboardOp.channels))['platforms'] as List)
      ProfileChannel._(row as Map),
  ];
  Future<bool> updateChannel(
    ProfileChannel channel,
    bool enabled,
    Map<String, String> env,
    List<String> clear,
  ) async {
    final keys = channel.fields.map((f) => f.key).toSet();
    if (!keys.containsAll({...env.keys, ...clear}) ||
        clear.any(env.containsKey)) {
      _fail(WorkspaceFailure.invalid);
    }
    final r = await _request(
      ProfileDashboardOp.channel,
      key: channel.id,
      fields: {'enabled': enabled, 'env': env, 'clear_env': clear},
    );
    final saved = (await channels()).where((c) => c.id == channel.id).single;
    if (r['ok'] != true ||
        r['platform'] != channel.id ||
        saved.enabled != enabled ||
        env.entries.any(
          (e) => !saved.fields.any(
            (f) =>
                f.key == e.key &&
                f.isSet &&
                (f.listValue == null || f.listValue == e.value),
          ),
        ) ||
        clear.any((k) => !saved.fields.any((f) => f.key == k && !f.isSet))) {
      _fail(WorkspaceFailure.mismatch);
    }
    return r['hot_served'] == true;
  }

  Future<List<ProfilePair>> pairs() async {
    final r = await _request(ProfileDashboardOp.pairs);
    return [
      for (final group in ['pending', 'approved'])
        for (final row in r[group] as List)
          (
            platform: row['platform'] as String,
            user: row['user_id'] as String,
            request: row['request_id'] as String?,
            pending: group == 'pending',
          ),
    ];
  }

  Future<void> changePair(ProfilePair pair) async {
    if (!(await pairs()).contains(pair)) _fail(WorkspaceFailure.mismatch);
    final id = pair.request;
    if (pair.pending && !RegExp(r'^[a-f0-9]{16}$').hasMatch(id ?? '')) {
      _fail(WorkspaceFailure.unsupported);
    }
    final r = await _request(
      pair.pending ? ProfileDashboardOp.approve : ProfileDashboardOp.revoke,
      fields: {
        'platform': pair.platform,
        if (!pair.pending) 'user_id': pair.user else 'request_id': id,
      },
    );
    if (r['ok'] != true ||
        pair.pending && r['user']?['user_id'] != pair.user ||
        (await pairs()).any(
              (p) =>
                  p.platform == pair.platform &&
                  p.user == pair.user &&
                  !p.pending,
            ) !=
            pair.pending) {
      _fail(WorkspaceFailure.mismatch);
    }
  }

  Future<({bool enabled, List<ProfileHook> entries})> hooks() async {
    final r = await _request(ProfileDashboardOp.hooks);
    return (
      enabled: r['enabled'] as bool,
      entries: [
        for (final h in r['subscriptions'] as List)
          (
            name: h['name'] as String,
            signature: h['signature'] as String? ?? 'unpinned',
            url: h['url'] as String,
            enabled: h['enabled'] as bool,
          ),
      ],
    );
  }

  Future<bool> enableHooks() async {
    final r = await _request(ProfileDashboardOp.enableHooks, fields: {});
    if (r['ok'] != true || !(await hooks()).enabled) {
      _fail(WorkspaceFailure.mismatch);
    }
    return r['needs_restart'] == true;
  }

  Future<({String url, String secret})> createHook({
    required String route,
    required String signature,
    required List<String> events,
    required String delivery,
    required String prompt,
    required List<String> skills,
    bool direct = false,
    String chatId = '',
  }) async {
    if (!isProfileId(route) ||
        !{'generic', 'github', 'gitlab', 'linear'}.contains(signature) ||
        delivery.isEmpty ||
        direct && delivery == 'log') {
      _fail(WorkspaceFailure.invalid);
    }
    final before = await hooks();
    if (!before.enabled || before.entries.any((e) => e.name == route)) {
      _fail(WorkspaceFailure.mismatch);
    }
    final r = await _request(
      ProfileDashboardOp.createHook,
      fields: {
        'name': route,
        'signature': signature,
        'events': events,
        'deliver': delivery,
        'deliver_only': direct,
        if (chatId.isNotEmpty) 'deliver_chat_id': chatId,
        'prompt': prompt,
        'skills': skills,
      },
    );
    if (r['name'] != route ||
        r['secret'] is! String ||
        (r['secret'] as String).isEmpty ||
        !(await hooks()).entries.any(
          (h) =>
              h.name == route && h.signature == signature && h.url == r['url'],
        )) {
      _fail(WorkspaceFailure.mismatch);
    }
    return (url: r['url'] as String, secret: r['secret'] as String);
  }

  Future<void> changeHook(ProfileHook hook, {required bool delete}) async {
    if (!(await hooks()).entries.contains(hook)) {
      _fail(WorkspaceFailure.mismatch);
    }
    await _ok(
      delete ? ProfileDashboardOp.deleteHook : ProfileDashboardOp.toggleHook,
      key: hook.name,
      fields: delete ? null : {'enabled': !hook.enabled},
    );
    final after = (await hooks()).entries.where((h) => h.name == hook.name);
    if (delete
        ? after.isNotEmpty
        : after.length != 1 || after.single.enabled == hook.enabled) {
      _fail(WorkspaceFailure.mismatch);
    }
  }

  Future<TelegramSetup> startTelegram(String bot) async {
    final r = await _request(
      ProfileDashboardOp.telegramStart,
      fields: {'bot_name': bot},
    );
    final payload = r['qr_payload'] as String;
    final uri = Uri.tryParse(payload);
    if (payload.length > 800 ||
        uri == null ||
        uri.scheme != 'https' ||
        uri.host != 't.me' ||
        !uri.path.startsWith('/newbot/') ||
        r['deep_link'] != payload ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort) {
      _fail(WorkspaceFailure.invalid);
    }
    return TelegramSetup._(
      this,
      r['pairing_id'] as String,
      payload,
      DateTime.parse(r['expires_at'] as String),
    );
  }

  Future<({bool ready, String user, String bot})> telegramStatus(
    TelegramSetup setup,
  ) async {
    if (setup._owner != this || !setup.expires.isAfter(DateTime.now())) {
      _fail(WorkspaceFailure.unavailable);
    }
    final r = await _request(ProfileDashboardOp.telegramStatus, key: setup.id);
    if (!{'waiting', 'ready'}.contains(r['status'])) {
      _fail(WorkspaceFailure.invalid);
    }
    return (
      ready: r['status'] == 'ready',
      user: r['owner_user_id'] as String? ?? '',
      bot: r['bot_username'] as String? ?? '',
    );
  }

  Future<bool> applyTelegram(TelegramSetup setup, List<String> users) async {
    if (users.isEmpty ||
        users.any((u) => !RegExp(r'^[0-9]+$').hasMatch(u)) ||
        !(await telegramStatus(setup)).ready) {
      _fail(WorkspaceFailure.invalid);
    }
    final r = await _request(
      ProfileDashboardOp.telegramApply,
      key: setup.id,
      fields: {'allowed_user_ids': users},
    );
    if (r['ok'] != true ||
        r['platform'] != 'telegram' ||
        !(await channels()).any(
          (c) =>
              c.id == 'telegram' &&
              c.enabled &&
              c.fields.any(
                (f) =>
                    f.key == 'TELEGRAM_ALLOWED_USERS' &&
                    f.listValue == users.join(','),
              ),
        )) {
      _fail(WorkspaceFailure.mismatch);
    }
    return r['needs_restart'] == true;
  }

  Future<void> cancelTelegram(TelegramSetup setup) {
    if (setup._owner != this) _fail(WorkspaceFailure.mismatch);
    return _ok(ProfileDashboardOp.telegramCancel, key: setup.id);
  }

  Future<Uint8List> backupBytes(ProfileBackup receipt) async {
    if (!await backupDone(receipt)) _fail(WorkspaceFailure.unavailable);
    return _guard(
      check,
      () =>
          _target._owner._dashboard.downloadAgentBackup(receipt.archive, check),
    );
  }

  Future<ProfileBackup> startBackup({void Function()? peerCheck}) async {
    final r = await _request(
      ProfileDashboardOp.backup,
      fields: {},
      peerCheck: peerCheck,
    );
    final path = r['archive'];
    if (r['ok'] != true ||
        r['pid'] is! int ||
        (r['pid'] as int) <= 0 ||
        r['name'] != 'backup' ||
        path is! String ||
        !_canonicalPath(path) ||
        !path.endsWith('.zip')) {
      _fail(WorkspaceFailure.invalid);
    }
    return ProfileBackup._(this, r['pid'] as int, path);
  }

  Future<bool> backupDone(ProfileBackup backup) async {
    if (backup._owner != this) _fail(WorkspaceFailure.mismatch);
    final r = await _request(ProfileDashboardOp.backupStatus);
    if (r['pid'] != backup.pid || r['name'] != 'backup') {
      _fail(WorkspaceFailure.mismatch);
    }
    if (r['running'] == true) return false;
    if (r['running'] != false || r['exit_code'] != 0) {
      _fail(WorkspaceFailure.unavailable);
    }
    return true;
  }
}
