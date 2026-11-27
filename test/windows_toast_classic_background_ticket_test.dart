import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/background_work_prefs.dart';
import 'package:hermes_android/core/services/connection_keepalive_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/services/mobile_push_service.dart';
import 'package:hermes_android/core/services/notification_prefs.dart';
import 'package:hermes_android/core/services/turn_notification_service.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'helpers/windows_receipt_credentials.dart';

// Windows release gate (555789a1, 3/3 MSIX and direct): in Classic, chat B's
// turn settles while Ares is in the background, Windows shows "Response
// complete", and clicking it does nothing because its ticket is not in
// `windows_toast_tickets_v1`. These cases drive the real root, owner and
// WindowsToastSink against a recording 'ares/windows_toast' runner.

enum _Scenario {
  /// Unmodified event-loop order of the real Classic settlement.
  natural,

  /// The operational-activity store's reload, which settlement starts just
  /// before the Response complete post, completes only after Windows posts
  /// that toast: its older snapshot lands on top of the new ticket.
  staleReload,

  /// The runner posts the toast, then reports an error (for example the
  /// post-Show notification setting read).
  showFailsAfterPosting,
}

Map<String, dynamic> _ledgerFrom(Map<Object?, Object?> all) {
  final raw = all['flutter.${WindowsToastSink.ledgerKey}'];
  return raw == null ? {} : jsonDecode(raw as String) as Map<String, dynamic>;
}

/// Holds one preferences read that the operational-activity store issues, so a
/// stale reload provably overlaps a ledger write.
mixin _HeldActivityReload {
  bool armed = false;
  final _gate = Completer<void>();
  Map<String, dynamic>? heldLedger;
  bool get held => heldLedger != null;

  void release() {
    if (!_gate.isCompleted) _gate.complete();
  }

  Future<Map<String, Object>> _maybeHold(Map<String, Object> snapshot) async {
    if (!armed ||
        !StackTrace.current.toString().contains(
          'operational_activity_store.dart',
        )) {
      return snapshot;
    }
    armed = false;
    heldLedger = _ledgerFrom(snapshot);
    await _gate.future;
    return snapshot;
  }

  /// Physical preference state, as a cold launch would read it.
  Future<Map<String, dynamic>> ledgerOnDisk();
}

/// Mirrors shared_preferences_windows 2.4.1 `SharedPreferencesWindows`: one
/// process cache read through an async accessor, so `reload()` is served from
/// memory and never re-reads the file, and every write persists the whole
/// cache after the async application-support path lookup.
class _WindowsPreferences extends SharedPreferencesStorePlatform
    with _HeldActivityReload {
  final Map<String, Object> _cache = {};

  /// `shared_preferences.json` after the latest write.
  String file = '{}';

  Future<Map<String, Object>> _readPreferences() async => _cache;

  Future<bool> _write() async {
    await Future<void>.value(); // path_provider_windows lookup
    file = jsonEncode(_cache);
    return true;
  }

  @override
  Future<bool> clear() async {
    (await _readPreferences()).removeWhere((k, _) => k.startsWith('flutter.'));
    return _write();
  }

  @override
  Future<Map<String, Object>> getAll() => getAllWithParameters(
    GetAllParameters(filter: PreferencesFilter(prefix: 'flutter.')),
  );

  @override
  Future<Map<String, Object>> getAllWithParameters(
    GetAllParameters parameters,
  ) async {
    final filter = parameters.filter;
    final all = Map<String, Object>.from(await _readPreferences());
    all.removeWhere(
      (k, _) =>
          !(k.startsWith(filter.prefix) &&
              (filter.allowList?.contains(k) ?? true)),
    );
    return _maybeHold(all);
  }

  @override
  Future<bool> remove(String key) async {
    (await _readPreferences()).remove(key);
    return _write();
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    (await _readPreferences())[key] = value;
    return _write();
  }

  @override
  Future<Map<String, dynamic>> ledgerOnDisk() async =>
      _ledgerFrom(jsonDecode(file) as Map);
}

/// The store every other suite uses (`setMockInitialValues`).
class _MemoryPreferences extends InMemorySharedPreferencesStore
    with _HeldActivityReload {
  _MemoryPreferences() : super.empty();

  @override
  Future<Map<String, Object>> getAll() async =>
      _maybeHold(await super.getAll());

  @override
  Future<Map<String, dynamic>> ledgerOnDisk() async =>
      _ledgerFrom(await super.getAll());
}

/// The runner's toast backend as Notification Center sees it.
class _Shell {
  _Shell(this.messenger, this.onPosted);
  final TestDefaultBinaryMessenger messenger;
  final void Function(bool quiet) onPosted;

  /// Toasts currently in Notification Center, id → launch ticket.
  final visible = <int, String>{};
  final shown = <({int id, String ticket, bool quiet})>[];
  final cancelled = <int>[];
  int focuses = 0;

  /// Native `Show` posts non-quiet toasts, then reports an error.
  bool failAfterPosting = false;

  void install() {
    messenger.setMockMethodCallHandler(WindowsToastSink.channel, (m) async {
      switch (m.method) {
        case 'permission':
          return true;
        case 'show':
          final args = m.arguments as Map;
          final id = args['id'] as int;
          final ticket = args['ticket'] as String;
          final quiet = args['quiet'] as bool;
          visible[id] = ticket;
          shown.add((id: id, ticket: ticket, quiet: quiet));
          onPosted(quiet);
          if (failAfterPosting && !quiet) {
            throw PlatformException(
              code: 'windows_toast',
              message: 'Windows notification error -2147024891',
            );
          }
        case 'cancel':
          cancelled.add(m.arguments as int);
          visible.remove(m.arguments as int);
        case 'cancelAll':
          visible.clear();
        case 'focus':
          focuses++;
      }
      return null;
    });
  }

  /// Windows forwarding a toast click to the running primary window.
  Future<void> click(String ticket) async {
    final done = Completer<void>();
    await messenger.handlePlatformMessage(
      WindowsToastSink.channel.name,
      const StandardMethodCodec().encodeMethodCall(
        MethodCall('activate', ticket),
      ),
      (_) => done.complete(),
    );
    await done.future;
  }
}

Future<void> _pumps(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump();
  }
  await tester.pump(const Duration(milliseconds: 350));
}

/// Every toast still in Notification Center must be activatable: its ticket
/// is in the process ledger (warm click) and on disk (cold click). Every
/// ticket the ledger dropped belongs to a toast Windows no longer shows.
Future<void> _expectEveryVisibleToastHasItsTicket(
  _Shell shell,
  SharedPreferences prefs,
  _HeldActivityReload store,
) async {
  final cache =
      jsonDecode(prefs.getString(WindowsToastSink.ledgerKey) ?? '{}') as Map;
  final disk = await store.ledgerOnDisk();
  for (final MapEntry(key: id, value: ticket) in shell.visible.entries) {
    expect(
      (cache[ticket] as Map?)?['id'],
      id,
      reason: 'visible toast $id has no live ticket in the process ledger',
    );
    expect(
      (disk[ticket] as Map?)?['id'],
      id,
      reason: 'visible toast $id has no live ticket on disk',
    );
  }
  for (final post in shell.shown) {
    if (!disk.containsKey(post.ticket) &&
        shell.visible[post.id] == post.ticket) {
      fail('toast ${post.id} lost its ticket but was never cancelled');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  for (final scenario in _Scenario.values) {
    for (final windowsStore in [true, false]) {
      testWidgets('Classic background Response complete keeps a live ticket: '
          '${scenario.name}, ${windowsStore ? 'Windows' : 'in-memory'} store', (
        tester,
      ) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        SharedPreferences.setMockInitialValues({});
        final original = SharedPreferencesStorePlatform.instance;
        final _HeldActivityReload store = windowsStore
            ? _WindowsPreferences()
            : _MemoryPreferences();
        SharedPreferencesStorePlatform.instance =
            store as SharedPreferencesStorePlatform;
        notificationPrefs.value = NotificationPrefs.defaults;
        backgroundWorkEnabled.value = true;
        final shell = _Shell(messenger, (quiet) {
          if (!quiet) store.release();
        })..failAfterPosting = scenario == _Scenario.showFailsAfterPosting;
        shell.install();
        messenger.setMockMethodCallHandler(
          ConnectionKeepAliveService.channel,
          (_) async => true,
        );
        final rpc = Completer<void>();
        final controller = GatewayTurnApplicationController();
        final push = MobilePushService(supported: false);
        Future<void> cleanUp() async {
          store.release();
          if (!rpc.isCompleted) rpc.complete();
          await controller.close();
          push.dispose();
          messenger.setMockMethodCallHandler(WindowsToastSink.channel, null);
          WindowsToastSink.channel.setMethodCallHandler(null);
          messenger.setMockMethodCallHandler(
            ConnectionKeepAliveService.channel,
            null,
          );
          SharedPreferencesStorePlatform.instance = original;
          notificationResponseHandler = null;
          debugDefaultTargetPlatformOverride = null;
        }

        addTearDown(() async {
          if (debugDefaultTargetPlatformOverride != null) await cleanUp();
        });

        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        final prefs = await SharedPreferences.getInstance();
        final manager = ConnectionManager(
          prefs,
          credentialStore: WindowsReceiptCredentials(),
        );
        await manager.saveConnection(
          'Toast gate',
          'https://toast.invalid',
          443,
          'toast-api-key',
        );
        final notifications = TurnNotificationService(sink: WindowsToastSink());
        await tester.pumpWidget(
          HermesApp(
            connManager: manager,
            notifications: notifications,
            mobilePush: push,
            turnApplicationController: controller,
          ),
        );
        await _pumps(tester);
        final responses = <NotificationResponse>[];
        notificationResponseHandler = responses.add;
        final connection = manager.getConnections().single;
        final normal = controller.normalSessionFor(
          connection,
          notifications: notifications,
          submit:
              ({
                required sessionId,
                required text,
                required onEvent,
                required onSent,
              }) async {
                onSent();
                await rpc.future;
              },
          resume: ({required localSessionId, required storedSessionId}) async =>
              ResumedGatewaySession(runtimeSessionId: 'runtime', running: true),
          history: (_) async => [],
        );
        await normal.ready;
        normal.chatFor('alpha', storedSessionId: 'tg-alpha', title: 'Alpha');
        final bravo = normal.chatFor(
          'bravo',
          storedSessionId: 'tg-bravo',
          title: 'Bravo',
        );
        await _pumps(tester);

        // Chat B's turn runs while chat A is shown; then Ares is inactive
        // and the root posts B's ongoing "Active chats" entry.
        final turn = bravo.submitPrepared(
          reservation: bravo.reserve()!,
          text: 'qa-delay',
          localContent: 'qa-delay',
        );
        turn.ignore();
        await _pumps(tester);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        await _pumps(tester);
        final ongoing = shell.shown.lastWhere((s) => s.quiet);
        expect(shell.visible[ongoing.id], ongoing.ticket);

        // B's owned lifecycle terminal settles in the background: the
        // owner posts Response complete while the root withdraws the
        // ongoing entry.
        normal.receiveEvent(
          'bravo',
          StreamEvent(type: 'message.start', data: const {}, turnId: 'turn-b'),
        );
        store.armed = scenario == _Scenario.staleReload;
        normal.receiveEvent(
          'bravo',
          StreamEvent(
            type: 'turn.end',
            data: {'status': 'completed'},
            turnId: 'turn-b',
          ),
        );
        rpc.complete();
        await _pumps(tester);

        final complete = shell.shown.lastWhere((s) => !s.quiet);
        if (scenario == _Scenario.staleReload) {
          expect(store.held, isTrue, reason: 'the reload was not held');
          expect(
            store.heldLedger!.keys,
            isNot(contains(complete.ticket)),
            reason: 'the held snapshot must predate the ticket',
          );
        }
        expect(shell.visible.containsKey(ongoing.id), isFalse);
        await _expectEveryVisibleToastHasItsTicket(shell, prefs, store);
        if (scenario == _Scenario.showFailsAfterPosting) {
          // A failed post is withdrawn, never left as a dead toast.
          expect(shell.visible, isEmpty);
          expect(shell.cancelled, contains(complete.id));
        } else {
          expect(shell.visible, {complete.id: complete.ticket});
          await shell.click(complete.ticket);
          await _pumps(tester);
          expect(shell.focuses, 1);
          final response = responses.single as WindowsToastResponse;
          expect(response.target.connectionId, connection.id);
          expect(response.target.sessionId, 'tg-bravo');
        }

        await tester.pumpWidget(const SizedBox());
        await _pumps(tester);
        await cleanUp();
        await turn;
      });
    }
  }
}
