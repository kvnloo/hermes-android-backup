// Renders the approved NextGen brand screens from the app's real widgets
// on invented chats. No network, no device.
//
//   flutter test tool/render_brand_mockups.dart
//
// Writes PNGs to ARES_MOCKUP_OUT (default
// ../mockups/nextgen-brand next to this worktree). Adapted from ares-apple's
// tool/render_store_screenshots.dart: every font is loaded with FontLoader,
// shadows are real, and frames settle with runAsync delays.
//
// One image: add --plain-name A1 (or any file prefix).

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/brand.dart';
import 'package:hermes_android/nextgen/ui/main_page.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'brand_mockup_fixtures.dart';

final _out =
    Platform.environment['ARES_MOCKUP_OUT'] ?? '../mockups/nextgen-brand';

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
}

const _iphone = _Device(
  'phone',
  Size(1179, 2556),
  3,
  TargetPlatform.iOS,
  top: 59,
  bottom: 34,
);
const _mac = _Device('desktop', Size(2880, 1800), 2, TargetPlatform.macOS);
const _android = _Device(
  'android',
  Size(1080, 2400),
  2.625,
  TargetPlatform.android,
  top: 45,
  bottom: 24,
);

Future<void> _loadFamily(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final path in files) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

Future<void> _loadFonts() async {
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

void _releaseDevice() {
  debugDefaultTargetPlatformOverride = null;
  debugDisableShadows = true;
}

Future<void> _settle(WidgetTester tester, {int frames = 10}) async {
  for (var i = 0; i < frames; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
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
  final target = File('$_out/$file')..createSync(recursive: true);
  target.writeAsBytesSync(bytes!);
  // ignore: avoid_print
  print('wrote ${target.absolute.path}');
}

Future<SharedPreferences> _preferences(Map<String, Object> values) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  for (final MapEntry(:key, :value) in values.entries) {
    switch (value) {
      case bool():
        await prefs.setBool(key, value);
      case String():
        await prefs.setString(key, value);
      default:
        throw ArgumentError('Unsupported preference $key');
    }
  }
  return prefs;
}

/// A stand-in for the on-screen keyboard: plain key caps, no letters, so the
/// picture shows where the keyboard sits without pretending to be one.
class _Keyboard extends StatelessWidget {
  const _Keyboard({required this.height, required this.dark});
  final double height;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark ? const Color(0xFF2B2B2E) : const Color(0xFFD1D3D9);
    final key = dark ? const Color(0xFF5A5A5F) : Colors.white;
    Widget row(int keys, {double inset = 0}) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 3 + inset),
      child: Row(
        children: [
          for (var i = 0; i < keys; i++)
            Expanded(
              child: Container(
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: key,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
        ],
      ),
    );
    return Container(
      height: height,
      color: bg,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          row(10),
          const SizedBox(height: 11),
          row(9, inset: 18),
          const SizedBox(height: 11),
          row(7, inset: 52),
          const SizedBox(height: 11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Container(
                  width: 92,
                  height: 42,
                  decoration: BoxDecoration(
                    color: key.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: key,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 92,
                  height: 42,
                  decoration: BoxDecoration(
                    color: key.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Whether the stand-in keyboard is drawn (B4 only, once the chat is open).
final _keyboardShown = ValueNotifier<double>(0);

Future<DemoGateway> _openNextGen(
  WidgetTester tester,
  _Device device, {
  required Brightness brightness,
  bool project = false,
}) async {
  _useDevice(tester, device);
  _keyboardShown.value = 0;
  final now = DateTime.now();
  final prefs = await _preferences(demoPreferences(now));
  NextGenLook.instance
    ..themeMode = brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light
    ..accent = NgAccent.blue
    ..pureBlack = false
    ..glow = true;
  final gateway = DemoGateway(now, withProjects: project);
  final manager = ConnectionManager(prefs);
  final app = MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: nextGenTheme(brightness, NextGenLook.instance),
    builder: (context, child) => Stack(
      children: [
        Positioned.fill(
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
        ValueListenableBuilder<double>(
          valueListenable: _keyboardShown,
          builder: (context, height, _) => height <= 0
              ? const SizedBox.shrink()
              : Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: height,
                  child: IgnorePointer(
                    child: _Keyboard(
                      height: height,
                      dark: brightness == Brightness.dark,
                    ),
                  ),
                ),
        ),
      ],
    ),
    home: const NgMainPage(),
  );
  await tester.pumpWidget(RepaintBoundary(key: _boundary, child: app));
  await _settle(tester);
  return gateway;
}

/// Raises the keyboard: the view's bottom inset and the stand-in drawn there.
Future<void> _raiseKeyboard(
  WidgetTester tester,
  _Device device,
  double height,
) async {
  tester.view.padding = FakeViewPadding(top: device.top * device.ratio);
  tester.view.viewInsets = FakeViewPadding(bottom: height * device.ratio);
  _keyboardShown.value = height;
  await tester.showKeyboard(find.byKey(const ValueKey('ng-composer-field')));
  await _settle(tester, frames: 4);
}

Future<void> _close(WidgetTester tester, DemoGateway gateway) async {
  await tester.pumpWidget(const SizedBox.shrink());
  gateway.dispose();
  await tester.pump(const Duration(seconds: 31));
  _releaseDevice();
}

String _r(Rect r) =>
    '(${r.left.round()},${r.top.round()} ${r.width.round()}x${r.height.round()})';

void _log(String line) {
  // ignore: avoid_print
  print('  $line');
}

/// Logs where the brand and its neighbours sit, and whether a scrollable
/// holding them overflows (content cut off at the top or bottom).
void _report(WidgetTester tester, String label) {
  final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
  _log('$label: screen ${screen.width.round()}x${screen.height.round()}');
  for (final (name, finder) in [
    ('logo', find.byType(NgBrandLogo)),
    ('wordmark', find.byType(NgBrandWordmark)),
    ('new chat', find.byKey(const ValueKey('ng-brand-new-chat'))),
    ('open chat', find.byKey(const ValueKey('ng-brand-open-chat'))),
    ('recent card', find.byType(NgCard)),
    ('empty', find.byType(NgEmpty)),
    ('composer', find.byKey(const ValueKey('ng-composer-field'))),
  ]) {
    for (final element in finder.evaluate()) {
      final box = element.renderObject;
      if (box is RenderBox && box.hasSize && box.attached) {
        final rect = box.localToGlobal(Offset.zero) & box.size;
        _log('  $name ${_r(rect)}');
      }
    }
  }
  for (final element in find.byType(Scrollable).evaluate()) {
    final state = (element as StatefulElement).state as ScrollableState;
    final p = state.position;
    if (!p.hasContentDimensions) continue;
    if (p.axis != Axis.vertical) continue;
    if (p.maxScrollExtent > 0.5) {
      final box = element.renderObject as RenderBox;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      _log('  OVERFLOW scrollable ${_r(rect)} max ${p.maxScrollExtent}');
    }
  }
}

Future<void> _shoot(
  WidgetTester tester,
  _Device device,
  String file, {
  required Brightness brightness,
  bool newChat = false,
  bool project = false,
  double keyboard = 0,
}) async {
  final gateway = await _openNextGen(
    tester,
    device,
    brightness: brightness,
    project: project,
  );
  if (newChat) {
    await tester.tap(find.byKey(const ValueKey('ng-brand-new-chat')));
    await _settle(tester);
    expect(find.byType(NgBrandLanding), findsNothing);
    if (project) {
      await tester.tap(find.byKey(const Key('nextgen-project-picker')));
      await _settle(tester);
      await tester.tap(
        find.widgetWithText(CheckedPopupMenuItem<String>, 'Home project'),
      );
      await _settle(tester);
    }
    if (keyboard > 0) await _raiseKeyboard(tester, device, keyboard);
  } else {
    expect(find.byType(NgBrandLanding), findsOneWidget);
  }
  _report(tester, file);
  await _save(tester, device, file);
  _keyboardShown.value = 0;
  await _close(tester, gateway);
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

  const dark = Brightness.dark, light = Brightness.light;

  testWidgets('A1-launch-phone-dark', (t) async {
    await _shoot(t, _iphone, 'A1-launch-phone-dark.png', brightness: dark);
  });
  testWidgets('A2-launch-phone-light', (t) async {
    await _shoot(
      t,
      _iphone,
      'A2-launch-phone-light-proposal.png',
      brightness: light,
    );
  });
  testWidgets('A3-launch-desktop-dark', (t) async {
    await _shoot(t, _mac, 'A3-launch-desktop-dark.png', brightness: dark);
  });
  testWidgets('A4-launch-desktop-light', (t) async {
    await _shoot(
      t,
      _mac,
      'A4-launch-desktop-light-proposal.png',
      brightness: light,
    );
  });
  testWidgets('A5-launch-android-dark', (t) async {
    await _shoot(t, _android, 'A5-launch-android-dark.png', brightness: dark);
  });
  testWidgets('B1-newchat-phone-dark', (t) async {
    await _shoot(
      t,
      _iphone,
      'B1-newchat-phone-dark.png',
      brightness: dark,
      newChat: true,
    );
  });
  testWidgets('B2-newchat-phone-dark-approved-sparkle', (t) async {
    await _shoot(
      t,
      _iphone,
      'B2-newchat-phone-dark-approved-sparkle.png',
      brightness: dark,
      newChat: true,
    );
  });
  testWidgets('B3-newchat-phone-light', (t) async {
    await _shoot(
      t,
      _iphone,
      'B3-newchat-phone-light-proposal.png',
      brightness: light,
      newChat: true,
    );
  });
  testWidgets('B4-newchat-phone-dark-keyboard', (t) async {
    await _shoot(
      t,
      _iphone,
      'B4-newchat-phone-dark-keyboard.png',
      brightness: dark,
      newChat: true,
      keyboard: 336,
    );
  });
  // No picture: the landing's ways forward each leave it.
  testWidgets('flow: open a chat, recent row', (t) async {
    final gateway = await _openNextGen(t, _iphone, brightness: dark);
    expect(find.byType(NgBrandLanding), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('ng-brand-open-chat')));
    await _settle(t, frames: 4);
    expect(find.text('Search chats'), findsWidgets);
    // Close the drawer, then open a chat from the recent list.
    await t.tapAt(const Offset(380, 400));
    await _settle(t, frames: 4);
    await t.tap(find.byKey(const ValueKey('ng-brand-recent-release')));
    await _settle(t);
    expect(find.byType(NgBrandLanding), findsNothing);
    expect(find.text('Draft release notes'), findsWidgets);
    await _close(t, gateway);
  });
  testWidgets('B6-newchat-phone-dark-project', (t) async {
    await _shoot(
      t,
      _iphone,
      'B6-newchat-phone-dark-project.png',
      brightness: dark,
      newChat: true,
      project: true,
    );
  });
  testWidgets('B7-newchat-desktop-dark-project', (t) async {
    await _shoot(
      t,
      _mac,
      'B7-newchat-desktop-dark-project.png',
      brightness: dark,
      newChat: true,
      project: true,
    );
  });
  testWidgets('B5-newchat-desktop-dark', (t) async {
    await _shoot(
      t,
      _mac,
      'B5-newchat-desktop-dark.png',
      brightness: dark,
      newChat: true,
    );
  });
}
