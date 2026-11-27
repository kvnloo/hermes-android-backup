import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/parallel_workspace_entry.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/hermes_sign_in.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/workspace/popout_bootstrap.dart';
import 'package:hermes_android/core/workspace/popout_owner.dart';
import 'package:hermes_android/core/workspace/popout_protocol.dart';
import 'package:hermes_android/core/workspace/workspace_popout.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

final _target = PopoutTarget(
  connectionId: 'c',
  sessionId: 's-1',
  profile: 'work',
  nextGen: true,
);
final _connection = SavedConnection(
  id: 'c',
  label: 'Fixture',
  host: 'fixture.invalid',
  port: 9119,
  apiKey: 'fixture-only',
  gatewayProfile: 'work',
  singleLogin: true,
  desktopGatewayUrl: 'https://fixture.invalid',
);

class _Refused extends NextGenGateway {
  _Refused(this.wrong) : super(_connection);
  final bool wrong;
  final calls = <String>[];
  final _ws = WsClient('https://fixture.invalid'); // never connected
  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => _ws;
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add(method);
    if (wrong) {
      return {'stored_session_id': 'other', 'session_id': 'wrong-runtime'};
    }
    throw StateError('Fixture refused.');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => HermesSignInVault.resetForTesting());
  test('only macOS, Windows and Linux expose the native window action', () {
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    for (final platform in TargetPlatform.values) {
      debugDefaultTargetPlatformOverride = platform;
      expect(
        supportsWorkspacePopout,
        {
          TargetPlatform.macOS,
          TargetPlatform.windows,
          TargetPlatform.linux,
        }.contains(platform),
      );
    }
  });
  testWidgets('entry owner revocation survives rollback and stale callbacks', (
    tester,
  ) async {
    final keyed = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: ParallelWorkspaceEntryHost(
          owner: _connection,
          connection: _connection,
          home: (_) => SizedBox(key: keyed),
          workspace: (_) => const SizedBox(),
        ),
      ),
    );
    final context = keyed.currentContext!;
    final lease = ParallelWorkspaceEntryHost.popoutOwner(context)!;
    expect(lease.current(), isTrue);
    ConnectionMutationBarrier.begin([_connection.id]).release();
    expect(lease.current(), isFalse);
    expect(ParallelWorkspaceEntryHost.popoutOwner(context), isNull);
    await tester.pumpWidget(const SizedBox());
    expect(lease.current(), isFalse);
  });
  testWidgets(
    'a page pushed over the owner keeps its pop-outs; popping the owner ends them',
    (tester) async {
      // SAM-GAMING gate (242fa67c): opening search, or a notification opening
      // another chat, killed the user's pop-out windows.
      final keyed = GlobalKey();
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: const Scaffold(body: Text('root')),
        ),
      );
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => ParallelWorkspaceEntryHost(
            owner: _connection,
            connection: _connection,
            home: (_) => SizedBox(key: keyed),
            workspace: (_) => const SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final lease = ParallelWorkspaceEntryHost.popoutOwner(
        keyed.currentContext!,
      )!;
      expect(lease.current(), isTrue);
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Search all chats')),
        ),
      );
      await tester.pumpAndSettle();
      expect(lease.current(), isTrue, reason: 'covered, not gone');
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(lease.current(), isTrue);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(lease.current(), isFalse, reason: 'owner route popped');
    },
  );
  test(
    'IPC carries the exact target only; malformed or extensible identities fail closed',
    () {
      final map = _target.toJson();
      expect(map, {
        'connectionId': 'c',
        'sessionId': 's-1',
        'profile': 'work',
        'nextGen': true,
      });
      expect(PopoutTarget.decode(map).key, _target.key);
      for (final bad in [
        null,
        {},
        {...map, 'endpoint': 'ignored'},
        {...map, 'nextGen': 'true'},
        for (final invalid in [
          '',
          '../s',
          'https://example.org',
          's\n',
          's 1',
          '--foo',
        ])
          {...map, 'sessionId': invalid},
      ]) {
        expect(() => PopoutTarget.decode(bad), throwsFormatException);
      }
    },
  );
  test(
    'one bounded frame; EOF, oversize, faults and a second frame revoke',
    () async {
      for (final input in [
        <List<int>>[],
        [utf8.encode('bad\n')],
        [List.filled(2049, 65)],
        [utf8.encode('{"a":1}\n'), utf8.encode('{}\n')],
        [utf8.encode('{"a"'), utf8.encode(':1}\n')],
      ]) {
        final events = [];
        await watchPopoutPipe(
          Stream.fromIterable(input),
          onLaunch: (m) => events.add(m),
          onRevoked: () => events.add('revoked'),
        );
        expect(events.last, 'revoked');
        expect(events.length, input.length == 2 ? 2 : 1);
      }
      var revoked = false;
      await watchPopoutPipe(
        Stream.error(StateError('pipe failed')),
        onLaunch: (_) => fail('unexpected'),
        onRevoked: () => revoked = true,
      );
      expect(revoked, true);
    },
  );
  test(
    'a pop-out gets the imported theme and reading choices, not the pet',
    () {
      final copied = popoutPreferences({
        'flutter.saved_connections': <String>[jsonEncode(_connection.toMap())],
        'flutter.imported_vscode_themes_v1': '{"version":1}',
        'flutter.presentation.reading.v1': '{"externalEmbeds":false}',
        'flutter.presentation.petdex.v1': '{"enabled":true}',
        'flutter.presentation.radio.enabled': true,
      }, _target);
      expect(
        copied.keys,
        unorderedEquals([
          'flutter.saved_connections',
          'flutter.imported_vscode_themes_v1',
          'flutter.presentation.reading.v1',
        ]),
      );
    },
  );
  test(
    'selects one migrated account and no shared chat data; writes stay in RAM',
    () async {
      final source = <String, Object>{
        'flutter.saved_connections': <String>[
          jsonEncode(_connection.toMap()),
          jsonEncode({..._connection.toMap(), 'id': 'other'}),
        ],
        'flutter.theme_mode': 'dark',
        'flutter.drafts': 'old',
        'flutter.gateway_turn_journal_v2': 'existing',
        // The primary window alone owns toast activation tickets and the
        // notification log; a child never reads or rewrites either.
        'flutter.windows_toast_tickets_v1': '{}',
        'flutter.notification_attempts_v1': '[]',
      };
      final physical = InMemorySharedPreferencesStore.withData(source);
      final initial = popoutPreferences(await physical.getAll(), _target);
      expect(
        initial.keys,
        unorderedEquals(['flutter.saved_connections', 'flutter.theme_mode']),
      );
      expect((initial['flutter.saved_connections'] as List).length, 1);
      final ephemeral = InMemorySharedPreferencesStore.withData(initial);
      await ephemeral.setValue('String', 'flutter.drafts', 'changed');
      await ephemeral.clear();
      expect(await physical.getAll(), source);
      for (final rows in [
        [],
        [_connection.toMap(), _connection.toMap()],
        [
          {..._connection.toMap(), 'gateway_profile': 'other'},
        ],
        [
          {..._connection.toMap(), 'dashboard_password': 'legacy'},
        ],
      ]) {
        expect(
          () => popoutPreferences({
            'flutter.saved_connections': [for (final r in rows) jsonEncode(r)],
          }, _target),
          throwsStateError,
        );
      }
    },
  );
  test(
    'owner proof changes on same-ID credential/endpoint change, carries no plaintext',
    () {
      final proof = popoutOwnerProof('challenge', _connection);
      expect(proof, matches(RegExp('^[a-f0-9]{64}\$')));
      expect(
        proof,
        popoutOwnerProof(
          'challenge',
          SavedConnection.fromMap(
            _connection.toMap(),
          ).copyWith(apiKey: 'fixture-only'),
        ),
      );
      for (final c in [
        _connection.copyWith(apiKey: 'changed'),
        _connection.copyWith(host: 'different.invalid'),
        _connection.copyWith(gatewayProfile: 'other'),
      ]) {
        expect(popoutOwnerProof('challenge', c), isNot(proof));
      }
      expect(popoutOwnerProof('different nonce', _connection), isNot(proof));
      expect(matchesPopoutOwner(_target, _connection), true);
      expect(
        matchesPopoutOwner(
          PopoutTarget(
            connectionId: 'c',
            sessionId: 's-1',
            profile: 'work',
            nextGen: false,
          ),
          _connection.copyWith(singleLogin: false),
        ),
        false,
      );
    },
  );
  test(
    'one exact physical metadata read; absent, draft, wrong profile and lineage substitution rejected',
    () async {
      for (final row in <Map<String, dynamic>>[
        {},
        {'id': 'another', '_lineage_root_id': 's-1'},
        {'id': 's-1', 'profile': 'home'},
        {'id': 's-1', 'is_local_draft': true},
      ]) {
        final reads = <String>[];
        await expectLater(
          exactPopoutSession(_target, (id) async {
            reads.add(id);
            return row;
          }),
          throwsStateError,
        );
        expect(reads, ['s-1']);
      }
      final s = await exactPopoutSession(
        _target,
        (id) async => {'id': id, 'profile': 'work'},
      );
      expect(s.id, 's-1');
      expect(s.isLocalDraft, false);
    },
  );
  for (final nextGen in [false, true]) {
    test(
      'a named profile must be confirmed by the stored row ($nextGen)',
      () async {
        final named = PopoutTarget(
          connectionId: 'gateway',
          sessionId: 'shared-id',
          profile: 'work',
          nextGen: nextGen,
        );
        for (final row in <Map<String, dynamic>>[
          {'id': 'shared-id'},
          {'id': 'shared-id', 'profile': null},
          {'id': 'shared-id', 'profile': ''},
          {'id': 'shared-id', 'profile': 'other'},
        ]) {
          await expectLater(
            exactPopoutSession(named, (_) async => row),
            throwsStateError,
          );
        }
        final stored = await exactPopoutSession(
          named,
          (id) async => {'id': id, 'profile': 'work'},
        );
        expect(stored.id, 'shared-id');
        final legacy = PopoutTarget(
          connectionId: 'gateway',
          sessionId: 'shared-id',
          profile: '',
          nextGen: nextGen,
        );
        final unqualified = await exactPopoutSession(
          legacy,
          (id) async => {'id': id},
        );
        expect(unqualified.id, 'shared-id');
      },
    );
  }
  test(
    'NextGen never creates or submits instead of a refused resume',
    () async {
      final gateway = _Refused(false);
      final chat = NgChatController(gateway, sessionId: 's-1');
      try {
        expect(await chat.send('fixture prompt'), false);
        expect(gateway.calls, ['session.resume']);
        expect(chat.storedId, 's-1');
        expect(chat.runtimeId, isNull);
      } finally {
        chat.dispose();
        gateway.dispose();
      }
    },
  );
  test(
    'NextGen binds a resume that followed a compressed chat to its tip, never creating another chat',
    () async {
      // The gateway answers a compressed chat's original id with its lineage
      // tip (tui_gateway methods_session._resume_follow_tip); that is the
      // same conversation, so it binds rather than refusing or creating.
      final gateway = _Refused(true);
      final chat = NgChatController(gateway, sessionId: 's-1');
      try {
        await chat.send('fixture prompt');
        expect(gateway.calls.first, 'session.resume');
        expect(gateway.calls, isNot(contains('session.create')));
        expect(chat.storedId, 's-1');
        expect(chat.runtimeId, 'wrong-runtime');
      } finally {
        chat.dispose();
        gateway.dispose();
      }
    },
  );
  test(
    'read-only child auth cannot rotate, replace or delete credentials',
    () async {
      HermesSignInVault.useReadOnlyWindowStore('https://fixture.invalid');
      final vault = HermesSignInVault.instance;
      await expectLater(
        vault.setSession('https://fixture.invalid', null),
        throwsStateError,
      );
      await expectLater(
        vault.setAccessToken('fixture.invalid', null),
        throwsStateError,
      );
      expect(await vault.refresh('https://fixture.invalid'), isNull);
    },
  );
}
