import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/workspace_worker_peer.dart';

Matcher fails(WorkspaceFailure why) =>
    throwsA(isA<WorkspaceException>().having((e) => e.reason, 'reason', why));

void main() {
  for (final classic in [true, false]) {
    group(classic ? 'Classic' : 'NextGen', () {
      late WorkerPeer peer;
      late RemoteWorkspaceOwner owner;
      late WorkspacePane pane, rosterPane;
      late Future<void> Function() attach;
      late void Function() close;
      Future<WorkspaceTarget> parent() =>
          pane.bind(owner.route(storedSessionId: 'stored-A'));
      Future<WorkspaceTarget> host() => rosterPane.bind(owner.route());
      setUp(() async {
        peer = await WorkerPeer.start();
        if (classic) {
          final g = DesktopGatewayClient.fromConnection(peer.connection)
            ..setReconnectAllowed(false);
          owner = g.workspace;
          attach = () async {
            await g.resumeSubmittedSession(
              localSessionId: 'local',
              storedSessionId: 'stored-A',
            );
          };
          close = g.close;
        } else {
          final g = NextGenGateway(peer.connection);
          owner = g.workspace;
          attach = () async {
            await g.connected();
            await g.call('session.resume', {
              'session_id': 'stored-A',
              'omit_messages': true,
            });
          };
          close = g.dispose;
        }
        pane = owner.pane();
        rosterPane = owner.pane();
      });
      tearDown(() async {
        pane.close();
        rosterPane.close();
        close();
        await peer.close();
      });

      test(
        'profile counts without attaching; target only the selected child of its attached parent',
        () async {
          final roster = await host();
          final cold = await roster.workerGroups();
          expect(
            cold.map(
              (g) => (
                g.route.storedSessionId,
                g.children,
                g.background,
                g.attached,
              ),
            ),
            [('stored-A', 2, 0, false), ('stored-B', 1, 3, false)],
          );
          expect(peer.calls('subagent.roster'), [
            {'profile': 'work'},
          ]);
          await expectLater(
            cold.first.bind(pane),
            fails(WorkspaceFailure.unbound),
          );
          await expectLater(
            (await parent()).workers(),
            fails(WorkspaceFailure.unbound),
          );
          expect(peer.calls('session.resume'), isEmpty);
          expect(peer.calls('subagent.list'), isEmpty);
          await attach();
          // A previously read, unattached group cannot borrow the new binding.
          await expectLater(
            cold.first.bind(pane),
            fails(WorkspaceFailure.unbound),
          );
          final groups = await roster.workerGroups();
          final workers = await (await groups.first.bind(pane)).workers();
          expect(workers.map((w) => w.id), ['first', 'second']);
          expect(peer.calls('subagent.steer'), isEmpty);
          expect(
            await workers.last.steer('Use the second fixture'),
            WorkerSteerReceipt.queued,
          );
          expect(peer.calls('subagent.list'), [
            for (var i = 0; i < 2; i++)
              {'session_id': 'runtime-A', 'profile': 'work'},
          ]);
          expect(peer.calls('subagent.steer'), [
            {
              'profile': 'work',
              'session_id': 'runtime-A',
              'subagent_id': 'second',
              'text': 'Use the second fixture',
            },
          ]);
          expect(peer.calls('session.steer'), isEmpty);
          expect(peer.calls('prompt.submit'), isEmpty);
          expect(peer.sockets, hasLength(1));
        },
      );

      test(
        'vanished, replaced or no-longer-accepting child and changed parent cannot receive a steer',
        () async {
          await attach();
          final target = await parent();
          final row = (await target.workers()).last;
          final original = peer.rows.removeLast();
          await expectLater(row.steer('gone'), fails(WorkspaceFailure.stale));
          peer.rows.add({...original, 'started_at': 42});
          await expectLater(row.steer('reused'), fails(WorkspaceFailure.stale));
          peer.rows.last = {...original, 'accepting_steer': false};
          await expectLater(row.steer('closed'), fails(WorkspaceFailure.stale));
          final closed = (await target.workers()).last;
          await expectLater(
            closed.steer('closed'),
            fails(WorkspaceFailure.unbound),
          );
          peer.rows.last = {...original, 'status': 'completed'};
          await expectLater(
            row.steer('terminal'),
            fails(WorkspaceFailure.stale),
          );
          peer.rows.last = original;
          await expectLater(row.steer('  '), fails(WorkspaceFailure.invalid));
          peer.rowProfile = 'different';
          await expectLater(
            row.steer('wrong profile'),
            fails(WorkspaceFailure.mismatch),
          );
          expect(peer.calls('subagent.steer'), isEmpty);
        },
      );

      test(
        'malformed or duplicate identities fail closed; no transcript or fallback IDs',
        () async {
          await attach();
          final target = await parent();
          for (final row in [
            {
              'child_session_id': 'history',
              'delegation_id': 'delegation',
              'task_index': 0,
            },
            {'subagent_id': ' first '},
            {'subagent_id': 'first'},
          ]) {
            peer.rows.add(row);
            await expectLater(
              target.workers(),
              fails(WorkspaceFailure.invalid),
            );
            peer.rows.removeLast();
          }
          peer.replies['subagent.roster'] = {
            'result': {
              'sessions': [
                {'session_id': 'stored-A', 'subagents': -1, 'background': 0},
              ],
            },
          };
          await expectLater(
            (await host()).workerGroups(),
            fails(WorkspaceFailure.invalid),
          );
          expect(peer.calls('subagent.steer'), isEmpty);
        },
      );

      test(
        'refusal, unsupported, denial and malformed acknowledgement never redirect or replay',
        () async {
          await attach();
          final row = (await (await parent()).workers()).last;
          peer.receipt = 'rejected';
          expect(await row.steer('x'), WorkerSteerReceipt.rejected);
          for (final (code, reason) in [
            (-32601, WorkspaceFailure.unsupported),
            (403, WorkspaceFailure.denied),
          ]) {
            peer.replies['subagent.steer'] = {
              'error': {'code': code, 'message': 'not for UI'},
            };
            await expectLater(row.steer('x'), fails(reason));
          }
          for (final result in [
            {'status': 'queued', 'subagent_id': 'first', 'text': 'x'},
            {'status': 'queued', 'subagent_id': 'second', 'text': 'different'},
            {'status': 'delivered', 'subagent_id': 'second', 'text': 'x'},
          ]) {
            peer.replies['subagent.steer'] = {'result': result};
            await expectLater(row.steer('x'), fails(WorkspaceFailure.invalid));
          }
          expect(peer.calls('subagent.steer'), hasLength(6));
          expect(peer.calls('session.steer'), isEmpty);
        },
      );

      test(
        'a second host with colliding profile, parent and child IDs cannot claim the selection',
        () async {
          await attach();
          final group = (await (await host()).workerGroups()).first;
          final row = (await (await group.bind(pane)).workers()).last;
          final twin = await WorkerPeer.start();
          final other = NextGenGateway(twin.connection);
          final otherPane = other.workspace.pane();
          try {
            await other.connected();
            await other.call('session.resume', {'session_id': 'stored-A'});
            await expectLater(
              group.bind(otherPane),
              fails(WorkspaceFailure.mismatch),
            );
            expect(await row.steer('original only'), WorkerSteerReceipt.queued);
            expect(peer.calls('subagent.steer'), hasLength(1));
            expect(twin.calls('subagent.list'), isEmpty);
            expect(twin.calls('subagent.steer'), isEmpty);
          } finally {
            otherPane.close();
            other.dispose();
            await twin.close();
          }
        },
      );

      test(
        'held preflight across an ABA runtime rebind sends nothing',
        () async {
          await attach();
          final group = (await (await host()).workerGroups()).first;
          final row = (await (await group.bind(pane)).workers()).last;
          peer.holdMethod = 'subagent.list';
          final flight = expectLater(
            row.steer('held'),
            fails(WorkspaceFailure.stale),
          );
          await peer.held.future.timeout(const Duration(seconds: 5));
          peer.runtime = 'new';
          await attach();
          peer.runtime = 'runtime-A';
          await attach();
          peer.release.complete();
          await flight;
          await expectLater(group.bind(pane), fails(WorkspaceFailure.stale));
          expect(peer.calls('subagent.steer'), isEmpty);
        },
      );

      test(
        'late queued acknowledgement after same-ID account edit is not success or retried',
        () async {
          await attach();
          final row = (await (await parent()).workers()).last;
          peer.holdMethod = 'subagent.steer';
          final flight = expectLater(
            row.steer('only once'),
            fails(WorkspaceFailure.stale),
          );
          await peer.held.future.timeout(const Duration(seconds: 5));
          ConnectionMutationBarrier.begin([peer.connection.id]).release();
          peer.release.complete();
          await flight;
          expect(peer.calls('subagent.steer'), hasLength(1));
          expect(peer.calls('session.steer'), isEmpty);
        },
      );
    });
  }
}
