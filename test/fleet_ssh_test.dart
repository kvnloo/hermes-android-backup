import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/fleet_ssh.dart';

void main() {
  test('malformed host names and public keys cannot reach OpenSSH', () {
    for (final h in ['-F', 'host name', 'a,b', 'user@host', '../host']) {
      expect(
        () => SshDestination(h, 22, 'fixture'),
        throwsA(
          isA<FleetSshException>().having(
            (e) => e.reason,
            'reason',
            FleetSshFailure.invalidDestination,
          ),
        ),
      );
    }
    expect(
      () => SshPublicKey.parse('ssh-ed25519 ${'A' * 68}'),
      throwsA(
        isA<FleetSshException>().having(
          (e) => e.reason,
          'reason',
          FleetSshFailure.invalidPublicKey,
        ),
      ),
    );
  });
  test(
    'real OpenSSH: explicit enrollment, direct channel, preview, remote shell and changed-key refusal',
    () async {
      final work = await Directory.systemTemp.createTemp('fleet-ssh-');
      final peers = <Process>[];
      try {
        final identity = File.fromUri(work.uri.resolve('user-key')).path;
        final gen = await Process.run('/usr/bin/ssh-keygen', [
          '-q',
          '-t',
          'ed25519',
          '-N',
          '',
          '-f',
          identity,
        ]);
        expect(gen.exitCode, 0);
        Future<({SshDestination dst, SshPublicKey key, String fingerprint})>
        peer() async {
          final p = await Process.start(
            Platform.environment['ARES_SSH_FIXTURE']!,
            ['$identity.pub'],
          );
          peers.add(p);
          unawaited(p.stderr.drain<void>());
          final line = await p.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .first
              .timeout(const Duration(seconds: 5));
          final data = jsonDecode(line) as Map;
          return (
            dst: SshDestination('127.0.0.1', data['port'] as int, 'fixture'),
            key: SshPublicKey.parse(data['key'] as String),
            fingerprint: data['fingerprint'] as String,
          );
        }

        final a = await peer(), b = await peer();
        final ssh = FleetSsh(Directory.fromUri(work.uri.resolve('pins/')));
        expect(await ssh.enrolled(a.dst), isNull);
        expect(a.key.fingerprint, a.fingerprint);
        await expectLater(
          ssh.readLoopback(
            a.dst,
            preview: false,
            port: 9119,
            identity: identity,
            healthMessage: (port) =>
                'Gateway is responding on remote loopback port $port.',
          ),
          throwsA(
            isA<FleetSshException>().having(
              (e) => e.reason,
              'reason',
              FleetSshFailure.confirmHostKey,
            ),
          ),
        );
        await ssh.enroll(a.dst, a.key);
        await ssh.enroll(a.dst, a.key);
        expect(
          await ssh.readLoopback(
            a.dst,
            preview: false,
            port: 9119,
            identity: identity,
            healthMessage: (port) =>
                'Gateway is responding on remote loopback port $port.',
          ),
          'Gateway is responding on remote loopback port 9119.',
        );
        expect(
          await ssh.readLoopback(
            a.dst,
            preview: true,
            port: 3000,
            identity: identity,
            healthMessage: (port) =>
                'Gateway is responding on remote loopback port $port.',
          ),
          'preview-fixture',
        );
        final shell = await ssh.shell(a.dst, identity: identity);
        final out = shell.stdout.transform(utf8.decoder).join();
        final errors = shell.stderr.drain<void>();
        shell.stdin.writeln('sample input');
        await shell.stdin.flush();
        expect(
          await out.timeout(const Duration(seconds: 8)),
          contains('fixture-shell: sample input'),
        );
        expect(await shell.exitCode, 0);
        await errors;
        await expectLater(
          ssh.enroll(a.dst, b.key),
          throwsA(
            isA<FleetSshException>().having(
              (e) => e.reason,
              'reason',
              FleetSshFailure.differentKeyPinned,
            ),
          ),
        );
        expect((await ssh.enrolled(a.dst))!.fingerprint, a.fingerprint);
        // The peer presenting key B is genuinely reached with pin A. A command
        // line assertion alone cannot prove OpenSSH checked the server key.
        await ssh.enroll(b.dst, a.key);
        await expectLater(
          ssh.readLoopback(
            b.dst,
            preview: false,
            port: 9119,
            identity: identity,
            healthMessage: (port) =>
                'Gateway is responding on remote loopback port $port.',
          ),
          throwsA(
            isA<FleetSshException>().having(
              (e) => e.reason,
              'reason',
              FleetSshFailure.connectionRefused,
            ),
          ),
        );
      } finally {
        for (final p in peers) {
          p.kill();
          await p.exitCode;
        }
        await work.delete(recursive: true);
      }
    },
    skip: Platform.environment['ARES_SSH_FIXTURE'] == null
        ? 'Build the disposable Go peer and set ARES_SSH_FIXTURE to its absolute path.'
        : false,
  );
}
