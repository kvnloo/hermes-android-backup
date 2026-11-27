import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../composer/composer_commands.dart';

Future<ResumeCandidate?> showResumePicker({
  required BuildContext context,
  required String initialQuery,
  required bool listAvailable,
  required Future<List<ResumeCandidate>> Function(String query) load,
}) {
  return showModalBottomSheet<ResumeCandidate>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _ResumePicker(
      initialQuery: initialQuery,
      listAvailable: listAvailable,
      load: load,
    ),
  );
}

class _ResumePicker extends StatefulWidget {
  const _ResumePicker({
    required this.initialQuery,
    required this.listAvailable,
    required this.load,
  });

  final String initialQuery;
  final bool listAvailable;
  final Future<List<ResumeCandidate>> Function(String query) load;

  @override
  State<_ResumePicker> createState() => _ResumePickerState();
}

class _ResumePickerState extends State<_ResumePicker> {
  late final TextEditingController _query = TextEditingController(
    text: widget.initialQuery,
  );
  List<ResumeCandidate> _rows = const [];
  Object? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.listAvailable) {
      _search(_query.text);
    }
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = filterResume(await widget.load(query), query);
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _rows = const [];
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.composer_resume_title)),
            if (!widget.listAvailable)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.composer_resume_unavailable),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  key: const ValueKey('resume-search'),
                  controller: _query,
                  decoration: InputDecoration(
                    hintText: l10n.composer_resume_search,
                  ),
                  onChanged: _search,
                ),
              ),
              if (_loading) const LinearProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('$_error'),
                ),
              if (!_loading && _error == null && _rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.composer_resume_empty),
                ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final row in _rows)
                      ListTile(
                        key: ValueKey('resume-${row.id}'),
                        title: Text(row.title.isEmpty ? row.id : row.title),
                        subtitle: Text(row.id),
                        onTap: () => Navigator.pop(context, row),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
