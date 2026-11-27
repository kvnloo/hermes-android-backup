import 'package:flutter/material.dart';

import '../theme/hermes_theme.dart';
import 'inline_embeds.dart';
import 'reading_controls.dart';

/// Chat face for prose. Missing scope keeps the surrounding theme.
TextStyle? chatTypeface(BuildContext context, TextStyle? style) {
  final family = ReadingControls.maybeOf(context)?.chatFont.family;
  if (family == null || style == null) return style;
  return style.copyWith(fontFamily: family);
}

/// Monospace face for code. Missing scope keeps the token face.
TextStyle terminalTypeface(BuildContext context, TextStyle style) {
  final family = ReadingControls.maybeOf(context)?.terminalFont.family;
  if (family == null) return style;
  return style.copyWith(fontFamily: family);
}

/// User bubbles fade toward the surface. Assistant bubbles stay opaque so
/// body text keeps the contrast the palette already measured.
Color userBubbleFill(BuildContext context, Color color) {
  final opacity = ReadingControls.maybeOf(context)?.bubbleOpacity;
  if (opacity == null || opacity >= 1) return color;
  return color.withValues(alpha: opacity);
}

/// Wraps a transcript when the reader has forced a direction.
Widget transcriptDirection(BuildContext context, Widget child) {
  final direction = ReadingControls.maybeOf(context)?.direction.textDirection;
  if (direction == null) return child;
  return Directionality(textDirection: direction, child: child);
}

/// The transcript's Markdown image hook, shared by both layouts. Inline
/// Embeds decides: Off keeps a link to the image, Ask shows a placeholder
/// naming the host until Load or Always allow, Always shows the image.
/// Only https images are ever downloaded; other sources stay [blocked].
/// [linkColor] is the prose's own link colour, for the links drawn in it.
Widget externalEmbed(
  BuildContext context, {
  required String? uri,
  required String? alt,
  required Widget blocked,
  Color? linkColor,
}) => inlineImageEmbed(
  context,
  uri: uri,
  alt: alt,
  blocked: blocked,
  linkColor: linkColor,
);

/// The transcript's provider-link hook, shared by both layouts: previews
/// for the bare YouTube, X, TikTok, Spotify, Maps… links in [markdown],
/// under its rendered [body]. The links in [body] stay tappable.
Widget transcriptEmbeds(
  BuildContext context,
  String markdown,
  Widget body, {
  required bool complete,
}) => withProviderEmbeds(context, markdown, body, complete: complete);

/// The chat a transcript's reactions belong to. Message ids are only unique
/// inside one chat (NextGen numbers every chat's rows from the same
/// sequence), so reactions are kept per chat, never in one shared map.
///
/// [chat] is either a string that names a stored chat on one connection and
/// profile (Classic), or the object that owns one visit to a chat (NextGen's
/// chat controller): those reactions last as long as that object.
class ReactionScope extends InheritedWidget {
  const ReactionScope({super.key, required this.chat, required super.child});

  final Object chat;

  static Object? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ReactionScope>()?.chat;

  @override
  bool updateShouldNotify(ReactionScope oldWidget) => oldWidget.chat != chat;
}

abstract final class _ReactionStore {
  /// Most recently used stored chats; an old chat's reactions age out.
  static const maxChats = 64;
  static final _byName = <String, Map<String, String>>{};
  static final _byOwner = Expando<Map<String, String>>('message reactions');

  static Map<String, String> of(Object chat) {
    if (chat is! String) return _byOwner[chat] ??= <String, String>{};
    final bucket = _byName.remove(chat) ?? <String, String>{};
    _byName[chat] = bucket;
    if (_byName.length > maxChats) _byName.remove(_byName.keys.first);
    return bucket;
  }
}

/// One reaction from a fixed set, kept for the message [messageId] in the
/// surrounding [ReactionScope]. Without a scope or an id it lasts only as
/// long as this widget.
class MessageReaction extends StatefulWidget {
  const MessageReaction({super.key, required this.messageId});

  final String? messageId;

  static const choices = <String>['👍', '👀', '✅'];

  @override
  State<MessageReaction> createState() => _MessageReactionState();
}

class _MessageReactionState extends State<MessageReaction> {
  String? _local;

  @override
  Widget build(BuildContext context) {
    if (!(ReadingControls.maybeOf(context)?.emojiReactions ?? false)) {
      return const SizedBox.shrink();
    }
    final chat = ReactionScope.maybeOf(context);
    final id = widget.messageId;
    final saved = chat == null || id == null ? null : _ReactionStore.of(chat);
    final selected = saved == null ? _local : saved[id];
    return Wrap(
      spacing: 4,
      children: [
        for (final emoji in MessageReaction.choices)
          ChoiceChip(
            label: Text(emoji),
            selected: selected == emoji,
            onSelected: (_) => setState(() {
              final next = selected == emoji ? null : emoji;
              if (saved == null) {
                _local = next;
              } else if (next == null) {
                saved.remove(id);
              } else {
                saved[id!] = next;
              }
            }),
          ),
      ],
    );
  }
}

/// A short heart burst when a reply arrived and the reader opted in.
class CelebrationHearts extends StatefulWidget {
  const CelebrationHearts({super.key, required this.play});

  final bool play;

  @override
  State<CelebrationHearts> createState() => _CelebrationHeartsState();
}

class _CelebrationHeartsState extends State<CelebrationHearts>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(CelebrationHearts oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final enabled =
        widget.play &&
        (ReadingControls.maybeOf(context)?.celebrationHearts ?? false);
    if (!enabled) {
      _clock.reset();
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) return;
    if (!_clock.isAnimating && _clock.value == 0) {
      _clock.forward();
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.play ||
        !(ReadingControls.maybeOf(context)?.celebrationHearts ?? false)) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: 28,
      height: 28,
      child: AnimatedBuilder(
        animation: _clock,
        // The active theme's danger red; an imported theme's error colour
        // when one is selected.
        builder: (context, _) => Icon(
          Icons.favorite,
          size: 16 + 8 * (1 - _clock.value),
          color: HermesTokens.of(
            context,
          ).danger.withValues(alpha: 1 - _clock.value),
        ),
      ),
    );
  }
}
