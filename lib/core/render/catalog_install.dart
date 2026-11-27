/// The `manage_catalog` install card: the gateway opens a connection
/// operation (`connection.request`, `tui_gateway/contracts/
/// connectors_operation.py`) with one row per catalog plugin or hub skill,
/// drives it with `connection.update` frames, and the card answers each row
/// with `connection.respond` (approved or skipped). The host installs what
/// is approved into the row's target profile and reports the result on the
/// row. A plugin row that failed after the operation settled can be tried
/// again through the capabilities install (`plugins.manage`, catalog name,
/// that profile), as the Desktop's catalog-install-tool.tsx does.
///
/// Nothing here is a fixture: every word on a row is the host's.
library;

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class CatalogEnvField {
  const CatalogEnvField({
    required this.name,
    required this.required,
    required this.secret,
    this.prompt,
  });

  final String name;
  final bool required;
  final bool secret;
  final String? prompt;
}

class CatalogServerError {
  const CatalogServerError(this.name, this.error);

  final String name;
  final String error;
}

/// One catalog row (`ConnectionOperationTarget` of kind plugin or skill).
class CatalogRow {
  const CatalogRow({
    required this.name,
    required this.kind,
    required this.state,
    this.resolved = false,
    this.display,
    this.description,
    this.detail,
    this.tier,
    this.platforms = const [],
    this.repo,
    this.sha,
    this.scanStatus,
    this.scanSummary,
    this.requiresHermes,
    this.targetProfile,
    this.skill,
    this.enabled,
    this.missingEnv = const [],
    this.serverErrors = const [],
    this.requiredEnv = const [],
    this.approvedForce = false,
    this.approvedEnable = true,
    this.approvedRef,
    this.phase,
    this.tools = const [],
  });

  final String name;

  /// `plugin` or `skill`.
  final String kind;

  /// pending, initiated, connected, skipped, failed, expired, not_connected.
  final String state;
  final bool resolved;
  final String? display;
  final String? description;
  final String? detail;
  final String? tier;
  final List<String> platforms;
  final String? repo;
  final String? sha;
  final String? scanStatus;
  final String? scanSummary;
  final String? requiresHermes;
  final String? targetProfile;
  final String? skill;
  final bool? enabled;
  final List<String> missingEnv;
  final List<CatalogServerError> serverErrors;
  final List<CatalogEnvField> requiredEnv;
  final bool approvedForce;
  final bool approvedEnable;
  final String? approvedRef;

  /// The install step while the row is installing (`InstallPhase`:
  /// downloading, python_packages, loading_tools); the card words it.
  final String? phase;

  /// On an installed row: the tools that went live (`_installed_row`).
  final List<String> tools;

  String get title => (display?.trim().isNotEmpty ?? false) ? display! : name;

  /// The row waits on the user's Install or Skip.
  bool get waiting => state == 'pending';

  /// The host is installing the row (`initiated`). It offers no Install or
  /// Skip: the host takes initiated -> skipped from the user and then drops
  /// the finished install, so a Skip here would hide a plugin that lands.
  bool get installing => state == 'initiated';

  static String? _string(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;

  static List<String> _strings(Object? value) => value is List
      ? [
          for (final item in value)
            if (item is String && item.trim().isNotEmpty) item.trim(),
        ]
      : const [];

  static CatalogRow? parse(Object? raw) {
    if (raw is! Map) return null;
    final kind = raw['kind'];
    final name = _string(raw['name']);
    if ((kind != 'plugin' && kind != 'skill') || name == null) return null;
    final scan = raw['scan'];
    final approved = raw['approved'];
    return CatalogRow(
      name: name,
      kind: kind as String,
      state: _string(raw['state']) ?? 'pending',
      resolved: raw['resolved'] == true,
      display: _string(raw['display']),
      description: _string(raw['description']),
      detail: _string(raw['detail']),
      tier: _string(raw['tier']),
      platforms: _strings(raw['platforms']),
      repo: _string(raw['repo']),
      sha: _string(raw['sha']),
      scanStatus: scan is Map ? _string(scan['status']) : null,
      scanSummary: scan is Map ? _string(scan['summary']) : null,
      requiresHermes: _string(raw['requires_hermes']),
      targetProfile: _string(raw['target_profile']),
      skill: _string(raw['skill']),
      enabled: raw['enabled'] is bool ? raw['enabled'] as bool : null,
      missingEnv: _strings(raw['missing_env']),
      serverErrors: [
        if (raw['server_errors'] is List)
          for (final error in raw['server_errors'] as List)
            if (error is Map && _string(error['name']) != null)
              CatalogServerError(
                _string(error['name'])!,
                _string(error['error']) ?? '',
              ),
      ],
      requiredEnv: [
        if (raw['required_env'] is List)
          for (final field in raw['required_env'] as List)
            if (field is Map && _string(field['name']) != null)
              CatalogEnvField(
                name: _string(field['name'])!,
                required: field['required'] == true,
                secret: field['secret'] != false,
                prompt: _string(field['prompt']),
              ),
      ],
      approvedForce: approved is Map && approved['force'] == true,
      approvedEnable: !(approved is Map && approved['enable'] == false),
      approvedRef: approved is Map ? _string(approved['ref']) : null,
      phase: _string(raw['phase']),
      tools: _strings(raw['tools']),
    );
  }
}

/// One open catalog operation, as its newest frame describes it.
class CatalogOperation {
  const CatalogOperation({
    required this.opId,
    required this.seq,
    required this.rows,
    required this.settled,
    this.toolCallId,
  });

  final String opId;
  final int seq;
  final List<CatalogRow> rows;
  final bool settled;
  final String? toolCallId;

  /// The operation a `connection.request` or `connection.update` payload
  /// describes, or null when it carries no catalog rows (a connector card).
  static CatalogOperation? parse(Map<String, dynamic> payload) {
    final opId = payload['op_id'];
    final seq = payload['seq'];
    final targets = payload['targets'];
    if (opId is! String || opId.isEmpty || seq is! num || targets is! List) {
      return null;
    }
    final rows = [for (final target in targets) ?CatalogRow.parse(target)];
    if (rows.isEmpty) return null;
    final toolCallId = payload['tool_call_id'];
    return CatalogOperation(
      opId: opId,
      seq: seq.toInt(),
      rows: List.unmodifiable(rows),
      settled: payload['settled'] == true || payload['settled_at'] != null,
      toolCallId: toolCallId is String && toolCallId.isNotEmpty
          ? toolCallId
          : null,
    );
  }

  /// [current] advanced by a frame: a frame of the same operation moves the
  /// card only when its seq is newer. Only a `connection.request` ([opens])
  /// starts another operation; an update for one this chat never saw opens
  /// nothing.
  static CatalogOperation? merge(
    CatalogOperation? current,
    Map<String, dynamic> payload, {
    required bool opens,
  }) {
    final next = parse(payload);
    if (next == null) return current;
    if (current == null || current.opId != next.opId) {
      return opens ? next : current;
    }
    if (next.seq <= current.seq) return current;
    return CatalogOperation(
      opId: next.opId,
      seq: next.seq,
      rows: next.rows,
      settled: next.settled,
      toolCallId: next.toolCallId ?? current.toolCallId,
    );
  }

  /// Continue: end the operation now with whatever is unresolved
  /// (Desktop's continueConnectionRequest; the host settles it with
  /// `SettleReason.continue_`).
  static const Map<String, dynamic> continueAnswer = {'settled_by': 'continue'};

  /// Whether a row still needs something from the user or the host.
  bool get unresolved => rows.any((row) => !row.resolved);

  /// The card's answer for one row (`ConnectionAnswer`).
  static Map<String, dynamic> answer(
    CatalogRow row, {
    required bool approve,
    Map<String, String>? env,
  }) => {
    'targets': [
      {
        'name': row.name,
        'status': approve ? 'approved' : 'skipped',
        if (approve && env != null && env.isNotEmpty) 'env': env,
      },
    ],
  };
}

/// What a post-settlement Try again reported.
class CatalogRetryResult {
  const CatalogRetryResult({required this.ok, this.message});

  final bool ok;
  final String? message;
}

typedef CatalogRespond = Future<bool> Function(Map<String, dynamic> answer);
typedef CatalogRetry = Future<CatalogRetryResult> Function(CatalogRow row);

/// The catalog install card for one chat, drawn above the composer.
class CatalogInstallCard extends StatefulWidget {
  const CatalogInstallCard({
    super.key,
    required this.operation,
    required this.respond,
    this.retry,
    this.onDismiss,
  });

  final CatalogOperation operation;
  final CatalogRespond respond;

  /// Installs a failed plugin row again after the operation settled.
  final CatalogRetry? retry;

  /// Hides a settled card.
  final VoidCallback? onDismiss;

  @override
  State<CatalogInstallCard> createState() => _CatalogInstallCardState();
}

class _CatalogInstallCardState extends State<CatalogInstallCard> {
  /// The seq each row's answer was sent at; its buttons stay held until a
  /// newer frame of the operation arrives, so a second tap cannot answer
  /// twice.
  final _sentAt = <String, int>{};
  final _retried = <String, CatalogRetryResult>{};
  final _retrying = <String>{};
  final _env = <String, TextEditingController>{};
  String? _error;

  /// The seq Continue was sent at; held until a newer frame.
  int? _continuedAt;

  @override
  void didUpdateWidget(CatalogInstallCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.operation.opId != widget.operation.opId) {
      _sentAt.clear();
      _retried.clear();
      _retrying.clear();
      _continuedAt = null;
      _error = null;
    }
  }

  Future<void> _continue() async {
    final seq = widget.operation.seq;
    setState(() {
      _continuedAt = seq;
      _error = null;
    });
    var sent = false;
    try {
      sent = await widget.respond(CatalogOperation.continueAnswer);
    } catch (_) {
      sent = false;
    }
    if (!mounted || sent) return;
    setState(() {
      _continuedAt = null;
      _error = context.sharedL10n.catalog_send_failed;
    });
  }

  @override
  void dispose() {
    for (final controller in _env.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _field(CatalogRow row, CatalogEnvField field) => _env
      .putIfAbsent('${row.name}\u0000${field.name}', TextEditingController.new);

  Future<void> _answer(CatalogRow row, {required bool approve}) async {
    final seq = widget.operation.seq;
    final env = <String, String>{
      for (final field in row.requiredEnv)
        if (_field(row, field).text.trim().isNotEmpty)
          field.name: _field(row, field).text.trim(),
    };
    setState(() {
      _sentAt[row.name] = seq;
      _error = null;
    });
    var sent = false;
    try {
      sent = await widget.respond(
        CatalogOperation.answer(row, approve: approve, env: env),
      );
    } catch (_) {
      sent = false;
    }
    if (!mounted) return;
    if (!sent) {
      setState(() {
        _sentAt.remove(row.name);
        _error = context.sharedL10n.catalog_send_failed;
      });
    }
  }

  Future<void> _retry(CatalogRow row) async {
    final retry = widget.retry;
    if (retry == null) return;
    setState(() => _retrying.add(row.name));
    CatalogRetryResult result;
    try {
      result = await retry(row);
    } catch (error) {
      result = CatalogRetryResult(ok: false, message: '$error');
    }
    if (!mounted) return;
    setState(() {
      _retrying.remove(row.name);
      _retried[row.name] = result;
    });
  }

  String _state(CatalogRow row, {required bool settled}) {
    final l = context.sharedL10n;
    return switch (row.state) {
      'connected' =>
        row.enabled == false ? l.catalog_installed_off : l.catalog_installed,
      'skipped' => l.catalog_skipped,
      'failed' || 'expired' || 'not_connected' => l.catalog_not_installed,
      // A settled operation installs nothing more.
      _ when settled => l.catalog_not_installed,
      'initiated' => l.catalog_installing,
      _ => l.catalog_waiting,
    };
  }

  /// The host's scan verdict in the app language (Desktop's
  /// catalogInstall.scan); a verdict this build does not know is shown as
  /// the host wrote it.
  String _scanStatus(String status) {
    final l = context.sharedL10n;
    return switch (status) {
      'passed' => l.catalog_scan_passed,
      'warnings' => l.catalog_scan_warnings,
      'failed' => l.catalog_scan_failed,
      _ => status,
    };
  }

  /// A platform as people write it (Desktop's platformName).
  static String _platformName(String platform) =>
      switch (platform.toLowerCase()) {
        'darwin' || 'macos' => 'macOS',
        'linux' => 'Linux',
        'windows' => 'Windows',
        _ => platform,
      };

  /// The host's install step, worded; null for a step this build does not
  /// know.
  String? _phase(CatalogRow row) {
    final l = context.sharedL10n;
    return switch (row.phase) {
      'downloading' => l.catalog_phase_downloading,
      'python_packages' => l.catalog_phase_python_packages,
      'loading_tools' => l.catalog_phase_loading_tools,
      _ => null,
    };
  }

  Widget _row(CatalogRow row) {
    final l = context.sharedL10n;
    final theme = Theme.of(context);
    final operation = widget.operation;
    final held =
        (_sentAt[row.name] ?? -1) >= operation.seq ||
        _retrying.contains(row.name);
    final retried = _retried[row.name];
    final canAnswer = !operation.settled && row.waiting;
    final installing = !operation.settled && row.installing;
    final phase = installing ? _phase(row) : null;
    final failed = row.state == 'failed' && retried?.ok != true;
    final small = theme.textTheme.bodySmall;
    return Padding(
      key: Key('catalog-row-${row.name}'),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(row.title, style: theme.textTheme.titleSmall),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(
                  row.kind == 'plugin'
                      ? l.catalog_kind_plugin
                      : l.catalog_kind_skill,
                ),
              ),
              if (row.tier != null)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(switch (row.tier) {
                    'official' => l.catalog_tier_official,
                    'verified' => l.catalog_tier_verified,
                    _ => l.catalog_tier_community,
                  }),
                ),
              for (final platform in row.platforms)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(_platformName(platform)),
                ),
            ],
          ),
          if (row.description != null) Text(row.description!),
          if (row.repo != null)
            Text(
              row.sha == null
                  ? row.repo!
                  : l.catalog_source(
                      row.repo!,
                      row.sha!.length > 7 ? row.sha!.substring(0, 7) : row.sha!,
                    ),
              style: small,
            ),
          if (row.scanStatus != null)
            Text(
              l.catalog_scan(
                _scanStatus(row.scanStatus!),
                row.scanSummary ?? '',
              ),
              key: Key('catalog-scan-${row.name}'),
              style: small,
            ),
          if (row.requiresHermes != null)
            Text(l.catalog_requires_hermes(row.requiresHermes!), style: small),
          if (canAnswer)
            for (final field in row.requiredEnv)
              TextField(
                key: Key('catalog-env-${row.name}-${field.name}'),
                controller: _field(row, field),
                obscureText: field.secret,
                enabled: !held,
                decoration: InputDecoration(
                  labelText: field.prompt ?? field.name,
                  isDense: true,
                ),
              ),
          const SizedBox(height: 4),
          Text(
            retried?.ok == true
                ? l.catalog_installed
                : _state(row, settled: operation.settled),
            key: Key('catalog-state-${row.name}'),
            style: theme.textTheme.labelLarge,
          ),
          if (installing) ...[
            const SizedBox(height: 4),
            LinearProgressIndicator(
              key: Key('catalog-progress-${row.name}'),
              minHeight: 2,
              semanticsLabel: l.catalog_installing,
            ),
            if (phase != null)
              Text(phase, key: Key('catalog-phase-${row.name}'), style: small),
          ],
          if (row.detail != null && retried == null)
            Text(row.detail!, key: Key('catalog-detail-${row.name}')),
          if (retried?.message != null)
            Text(retried!.message!, key: Key('catalog-retry-${row.name}')),
          if (row.state == 'connected' && row.tools.isNotEmpty)
            Text(
              l.catalog_tool_count(row.tools.length),
              key: Key('catalog-tools-${row.name}'),
              style: small,
            ),
          if (row.skill != null) Text(l.catalog_skill_ready(row.skill!)),
          if (row.missingEnv.isNotEmpty)
            Text(l.catalog_missing_env(row.missingEnv.join(', '))),
          for (final error in row.serverErrors)
            Text(l.catalog_server_error(error.name, error.error)),
          if (canAnswer)
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  key: Key('catalog-install-${row.name}'),
                  onPressed: held ? null : () => _answer(row, approve: true),
                  child: Text(l.catalog_install),
                ),
                TextButton(
                  key: Key('catalog-skip-${row.name}'),
                  onPressed: held ? null : () => _answer(row, approve: false),
                  child: Text(l.ng_skip),
                ),
              ],
            )
          else if (failed &&
              (!operation.settled ||
                  (row.kind == 'plugin' && widget.retry != null)))
            TextButton(
              key: Key('catalog-retry-button-${row.name}'),
              onPressed: held
                  ? null
                  : operation.settled
                  ? () => _retry(row)
                  : () => _answer(row, approve: true),
              child: Text(l.ng_try_again),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final operation = widget.operation;
    final profile = operation.rows
        .map((row) => row.targetProfile)
        .whereType<String>()
        .firstOrNull;
    // Above the composer the card may not take the whole pane: on a phone
    // it scrolls within at most two fifths of the screen.
    return Card(
      key: Key('catalog-card-${operation.opId}'),
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.4,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final row in operation.rows) _row(row),
              if (!operation.settled && operation.unresolved)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    key: const Key('catalog-continue'),
                    onPressed: (_continuedAt ?? -1) >= operation.seq
                        ? null
                        : _continue,
                    child: Text(l.ng_continue),
                  ),
                ),
              if (profile != null)
                Text(
                  l.catalog_target_profile(profile),
                  key: const Key('catalog-target-profile'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              if (operation.settled && widget.onDismiss != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    key: const Key('catalog-dismiss'),
                    onPressed: widget.onDismiss,
                    child: Text(l.ng_dismiss),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
