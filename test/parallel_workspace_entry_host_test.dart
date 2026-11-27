import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/connection.dart';
import 'package:hermes_android/core/screens/parallel_workspace_entry.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';

void main() {
  testWidgets(
    'replacing a same-ID owner tears down the whole workspace stack',
    (tester) async {
      SavedConnection owner(String profile) => SavedConnection(
        id: 'host-test',
        label: 'Fixture',
        host: 'example.invalid',
        port: 9119,
        apiKey: '',
        gatewayProfile: profile,
      );
      final a = owner('a');
      final b = owner('b');
      Widget host(SavedConnection current) => MaterialApp(
        home: ParallelWorkspaceEntryHost(
          owner: current,
          connection: current,
          home: (open) => Scaffold(
            body: TextButton(onPressed: open, child: const Text('Enter')),
          ),
          workspace: (context) => Scaffold(
            appBar: AppBar(title: Text(current.gatewayProfile!)),
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(body: Text('Nested route')),
                ),
              ),
              child: const Text('Open pane'),
            ),
          ),
        ),
      );
      await tester.pumpWidget(host(a));
      await tester.tap(find.text('Enter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open pane'));
      await tester.pumpAndSettle();
      expect(find.text('Nested route'), findsOneWidget);
      await tester.pumpWidget(host(b));
      await tester.pumpAndSettle();
      expect(find.text('Nested route', skipOffstage: false), findsNothing);
      expect(find.text('Enter'), findsOneWidget);
      await tester.tap(find.text('Enter'));
      await tester.pumpAndSettle();
      expect(find.text('b'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Enter'), findsOneWidget);
      await tester.tap(find.text('Enter'));
      await tester.pumpAndSettle();
      final lease = ConnectionMutationBarrier.begin([b.id]);
      lease.release();
      await tester.pumpAndSettle();
      expect(find.text('Enter'), findsOneWidget);
      await tester.tap(find.text('Enter'));
      await tester.pump();
      expect(find.textContaining('The connection changed'), findsOneWidget);
      expect(find.text('b'), findsNothing);
    },
  );
}
