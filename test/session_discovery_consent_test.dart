import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/services/session_search_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

SavedConnection _connection(String id, String? profile, {String? prefix}) =>
    SavedConnection(
      id: id,
      label: id,
      host: 'consent.invalid',
      port: 8642,
      apiKey: '',
      desktopGatewayUrl: 'https://consent.invalid:9443/hermes',
      gatewayProfile: profile,
      dashboardPrefix: prefix,
    );

class _PhysicalConsentStore extends InMemorySharedPreferencesStore {
  _PhysicalConsentStore() : super.empty();

  Completer<void>? readGate;
  Completer<void>? readStarted;
  Completer<bool>? writeGate;
  Completer<void>? writeStarted;
  final writes = <({String key, Object value})>[];
  final heldReads = <Completer<void>>[];
  final heldWrites = <Completer<bool>>[];

  void release() {
    for (final gate in [...heldReads, ?readGate]) {
      if (!gate.isCompleted) gate.complete();
    }
    for (final gate in [...heldWrites, ?writeGate]) {
      if (!gate.isCompleted) gate.complete(true);
    }
  }

  @override
  Future<Map<String, Object>> getAll() async {
    final gate = readGate;
    if (gate != null) {
      readGate = null;
      heldReads.add(gate);
      readStarted!.complete();
      await gate.future;
    }
    return super.getAll();
  }

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    writes.add((key: key, value: value));
    final gate = writeGate;
    if (gate != null) {
      writeGate = null;
      heldWrites.add(gate);
      writeStarted!.complete();
      if (!await gate.future) return false;
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _PhysicalConsentStore physical;
  late SharedPreferences prefs;
  late SessionSearchPreferences store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final previous = SharedPreferencesStorePlatform.instance;
    physical = _PhysicalConsentStore();
    SharedPreferencesStorePlatform.instance = physical;
    addTearDown(() => SharedPreferencesStorePlatform.instance = previous);
    addTearDown(physical.release);
    prefs = await SharedPreferences.getInstance();
    store = SessionSearchPreferences(prefs);
  });

  test(
    'consent identity includes saved connection, endpoint and exact profile',
    () {
      final a = _connection('a', 'research');
      final identities = [
        sessionSearchIdentity(a),
        sessionSearchIdentity(_connection('a', 'personal')),
        sessionSearchIdentity(_connection('b', 'research')),
        sessionSearchIdentity(_connection('a', null)),
        sessionSearchIdentity(_connection('a', 'default')),
        sessionSearchIdentity(_connection('a', ' research')),
        sessionSearchIdentity(_connection('a', 'research', prefix: '/other')),
        sessionSearchIdentity(a.copyWith(host: 'other.invalid')),
      ];
      expect(identities.toSet(), hasLength(identities.length));
      expect(
        sessionSearchIdentity(_connection('a|b', 'c')),
        isNot(sessionSearchIdentity(_connection('a', 'b|c'))),
      );
    },
  );

  test(
    'gateway-only server and AI choices never migrate to any profile',
    () async {
      final a = _connection('legacy', 'research');
      final legacy =
          '${a.baseUrl}|${a.gatewayPrefix ?? ''}|${a.desktopGatewayUrl ?? ''}';
      final legacyKey = 'session_search.${Uri.encodeComponent(legacy)}.mode';
      for (final oldMode in [SessionSearchMode.server, SessionSearchMode.ai]) {
        await prefs.setString(legacyKey, oldMode.storageValue);
        for (final profile in ['research', 'personal', null, 'default']) {
          expect(
            store.readMode(
              connectionIdentity: sessionSearchIdentity(
                _connection('legacy', profile),
              ),
            ),
            SessionSearchMode.local,
          );
        }
        expect(prefs.getString(legacyKey), oldMode.storageValue);
      }
    },
  );

  test(
    'grant, revoke and restart are isolated to one connection/profile',
    () async {
      final a = sessionSearchIdentity(_connection('isolation', 'research'));
      final b = sessionSearchIdentity(_connection('isolation', 'personal'));
      final c = sessionSearchIdentity(_connection('separate', 'research'));
      await store.saveMode(
        connectionIdentity: a,
        mode: SessionSearchMode.server,
      );
      expect(store.readMode(connectionIdentity: b), SessionSearchMode.local);
      expect(store.readMode(connectionIdentity: c), SessionSearchMode.local);
      await store.saveMode(
        connectionIdentity: b,
        mode: SessionSearchMode.server,
      );
      await store.clear(connectionIdentity: a);
      await prefs.reload();
      final reopened = SessionSearchPreferences(prefs);
      expect(reopened.readMode(connectionIdentity: a), SessionSearchMode.local);
      expect(
        reopened.readMode(connectionIdentity: b),
        SessionSearchMode.server,
      );
      expect(reopened.readMode(connectionIdentity: c), SessionSearchMode.local);
    },
  );

  test(
    'departing while baseline read is held never dispatches a grant',
    () async {
      final id = sessionSearchIdentity(_connection('read-fence', 'research'));
      final access = SessionSearchAccess(store, id);
      final gate = physical.readGate = Completer<void>();
      final started = physical.readStarted = Completer<void>();
      final saving = access.setServer(true);
      await started.future;
      access.dispose();
      gate.complete();
      await saving;
      expect(physical.writes, isEmpty);
      expect(store.readMode(connectionIdentity: id), SessionSearchMode.local);
    },
  );

  test(
    'held grant is not authority and departure retracts only its captured key',
    () async {
      final a = sessionSearchIdentity(_connection('write-fence', 'research'));
      final b = sessionSearchIdentity(_connection('write-fence', 'personal'));
      await store.saveMode(
        connectionIdentity: b,
        mode: SessionSearchMode.server,
      );
      final access = SessionSearchAccess(store, a);
      final sibling = SessionSearchAccess(store, a);
      addTearDown(sibling.dispose);
      final grants = <bool>[];
      sibling.addListener(() => grants.add(sibling.value));
      final gate = physical.writeGate = Completer<bool>();
      final started = physical.writeStarted = Completer<void>();
      final saving = access.setServer(true);
      await started.future;
      expect(access.value, isFalse);
      expect(sibling.value, isFalse);
      expect(store.readMode(connectionIdentity: a), SessionSearchMode.local);
      final replacement = SessionSearchAccess(store, a);
      expect(replacement.value, isFalse);
      replacement.dispose();
      access.dispose();
      gate.complete(true);
      await saving;
      await prefs.reload();
      expect(grants, isNot(contains(true)));
      expect(store.readMode(connectionIdentity: a), SessionSearchMode.local);
      expect(store.readMode(connectionIdentity: b), SessionSearchMode.server);
      final physicalValues = await physical.getAll();
      expect(
        physicalValues['flutter.session_search.${Uri.encodeComponent(a)}.mode'],
        'local',
      );
      expect(
        physicalValues['flutter.session_search.${Uri.encodeComponent(b)}.mode'],
        'server',
      );
    },
  );

  test('departure during grant readback cannot publish or retain it', () async {
    final id = sessionSearchIdentity(_connection('readback-fence', 'research'));
    final access = SessionSearchAccess(store, id);
    final sibling = SessionSearchAccess(store, id);
    addTearDown(sibling.dispose);
    final writeGate = physical.writeGate = Completer<bool>();
    final writeStarted = physical.writeStarted = Completer<void>();
    final saving = access.setServer(true);
    await writeStarted.future;
    final readGate = physical.readGate = Completer<void>();
    final readStarted = physical.readStarted = Completer<void>();
    writeGate.complete(true);
    await readStarted.future;
    expect(sibling.value, isFalse);
    access.dispose();
    readGate.complete();
    await saving;
    expect(sibling.value, isFalse);
    expect(store.readMode(connectionIdentity: id), SessionSearchMode.local);
    expect(
      (await physical
          .getAll())['flutter.session_search.${Uri.encodeComponent(id)}.mode'],
      'local',
    );
  });

  test(
    'failed grant stays denied for retained and reopened access; retry can grant',
    () async {
      final id = sessionSearchIdentity(_connection('failed-grant', 'research'));
      final access = SessionSearchAccess(store, id);
      addTearDown(access.dispose);
      final gate = physical.writeGate = Completer<bool>();
      final started = physical.writeStarted = Completer<void>();
      final saving = access.setServer(true);
      final rejection = expectLater(saving, throwsStateError);
      await started.future;
      gate.complete(false);
      await rejection;
      expect(access.value, isFalse);
      final reopened = SessionSearchAccess(store, id);
      addTearDown(reopened.dispose);
      expect(reopened.value, isFalse);
      await access.setServer(true);
      expect(access.value, isTrue);
      expect(reopened.value, isTrue);
    },
  );

  test(
    'withdrawal queues behind held grant and survives browser departure',
    () async {
      final id = sessionSearchIdentity(
        _connection('queued-revoke', 'research'),
      );
      final access = SessionSearchAccess(store, id);
      final sibling = SessionSearchAccess(store, id);
      addTearDown(sibling.dispose);
      final grants = <bool>[];
      sibling.addListener(() => grants.add(sibling.value));
      final gate = physical.writeGate = Completer<bool>();
      final started = physical.writeStarted = Completer<void>();
      final grant = access.setServer(true);
      await started.future;
      final revoke = access.setServer(false);
      access.dispose();
      gate.complete(true);
      await Future.wait([grant, revoke]);
      expect(grants, isNot(contains(true)));
      expect(store.readMode(connectionIdentity: id), SessionSearchMode.local);
      expect(
        (await physical
            .getAll())['flutter.session_search.${Uri.encodeComponent(id)}.mode'],
        'local',
      );
    },
  );
}
