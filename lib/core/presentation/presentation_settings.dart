import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imported_theme.dart';
import 'pet_window.dart';
import 'petdex.dart';
import '../../l10n/app_localizations.dart';
import '../l10n/l10n.dart';
import 'presentation_scope.dart';
import 'radio.dart';
import 'reading_controls.dart';

/// A theme file the panel can parse without touching the platform picker.
typedef PickedThemeFile = ({String name, Uint8List bytes});

/// Appearance, companion, radio and the in-app tour. Both layouts mount this
/// same panel; it uses the surrounding [PresentationHost] when one exists.
class PresentationSettingsPanel extends StatefulWidget {
  const PresentationSettingsPanel({
    super.key,
    required this.preferences,
    this.pickTheme,
    this.pickDraft,
  });

  final SharedPreferences preferences;
  final Future<PickedThemeFile?> Function()? pickTheme;
  final Future<PetDraft?> Function()? pickDraft;

  @override
  State<PresentationSettingsPanel> createState() =>
      _PresentationSettingsPanelState();
}

class _GuideStep {
  const _GuideStep(this.id, this.title, this.body);

  final String id;
  final String Function(AppLocalizations l) title;
  final String Function(AppLocalizations l) body;
}

final _steps = <_GuideStep>[
  _GuideStep(
    'theme',
    (l) => l.appearance_imported_themes,
    (l) => l.appearance_tour_theme_body,
  ),
  _GuideStep(
    'fonts',
    (l) => l.appearance_tour_fonts_title,
    (l) => l.appearance_tour_fonts_body,
  ),
  _GuideStep(
    'direction',
    (l) => l.appearance_tour_direction_title,
    (l) => l.appearance_tour_direction_body,
  ),
  _GuideStep(
    'pet',
    (l) => l.appearance_tour_pet_title,
    (l) => l.appearance_tour_pet_body,
  ),
  _GuideStep(
    'radio',
    (l) => l.appearance_radio,
    (l) => l.appearance_tour_radio_body,
  ),
];

/// English stays searchable in every locale: a reader following an English
/// guide can still find the control.
final _english = lookupAppLocalizations(const Locale('en'));

class _PresentationSettingsPanelState extends State<PresentationSettingsPanel> {
  final _search = TextEditingController();
  final _targets = <String, GlobalKey>{};
  String _query = '';
  int? _tour;
  String? _error;
  var _busy = false;
  var _prepared = false;
  ReadingControls? _ownedReading;
  PetdexController? _ownedPet;
  AresRadio? _ownedRadio;
  late ImportedThemeStore _themes;
  final _dismissedTips = <String>{};

  static const _tipsKey = 'presentation.tips.v1';

  GlobalKey _key(String id) => _targets.putIfAbsent(id, GlobalKey.new);

  ReadingControls get _reading =>
      PresentationScope.maybeOf(context)?.reading ?? _ownedReading!;

  PetdexController get _pet =>
      PresentationScope.maybeOf(context)?.pet ?? _ownedPet!;

  AresRadio get _radio =>
      PresentationScope.maybeOf(context)?.radio ?? _ownedRadio!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prepared) return;
    _prepared = true;
    final host = PresentationScope.maybeOf(context);
    _themes = host?.themes ?? ImportedThemeStore(widget.preferences);
    if (host == null) {
      _ownedReading = ReadingControls(widget.preferences);
      _ownedPet = PetdexController(widget.preferences);
      _ownedRadio = AresRadio.fromPreferences(widget.preferences);
    }
    final saved = widget.preferences.getStringList(_tipsKey);
    if (saved != null) _dismissedTips.addAll(saved);
  }

  @override
  void dispose() {
    _search.dispose();
    _ownedReading?.dispose();
    _ownedPet?.dispose();
    _ownedRadio?.dispose();
    super.dispose();
  }

  bool _visible(_GuideStep step) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return true;
    final l = context.sharedL10n;
    return [
      step.title(l),
      step.body(l),
      step.title(_english),
      step.body(_english),
    ].any((text) => text.toLowerCase().contains(query));
  }

  Future<void> _jump(_GuideStep step) async {
    setState(() {
      _query = '';
      _search.clear();
    });
    await Future<void>.delayed(Duration.zero);
    final target = _key(step.id).currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(
        target,
        alignment: 0.2,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  void _startTour() {
    setState(() {
      _query = '';
      _search.clear();
      _tour = 0;
    });
    _revealTour();
  }

  Future<void> _revealTour() async {
    final index = _tour;
    if (index == null) return;
    await Future<void>.delayed(Duration.zero);
    final target = _key(_steps[index].id).currentContext;
    if (target != null && target.mounted) {
      await Scrollable.ensureVisible(target, alignment: 0.15);
    }
  }

  void _moveTour(int delta) {
    final index = _tour;
    if (index == null) return;
    final next = index + delta;
    if (next < 0 || next >= _steps.length) {
      setState(() => _tour = null);
      return;
    }
    setState(() => _tour = next);
    _revealTour();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        // A parser's reason is English; the reader gets a localised one.
        _error = error is FormatException
            ? context.sharedL10n.appearance_theme_import_failed
            : context.sharedL10n.appearance_save_failed;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<List<ImportedTheme>?> _loadTheme() async {
    final injected = widget.pickTheme;
    if (injected != null) {
      final file = await injected();
      if (file == null) return null;
      return ImportedThemeParser.parse(file.name, file.bytes);
    }
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['vsix', 'json', 'jsonc'],
      withData: false,
      withReadStream: true,
    );
    if (picked == null || picked.files.isEmpty) return null;
    final file = picked.files.single;
    final stream = file.readStream;
    if (stream == null) {
      throw const FormatException('Choose a .vsix, .json or .jsonc theme.');
    }
    return ImportedThemeParser.parseStream(
      file.name,
      stream,
      declaredSize: file.size,
    );
  }

  Future<void> _import() => _run(() async {
    final variants = await _loadTheme();
    if (variants == null || !mounted) return;
    final chosen = await showDialog<ImportedTheme>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.sharedL10n.appearance_keep_which_theme),
        children: [
          for (final theme in variants)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, theme),
              child: Text(
                '${theme.label} · ${theme.brightness == Brightness.dark ? context.sharedL10n.dark : context.sharedL10n.light}',
              ),
            ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;
    final host = PresentationScope.maybeOf(context);
    await _themes.save(chosen);
    host?.themeChanged();
    if (mounted) setState(() {});
  });

  void _dismissTip(String id) {
    setState(() => _dismissedTips.add(id));
    unawaited(
      widget.preferences.setStringList(_tipsKey, _dismissedTips.toList()),
    );
  }

  void _restoreTips() {
    setState(_dismissedTips.clear);
    unawaited(widget.preferences.remove(_tipsKey));
  }

  Widget _section(String id, Widget child) {
    final active = _tour != null && _steps[_tour!].id == id;
    final step = active ? _steps[_tour!] : null;
    return Container(
      key: _key(id),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          if (step != null) ...[
            const SizedBox(height: 8),
            Text(
              step.title(context.sharedL10n),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(step.body(context.sharedL10n)),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _moveTour(-1),
                  child: Text(context.sharedL10n.appearance_tour_back),
                ),
                TextButton(
                  onPressed: () => _moveTour(1),
                  child: Text(
                    _tour == _steps.length - 1
                        ? context.sharedL10n.appearance_tour_finish
                        : context.sharedL10n.appearance_tour_next,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _tour = null),
                  child: Text(context.sharedL10n.appearance_tour_close),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tip(String id, String text) {
    if (_dismissedTips.contains(id)) return const SizedBox.shrink();
    return MaterialBanner(
      forceActionsBelow: true,
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => _dismissTip(id),
          child: Text(context.sharedL10n.appearance_dismiss_tip),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_prepared) return const SizedBox.shrink();
    final library = _themes.read();
    final matches = _steps.where(_visible).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('presentation-search'),
          controller: _search,
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: context.sharedL10n.appearance_search_settings,
          ),
        ),
        if (_query.trim().isNotEmpty)
          for (final step in matches)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(step.title(context.sharedL10n)),
              trailing: Text(context.sharedL10n.appearance_search_show),
              onTap: () => _jump(step),
            ),
        if (_query.trim().isNotEmpty && matches.isEmpty)
          Text(context.sharedL10n.appearance_no_matching_setting),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              key: const ValueKey('presentation-replay-tour'),
              onPressed: _startTour,
              icon: const Icon(Icons.tour_outlined),
              label: Text(context.sharedL10n.appearance_replay_tour),
            ),
            TextButton(
              onPressed: _restoreTips,
              child: Text(context.sharedL10n.appearance_show_tips_again),
            ),
          ],
        ),
        _tip('theme', context.sharedL10n.appearance_tip_theme),
        if (_visible(_steps[0])) _section('theme', _themeSection(library)),
        if (_visible(_steps[1])) _section('fonts', _fontSection()),
        if (_visible(_steps[2])) _section('direction', _directionSection()),
        _section('reading', _readingToggles()),
        _section(
          'window',
          Text(context.sharedL10n.appearance_window_translucency_unavailable),
        ),
        if (_visible(_steps[3])) _section('pet', _petSection()),
        if (_visible(_steps[4]))
          _section('radio', AresRadioSettingsBody(radio: _radio)),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }

  Widget _themeSection(ImportedThemeLibrary library) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.sharedL10n.appearance_imported_themes,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        OutlinedButton.icon(
          key: const ValueKey('presentation-import-theme'),
          onPressed: _busy ? null : _import,
          icon: const Icon(Icons.palette_outlined),
          label: Text(context.sharedL10n.appearance_import_theme_file),
        ),
        for (final theme in library.themes)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(theme.label),
            subtitle: Text(theme.source),
            leading: Icon(
              library.selectedId == theme.id
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
            ),
            onTap: _busy
                ? null
                : () {
                    final host = PresentationScope.maybeOf(context);
                    final id = theme.id;
                    final clear = library.selectedId == id;
                    _run(() async {
                      await _themes.select(clear ? null : id);
                      host?.themeChanged();
                    });
                  },
            trailing: IconButton(
              tooltip: context.sharedL10n.appearance_remove_theme,
              onPressed: _busy
                  ? null
                  : () {
                      final host = PresentationScope.maybeOf(context);
                      final id = theme.id;
                      _run(() async {
                        await _themes.remove(id);
                        host?.themeChanged();
                      });
                    },
              icon: const Icon(Icons.delete_outline),
            ),
          ),
      ],
    );
  }

  Widget _fontSection() {
    final reading = _reading;
    return ListenableBuilder(
      listenable: reading,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.sharedL10n.appearance_chat_font,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DropdownButton<AresTypeface>(
            key: const ValueKey('presentation-chat-font'),
            isExpanded: true,
            value: reading.chatFont,
            items: [
              for (final face in AresTypeface.chatChoices)
                DropdownMenuItem(value: face, child: Text(_face(face))),
            ],
            onChanged: _busy
                ? null
                : (face) {
                    if (face != null) _run(() => reading.setChatFont(face));
                  },
          ),
          Text(
            context.sharedL10n.appearance_terminal_font,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DropdownButton<AresTypeface>(
            key: const ValueKey('presentation-terminal-font'),
            isExpanded: true,
            value: reading.terminalFont,
            items: [
              for (final face in AresTypeface.terminalChoices)
                DropdownMenuItem(value: face, child: Text(_face(face))),
            ],
            onChanged: _busy
                ? null
                : (face) {
                    if (face != null) {
                      _run(() => reading.setTerminalFont(face));
                    }
                  },
          ),
        ],
      ),
    );
  }

  String _face(AresTypeface face) => switch (face) {
    AresTypeface.platform => context.sharedL10n.appearance_font_platform,
    AresTypeface.geist => 'Geist',
    AresTypeface.geistMono => 'Geist Mono',
    AresTypeface.cinzel => 'Cinzel',
  };

  Widget _directionSection() {
    final reading = _reading;
    return ListenableBuilder(
      listenable: reading,
      builder: (context, _) => Column(
        children: [
          DropdownButton<TranscriptDirection>(
            key: const ValueKey('presentation-direction'),
            isExpanded: true,
            value: reading.direction,
            items: [
              DropdownMenuItem(
                value: TranscriptDirection.automatic,
                child: Text(context.sharedL10n.appearance_automatic),
              ),
              DropdownMenuItem(
                value: TranscriptDirection.leftToRight,
                child: Text(context.sharedL10n.appearance_force_left_to_right),
              ),
              DropdownMenuItem(
                value: TranscriptDirection.rightToLeft,
                child: Text(context.sharedL10n.appearance_force_right_to_left),
              ),
            ],
            onChanged: _busy
                ? null
                : (value) {
                    if (value != null) _run(() => reading.setDirection(value));
                  },
          ),
          Text(context.sharedL10n.appearance_user_bubble_opacity),
          Semantics(
            label: context.sharedL10n.appearance_user_bubble_opacity,
            child: Slider(
              key: const ValueKey('presentation-bubble-opacity'),
              min: ReadingControls.minBubbleOpacity,
              max: 1,
              value: reading.bubbleOpacity,
              onChanged: _busy
                  ? null
                  : (value) => _run(() => reading.setBubbleOpacity(value)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingToggles() {
    final reading = _reading;
    return ListenableBuilder(
      listenable: reading,
      builder: (context, _) => Column(
        children: [
          _inlineEmbeds(context, reading),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            key: const ValueKey('presentation-reactions'),
            title: Text(context.sharedL10n.appearance_emoji_reactions),
            value: reading.emojiReactions,
            onChanged: _busy
                ? null
                : (value) => _run(() => reading.setEmojiReactions(value)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            key: const ValueKey('presentation-hearts'),
            title: Text(context.sharedL10n.appearance_celebration_hearts),
            subtitle: Text(
              context.sharedL10n.appearance_celebration_hearts_hint,
            ),
            value: reading.celebrationHearts,
            onChanged: _busy
                ? null
                : (value) => _run(() => reading.setCelebrationHearts(value)),
          ),
        ],
      ),
    );
  }

  /// Hermes Desktop's Inline Embeds: Ask, Always or Off, and a reset for
  /// the services the reader always allows.
  Widget _inlineEmbeds(BuildContext context, ReadingControls reading) {
    final l = context.sharedL10n;
    final allowed = reading.allowedEmbeds.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l.appearance_inline_embeds),
          subtitle: Text(l.appearance_inline_embeds_hint),
        ),
        SegmentedButton<InlineEmbedMode>(
          key: const ValueKey('presentation-embeds'),
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: InlineEmbedMode.ask,
              label: Text(l.appearance_embeds_ask),
            ),
            ButtonSegment(
              value: InlineEmbedMode.always,
              label: Text(l.appearance_embeds_always),
            ),
            ButtonSegment(
              value: InlineEmbedMode.off,
              label: Text(l.appearance_embeds_off),
            ),
          ],
          selected: {reading.embedMode},
          onSelectionChanged: _busy
              ? null
              : (choice) => _run(() => reading.setEmbedMode(choice.single)),
        ),
        if (allowed > 0)
          TextButton(
            key: const ValueKey('presentation-embeds-reset'),
            onPressed: _busy ? null : () => _run(reading.resetAllowedEmbeds),
            child: Text(l.appearance_embeds_reset(allowed)),
          ),
      ],
    );
  }

  Widget _petSection() {
    final pet = _pet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tip('pet', context.sharedL10n.appearance_tip_pet),
        PetdexSettings(
          controller: pet,
          pickDraft: widget.pickDraft ?? PetDraft.pick,
        ),
        OutlinedButton.icon(
          key: const ValueKey('presentation-pet-popout'),
          onPressed: () => openPetCompanion(context, pet),
          icon: const Icon(Icons.open_in_new),
          label: Text(context.sharedL10n.appearance_pop_out_companion),
        ),
      ],
    );
  }
}
