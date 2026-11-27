import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Faces shipped with Ares. The chooser does not enumerate fonts installed
/// elsewhere on the computer: Flutter has no portable catalogue of those.
enum AresTypeface {
  platform,
  geist,
  geistMono,
  cinzel;

  String? get family => switch (this) {
    AresTypeface.platform => null,
    AresTypeface.geist => 'Geist',
    AresTypeface.geistMono => 'GeistMono',
    AresTypeface.cinzel => 'Cinzel',
  };

  static const chatChoices = <AresTypeface>[
    AresTypeface.platform,
    AresTypeface.geist,
    AresTypeface.cinzel,
  ];

  static const terminalChoices = <AresTypeface>[
    AresTypeface.platform,
    AresTypeface.geistMono,
  ];

  static AresTypeface? named(Object? value) => values.asNameMap()[value];
}

/// Forces the transcript only. Automatic follows the locale's direction.
enum TranscriptDirection {
  automatic,
  leftToRight,
  rightToLeft;

  TextDirection? get textDirection => switch (this) {
    TranscriptDirection.automatic => null,
    TranscriptDirection.leftToRight => TextDirection.ltr,
    TranscriptDirection.rightToLeft => TextDirection.rtl,
  };

  static TranscriptDirection? named(Object? value) => values.asNameMap()[value];
}

/// Inline embeds, as in Hermes Desktop: Ask shows a placeholder until the
/// reader allows each embed or service; Always loads them; Off keeps plain
/// links. Nothing is fetched for an embed the mode does not permit.
enum InlineEmbedMode {
  ask,
  always,
  off;

  static InlineEmbedMode? named(Object? value) => values.asNameMap()[value];
}

/// Device-local reading preferences. One JSON value, written in order.
class ReadingControls extends ChangeNotifier {
  ReadingControls(this._preferences)
    : _state = _ReadingState.decode(_preferences.get(preferenceKey));

  static const preferenceKey = 'presentation.reading.v1';

  /// Lowest user-bubble fill that still keeps the accent recognisable.
  static const minBubbleOpacity = 0.7;

  /// Services with a standing "Always allow"; the oldest drops first.
  static const maxAllowedEmbeds = 64;

  /// A provider id (`youtube`) or `image:` and an image host.
  static bool isEmbedServiceKey(String service) {
    if (_providerKey.hasMatch(service)) return true;
    return service.startsWith('image:') &&
        _hostKey.hasMatch(service.substring(6));
  }

  static final _providerKey = RegExp(r'^[a-z]{1,32}$');
  static final _hostKey = RegExp(r'^[a-z0-9](?:[a-z0-9.-]{0,251}[a-z0-9])?$');

  final SharedPreferences _preferences;
  _ReadingState _state;
  Future<void> _tail = Future<void>.value();
  var _disposed = false;

  AresTypeface get chatFont => _state.chatFont;
  AresTypeface get terminalFont => _state.terminalFont;
  TranscriptDirection get direction => _state.direction;
  double get bubbleOpacity => _state.bubbleOpacity;
  InlineEmbedMode get embedMode => _state.embedMode;

  /// Services the reader always allows, in the order they were allowed.
  Set<String> get allowedEmbeds => _state.allowedEmbeds;
  bool get emojiReactions => _state.emojiReactions;
  bool get celebrationHearts => _state.celebrationHearts;

  static ReadingControls? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ReadingScope>();
    return scope?.controls;
  }

  Future<void> setChatFont(AresTypeface value) =>
      _change((state) => state.copy(chatFont: value));

  Future<void> setTerminalFont(AresTypeface value) =>
      _change((state) => state.copy(terminalFont: value));

  Future<void> setDirection(TranscriptDirection value) =>
      _change((state) => state.copy(direction: value));

  Future<void> setBubbleOpacity(double value) {
    if (!value.isFinite) return Future<void>.value();
    final opacity = value.clamp(minBubbleOpacity, 1.0).toDouble();
    return _change((state) => state.copy(bubbleOpacity: opacity));
  }

  Future<void> setEmbedMode(InlineEmbedMode value) =>
      _change((state) => state.copy(embedMode: value));

  /// "Always allow" for one service. Invalid keys are ignored.
  Future<void> allowEmbedService(String service) {
    if (!isEmbedServiceKey(service)) return Future<void>.value();
    return _change((state) {
      if (state.allowedEmbeds.contains(service)) return state;
      final next = [...state.allowedEmbeds, service];
      return state.copy(
        allowedEmbeds: next
            .skip(math.max(0, next.length - maxAllowedEmbeds))
            .toSet(),
      );
    });
  }

  Future<void> resetAllowedEmbeds() =>
      _change((state) => state.copy(allowedEmbeds: const {}));

  Future<void> setEmojiReactions(bool value) =>
      _change((state) => state.copy(emojiReactions: value));

  Future<void> setCelebrationHearts(bool value) =>
      _change((state) => state.copy(celebrationHearts: value));

  Future<void> _change(_ReadingState Function(_ReadingState state) change) {
    final result = _tail.then((_) async {
      final next = change(_state);
      final encoded = jsonEncode(next.encode());
      final previous = _preferences.get(preferenceKey);
      if (previous == encoded) {
        _state = next;
        return;
      }
      try {
        if (!await _preferences.setString(preferenceKey, encoded)) {
          throw StateError('Could not save reading settings.');
        }
      } catch (_) {
        try {
          if (previous is String) {
            await _preferences.setString(preferenceKey, previous);
          } else {
            await _preferences.remove(preferenceKey);
          }
        } catch (_) {}
        rethrow;
      }
      _state = next;
      if (!_disposed) notifyListeners();
    });
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _ReadingScope extends InheritedNotifier<ReadingControls> {
  const _ReadingScope({required ReadingControls controls, required super.child})
    : super(notifier: controls);

  ReadingControls get controls => notifier!;
}

/// Publishes [ReadingControls] without owning their lifetime.
class ReadingScope extends StatelessWidget {
  const ReadingScope({super.key, required this.controls, required this.child});

  final ReadingControls controls;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      _ReadingScope(controls: controls, child: child);
}

final class _ReadingState {
  const _ReadingState({
    this.chatFont = AresTypeface.platform,
    this.terminalFont = AresTypeface.geistMono,
    this.direction = TranscriptDirection.automatic,
    this.bubbleOpacity = 1,
    this.embedMode = InlineEmbedMode.ask,
    this.allowedEmbeds = const {},
    this.emojiReactions = false,
    this.celebrationHearts = false,
  });

  final AresTypeface chatFont;
  final AresTypeface terminalFont;
  final TranscriptDirection direction;
  final double bubbleOpacity;
  final InlineEmbedMode embedMode;
  final Set<String> allowedEmbeds;
  final bool emojiReactions;
  final bool celebrationHearts;

  _ReadingState copy({
    AresTypeface? chatFont,
    AresTypeface? terminalFont,
    TranscriptDirection? direction,
    double? bubbleOpacity,
    InlineEmbedMode? embedMode,
    Set<String>? allowedEmbeds,
    bool? emojiReactions,
    bool? celebrationHearts,
  }) => _ReadingState(
    chatFont: chatFont ?? this.chatFont,
    terminalFont: terminalFont ?? this.terminalFont,
    direction: direction ?? this.direction,
    bubbleOpacity: bubbleOpacity ?? this.bubbleOpacity,
    embedMode: embedMode ?? this.embedMode,
    allowedEmbeds: allowedEmbeds == null
        ? this.allowedEmbeds
        : Set.unmodifiable(allowedEmbeds),
    emojiReactions: emojiReactions ?? this.emojiReactions,
    celebrationHearts: celebrationHearts ?? this.celebrationHearts,
  );

  Map<String, Object> encode() => {
    'chatFont': chatFont.name,
    'terminalFont': terminalFont.name,
    'direction': direction.name,
    'bubbleOpacity': bubbleOpacity,
    'embedMode': embedMode.name,
    'allowedEmbeds': allowedEmbeds.toList(),
    'emojiReactions': emojiReactions,
    'celebrationHearts': celebrationHearts,
  };

  static _ReadingState decode(Object? raw) {
    const fallback = _ReadingState();
    if (raw is! String || raw.length > 32 * 1024) return fallback;
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return fallback;
      final opacity = map['bubbleOpacity'];
      if (opacity is! num || !opacity.isFinite) return fallback;
      final chat = AresTypeface.named(map['chatFont']);
      final terminal = AresTypeface.named(map['terminalFont']);
      final direction = TranscriptDirection.named(map['direction']);
      if (chat == null ||
          terminal == null ||
          direction == null ||
          map['emojiReactions'] is! bool ||
          map['celebrationHearts'] is! bool) {
        return fallback;
      }
      if (!AresTypeface.chatChoices.contains(chat) ||
          !AresTypeface.terminalChoices.contains(terminal)) {
        return fallback;
      }
      return _ReadingState(
        chatFont: chat,
        terminalFont: terminal,
        direction: direction,
        bubbleOpacity: opacity.toDouble().clamp(
          ReadingControls.minBubbleOpacity,
          1.0,
        ),
        // The old on/off switch: on loaded every https image (Always), off
        // kept them as links, which Ask now does until the reader chooses.
        embedMode:
            InlineEmbedMode.named(map['embedMode']) ??
            (map['externalEmbeds'] == true
                ? InlineEmbedMode.always
                : InlineEmbedMode.ask),
        allowedEmbeds: Set.unmodifiable(_allowed(map['allowedEmbeds'])),
        emojiReactions: map['emojiReactions'] as bool,
        celebrationHearts: map['celebrationHearts'] as bool,
      );
    } on FormatException {
      return fallback;
    }
  }

  static Iterable<String> _allowed(Object? raw) {
    if (raw is! List) return const [];
    final valid = <String>{
      for (final service in raw)
        if (service is String && ReadingControls.isEmbedServiceKey(service))
          service,
    }.toList();
    return valid.skip(
      math.max(0, valid.length - ReadingControls.maxAllowedEmbeds),
    );
  }
}
