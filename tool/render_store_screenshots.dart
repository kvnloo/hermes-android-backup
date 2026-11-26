// Renders App Store screenshots from the app's real widgets on invented
// sample data (tool/store_screenshot_fixtures.dart). No network, no device.
//
//   flutter test tool/render_store_screenshots.dart
//
// Writes PNGs to ../apple-store-screenshots/ares/{iphone,ipad,mac} (override
// the folder with ARES_SCREENSHOT_OUT). It is a tool, not part of the test
// suite (the file name keeps it out of `flutter test`): it reads the macOS
// system font so platform text is drawn in San Francisco, as on a device,
// and the app's bundled Geist/Cinzel fonts from assets/. There is no status
// bar or window chrome in the output; the safe-area insets are kept so the
// layout matches the device.
//
// One device: add --plain-name iphone (or ipad, mac).

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/utils/home_turn_signals.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/models_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/projects_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'store_screenshot_fixtures.dart';

final _out =
    Platform.environment['ARES_SCREENSHOT_OUT'] ??
    '../apple-store-screenshots/ares';

class _Device {
  const _Device(
    this.name,
    this.pixels,
    this.ratio,
    this.platform, {
    this.top = 0,
    this.bottom = 0,
  });
  final String name;
  final Size pixels;
  final double ratio;
  final TargetPlatform platform;

  /// Safe-area insets in logical pixels.
  final double top, bottom;

  bool get phone => name == 'iphone';

  /// Sample data sized for this screen.
  DemoLook get look => switch (name) {
    'iphone' => const DemoLook.phone(),
    'ipad' => const DemoLook.wide(),
    _ => const DemoLook.wide(
      reviewTurns: 2,
      emailTurns: 2,
      tripTurns: 1,
      docsTurns: 2,
      projects: 8,
      brief: true,
    ),
  };
}

const _iphone = _Device(
  'iphone',
  Size(1179, 2556),
  3,
  TargetPlatform.iOS,
  top: 59,
  bottom: 34,
);
const _ipad = _Device(
  'ipad',
  Size(2048, 2732),
  2,
  TargetPlatform.iOS,
  top: 24,
  bottom: 20,
);
const _mac = _Device('mac', Size(2880, 1800), 2, TargetPlatform.macOS);

Future<void> _loadFamily(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final path in files) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

Future<void> _loadFonts() async {
  // Every family name Flutter resolves the platform UI font to on iOS and
  // macOS.
  for (final family in [
    'CupertinoSystemText',
    'CupertinoSystemDisplay',
    '.AppleSystemUIFont',
    '.SF UI Text',
    '.SF UI Display',
    '.SF Pro Text',
    '.SF Pro Display',
    'Roboto',
  ]) {
    await _loadFamily(family, ['/System/Library/Fonts/SFNS.ttf']);
  }
  const mono = '/System/Library/Fonts/SFNSMono.ttf';
  if (File(mono).existsSync()) {
    for (final family in ['monospace', 'Menlo', 'Courier']) {
      await _loadFamily(family, [mono]);
    }
  }
  // The app's own families (pubspec.yaml `fonts:`).
  await _loadFamily('Geist', [
    'assets/fonts/geist/Geist-Regular.ttf',
    'assets/fonts/geist/Geist-Medium.ttf',
    'assets/fonts/geist/Geist-SemiBold.ttf',
  ]);
  await _loadFamily('GeistMono', [
    'assets/fonts/geist/GeistMono-Regular.ttf',
    'assets/fonts/geist/GeistMono-Medium.ttf',
  ]);
  await _loadFamily('Cinzel', ['assets/fonts/Cinzel-Variable.ttf']);
  final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
  await _loadFamily('MaterialIcons', [
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

final _boundary = GlobalKey();

void _useDevice(WidgetTester tester, _Device device) {
  debugDefaultTargetPlatformOverride = device.platform;
  // Tests paint every shadow as a solid black outline unless told not to.
  debugDisableShadows = false;
  tester.view.physicalSize = device.pixels;
  tester.view.devicePixelRatio = device.ratio;
  final insets = FakeViewPadding(
    top: device.top * device.ratio,
    bottom: device.bottom * device.ratio,
  );
  tester.view.padding = insets;
  tester.view.viewPadding = insets;
  addTearDown(tester.view.reset);
}

/// Puts back the debug switches the test binding checks after each test.
void _releaseDevice() {
  debugDefaultTargetPlatformOverride = null;
  debugDisableShadows = true;
}

Future<void> _settle(WidgetTester tester, {int frames = 8}) async {
  // Asset images and fonts decode on the real event loop; the sample gateway
  // answers from memory. Long enough for a pushed route or drawer to finish.
  for (var i = 0; i < frames; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> _save(WidgetTester tester, _Device device, String file) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_boundary),
  );
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: device.ratio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final size = Size(image.width.toDouble(), image.height.toDouble());
    image.dispose();
    if (size != device.pixels) {
      throw StateError('$file is $size, expected ${device.pixels}');
    }
    return data!.buffer.asUint8List();
  });
  final target = File('$_out/${device.name}/$file')
    ..createSync(recursive: true);
  target.writeAsBytesSync(bytes!);
  // ignore: avoid_print
  print('wrote ${target.absolute.path}');
}

/// The app's preferences, held in memory and reset to [values].
Future<SharedPreferences> _preferences(Map<String, Object> values) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  for (final MapEntry(:key, :value) in values.entries) {
    switch (value) {
      case bool():
        await prefs.setBool(key, value);
      case String():
        await prefs.setString(key, value);
      case List<String>():
        await prefs.setStringList(key, value);
      default:
        throw ArgumentError('Unsupported preference $key');
    }
  }
  return prefs;
}

/// One NextGen screen: the real main page on the sample gateway.
class _NextGen {
  _NextGen(this.gateway, this.chats, this.look);
  final DemoGateway gateway;
  final List<DemoChat> chats;
  final DemoLook look;

  DemoChat chat(String id) => chats.firstWhere((c) => c.id == id);
}

/// Prints how the open transcript sits in its pane, to tune the sample
/// text: a positive gap is blank space above the first row, a negative one
/// is how far the conversation runs off the top.
void _reportTranscript(WidgetTester tester, String label) {
  final list = find.byKey(const ValueKey('ng-transcript'));
  if (list.evaluate().isEmpty) return;
  final pane = tester.getRect(list);
  final rows = find.descendant(of: list, matching: find.byType(KeyedSubtree));
  var top = double.infinity;
  for (final element in rows.evaluate()) {
    final box = element.renderObject;
    if (box is RenderBox && box.hasSize) {
      final y = box.localToGlobal(Offset.zero).dy;
      if (y < top) top = y;
    }
  }
  final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
  final first = find.byKey(ValueKey(chat.items.first.key));
  final firstTop = first.evaluate().isEmpty
      ? 'scrolled off'
      : '${(tester.getRect(first.first).top - pane.top).round()}';
  // ignore: avoid_print
  print(
    '  $label: transcript ${pane.height.round()} high, first row at '
    '$firstTop, topmost built row at ${(top - pane.top).round()}',
  );
}

Future<_NextGen> _openNextGen(
  WidgetTester tester,
  _Device device, {
  required Brightness brightness,
  required String chat,
  NgAccent accent = NgAccent.blue,
}) async {
  _useDevice(tester, device);
  final now = DateTime.now();
  final look = device.look;
  final chats = demoChats(now, look);
  final prefs = await _preferences(demoPreferences(chats, now, openChat: chat));
  NextGenLook.instance
    ..themeMode = brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light
    ..accent = accent
    ..pureBlack = false
    ..glow = true;
  final gateway = DemoGateway(chats, now, look);
  final manager = ConnectionManager(prefs);
  await tester.pumpWidget(
    RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: nextGenTheme(brightness, NextGenLook.instance),
        builder: (context, child) => NgLocalizationScope(
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
        home: const NgMainPage(),
      ),
    ),
  );
  await _settle(tester);
  _reportTranscript(tester, '${device.name} $chat');
  return _NextGen(gateway, chats, look);
}

Future<void> _closeNextGen(WidgetTester tester, _NextGen stage) async {
  await tester.pumpWidget(const SizedBox.shrink());
  stage.gateway.dispose();
  // Project discovery and reconnect waits run out on their own timers.
  await tester.pump(const Duration(seconds: 31));
  _releaseDevice();
}

/// The Lisbon chat mid-turn: tools used, three delegated subagents and the
/// reply so far.
Future<void> _streamTrip(
  WidgetTester tester,
  _NextGen stage, {
  required bool phone,
}) async {
  final chat = stage.chat('trip');
  final g = stage.gateway;
  g.emit(chat, 'message.start', const {});
  g.emit(chat, 'tool.start', {
    'tool_id': 'w1',
    'name': 'web_search',
    'context': 'Lisbon food markets',
  });
  g.emit(chat, 'tool.complete', {
    'tool_id': 'w1',
    'summary': '8 results',
    'duration_s': 1.4,
  });
  g.emit(chat, 'tool.start', {
    'tool_id': 'w2',
    'name': 'web_search',
    'context': 'Lisbon viewpoints at sunset',
  });
  g.emit(chat, 'tool.complete', {
    'tool_id': 'w2',
    'summary': '6 results',
    'duration_s': 1.1,
  });
  g.emit(chat, 'message.delta', {
    'text': phone
        ? 'The markets and viewpoints are picked. Three helpers are '
              'working on where to stay, the day trip and the evenings.'
        : 'May is a great month for this. The markets and viewpoints are '
              'picked, and three helpers are working on the rest in '
              'parallel:\n\n'
              '- **Where to stay:** comparing Alfama, Chiado and Principe '
              'Real\n'
              '- **Day trip:** Sintra or Cascais, by train\n'
              '- **Evenings:** places with live fado near each area\n\n'
              '${stage.look.tripTurns == 1 ? _tripSoFar : ''}'
              'I will put it all into a day-by-day plan as soon as they '
              'report back.',
  });
  g.emit(chat, 'tool.start', {
    'tool_id': 'd1',
    'name': 'delegate_task',
    'context': '3 tasks',
  });
  final helper = stage.look.helperModel;
  // The folded row names the first helper: a phone has room for two words.
  final goals = phone
      ? const ['Where to stay', 'Day trip options', 'Evening venues']
      : const [
          'Shortlist neighbourhoods to stay in',
          'Compare day trips: Sintra or Cascais',
          'Find evening fado venues',
        ];
  for (final (index, goal) in goals.indexed) {
    g.emit(chat, 'subagent.start', {
      'subagent_id': 'sub-$index',
      'goal': goal,
      'task_index': index,
      'model': helper,
    });
  }
  g.emit(chat, 'subagent.tool', {
    'subagent_id': 'sub-0',
    'tool_name': 'web_search',
    'tool_preview': 'Alfama or Chiado for a first visit',
    'tool_count': 4,
    'duration_seconds': 38,
  });
  g.emit(chat, 'subagent.tool', {
    'subagent_id': 'sub-1',
    'tool_name': 'web_extract',
    'tool_preview': 'train times from Rossio station',
    'tool_count': 6,
    'duration_seconds': 44,
  });
  g.emit(chat, 'subagent.complete', {
    'subagent_id': 'sub-2',
    'status': 'completed',
    'summary': 'Three venues, one in each neighbourhood',
    'duration_seconds': 41,
    'tool_count': 5,
  });
  g.emit(chat, 'status.update', {'text': 'waiting for 2 subagents'});
  await _settle(tester, frames: 4);
  await _backdateTurn(tester, const Duration(seconds: 52));
}

/// What the Lisbon reply adds when it is the only turn in a wide window.
const _tripSoFar =
    'Already decided:\n\n'
    '- **Saturday morning:** the food market at Campo de Ourique\n'
    '- **Saturday sunset:** the viewpoint above Graca\n'
    '- **Getting around:** trams and the funiculars, no car needed\n\n';

/// Makes the running turn read as started [ago], so its timer does not say
/// one second beside subagents that ran for most of a minute.
Future<void> _backdateTurn(WidgetTester tester, Duration ago) async {
  final chat = tester.widget<NgChatView>(find.byType(NgChatView)).chat;
  chat.turnStartedAt = DateTime.now().subtract(ago);
  // The view's one-second ticker redraws the timer.
  await tester.pump(const Duration(milliseconds: 1100));
}

/// The docs chat stopped on an approval: what ran so far.
Future<void> _streamDocs(WidgetTester tester, _NextGen stage) async {
  final chat = stage.chat('docs');
  final g = stage.gateway;
  g.emit(chat, 'message.start', const {});
  g.emit(chat, 'tool.start', {
    'tool_id': 'g1',
    'name': 'terminal',
    'context': 'git pull origin main',
  });
  g.emit(chat, 'tool.complete', {
    'tool_id': 'g1',
    'summary': 'Already up to date',
    'duration_s': 0.8,
  });
  g.emit(chat, 'message.delta', {
    'text':
        'The repository is on the latest `main`. The old output has stale '
        'pages in it, so I want to clear it before building:\n\n'
        '1. Remove the `build` folder\n'
        '2. Run the site build\n'
        '3. Check every internal link\n\n'
        'The first step deletes files, so I need your go-ahead.',
  });
  g.emit(chat, 'status.update', {'text': 'waiting for approval'});
  await _settle(tester, frames: 4);
  await _backdateTurn(tester, const Duration(seconds: 17));
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await _settle(tester, frames: 4);
}

/// The family the platform text styles resolve to on iOS and macOS.
const _systemFont = 'CupertinoSystemText';

/// Classic's theme. Its type ramp names no font family, so a device draws it
/// in the system font; the test engine would fall back to its block font
/// instead, so the family loaded above is named wherever the ramp is used.
ThemeData _classicTheme(Brightness brightness) {
  final theme = hermesTheme(brightness);
  TextStyle? system(TextStyle? style) =>
      style?.copyWith(fontFamily: _systemFont);
  final type = theme.extension<HermesTokens>()!.typography;
  final rail = theme.navigationRailTheme;
  final bar = theme.navigationBarTheme;
  final dialog = theme.dialogTheme;
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamily: _systemFont),
    primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: _systemFont),
    dialogTheme: dialog.copyWith(
      titleTextStyle: system(dialog.titleTextStyle),
      contentTextStyle: system(dialog.contentTextStyle),
    ),
    navigationRailTheme: rail.copyWith(
      selectedLabelTextStyle: system(rail.selectedLabelTextStyle),
      unselectedLabelTextStyle: system(rail.unselectedLabelTextStyle),
    ),
    navigationBarTheme: bar.copyWith(
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => system(bar.labelTextStyle?.resolve(states)),
      ),
    ),
    extensions: [
      for (final extension in theme.extensions.values)
        if (extension is HermesTokens)
          extension.copyWith(
            typography: HermesTypography(
              display: system(type.display)!,
              title: system(type.title)!,
              section: system(type.section)!,
              body: system(type.body)!,
              label: system(type.label)!,
              mono: type.mono,
            ),
          )
        else
          extension,
    ],
  );
}

/// The Classic layout: its workspace shell on the same sample chats, with
/// one of them opened (pushed on a phone, beside the list on a wide window).
Future<void> _openClassic(
  WidgetTester tester,
  _Device device, {
  required Brightness brightness,
  required String chat,
}) async {
  _useDevice(tester, device);
  final now = DateTime.now();
  final look = device.look;
  final chats = demoChats(now, look);
  await _preferences({'verbose_mode': false});
  // The Classic chat asks the image picker for a photo lost to a restart.
  const picker = MethodChannel('plugins.flutter.io/image_picker');
  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(picker, (_) async => null);
  addTearDown(() => messenger.setMockMethodCallHandler(picker, null));
  await tester.pumpWidget(
    RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: _classicTheme(brightness),
        home: WorkspaceScreen(
          connection: classicConnection(),
          // The chat to open leads the list, as the one last used.
          sessionsLoader: () async => [
            for (final c in chats.where((c) => c.id == chat))
              c.row(
                now,
                look.model,
                source: 'gateway',
                live: false,
                ago: const Duration(minutes: 5),
              ),
            for (final c in chats.where((c) => c.id != chat))
              c.row(now, look.model, source: 'gateway', live: false),
          ],
          turnSignalsLoader: (_) async => HomeTurnSignals.empty,
          installedVersionLoader: () async => null,
          testChatApiClientFactory: () => classicApi(chats),
        ),
      ),
    ),
  );
  await _settle(tester);
  final title = chats.firstWhere((c) => c.id == chat).title;
  final row = find.text(title).last;
  await tester.ensureVisible(row);
  await _settle(tester, frames: 3);
  await tester.tap(row);
  await _settle(tester);
  final bubbles = find.byKey(const Key('message-bubble'));
  final composer = find.byKey(const Key('chat-composer-pill'));
  // ignore: avoid_print
  print(
    '  ${device.name} classic: bubbles from '
    '${tester.getRect(bubbles.first).top.round()} to '
    '${tester.getRect(bubbles.last).bottom.round()}, composer at '
    '${tester.getRect(composer).top.round()}',
  );
}

Future<void> _closeClassic(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 31));
  _releaseDevice();
}

/// Pushes one of NextGen's own pages over the main page, as its menus do.
Future<void> _push(WidgetTester tester, Widget page) async {
  final navigator = Navigator.of(tester.element(find.byType(NgChatView)));
  navigator.push(MaterialPageRoute<void>(builder: (_) => page));
  await _settle(tester);
}

void main() {
  setUpAll(() async {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await _loadFonts();
  });
  setUp(() => WidgetsApp.debugAllowBannerOverride = false);
  tearDown(() => WidgetsApp.debugAllowBannerOverride = true);

  for (final device in const [_iphone, _ipad, _mac]) {
    final phone = device.phone;
    // File names in store order; the first two show in search results.
    final names = phone
        ? const {
            'chat': '01-chat.png',
            'chats': '02-chat-list.png',
            'plan': '03-live-plan.png',
            'slash': '04-slash-commands.png',
            'approval': '05-approval.png',
            'models': '06-models.png',
            'projects': '07-projects.png',
            'classic': '08-classic.png',
          }
        : const {
            'chat': '01-chat.png',
            'plan': '02-live-plan.png',
            'slash': '03-slash-commands.png',
            'approval': '04-approval.png',
            'models': '05-models.png',
            'projects': '06-projects.png',
          };

    testWidgets('${device.name}: NextGen chat', (tester) async {
      final stage = await _openNextGen(
        tester,
        device,
        brightness: Brightness.dark,
        chat: 'review',
      );
      expect(find.byType(NgChatView), findsOneWidget);
      await _save(tester, device, names['chat']!);
      await _closeNextGen(tester, stage);
    });

    if (phone) {
      testWidgets('${device.name}: NextGen chat list', (tester) async {
        final stage = await _openNextGen(
          tester,
          device,
          brightness: Brightness.light,
          chat: 'email',
        );
        await _tapKey(tester, 'ng-sidebar-button');
        await _settle(tester);
        await _save(tester, device, names['chats']!);
        await _closeNextGen(tester, stage);
      });
    }

    testWidgets('${device.name}: NextGen live plan', (tester) async {
      final stage = await _openNextGen(
        tester,
        device,
        brightness: phone ? Brightness.dark : Brightness.light,
        chat: 'trip',
      );
      await _streamTrip(tester, stage, phone: phone);
      // The dock is capped at under half the window: a phone opens the plan,
      // the short Mac window the helpers, and the tall iPad both.
      if (device != _iphone) await _tapKey(tester, 'ng-dock-subagents');
      if (device != _mac) await _tapKey(tester, 'ng-dock-tasks');
      _reportTranscript(tester, '${device.name} plan');
      await _save(tester, device, names['plan']!);
      await _closeNextGen(tester, stage);
    });

    testWidgets('${device.name}: NextGen slash commands', (tester) async {
      final stage = await _openNextGen(
        tester,
        device,
        brightness: phone ? Brightness.light : Brightness.dark,
        chat: 'email',
      );
      await tester.enterText(
        find.byKey(const ValueKey('ng-composer-field')),
        '/',
      );
      await _settle(tester, frames: 4);
      expect(find.byKey(const ValueKey('ng-slash-suggestions')), findsOne);
      await _save(tester, device, names['slash']!);
      await _closeNextGen(tester, stage);
    });

    testWidgets('${device.name}: NextGen approval', (tester) async {
      final stage = await _openNextGen(
        tester,
        device,
        brightness: phone ? Brightness.dark : Brightness.light,
        chat: 'docs',
      );
      await _streamDocs(tester, stage);
      _reportTranscript(tester, '${device.name} approval');
      await _save(tester, device, names['approval']!);
      await _closeNextGen(tester, stage);
    });

    testWidgets('${device.name}: NextGen models', (tester) async {
      final stage = await _openNextGen(
        tester,
        device,
        brightness: phone ? Brightness.light : Brightness.dark,
        chat: 'review',
      );
      await _push(
        tester,
        NgModelsPage(
          connection: stage.gateway.connection,
          client: stage.gateway.dashboard,
        ),
      );
      await _save(tester, device, names['models']!);
      await _closeNextGen(tester, stage);
    });

    testWidgets('${device.name}: NextGen projects', (tester) async {
      final stage = await _openNextGen(
        tester,
        device,
        brightness: phone ? Brightness.dark : Brightness.light,
        chat: 'review',
      );
      await _push(
        tester,
        NgProjectsPage(onOpenSession: (_) {}, onNewProjectChat: (_) {}),
      );
      await _save(tester, device, names['projects']!);
      await _closeNextGen(tester, stage);
    });

    // Classic is shown on the phone only: in a wide window its list and
    // chat sit side by side and the list's New button covers the chat's
    // send button, which is no picture for a store page.
    if (phone) {
      testWidgets('${device.name}: Classic chat', (tester) async {
        await _openClassic(
          tester,
          device,
          brightness: Brightness.light,
          chat: 'trees',
        );
        await _save(tester, device, names['classic']!);
        await _closeClassic(tester);
      });
    }
  }
}
