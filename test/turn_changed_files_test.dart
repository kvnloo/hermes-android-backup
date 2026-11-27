import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/turn_changed_files.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';

void main() {
  test('changed-file card sums landed edits and ignores failures', () {
    final files = changedFilesInLatestTurn([
      {'role': 'user', 'content': 'earlier'},
      {
        'role': 'assistant',
        'tool_calls': [
          {
            'id': 'old',
            'function': {
              'name': 'write_file',
              'arguments': jsonEncode({'path': 'old.txt'}),
            },
          },
        ],
      },
      {
        'role': 'tool',
        'tool_call_id': 'old',
        'content': jsonEncode({'diff': '+old\n'}),
      },
      {'role': 'user', 'content': 'edit the notes'},
      {
        'role': 'assistant',
        'tool_calls': [
          {
            'id': 'ok',
            'function': {
              'name': 'patch',
              'arguments': jsonEncode({'path': 'notes.txt'}),
            },
          },
          {
            'id': 'again',
            'function': {
              'name': 'edit_file',
              'arguments': jsonEncode({'file': 'notes.txt'}),
            },
          },
          {
            'id': 'bad',
            'function': {
              'name': 'write_file',
              'arguments': jsonEncode({'path': 'secret.txt'}),
            },
          },
        ],
      },
      {
        'role': 'tool',
        'tool_call_id': 'ok',
        'content': jsonEncode({
          'diff': '--- a/notes.txt\n+++ b/notes.txt\n+one\n-two\n',
        }),
      },
      {
        'role': 'tool',
        'tool_call_id': 'again',
        'content': jsonEncode({'inline_diff': '+three\n'}),
      },
      {
        'role': 'tool',
        'tool_call_id': 'bad',
        'content': jsonEncode({
          'success': false,
          'error': 'no',
          'diff': '+no\n',
        }),
      },
    ]);

    expect(files, hasLength(1));
    expect(files.single.path, 'notes.txt');
    expect(files.single.name, 'notes.txt');
    expect(files.single.added, 2);
    expect(files.single.removed, 1);
  });

  test('commit drafts name the paths and do not repeat the previous text', () {
    const diff = '''
diff --git a/src/app.dart b/src/app.dart
--- a/src/app.dart
+++ b/src/app.dart
+line
# New (untracked) files:
#   notes.txt
''';
    expect(
      draftGitCommitMessage(diff),
      'Update 2 files\n\nsrc/app.dart\nnotes.txt',
    );
    expect(
      draftGitCommitMessage(
        diff,
        avoid: 'Update 2 files\n\nsrc/app.dart\nnotes.txt',
      ),
      endsWith('\n'),
    );
    expect(draftGitCommitMessage('no paths here'), isEmpty);
  });
}
