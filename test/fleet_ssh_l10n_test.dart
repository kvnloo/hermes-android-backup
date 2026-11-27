import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';
import 'package:hermes_android/core/screens/fleet_ssh_screen.dart';
import 'package:hermes_android/core/services/fleet_ssh.dart';
import 'package:hermes_android/l10n/app_localizations_en.dart';

void main() {
  test('all structured SSH refusals render exact original English', () {
    final l10n = AppLocalizationsEn();
    const expected = {
      FleetSshFailure.invalidDestination: 'Invalid SSH host, port or user.',
      FleetSshFailure.publicKeyRequired:
          'An OpenSSH Ed25519 public host key is required.',
      FleetSshFailure.invalidPublicKey: 'Invalid Ed25519 host key.',
      FleetSshFailure.invalidSavedKey: 'Invalid saved host key.',
      FleetSshFailure.enrollmentUnverified:
          'Could not verify host-key enrollment.',
      FleetSshFailure.differentKeyPinned:
          'A different key is already pinned. Verify the change separately.',
      FleetSshFailure.openSshUnavailable: 'System OpenSSH is unavailable.',
      FleetSshFailure.confirmHostKey: 'Confirm the host key before connecting.',
      FleetSshFailure.absoluteIdentityRequired:
          'Select an absolute identity file.',
      FleetSshFailure.invalidRemotePort: 'Invalid remote port.',
      FleetSshFailure.previewTooLarge: 'Preview exceeds the 64 KiB limit.',
      FleetSshFailure.connectionRefused:
          'SSH connection refused. Check the enrolled host key, identity and service.',
      FleetSshFailure.httpNotOk: 'The remote service did not return HTTP 200.',
      FleetSshFailure.encodedResponse:
          'Encoded responses are not supported by this preview.',
      FleetSshFailure.previewTypeUnsupported:
          'Only text and HTML source can be previewed.',
      FleetSshFailure.healthUnconfirmed:
          'The service did not confirm gateway health.',
      FleetSshFailure.enrollHostKeyFirst: 'Enroll the host’s public key first.',
    };
    expect(expected.keys, unorderedEquals(FleetSshFailure.values));
    for (final entry in expected.entries) {
      expect(fleetSshFailureMessage(l10n, entry.key), entry.value);
    }
    expect(
      l10n.rel_ops_ssh_gateway_responding(9119),
      'Gateway is responding on remote loopback port 9119.',
    );
    expect(
      l10n.rel_ops_ssh_pin_detail('user@host:22', 'SHA256:fixture'),
      'user@host:22\nSHA256:fixture\nCompare this fingerprint with the host administrator over an independent channel. No connection will be made.',
    );
    expect(
      l10n.rel_ops_ssh_read_detail('/api/health', 9119),
      'Read /api/health on remote 127.0.0.1:9119 through an SSH channel.',
    );
    expect(
      l10n.rel_ops_ssh_connect_detail(
        l10n.rel_ops_ssh_shell_detail,
        'SHA256:fixture',
        l10n.rel_ops_ssh_agent_auth,
      ),
      'Open an interactive login shell.\nSHA256:fixture\nAuthenticate with your SSH agent.',
    );
  });

  for (final delegated in [true, false]) {
    testWidgets('SSH renders with generated delegate: $delegated', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: delegated
              ? AppLocalizations.localizationsDelegates
              : null,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FleetSshScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Verified SSH'), findsOneWidget);
      if (FleetSsh.supported) {
        expect(find.text('SSH host'), findsOneWidget);
        expect(find.text('Review host key'), findsOneWidget);
      } else {
        expect(
          find.text(AppLocalizationsEn().rel_ops_ssh_unsupported),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
