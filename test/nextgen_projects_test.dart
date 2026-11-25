import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/projects_root_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/core/widgets/project_detail_screen.dart';
import 'package:hermes_android/core/widgets/projects_pane.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/more_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/mtls_fixture.dart';

SavedConnection _connection({String id = 'c1', String profile = 'work'}) =>
    SavedConnection(
      id: id,
      label: profile,
      host: 'gateway.example',
      port: 443,
      apiKey: '',
      useHttps: true,
      desktopGatewayUrl: 'https://gateway.example/hermes',
      dashboardPrefix: '/hermes',
      dashboardProxied: true,
      gatewayProfile: profile,
      singleLogin: true,
      signInMethod: 'none',
    );

class _Gateway extends NextGenGateway {
  _Gateway(super.connection)
    : super(
        dashboard: DashboardClient.fromConnection(
          connection,
          httpClient: MockClient((request) async {
            expectSync(request.method, 'GET', reason: 'no settings writes');
            expectSync(request.url.path, startsWith('/hermes/api/'));
            if (request.url.path.endsWith('/messages')) {
              return http.Response(jsonEncode({'messages': []}), 200);
            }
            if (request.url.path.endsWith('/sessions')) {
              return http.Response(jsonEncode({'sessions': []}), 200);
            }
            return http.Response(jsonEncode({'model': 'test-model'}), 200);
          }),
        ),
      );

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  final calls = <({String method, Map<String, dynamic> params})>[];
  final dummy = WsClient('https://gateway.example/hermes');
  Completer<void>? listGate;
  Completer<void>? treeGate;
  Completer<void>? detailGate;
  bool folderless = false;
  bool empty = false;
  bool includeFolderless = false;
  Completer<void>? createGate;
  Completer<void>? connectionGate;
  Object? createError;
  String? actualCwd;
  final created = Completer<void>();
  bool unsupported = false;
  int count = 2;

  Map<String, dynamic> get project => {
    'id': 'p1',
    'slug': 'project',
    'name': '${profile!} project',
    'primary_path': folderless ? null : '/srv/${profile!}/project',
    'folders': [],
  };

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    await connectionGate?.future;
    return dummy;
  }

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    calls.add((method: method, params: Map.of(params)));
    switch (method) {
      case 'projects.list':
        await listGate?.future;
        if (unsupported) {
          throw JsonRpcError(method, 'Method not found', code: -32601);
        }
        return {
          'projects': [
            if (!empty) project,
            if (includeFolderless)
              {
                'id': 'p2',
                'slug': 'no-folder',
                'name': 'No folder',
                'folders': [],
              },
          ],
        };
      case 'projects.tree':
        final snapshot = count;
        await treeGate?.future;
        return {
          'projects': [
            {'id': 'p1', 'label': project['name'], 'sessionCount': snapshot},
          ],
        };
      case 'projects.project_sessions':
        await detailGate?.future;
        return {
          'project': {
            'id': 'p1',
            'label': project['name'],
            'sessionCount': count,
            'repos': [
              {
                'id': 'repo',
                'label': 'repo',
                'groups': [
                  {
                    'id': 'main',
                    'label': 'main',
                    'isMain': true,
                    'sessions': [
                      {
                        'id': 'stored-project-chat',
                        'title': 'Existing project conversation',
                        'source': 'cli',
                        'message_count': 2,
                        'started_at': 1750000000,
                      },
                    ],
                  },
                ],
              },
            ],
          },
        };
      case 'session.resume':
        return {'session_id': 'runtime-existing', 'running': false};
      case 'session.create':
        if (!created.isCompleted) created.complete();
        await createGate?.future;
        if (createError != null) throw createError!;
        return {
          'session_id': 'runtime-new',
          'stored_session_id': 'stored-new',
          if (actualCwd != null) 'info': {'cwd': actualCwd},
        };
      case 'prompt.submit':
        return {'status': 'started'};
      default:
        return {};
    }
  }

  int reads(String method) => calls.where((c) => c.method == method).length;
}

Future<void> _frames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _app(
  WidgetTester tester,
  ValueNotifier<NextGenGateway> selected, {
  bool main = false,
  Locale locale = const Locale('en'),
  double textScale = 1,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final manager = ConnectionManager(prefs);
  await tester.pumpWidget(
    ValueListenableBuilder<NextGenGateway>(
      valueListenable: selected,
      builder: (_, gateway, _) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: NgLocalizationScope(
            child: NgScope(
              connManager: manager,
              gateway: gateway,
              connections: [gateway.connection],
              switchTo: (_) async {},
              addGateway: () async {},
              signOut: (_) async {},
              reload: () async {},
              signInAgain: () async {},
              child: child!,
            ),
          ),
        ),
        home: main ? const NgMainPage() : NgMorePage(onOpenSession: (_) {}),
      ),
    ),
  );
  await _frames(tester);
}

Future<void> _browse(WidgetTester tester, {bool main = false}) async {
  if (main) {
    final chat = tester.widget<NgChatView>(find.byType(NgChatView));
    chat.onOpenSidebar();
    await _frames(tester);
    await tester.tap(find.text('More'));
    await _frames(tester);
  }
  await tester.tap(find.text('Projects'));
  await _frames(tester);
  expect(find.byType(ProjectsPane), findsOneWidget);
  expect(find.byType(ProjectsRootScreen), findsNothing);
}

Future<void> _detail(WidgetTester tester, NextGenGateway gateway) async {
  await tester.tap(find.text('${gateway.profile} project'));
  await _frames(tester);
  expect(find.byType(ProjectDetailScreen), findsOneWidget);
}

Future<void> _close(WidgetTester tester, List<_Gateway> gateways) async {
  await tester.pumpWidget(const SizedBox());
  for (final gateway in gateways) {
    gateway.dispose();
  }
  await _frames(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    nextGenOpenRequest.value = null;
    nextGenNotificationAnswer.value = null;
  });

  testWidgets(
    'new chat greeting offers a project picker without replacing its draft',
    (tester) async {
      final gateway = _Gateway(_connection());
      await _app(tester, ValueNotifier(gateway), main: true);
      expect(find.byKey(const Key('nextgen-project-picker')), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'Keep this draft');
      final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
      await tester.tap(find.byKey(const Key('nextgen-project-picker')));
      await _frames(tester);
      await tester.tap(
        find.widgetWithText(CheckedPopupMenuItem<String>, 'work project'),
      );
      await _frames(tester);
      expect(
        tester.widget<NgChatView>(find.byType(NgChatView)).chat,
        same(chat),
      );
      expect(chat.workingDirectory, '/srv/work/project');
      expect(find.text('Keep this draft'), findsOneWidget);
      expect(gateway.reads('session.create'), 0);
      await _close(tester, [gateway]);
    },
  );

  testWidgets(
    'picker send is explicit, hides after create and excludes folderless projects',
    (tester) async {
      final gateway = _Gateway(_connection())..includeFolderless = true;
      await _app(tester, ValueNotifier(gateway), main: true);
      await tester.tap(find.byKey(const Key('nextgen-project-picker')));
      await _frames(tester);
      expect(find.text('No folder'), findsNothing);
      await tester.tap(
        find.widgetWithText(CheckedPopupMenuItem<String>, 'work project'),
      );
      await _frames(tester);
      final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
      expect(await chat.send('Run pwd'), isTrue);
      await _frames(tester);
      expect(find.byKey(const Key('nextgen-project-picker')), findsNothing);
      expect(chat.startIn('/wrong'), isFalse);
      final params = gateway.calls
          .singleWhere((c) => c.method == 'session.create')
          .params;
      expect(params['cwd'], '/srv/work/project');
      expect(params['cwd_explicit'], true);
      await _close(tester, [gateway]);
    },
  );

  testWidgets('Home clears a pending cwd and sends neither cwd field', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    await _app(tester, ValueNotifier(gateway), main: true);
    final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    expect(chat.startIn('/srv/work/project/'), true);
    await _frames(tester);
    expect(
      find.text('work project'),
      findsOneWidget,
      reason: 'trailing slash matches project',
    );
    await tester.tap(find.byKey(const Key('nextgen-project-picker')));
    await _frames(tester);
    await tester.tap(find.widgetWithText(CheckedPopupMenuItem<String>, 'Home'));
    await _frames(tester);
    expect(chat.workingDirectory, isNull);
    await chat.send('Home prompt');
    final params = gateway.calls
        .singleWhere((c) => c.method == 'session.create')
        .params;
    expect(params.containsKey('cwd'), false);
    expect(params.containsKey('cwd_explicit'), false);
    await _close(tester, [gateway]);
  });

  testWidgets(
    'held Projects never blocks typing and chosen cwd stays visible',
    (tester) async {
      final gateway = _Gateway(_connection())..listGate = Completer<void>();
      await _app(tester, ValueNotifier(gateway), main: true);
      expect(find.byKey(const Key('nextgen-project-picker')), findsNothing);
      await tester.enterText(
        find.byType(TextField).last,
        'Typing while projects load',
      );
      final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
      expect(chat.startIn('/srv/chosen'), true);
      await _frames(tester);
      expect(find.byKey(const Key('nextgen-project-picker')), findsOneWidget);
      expect(find.text('chosen'), findsOneWidget);
      expect(find.text('Typing while projects load'), findsOneWidget);
      gateway.listGate!.complete();
      await _frames(tester);
      await _close(tester, [gateway]);
    },
  );

  for (final empty in [false, true]) {
    testWidgets(
      'picker hidden with ${empty ? 'no projects' : 'only folderless projects'}',
      (tester) async {
        final gateway = _Gateway(_connection())
          ..empty = empty
          ..folderless = !empty;
        await _app(tester, ValueNotifier(gateway), main: true);
        expect(find.byKey(const Key('nextgen-project-picker')), findsNothing);
        await _close(tester, [gateway]);
      },
    );
  }

  for (final newConnection in [false, true]) {
    testWidgets(
      'pending pick resets on ${newConnection ? 'connection' : 'profile'} replacement',
      (tester) async {
        final old = _Gateway(_connection(profile: 'old'));
        final next = _Gateway(
          _connection(id: newConnection ? 'c2' : 'c1', profile: 'next'),
        );
        final selected = ValueNotifier<NextGenGateway>(old);
        await _app(tester, selected, main: true);
        final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
        expect(chat.startIn('/srv/old/project'), true);
        await _frames(tester);
        // Hold an open popup across the authority switch too.
        await tester.tap(find.byKey(const Key('nextgen-project-picker')));
        await _frames(tester);
        final stalePick = tester
            .widget<PopupMenuButton<String>>(
              find.byKey(const Key('nextgen-project-picker')),
            )
            .onSelected!;
        selected.value = next;
        await _frames(tester);
        stalePick('/srv/old/project');
        final current = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
        expect(current, isNot(same(chat)));
        expect(current.gateway, same(next));
        expect(current.workingDirectory, isNull);
        expect(next.reads('session.create'), 0);
        final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
        nav.popUntil((route) => route.isFirst);
        await _frames(tester);
        await tester.tap(find.byKey(const Key('nextgen-project-picker')));
        await _frames(tester);
        expect(find.text('old project'), findsNothing);
        expect(find.text('next project'), findsOneWidget);
        await _close(tester, [old, next]);
      },
    );
  }

  for (final authority in [false, true]) {
    test(
      'explicit cwd survives first create (${authority ? 'canonical' : 'legacy'})',
      () async {
        final gateway = _Gateway(_connection());
        if (authority) {
          gateway.readyFrame = {
            'params': {
              'type': 'gateway.ready',
              'payload': {'session_authority': true},
            },
          };
        }
        final chat = NgChatController(
          gateway,
          workingDirectory: '/srv/work/project',
        );
        addTearDown(() {
          chat.dispose();
          gateway.dispose();
        });
        expect(await chat.send('pwd'), true);
        final params = gateway.calls
            .singleWhere((c) => c.method == 'session.create')
            .params;
        expect(params['cwd'], '/srv/work/project');
        expect(params['cwd_explicit'], true);
      },
    );
  }

  test(
    'creation locks picks before connection wait and throughout held create',
    () async {
      final gateway = _Gateway(_connection())
        ..connectionGate = Completer<void>()
        ..createGate = Completer<void>();
      final chat = NgChatController(gateway);
      addTearDown(() {
        chat.dispose();
        gateway.dispose();
      });
      expect(chat.startIn('/srv/work/project'), true);
      final send = chat.send('pwd');
      expect(chat.startIn('/wrong'), false);
      gateway.connectionGate!.complete();
      await gateway.created.future;
      expect(chat.startIn(null), false);
      gateway.createGate!.complete();
      expect(await send, true);
      expect(chat.startIn(null), false);
      expect(gateway.reads('session.create'), 1);
    },
  );

  test(
    'older closed contract refuses explicit cwd without an unsafe create retry',
    () async {
      final gateway = _Gateway(_connection())
        ..createError = JsonRpcError(
          'session.create',
          'invalid params for session.create: cwd_explicit: Extra inputs are not permitted — run hermes update',
          code: 4000,
        );
      final chat = NgChatController(
        gateway,
        workingDirectory: '/srv/work/project',
      );
      addTearDown(() {
        chat.dispose();
        gateway.dispose();
      });
      expect(await chat.send('pwd'), false);
      expect(gateway.reads('session.create'), 1);
      expect(gateway.reads('prompt.submit'), 0);
      expect(
        chat.items.whereType<NgUserItem>().single.failure,
        contains('cwd_explicit'),
      );
      expect(chat.workingDirectory, '/srv/work/project');
    },
  );

  test('ambiguous create never retries or unlocks the pending cwd', () async {
    final gateway = _Gateway(_connection())
      ..createError = TimeoutException('lost create acknowledgement');
    final chat = NgChatController(
      gateway,
      workingDirectory: '/srv/work/project',
    );
    addTearDown(() {
      chat.dispose();
      gateway.dispose();
    });
    expect(await chat.send('pwd'), false);
    expect(chat.startIn(null), false);
    expect(await chat.send('try again'), false);
    await chat.retryLast();
    expect(gateway.reads('session.create'), 1);
    expect(gateway.reads('prompt.submit'), 0);
  });

  test(
    'gateway cwd mismatch is visible but equivalent trailing slash is not',
    () async {
      final gateway = _Gateway(_connection())..actualCwd = '/fallback';
      final chat = NgChatController(gateway, workingDirectory: '/missing');
      addTearDown(() {
        chat.dispose();
        gateway.dispose();
      });
      expect(await chat.send('pwd'), true);
      expect(chat.error, contains('/fallback'));
      final same = NgChatController(gateway, workingDirectory: '/fallback/');
      expect(await same.send('pwd'), true);
      expect(same.error, isNull);
      same.dispose();
    },
  );

  test(
    'internal create error is also ambiguous and cannot mint another session',
    () async {
      final gateway = _Gateway(_connection())
        ..createError = JsonRpcError(
          'session.create',
          'handler error after mint',
          code: -32000,
        );
      final chat = NgChatController(
        gateway,
        workingDirectory: '/srv/work/project',
      );
      addTearDown(() {
        chat.dispose();
        gateway.dispose();
      });
      expect(await chat.send('pwd'), false);
      await chat.retryLast();
      expect(gateway.reads('session.create'), 1);
      expect(gateway.reads('prompt.submit'), 0);
    },
  );

  testWidgets('greeting stays hidden on an existing empty stored chat', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    await _app(tester, ValueNotifier(gateway), main: true);
    await _browse(tester, main: true);
    await _detail(tester, gateway);
    await tester.tap(find.text('Existing project conversation'));
    await _frames(tester);
    expect(find.byKey(const Key('nextgen-project-picker')), findsNothing);
    expect(
      tester.widget<NgChatView>(find.byType(NgChatView)).chat.startIn('/wrong'),
      false,
    );
    await _close(tester, [gateway]);
  });

  testWidgets('browser and greeting reuse the exact same Projects repository', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    final prefs = await SharedPreferences.getInstance();
    await _app(tester, ValueNotifier(gateway), main: true);
    final projects = gateway.projects(prefs);
    await _browse(tester, main: true);
    expect(
      tester.widget<ProjectsPane>(find.byType(ProjectsPane)).repository,
      same(projects.repository),
    );
    await _close(tester, [gateway]);
  });

  test(
    'disposing an owner during held create cannot publish or submit',
    () async {
      final gateway = _Gateway(_connection())..createGate = Completer<void>();
      var published = 0;
      final chat = NgChatController(
        gateway,
        workingDirectory: '/srv/old/project',
        onCreated: (_) => published++,
      );
      final send = chat.send('Do not run after scope switch');
      await gateway.created.future;
      chat.dispose();
      gateway.createGate!.complete();
      expect(await send, false);
      expect(published, 0);
      expect(gateway.reads('session.create'), 1);
      expect(gateway.reads('prompt.submit'), 0);
      gateway.dispose();
    },
  );

  testWidgets('late greeting list cannot restore an old scope cwd or choices', (
    tester,
  ) async {
    final old = _Gateway(_connection(profile: 'old'))
      ..listGate = Completer<void>();
    final next = _Gateway(_connection(profile: 'next'));
    final selected = ValueNotifier<NextGenGateway>(old);
    await _app(tester, selected, main: true);
    final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    chat.startIn('/srv/old/project');
    selected.value = next;
    await _frames(tester);
    old.listGate!.complete();
    await _frames(tester);
    final current = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    expect(current.workingDirectory, isNull);
    await tester.tap(find.byKey(const Key('nextgen-project-picker')));
    await _frames(tester);
    expect(find.text('old project'), findsNothing);
    expect(find.text('next project'), findsOneWidget);
    expect(next.reads('session.create'), 0);
    await _close(tester, [old, next]);
  });

  testWidgets('root cwd keeps a nonempty greeting label while projects load', (
    tester,
  ) async {
    final gateway = _Gateway(_connection())..listGate = Completer<void>();
    await _app(tester, ValueNotifier(gateway), main: true);
    final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    chat.startIn('/');
    await _frames(tester);
    expect(find.text('/'), findsOneWidget);
    gateway.listGate!.complete();
    await _frames(tester);
    await _close(tester, [gateway]);
  });

  for (final locale in [
    const Locale('en'),
    const Locale('de'),
    const Locale('ja'),
    const Locale('ru'),
  ]) {
    testWidgets('project picker fits narrow phone at large text in $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final gateway = _Gateway(
        _connection(profile: 'A very long project name for testing ellipsis'),
      );
      final selected = ValueNotifier<NextGenGateway>(gateway);
      await _app(tester, selected, main: true, locale: locale, textScale: 2);
      expect(find.byKey(const Key('nextgen-project-picker')), findsOneWidget);
      final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
      chat.startIn(
        '/srv/A very long project name for testing ellipsis/project',
      );
      await _frames(tester);
      await tester.tap(find.byKey(const Key('nextgen-project-picker')));
      await _frames(tester);
      final home = lookupAppLocalizations(locale).ng_project_home;
      expect(
        find.widgetWithText(CheckedPopupMenuItem<String>, home),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.widgetWithText(CheckedPopupMenuItem<String>, home));
      await _frames(tester);
      expect(chat.workingDirectory, isNull);
      expect(tester.takeException(), isNull);
      // Reset the process-wide NextGen strings for following tests.
      await _app(tester, selected, main: true);
      await _close(tester, [gateway]);
    });
  }

  testWidgets('More browses Classic projects and refreshes counts on return', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    await _app(tester, ValueNotifier(gateway));
    await _browse(tester);
    expect(find.text('work project'), findsOneWidget);
    expect(find.text('2 chats'), findsOneWidget);
    expect(gateway.reads('session.create'), 0);
    expect(gateway.reads('session.resume'), 0);
    await _detail(tester, gateway);
    gateway.count = 7;
    await tester.pageBack();
    await _frames(tester);
    expect(find.text('7 chats'), findsOneWidget);
    expect(gateway.reads('projects.tree'), 2);
    await tester.pageBack();
    await _frames(tester);
    await tester.tap(find.text('Projects folder on the server'));
    await _frames(tester);
    expect(find.byType(ProjectsRootScreen), findsOneWidget);
    await _close(tester, [gateway]);
  });

  testWidgets('existing project chat uses the normal NextGen owner and route', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    await _app(tester, ValueNotifier(gateway), main: true);
    await _browse(tester, main: true);
    await _detail(tester, gateway);
    await tester.tap(find.text('Existing project conversation'));
    await _frames(tester);
    expect(find.byType(ProjectDetailScreen), findsNothing);
    final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    expect(chat.storedId, 'stored-project-chat');
    expect(chat.gateway, same(gateway));
    expect(gateway.reads('session.create'), 0);
    final resume = gateway.calls.singleWhere(
      (c) => c.method == 'session.resume',
    );
    expect(resume.params['session_id'], 'stored-project-chat');
    expect(
      NextGenPreferences.lastSession(
        await SharedPreferences.getInstance(),
        'c1',
      ),
      'stored-project-chat',
    );
    await _close(tester, [gateway]);
  });

  testWidgets('new project chat binds cwd on its first actual create', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    await _app(tester, ValueNotifier(gateway), main: true);
    await _browse(tester, main: true);
    await _detail(tester, gateway);
    await tester.tap(find.byKey(kProjectNewChatButtonKey));
    await _frames(tester);
    final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    expect(chat.isNew, isTrue);
    expect(chat.gateway, same(gateway));
    expect(chat.workingDirectory, '/srv/work/project');
    expect(gateway.reads('session.create'), 0);
    await chat.send('Project prompt');
    await _frames(tester);
    final create = gateway.calls.singleWhere(
      (c) => c.method == 'session.create',
    );
    expect(create.params['cwd'], '/srv/work/project');
    expect(create.params['cwd_explicit'], isTrue);
    expect(gateway.reads('projects.assign_session'), 0);
    expect(gateway.reads('config.set'), 0);
    await _close(tester, [gateway]);
  });

  testWidgets('folderless project cannot replace the open draft', (
    tester,
  ) async {
    final gateway = _Gateway(_connection())..folderless = true;
    await _app(tester, ValueNotifier(gateway), main: true);
    final original = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
    await tester.enterText(find.byType(TextField).last, 'Unsent draft');
    await _browse(tester, main: true);
    await _detail(tester, gateway);
    await tester.tap(find.byKey(kProjectNewChatButtonKey));
    await _frames(tester);
    expect(find.textContaining('This Project needs a folder'), findsOneWidget);
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(gateway.reads('session.create'), 0);
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.popUntil((route) => route.isFirst);
    await _frames(tester);
    expect(
      tester.widget<NgChatView>(find.byType(NgChatView)).chat,
      same(original),
    );
    expect(find.text('Unsent draft'), findsOneWidget);
    await _close(tester, [gateway]);
  });

  testWidgets('normal New chat clears Project cwd without creating a session', (
    tester,
  ) async {
    final gateway = _Gateway(_connection());
    await _app(tester, ValueNotifier(gateway), main: true);
    await _browse(tester, main: true);
    await _detail(tester, gateway);
    await tester.tap(find.byKey(kProjectNewChatButtonKey));
    await _frames(tester);
    var view = tester.widget<NgChatView>(find.byType(NgChatView));
    expect(view.chat.workingDirectory, '/srv/work/project');
    view.onNewChat();
    await _frames(tester);
    view = tester.widget<NgChatView>(find.byType(NgChatView));
    expect(view.chat.workingDirectory, isNull);
    expect(gateway.reads('session.create'), 0);
    await _close(tester, [gateway]);
  });

  testWidgets(
    'leaving Projects during a held read cannot publish after disposal',
    (tester) async {
      final gateway = _Gateway(_connection())..detailGate = Completer<void>();
      await _app(tester, ValueNotifier(gateway));
      await _browse(tester);
      await _detail(tester, gateway);
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.popUntil((route) => route.isFirst);
      await _frames(tester);
      gateway.detailGate!.complete();
      await _frames(tester);
      expect(find.byType(ProjectDetailScreen), findsNothing);
      expect(gateway.reads('session.resume'), 0);
      expect(tester.takeException(), isNull);
      await _close(tester, [gateway]);
    },
  );

  testWidgets('profile cache is hidden while the replacement list waits', (
    tester,
  ) async {
    final old = _Gateway(_connection(profile: 'old'));
    final next = _Gateway(_connection(profile: 'next'))
      ..listGate = Completer<void>();
    final selected = ValueNotifier<NextGenGateway>(old);
    await _app(tester, selected);
    await _browse(tester);
    expect(find.text('old project'), findsOneWidget);
    selected.value = next;
    await _frames(tester);
    expect(find.text('old project'), findsNothing);
    expect(find.text('next project'), findsNothing);
    next.listGate!.complete();
    await _frames(tester);
    expect(find.text('next project'), findsOneWidget);
    await _close(tester, [old, next]);
  });

  for (final held in [
    'projects.list',
    'projects.tree',
    'projects.project_sessions',
  ]) {
    for (final differentConnection in [false, true]) {
      testWidgets(
        'scope switch fences held $held (${differentConnection ? 'connection' : 'profile'})',
        (tester) async {
          final gate = Completer<void>();
          final old = _Gateway(_connection(profile: 'old'));
          final next = _Gateway(
            _connection(id: differentConnection ? 'c2' : 'c1', profile: 'next'),
          );
          if (held == 'projects.list') old.listGate = gate;
          if (held == 'projects.tree') old.treeGate = gate;
          if (held == 'projects.project_sessions') old.detailGate = gate;
          final selected = ValueNotifier<NextGenGateway>(old);
          await _app(tester, selected);
          await _browse(tester);
          if (held == 'projects.project_sessions') await _detail(tester, old);
          expect(old.reads(held), 1);
          selected.value = next;
          await _frames(tester);
          expect(find.text('old project'), findsNothing);
          expect(find.text('next project'), findsOneWidget);
          gate.complete();
          await _frames(tester);
          expect(find.text('old project'), findsNothing);
          expect(find.text('next project'), findsOneWidget);
          expect(tester.takeException(), isNull);
          // Reopen: no profile-A disk cache can masquerade as profile B content.
          await tester.pageBack();
          await _frames(tester);
          next.listGate = Completer<void>();
          await _browse(tester);
          expect(find.text('old project'), findsNothing);
          expect(find.text('next project'), findsOneWidget);
          next.listGate!.complete();
          await _frames(tester);
          await _close(tester, [old, next]);
        },
      );
    }
  }

  testWidgets(
    'Projects reuses selected authenticated prefix/profile/mTLS socket',
    (tester) async {
      final fixture = MutualTlsFixture();
      var logins = 0;
      var tickets = 0;
      await tester.runAsync(() async {
        await fixture.start((request) async {
          final path = request.uri.path;
          if (path == '/hermes/auth/password-login') {
            logins++;
            request.response.headers.add(
              'set-cookie',
              'hermes_session_at=fixture-cookie; Path=/',
            );
            fixture.json(request, {'ok': true});
          } else if (path == '/hermes/api/ws') {
            // The ticket, not a cookie or API-server key, authenticates this hop.
            expect(
              request.headers.value('sec-websocket-protocol'),
              contains('fixture-ticket'),
            );
            final socket = await WebSocketTransformer.upgrade(request);
            fixture.sockets.add(socket);
            socket.add(
              jsonEncode({
                'jsonrpc': '2.0',
                'method': 'event',
                'params': {'type': 'gateway.ready', 'payload': {}},
              }),
            );
            socket.listen((raw) {
              final frame = jsonDecode(raw as String) as Map<String, dynamic>;
              fixture.rpcRequests.add(frame);
              final result = switch (frame['method']) {
                'projects.list' => {
                  'projects': [
                    {
                      'id': 'p1',
                      'slug': 'project',
                      'name': 'work project',
                      'primary_path': '/srv/work/project',
                      'folders': [],
                    },
                  ],
                },
                'projects.tree' => {
                  'projects': [
                    {'id': 'p1', 'label': 'work project', 'sessionCount': 5},
                  ],
                },
                'projects.project_sessions' => {
                  'project': {
                    'id': 'p1',
                    'label': 'work project',
                    'sessionCount': 5,
                    'repos': [],
                  },
                },
                _ => <String, dynamic>{},
              };
              socket.add(
                jsonEncode({
                  'jsonrpc': '2.0',
                  'id': frame['id'],
                  'result': result,
                }),
              );
            });
            return;
          } else {
            expect(path, '/hermes/api/auth/ws-ticket');
            expect(
              request.headers.value('cookie'),
              contains('hermes_session_at=fixture-cookie'),
            );
            tickets++;
            expect(request.method, 'POST');
            fixture.json(request, {'ticket': 'fixture-ticket'});
          }
          await request.response.close();
        });
      });
      final connection = _connection().copyWith(
        host: '127.0.0.1',
        port: fixture.server.port,
        desktopGatewayUrl: '${fixture.origin}/hermes',
        dashboardProxied: false,
        dashboardUsername: 'fixture-user',
        dashboardPassword: 'fixture-password',
        clientCertificate: loopbackIdentity,
      );
      late NextGenGateway gateway;
      var closed = false;
      Future<void> close() async {
        if (closed) return;
        closed = true;
        gateway.dispose();
        await fixture.close();
      }

      addTearDown(close);
      await tester.runAsync(
        () => withLoopbackTrust(() async {
          gateway = NextGenGateway(connection);
          await gateway.connected();
        }),
      );
      await _app(tester, ValueNotifier(gateway));
      await _browse(tester);
      Future<void> waitFor(String method) async {
        for (var i = 0; i < 100; i++) {
          await _frames(tester);
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 10)),
          );
          if (fixture.rpcRequests.any((r) => r['method'] == method)) {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 20)),
            );
            await _frames(tester);
            return;
          }
        }
        fail('No $method request');
      }

      await waitFor('projects.tree');
      expect(find.text('work project'), findsOneWidget);
      expect(find.text('5 chats'), findsOneWidget);
      await _detail(tester, gateway);
      await waitFor('projects.project_sessions');
      expect(logins, 1);
      expect(tickets, 1, reason: 'Projects must reuse the main gateway socket');
      expect(fixture.anonymousRequests, 0);
      final methods = fixture.rpcRequests
          .where((r) => (r['method'] as String).startsWith('projects.'))
          .toList();
      expect(
        methods.map((r) => r['method']),
        containsAll([
          'projects.list',
          'projects.tree',
          'projects.project_sessions',
        ]),
      );
      for (final call in methods) {
        expect((call['params'] as Map)['profile'], 'work');
      }
      expect(
        fixture.rpcRequests.where(
          (r) => (r['method'] as String).startsWith('session.'),
        ),
        isEmpty,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(close);
      await _frames(tester);
    },
  );

  testWidgets(
    'unsupported Projects stays separate from server folder settings',
    (tester) async {
      final gateway = _Gateway(_connection())..unsupported = true;
      await _app(tester, ValueNotifier(gateway));
      await _browse(tester);
      expect(
        find.textContaining('Update Hermes', findRichText: true),
        findsWidgets,
      );
      expect(find.byType(ProjectsRootScreen), findsNothing);
      await _close(tester, [gateway]);
    },
  );
}
