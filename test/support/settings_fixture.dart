import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/settings_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/settings/settings_browser.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_l10n.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:hermes_android/nextgen/ui/settings_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const settingsCaptureKey = Key('settings-preview');

class SettingsFixture {
  SettingsFixture(
    this.prefs, {
    String id = 'settings-demo',
    Future<http.Response> Function(http.Request)? reply,
  }) {
    connection = SavedConnection(
      id: id,
      label: 'Demo workspace',
      host: 'demo.invalid',
      port: 8642,
      apiKey: '',
      dashboardProxied: true,
      singleLogin: true,
      signInMethod: 'password',
    );
    client = DashboardClient(
      host: 'demo.invalid',
      port: 8642,
      httpClient: MockClient(reply ?? (_) async => http.Response('{}', 503)),
    );
    gateway = NextGenGateway(connection, dashboard: client);
  }
  final SharedPreferences prefs;
  late final SavedConnection connection;
  late final DashboardClient client;
  late final NextGenGateway gateway;
  void dispose() => gateway.dispose();

  static void platforms() {
    PackageInfo.setMockInitialValues(
      appName: 'Ares',
      packageName: 'demo.ares',
      version: '5.0.0-demo',
      buildNumber: '5000',
      buildSignature: '',
    );
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => call.method == 'getVoices'
          ? <Object>[
              {'name': 'Demo voice', 'locale': 'en-AU'},
            ]
          : <Object>[],
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('com.hermesagent.ares/power'),
      (call) async => call.method == 'isSupported' ? true : null,
    );
  }

  Widget app(
    SettingsMode mode, {
    Brightness brightness = Brightness.light,
    Locale locale = const Locale('en'),
    double scale = 1,
    bool realFonts = false,
    SettingsCategory? category,
    String? target,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: mode == SettingsMode.nextgen
          ? nextGenTheme(brightness, NextGenLook.instance)
          : realFonts
          ? hermesTheme(brightness).copyWith(
              textTheme: hermesTheme(
                brightness,
              ).textTheme.apply(fontFamily: 'Roboto'),
            )
          : hermesTheme(brightness),
      builder: (context, child) => NgLocalizationScope(
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
      home: NgScope(
        connManager: ConnectionManager(prefs),
        gateway: gateway,
        connections: [connection],
        switchTo: (_) async {},
        addGateway: () async {},
        signOut: (_) async {},
        reload: () async {},
        signInAgain: () async {},
        child: RepaintBoundary(
          key: settingsCaptureKey,
          child: mode == SettingsMode.nextgen
              ? NgSettingsPage(initialCategory: category, initialTarget: target)
              : SettingsScreen(
                  connection: connection,
                  dashboardClient: client,
                  connectionManager: ConnectionManager(prefs),
                  initialCategory: category,
                  initialTarget: target,
                ),
        ),
      ),
    );
  }
}
