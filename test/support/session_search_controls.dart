import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// A held gateway request can keep a progress indicator animating: wait only
// for the menu's transition rather than settling the whole screen.
Future<void> chooseGatewaySearch(WidgetTester t, {required bool enable}) async {
  final from = enable ? 'On-device' : 'Full-text (gateway)';
  final to = enable ? 'Full-text (gateway)' : 'On-device';
  await t.tap(find.byTooltip('Search mode: $from'));
  await t.pump();
  await t.pump(const Duration(milliseconds: 350));
  await t.tap(find.widgetWithText(CheckedPopupMenuItem<bool>, to));
  await t.pump();
  await t.pump(const Duration(milliseconds: 350));
}
