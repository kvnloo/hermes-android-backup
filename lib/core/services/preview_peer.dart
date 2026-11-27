import 'dart:convert';

/// Inbound Desktop preview requests only. A page never receives this object
/// or a gateway request/reply callback. All responses are synchronous so a
/// late result cannot be routed onto a replacement socket or document.
class PreviewPeers {
  final _entries =
      <String, ({Object token, String profile, PreviewAnswer answer})>{};

  void Function() attach(String runtime, String profile, PreviewAnswer answer) {
    if (_entries.containsKey(runtime)) {
      throw StateError('Preview already shared');
    }
    final token = Object();
    _entries[runtime] = (token: token, profile: profile, answer: answer);
    return () {
      if (identical(_entries[runtime]?.token, token)) _entries.remove(runtime);
    };
  }

  void clear() => _entries.clear();
  Map<String, dynamic>? answer(
    String method,
    Map<String, dynamic> params, {
    required bool replayed,
  }) {
    if (replayed || method != 'preview.read' && method != 'preview.act') {
      return null;
    }
    final entry = _entries[params['session_id']];
    if (entry == null ||
        params.containsKey('profile') && params['profile'] != entry.profile) {
      return null;
    }
    final action = method == 'preview.read'
        ? PreviewAction.read
        : switch (params['action']) {
            'elements' => PreviewAction.elements,
            'scroll' => PreviewAction.scroll,
            _ => null,
          };
    if (action == null) return null;
    int number(String name, int fallback, int min, int max) {
      final value = params[name];
      return value is int ? value.clamp(min, max) : fallback;
    }

    final result = entry.answer(
      action,
      start: number('start', 0, 0, 2000000),
      count: number('count', 24000, 1, 24000),
      amount: number('amount', 400, -1200, 1200),
      direction: params['to'] is String ? params['to'] as String : 'down',
    );
    return result == null ? null : {'value': jsonEncode(result)};
  }
}

enum PreviewAction { read, elements, scroll }

typedef PreviewAnswer =
    Map<String, dynamic>? Function(
      PreviewAction action, {
      required int start,
      required int count,
      required int amount,
      required String direction,
    });
