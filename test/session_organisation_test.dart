import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/session.dart';
import 'package:hermes_android/core/widgets/session_organisation.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'reported usage survives row updates; missing values sort after known zero',
    () {
      final a =
          Session.fromJson({
                'id': 'a',
                'input_tokens': 2,
                'output_tokens': 3,
                'estimated_cost_usd': 0.75,
              })
              .withArchived(false)
              .withTitle('renamed')
              .withReadState(unread: false)
              .withPinned(true)
              .withStoredId('a');
      final b = Session.fromJson({'id': 'b', 'total_tokens': 0, 'cost_usd': 0});
      final unknown = Session.fromJson({'id': 'x', 'total_tokens': -1});
      for (final sort in [SessionSort.tokens, SessionSort.cost]) {
        expect(sort.apply([unknown, b, a]).map((s) => s.id), ['a', 'b', 'x']);
      }
      expect(sessionDetails(a), contains('5 tokens'));
      expect(sessionDetails(a), contains(r'$0.7500'));
      expect(sessionDetails(unknown), isNot(contains('tokens')));
    },
  );
  test(
    'opting out of chat restore never suppresses an explicit open',
    () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      await NextGenPreferences.setLastSession(p, 'one', 'saved');
      expect(NextGenPreferences.launchSession(p, 'one'), 'saved');
      await p.setBool(NextGenPreferences.reopenKey, false);
      expect(NextGenPreferences.launchSession(p, 'one'), isNull);
      expect(
        NextGenPreferences.launchSession(
          p,
          'one',
          requested: 'from-notification',
        ),
        'from-notification',
      );
    },
  );
}
