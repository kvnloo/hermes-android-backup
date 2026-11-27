import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/history/fork_lineage.dart';

void main() {
  test('nests real forks and keeps resets and compression separate', () {
    final parent = ForkMark(id: 'p', title: 'Parent', lastActive: 1);
    final current = ForkMark(
      id: 'c',
      title: 'Current',
      branchedFrom: 'p',
      lastActive: 3,
    );
    final sibling = ForkMark(
      id: 's',
      title: 'Sibling',
      branchedFrom: 'p',
      lastActive: 4,
    );
    final reset = ForkMark(
      id: 'r',
      title: 'Reset',
      parentSessionId: 'c',
      resetFrom: 'c',
      lastActive: 5,
    );
    final shown = lineageAround('c', [parent, current, sibling, reset]);
    expect(shown.parent?.id, 'p');
    expect(shown.siblings.map((row) => row.id), ['s']);
    expect(shown.children, isEmpty);

    final legacy = lineageAround('c', [
      parent,
      ForkMark(id: 'c', title: 'Child', parentSessionId: 'p', lastActive: 2),
    ]);
    expect(legacy.parent?.id, 'p');

    final compressed = lineageAround('tip', [
      ForkMark(id: 'root', title: 'Old', lineageRootId: 'root', lastActive: 1),
      ForkMark(
        id: 'tip',
        title: 'Tip',
        lineageRootId: 'root',
        parentSessionId: 'root',
        lastActive: 2,
      ),
    ]);
    expect(compressed.parent, isNull);
    expect(compressed.siblings, isEmpty);
    expect(compressed.children, isEmpty);
  });
}
