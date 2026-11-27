import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../theme/hermes_theme.dart';

/// Only coarse, transient signals enter the pet. No messages or session IDs.
enum PetActivity { idle, working, thinking, waiting, completed, failed }

enum PetSpecies { mosskip, emberbun, tideling, hatchling }

enum PetSize { small, medium, large }

/// A local draft is already reduced to a thumbnail. It never retains an encoded
/// image, path, EXIF, user-supplied name, or URI. One byte per pixel: 0 is
/// transparent, 1..216 are the colors of a six-level RGB cube.
final class PetDraft {
  PetDraft._(this._pixels);
  final Uint8List _pixels;
  static const edge = 24;
  static const maxFileBytes = 4 * 1024 * 1024;
  static const maxImageEdge = 4096;
  static const maxImagePixels = 8 * 1024 * 1024;

  static Future<PetDraft?> pick() async {
    final files = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['png', 'jpg', 'jpeg'],
      allowMultiple: false,
      withData: false,
      withReadStream: true,
    );
    if (files == null || files.files.isEmpty) return null;
    final file = files.files.single;
    final stream = file.readStream;
    if (file.size <= 0 || file.size > maxFileBytes || stream == null) {
      throw const FormatException('Invalid image size');
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in stream) {
      if (chunk.length > maxFileBytes - bytes.length) {
        throw const FormatException('Image too large');
      }
      bytes.add(chunk);
    }
    return fromImageBytes(bytes.takeBytes());
  }

  static Future<PetDraft> fromImageBytes(Uint8List bytes) async {
    const png = [137, 80, 78, 71, 13, 10, 26, 10];
    if (bytes.length < 8 ||
        bytes.length > maxFileBytes ||
        !(listEquals(bytes.sublist(0, 8), png) ||
            (bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255))) {
      throw const FormatException('Choose a PNG or JPEG');
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    ui.ImageDescriptor? descriptor;
    ui.Codec? codec;
    ui.Image? frame;
    try {
      descriptor = await ui.ImageDescriptor.encoded(buffer);
      final width = descriptor.width, height = descriptor.height;
      if (width <= 0 ||
          height <= 0 ||
          width > maxImageEdge ||
          height > maxImageEdge ||
          width * height > maxImagePixels) {
        throw const FormatException('Image dimensions too large');
      }
      final ratio = edge / math.max(width, height);
      codec = await descriptor.instantiateCodec(
        targetWidth: math.max(1, (width * ratio).round()),
        targetHeight: math.max(1, (height * ratio).round()),
      );
      frame = (await codec.getNextFrame()).image;
      final w = frame.width, h = frame.height;
      if (w > edge || h > edge) throw const FormatException('Invalid resize');
      final data = await frame.toByteData(
        format: ui.ImageByteFormat.rawStraightRgba,
      );
      if (data == null) throw const FormatException('No pixels');
      final pixels = Uint8List(edge * edge);
      final left = (edge - w) ~/ 2, top = (edge - h) ~/ 2;
      var visible = false;
      for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
          final i = (y * w + x) * 4;
          if (data.getUint8(i + 3) < 128) continue;
          final r = (data.getUint8(i) / 51).round();
          final g = (data.getUint8(i + 1) / 51).round();
          final b = (data.getUint8(i + 2) / 51).round();
          pixels[(top + y) * edge + left + x] = 1 + r * 36 + g * 6 + b;
          visible = true;
        }
      }
      if (!visible) throw const FormatException('No visible pixels');
      return PetDraft._(pixels);
    } finally {
      frame?.dispose();
      codec?.dispose();
      descriptor?.dispose();
      buffer.dispose();
    }
  }

  static PetDraft? _restore(Object? value) {
    if (value is! String || value.length != edge * edge * 4 ~/ 3) return null;
    final pixels = base64Decode(value);
    if (pixels.length != edge * edge ||
        pixels.any((p) => p > 216) ||
        !pixels.any((p) => p != 0)) {
      return null;
    }
    return PetDraft._(pixels);
  }
}

class _PetState {
  const _PetState({
    this.enabled = false,
    this.roam = false,
    this.size = PetSize.medium,
    this.species = PetSpecies.mosskip,
    this.draft,
  });
  final bool enabled, roam;
  final PetSize size;
  final PetSpecies species;
  final PetDraft? draft;

  _PetState copy({
    bool? enabled,
    bool? roam,
    PetSize? size,
    PetSpecies? species,
    PetDraft? draft,
    bool forget = false,
  }) => _PetState(
    enabled: enabled ?? this.enabled,
    roam: roam ?? this.roam,
    size: size ?? this.size,
    species: species ?? this.species,
    draft: forget ? null : draft ?? this.draft,
  );

  String encode() => jsonEncode({
    'enabled': enabled,
    'roam': roam,
    'size': size.name,
    'species': species.name,
    if (draft != null) 'portrait': base64Encode(draft!._pixels),
  });

  static _PetState read(Object? raw) {
    if (raw is! String || raw.length > 1024) return const _PetState();
    try {
      final map = jsonDecode(raw);
      if (map is! Map ||
          map['enabled'] is! bool ||
          map['roam'] is! bool ||
          map['size'] is! String ||
          map['species'] is! String) {
        return const _PetState();
      }
      final size = PetSize.values.byName(map['size']);
      final species = PetSpecies.values.byName(map['species']);
      final draft = PetDraft._restore(map['portrait']);
      if (draft == null &&
          (map.containsKey('portrait') || species == PetSpecies.hatchling)) {
        return const _PetState();
      }
      return _PetState(
        enabled: map['enabled'],
        roam: map['roam'],
        size: size,
        species: species,
        draft: draft,
      );
    } on FormatException {
      return const _PetState();
    } on ArgumentError {
      return const _PetState();
    }
  }
}

/// Device-local appearance. Share one owner between settings and companions;
/// the caller disposes it. [snapshot] contains only the validated cosmetic state.
class PetdexController extends ChangeNotifier {
  PetdexController(SharedPreferences preferences)
    : _prefs = preferences,
      _state = _PetState.read(preferences.get(preferenceKey));

  /// Read a bounded cosmetic snapshot without opening the main store.
  PetdexController.preview(Object? snapshot)
    : _prefs = null,
      _state = _PetState.read(snapshot);

  static const preferenceKey = 'presentation.petdex.v1';
  final SharedPreferences? _prefs;
  _PetState _state;
  Future<void> _tail = Future.value();
  bool _disposed = false;
  bool get enabled => _state.enabled;
  bool get roaming => _state.roam;
  PetSize get size => _state.size;
  PetSpecies get species => _state.species;
  bool get hasHatch => _state.draft != null;
  String get snapshot => _state.encode();

  Future<void> setEnabled(bool value) => _change((s) => s.copy(enabled: value));
  Future<void> setRoaming(bool value) => _change((s) => s.copy(roam: value));
  Future<void> setSize(PetSize value) => _change((s) => s.copy(size: value));
  Future<void> adopt(PetSpecies value) => _change((s) {
    if (value == PetSpecies.hatchling && s.draft == null) {
      throw StateError('No hatchling');
    }
    return s.copy(enabled: true, species: value);
  });
  Future<void> hatch(PetDraft draft) => _change(
    (s) => s.copy(enabled: true, species: PetSpecies.hatchling, draft: draft),
  );
  Future<void> forgetHatch() => _change(
    (s) => s.species == PetSpecies.hatchling
        ? s.copy(enabled: false, species: PetSpecies.mosskip, forget: true)
        : s.copy(forget: true),
  );

  Future<void> _change(_PetState Function(_PetState) change) {
    final result = _tail.then((_) async {
      final next = change(_state);
      final prefs = _prefs;
      if (prefs != null) {
        try {
          if (!await prefs.setString(preferenceKey, next.encode())) {
            throw StateError('Petdex save failed');
          }
        } catch (_) {
          // SharedPreferences writes its cache before platform persistence.
          // Restore the last confirmed, sanitized state, even on a false result.
          try {
            await prefs.setString(preferenceKey, snapshot);
          } catch (_) {}
          rethrow;
        }
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

String _name(BuildContext c, PetSpecies pet) => switch (pet) {
  PetSpecies.mosskip => c.sharedL10n.appearance_mosskip,
  PetSpecies.emberbun => c.sharedL10n.appearance_emberbun,
  PetSpecies.tideling => c.sharedL10n.appearance_tideling,
  PetSpecies.hatchling => c.sharedL10n.appearance_my_hatchling,
};
String _status(BuildContext c, PetActivity activity) => switch (activity) {
  PetActivity.idle => c.sharedL10n.appearance_at_rest,
  PetActivity.working => c.sharedL10n.appearance_working,
  PetActivity.thinking => c.sharedL10n.appearance_thinking,
  PetActivity.waiting => c.sharedL10n.appearance_waiting_for_you,
  PetActivity.completed => c.sharedL10n.appearance_reply_ready,
  PetActivity.failed => c.sharedL10n.appearance_turn_failed,
};
String _sizeName(BuildContext c, PetSize size) => switch (size) {
  PetSize.small => c.sharedL10n.appearance_small,
  PetSize.medium => c.sharedL10n.appearance_medium,
  PetSize.large => c.sharedL10n.appearance_large,
};

/// Original little pixel silhouettes, drawn locally, not gateway sprite assets.
const _moss = [
  '..dd.....dd.',
  '.dggd...dggd',
  '.dgwd...dwgd',
  '..ddddddddd.',
  '.dgggggggggd',
  '.dggtgggtggd',
  '.dgggddggggd',
  '..dtttttttd.',
  '...ddddddd..',
  '..dggd.dggd.',
];
const _ember = [
  '..dd....dd..',
  '.dood..dood.',
  '.doood.dood.',
  '..dooddood..',
  '...dooood...',
  '..doooowod..',
  '.doowoowood.',
  '.doooddooood',
  '..dotttoodd.',
  '...dd..dd...',
];
const _tide = [
  '.....dd.....',
  '....dbbd....',
  '...dbwwbd...',
  '..dbbbbbbd..',
  '.dbbbbbbbbd.',
  'dbbbdbbdbbbd',
  '.dbbbbbbbbd.',
  '..dbbttbbd..',
  '...dttttd...',
  '..dd.dd.dd..',
];

/// The built-in pets are drawn in the active theme's inks, so they stay
/// visible on any surface: an outline in the body text colour, the status
/// greens, ambers and blues for bodies, and a highlight that contrasts with
/// the outline. A hatchling keeps the user's own picture colours.
class _PetInks {
  _PetInks(HermesTokens t)
    : outline = t.onSurface,
      green = t.success,
      amber = t.warning,
      blue = t.running,
      highlight = foregroundFor(t.onSurface),
      belly = Color.lerp(t.success, foregroundFor(t.onSurface), 0.45)!;

  final Color outline, green, amber, blue, highlight, belly;

  Color? operator [](String code) => switch (code) {
    'd' => outline,
    'g' => green,
    'o' => amber,
    'w' => highlight,
    'b' => blue,
    't' => belly,
    _ => null,
  };

  @override
  bool operator ==(Object other) =>
      other is _PetInks &&
      other.outline == outline &&
      other.green == green &&
      other.amber == amber &&
      other.blue == blue &&
      other.highlight == highlight &&
      other.belly == belly;

  @override
  int get hashCode =>
      Object.hash(outline, green, amber, blue, highlight, belly);
}

class _PortraitPainter extends CustomPainter {
  const _PortraitPainter(this.pet, this.draft, this.inks);
  final PetSpecies pet;
  final PetDraft? draft;
  final _PetInks inks;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    final custom = pet == PetSpecies.hatchling ? draft : null;
    final rows = switch (pet) {
      PetSpecies.emberbun => _ember,
      PetSpecies.tideling => _tide,
      _ => _moss,
    };
    final w = custom == null ? 12 : PetDraft.edge;
    final h = custom == null ? rows.length : PetDraft.edge;
    final unit = math.min(size.width / w, size.height / h);
    final dx = (size.width - unit * w) / 2, dy = (size.height - unit * h) / 2;
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        if (custom != null) {
          final index = custom._pixels[y * w + x] - 1;
          if (index < 0) continue;
          paint.color = Color.fromARGB(
            255,
            index ~/ 36 * 51,
            index ~/ 6 % 6 * 51,
            index % 6 * 51,
          );
        } else {
          final color = inks[rows[y][x]];
          if (color == null) continue;
          paint.color = color;
        }
        canvas.drawRect(
          Rect.fromLTWH(dx + x * unit, dy + y * unit, unit, unit),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_PortraitPainter old) =>
      pet != old.pet || draft != old.draft || inks != old.inks;
}

Widget _art(
  BuildContext context,
  PetSpecies species,
  PetDraft? draft,
  double side,
) => RepaintBoundary(
  child: SizedBox.square(
    dimension: side,
    child: CustomPaint(
      painter: _PortraitPainter(
        species,
        draft,
        _PetInks(HermesTokens.of(context)),
      ),
    ),
  ),
);

/// Both views disappear when disabled. The compact view is a 48dp toolbar
/// target. The full view takes up to 280dp width and should be given natural
/// height (or a scrolling parent). No activity or unread flag is persisted.
class PetCompanion extends StatelessWidget {
  const PetCompanion.compact({
    super.key,
    required this.controller,
    this.activity = PetActivity.idle,
    this.anyUnread = false,
    this.onCompose,
  }) : _compact = true;
  const PetCompanion.full({
    super.key,
    required this.controller,
    this.activity = PetActivity.idle,
    this.anyUnread = false,
    this.onCompose,
  }) : _compact = false;
  final PetdexController controller;
  final PetActivity activity;
  final bool anyUnread;
  final VoidCallback? onCompose;
  final bool _compact;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => controller.enabled
        ? _AwakePet(
            species: controller.species,
            size: controller.size,
            draft: controller._state.draft,
            roam: controller.roaming,
            compact: _compact,
            activity: activity,
            anyUnread: anyUnread,
            onCompose: onCompose,
          )
        : const SizedBox.shrink(),
  );
}

class _AwakePet extends StatefulWidget {
  const _AwakePet({
    required this.species,
    required this.draft,
    required this.size,
    required this.roam,
    required this.compact,
    required this.activity,
    required this.anyUnread,
    required this.onCompose,
  });
  final PetSpecies species;
  final PetDraft? draft;
  final PetSize size;
  final bool roam, compact, anyUnread;
  final PetActivity activity;
  final VoidCallback? onCompose;
  @override
  State<_AwakePet> createState() => _AwakePetState();
}

class _AwakePetState extends State<_AwakePet>
    with SingleTickerProviderStateMixin {
  late final _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );
  Timer? _hello;
  bool _greeting = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) ||
        !TickerMode.valuesOf(context).enabled) {
      _clock.reset();
    } else if (!_clock.isAnimating) {
      _clock.repeat();
    }
  }

  @override
  void dispose() {
    _hello?.cancel();
    _clock.dispose();
    super.dispose();
  }

  void _greet() {
    _hello?.cancel();
    setState(() => _greeting = true);
    _hello = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _greeting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = _name(context, widget.species);
    final status = _status(context, widget.activity);
    final hello = context.sharedL10n.appearance_hello;
    final unread = context.sharedL10n.appearance_unread_reply;
    final compose = context.sharedL10n.appearance_compose;
    final greet = context.sharedL10n.appearance_say_hello;
    final compact = widget.compact;
    final hint = compact && widget.onCompose != null ? compose : greet;
    final action = compact ? widget.onCompose ?? _greet : _greet;
    final side = (compact
        ? const [24.0, 30.0, 36.0]
        : const [44.0, 60.0, 76.0])[widget.size.index];
    final label = [
      name,
      status,
      if (widget.anyUnread) unread,
      if (_greeting) hello,
    ].join(' · ');
    final colors = Theme.of(context).colorScheme;
    final still = MediaQuery.disableAnimationsOf(context);
    final icon = switch (widget.activity) {
      PetActivity.idle => null,
      PetActivity.failed => Icons.error_outline,
      PetActivity.completed => Icons.check,
      PetActivity.waiting => Icons.pan_tool_outlined,
      PetActivity.working => Icons.bolt,
      PetActivity.thinking => Icons.more_horiz,
    };
    final stage = Semantics(
      button: true,
      label: label,
      hint: hint,
      onTap: action,
      excludeSemantics: true,
      child: Tooltip(
        message: '$label — $hint',
        excludeFromSemantics: true,
        child: Material(
          color: compact ? Colors.transparent : colors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: action,
            child: SizedBox(
              width: compact ? 48 : 280,
              height: compact ? 48 : 96,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, bounds) {
                        final artSize = math.min(
                          side,
                          math.min(bounds.maxWidth, bounds.maxHeight),
                        );
                        final range = math.max(
                          0.0,
                          (bounds.maxWidth - artSize - 4) / 2,
                        );
                        return Center(
                          child: AnimatedBuilder(
                            animation: _clock,
                            child: _art(
                              context,
                              widget.species,
                              widget.draft,
                              artSize,
                            ),
                            builder: (context, child) {
                              final t = still
                                  ? 0.0
                                  : _clock.value * math.pi * 2;
                              final roam =
                                  widget.roam &&
                                  widget.activity == PetActivity.idle &&
                                  !_greeting &&
                                  !widget.anyUnread;
                              final dx = roam ? math.sin(t) * range : 0.0;
                              final (bob, tilt) = switch (_greeting
                                  ? PetActivity.completed
                                  : widget.activity) {
                                PetActivity.working => (
                                  -3 * math.sin(6 * t).abs(),
                                  .10 * math.sin(6 * t),
                                ),
                                PetActivity.completed => (
                                  -4 * math.sin(3 * t).abs(),
                                  .12 * math.sin(3 * t),
                                ),
                                PetActivity.waiting => (
                                  0.0,
                                  .06 * math.sin(2 * t),
                                ),
                                PetActivity.thinking => (
                                  -2 * math.sin(2 * t).abs(),
                                  -.06 * math.sin(t),
                                ),
                                PetActivity.failed => (1.0, -.09),
                                PetActivity.idle => (
                                  -1.6 * math.sin((roam ? 6 : 2) * t).abs(),
                                  0.0,
                                ),
                              };
                              return Transform.translate(
                                offset: Offset(dx, bob),
                                child: Transform.rotate(
                                  angle: tilt,
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.anyUnread || _greeting || icon != null)
                    PositionedDirectional(
                      top: 2,
                      end: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            widget.anyUnread
                                ? Icons.mark_email_unread_outlined
                                : _greeting
                                ? Icons.waving_hand_outlined
                                : icon,
                            size: compact ? 13 : 17,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (compact) return stage;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          stage,
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            [
              if (_greeting) hello,
              status,
              if (widget.anyUnread) unread,
            ].join(' · '),
            textAlign: TextAlign.center,
          ),
          if (widget.onCompose != null)
            TextButton.icon(
              onPressed: widget.onCompose,
              icon: const Icon(Icons.edit_outlined),
              label: Text(compose),
            ),
        ],
      ),
    );
  }
}

/// Embeddable settings content. The parent supplies the scroll view and route.
class PetdexSettings extends StatefulWidget {
  const PetdexSettings({
    super.key,
    required this.controller,
    this.pickDraft = PetDraft.pick,
  });
  final PetdexController controller;
  final Future<PetDraft?> Function() pickDraft;
  @override
  State<PetdexSettings> createState() => _PetdexSettingsState();
}

class _PetdexSettingsState extends State<PetdexSettings> {
  PetDraft? _pending;
  bool _busy = false;
  String? _error;
  @override
  void didUpdateWidget(PetdexSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _pending = null;
      _busy = false;
      _error = null;
    }
  }

  Future<void> _run(
    Future<void> Function() action, {
    bool picking = false,
  }) async {
    if (_busy) return;
    final owner = widget.controller;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (_) {
      if (!mounted || owner != widget.controller) return;
      _error = picking
          ? context.sharedL10n.appearance_pet_image_failed
          : context.sharedL10n.appearance_save_failed;
    } finally {
      if (mounted && owner == widget.controller) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile.adaptive(
            key: const ValueKey('presentation-pet-enabled'),
            contentPadding: EdgeInsets.zero,
            title: Text(context.sharedL10n.appearance_pet_companion),
            subtitle: Text(context.sharedL10n.appearance_pet_companion_hint),
            value: c.enabled,
            onChanged: _busy ? null : (v) => _run(() => c.setEnabled(v)),
          ),
          Text(
            context.sharedL10n.appearance_adopt_a_companion,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final pet in PetSpecies.values)
                if (pet != PetSpecies.hatchling || c.hasHatch)
                  ChoiceChip(
                    avatar: _art(context, pet, c._state.draft, 22),
                    label: Text(_name(context, pet)),
                    selected: c.enabled && c.species == pet,
                    onSelected: _busy ? null : (_) => _run(() => c.adopt(pet)),
                  ),
            ],
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(context.sharedL10n.appearance_roam_when_idle),
            value: c.roaming,
            onChanged: _busy ? null : (v) => _run(() => c.setRoaming(v)),
          ),
          Text(
            context.sharedL10n.appearance_pet_size,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final size in PetSize.values)
                ChoiceChip(
                  label: Text(_sizeName(context, size)),
                  selected: c.size == size,
                  onSelected: _busy ? null : (_) => _run(() => c.setSize(size)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.sharedL10n.appearance_hatch_from_a_local_picture,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(context.sharedL10n.appearance_pet_image_limits),
          if (_pending == null)
            OutlinedButton.icon(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(context.sharedL10n.appearance_choose_picture),
              onPressed: _busy
                  ? null
                  : () => _run(() async {
                      final picked = await widget.pickDraft();
                      if (mounted && widget.controller == c && picked != null) {
                        _pending = picked;
                      }
                    }, picking: true),
            ),
          if (_pending case final draft?) ...[
            Semantics(
              image: true,
              label: context.sharedL10n.appearance_hatchling_preview,
              child: _art(context, PetSpecies.hatchling, draft, 72),
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                          await c.hatch(draft);
                          if (mounted && widget.controller == c) {
                            _pending = null;
                          }
                        }),
                  child: Text(context.sharedL10n.appearance_hatch_and_adopt),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _pending = null),
                  child: Text(context.sharedL10n.appearance_discard_draft),
                ),
              ],
            ),
          ],
          if (c.hasHatch)
            TextButton(
              onPressed: _busy ? null : () => _run(c.forgetHatch),
              child: Text(context.sharedL10n.appearance_forget_saved_hatchling),
            ),
          if (_error case final message?)
            Semantics(
              liveRegion: true,
              child: Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
