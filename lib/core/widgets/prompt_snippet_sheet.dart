import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../composer/prompt_snippets.dart';

class PromptSnippet {
  const PromptSnippet(this.label, this.description, this.text);

  final String label;
  final String description;
  final String text;
}

List<PromptSnippet> promptSnippets(AppLocalizations l10n) => [
  PromptSnippet(
    l10n.composer_snippet_review,
    l10n.composer_snippet_review_body,
    l10n.composer_snippet_review_text,
  ),
  PromptSnippet(
    l10n.composer_snippet_plan,
    l10n.composer_snippet_plan_body,
    l10n.composer_snippet_plan_text,
  ),
  PromptSnippet(
    l10n.composer_snippet_explain,
    l10n.composer_snippet_explain_body,
    l10n.composer_snippet_explain_text,
  ),
];

Future<void> showPromptSnippets({
  required BuildContext context,
  required TextEditingController editor,
}) {
  final l10n = context.sharedL10n;
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheet) {
      final strings = sheet.sharedL10n;
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(strings.composer_snippets),
              subtitle: Text(strings.composer_snippets_description),
            ),
            for (final snippet in promptSnippets(l10n))
              ListTile(
                key: ValueKey('snippet-${snippet.label}'),
                title: Text(snippet.label),
                subtitle: Text(snippet.description),
                onTap: () {
                  final selection = editor.selection;
                  final next = insertSnippet(
                    editor.text,
                    selection,
                    snippet.text,
                  );
                  final offset = selection.isValid
                      ? selection.start + snippet.text.length
                      : next.length;
                  editor.value = TextEditingValue(
                    text: next,
                    selection: TextSelection.collapsed(
                      offset: offset.clamp(0, next.length),
                    ),
                  );
                  Navigator.pop(sheet);
                },
              ),
          ],
        ),
      );
    },
  );
}
