import 'package:flutter_test/flutter_test.dart';

import '../tool/check_l10n_placeholders.dart';

void main() {
  test(
    'every locale has source-ordered keys and matching ICU placeholders',
    () {
      expect(checkCatalogs(), isEmpty);
    },
  );

  test('argument extraction includes plural controls and nested arguments', () {
    expect(
      messageArguments(
        '{count, plural, =1{One {name}} other{{count} files for {name}}}',
      ),
      {
        'count': {'plural', 'value'},
        'name': {'value'},
      },
    );
    expect(messageArguments('No variables.'), isEmpty);
  });

  test(
    'ICU check preserves selectors and nesting but ignores translated text',
    () {
      const source =
          '{count, plural, =1{One} other{{kind, select, a{A} other{B}}}}';
      const translated =
          '{count, plural, other{{kind, select, other{Б} a{А}}} =1{Один}}';
      expect(messageStructure(translated), messageStructure(source));
      expect(
        messageStructure('{count, plural, other{Many}}'),
        isNot(messageStructure(source)),
      );
      expect(
        messageStructure('{count, plural, =1{One {name}} other{Many}}'),
        isNot(messageStructure('{count, plural, =1{One} other{Many {name}}}')),
      );
      expect(
        () => messageStructure('{count, plural, other{Broken}'),
        throwsFormatException,
      );
    },
  );
}
