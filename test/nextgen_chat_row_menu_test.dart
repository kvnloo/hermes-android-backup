// A NextGen chat row's actions (Pin/Unpin, Mark read/unread, Rename, Archive,
// Delete) are reachable with a mouse: right-click opens a menu at the cursor,
// and a ⋯ button shows while the row is hovered or focused (always on the
// open chat on desktop). Long-press keeps the bottom sheet, and a phone's
// layout is unchanged.
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/dashboard_api_client.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/sessions_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final double _now = DateTime.now().millisecondsSinceEpoch / 1000.0;

Session _row(
  String id,
  String title, {
  double ago = 300,
  bool pinned = false,
  String source = 'desktop',
  bool active = false,
}) => Session(
  id: id,
  title: title,
  model: 'm',
  source: source,
  messageCount: 2,
  isActive: active,
  preview: '',
  startedAt: 1000,
  lastActive: _now - ago,
  pinned: pinned,
);

/// The open chat, two read chats (one pinned), one unread chat, one running
/// chat and a cron conversation.
List<Session> _rows() => [
  _row('open', 'On screen'),
  _row('a', 'Alpha'),
  _row('b', 'Beta', pinned: true),
  _row('u', 'Unread one', ago: 120),
  _row('run', 'Running job', active: true),
  _row('daily', 'Daily report', source: 'cron'),
];

SavedConnection _conn() => SavedConnection(
  id: 'c1',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
);

class _FakeApi extends DashboardApiClient {
  _FakeApi(super.dashboard, this.rows) : super.withDashboard();

  List<Session> rows;
  final pins = <(String, bool)>[];
  final archived = <String>[];
  final deleted = <String>[];

  @override
  Future<bool?> showSubagentSessions({String? profile}) async => false;

  @override
  Future<SessionListPage> getSessionsPage({
    int limit = 50,
    int offset = 0,
    String? title,
    String? excludeSources,
    bool Function()? maySendSearch,
    Duration timeout = ApiClient.requestTimeout,
  }) async =>
      SessionListPage(sessions: offset == 0 ? rows : const [], hasMore: false);

  @override
  Future<bool> setSessionPinned({
    required String sessionId,
    required bool pinned,
  }) async {
    pins.add((sessionId, pinned));
    return true;
  }

  @override
  Future<bool> setSessionArchived({
    required String sessionId,
    required bool archived,
    bool clearPin = false,
  }) async {
    this.archived.add(sessionId);
    rows = rows.where((s) => s.id != sessionId).toList();
    return true;
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    deleted.add(sessionId);
    rows = rows.where((s) => s.id != sessionId).toList();
  }

  @override
  Future<void> setSessionUnread(String sessionId, {required bool unread}) =>
      Future.value();
}

class _Harness {
  _Harness(this.api, this.model, this.gateway, this.opened);

  final _FakeApi api;
  final NgSessionsModel model;
  final NextGenGateway gateway;
  final List<String> opened;

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    model.dispose();
    gateway.dispose();
  }
}

Future<_Harness> _pump(
  WidgetTester tester, {
  Size size = const Size(1280, 800),
  String current = 'open',
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // Every row was looked at just now except "u", which has news.
  final seen = ['open', 'a', 'b', 'run', 'daily'].map((id) => '"$id": $_now');
  SharedPreferences.setMockInitialValues({
    'nextgen.seen_chats.c1':
        '{"since": ${_now - 3600}, "chats": {${seen.join(', ')}}}',
  });
  final prefs = await SharedPreferences.getInstance();
  final conn = _conn();
  final gateway = NextGenGateway(conn);
  final api = _FakeApi(gateway.dashboard, _rows());
  gateway.api = api;
  NgScope scope(Widget child) => NgScope(
    connManager: ConnectionManager(prefs),
    gateway: gateway,
    connections: [conn],
    switchTo: (_) async {},
    addGateway: () async {},
    signOut: (_) async {},
    reload: () async {},
    signInAgain: () async {},
    child: child,
  );
  final model = NgSessionsModel(scope(const SizedBox()))
    ..sessions = _rows()
    ..currentId = current;
  final opened = <String>[];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: nextGenTheme(Brightness.light, NextGenLook.instance),
      home: scope(
        Scaffold(
          body: NgSessionsSidebar(
            model: model,
            currentSessionId: current,
            onOpen: (s) => opened.add(s.id),
            onNewChat: () {},
            onDestination: (_) {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return _Harness(api, model, gateway, opened);
}

Future<void> _on(TargetPlatform platform, Future<void> Function() body) async {
  debugDefaultTargetPlatformOverride = platform;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

Future<Offset> _rightClick(WidgetTester tester, String title) async {
  final at = tester.getCenter(find.text(title));
  await tester.tapAt(
    at,
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryMouseButton,
  );
  await _settle(tester);
  return at;
}

Finder _menuItem(String label) => find.descendant(
  of: find.byType(PopupMenuItem<String>),
  matching: find.text(label),
);

List<String> _menuLabels(WidgetTester tester) => [
  for (final e
      in find
          .descendant(
            of: find.byType(PopupMenuItem<String>),
            matching: find.byType(Text),
          )
          .evaluate())
    (e.widget as Text).data!,
];

List<String> _sheetLabels(WidgetTester tester) => [
  for (final e
      in find
          .descendant(
            of: find.byType(BottomSheet),
            matching: find.byType(ListTile),
          )
          .evaluate())
    ((e.widget as ListTile).title! as Text).data!,
];

Finder _more(String id) => find.byKey(ValueKey('ng-session-more-$id'));

Finder _dot(String label) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == label,
);

Future<void> _closeMenu(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await _settle(tester);
}

void main() {
  testWidgets('Copy session ID copies the selected row, not the open chat', (
    tester,
  ) async {
    final h = await _pump(tester);
    String? copied;
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied = (call.arguments as Map)['text'] as String?;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    await _rightClick(tester, 'Alpha');
    await tester.tap(_menuItem('Copy session ID'));
    await _settle(tester);
    expect(copied, 'a');
    expect(h.opened, isEmpty);
    await h.dispose(tester);
  });
  const desktops = [TargetPlatform.windows, TargetPlatform.macOS];

  for (final platform in desktops) {
    group(platform.name, () {
      testWidgets('right-click opens a menu at the cursor; Pin and Unpin '
          'write the pin', (tester) async {
        await _on(platform, () async {
          final h = await _pump(tester);
          final at = await _rightClick(tester, 'Alpha');
          expect(_menuItem('Pin'), findsOneWidget);
          expect(find.byType(BottomSheet), findsNothing);
          expect(_menuLabels(tester), [
            'Pin',
            'Mark as unread',
            'Copy session ID',
            'Rename',
            'Archive',
            'Delete',
          ]);
          // Anchored at the cursor, not centred or docked to an edge.
          final pin = tester.getRect(
            find.ancestor(
              of: _menuItem('Pin'),
              matching: find.byType(PopupMenuItem<String>),
            ),
          );
          expect((pin.left - at.dx).abs(), lessThanOrEqualTo(1));
          expect(pin.top - at.dy, inInclusiveRange(0, 16));
          // Delete is drawn in the danger colour.
          final c = NgColors.of(tester.element(find.text('Alpha')));
          final delete = tester.widget<Text>(_menuItem('Delete'));
          expect(delete.style?.color, c.danger);

          await tester.tap(_menuItem('Pin'));
          await _settle(tester);
          expect(h.api.pins, [('a', true)]);
          expect(h.opened, isEmpty, reason: 'right-click must not open');

          await _rightClick(tester, 'Beta');
          expect(_menuItem('Unpin'), findsOneWidget);
          await tester.tap(_menuItem('Unpin'));
          await _settle(tester);
          expect(h.api.pins, [('a', true), ('b', false)]);
          await h.dispose(tester);
        });
      });

      testWidgets('hovering a row swaps its time for a ⋯ button that opens '
          'the same menu under it', (tester) async {
        await _on(platform, () async {
          final h = await _pump(tester);
          // The open chat keeps its ⋯ on desktop; other rows show none
          // until hovered.
          expect(_more('open'), findsOneWidget);
          expect(_more('a'), findsNothing);
          expect(_more('u'), findsNothing);
          final title = tester.getRect(find.text('Unread one'));
          final dot = tester.getRect(_dot('Finished, unread reply'));
          final spinner = tester.getRect(
            find.byType(CircularProgressIndicator),
          );

          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          addTearDown(mouse.removePointer);
          await mouse.moveTo(tester.getCenter(find.text('Unread one')));
          await tester.pump();
          expect(_more('u'), findsOneWidget);
          expect(find.byTooltip('Chat actions'), findsNWidgets(2));
          expect(_more('a'), findsNothing);
          // The title stays put and the unread dot stays visible beside the
          // button.
          expect(tester.getRect(find.text('Unread one')), title);
          expect(tester.getRect(_dot('Finished, unread reply')), dot);
          final button = tester.getRect(_more('u'));
          expect(button.right, lessThanOrEqualTo(dot.left));
          expect(button.overlaps(title.deflate(1)), isFalse);

          // A running chat keeps its spinner while hovered.
          await mouse.moveTo(tester.getCenter(find.text('Running job')));
          await tester.pump();
          expect(_more('run'), findsOneWidget);
          expect(_more('u'), findsNothing);
          expect(
            tester.getRect(find.byType(CircularProgressIndicator)),
            spinner,
          );

          await mouse.moveTo(tester.getCenter(find.text('Unread one')));
          await tester.pump();
          await mouse.moveTo(tester.getCenter(_more('u')));
          await tester.pump();
          await mouse.down(tester.getCenter(_more('u')));
          await mouse.up();
          await _settle(tester);
          expect(h.opened, isEmpty, reason: '⋯ must not open the chat');
          expect(_menuLabels(tester), [
            'Pin',
            'Mark as read',
            'Copy session ID',
            'Rename',
            'Archive',
            'Delete',
          ]);
          final pin = tester.getRect(
            find.ancestor(
              of: _menuItem('Pin'),
              matching: find.byType(PopupMenuItem<String>),
            ),
          );
          final more = tester.getRect(_more('u'));
          expect((pin.left - more.left).abs(), lessThanOrEqualTo(1));
          expect(pin.top - more.bottom, inInclusiveRange(0, 16));

          await tester.tap(_menuItem('Archive'));
          await _settle(tester);
          expect(h.api.archived, ['u']);
          expect(find.text('Unread one'), findsNothing);
          await h.dispose(tester);
        });
      });

      testWidgets('Mark read is hidden for the open chat; Delete confirms', (
        tester,
      ) async {
        await _on(platform, () async {
          final h = await _pump(tester);
          await _rightClick(tester, 'On screen');
          expect(_menuLabels(tester), [
            'Pin',
            'Copy session ID',
            'Rename',
            'Archive',
            'Delete',
          ]);
          await _closeMenu(tester);

          await _rightClick(tester, 'Alpha');
          await tester.tap(_menuItem('Delete'));
          await _settle(tester);
          expect(find.text('Delete this chat?'), findsOneWidget);
          await tester.tap(find.text('Cancel'));
          await _settle(tester);
          expect(h.api.deleted, isEmpty);
          expect(find.text('Alpha'), findsOneWidget);

          await _rightClick(tester, 'Alpha');
          await tester.tap(_menuItem('Delete'));
          await _settle(tester);
          await tester.tap(
            find.descendant(
              of: find.byType(AlertDialog),
              matching: find.text('Delete'),
            ),
          );
          await _settle(tester);
          expect(h.api.deleted, ['a']);
          expect(find.text('Alpha'), findsNothing);
          await h.dispose(tester);
        });
      });

      testWidgets('a focused row shows ⋯ and Shift+F10 or the menu key opens '
          'the menu', (tester) async {
        await _on(platform, () async {
          final h = await _pump(tester);
          Focus.of(tester.element(find.text('Alpha'))).requestFocus();
          await tester.pump();
          expect(_more('a'), findsOneWidget);

          await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.f10);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await _settle(tester);
          expect(_menuItem('Pin'), findsOneWidget);
          await _closeMenu(tester);
          expect(_menuItem('Pin'), findsNothing);

          Focus.of(tester.element(find.text('Alpha'))).requestFocus();
          await tester.pump();
          await tester.sendKeyEvent(LogicalKeyboardKey.contextMenu);
          await _settle(tester);
          expect(_menuItem('Pin'), findsOneWidget);
          await tester.tap(_menuItem('Pin'));
          await _settle(tester);
          expect(h.api.pins, [('a', true)]);
          expect(h.opened, isEmpty);
          await h.dispose(tester);
        });
      });

      testWidgets('long-press still opens the bottom sheet', (tester) async {
        await _on(platform, () async {
          final h = await _pump(tester);
          await tester.longPress(find.text('Alpha'));
          await _settle(tester);
          expect(find.byType(BottomSheet), findsOneWidget);
          expect(find.byType(PopupMenuItem<String>), findsNothing);
          expect(_sheetLabels(tester), [
            'Pin',
            'Mark as unread',
            'Copy session ID',
            'Rename',
            'Archive',
            'Delete',
          ]);
          await h.dispose(tester);
        });
      });
    });
  }

  testWidgets('Crons rows get the same menu as their long-press sheet', (
    tester,
  ) async {
    await _on(TargetPlatform.windows, () async {
      final h = await _pump(tester);
      await tester.ensureVisible(find.text('Crons'));
      await tester.pump();
      await tester.tap(find.text('Crons'));
      await _settle(tester);
      expect(find.text('Daily report'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);

      await tester.longPress(find.text('Daily report'));
      await _settle(tester);
      final sheet = _sheetLabels(tester);
      expect(sheet, [
        'Pin',
        'Mark as unread',
        'Copy session ID',
        'Rename',
        'Archive',
        'Delete',
      ]);
      await tester.tapAt(const Offset(1000, 20));
      await _settle(tester);
      expect(find.byType(BottomSheet), findsNothing);

      await _rightClick(tester, 'Daily report');
      expect(_menuLabels(tester), sheet);
      await tester.tap(_menuItem('Pin'));
      await _settle(tester);
      expect(h.api.pins, [('daily', true)]);
      expect(h.opened, isEmpty);
      await h.dispose(tester);
    });
  });

  testWidgets('Android phone: no ⋯ without a mouse, layout unchanged, '
      'long-press sheet unchanged', (tester) async {
    await _on(TargetPlatform.android, () async {
      final h = await _pump(tester, size: const Size(412, 915));
      Map<String, Rect> rects() => {
        for (final (key, title, time) in [
          ('ng-session-open', 'On screen', '5m'),
          ('ng-session-a', 'Alpha', '5m'),
          ('ng-session-b', 'Beta', '5m'),
          ('ng-session-u-finished', 'Unread one', '2m'),
          ('ng-session-run', 'Running job', '5m'),
        ]) ...{
          title: tester.getRect(find.text(title)),
          '$title time': tester.getRect(
            find.descendant(
              of: find.byKey(ValueKey(key)),
              matching: find.text(time),
            ),
          ),
        },
        'dot': tester.getRect(_dot('Finished, unread reply')),
        'spinner': tester.getRect(find.byType(CircularProgressIndicator)),
      };
      final before = rects();
      // Recorded on 66fb445 (v4.0.15) with the same fixture.
      expect(before, _kAndroidRects);
      expect(find.byTooltip('Chat actions'), findsNothing);

      // A finger resting on and sliding along a row is not a hover.
      final finger = await tester.startGesture(
        tester.getCenter(find.text('Alpha')),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await finger.moveBy(const Offset(-40, 0));
      await tester.pump();
      expect(find.byTooltip('Chat actions'), findsNothing);
      expect(rects(), before);
      await finger.cancel();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byTooltip('Chat actions'), findsNothing);
      expect(rects(), before);

      await tester.longPress(find.text('Alpha'));
      await _settle(tester);
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byType(PopupMenuItem<String>), findsNothing);
      expect(_sheetLabels(tester), [
        'Pin',
        'Mark as unread',
        'Copy session ID',
        'Rename',
        'Archive',
        'Delete',
      ]);
      await tester.tap(find.text('Pin').last);
      await _settle(tester);
      expect(h.api.pins, [('a', true)]);
      await h.dispose(tester);
    });
  });
}

/// Title, time, unread-dot and spinner rects of the phone fixture on
/// 66fb445, before the menu existed.
const _kAndroidRects = <String, Rect>{
  'On screen': Rect.fromLTRB(22.0, 407.0, 280.13999938964844, 424.0),
  'On screen time': Rect.fromLTRB(288.13999938964844, 407.5, 312.0, 423.5),
  'Alpha': Rect.fromLTRB(22.0, 446.0, 280.13999938964844, 463.0),
  'Alpha time': Rect.fromLTRB(288.13999938964844, 446.5, 312.0, 462.5),
  'Beta': Rect.fromLTRB(22.0, 326.0, 280.13999938964844, 343.0),
  'Beta time': Rect.fromLTRB(288.13999938964844, 326.5, 312.0, 342.5),
  'Unread one': Rect.fromLTRB(22.0, 485.0, 264.13999938964844, 502.0),
  'Unread one time': Rect.fromLTRB(272.13999938964844, 485.5, 296.0, 501.5),
  'Running job': Rect.fromLTRB(42.0, 524.0, 280.13999938964844, 541.0),
  'Running job time': Rect.fromLTRB(288.13999938964844, 524.5, 312.0, 540.5),
  'dot': Rect.fromLTRB(304.0, 489.5, 312.0, 497.5),
  'spinner': Rect.fromLTRB(22.0, 527.5, 32.0, 537.5),
};
