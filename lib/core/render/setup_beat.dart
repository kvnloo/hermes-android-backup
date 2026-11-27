/// `setup_beat`: the onboarding chat's card for one beat, sent by the gateway
/// as a server request (`tui_gateway/contracts/server_requests.py`, built by
/// `tools/setup_beat_tool.py::_card`). The user's pick answers that request
/// on the socket it arrived on; Classic and NextGen hold one card per chat.
///
/// Answers follow the Desktop (`apps/desktop/src/store/setup-beat.ts`):
/// a pick sends `{answer}`, and closing the card sends `{}`, which the
/// backend reads as a card closed without its own answer and records what
/// this machine already has. Beats whose card applies something on the
/// computer running Hermes (the theme accent, connecting apps, installing
/// plugins) are only closed from Ares, never answered with a pick that Ares
/// could not apply.
library;

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

enum SetupBeatKind { name, theme, layout, connectors, plugins, tour, build }

class SetupBeatOption {
  const SetupBeatOption(this.id, this.label);

  final String id;
  final String label;
}

class SetupBeatRequest {
  const SetupBeatRequest({
    required this.requestId,
    required this.beat,
    required this.question,
    this.toolCallId,
    this.suggestedName,
    this.options = const [],
    this.names = const [],
  });

  /// The local handle the answer is routed by (never shown).
  final String requestId;
  final SetupBeatKind beat;
  final String question;

  /// The setup_beat call the card belongs to.
  final String? toolCallId;

  /// The name card's suggestion (the account name; never sent unless picked).
  final String? suggestedName;

  /// layout, tour and build: the backend's options; an answer must be one.
  final List<SetupBeatOption> options;

  /// connectors: suggested slugs; plugins: catalog plugin names.
  final List<String> names;

  /// A card the gateway built, or null for an unknown beat or shape.
  static SetupBeatRequest? parse(
    String requestId,
    Map<String, dynamic> params,
  ) {
    if (requestId.isEmpty) return null;
    final beat = SetupBeatKind.values
        .where((kind) => kind.name == params['beat'])
        .firstOrNull;
    if (beat == null) return null;
    final card = params['card'];
    final data = card is Map ? card : const {};
    List<String> strings(Object? value) => value is List
        ? [
            for (final item in value)
              if (item is String && item.trim().isNotEmpty) item.trim(),
          ]
        : const [];
    final options = <SetupBeatOption>[];
    final rawOptions = data['options'];
    if (rawOptions is List) {
      for (final raw in rawOptions) {
        if (raw is! Map) continue;
        final id = raw['id'];
        final label = raw['label'];
        if (id is String && id.isNotEmpty) {
          options.add(
            SetupBeatOption(
              id,
              label is String && label.isNotEmpty ? label : id,
            ),
          );
        }
      }
    }
    final suggested = data['suggested'];
    final toolCallId = params['tool_call_id'];
    return SetupBeatRequest(
      requestId: requestId,
      beat: beat,
      question: (params['question'] as Object?)?.toString().trim() ?? '',
      toolCallId: toolCallId is String && toolCallId.isNotEmpty
          ? toolCallId
          : null,
      suggestedName: beat == SetupBeatKind.name && suggested is String
          ? suggested.trim()
          : null,
      options: List.unmodifiable(options),
      names: List.unmodifiable(
        beat == SetupBeatKind.plugins
            ? strings(data['plugins'])
            : beat == SetupBeatKind.connectors
            ? strings(suggested)
            : const <String>[],
      ),
    );
  }

  /// Whether Ares can answer this beat with a pick. The others only close.
  bool get answerable => switch (beat) {
    SetupBeatKind.name => true,
    SetupBeatKind.layout ||
    SetupBeatKind.tour ||
    SetupBeatKind.build => options.isNotEmpty,
    SetupBeatKind.theme ||
    SetupBeatKind.connectors ||
    SetupBeatKind.plugins => false,
  };

  /// The `{answer: …}` result for [option] on an options beat.
  Map<String, dynamic> answerFor(SetupBeatOption option) => {
    'answer': switch (beat) {
      SetupBeatKind.layout => {'layout': option.id},
      SetupBeatKind.tour => {'tour': option.id, 'label': option.label},
      _ => {'build': option.id, 'label': option.label},
    },
  };
}

/// What became of a card's answer.
enum SetupBeatSend {
  /// The answer went out on the request's socket; the card closes.
  sent,

  /// The request still waits here but the answer did not go out (its socket
  /// dropped). The card stays to be answered again, as on the Desktop,
  /// whose setup-beat store clears a card only once its answer is sent.
  failed,

  /// The request no longer waits here (answered elsewhere, withdrawn, or
  /// another chat's).
  closed,
}

/// Sends a result for the card.
typedef SetupBeatAnswer =
    Future<SetupBeatSend> Function(Map<String, dynamic> result);

/// The card for one waiting beat, drawn above the composer in both layouts.
class SetupBeatCard extends StatefulWidget {
  const SetupBeatCard({
    super.key,
    required this.request,
    required this.onAnswer,
  });

  final SetupBeatRequest request;
  final SetupBeatAnswer onAnswer;

  @override
  State<SetupBeatCard> createState() => _SetupBeatCardState();
}

class _SetupBeatCardState extends State<SetupBeatCard> {
  final _name = TextEditingController();
  var _sending = false;
  String? _error;

  @override
  void didUpdateWidget(SetupBeatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request.requestId != widget.request.requestId) {
      _name.clear();
      _sending = false;
      _error = null;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _send(Map<String, dynamic> result) async {
    if (_sending) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final requestId = widget.request.requestId;
    SetupBeatSend outcome;
    try {
      outcome = await widget.onAnswer(result);
    } catch (_) {
      outcome = SetupBeatSend.failed;
    }
    if (!mounted || widget.request.requestId != requestId) return;
    final l = context.sharedL10n;
    setState(() {
      _sending = false;
      _error = switch (outcome) {
        SetupBeatSend.sent => null,
        SetupBeatSend.failed => l.setup_beat_send_failed,
        SetupBeatSend.closed => l.setup_beat_not_waiting,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    final request = widget.request;
    final theme = Theme.of(context);
    final typed = _name.text.trim();
    final body = <Widget>[];
    switch (request.beat) {
      case SetupBeatKind.name:
        final suggested = request.suggestedName;
        if (suggested != null && suggested.isNotEmpty) {
          body.add(
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ActionChip(
                key: const Key('setup-beat-suggested-name'),
                label: Text(l.setup_beat_use_name(suggested)),
                onPressed: _sending
                    ? null
                    : () => _send({
                        'answer': {'name': suggested},
                      }),
              ),
            ),
          );
        }
        body.add(
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('setup-beat-name'),
                  controller: _name,
                  enabled: !_sending,
                  decoration: InputDecoration(
                    hintText: l.setup_beat_name_hint,
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _send({
                        'answer': {'name': value.trim()},
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const Key('setup-beat-name-continue'),
                onPressed: _sending || typed.isEmpty
                    ? null
                    : () => _send({
                        'answer': {'name': typed},
                      }),
                child: Text(l.ng_continue),
              ),
            ],
          ),
        );
      case SetupBeatKind.layout || SetupBeatKind.tour || SetupBeatKind.build:
        body.add(
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in request.options)
                OutlinedButton(
                  key: Key('setup-beat-option-${option.id}'),
                  onPressed: _sending
                      ? null
                      : () => _send(request.answerFor(option)),
                  child: Text(option.label),
                ),
            ],
          ),
        );
      case SetupBeatKind.theme ||
          SetupBeatKind.connectors ||
          SetupBeatKind.plugins:
        if (request.names.isNotEmpty) {
          body.add(Text(request.names.join(', ')));
        }
        body.add(
          Text(l.setup_beat_on_computer, style: theme.textTheme.bodySmall),
        );
    }
    // The composer stays below the card, so on a phone the card scrolls
    // within at most two fifths of the screen.
    return Card(
      key: Key('setup-beat-${request.requestId}'),
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.4,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                request.question.isNotEmpty
                    ? request.question
                    : l.setup_beat_title,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...body,
              if (_error != null) ...[
                const SizedBox(height: 6),
                Text(
                  _error!,
                  key: const Key('setup-beat-error'),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  key: const Key('setup-beat-close'),
                  onPressed: _sending ? null : () => _send(const {}),
                  child: Text(
                    request.answerable ? l.ng_not_now : l.ng_continue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
