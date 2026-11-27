// Run from the repository root: dart run tool/check_l10n_placeholders.dart
import 'dart:convert';
import 'dart:io';

/// Placeholder names and ICU argument kinds, including nested branch arguments.
Map<String, Set<String>> messageArguments(String message) {
  final arguments = <String, Set<String>>{};
  for (final match in RegExp(
    r'\{([A-Za-z_][A-Za-z_0-9]*)\s*(?:,\s*([A-Za-z]+)\s*,|\})',
  ).allMatches(message)) {
    arguments.putIfAbsent(match[1]!, () => <String>{}).add(match[2] ?? 'value');
  }
  return arguments;
}

String _signature(Map<String, Set<String>> arguments) {
  final names = arguments.keys.toList()..sort();
  return names
      .map((name) {
        final kinds = arguments[name]!.toList()..sort();
        return '$name:${kinds.join(',')}';
      })
      .join(';');
}

/// ICU structure only: text/argument order is language-dependent. Branch
/// selectors and nesting must stay intact for new release messages.
String messageStructure(String message) {
  final nodes = <String>[];
  for (var i = 0; i < message.length; i++) {
    if (message[i] != '{') continue;
    final start = i;
    var depth = 1;
    while (++i < message.length && depth > 0) {
      if (message[i] == '{') depth++;
      if (message[i] == '}') depth--;
    }
    if (depth != 0) throw const FormatException('Unbalanced ICU braces');
    final expression = message.substring(start + 1, i - 1).trim();
    // The loop above advances one character past the closing brace.
    i--;
    final header = RegExp(
      r'^([A-Za-z_][A-Za-z_0-9]*)\s*,\s*(plural|select|selectordinal)\s*,',
    ).firstMatch(expression);
    if (header == null) {
      if (RegExp(r'^[A-Za-z_][A-Za-z_0-9]*$').hasMatch(expression)) {
        nodes.add('value:$expression');
      }
      continue;
    }
    final branches = <String>[];
    var offset = header.end;
    while (offset < expression.length) {
      while (offset < expression.length && expression[offset].trim().isEmpty) {
        offset++;
      }
      if (offset == expression.length) break;
      final open = expression.indexOf('{', offset);
      if (open == -1) throw const FormatException('Missing ICU branch');
      final selector = expression.substring(offset, open).trim();
      var close = open;
      var branchDepth = 1;
      while (++close < expression.length && branchDepth > 0) {
        if (expression[close] == '{') branchDepth++;
        if (expression[close] == '}') branchDepth--;
      }
      if (branchDepth != 0) {
        throw const FormatException('Unbalanced ICU branch');
      }
      final body = expression.substring(open + 1, close - 1);
      branches.add('$selector[${messageStructure(body)}]');
      offset = close;
    }
    branches.sort();
    nodes.add('${header[1]}:${header[2]}{${branches.join(';')}}');
  }
  nodes.sort();
  return nodes.join('|');
}

List<String> checkCatalogs({String directory = 'lib/l10n'}) {
  final root = Directory(directory);
  final source =
      jsonDecode(File('${root.path}/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
  final keys = source.keys.where((key) => !key.startsWith('@')).toList();
  final failures = <String>[];
  final catalogs =
      root
          .listSync()
          .whereType<File>()
          .where(
            (file) => RegExp(r'app_(?!en\.)[\w]+\.arb$').hasMatch(file.path),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final file in catalogs) {
    final translated =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final actualOrder = translated.keys
        .where((key) => !key.startsWith('@'))
        .toList();
    if (actualOrder.join('\n') != keys.join('\n')) {
      failures.add(
        '${file.path}: message keys missing, extra or out of source order',
      );
    }
    for (final key in keys) {
      final value = translated[key];
      if (value is! String || value.trim().isEmpty) {
        failures.add('${file.path}:$key: missing/empty message');
        continue;
      }
      final expected = _signature(messageArguments(source[key] as String));
      final actual = _signature(messageArguments(value));
      if (actual != expected) {
        failures.add('${file.path}:$key: arguments $actual != $expected');
      }
      if ((key.startsWith('release_') || key.startsWith('ng_release_')) &&
          messageStructure(value) != messageStructure(source[key] as String)) {
        failures.add('${file.path}:$key: changed ICU selectors/nesting');
      }
      final metadata = translated['@$key'];
      if (metadata is Map && metadata['placeholders'] is Map) {
        final placeholders = metadata['placeholders'] as Map;
        final names = placeholders.keys.toSet();
        final expectedNames = messageArguments(
          source[key] as String,
        ).keys.toSet();
        if (names.length != expectedNames.length ||
            !names.containsAll(expectedNames)) {
          failures.add('${file.path}:@$key: placeholder metadata mismatch');
        }
      }
    }
  }
  if (catalogs.length != 13) {
    failures.add('Expected 13 translated catalogs, found ${catalogs.length}');
  }
  return failures;
}

void main() {
  final failures = checkCatalogs();
  if (failures.isNotEmpty) {
    stderr.writeln(failures.join('\n'));
    exitCode = 1;
  } else {
    stdout.writeln(
      'All 13 locales: complete source-ordered keys and matching placeholders/ICU structure.',
    );
  }
}
