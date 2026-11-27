// The Kanban dock after context compression (review of deb6f558, PROBE
// A-C1 NextGen and A-C2 Classic). The gateway rotates a chat's stored
// session id when it compresses (tui_gateway/session_compression.py,
// `_sync_session_key_after_compress`) and says so with a `session.info`
// whose `stored_session_id` is the continuation. Cards made from then on
// carry the continuation id; cards made before carry the old one. The dock
// must count both as this chat's.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/kanban_dock.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_kanban_source.dart';
import 'support/kanban_dock_review_harness.dart';

/// NextGen: a turn after which the gateway rotated the chat's stored id,
/// then the agent created a parent card and a Kanban worker created a
/// child card under it, known from provenance only. With [older], a card
/// made before the compression (stamped with the old id) is on the board
/// too.
Future<List<String>> _nextGen(
  WidgetTester tester, {
  required bool rotate,
  bool older = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final gateway = NextGenGateway(ngDockConnection());
  final source = FakeKanbanSource();
  if (older) {
    source.put('default', dockTask('t_before', status: 'running'));
  }
  final chat = ngDockChat(gateway, 'chat-a', source);
  await showNgDockChat(tester, gateway, chat);
  final live = rotate ? 'chat-a-cont' : 'chat-a';
  if (rotate) {
    // What the gateway emits once the session key moved to the continuation.
    gateway.debugEmit(
      ngDockEvent('session.info', 'rt-chat-a', {
        'stored_session_id': 'chat-a-cont',
        'model': 'model-a',
      }),
    );
    await dockSettle(tester);
  }
  source.put('default', dockTask('t_parent', status: 'running', session: live));
  gateway
    ..debugEmit(ngDockEvent('message.start', 'rt-chat-a'))
    ..debugEmit(
      ngDockEvent(
        'tool.complete',
        'rt-chat-a',
        kanbanCreateEvent(
          toolId: 'call-1',
          taskId: 't_parent',
          status: 'running',
        ),
      ),
    );
  await dockSettle(tester);
  // A worker creates a child under the parent: provenance only.
  source.put(
    'default',
    dockTask(
      't_child',
      title: 'Child of parent',
      status: 'todo',
      session: live,
    ),
  );
  source.emit('default', [
    {'id': 21, 'task_id': 't_child', 'kind': 'created'},
  ]);
  await dockSettle(tester);
  final ids = [for (final card in chat.kanban.cards) card.id];
  await closeNgDockChat(tester, gateway);
  return ids;
}

/// Classic: the same, with the remote's turn emitting the `session.info`.
Future<List<String>> _classic(
  WidgetTester tester, {
  required bool rotate,
  bool older = false,
}) async {
  tester.view.physicalSize = const Size(412, 860);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final live = rotate ? 'chat-a-cont' : 'chat-a';
  final source = FakeKanbanSource();
  if (older) {
    source.put('default', dockTask('t_before', status: 'running'));
  }
  final remote = ClassicDockRemote(
    before: [
      if (rotate)
        StreamEvent(
          type: 'session.info',
          data: const {'stored_session_id': 'chat-a-cont', 'model': 'fixture'},
        ),
    ],
    cards: [
      kanbanCreateEvent(
        toolId: 'call-1',
        taskId: 't_parent',
        status: 'running',
      ),
    ],
  );
  final controller = GatewayTurnApplicationController();
  addTearDown(controller.close);
  await openClassicDockChat(
    tester,
    session: 'chat-a',
    remote: remote,
    controller: controller,
    kanban: TestChatKanban(source: () => source),
  );
  source.put('default', dockTask('t_parent', status: 'running', session: live));
  await sendClassicDockMessage(tester, 'Put that on the board.');
  source.put(
    'default',
    dockTask(
      't_child',
      title: 'Child of parent',
      status: 'todo',
      session: live,
    ),
  );
  source.emit('default', [
    {'id': 21, 'task_id': 't_child', 'kind': 'created'},
  ]);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(classicDockToggle));
  await tester.pumpAndSettle();
  final ids = [
    for (final id in ['t_before', 't_parent', 't_child'])
      if (dockRow(id).evaluate().isNotEmpty) id,
  ];
  await closeClassicDockChat(tester);
  return ids;
}

void main() {
  group('NextGen', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('A-C1 control: without a compression the worker\'s child '
        'card (provenance only) joins the dock', (tester) async {
      final ids = await _nextGen(tester, rotate: false);
      expect(ids, containsAll(['t_parent', 't_child']));
    });

    testWidgets('A-C1: after an in-chat compression the child card stamped '
        'with the continuation id belongs to this chat', (tester) async {
      final ids = await _nextGen(tester, rotate: true);
      expect(
        ids,
        contains('t_child'),
        reason: 'provenance must follow the continuation stored id',
      );
    });

    testWidgets('A-C1: cards stamped with the id from before the compression '
        'still belong to this chat', (tester) async {
      final ids = await _nextGen(tester, rotate: true, older: true);
      expect(ids, containsAll(['t_before', 't_parent', 't_child']));
    });
  });

  group('Classic', () {
    setUp(
      () => SharedPreferences.setMockInitialValues({'verbose_mode': false}),
    );

    testWidgets('A-C2 control: without a compression the worker\'s child '
        'card joins the strip', (tester) async {
      expect(await _classic(tester, rotate: false), ['t_parent', 't_child']);
    });

    testWidgets('A-C2: after an in-chat compression the child card stamped '
        'with the continuation id belongs to this chat', (tester) async {
      expect(await _classic(tester, rotate: true), contains('t_child'));
    });

    testWidgets('A-C2: cards stamped with the id from before the compression '
        'still belong to this chat', (tester) async {
      expect(await _classic(tester, rotate: true, older: true), [
        't_before',
        't_parent',
        't_child',
      ]);
    });
  });
}
