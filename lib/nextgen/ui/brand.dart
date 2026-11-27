// Ares branding for NextGen's launch and empty new-chat screens.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/models/session.dart';
import '../nextgen_l10n.dart';
import '../theme/nextgen_theme.dart';
import 'sessions_sidebar.dart';
import 'widgets.dart';

/// The black-on-white Ares mark (transparent background, black art).
const ngBrandMarkAsset = 'assets/icon/ares_mark_black.png';

/// Classic's ARES: Cinzel w700, letter spacing 6 at 22 px (0.27 em).
const double ngBrandTracking = 6 / 22;

/// Silver-white on dark themes; graphite-silver on light ones (silver-white
/// would vanish on NextGen's near-white background).
const ngBrandSilver = [Color(0xFFFFFFFF), Color(0xFFC3C7CE)];
const ngBrandGraphite = [Color(0xFF3A3D44), Color(0xFF7D828C)];

bool _dark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

/// The logo on its own white rounded tile. Dark themes get a silver hairline
/// ring a few pixels outside the tile; light themes a hairline border.
class NgBrandLogo extends StatelessWidget {
  const NgBrandLogo({super.key, required this.size});

  /// The white tile's side, in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = _dark(context);
    final radius = size * 0.14; // 28 at 200
    final tile = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.07),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: dark
            ? null
            : Border.all(color: const Color(0x2E0A0A1E), width: 1),
        boxShadow: [
          if (dark)
            BoxShadow(
              color: ngBrandSilver.last.withValues(alpha: 0.10),
              blurRadius: size * 0.22,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: size * 0.12,
              offset: Offset(0, size * 0.02),
            ),
        ],
      ),
      child: Image.asset(
        ngBrandMarkAsset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'Ares',
      ),
    );
    if (!dark) return tile;
    final gap = math.max(3.0, size * 0.025);
    return Container(
      padding: EdgeInsets.all(gap),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius + gap),
        border: Border.all(
          color: ngBrandSilver.last.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: tile,
    );
  }
}

/// ARES in Classic's Cinzel, filled with a vertical silver gradient.
class NgBrandWordmark extends StatelessWidget {
  const NgBrandWordmark({super.key, required this.size});

  /// Font size in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = _dark(context) ? ngBrandSilver : ngBrandGraphite;
    final tracking = size * ngBrandTracking;
    return Padding(
      // Letter spacing also follows the last letter: balance it on the left
      // so the word sits on the logo's centre line.
      padding: EdgeInsets.only(left: tracking),
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (rect) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Cinzel's caps span about 16% to 74% of the 1.15 line box: the
          // gradient runs from cap top to baseline.
          stops: const [0.16, 0.74],
          colors: colors,
        ).createShader(rect),
        child: ExcludeSemantics(
          child: Text(
            'ARES',
            textScaler: TextScaler.noScaling,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontWeight: FontWeight.w700,
              letterSpacing: tracking,
              fontSize: size,
              height: 1.15,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo above wordmark, or beside it when [horizontal] (the compact lockup
/// the new-chat screen falls back to when the keyboard leaves little room).
class NgBrandMark extends StatelessWidget {
  const NgBrandMark({
    super.key,
    required this.logoSize,
    required this.wordSize,
    this.gap,
    this.horizontal = false,
  });

  final double logoSize;
  final double wordSize;
  final double? gap;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final space = gap ?? logoSize * 0.13;
    if (horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NgBrandLogo(size: logoSize),
          SizedBox(width: space),
          NgBrandWordmark(size: wordSize),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NgBrandLogo(size: logoSize),
        SizedBox(height: space),
        NgBrandWordmark(size: wordSize),
      ],
    );
  }
}

/// The brand above a new chat's greeting, sized to the room it has: the
/// stacked brand (logo 72, ARES 28) when there is space, a one-line lockup
/// when the keyboard is up, nothing when even that would push the greeting
/// out of view. Never taller than the pane, so the composer stays put.
Widget? ngNewChatBrand(double height, {double textScale = 1}) {
  // Reserve room for the sparkle, wrapping project greeting and body first.
  final greeting = 220.0 * textScale;
  if (height >= greeting + 165) {
    return const NgBrandMark(logoSize: 72, wordSize: 28, gap: 12);
  }
  if (height >= greeting + 72) {
    return const NgBrandMark(
      logoSize: 36,
      wordSize: 24,
      gap: 12,
      horizontal: true,
    );
  }
  return null;
}

/// What NextGen shows on launch until a chat is opened or started.
class NgBrandLanding extends StatelessWidget {
  const NgBrandLanding({
    super.key,
    required this.sessions,
    required this.docked,
    required this.onNewChat,
    required this.onOpen,
    required this.onOpenChats,
    this.recentCount = 4,
  });

  final NgSessionsModel sessions;

  /// The sidebar sits beside this pane (wide windows): it already lists the
  /// chats, so the landing only offers New chat.
  final bool docked;
  final VoidCallback onNewChat;
  final ValueChanged<Session> onOpen;
  final VoidCallback onOpenChats;
  final int recentCount;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final big = docked;
    return ColoredBox(
      color: c.background,
      child: NgGlow(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: big ? 40 : 28,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: big ? 360 : 380),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: NgBrandMark(
                            logoSize: big ? 240 : 200,
                            wordSize: big ? 80 : 56,
                            gap: big ? 30 : 24,
                          ),
                        ),
                        SizedBox(height: big ? 44 : 34),
                        NgPrimaryButton(
                          key: const ValueKey('ng-brand-new-chat'),
                          label: ngL.ng_new_chat,
                          icon: Icons.edit_square,
                          onPressed: onNewChat,
                        ),
                        if (docked) ...[
                          const SizedBox(height: 14),
                          Text(
                            ngL.ng_brand_sidebar_hint,
                            textAlign: TextAlign.center,
                            style: NgType.bodySmall.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 10),
                          NgSecondaryButton(
                            key: const ValueKey('ng-brand-open-chat'),
                            label: ngL.ng_brand_open_chat,
                            icon: Icons.view_sidebar_outlined,
                            onPressed: onOpenChats,
                          ),
                          _Recent(
                            sessions: sessions,
                            count: recentCount,
                            onOpen: onOpen,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (!docked)
                PositionedDirectional(
                  top: 4,
                  start: 4,
                  child: IconButton(
                    key: const ValueKey('ng-sidebar-button'),
                    tooltip: ngL.ng_chats,
                    color: c.text2,
                    icon: const Icon(Icons.view_sidebar_outlined),
                    onPressed: onOpenChats,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The few most recent chats, one tap to open.
class _Recent extends StatelessWidget {
  const _Recent({
    required this.sessions,
    required this.count,
    required this.onOpen,
  });

  final NgSessionsModel sessions;
  final int count;
  final ValueChanged<Session> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return ListenableBuilder(
      listenable: sessions,
      builder: (context, _) {
        final recent = sessions.sessions
            .where(sessions.includesChat)
            .take(count)
            .toList();
        if (recent.isEmpty) return const SizedBox(height: 0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            NgSectionLabel(ngL.ng_brand_recent),
            NgCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (i, s) in recent.indexed) ...[
                    if (i > 0)
                      Divider(height: 1, thickness: 1, color: c.stroke),
                    InkWell(
                      key: ValueKey('ng-brand-recent-${s.id}'),
                      onTap: () => onOpen(s),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 17,
                              color: c.text3,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                ngSessionTitle(s),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: NgType.label.copyWith(color: c.text),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              ngAgo(ngSessionTime(s)),
                              style: NgType.caption.copyWith(color: c.text3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
