import '../../l10n/app_localizations_en.dart';
import '../l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../services/profile_file_save.dart';
import 'package:qr/qr.dart';
import '../services/remote_workspace.dart';
import '../models/connection.dart';
import 'profile_transfer_screen.dart';
import 'profile_bundle_screen.dart';

/// English default preserves the caller outside this owned screen group.
String profileError(Object e, [AppLocalizations? strings]) {
  final l = strings ?? AppLocalizationsEn();
  return switch (e) {
    WorkspaceException(reason: WorkspaceFailure.unsupported) =>
      l.rel_admin_this_operation_is_unavailable_on_this_gateway,
    WorkspaceException(reason: WorkspaceFailure.denied) =>
      l.rel_admin_access_denied_by_the_gateway,
    WorkspaceException(reason: WorkspaceFailure.stale) =>
      l.rel_admin_connection_changed_reopen_profiles,
    WorkspaceException(reason: WorkspaceFailure.invalid) =>
      l.rel_admin_invalid_input_or_gateway_response_check_the_target_before,
    _ => l.rel_admin_could_not_verify_the_result_refresh_the_target_before,
  };
}

Future<String?> profileInput(
  BuildContext context,
  String title,
  String field,
  String scope,
) {
  String value = '';
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(scope),
          TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: field),
            onChanged: (v) => value = v,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(context.sharedL10n.rel_admin_cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, value),
          child: Text(context.sharedL10n.rel_admin_create),
        ),
      ],
    ),
  );
}

class ProfileAdminPanel extends StatefulWidget {
  const ProfileAdminPanel({
    super.key,
    required this.admin,
    required this.label,
    required this.connection,
    required this.nextGen,
    required this.onRosterChanged,
  });
  final RemoteProfileAdmin admin;
  final String label;
  final SavedConnection connection;
  final bool nextGen;
  final VoidCallback onRosterChanged;
  @override
  State<ProfileAdminPanel> createState() => _ProfileAdminPanelState();
}

class _Field {
  const _Field(
    this.label, {
    this.value = '',
    this.secret = false,
    this.lines = 1,
    this.choices,
  });
  final String label, value;
  final bool secret;
  final int lines;
  final List<String>? choices;
}

class _Editor {
  _Editor(this.title, this.warning, this.fields, this.submit);
  final String title, warning;
  final List<_Field> fields;
  final Future<void> Function(List<String>) submit;
}

class _ProfileAdminPanelState extends State<ProfileAdminPanel> {
  RemoteProfileAdmin get a => widget.admin;
  String get scope => '${widget.label} / ${a.name}';
  bool busy = false;
  String message = '';
  _Editor? editor;
  List<String> values = [];
  List<ProfileChannel>? channels;
  List<ProfilePair>? pairs;
  ({bool enabled, List<ProfileHook> entries})? hooks;
  TelegramSetup? setup;
  QrImage? qr;
  ProfileBackup? backup;
  ProfileBackup? completedBackup;
  String? revealedSecret;
  bool showSecret = false;
  List<String> csv(String s) => s
      .split(',')
      .map((v) => v.trim())
      .where((v) => v.isNotEmpty)
      .toSet()
      .toList();
  void edit(
    String title,
    String warning,
    List<_Field> fields,
    Future<void> Function(List<String>) submit,
  ) {
    if (!mounted) return;
    a.check();
    setState(() {
      editor = _Editor(title, warning, fields, submit);
      values = fields.map((f) => f.value).toList();
      message = '';
      revealedSecret = null;
    });
  }

  Future<void> run(Future<void> Function() work) async {
    final l = context.sharedL10n;
    if (busy) return;
    setState(() {
      busy = true;
      message = '';
      revealedSecret = null;
      showSecret = false;
    });
    try {
      a.check();
      await work();
    } catch (e) {
      if (mounted) message = profileError(e, l);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget action(String text, Future<void> Function() work, {String? detail}) =>
      ListTile(
        title: Text(text),
        subtitle: detail == null ? null : Text(detail),
        onTap: busy ? null : () => run(work),
      );
  void changeRoster(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    widget.onRosterChanged();
  }

  Future<void> persona() async {
    final l = context.sharedL10n;
    final before = await a.soul();
    edit(
      l.rel_admin_edit_soul_md,
      l.rel_admin_persona_scope(scope),
      [_Field(l.rel_admin_persona, value: before.content, lines: 7)],
      (v) async {
        await a.saveSoul(before, v[0]);
        message = l.rel_admin_persona_saved;
      },
    );
  }

  void channelEditor(ProfileChannel c) {
    final l = context.sharedL10n;
    final inputs = [
      for (final f in c.fields)
        _Field(
          '${f.key} (${f.isSet ? l.rel_admin_configured : l.rel_admin_not_set})',
          value: f.listValue ?? '',
          secret: f.listValue == null,
        ),
    ];
    edit(
      l.rel_admin_configure_channel(c.name),
      l.rel_admin_channel_warning(scope),
      [
        _Field(
          l.rel_admin_enabled,
          value: c.enabled ? 'yes' : 'no',
          choices: const ['yes', 'no'],
        ),
        ...inputs,
        _Field(l.rel_admin_keys_to_remove_comma_separated),
      ],
      (v) async {
        if (!{'yes', 'no'}.contains(v.first)) {
          throw const WorkspaceException(WorkspaceFailure.invalid);
        }
        final clear = csv(v.last);
        final env = <String, String>{};
        for (var i = 0; i < c.fields.length; i++) {
          final f = c.fields[i];
          final val = v[i + 1].trim();
          if (val.isNotEmpty && val != f.listValue && !clear.contains(f.key)) {
            env[f.key] = val;
          }
        }
        final hot = await a.updateChannel(c, v.first == 'yes', env, clear);
        channels = await a.channels();
        message = hot
            ? l.rel_admin_saved_and_applied_by_the_gateway
            : l.rel_admin_saved_a_gateway_restart_may_be_required;
      },
    );
  }

  void newHook() {
    final l = context.sharedL10n;
    edit(
      l.rel_admin_create_signed_route,
      l.rel_admin_hook_warning(scope),
      [
        _Field(l.rel_admin_route_id),
        _Field(
          l.rel_admin_signature,
          value: 'generic',
          choices: ['generic', 'github', 'gitlab', 'linear'],
        ),
        _Field(l.rel_admin_events_comma_separated),
        _Field(
          l.rel_admin_delivery_target,
          value: 'log',
          choices: [
            'log',
            'telegram',
            'discord',
            'slack',
            'email',
            'github_comment',
          ],
        ),
        _Field(l.rel_admin_prompt, lines: 3),
        _Field(l.rel_admin_skills_comma_separated),
        _Field(
          l.rel_admin_delivery_mode,
          value: 'Agent processes event',
          choices: ['Agent processes event', 'Direct delivery'],
        ),
        _Field(l.rel_admin_delivery_chat_id_optional),
      ],
      (v) async {
        final r = await a.createHook(
          route: v[0],
          signature: v[1],
          events: csv(v[2]),
          delivery: v[3],
          prompt: v[4],
          skills: csv(v[5]),
          direct: v[6] == 'Direct delivery',
          chatId: v[7],
        );
        hooks = await a.hooks();
        revealedSecret = r.secret;
        message = l.rel_admin_hook_created(r.url);
      },
    );
  }

  String _choiceLabel(String value) => switch (value) {
    'yes' => context.sharedL10n.rel_admin_choice_yes,
    'no' => context.sharedL10n.rel_admin_choice_no,
    'generic' => context.sharedL10n.rel_admin_choice_generic,
    'log' => context.sharedL10n.rel_admin_choice_log,
    'email' => context.sharedL10n.rel_admin_choice_email,
    'github_comment' => context.sharedL10n.rel_admin_choice_github_comment,
    'Agent processes event' => context.sharedL10n.rel_admin_choice_agent,
    'Direct delivery' => context.sharedL10n.rel_admin_choice_direct,
    // Provider names and signature identifiers are stable protocol names.
    _ => value,
  };

  String _channelState(String value) => switch (value) {
    'pending_restart' => context.sharedL10n.rel_admin_state_pending_restart,
    'unknown' => context.sharedL10n.rel_admin_state_unknown,
    'connected' => context.sharedL10n.rel_admin_state_connected,
    'disconnected' => context.sharedL10n.rel_admin_state_disconnected,
    'disabled' => context.sharedL10n.rel_admin_state_disabled,
    'enabled' => context.sharedL10n.rel_admin_state_enabled,
    'running' => context.sharedL10n.rel_admin_state_running,
    'stopped' => context.sharedL10n.rel_admin_state_stopped,
    'error' => context.sharedL10n.rel_admin_state_error,
    'not_configured' => context.sharedL10n.rel_admin_state_not_configured,
    'configured' => context.sharedL10n.rel_admin_configured,
    'startup_failed' => context.sharedL10n.rel_admin_state_startup_failed,
    'gateway_stopped' => context.sharedL10n.rel_admin_state_gateway_stopped,
    'connecting' => context.sharedL10n.rel_admin_state_connecting,
    'retrying' => context.sharedL10n.rel_admin_state_retrying,
    'fatal' => context.sharedL10n.rel_admin_state_fatal,

    _ => value,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final form = editor;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (busy) const LinearProgressIndicator(),
        if (message.isNotEmpty) SelectableText(message),
        if (revealedSecret != null) ...[
          TextButton(
            onPressed: () => setState(() => showSecret = !showSecret),
            child: Text(
              showSecret
                  ? l.rel_admin_hide_signing_secret
                  : l.rel_admin_reveal_signing_secret,
            ),
          ),
          if (showSecret) SelectableText(revealedSecret!),
        ],
        if (form != null) ...[
          Text(form.title, style: Theme.of(context).textTheme.titleLarge),
          Text(form.warning),
          for (var i = 0; i < form.fields.length; i++)
            if (form.fields[i].choices case final options?)
              DropdownButtonFormField<String>(
                key: ValueKey((form, i)),
                initialValue: values[i],
                decoration: InputDecoration(labelText: form.fields[i].label),
                items: [
                  for (final option in options)
                    DropdownMenuItem(
                      value: option,
                      child: Text(_choiceLabel(option)),
                    ),
                ],
                onChanged: busy
                    ? null
                    : (v) {
                        if (v != null) values[i] = v;
                      },
              )
            else
              TextFormField(
                key: ValueKey((form, i)),
                initialValue: values[i],
                enabled: !busy,
                obscureText: form.fields[i].secret,
                autocorrect: false,
                enableSuggestions: false,
                minLines: form.fields[i].lines,
                maxLines: form.fields[i].lines,
                maxLength: form.fields[i].lines > 1 ? 131072 : 8192,
                decoration: InputDecoration(
                  labelText: form.fields[i].label,
                  counterText: '',
                ),
                onChanged: (v) => values[i] = v,
              ),
          Wrap(
            children: [
              TextButton(
                onPressed: busy
                    ? null
                    : () => setState(() {
                        editor = null;
                        values = [];
                      }),
                child: Text(l.rel_admin_cancel),
              ),
              FilledButton(
                onPressed: busy
                    ? null
                    : () => run(() async {
                        final args = [...values];
                        await form.submit(args);
                        if (mounted) {
                          editor = null;
                          values = [];
                        }
                      }),
                child: Text(l.rel_admin_confirm),
              ),
            ],
          ),
        ] else ...[
          action(l.rel_admin_edit_persona, persona, detail: 'SOUL.md'),
          action(l.rel_admin_portable_profile_bundle, () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ProfileBundleScreen(
                  admin: a,
                  gateway: widget.label,
                  connection: widget.connection,
                  nextGen: widget.nextGen,
                ),
              ),
            );
          }),
          action(
            l.rel_admin_clone_profile,
            () async => edit(
              l.rel_admin_clone_profile,
              l.rel_admin_clone_warning(scope),
              [_Field(l.rel_admin_new_profile_id)],
              (v) async {
                await a.roster.create(v[0], clone: a.name);
                changeRoster(l.rel_admin_cloned(a.name, v[0]));
              },
            ),
          ),
          action(
            a.name == 'default'
                ? l.rel_admin_rename_display_label
                : l.rel_admin_rename_profile,
            () async => edit(
              l.rel_admin_rename_target(a.name),
              a.name == 'default'
                  ? l.rel_admin_rename_label_warning(scope)
                  : l.rel_admin_rename_warning(scope),
              [_Field(l.rel_admin_new_name)],
              (v) async {
                await a.rename(v[0]);
                changeRoster(l.rel_admin_rename_verified);
              },
            ),
          ),
          if (a.name != 'default')
            action(
              l.rel_admin_delete_profile,
              () async => edit(
                l.rel_admin_delete_target(a.name),
                l.rel_admin_delete_profile_warning(scope),
                [_Field(l.rel_admin_profile_id_to_delete)],
                (v) async {
                  if (v[0] != a.name) {
                    throw const WorkspaceException(WorkspaceFailure.mismatch);
                  }
                  final settled = await a.remove();
                  changeRoster(
                    settled
                        ? l.rel_admin_profile_deleted
                        : l.rel_admin_profile_deleted_server_identity_cleanup_is_still_pending,
                  );
                },
              ),
            ),
          action(
            l.rel_admin_export_profile_archive,
            () async => edit(
              l.rel_admin_export_target(a.name),
              l.rel_admin_export_warning(scope),
              [],
              (v) async {
                message = l.rel_admin_archive_on(
                  widget.label,
                  await a.exportProfile(),
                );
              },
            ),
          ),
          action(
            l.rel_admin_import_profile_archive,
            () async => edit(
              l.rel_admin_import_a_trusted_profile,
              l.rel_admin_import_warning(widget.label),
              [
                _Field(l.rel_admin_absolute_archive_path_on_gateway),
                _Field(l.rel_admin_new_profile_id),
              ],
              (v) async {
                await a.importProfile(v[0], v[1]);
                changeRoster(l.rel_admin_imported(v[1]));
              },
            ),
          ),
          const Divider(),
          action(l.rel_admin_messaging_channels, () async {
            channels = await a.channels();
          }),
          for (final c in channels ?? <ProfileChannel>[])
            action(
              c.name,
              () async => channelEditor(c),
              detail: '${c.id} · ${_channelState(c.state)}',
            ),
          action(l.rel_admin_dm_pairing_requests, () async {
            pairs = await a.pairs();
            if (pairs!.isEmpty) {
              message = l.rel_admin_no_pending_or_approved_users;
            }
          }),
          for (final p in pairs ?? <ProfilePair>[])
            if (p.pending &&
                !RegExp(r'^[a-f0-9]{16}$').hasMatch(p.request ?? ''))
              ListTile(
                title: Text(p.user),
                subtitle: Text(
                  l.rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user,
                ),
              )
            else
              action(
                p.pending
                    ? l.rel_admin_approve_user(p.user)
                    : l.rel_admin_revoke_user(p.user),
                () async => edit(
                  p.pending
                      ? l.rel_admin_approve_user(p.user)
                      : l.rel_admin_revoke_user(p.user),
                  p.pending
                      ? l.rel_admin_allow_pair(p.platform, scope)
                      : l.rel_admin_remove_pair(p.platform, scope),
                  [],
                  (v) async {
                    await a.changePair(p);
                    pairs = await a.pairs();
                    message = l.rel_admin_pairing_change_verified;
                  },
                ),
                detail: p.platform,
              ),
          if (setup == null)
            action(
              l.rel_admin_create_telegram_bot_by_qr,
              () async => edit(
                l.rel_admin_create_telegram_bot,
                l.rel_admin_telegram_start(scope),
                [_Field(l.rel_admin_bot_name, value: 'Hermes Agent')],
                (v) async {
                  final result = await a.startTelegram(v[0]);
                  qr = QrImage(
                    QrCode.fromData(
                      data: result.payload,
                      errorCorrectLevel: QrErrorCorrectLevel.M,
                    ),
                  );
                  setup = result;
                },
              ),
            ),
          if (setup case final s?) ...[
            Center(
              child: Semantics(
                label: l.rel_admin_telegram_bot_creation_qr_code,
                child: CustomPaint(
                  size: const Size.square(216),
                  painter: _QR(qr!),
                ),
              ),
            ),
            SelectableText(s.payload),
            Text(l.rel_admin_expires(s.expires.toLocal().toString())),
            action(l.rel_admin_check_telegram_pairing, () async {
              final status = await a.telegramStatus(s);
              if (!status.ready) {
                message = l.rel_admin_waiting_for_telegram;
                return;
              }
              edit(
                l.rel_admin_apply_telegram_bot,
                l.rel_admin_telegram_apply(status.bot, scope),
                [
                  _Field(
                    l.rel_admin_allowed_numeric_user_ids,
                    value: status.user,
                  ),
                ],
                (v) async {
                  final needs = await a.applyTelegram(s, csv(v[0]));
                  setup = null;
                  qr = null;
                  message = needs
                      ? l.rel_admin_saved_restart_still_required
                      : l.rel_admin_saved_gateway_restart_requested;
                },
              );
            }),
            action(l.rel_admin_cancel_telegram_setup, () async {
              await a.cancelTelegram(s);
              setup = null;
              qr = null;
            }),
          ],
          const Divider(),
          action(l.rel_admin_inbound_webhooks, () async {
            hooks = await a.hooks();
          }),
          if (hooks case final h?) ...[
            if (!h.enabled)
              action(
                l.rel_admin_enable_webhook_service,
                () async => edit(
                  l.rel_admin_enable_webhooks,
                  l.rel_admin_hooks_enable(scope),
                  [],
                  (v) async {
                    final needs = await a.enableHooks();
                    hooks = await a.hooks();
                    message = needs
                        ? l.rel_admin_enabled_restart_still_required
                        : l.rel_admin_enabled_restart_requested;
                  },
                ),
              )
            else
              action(l.rel_admin_create_signed_route, () async => newHook()),
            for (final route in h.entries) ...[
              ListTile(
                title: Text(route.name),
                subtitle: SelectableText('${route.signature} · ${route.url}'),
              ),
              Wrap(
                children: [
                  for (final del in [false, true])
                    TextButton(
                      onPressed: busy
                          ? null
                          : () => run(
                              () async => edit(
                                del
                                    ? l.rel_admin_delete_target(route.name)
                                    : route.enabled
                                    ? l.rel_admin_disable_target(route.name)
                                    : l.rel_admin_enable_target(route.name),
                                l.rel_admin_hook_change(route.name, scope),
                                [],
                                (v) async {
                                  await a.changeHook(route, delete: del);
                                  hooks = await a.hooks();
                                  message = l.rel_admin_route_change_verified;
                                },
                              ),
                            ),
                      child: Text(
                        del
                            ? l.rel_admin_delete_route
                            : route.enabled
                            ? l.rel_admin_disable_route
                            : l.rel_admin_enable_route,
                      ),
                    ),
                ],
              ),
            ],
          ],
          const Divider(),
          action(
            l.rel_admin_back_up_entire_agent_home,
            () async => edit(
              l.rel_admin_back_up_entire_agent_home,
              l.rel_admin_backup_warning(widget.label),
              [],
              (v) async {
                completedBackup = null;
                backup = await a.startBackup();
                message = l.rel_admin_backup_started(widget.label);
              },
            ),
          ),
          action(l.rel_admin_transfer_to_a_cloud_agent, () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    ProfileTransferScreen(source: a, label: widget.label),
              ),
            );
          }),
          if (backup case final b?)
            action(l.rel_admin_check_backup_progress, () async {
              if (await a.backupDone(b)) {
                message = l.rel_admin_backup_verified(widget.label, b.archive);
                completedBackup = b;
                backup = null;
              } else {
                message = l.rel_admin_backup_running(widget.label);
              }
            }),
          if (completedBackup case final done?)
            action(
              l.rel_admin_save_backup_to_this_device,
              () async {
                final bytes = await a.backupBytes(done);
                if (!mounted) return;
                a.check();
                final path = await saveProfileFile(
                  title: l.rel_admin_save_sensitive_full_home_archive,
                  filename: 'hermes-backup.zip',
                  check: () {
                    if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
                      throw const WorkspaceException(WorkspaceFailure.stale);
                    }
                    a.check();
                  },
                  bytes: bytes,
                );
                message = path == null
                    ? l.rel_admin_save_cancelled
                    : l.rel_admin_backup_saved;
              },
              detail: l
                  .rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway,
            ),
        ],
      ],
    );
  }
}

class _QR extends CustomPainter {
  _QR(this.image);
  final QrImage image;
  @override
  void paint(Canvas canvas, Size size) {
    final side = image.moduleCount + 8;
    final unit = size.shortestSide / side;
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final pen = Paint()
      ..color = Colors.black
      ..isAntiAlias = false;
    for (var y = 0; y < image.moduleCount; y++) {
      for (var x = 0; x < image.moduleCount; x++) {
        if (image.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH((x + 4) * unit, (y + 4) * unit, unit, unit),
            pen,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QR oldDelegate) => image != oldDelegate.image;
}
