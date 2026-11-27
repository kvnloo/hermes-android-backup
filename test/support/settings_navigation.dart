import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exercise the category row before asserting the existing live control.
Future<void> openSettingsCategory(WidgetTester tester, String category) async {
  final row = find.byKey(ValueKey('settings-category-$category'));
  await tester.ensureVisible(row);
  await tester.pumpAndSettle();
  await tester.tap(row);
  await tester.pumpAndSettle();
}
