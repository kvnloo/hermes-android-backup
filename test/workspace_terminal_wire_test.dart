import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/device_terminal.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

Future<void> until(bool Function() done, [String Function()? detail]) async {
  for (var i = 0; i < 200; i++) {
    if (done()) return;
    await Future<void>.delayed(const Duration(milliseconds: 15));
  }
  final extra = detail?.call();
  stderr.writeln('TERMINAL-TIMEOUT ${extra ?? ''}');
  fail(
    'Timed out waiting for fixture output${extra == null ? '' : ': $extra'}',
  );
}

void main() {
  final python = Platform.environment['ARES_TERMINAL_FIXTURE_PYTHON'];
  final helper = Platform.environment['ARES_TERMINAL_FIXTURE_HELPER'];
  test(
    'local helper is a PTY, resizes, retains variables, and dies on close',
    () async {
      final home = await Directory.systemTemp.createTemp('terminal-local-');
      addTearDown(() => home.delete(recursive: true));
      final t = await LocalTerminal.startHelper(
        File(helper!),
        home,
        check: () {},
      );
      var data = '';
      t.output
          .transform(const Utf8Decoder(allowMalformed: true))
          .listen((s) => data += s);
      t.resize(85, 32);
      t.write(
        'stty -echo; test -t 0 && STAMP=local; printf "ready:%s\\n" "\$STAMP"\r',
      );
      await until(() => data.contains('ready:local'));
      t.write('printf "size:%s:%s\\n" "\$STAMP" "\$(stty size)"\r');
      await until(() => data.contains('size:local:32 85'));
      await t.close();
    },
    skip: helper == null ? 'Compile disposable native PTY helper first' : false,
  );
  group(
    'authenticated disposable PTYs',
    () {
      late Process peer;
      late Map info;
      final errors = StringBuffer();
      setUp(() async {
        peer = await Process.start(
          python!,
          ['tool/terminal_fixture/peer.py'],
          environment: {
            'PATH': '/usr/bin:/bin',
            'TMPDIR': Directory.systemTemp.path,
          },
          includeParentEnvironment: false,
        );
        peer.stderr.transform(utf8.decoder).listen(errors.write);
        info =
            jsonDecode(
                  await peer.stdout
                      .transform(utf8.decoder)
                      .transform(const LineSplitter())
                      .first
                      .timeout(const Duration(seconds: 8)),
                )
                as Map;
      });
      tearDown(() {
        if (errors.isNotEmpty) {
          fail('Disposable terminal peer reported: $errors');
        }
      });
      tearDown(() async {
        await peer.stdin.close();
        await peer.exitCode.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            peer.kill();
            return peer.exitCode;
          },
        );
      });
      test(
        'SSH pins the independent key before authenticating; PTY input and resize',
        () async {
          Future<VerifiedSshTerminal> open(String pin) =>
              VerifiedSshTerminal.open(
                host: '127.0.0.1',
                port: info['ssh'] as int,
                user: 'fixture',
                fingerprint: pin,
                password: info['secret'] as String,
                check: () {},
              );
          await expectLater(open('SHA256:${'A' * 43}'), throwsA(anything));
          final terminal = await open(info['pin'] as String);
          addTearDown(terminal.close);
          var out = '';
          terminal.output
              .transform(const Utf8Decoder(allowMalformed: true))
              .listen((s) => out += s);
          await until(() => out.contains('tty-ready'));
          terminal.resize(82, 35);
          terminal.write('hello\r');
          await until(() => out.contains('1:35 82:hello'));
        },
      );
      for (final classic in [true, false]) {
        test(
          '${classic ? 'Classic' : 'NextGen'} verified PTY resume, replay, close and process isolation',
          () async {
            final port = info['http'] as int;
            final c = SavedConnection(
              id: 'fixture',
              label: 'test',
              host: '127.0.0.1',
              port: port,
              apiKey: 'unused',
              dashboardPortOverride: port,
              dashboardPrefix: '/prefix',
              dashboardUsername: 'fixture',
              dashboardPassword: info['secret'] as String,
              gatewayProfile: 'work',
              desktopGatewayUrl: 'http://127.0.0.1:$port/prefix',
            );
            final RemoteWorkspaceOwner owner;
            if (classic) {
              final g = DesktopGatewayClient.fromConnection(c);
              g.setReconnectAllowed(false);
              addTearDown(g.close);
              owner = g.workspace;
              await g.resumeSubmittedSession(
                localSessionId: 'local',
                storedSessionId: 'stored',
              );
            } else {
              final g = NextGenGateway(c);
              addTearDown(g.dispose);
              owner = g.workspace;
              await g.connected();
              await g.call('session.resume', {
                'session_id': 'stored',
                'omit_messages': true,
              });
            }
            final p = owner.pane();
            addTearDown(p.close);
            final t = await p.bind(owner.route(storedSessionId: 'stored'));
            final terminal = t.terminal(checkPane: () {});
            addTearDown(terminal.dispose);
            var text = '', resets = 0;
            Future<void> dial() => terminal.connect(
              output: (s) => text += s,
              reset: (_) {
                text = '';
                resets++;
              },
              disconnected: (_) {},
            );
            await dial();
            await until(() => text.contains('tty-ready'), () => 'text=$text');
            terminal.resize(93, 31);
            terminal.write('first\r');
            await until(
              () => text.contains('1:31 93:first'),
              () => 'text=$text',
            );
            terminal.detach();
            await dial();
            expect(resets, 1);
            await until(
              () => text.contains('1:31 93:first'),
              () => 'replay=$text',
            );
            terminal.write('second\r');
            await until(
              () => text.contains('2:31 93:second'),
              () => 'second=$text',
            );
            expect('1:31 93:first'.allMatches(text).length, 1);
            await terminal.closeShell();
            expect(terminal.retained, false);
            await expectLater(dial(), throwsA(isA<WorkspaceException>()));
            final changes = <ProcessChange>[];
            final stop = t.watchProcesses(changes.add);
            addTearDown(stop);
            expect(await t.processSnapshot(), [
              (id: 'proc-1', tail: 'snapshot', status: 'running'),
            ]);
            await until(() => changes.length >= 2);
            expect(changes, [
              (id: 'proc-1', chunk: 'live'),
              (id: 'proc-1', chunk: null),
            ]);
            ConnectionMutationBarrier.begin(['fixture']).release();
            expect(
              () => terminal.write('never'),
              throwsA(isA<WorkspaceException>()),
            );
          },
        );
      }
    },
    skip: python == null
        ? 'Set ARES_TERMINAL_FIXTURE_PYTHON to the isolated fixture interpreter'
        : false,
  );
}
