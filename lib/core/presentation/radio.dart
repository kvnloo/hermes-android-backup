import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../theme/hermes_theme.dart';

/// Only preset IDs are stored. Preferences cannot supply a URL to the player.
enum AresRadioStation {
  chillsynth(
    'chillsynth',
    'Chillsynth',
    'Nightride FM',
    'https://stream.nightride.fm/chillsynth.mp3',
  ),
  nightride(
    'nightride',
    'Nightride',
    'Nightride FM',
    'https://stream.nightride.fm/nightride.mp3',
  ),
  darksynth(
    'darksynth',
    'Darksynth',
    'Nightride FM',
    'https://stream.nightride.fm/darksynth.mp3',
  ),
  spacesynth(
    'spacesynth',
    'Spacesynth',
    'Nightride FM',
    'https://stream.nightride.fm/spacesynth.mp3',
  ),
  paradiseMain(
    'paradise-main',
    'Main Mix',
    'Radio Paradise',
    'https://stream.radioparadise.com/aac-128',
  ),
  paradiseMellow(
    'paradise-mellow',
    'Mellow Mix',
    'Radio Paradise',
    'https://stream.radioparadise.com/mellow-flac',
  ),
  eve(
    'eve-radio',
    'EVE Radio',
    'GamingNow',
    'https://media01.gamingnow.net:8010/erweb.mp3',
  );

  const AresRadioStation(this.id, this.label, this.provider, this.streamUrl);

  /// Every station's broadcaster, in list order: who a stream comes from.
  static String get broadcasters =>
      {for (final station in values) station.provider}.join(', ');

  final String id;
  final String label;
  final String provider;
  final String streamUrl;

  Uri? get _metadataEndpoint => switch (this) {
    paradiseMain || paradiseMellow => null,
    _ => Uri.parse(streamUrl).replace(path: '/status-json.xsl'),
  };
}

enum AresRadioStatus { paused, connecting, playing, unavailable }

AudioPlayer _newPlayer() => AudioPlayer()..positionUpdater = null;

/// One foreground radio per widget tree. There is no process-wide instance.
///
/// [play] is the only control that opens a stream from silence. [select] and
/// [next] reconnect only while a stream is already active. [pause], disabling,
/// leaving the foreground, and [dispose] release the player. Pins, volume, and
/// the station id are stored under `presentation.radio.`.
class AresRadio extends ChangeNotifier with WidgetsBindingObserver {
  factory AresRadio.fromPreferences(
    SharedPreferences prefs, {
    AudioPlayer Function() createPlayer = _newPlayer,
    http.Client Function() createMetadataClient = http.Client.new,
  }) {
    final storedPins = prefs.get('${_prefix}pins');
    final savedVolume = prefs.get('${_prefix}volume');
    AresRadioStation? byId(Object? id) =>
        AresRadioStation.values.where((s) => s.id == id).firstOrNull;
    return AresRadio._(
      prefs,
      createPlayer,
      createMetadataClient,
      prefs.get('${_prefix}enabled') == true,
      byId(prefs.get('${_prefix}station')) ?? AresRadioStation.chillsynth,
      {if (storedPins is List) ...storedPins.map(byId).nonNulls},
      savedVolume is num && savedVolume.isFinite
          ? savedVolume.toDouble().clamp(0, 1).toDouble()
          : 0.25,
    );
  }

  AresRadio._(
    this._prefs,
    this._createPlayer,
    this._createMetadataClient,
    this._enabled,
    this._station,
    this._pins,
    this._volume,
  );

  static const _prefix = 'presentation.radio.';
  static final Expando<Future<void>> _writeTails = Expando<Future<void>>();
  final SharedPreferences _prefs;
  final AudioPlayer Function() _createPlayer;
  final http.Client Function() _createMetadataClient;
  final Set<AresRadioStation> _pins;
  bool _enabled;
  AresRadioStation _station;
  double _volume;
  bool _closed = false;
  bool _disposed = false;
  bool _saveFailed = false;
  AresRadioStatus _status = AresRadioStatus.paused;
  AudioPlayer? _player;
  StreamSubscription<void>? _end;
  StreamSubscription<PlayerState>? _state;
  int _generation = 0;
  Future<void> _releasing = Future.value();
  AudioPlayer? _failedRelease;
  int _openSheets = 0;
  _MetadataFeed? _feed;
  String? _track;

  bool get enabled => _enabled;
  double get volume => _volume;
  AresRadioStation get station => _station;
  AresRadioStatus get status => _status;
  bool get active =>
      status == AresRadioStatus.connecting || status == AresRadioStatus.playing;
  String? get nowPlaying => _track;
  bool isPinned(AresRadioStation station) => _pins.contains(station);

  List<AresRadioStation> search(String query) {
    final text = query.trim().toLowerCase();
    return {..._pins, ...AresRadioStation.values}
        .where((s) => '${s.label} ${s.provider}'.toLowerCase().contains(text))
        .toList();
  }

  void _markSaveFailed() {
    if (_closed || _saveFailed) return;
    _saveFailed = true;
    notifyListeners();
  }

  /// One tail per preference store, so an older save cannot land after a newer
  /// one. The stored future is only the completion signal.
  Future<void> _save(Future<bool> Function() write) {
    final done = Completer<void>();
    final previous = _writeTails[_prefs] ?? Future<void>.value();
    _writeTails[_prefs] = done.future;
    unawaited(() async {
      try {
        await previous;
      } catch (_) {
        /* the earlier attempt recorded its own outcome */
      }
      try {
        if (!await write()) _markSaveFailed();
      } catch (_) {
        _markSaveFailed();
      } finally {
        if (!done.isCompleted) done.complete();
      }
    }());
    return done.future;
  }

  Future<void> setEnabled(bool value) async {
    if (_closed || _enabled == value) return;
    _enabled = value;
    final write = _save(() => _prefs.setBool('${_prefix}enabled', value));
    if (!value) {
      await pause();
    } else {
      notifyListeners();
    }
    await write;
  }

  Future<void> togglePin(AresRadioStation value) async {
    if (_closed) return;
    if (!_pins.remove(value)) _pins.add(value);
    final write = _save(
      () =>
          _prefs.setStringList('${_prefix}pins', [for (final s in _pins) s.id]),
    );
    notifyListeners();
    await write;
  }

  Future<void> select(AresRadioStation value) async {
    if (_closed || _station == value) return;
    final wasActive = active;
    _station = value;
    final write = _save(() => _prefs.setString('${_prefix}station', value.id));
    if (wasActive) {
      await _start();
    } else {
      _status = AresRadioStatus.paused;
      notifyListeners();
    }
    await write;
  }

  Future<void> next() {
    final queue = search('');
    return select(queue[(queue.indexOf(station) + 1) % queue.length]);
  }

  Future<void> setVolume(double value) async {
    if (_closed || !value.isFinite) return;
    final level = value.clamp(0.0, 1.0).toDouble();
    if (level == _volume) return;
    _volume = level;
    final write = _save(() => _prefs.setDouble('${_prefix}volume', level));
    final player = _player;
    final generation = _generation;
    final adjust = player?.setVolume(level);
    notifyListeners();
    try {
      await adjust;
    } catch (_) {
      if (_current(generation)) await _stop(AresRadioStatus.unavailable);
    }
    await write;
  }

  Future<void> play() async {
    if (!_closed && enabled && !active) await _start();
  }

  bool _current(int generation) => !_closed && _generation == generation;

  Future<void> _start() async {
    _detach();
    final generation = _generation;
    _status = AresRadioStatus.connecting;
    WidgetsBinding.instance.addObserver(this);
    notifyListeners();
    try {
      await _releasing;
      if (!_current(generation)) return;
      // Never start a second stream while a prior native release is uncertain.
      if (_failedRelease != null) {
        _detach();
        _status = AresRadioStatus.unavailable;
        notifyListeners();
        return;
      }
      final player = _player = _createPlayer();
      void fail() {
        if (_current(generation)) unawaited(_stop(AresRadioStatus.unavailable));
      }

      _end = player.onPlayerComplete.listen(
        (_) => fail(),
        onError: (Object _) => fail(),
      );
      _state = player.onPlayerStateChanged.listen((value) {
        // A platform stop while setSource is still running must not release
        // the player before resume. Only a pause after we are actually live
        // ends the stream.
        if (!_current(generation) || _status != AresRadioStatus.playing) {
          return;
        }
        if (value == PlayerState.paused || value == PlayerState.stopped) {
          unawaited(pause());
        }
      });
      // Separate preparation from resume: play(source) could dispatch a URL
      // after a pause while its initial volume/creation call was still held.
      await player.setVolume(volume);
      if (!_current(generation)) return;
      await player.setSource(UrlSource(station.streamUrl));
      if (!_current(generation)) return;
      await player.resume();
      if (!_current(generation)) return;
      _status = AresRadioStatus.playing;
      _syncFeed();
      notifyListeners();
    } catch (_) {
      if (_current(generation)) await _stop(AresRadioStatus.unavailable);
    }
  }

  Future<void> pause() => _closed ? _releasing : _stop(AresRadioStatus.paused);

  Future<void> _stop(AresRadioStatus status) {
    _detach();
    _status = status;
    notifyListeners();
    return _releasing;
  }

  void _detach() {
    ++_generation;
    WidgetsBinding.instance.removeObserver(this);
    _feed?.close();
    _feed = null;
    _track = null;
    unawaited(_end?.cancel());
    unawaited(_state?.cancel());
    _end = null;
    _state = null;
    final player = _player ?? _failedRelease;
    _player = _failedRelease = null;
    if (player != null) _releasing = _release(player);
  }

  Future<void> _release(AudioPlayer player) async {
    try {
      // audioplayers.dispose stops, releases the stream, and destroys the player.
      await player.dispose();
    } catch (_) {
      _failedRelease = player;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(pause());
    }
  }

  void _syncFeed() {
    final endpoint = station._metadataEndpoint;
    if (_closed ||
        _openSheets == 0 ||
        status != AresRadioStatus.playing ||
        endpoint == null) {
      _feed?.close();
      _feed = null;
      _track = null;
      return;
    }
    if (_feed != null) return;
    final feed = _feed = _MetadataFeed(
      endpoint,
      Uri.parse(station.streamUrl).path,
      _createMetadataClient,
      (track) {
        if (_track == track) return;
        _track = track;
        notifyListeners();
      },
    );
    unawaited(feed.poll());
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _closed = true;
    _detach();
    _status = AresRadioStatus.paused;
    super.dispose();
  }
}

/// Icecast exposes one source object or an array of mount points. Only the
/// selected mount can supply credits. A station name is not a track title.
String? _readCredit(Object? data, String mount) {
  if (data is! Map || data['icestats'] is! Map) return null;
  final raw = data['icestats']['source'];
  for (final source in raw is List ? raw : [raw]) {
    if (source is! Map ||
        source['listenurl'] is! String ||
        Uri.tryParse(source['listenurl'])?.path != mount) {
      continue;
    }
    String text(Object? value) => value is String ? value.trim() : '';
    final title = text(source['title']);
    if (title.isEmpty) continue;
    final metadata = source['metadata'];
    final artist = text(source['artist']).isNotEmpty
        ? text(source['artist'])
        : text(metadata is Map ? metadata['artist'] : null);
    final parts = RegExp(r'^(.+?)\s+[-–—]\s+(.+)$').firstMatch(title);
    if (parts != null && (artist.isEmpty || parts[1]!.trim() == artist)) {
      return '${parts[1]!.trim()} — ${parts[2]!.trim()}';
    }
    return artist.isEmpty ? title : '$artist — $title';
  }
  return null;
}

class _MetadataFeed {
  _MetadataFeed(this.endpoint, this.mount, this.createClient, this.onCredit);
  final Uri endpoint;
  final String mount;
  final http.Client Function() createClient;
  final ValueChanged<String?> onCredit;
  http.Client? _client;
  Timer? _timer;
  final _abort = Completer<void>();
  bool _closed = false;

  Future<void> poll() async {
    if (_closed) return;
    String? track;
    try {
      final client = _client = createClient();
      track = await _fetch(client).timeout(const Duration(seconds: 10));
    } catch (_) {
      /* absent, malformed, oversized or unavailable metadata */
    } finally {
      _client?.close();
      _client = null;
    }
    if (_closed) return;
    onCredit(track);
    if (!_closed) _timer = Timer(const Duration(seconds: 25), poll);
  }

  Future<String?> _fetch(http.Client client) async {
    final response = await client.send(
      http.AbortableRequest('GET', endpoint, abortTrigger: _abort.future)
        ..followRedirects = false,
    );
    const limit = 256 * 1024;
    if (response.statusCode != 200 || (response.contentLength ?? 0) > limit) {
      return null;
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.stream) {
      if (_closed || bytes.length + chunk.length > limit) return null;
      bytes.add(chunk);
    }
    return _readCredit(jsonDecode(utf8.decode(bytes.takeBytes())), mount);
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _timer?.cancel();
    _timer = null;
    if (!_abort.isCompleted) _abort.complete();
    final client = _client;
    _client = null;
    client?.close();
  }
}

/// Can be placed directly in a scrollable settings panel; no nested scroll view.
class AresRadioSettingsBody extends StatelessWidget {
  const AresRadioSettingsBody({super.key, required this.radio});
  final AresRadio radio;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: radio,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          key: const ValueKey('presentation-radio-enabled'),
          value: radio.enabled,
          onChanged: radio.setEnabled,
          title: Text(context.sharedL10n.appearance_radio),
          // Streams are hard-coded third-party URLs: name the stations.
          subtitle: Text(
            context.sharedL10n.appearance_radio_hint(
              AresRadioStation.broadcasters,
            ),
          ),
        ),
        if (radio.enabled) AresRadioBar(radio: radio),
        if (radio._saveFailed)
          Text(context.sharedL10n.appearance_radio_save_failed),
      ],
    ),
  );
}

class AresRadioBar extends StatelessWidget {
  const AresRadioBar({super.key, required this.radio});
  final AresRadio radio;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: radio,
    builder: (context, _) {
      if (!radio.enabled) return const SizedBox.shrink();
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 148),
              child: Tooltip(
                message: context.sharedL10n.appearance_choose_a_station,
                child: TextButton(
                  onPressed: () => showAresRadioSheet(context, radio),
                  child: Text(
                    radio.station.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          _PlayButton(radio: radio),
          _NextButton(radio: radio),
        ],
      );
    },
  );
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.radio});
  final AresRadio radio;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: radio.active
        ? context.sharedL10n.appearance_pause_radio
        : context.sharedL10n.appearance_play_radio,
    onPressed: radio.active ? radio.pause : radio.play,
    icon: Icon(radio.active ? Icons.pause : Icons.play_arrow),
  );
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.radio});
  final AresRadio radio;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.sharedL10n.appearance_next_station,
    onPressed: radio.next,
    icon: const Icon(Icons.skip_next),
  );
}

Future<void> showAresRadioSheet(BuildContext context, AresRadio radio) async {
  if (radio._closed || !radio.enabled) return;
  radio._openSheets++;
  radio._syncFeed();
  try {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _RadioSheet(radio: radio),
    );
  } finally {
    radio._openSheets--;
    radio._syncFeed();
  }
}

class _FlatTrace extends CustomPainter {
  const _FlatTrace(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(_FlatTrace oldDelegate) => oldDelegate.color != color;
}

/// A flat trace. Playback does not expose PCM here, so the line does not
/// invent loudness. Silence and an unanalysed stream look the same.
class RadioActivityTrace extends StatelessWidget {
  const RadioActivityTrace({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.sharedL10n.appearance_radio_trace_semantics,
      child: SizedBox(
        height: 18,
        width: 120,
        child: CustomPaint(
          painter: _FlatTrace(HermesTokens.of(context).accent),
        ),
      ),
    );
  }
}

class _RadioSheet extends StatefulWidget {
  const _RadioSheet({required this.radio});
  final AresRadio radio;
  @override
  State<_RadioSheet> createState() => _RadioSheetState();
}

class _RadioSheetState extends State<_RadioSheet> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final radio = widget.radio;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ListenableBuilder(
          listenable: radio,
          builder: (context, _) {
            if (!radio.enabled || radio._closed) {
              return ListTile(
                title: Text(context.sharedL10n.appearance_radio_is_off),
              );
            }
            final results = radio.search(query);
            final status = switch (radio.status) {
              AresRadioStatus.paused => context.sharedL10n.appearance_paused,
              AresRadioStatus.connecting =>
                context.sharedL10n.appearance_connecting,
              AresRadioStatus.playing => context.sharedL10n.appearance_live,
              AresRadioStatus.unavailable =>
                context.sharedL10n.appearance_stream_unavailable,
            };
            final credit = radio.nowPlaying;
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.75,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        radio.station.label,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PlayButton(radio: radio),
                          _NextButton(radio: radio),
                        ],
                      ),
                    ],
                  ),
                  Semantics(
                    liveRegion: true,
                    child: Text('$status · ${radio.station.provider}'),
                  ),
                  if (credit != null)
                    Text(context.sharedL10n.appearance_now_playing(credit)),
                  if (radio.status == AresRadioStatus.playing)
                    const RadioActivityTrace(),
                  if (radio.status == AresRadioStatus.playing)
                    Text(
                      context
                          .sharedL10n
                          .appearance_audio_only_waveform_unavailable,
                    ),
                  Row(
                    children: [
                      Icon(
                        radio.volume == 0 ? Icons.volume_off : Icons.volume_up,
                      ),
                      Expanded(
                        child: Semantics(
                          label: context.sharedL10n.appearance_volume,
                          child: Slider(
                            value: radio.volume,
                            onChanged: radio.setVolume,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    onChanged: (v) => setState(() => query = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText: context.sharedL10n.appearance_search_presets,
                    ),
                  ),
                  if (results.isEmpty)
                    ListTile(
                      title: Text(
                        context.sharedL10n.appearance_no_stations_found,
                      ),
                    ),
                  for (final station in results)
                    ListTile(
                      selected: radio.station == station,
                      title: Text(station.label),
                      subtitle: Text(station.provider),
                      onTap: () => radio.select(station),
                      trailing: IconButton(
                        icon: Icon(
                          radio.isPinned(station)
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                        ),
                        tooltip: radio.isPinned(station)
                            ? context.sharedL10n.appearance_unpin_station(
                                station.label,
                              )
                            : context.sharedL10n.appearance_pin_station(
                                station.label,
                              ),
                        onPressed: () => radio.togglePin(station),
                      ),
                    ),
                  Text(
                    context.sharedL10n.appearance_radio_picker_metadata_notice,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
