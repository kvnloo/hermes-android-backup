import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/workspace_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_origin_test.dart' show MemoryCredentials;
import 'support/inert_turn_application_session.dart';

void main() {
  testWidgets('Classic primary launch leaves last-used routing unchanged', (
    t,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final manager = ConnectionManager(
      prefs,
      credentialStore: MemoryCredentials(),
      nativePushSupported: false,
    );
    await manager.saveConnection('Primary A', 'a.invalid', 8642, '');
    await manager.saveConnection('Last B', 'b.invalid', 8642, '');
    final all = manager.getConnections();
    final a = all.singleWhere((c) => c.label == 'Primary A');
    final b = all.singleWhere((c) => c.label == 'Last B');
    await prefs.setString('last_connection_id', b.id);
    await prefs.setString(
      'ares.fleet.primary.v1',
      sha256.convert(utf8.encode(jsonEncode(a.toMap()))).toString(),
    );
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(
          connManager: manager,
          turnApplicationController: GatewayTurnApplicationController(
            sessionFactory: (_) => InertTurnApplicationSession(),
          ),
        ),
      ),
    );
    await t.pump();
    await t.pump(const Duration(milliseconds: 50));
    // The primary's workspace was actually opened, not merely skipped.
    final opened = t.widget<WorkspaceScreen>(find.byType(WorkspaceScreen));
    expect(opened.connection.id, a.id);
    final last = prefs.getString('last_connection_id');
    await t.pumpWidget(const SizedBox.shrink());
    await t.pump(const Duration(seconds: 15));
    expect(last, b.id);
  });
}
