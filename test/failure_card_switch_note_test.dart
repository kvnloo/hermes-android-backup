// Where Switch to cannot re-run the failed turn (a REST connection has no
// regenerate), the failure card says so before the switch, on the card and
// in its confirm, and confirming only switches.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/composer/failure_recovery.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/failure_recovery_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

const _surface = {
  'layer': 'provider',
  'code': 'usage_window',
  'message': 'Usage limit reached',
  'usage_limit': {
    'suggestions': [
      {'model': 'gpt-5-mini', 'label': 'GPT-5 mini', 'provider': 'openai'},
    ],
  },
};

Widget _card({required bool switchRetries, required List<String> log}) =>
    MaterialApp(
      theme: hermesTheme(Brightness.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: FailureRecoveryCard(
          message: 'Usage limit reached',
          recovery: presentRecovery(FailureSurface.parse(_surface), nowMs: 0),
          diagnosticsText: '',
          onRetry: () => log.add('retry'),
          onChooseModel: () => log.add('picker'),
          onSwitchTo: (s) async => log.add('switch ${s.model}'),
          switchRetries: switchRetries,
        ),
      ),
    );

void main() {
  testWidgets('REST: the card and its confirm say the turn will not run '
      'again; confirming only switches', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(_card(switchRetries: false, log: log));
    const note =
        "Switching changes the model only: this connection can't run the "
        'failed turn again. Send it again after switching.';
    expect(find.text(note), findsOneWidget, reason: 'said before the switch');
    await tester.tap(find.text('Switch to GPT-5 mini'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.textContaining('this connection can'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Switch model'));
    await tester.pumpAndSettle();
    expect(log, ['switch gpt-5-mini']);
  });

  testWidgets('a connection that regenerates shows no such note', (
    tester,
  ) async {
    await tester.pumpWidget(_card(switchRetries: true, log: []));
    expect(find.text('Switch to GPT-5 mini'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('failure-card-switch-no-retry')),
      findsNothing,
    );
  });
}
