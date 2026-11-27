import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../l10n/l10n.dart';
import 'markdown_link_handler.dart';

bool isMarkdownFilename(String filename) {
  final name = filename.toLowerCase();
  return name.endsWith('.md') || name.endsWith('.markdown');
}

/// Native display of already-authorized text. No gateway, filesystem, image
/// loader or chat actions are available to the document. The owning route
/// keeps its truncation notice and its actions on the original file.
class MarkdownFilePreview extends StatefulWidget {
  const MarkdownFilePreview({required this.text, super.key});

  final String text;

  @override
  State<MarkdownFilePreview> createState() => _MarkdownFilePreviewState();
}

class _MarkdownFilePreviewState extends State<MarkdownFilePreview> {
  bool _source = false;
  late String _text;
  late String _formatted;
  late bool _richTruncated;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(MarkdownFilePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _prepare();
  }

  void _prepare() {
    _source = false;
    _text = _prefix(widget.text, 64 * 1024);
    // GFM pads ragged tables to the header width and nests block widgets.
    // Bound structural work, not just bytes. Source remains available even
    // for a single pathologically dense line that cannot be formatted.
    final input = _prefix(_text, 32 * 1024);
    final prefix = StringBuffer();
    for (final match in _lines.allMatches(input).take(400)) {
      final line = _prefix(match[0]!, 4096);
      // Table delimiter rows and thematic breaks are flat, however many
      // dashes pad them; only nesting-capable markers are bounded.
      if ((!_flatRule.hasMatch(line) &&
              _markers.allMatches(line).take(65).length > 64) ||
          '|'.allMatches(line).take(25).length > 24) {
        break;
      }
      prefix.write(line);
      if (line.length < match.end - match.start) break;
    }
    _formatted = prefix.toString();
    _richTruncated = _formatted.length < _text.length;
  }

  static final _lines = RegExp(r'[^\r\n]*(?:\r\n?|\n|$)');
  static final _markers = RegExp(r'[>_*\[\]~`+.)\-]');
  static final _flatRule = RegExp(
    r'^ {0,3}(?:([-*_])(?:[ \t]*\1){2,}'
    r'|\|?[ \t]*:?-+:?[ \t]*(?:\|[ \t]*:?-+:?[ \t]*)*\|?)'
    r'[ \t]*(?:\r\n?|\n)?$',
  );

  static String _prefix(String text, int limit) {
    if (text.length <= limit) return text;
    final last = text.codeUnitAt(limit - 1);
    return text.substring(
      0,
      last >= 0xd800 && last <= 0xdbff ? limit - 1 : limit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilterChip(
              label: Text(context.l10n.markdown_source),
              selected: _source,
              onSelected: (selected) => setState(() => _source = selected),
            ),
            if (_text.length < widget.text.length ||
                (!_source && _richTruncated))
              Text(context.l10n.preview_truncated),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            key: ValueKey(_source),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _source
                ? SelectableText(
                    _text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  )
                : SelectionArea(
                    child: MarkdownBody(
                      data: _formatted,
                      fitContent: false,
                      sizedImageBuilder: (image) =>
                          image.alt?.isNotEmpty == true
                          ? Text(image.alt!)
                          : const Icon(Icons.image_not_supported_outlined),
                      onTapLink: (_, href, _) =>
                          openMarkdownWebLink(context, href),
                      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                        tableColumnWidth: const IntrinsicColumnWidth(),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
