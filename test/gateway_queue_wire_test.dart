import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/workspace_worker_peer.dart';
import 'support/queue_ledger.dart';

void main() {
  late WorkerPeer peer;
  late QueueLedger ledger;
  final closes = <void Function()>[];
  Future<({WorkspaceTarget target, WorkspacePane pane})> attach(
    bool classic,
  ) async {
    late RemoteWorkspaceOwner owner;
    if (classic) {
      final g = DesktopGatewayClient.fromConnection(peer.connection)
        ..setReconnectAllowed(false);
      closes.add(g.close);
      owner = g.workspace;
      await g.resumeSubmittedSession(
        localSessionId: 'local',
        storedSessionId: QueueLedger.sid,
      );
    } else {
      final g = NextGenGateway(peer.connection);
      closes.add(g.dispose);
      owner = g.workspace;
      await g.connected();
      await g.call('session.resume', {
        'session_id': QueueLedger.sid,
        'omit_messages': true,
      });
    }
    final pane = owner.pane();
    closes.add(pane.close);
    return (
      target: await pane.bind(owner.route(storedSessionId: QueueLedger.sid)),
      pane: pane,
    );
  }

  setUp(() async {
    peer = await WorkerPeer.start();
    ledger = QueueLedger(peer);
  });
  tearDown(() async {
    for (final close in closes.reversed) {
      close();
    }
    closes.clear();
    await peer.close();
  });
  test(
    'both clients share FIFO; edit moves to tail, remove and steer name the exact admission',
    () async {
      ledger.add('first');
      ledger.add('second');
      final a = (await attach(true)).target, b = (await attach(false)).target;
      final seen = Completer<void>();
      final off = b.watchQueue(() {
        if (!seen.isCompleted) seen.complete();
      });
      addTearDown(off);
      var queue = await a.busyQueue();
      await queue.enqueue('third', 'client-intent');
      await seen.future.timeout(const Duration(seconds: 3));
      final before = await b.busyQueue();
      expect(before.entries.map((r) => r.text), ['first', 'second', 'third']);
      expect(before.entries.last.inputId, 'client-intent');
      expect(before.entries.last.id, isNot('client-intent'));
      await before.entries.first.replace('first, edited', 'new-intent');
      queue = await a.busyQueue();
      expect(queue.entries.map((r) => r.text), [
        'second',
        'third',
        'first, edited',
      ]);
      await queue.entries.first.remove();
      await queue.entries.last.steer();
      expect((await b.busyQueue()).entries.map((r) => (r.text, r.state)), [
        ('third', 'queued'),
        ('first, edited', 'started'),
      ]);
      expect(peer.calls('prompt.cancel'), [
        {
          'admission_id': 'host-2',
          'session_id': QueueLedger.sid,
          'profile': 'work',
        },
      ]);
      expect(peer.calls('prompt.receipt'), hasLength(4));
      expect(peer.calls('session.interrupt'), isEmpty);
      expect(peer.calls('prompt.submit'), hasLength(1));
    },
  );
  test(
    'fresh socket sees unknown after restart; discard carries lost generation, never submits',
    () async {
      ledger.add('lost', state: 'unknown');
      ledger.add('behind it');
      final first = await attach(true);
      expect((await first.target.busyQueue()).paused, isTrue);
      first.pane.close();
      final fresh = (await attach(false)).target;
      final queue = await fresh.busyQueue();
      expect(queue.paused, isTrue);
      await queue.entries.first.discardUnknown();
      expect(peer.calls('prompt.resolve_unknown'), [
        {
          'session_id': QueueLedger.sid,
          'admission_id': 'host-1',
          'execution_generation': 3,
          'profile': 'work',
        },
      ]);
      expect((await fresh.busyQueue()).entries.single.text, 'behind it');
      expect(peer.calls('prompt.submit'), isEmpty);
    },
  );
  test(
    'concurrent claim blocks edit; close during preflight emits no removal',
    () async {
      ledger.add('original');
      final a = await attach(true);
      final rows = (await a.target.busyQueue()).entries;
      ledger.rows.first['status'] = 'started';
      await expectLater(
        rows.single.replace('late', 'edit-1'),
        throwsA(isA<WorkspaceException>()),
      );
      expect(peer.calls('prompt.replace_queued'), isEmpty);
      ledger.rows.first['status'] = 'queued';
      peer.holdMethod = 'session.resume';
      final removal = expectLater(
        rows.single.remove(),
        throwsA(isA<WorkspaceException>()),
      );
      await peer.held.future;
      a.pane.invalidate();
      peer.release.complete();
      await removal;
      expect(peer.calls('prompt.cancel'), isEmpty);
    },
  );
  test(
    'socket closes after durable admission but before ACK: reopen never resubmits',
    () async {
      final a = await attach(true);
      final q = await a.target.busyQueue();
      peer.holdMethod = 'prompt.submit';
      peer.dropHeldReply = true;
      final lost = expectLater(
        q.enqueue('accepted before disconnect', 'pending-client'),
        throwsA(isA<WorkspaceException>()),
      );
      await peer.held.future;
      expect(ledger.rows.single['input_id'], 'pending-client');
      await peer.sockets.single.close();
      peer.release.complete();
      await lost;
      final next = await attach(false);
      expect((await next.target.busyQueue()).entries.single.id, 'host-1');
      expect(peer.calls('prompt.submit'), hasLength(1));
    },
  );

  test(
    'malformed mutation reply never replays; reopening physically reads committed owner row',
    () async {
      final a = await attach(true);
      final q = await a.target.busyQueue();
      ledger.unknownAck = true;
      await expectLater(
        q.enqueue('uncertain', 'client-A'),
        throwsA(isA<WorkspaceException>()),
      );
      a.pane.close();
      final b = await attach(false);
      final restored = await b.target.busyQueue();
      expect(restored.entries.single.inputId, 'client-A');
      expect(peer.calls('prompt.submit'), hasLength(1));
      ledger.rows.single['ref'] = {
        'session_id': 'sibling',
        'profile_id': QueueLedger.profile,
      };
      await expectLater(
        b.target.busyQueue(),
        throwsA(isA<WorkspaceException>()),
      );
    },
  );
}
