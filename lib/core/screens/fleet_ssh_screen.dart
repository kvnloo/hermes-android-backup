import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/l10n.dart';
import '../services/fleet_ssh.dart';

/// Render structured service refusals without giving the transport a context.
String fleetSshFailureMessage(
  AppLocalizations l10n,
  FleetSshFailure reason,
) => switch (reason) {
  FleetSshFailure.invalidDestination => l10n.rel_ops_ssh_invalid_destination,
  FleetSshFailure.publicKeyRequired => l10n.rel_ops_ssh_public_key_required,
  FleetSshFailure.invalidPublicKey => l10n.rel_ops_ssh_invalid_public_key,
  FleetSshFailure.invalidSavedKey => l10n.rel_ops_ssh_invalid_saved_key,
  FleetSshFailure.enrollmentUnverified =>
    l10n.rel_ops_ssh_enrollment_unverified,
  FleetSshFailure.differentKeyPinned => l10n.rel_ops_ssh_different_key_pinned,
  FleetSshFailure.openSshUnavailable => l10n.rel_ops_ssh_open_ssh_unavailable,
  FleetSshFailure.confirmHostKey => l10n.rel_ops_ssh_confirm_host_key,
  FleetSshFailure.absoluteIdentityRequired =>
    l10n.rel_ops_ssh_absolute_identity_required,
  FleetSshFailure.invalidRemotePort => l10n.rel_ops_ssh_invalid_remote_port,
  FleetSshFailure.previewTooLarge => l10n.rel_ops_ssh_preview_too_large,
  FleetSshFailure.connectionRefused => l10n.rel_ops_ssh_connection_refused,
  FleetSshFailure.httpNotOk => l10n.rel_ops_ssh_http_not_ok,
  FleetSshFailure.encodedResponse => l10n.rel_ops_ssh_encoded_response,
  FleetSshFailure.previewTypeUnsupported =>
    l10n.rel_ops_ssh_preview_type_unsupported,
  FleetSshFailure.healthUnconfirmed => l10n.rel_ops_ssh_health_unconfirmed,
  FleetSshFailure.enrollHostKeyFirst => l10n.rel_ops_ssh_enroll_host_key_first,
};

/// SSH is deliberately separate from HTTP saved accounts. No API key, bearer,
/// Portal identity, Webapp SSH auto-connect or local shell fallback is used.
class FleetSshScreen extends StatefulWidget {
  const FleetSshScreen({super.key});
  @override
  State<FleetSshScreen> createState() => _FleetSshScreenState();
}

class _FleetSshScreenState extends State<FleetSshScreen> {
  final host = TextEditingController(),
      user = TextEditingController(),
      port = TextEditingController(text: '22'),
      keyInput = TextEditingController(),
      identity = TextEditingController(),
      remotePort = TextEditingController(text: '9119'),
      command = TextEditingController();
  bool busy = false;
  String message = '', output = '';
  Process? shell;
  @override
  void dispose() {
    shell?.kill();
    for (final c in [
      host,
      user,
      port,
      keyInput,
      identity,
      remotePort,
      command,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<bool> confirm(String title, String detail) async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(title),
          content: SelectableText(detail),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text(c.sharedL10n.rel_ops_ssh_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: Text(c.sharedL10n.rel_ops_ssh_confirm),
            ),
          ],
        ),
      ) ==
      true;
  Future<void> action(String mode) async {
    if (busy || shell != null) return;
    setState(() {
      busy = true;
      message = '';
      output = '';
    });
    try {
      final dest = SshDestination(
        host.text.trim(),
        int.tryParse(port.text) ?? 0,
        user.text.trim(),
      );
      final id = identity.text.trim().isEmpty ? null : identity.text.trim();
      final servicePort = int.tryParse(remotePort.text) ?? 0;
      final home = await getApplicationSupportDirectory();
      if (!mounted) return;
      final client = FleetSsh(Directory.fromUri(home.uri.resolve('ares-ssh/')));
      if (mode == 'enroll') {
        final key = SshPublicKey.parse(keyInput.text);
        if (!await confirm(
              context.sharedL10n.rel_ops_ssh_pin_title,
              context.sharedL10n.rel_ops_ssh_pin_detail(
                dest.label,
                key.fingerprint,
              ),
            ) ||
            !mounted) {
          return;
        }
        await client.enroll(dest, key);
        if (mounted) {
          setState(
            () => message = context.sharedL10n.rel_ops_ssh_host_key_pinned,
          );
        }
        return;
      }
      final key = await client.enrolled(dest);
      if (!mounted) return;
      if (key == null) {
        throw const FleetSshException(FleetSshFailure.enrollHostKeyFirst);
      }
      final l10n = context.sharedL10n;
      final detail = mode == 'shell'
          ? l10n.rel_ops_ssh_shell_detail
          : l10n.rel_ops_ssh_read_detail(
              mode == 'preview' ? '/' : '/api/health',
              servicePort,
            );
      if (!await confirm(
            l10n.rel_ops_ssh_connect_title(dest.label),
            l10n.rel_ops_ssh_connect_detail(
              detail,
              key.fingerprint,
              id == null
                  ? l10n.rel_ops_ssh_agent_auth
                  : l10n.rel_ops_ssh_identity_auth,
            ),
          ) ||
          !mounted) {
        return;
      }
      if (mode != 'shell') {
        final s = await client.readLoopback(
          dest,
          preview: mode == 'preview',
          port: servicePort,
          healthMessage: context.sharedL10n.rel_ops_ssh_gateway_responding,
          identity: id,
        );
        if (mounted) setState(() => output = s);
        return;
      }
      final p = await client.shell(dest, identity: id);
      if (!mounted) {
        p.kill();
        return;
      }
      setState(() => shell = p);
      final drain = p.stderr.drain<void>();
      await for (final s in p.stdout.transform(
        const Utf8Decoder(allowMalformed: true),
      )) {
        if (!mounted || !identical(shell, p)) continue;
        final text = (output + s).replaceAll(
          RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]'),
          '',
        );
        setState(
          () => output = text.length > 32768
              ? text.substring(text.length - 32768)
              : text,
        );
      }
      final rc = await p.exitCode;
      await drain;
      if (mounted) {
        setState(
          () => message = rc == 0
              ? context.sharedL10n.rel_ops_ssh_session_closed
              : context.sharedL10n.rel_ops_ssh_session_unclean,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => message = e is FleetSshException
              ? fleetSshFailureMessage(context.sharedL10n, e.reason)
              : context.sharedL10n.rel_ops_ssh_operation_failed,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
          shell = null;
        });
      }
    }
  }

  Widget field(TextEditingController c, String label, {bool multi = false}) =>
      TextField(
        controller: c,
        enabled: !busy,
        maxLines: multi ? 2 : 1,
        autocorrect: false,
        decoration: InputDecoration(labelText: label),
      );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.sharedL10n.rel_ops_ssh_title)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!FleetSsh.supported)
          Text(context.sharedL10n.rel_ops_ssh_unsupported)
        else ...[
          field(host, context.sharedL10n.rel_ops_ssh_host),
          field(port, context.sharedL10n.rel_ops_ssh_port),
          field(user, context.sharedL10n.rel_ops_ssh_user),
          field(identity, context.sharedL10n.rel_ops_ssh_identity),
          field(
            keyInput,
            context.sharedL10n.rel_ops_ssh_public_key,
            multi: true,
          ),
          TextButton(
            onPressed: busy ? null : () => action('enroll'),
            child: Text(context.sharedL10n.rel_ops_ssh_review_key),
          ),
          const Divider(),
          field(remotePort, context.sharedL10n.rel_ops_ssh_remote_port),
          Wrap(
            children: [
              TextButton(
                onPressed: busy ? null : () => action('health'),
                child: Text(context.sharedL10n.rel_ops_ssh_check_gateway),
              ),
              TextButton(
                onPressed: busy ? null : () => action('preview'),
                child: Text(context.sharedL10n.rel_ops_ssh_preview_source),
              ),
              TextButton(
                onPressed: busy ? null : () => action('shell'),
                child: Text(context.sharedL10n.rel_ops_ssh_open_shell),
              ),
            ],
          ),
          if (shell case final p?) ...[
            TextField(
              controller: command,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: context.sharedL10n.rel_ops_ssh_shell_line,
              ),
              onSubmitted: (s) {
                if (identical(shell, p)) {
                  p.stdin.writeln(s);
                  p.stdin.flush().catchError((Object _) {
                    p.kill();
                  });
                  command.clear();
                }
              },
            ),
            TextButton(
              onPressed: () => p.kill(),
              child: Text(context.sharedL10n.rel_ops_ssh_disconnect),
            ),
          ],
          if (busy && shell == null) const LinearProgressIndicator(),
          if (message.isNotEmpty) Text(message),
          if (output.isNotEmpty) SelectableText(output),
        ],
      ],
    ),
  );
}
