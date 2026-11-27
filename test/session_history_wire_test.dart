import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';

import 'support/history_gateway.dart';

void main() {
  for (final classic in [true, false]) {
    test(
      '${classic ? 'Classic' : 'NextGen'} history uses the bound owner',
      () async {
        final gateway = await HistoryGateway.start();
        late final WorkspacePane pane;
        late final void Function() dispose;
        try {
          late final RemoteWorkspaceOwner owner;
          if (classic) {
            final client = DesktopGatewayClient.fromConnection(
              gateway.connection,
            );
            client.setReconnectAllowed(false);
            owner = client.workspace;
            pane = owner.pane();
            dispose = client.close;
            await client.resumeSubmittedSession(
              localSessionId: 'local',
              storedSessionId: HistoryGateway.session,
            );
          } else {
            final client = NextGenGateway(gateway.connection);
            owner = client.workspace;
            pane = owner.pane();
            dispose = client.dispose;
            await client.connected();
            await client.call('session.resume', {
              'session_id': HistoryGateway.session,
              'omit_messages': true,
            });
          }
          final target = await pane.bind(
            owner.route(storedSessionId: HistoryGateway.session),
          );
          await _exercise(target, owner, gateway);
        } finally {
          pane.close();
          dispose();
          await gateway.close();
        }
      },
    );
  }
}

Future<void> _exercise(
  WorkspaceTarget target,
  RemoteWorkspaceOwner owner,
  HistoryGateway gateway,
) async {
  final fences = await target.historyFences();
  await expectLater(
    target.branchAtMessage(
      throughMessageId: 7,
      confirmed: false,
      fences: fences,
    ),
    throwsA(
      isA<WorkspaceException>().having(
        (error) => error.reason,
        'reason',
        WorkspaceFailure.invalid,
      ),
    ),
  );
  expect(gateway.mutations, isEmpty);

  final branch = await target.branchAtMessage(
    throughMessageId: 7,
    confirmed: true,
    fences: fences,
  );
  expect(branch.sessionId, 'child-1');
  expect(gateway.mutations.single['operation'], 'branch');
  expect(gateway.mutations.single['payload'], {'through_message_id': 7});
  expect(gateway.mutations.single.containsKey('profile'), isFalse);

  final later = await target.historyFences();
  await expectLater(
    target.branchAtMessage(
      throughMessageId: 99,
      confirmed: true,
      fences: later,
    ),
    throwsA(
      isA<WorkspaceException>().having(
        (error) => error.reason,
        'reason',
        WorkspaceFailure.invalid,
      ),
    ),
  );

  final rewind = await target.rewindAtMessage(
    targetMessageId: 7,
    confirmed: true,
    fences: await target.historyFences(),
  );
  expect(rewind.removed, 2);
  expect(rewind.text, 'Keep this');

  // Lineage is the REST session rows' (as Desktop reads it), never the
  // WebSocket session.list: its canonical rows have no lineage fields.
  final lineage = await target.lineage();
  expect(lineage.parent?.id, 'parent');
  expect(lineage.siblings.map((row) => row.id), ['sibling']);
  expect(lineage.children, isEmpty);
  expect(gateway.sessionLists.single, {
    'limit': '200',
    'offset': '0',
    'min_messages': '0',
    'archived': 'include',
    'order': 'recent',
    'profile': HistoryGateway.profile,
  });
  expect(gateway.methods, isNot(contains('session.list')));

  final checkpoints = await target.checkpoints();
  final diff = await target.checkpointDiff(checkpoints.single.hash);
  expect(
    diff.text,
    isNot(
      contains(
        'AK'
        'IA',
      ),
    ),
  );
  await expectLater(
    target.restoreCheckpoint(hash: checkpoints.single.hash, confirmed: false),
    throwsA(isA<WorkspaceException>()),
  );
  expect(gateway.restores, isEmpty);
  // The default restore sends no `all` (Desktop's /rollback): the user's
  // own edits are reverted only on the explicit opt-in (--all).
  final restored = await target.restoreCheckpoint(
    hash: checkpoints.single.hash,
    confirmed: true,
  );
  expect(restored.historyRemoved, 1);
  expect(gateway.restores.single, {
    'session_id': HistoryGateway.session,
    'hash': checkpoints.single.hash,
    'profile': HistoryGateway.profile,
  });
  await target.restoreCheckpoint(
    hash: checkpoints.single.hash,
    confirmed: true,
    revertOwnEdits: true,
  );
  expect(gateway.restores.last, {
    'session_id': HistoryGateway.session,
    'hash': checkpoints.single.hash,
    'all': true,
    'profile': HistoryGateway.profile,
  });

  final exported = await target.exportTranscript(format: 'html', redact: true);
  expect(exported.format, 'html');
  expect(
    exported.content,
    isNot(
      contains(
        'gh'
        'p_',
      ),
    ),
  );
  expect(gateway.exports.single['redact'], isTrue);

  await expectLater(
    target.importForeign('../secret'),
    throwsA(isA<WorkspaceException>()),
  );
  final page = await target.foreignSessions(source: 'claude');
  expect(gateway.foreignLists.last['profile'], HistoryGateway.profile);
  expect(page.sessions.single.cwd, '/srv/claude');
  final preview = await target.previewForeign(page.sessions.single.id);
  expect(gateway.foreignPreviews.last['profile'], HistoryGateway.profile);
  expect(preview.cwd, '/srv/claude');
  expect(preview.messages.single.text, isNot(contains(HistoryGateway.secret)));
  final imported = await target.importForeign(page.sessions.single.id);
  expect(gateway.imports.last['profile'], HistoryGateway.profile);
  expect(imported.sessionId, 'imported-host');

  // Session-less owner route (fresh draft / session browser) still binds
  // profile and paginates + imports host sessions, and surfaces unsupported
  // when an older gateway lacks session.foreign.*.
  final profilePane = owner.pane();
  try {
    final profileTarget = await profilePane.bind(owner.route());
    final firstPage = await profileTarget.foreignSessions();
    expect(firstPage.nextOffset, 25);
    expect(gateway.foreignLists.last['profile'], HistoryGateway.profile);
    final secondPage = await profileTarget.foreignSessions(
      offset: firstPage.nextOffset!,
    );
    expect(secondPage.sessions.single.source, 'codex');
    expect(
      secondPage.sessions.single.excerpt,
      isNot(contains(HistoryGateway.secret)),
    );
    final profileImported = await profileTarget.importForeign(
      secondPage.sessions.single.id,
    );
    expect(profileImported.sessionId, 'imported-host');

    gateway.foreignSupported = false;
    await expectLater(
      profileTarget.foreignSessions(),
      throwsA(
        isA<WorkspaceException>().having(
          (error) => error.reason,
          'reason',
          WorkspaceFailure.unsupported,
        ),
      ),
    );
  } finally {
    profilePane.close();
  }
}
