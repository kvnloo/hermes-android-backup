import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/remote_workspace.dart';
import '../theme/hermes_theme.dart';
import '../workspace/profile_presentation.dart' show profileColor;

// Bot Mode's New Bot and Edit Profile forms and the avatar they edit, after
// Hermes Desktop b7ee21c14e (apps/desktop/src/plugins/hermes-bots:
// create-dialog.tsx, edit-profile-dialog.tsx, avatar-picker.tsx, avatar.tsx).
// The forms never talk to the gateway: the bots screen sends every request
// on the connection it is bound to and drops a reply that outlives it.

/// Desktop's classic avatar shapes (`AVATAR_SHAPES`), the default-shape set.
const botAvatarShapes = [
  'circle',
  'squircle',
  'pill',
  'triangle',
  'hexagon',
  'cloud',
  'drop',
];

/// The picker's shapes (`AVATAR_PICKER_SHAPES`).
const botAvatarPickerShapes = [
  'circle',
  'blob',
  'squircle',
  'pill',
  'triangle',
  'hexagon',
  'cloud',
  'drop',
];

/// Desktop's `PROFILE_SWATCHES`: twelve hues at the profile palette's
/// saturation and lightness, in Desktop's spelling so both apps recognise
/// the selected swatch.
final botAvatarSwatches = [
  for (var i = 0; i < 12; i++) 'hsl(${i * 30} 68% 58%)',
];

int _hash(String value) {
  var hash = 0;
  for (final unit in value.codeUnits) {
    hash = (hash * 31 + unit).toUnsigned(32);
  }
  return hash;
}

/// `defaultShapeFor`: the shape a bot has until someone picks one.
String botDefaultShape(String name) {
  var hash = 0;
  for (final rune in name.runes) {
    hash = (hash * 31 + String.fromCharCode(rune).codeUnitAt(0)).toUnsigned(32);
  }
  return botAvatarShapes[hash % botAvatarShapes.length];
}

Color _hsl(double hue, double saturation, double lightness) =>
    HSLColor.fromAHSL(1, hue % 360, saturation, lightness).toColor();

/// The primary bot's fixed violet (Desktop's `PRIMARY_AVATAR_COLOR`).
final _primaryColor = _hsl(258, .90, .66);

/// A stored avatar colour (`hsl(h s% l%)` or `#rrggbb`), else the name's own
/// hue (`profileColor`), else the primary violet.
Color botAvatarColor(String? css, String name) {
  final parsed = _parseCss(css);
  if (parsed != null) return parsed;
  final key = name.trim();
  if (key.isEmpty || key == 'default') return _primaryColor;
  return _hsl((_hash(key) % 360).toDouble(), .68, .58);
}

Color? _parseCss(String? css) {
  if (css == null) return null;
  final value = css.trim();
  final hex = profileColor(value);
  if (hex != null) return hex;
  final match = RegExp(
    r'^hsla?\(\s*(-?[\d.]+)(?:deg)?[\s,]+([\d.]+)%[\s,]+([\d.]+)%',
  ).firstMatch(value);
  if (match == null) return null;
  final h = double.tryParse(match[1]!);
  final s = double.tryParse(match[2]!);
  final l = double.tryParse(match[3]!);
  if (h == null || s == null || l == null) return null;
  return _hsl(h, (s / 100).clamp(0, 1), (l / 100).clamp(0, 1));
}

/// What a bot looks like: Desktop's `botAppearance`.
({String shape, String? color}) botAppearance(
  String name,
  Map<String, dynamic> look,
) {
  final shape = look['shape'];
  final color = look['color'];
  if (name.trim().toLowerCase() == 'default' && look['custom'] != true) {
    return (shape: 'squircle', color: null);
  }
  return (
    shape: shape is String && shape.isNotEmpty ? shape : botDefaultShape(name),
    color: color is String && color.isNotEmpty ? color : null,
  );
}

/// A bot's face: its shape in its colour with two eyes, or its picture
/// clipped to the shape.
class BotFace extends StatelessWidget {
  const BotFace({
    super.key,
    required this.name,
    required this.shape,
    this.color,
    this.image,
    this.size = 40,
  });

  final String name;
  final String shape;
  final String? color;
  final Uint8List? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fill = botAvatarColor(color, name);
    final bytes = image;
    return SizedBox.square(
      dimension: size,
      child: bytes != null
          ? ClipPath(
              clipper: _ShapeClipper(shape),
              child: Image.memory(
                bytes,
                width: size,
                height: size,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                cacheWidth: (size * 3).round(),
              ),
            )
          : CustomPaint(painter: _FacePainter(shape, fill)),
    );
  }
}

Path botShapePath(String shape, Size size) {
  final w = size.width, h = size.height;
  Offset p(double x, double y) => Offset(x * w, y * h);
  final path = Path();
  switch (shape) {
    case 'circle':
      path.addOval(Offset.zero & size);
    case 'squircle':
      path.addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(w * .3)),
      );
    case 'pill':
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(w * .16, 0, w * .84, h),
          Radius.circular(w * .34),
        ),
      );
    case 'triangle':
      path
        ..moveTo(p(.5, .04).dx, p(.5, .04).dy)
        ..lineTo(p(.97, .92).dx, p(.97, .92).dy)
        ..lineTo(p(.03, .92).dx, p(.03, .92).dy)
        ..close();
    case 'hexagon':
      for (var i = 0; i < 6; i++) {
        final a = math.pi / 3 * i - math.pi / 2;
        final pt = p(.5 + .5 * math.cos(a), .5 + .5 * math.sin(a));
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      path.close();
    case 'cloud':
      path
        ..addOval(Rect.fromLTRB(0, h * .3, w * .55, h * .85))
        ..addOval(Rect.fromLTRB(w * .2, h * .1, w * .8, h * .7))
        ..addOval(Rect.fromLTRB(w * .45, h * .3, w, h * .85))
        ..addRect(Rect.fromLTRB(w * .2, h * .5, w * .8, h * .85));
    case 'drop':
      path
        ..moveTo(p(.5, 0).dx, p(.5, 0).dy)
        ..cubicTo(w * .8, h * .3, w, h * .5, w, h * .66)
        ..arcToPoint(p(0, .66), radius: Radius.circular(w * .5))
        ..cubicTo(0, h * .5, w * .2, h * .3, w * .5, 0)
        ..close();
    default:
      // 'blob' and Desktop's generated blob faces ('blobatar…').
      path
        ..moveTo(p(.5, .02).dx, p(.5, .02).dy)
        ..cubicTo(w * .85, 0, w * 1.02, h * .3, w * .96, h * .56)
        ..cubicTo(w * .9, h * .86, w * .66, h, w * .44, h * .97)
        ..cubicTo(w * .16, h * .94, 0, h * .72, w * .03, h * .44)
        ..cubicTo(w * .06, h * .16, w * .26, h * .04, w * .5, h * .02)
        ..close();
  }
  return path;
}

class _ShapeClipper extends CustomClipper<Path> {
  const _ShapeClipper(this.shape);
  final String shape;
  @override
  Path getClip(Size size) => botShapePath(shape, size);
  @override
  bool shouldReclip(_ShapeClipper old) => old.shape != shape;
}

class _FacePainter extends CustomPainter {
  const _FacePainter(this.shape, this.fill);
  final String shape;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(botShapePath(shape, size), Paint()..color = fill);
    // Eyes in a shade of the face that reads on it.
    final hsl = HSLColor.fromColor(fill);
    final ink = hsl
        .withLightness(fill.computeLuminance() > .35 ? .14 : .95)
        .toColor();
    final eye = Paint()..color = ink;
    final r = size.width * .07;
    canvas
      ..drawCircle(Offset(size.width * .37, size.height * .5), r, eye)
      ..drawCircle(Offset(size.width * .63, size.height * .5), r, eye);
  }

  @override
  bool shouldRepaint(_FacePainter old) =>
      old.shape != shape || old.fill != fill;
}

/// An avatar picked from the device was over Desktop's 15 MB limit.
class BotAvatarTooLarge implements Exception {
  const BotAvatarTooLarge();
}

/// Desktop's upload limit for a bot picture (avatar-picker.tsx).
const botAvatarMaxBytes = 15000000;

/// Desktop's upload path: pick a PNG, JPEG, WebP or GIF (at most 15 MB) and
/// reduce it to a 256 px square PNG data URL (`normalizeAvatarImage`). The
/// picker hands back a path, not the bytes, so a file over the limit is
/// refused before anything is read.
Future<String?> pickBotAvatarImage() async {
  final picked = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['png', 'jpg', 'jpeg', 'webp', 'gif'],
    withData: false,
  );
  final file = picked?.files.singleOrNull;
  if (file == null) return null;
  final bytes = await readBotAvatarFile(file);
  if (bytes == null) return null;
  return normalizeBotAvatar(bytes);
}

/// The bytes of a picked picture, read only once its size is known to be
/// within [botAvatarMaxBytes]: the picker's own size first, then the file's
/// length on disk (the picker reports 0 when it does not know). Throws
/// [BotAvatarTooLarge] before reading anything bigger.
Future<Uint8List?> readBotAvatarFile(PlatformFile file) async {
  if (file.size > botAvatarMaxBytes) throw const BotAvatarTooLarge();
  final path = file.path;
  if (path == null) {
    // No file to stat (the picker already holds the bytes).
    final bytes = file.bytes;
    if (bytes != null && bytes.length > botAvatarMaxBytes) {
      throw const BotAvatarTooLarge();
    }
    return bytes;
  }
  final handle = File(path);
  if (await handle.length() > botAvatarMaxBytes) {
    throw const BotAvatarTooLarge();
  }
  final bytes = await handle.readAsBytes();
  // It may have grown in between.
  if (bytes.length > botAvatarMaxBytes) throw const BotAvatarTooLarge();
  return bytes;
}

/// The size a [width] x [height] picture is decoded at for an [edge] px
/// avatar: its short side brought down to [edge] (never up) and its long
/// side in proportion, but at most eight times [edge]. A picture of huge
/// dimensions (a few kilobytes of PNG can claim 40000 x 40000) is never
/// decoded at full size.
({int width, int height}) botAvatarDecodeSize(
  int width,
  int height, {
  int edge = 256,
}) {
  final short = math.min(width, height);
  final scale = short > edge ? edge / short : 1.0;
  int fit(int side) => math.max(1, math.min((side * scale).round(), edge * 8));
  return (width: fit(width), height: fit(height));
}

/// Crops [bytes] to its centred square and returns it as an [edge] px PNG
/// data URL, or null when it is not a picture. The picture is decoded at
/// [botAvatarDecodeSize] of the size its header gives; [onDecoded] is told
/// the decoded size.
Future<String?> normalizeBotAvatar(
  Uint8List bytes, {
  int edge = 256,
  @visibleForTesting void Function(int width, int height)? onDecoded,
}) async {
  ui.ImageDescriptor? descriptor;
  ui.Codec? codec;
  ui.Image? source;
  ui.Image? out;
  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    try {
      // Reads the header: the picture's size, before any pixel is decoded.
      descriptor = await ui.ImageDescriptor.encoded(buffer);
    } finally {
      // The descriptor keeps what it needs.
      buffer.dispose();
    }
    final width = descriptor.width;
    final height = descriptor.height;
    final size = botAvatarDecodeSize(width, height, edge: edge);
    codec = await descriptor.instantiateCodec(
      targetWidth: size.width,
      targetHeight: size.height,
    );
    source = (await codec.getNextFrame()).image;
    onDecoded?.call(source.width, source.height);
    if (width <= 0 || height <= 0) return null;
    // The original's centred square, in the decoded picture's pixels.
    final sx = source.width / width;
    final sy = source.height / height;
    final side = math.min(width, height).toDouble();
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(
      source,
      Rect.fromLTWH(
        (width - side) / 2 * sx,
        (height - side) / 2 * sy,
        side * sx,
        side * sy,
      ),
      Rect.fromLTWH(0, 0, edge.toDouble(), edge.toDouble()),
      Paint()..filterQuality = FilterQuality.medium,
    );
    out = await recorder.endRecording().toImage(edge, edge);
    final png = await out.toByteData(format: ui.ImageByteFormat.png);
    if (png == null) return null;
    return 'data:image/png;base64,${base64Encode(png.buffer.asUint8List())}';
  } catch (_) {
    return null;
  } finally {
    source?.dispose();
    out?.dispose();
    codec?.dispose();
    descriptor?.dispose();
  }
}

/// The avatar editor shared by New Bot and Edit Profile: shape grid, colour
/// swatches, and an uploaded picture (Desktop's Bot and Upload tabs).
class BotAvatarPicker extends StatelessWidget {
  const BotAvatarPicker({
    super.key,
    required this.name,
    required this.shape,
    required this.color,
    required this.image,
    required this.onShape,
    required this.onColor,
    required this.onImage,
    required this.onUpload,
    this.uploadError,
  });

  final String name;
  final String shape;
  final String? color;
  final Uint8List? image;
  final ValueChanged<String> onShape;
  final ValueChanged<String?> onColor;
  final ValueChanged<String?> onImage;
  final VoidCallback onUpload;
  final String? uploadError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final scheme = Theme.of(context).colorScheme;
    final tokens = HermesTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: BotFace(
            name: name,
            shape: shape,
            color: color,
            image: image,
            size: 64,
          ),
        ),
        const SizedBox(height: 12),
        Text(l10n.ng_bots_avatar_shape, style: TextStyle(color: tokens.muted)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final (i, s) in botAvatarPickerShapes.indexed)
              Semantics(
                selected: s == shape && image == null,
                button: true,
                label: l10n.ng_bots_avatar_shape_n(i + 1),
                child: InkWell(
                  key: Key('bots-avatar-shape-$s'),
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    onImage(null);
                    onShape(s);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: s == shape && image == null
                            ? scheme.primary
                            : scheme.outlineVariant,
                        width: s == shape && image == null ? 2 : 1,
                      ),
                    ),
                    child: BotFace(
                      name: name,
                      shape: s,
                      color: color,
                      size: 30,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(l10n.ng_bots_avatar_colour, style: TextStyle(color: tokens.muted)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final (i, swatch) in botAvatarSwatches.indexed)
              Semantics(
                selected: swatch == color,
                button: true,
                label: l10n.ng_bots_avatar_colour_n(i + 1),
                child: InkWell(
                  key: Key('bots-avatar-colour-$i'),
                  customBorder: const CircleBorder(),
                  onTap: () => onColor(swatch),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: botAvatarColor(swatch, name),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: swatch == color
                            ? scheme.onSurface
                            : scheme.outlineVariant,
                        width: swatch == color ? 2.5 : 1,
                      ),
                    ),
                  ),
                ),
              ),
            TextButton(
              key: const Key('bots-avatar-colour-auto'),
              onPressed: color == null ? null : () => onColor(null),
              child: Text(l10n.ng_bots_avatar_match_name),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            OutlinedButton.icon(
              key: const Key('bots-avatar-upload'),
              icon: const Icon(Icons.image_outlined),
              label: Text(l10n.ng_bots_avatar_upload),
              onPressed: onUpload,
            ),
            if (image != null)
              TextButton(
                key: const Key('bots-avatar-remove'),
                onPressed: () => onImage(null),
                child: Text(l10n.ng_bots_avatar_remove),
              ),
          ],
        ),
        if (uploadError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              uploadError!,
              key: const Key('bots-avatar-error'),
              style: TextStyle(color: scheme.error),
            ),
          ),
      ],
    );
  }
}

/// How a form's submission ended, as the bots screen reports it.
sealed class BotFormResult {
  const BotFormResult();
}

/// Saved: the form closes.
final class BotFormDone extends BotFormResult {
  const BotFormDone();
}

/// The connection changed while the request was out: its reply was dropped
/// and the form closes without reporting anything.
final class BotFormDropped extends BotFormResult {
  const BotFormDropped();
}

/// Refused or partly failed: shown in the form, which stays open.
final class BotFormFailed extends BotFormResult {
  const BotFormFailed(this.message);
  final String message;
}

/// What New Bot sends: Desktop's `profiles.create` fields, then the look.
class BotCreateDraft {
  const BotCreateDraft({
    required this.name,
    required this.title,
    required this.description,
    required this.cloneFrom,
    required this.noSkills,
    required this.shareAuth,
    required this.soul,
    required this.provider,
    required this.model,
    required this.look,
    required this.image,
  });

  final String name;
  final String title;
  final String description;
  final String? cloneFrom;
  final bool noSkills;
  final bool shareAuth;
  final String soul;
  final String provider;
  final String model;
  final Map<String, dynamic> look;
  final String? image;
}

/// What Edit Profile saves: only what changed since it opened (Desktop's
/// `editedLook` and dirty sections). Null fields are left as they are.
class BotProfileEdit {
  const BotProfileEdit({
    this.look,
    this.lookRemove = const {},
    this.imageChanged = false,
    this.image,
    this.description,
    this.soul,
    this.provider,
    this.model,
    this.disabledSkills,
    this.enabledToolsets,
    this.enabledMcpServers,
  });

  /// The look fields to write over the bot's record, or null.
  final Map<String, dynamic>? look;

  /// Look fields to drop (a colour reset to the name's own).
  final Set<String> lookRemove;
  final bool imageChanged;

  /// The new picture as a data URL; null with [imageChanged] clears it.
  final String? image;
  final String? description;
  final String? soul;
  final String? provider;
  final String? model;
  final List<String>? disabledSkills;
  final List<String>? enabledToolsets;
  final List<String>? enabledMcpServers;

  bool get advanced =>
      soul != null ||
      model != null ||
      disabledSkills != null ||
      enabledToolsets != null ||
      enabledMcpServers != null;
}

/// Desktop's Edit Profile (edit-profile-dialog.tsx): avatar, title,
/// description, and the Advanced section (model, SOUL.md, skills, toolsets,
/// MCP servers) read from `profiles.describe` when it is opened.
class BotEditForm extends StatefulWidget {
  const BotEditForm({
    super.key,
    required this.bot,
    required this.image,
    required this.loadAdvanced,
    required this.confirm,
    required this.onSubmit,
    this.pickImage = pickBotAvatarImage,
  });

  final BotRosterProfile bot;

  /// The bot's stored picture as a data URL, if it has one.
  final String? image;
  final Future<BotProfileDescription> Function() loadAdvanced;
  final Future<bool> Function(String title, String message, String ok) confirm;
  final Future<BotFormResult> Function(BotProfileEdit edit) onSubmit;
  final Future<String?> Function() pickImage;

  @override
  State<BotEditForm> createState() => _BotEditFormState();
}

class _BotEditFormState extends State<BotEditForm> {
  late final ({String shape, String? color}) _opened = botAppearance(
    widget.bot.name,
    widget.bot.look,
  );
  late final String _openedTitle = widget.bot.look['title'] is String
      ? (widget.bot.look['title'] as String).trim()
      : '';
  late String _shape = _opened.shape;
  late String? _color = _opened.color;
  late String? _image = widget.image;
  late Uint8List? _imageBytes = DisplayThumbnail.decode(widget.image);
  late final _title = TextEditingController(text: _openedTitle);
  late final _description = TextEditingController(text: widget.bot.description);
  final _provider = TextEditingController();
  final _model = TextEditingController();
  final _soul = TextEditingController();
  BotProfileDescription? _loaded;
  bool _loading = false;
  String? _loadError;
  List<BotProfileToggle> _skills = const [];
  List<BotProfileToggle> _toolsets = const [];
  List<BotProfileToggle> _mcp = const [];
  bool _busy = false;
  String? _error;
  String? _uploadError;

  @override
  void initState() {
    super.initState();
    for (final c in [_provider, _model]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_title, _description, _provider, _model, _soul]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadAdvancedOnce() async {
    if (_loaded != null || _loading) return;
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final d = await widget.loadAdvanced();
      if (!mounted) return;
      setState(() {
        _loaded = d;
        _loading = false;
        _provider.text = d.provider;
        _model.text = d.model;
        _soul.text = d.soul;
        _skills = d.skills;
        _toolsets = d.toolsets;
        _mcp = d.mcpServers;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e is BotProfileRefusal
            ? e.message
            : context.sharedL10n.ng_bots_advanced_failed(
                e is WorkspaceException ? e.reason.name : '$e',
              );
      });
    }
  }

  Future<void> _upload() async {
    try {
      final image = await widget.pickImage();
      if (!mounted || image == null) return;
      final bytes = DisplayThumbnail.decode(image);
      setState(() {
        _uploadError = bytes == null
            ? context.sharedL10n.ng_bots_avatar_unreadable
            : null;
        if (bytes != null) {
          _image = image;
          _imageBytes = bytes;
        }
      });
    } on BotAvatarTooLarge {
      if (mounted) {
        setState(
          () => _uploadError = context.sharedL10n.ng_bots_avatar_too_large,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _uploadError = context.sharedL10n.ng_bots_avatar_unreadable,
        );
      }
    }
  }

  bool _differs(List<BotProfileToggle> now, List<BotProfileToggle> was) {
    final before = {for (final t in was) t.name: t.enabled};
    return now.any((t) => before[t.name] != t.enabled);
  }

  int _turnedOff(List<BotProfileToggle> now, List<BotProfileToggle> was) {
    final before = {for (final t in was) t.name: t.enabled};
    return now.where((t) => before[t.name] == true && !t.enabled).length;
  }

  bool get _modelDirty {
    final d = _loaded;
    return d != null &&
        (_provider.text.trim() != d.provider.trim() ||
            _model.text.trim() != d.model.trim());
  }

  bool get _modelPairBroken =>
      _modelDirty &&
      (_provider.text.trim().isEmpty || _model.text.trim().isEmpty);

  BotProfileEdit _edit() {
    final look = <String, dynamic>{};
    final remove = <String>{};
    if (_shape != _opened.shape) look['shape'] = _shape;
    if (_color != _opened.color) {
      if (_color == null) {
        remove.add('color');
      } else {
        look['color'] = _color;
      }
    }
    final imageChanged = _image != widget.image;
    if (imageChanged) look['imageKind'] = _image != null ? 'photo' : 'shape';
    if (look.isNotEmpty || remove.isNotEmpty) look['custom'] = true;
    if (_title.text.trim() != _openedTitle) look['title'] = _title.text.trim();
    final d = _loaded;
    final description = _description.text.trim();
    List<String>? toolsets;
    if (d != null && _differs(_toolsets, d.toolsets)) {
      final on = [
        for (final t in _toolsets)
          if (t.enabled) t.name,
      ];
      // All (or none) checked clears the pin: the default toolsets apply.
      toolsets = on.length == _toolsets.length || on.isEmpty ? const [] : on;
    }
    return BotProfileEdit(
      look: look.isEmpty ? null : look,
      lookRemove: remove,
      imageChanged: imageChanged,
      image: _image,
      description: description != widget.bot.description.trim()
          ? description
          : null,
      soul: d != null && _soul.text != d.soul ? _soul.text : null,
      provider: _modelDirty ? _provider.text.trim() : null,
      model: _modelDirty ? _model.text.trim() : null,
      disabledSkills: d != null && _differs(_skills, d.skills)
          ? [
              for (final s in _skills)
                if (!s.enabled) s.name,
            ]
          : null,
      enabledToolsets: toolsets,
      enabledMcpServers: d != null && _differs(_mcp, d.mcpServers)
          ? [
              for (final m in _mcp)
                if (m.enabled) m.name,
            ]
          : null,
    );
  }

  Future<void> _submit() async {
    if (_busy || _modelPairBroken) return;
    final l10n = context.sharedL10n;
    final edit = _edit();
    final d = _loaded;
    final destructive = [
      if (edit.imageChanged && edit.image == null && widget.image != null)
        l10n.ng_bots_change_remove_image,
      if (edit.soul != null) l10n.ng_bots_change_soul,
      if (d != null)
        if (_turnedOff(_skills, d.skills) +
                _turnedOff(_toolsets, d.toolsets) +
                _turnedOff(_mcp, d.mcpServers)
            case final off when off > 0)
          l10n.ng_bots_change_turn_off(off),
    ];
    if (destructive.isNotEmpty) {
      final ok = await widget.confirm(
        l10n.ng_bots_confirm_changes_title,
        destructive.map((line) => '• $line').join('\n'),
        l10n.save,
      );
      if (!ok || !mounted) return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await widget.onSubmit(edit);
    if (!mounted) return;
    switch (result) {
      case BotFormDone() || BotFormDropped():
        Navigator.of(context).pop();
      case BotFormFailed(:final message):
        setState(() {
          _busy = false;
          _error = message;
        });
    }
  }

  Widget _toggles(
    String heading,
    String keyPrefix,
    List<BotProfileToggle> items,
    ValueChanged<List<BotProfileToggle>> onChanged, {
    String? hint,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _gap(),
        Text(heading, style: Theme.of(context).textTheme.titleSmall),
        if (hint != null)
          Text(hint, style: TextStyle(color: HermesTokens.of(context).muted)),
        for (final (i, item) in items.indexed)
          SwitchListTile(
            key: Key('$keyPrefix-${item.name}'),
            contentPadding: EdgeInsets.zero,
            value: item.enabled,
            title: Text(item.label.isNotEmpty ? item.label : item.name),
            subtitle: item.detail.isEmpty ? null : Text(item.detail),
            onChanged: _busy
                ? null
                : (on) => onChanged([...items]..[i] = item.withEnabled(on)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final bot = widget.bot;
    return _FormFrame(
      title: l10n.ng_bots_edit_profile,
      busy: _busy,
      children: [
        Text(l10n.ng_bots_edit_description(bot.title, bot.name)),
        _gap(),
        BotAvatarPicker(
          name: bot.name,
          shape: _shape,
          color: _color,
          image: _imageBytes,
          onShape: (s) => setState(() => _shape = s),
          onColor: (c) => setState(() => _color = c),
          onImage: (i) => setState(() {
            _image = i;
            _imageBytes = DisplayThumbnail.decode(i);
          }),
          onUpload: () => unawaited(_upload()),
          uploadError: _uploadError,
        ),
        _gap(),
        TextField(
          key: const Key('bots-edit-title'),
          controller: _title,
          enabled: !_busy,
          decoration: InputDecoration(
            labelText: l10n.ng_bots_field_title,
            hintText: bot.title,
            border: const OutlineInputBorder(),
          ),
        ),
        _gap(),
        TextField(
          key: const Key('bots-edit-description'),
          controller: _description,
          enabled: !_busy,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: l10n.ng_bots_field_description,
            hintText: l10n.ng_bots_description_hint,
            border: const OutlineInputBorder(),
          ),
        ),
        _gap(),
        ExpansionTile(
          key: const Key('bots-edit-advanced'),
          tilePadding: EdgeInsets.zero,
          title: Text(l10n.ng_bots_advanced),
          onExpansionChanged: (open) {
            if (open) unawaited(_loadAdvancedOnce());
          },
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: [
            if (_loading) const LinearProgressIndicator(),
            _inlineError(context, _loadError, 'bots-edit-advanced-error'),
            if (_loaded != null) ...[
              TextField(
                key: const Key('bots-edit-provider'),
                controller: _provider,
                enabled: !_busy,
                decoration: InputDecoration(
                  labelText: l10n.ng_bots_provider,
                  border: const OutlineInputBorder(),
                ),
              ),
              _gap(),
              TextField(
                key: const Key('bots-edit-model'),
                controller: _model,
                enabled: !_busy,
                decoration: InputDecoration(
                  labelText: l10n.ng_bots_model,
                  border: const OutlineInputBorder(),
                  errorText: _modelPairBroken ? l10n.ng_bots_model_pair : null,
                  errorMaxLines: 3,
                ),
              ),
              _gap(),
              TextField(
                key: const Key('bots-edit-soul'),
                controller: _soul,
                enabled: !_busy,
                minLines: 3,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: l10n.ng_bots_soul_edit,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              _toggles(
                l10n.ng_bots_skills,
                'bots-edit-skill',
                _skills,
                (v) => setState(() => _skills = v),
              ),
              _toggles(
                l10n.ng_bots_toolsets,
                'bots-edit-toolset',
                _toolsets,
                (v) => setState(() => _toolsets = v),
                hint: l10n.ng_bots_toolsets_hint,
              ),
              _toggles(
                l10n.ng_bots_mcp_servers,
                'bots-edit-mcp',
                _mcp,
                (v) => setState(() => _mcp = v),
              ),
            ],
          ],
        ),
        _inlineError(context, _error, 'bots-form-error'),
        _gap(),
        FilledButton(
          key: const Key('bots-form-save'),
          onPressed: _busy || _modelPairBroken
              ? null
              : () => unawaited(_submit()),
          child: Text(_busy ? l10n.ng_bots_saving : l10n.save),
        ),
      ],
    );
  }
}

/// Desktop's `composeSoul` without a custom SOUL: the persona New Bot writes.
/// The teammate-messaging protocol is the gateway's to inject
/// (`bot_mode_protocol`), never appended here.
String botComposeSoul({
  required String name,
  required String title,
  required String description,
  required String customSoul,
}) {
  if (customSoul.trim().isNotEmpty) return customSoul;
  final shown = title.isNotEmpty ? title : name;
  return [
    '# $shown',
    '',
    if (title.isNotEmpty) '**Role:** $title',
    if (description.isNotEmpty) '**Mission:** $description',
    '',
    'You are $shown, a persistent named agent (profile `$name`) on this machine.',
    'You keep your own memory, skills, and conversation history across sessions.',
  ].join('\n');
}

/// Shows a bot form: a pushed full-screen route below 480 px, a dialog
/// otherwise.
Future<void> showBotForm(BuildContext context, Widget form) {
  if (MediaQuery.sizeOf(context).width < 480) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => form),
    );
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final height = MediaQuery.sizeOf(ctx).height;
      return Dialog(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 560,
          height: math.min(780, height * .9),
          child: form,
        ),
      );
    },
  );
}

class _FormFrame extends StatelessWidget {
  const _FormFrame({
    required this.title,
    required this.busy,
    required this.children,
  });

  final String title;
  final bool busy;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          key: const Key('bots-form-cancel'),
          tooltip: context.sharedL10n.cancel,
          icon: const Icon(Icons.close),
          onPressed: busy ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(title),
      ),
      // Every field is built (not a lazy list): an off-screen field keeps its
      // state, and focusing one scrolls it above the keyboard.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

Widget _inlineError(BuildContext context, String? message, String key) =>
    message == null
    ? const SizedBox.shrink()
    : Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          message,
          key: Key(key),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );

Widget _gap() => const SizedBox(height: 12);

/// Desktop's New Bot dialog (create-dialog.tsx). The profile is created on
/// Create, never before: Cancel sends nothing.
class BotCreateForm extends StatefulWidget {
  const BotCreateForm({
    super.key,
    required this.roster,
    required this.onSubmit,
    this.pickImage = pickBotAvatarImage,
  });

  /// The connection's bots: their names are taken, and any can be cloned.
  final List<BotRosterProfile> roster;
  final Future<BotFormResult> Function(BotCreateDraft draft) onSubmit;
  final Future<String?> Function() pickImage;

  @override
  State<BotCreateForm> createState() => _BotCreateFormState();
}

const _freshProfile = '__none__';

class _BotCreateFormState extends State<BotCreateForm> {
  final _name = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _provider = TextEditingController();
  final _model = TextEditingController();
  final _soul = TextEditingController();
  String? _shape;
  String? _color;
  String? _image;
  Uint8List? _imageBytes;
  String _cloneFrom = 'default';
  bool _noSkills = false;
  bool _shareAuth = true;
  bool _busy = false;
  String? _error;
  String? _uploadError;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _title, _provider, _model]) {
      c.addListener(_changed);
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in [_name, _title, _description, _provider, _model, _soul]) {
      c.dispose();
    }
    super.dispose();
  }

  ({String slug, String title}) get _identity =>
      botProfileIdentity(_name.text, _title.text);

  bool get _taken => widget.roster.any((bot) => bot.name == _identity.slug);

  bool get _modelPairBroken =>
      _provider.text.trim().isEmpty != _model.text.trim().isEmpty;

  bool get _valid {
    final slug = _identity.slug;
    return slug.isNotEmpty &&
        botProfileIdPattern.hasMatch(slug) &&
        !_taken &&
        !_modelPairBroken;
  }

  Future<void> _upload() async {
    try {
      final image = await widget.pickImage();
      if (!mounted || image == null) return;
      final bytes = DisplayThumbnail.decode(image);
      setState(() {
        _uploadError = bytes == null
            ? context.sharedL10n.ng_bots_avatar_unreadable
            : null;
        if (bytes != null) {
          _image = image;
          _imageBytes = bytes;
        }
      });
    } on BotAvatarTooLarge {
      if (mounted) {
        setState(
          () => _uploadError = context.sharedL10n.ng_bots_avatar_too_large,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _uploadError = context.sharedL10n.ng_bots_avatar_unreadable,
        );
      }
    }
  }

  Future<void> _submit() async {
    if (_busy || !_valid) return;
    final identity = _identity;
    final description = _description.text.trim();
    final draft = BotCreateDraft(
      name: identity.slug,
      title: identity.title,
      description: [
        identity.title,
        description,
      ].where((s) => s.isNotEmpty).join(' — '),
      cloneFrom: _cloneFrom == _freshProfile ? null : _cloneFrom,
      noSkills: _noSkills,
      shareAuth: _shareAuth,
      soul: botComposeSoul(
        name: identity.slug,
        title: identity.title,
        description: description,
        customSoul: _soul.text,
      ),
      provider: _provider.text.trim(),
      model: _model.text.trim(),
      look: {
        'shape': _shape ?? botDefaultShape(identity.slug),
        'color': ?_color,
        'imageKind': _image != null ? 'photo' : 'shape',
        'title': identity.title,
        'created': DateTime.now().millisecondsSinceEpoch,
      },
      image: _image,
    );
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await widget.onSubmit(draft);
    if (!mounted) return;
    switch (result) {
      case BotFormDone() || BotFormDropped():
        Navigator.of(context).pop();
      case BotFormFailed(:final message):
        setState(() {
          _busy = false;
          _error = message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final identity = _identity;
    final slug = identity.slug;
    final typed = _name.text.trim().isNotEmpty;
    final nameError = !typed
        ? null
        : slug.isEmpty || !botProfileIdPattern.hasMatch(slug)
        ? l10n.ng_bots_name_invalid
        : _taken
        ? l10n.ng_bots_name_taken(slug)
        : null;
    final pickerName = slug.isEmpty ? 'agent' : slug;
    return _FormFrame(
      title: l10n.ng_bots_new_bot,
      busy: _busy,
      children: [
        Text(l10n.ng_bots_new_bot_hint),
        _gap(),
        TextField(
          key: const Key('bots-new-name'),
          controller: _name,
          enabled: !_busy,
          decoration: InputDecoration(
            labelText: l10n.ng_bots_field_name,
            hintText: 'research-buddy',
            border: const OutlineInputBorder(),
            errorText: nameError,
            errorMaxLines: 4,
            helperText: typed && nameError == null
                ? l10n.ng_bots_profile_id(slug)
                : null,
            helperMaxLines: 2,
          ),
        ),
        _gap(),
        TextField(
          key: const Key('bots-new-title'),
          controller: _title,
          enabled: !_busy,
          decoration: InputDecoration(
            labelText: l10n.ng_bots_field_title,
            border: const OutlineInputBorder(),
          ),
        ),
        _gap(),
        TextField(
          key: const Key('bots-new-description'),
          controller: _description,
          enabled: !_busy,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: l10n.ng_bots_field_description,
            hintText: l10n.ng_bots_description_hint,
            border: const OutlineInputBorder(),
          ),
        ),
        _gap(),
        BotAvatarPicker(
          name: pickerName,
          shape: _shape ?? botDefaultShape(pickerName),
          color: _color,
          image: _imageBytes,
          onShape: (s) => setState(() => _shape = s),
          onColor: (c) => setState(() => _color = c),
          onImage: (i) => setState(() {
            _image = i;
            _imageBytes = i == null ? null : DisplayThumbnail.decode(i);
          }),
          onUpload: () => unawaited(_upload()),
          uploadError: _uploadError,
        ),
        _gap(),
        ExpansionTile(
          key: const Key('bots-new-advanced'),
          tilePadding: EdgeInsets.zero,
          title: Text(l10n.ng_bots_advanced),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: [
            DropdownButtonFormField<String>(
              key: const Key('bots-new-clone'),
              initialValue: _cloneFrom,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.ng_bots_clone_from,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'default',
                  child: Text(
                    l10n.ng_bots_clone_main,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: _freshProfile,
                  child: Text(
                    l10n.ng_bots_fresh_profile,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final bot in widget.roster)
                  if (!bot.isDefault && bot.name != 'default')
                    DropdownMenuItem(
                      value: bot.name,
                      child: Text(bot.title, overflow: TextOverflow.ellipsis),
                    ),
              ],
              onChanged: _busy
                  ? null
                  : (v) => setState(() => _cloneFrom = v ?? 'default'),
            ),
            CheckboxListTile(
              key: const Key('bots-new-no-skills'),
              contentPadding: EdgeInsets.zero,
              value: _noSkills,
              title: Text(l10n.ng_bots_create_empty),
              onChanged: _busy
                  ? null
                  : (v) => setState(() => _noSkills = v ?? false),
            ),
            CheckboxListTile(
              key: const Key('bots-new-share-auth'),
              contentPadding: EdgeInsets.zero,
              value: _shareAuth,
              title: Text(l10n.ng_bots_share_keys),
              onChanged: _busy
                  ? null
                  : (v) => setState(() => _shareAuth = v ?? true),
            ),
            _gap(),
            TextField(
              key: const Key('bots-new-provider'),
              controller: _provider,
              enabled: !_busy,
              decoration: InputDecoration(
                labelText: l10n.ng_bots_provider,
                border: const OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextField(
              key: const Key('bots-new-model'),
              controller: _model,
              enabled: !_busy,
              decoration: InputDecoration(
                labelText: l10n.ng_bots_model,
                border: const OutlineInputBorder(),
                errorText: _modelPairBroken ? l10n.ng_bots_model_pair : null,
                errorMaxLines: 3,
              ),
            ),
            _gap(),
            TextField(
              key: const Key('bots-new-soul'),
              controller: _soul,
              enabled: !_busy,
              minLines: 3,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: l10n.ng_bots_soul,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        _inlineError(context, _error, 'bots-form-error'),
        _gap(),
        FilledButton(
          key: const Key('bots-form-save'),
          onPressed: _valid && !_busy ? () => unawaited(_submit()) : null,
          child: Text(_busy ? l10n.ng_bots_creating : l10n.ng_bots_create_bot),
        ),
      ],
    );
  }
}
