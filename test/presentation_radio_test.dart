import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/presentation/radio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class _Player extends Fake implements AudioPlayer {
  final complete = StreamController<void>.broadcast(sync: true);
  final states = StreamController<PlayerState>.broadcast(sync: true);
  final gotVolume = Completer<void>();
  final gotSource = Completer<void>();
  Completer<void>? volumeGate, sourceGate, resumeGate, disposeGate;
  final urls = <String>[];
  final levels = <double>[];
  int starts = 0, releases = 0;

  @override
  Stream<void> get onPlayerComplete => complete.stream;
  @override
  Stream<PlayerState> get onPlayerStateChanged => states.stream;
  @override
  Future<void> setVolume(double volume) async {
    levels.add(volume);
    if (!gotVolume.isCompleted) gotVolume.complete();
    await volumeGate?.future;
  }

  @override
  Future<void> setSource(Source source) async {
    urls.add((source as UrlSource).url);
    gotSource.complete();
    await sourceGate?.future;
  }

  @override
  Future<void> resume() async {
    await resumeGate?.future;
    ++starts;
  }

  @override
  Future<void> dispose() async {
    ++releases;
    await disposeGate?.future;
    await complete.close();
    await states.close();
  }
}

class _Metadata extends http.BaseClient {
  final response = Completer<http.StreamedResponse>();
  final requests = <http.BaseRequest>[];
  int closes = 0;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    requests.add(request);
    return response.future;
  }

  void sources(Object sources) => response.complete(
    http.StreamedResponse(
      Stream.value(
        utf8.encode(
          jsonEncode({
            'icestats': {'source': sources},
          }),
        ),
      ),
      200,
    ),
  );
  @override
  void close() {
    ++closes;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late List<_Player> players;
  late List<_Metadata> clients;
  AresRadio create({_Player Function()? factory}) => AresRadio.fromPreferences(
    prefs,
    createPlayer: () {
      final player = factory?.call() ?? _Player();
      players.add(player);
      return player;
    },
    createMetadataClient: () {
      final client = _Metadata();
      clients.add(client);
      return client;
    },
  );
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    players = [];
    clients = [];
  });

  test(
    'only Play connects; preferences and pin-first queue survive rehydration',
    () async {
      final radio = create();
      expect(radio.enabled, false);
      await radio.play();
      await radio.setEnabled(true);
      expect(radio.search(' paradise '), [
        AresRadioStation.paradiseMain,
        AresRadioStation.paradiseMellow,
      ]);
      expect(radio.search('not a preset'), isEmpty);
      await radio.togglePin(AresRadioStation.eve);
      await radio.select(AresRadioStation.paradiseMellow);
      await radio.next();
      expect(radio.station, AresRadioStation.eve);
      await radio.setVolume(0.7);
      expect(players, isEmpty);
      expect(clients, isEmpty);
      radio.dispose();
      await prefs.reload();
      final restored = create();
      addTearDown(restored.dispose);
      expect(restored.enabled, true);
      expect(restored.status, AresRadioStatus.paused);
      expect(restored.volume, 0.7);
      expect(restored.station, AresRadioStation.eve);
      expect(restored.search('').first, AresRadioStation.eve);
      expect(players, isEmpty);
      await restored.play();
      expect(players.single.urls, [
        'https://media01.gamingnow.net:8010/erweb.mp3',
      ]);
      expect(players.single.levels, [0.7]);
      expect(players.single.starts, 1);
      expect(restored.status, AresRadioStatus.playing);
      expect(clients, isEmpty);
      await restored.setVolume(2);
      expect(players.single.levels.last, 1);
      await restored.next();
      expect(players.first.releases, 1);
      expect(players.last.urls, [AresRadioStation.chillsynth.streamUrl]);
      await restored.setEnabled(false);
      expect(players.last.releases, 1);
      await restored.togglePin(AresRadioStation.eve);
      await prefs.reload();
      final off = create();
      addTearDown(off.dispose);
      expect(off.enabled, false);
      expect(off.isPinned(AresRadioStation.eve), false);
      expect(off.volume, 1);
      expect(off.station, AresRadioStation.chillsynth);
    },
  );

  test(
    'malformed preferences cannot enable a stream or inject its URL',
    () async {
      SharedPreferences.setMockInitialValues({
        'presentation.radio.station': 'https://unknown.invalid/untrusted',
        'presentation.radio.enabled': 'true',
        'presentation.radio.volume': double.nan,
        'presentation.radio.pins': ['unknown', 'eve-radio', 'eve-radio'],
      });
      prefs = await SharedPreferences.getInstance();
      final radio = create();
      addTearDown(radio.dispose);
      expect(radio.enabled, false);
      expect(radio.station, AresRadioStation.chillsynth);
      expect(radio.search('').length, AresRadioStation.values.length);
      expect(radio.search('').first, AresRadioStation.eve);
      expect(radio.volume, 0.25);
      await radio.play();
      expect(players, isEmpty);
    },
  );

  test(
    'pause fences a delayed initial volume before source dispatch',
    () async {
      final first = _Player()
        ..volumeGate = Completer<void>()
        ..disposeGate = Completer<void>();
      final radio = create(factory: () => players.isEmpty ? first : _Player());
      addTearDown(radio.dispose);
      await radio.setEnabled(true);
      final start = radio.play();
      await first.gotVolume.future;
      final stopping = radio.pause();
      final newStart = radio.play();
      expect(first.releases, 1);
      first.volumeGate!.complete();
      await start;
      expect(first.urls, isEmpty);
      expect(players.length, 1);
      first.disposeGate!.complete();
      await stopping;
      await newStart;
      expect(players.length, 2);
      expect(players.last.starts, 1);
      await radio.pause();
      expect(players.last.releases, 1);
    },
  );

  for (final stop in ['disable', 'dispose', 'background']) {
    test(
      '$stop during preparation releases and cannot resume or reconnect',
      () async {
        final player = _Player()..sourceGate = Completer<void>();
        final radio = create(factory: () => player);
        addTearDown(radio.dispose);
        await radio.setEnabled(true);
        final start = radio.play();
        await player.gotSource.future;
        switch (stop) {
          case 'disable':
            await radio.setEnabled(false);
          case 'dispose':
            radio.dispose();
          case 'background':
            radio.didChangeAppLifecycleState(AppLifecycleState.paused);
        }
        player.sourceGate!.complete();
        await start;
        expect(player.starts, 0);
        expect(player.releases, 1);
        expect(radio.status, AresRadioStatus.paused);
        radio.didChangeAppLifecycleState(AppLifecycleState.resumed);
        expect(players.length, 1);
      },
    );
  }

  test(
    'platform stop during preparation does not release a live pause',
    () async {
      final player = _Player()..resumeGate = Completer<void>();
      final radio = create(factory: () => player);
      addTearDown(radio.dispose);
      await radio.setEnabled(true);
      final start = radio.play();
      await player.gotSource.future;
      player.states.add(PlayerState.stopped);
      expect(radio.status, AresRadioStatus.connecting);
      expect(player.releases, 0);
      player.resumeGate!.complete();
      await start;
      expect(player.starts, 1);
      expect(radio.status, AresRadioStatus.playing);
      player.states.add(PlayerState.paused);
      expect(radio.status, AresRadioStatus.paused);
      expect(player.releases, 1);
    },
  );

  test(
    'native stream errors and ends release rather than claiming live or retrying',
    () async {
      final radio = create();
      addTearDown(radio.dispose);
      await radio.setEnabled(true);
      await radio.play();
      players.single.complete.addError(
        StateError('fixture stream disconnected'),
      );
      expect(radio.status, AresRadioStatus.unavailable);
      expect(players.single.releases, 1);
      await radio.play();
      players.last.complete.add(null);
      expect(radio.status, AresRadioStatus.unavailable);
      expect(players.last.releases, 1);
      expect(players.length, 2);
    },
  );

  Future<void> mount(
    WidgetTester tester,
    AresRadio radio, [
    Locale locale = const Locale('en'),
  ]) => tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: [locale],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(body: AresRadioSettingsBody(radio: radio)),
    ),
  );

  testWidgets(
    'compact picker searches offline; metadata belongs to the live mount and open sheet',
    (tester) async {
      final radio = create();
      addTearDown(radio.dispose);
      await mount(tester, radio);
      expect(find.byTooltip('Play radio'), findsNothing);
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Choose a station'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'gamingnow');
      await tester.pumpAndSettle();
      expect(
        find
            .byType(ListTile)
            .evaluate()
            .where(
              (e) =>
                  (e.widget as ListTile).title is Text &&
                  ((e.widget as ListTile).title as Text).data == 'EVE Radio',
            ),
        hasLength(1),
      );
      await tester.tap(find.byTooltip('Pin station: EVE Radio'));
      await tester.pumpAndSettle();
      expect(radio.isPinned(AresRadioStation.eve), true);
      await tester.tap(find.text('EVE Radio'));
      await tester.pumpAndSettle();
      expect(players, isEmpty);
      expect(clients, isEmpty);
      await tester.tap(find.byTooltip('Play radio').last);
      await tester.pumpAndSettle();
      expect(
        clients.single.requests.single.url.toString(),
        'https://media01.gamingnow.net:8010/status-json.xsl',
      );
      expect(clients.single.requests.single.followRedirects, false);
      expect(radio.nowPlaying, isNull);
      clients.single.sources([
        {'listenurl': 'http://fixture/other.mp3', 'title': 'Wrong mount'},
        {
          'listenurl': 'http://fixture/erweb.mp3',
          'title': 'Artist - First track',
          'metadata': {'artist': 'Artist'},
        },
      ]);
      await tester.pump();
      await tester.pump();
      expect(radio.nowPlaying, 'Artist — First track');
      expect(find.textContaining('Artist — First track'), findsOneWidget);
      expect(find.textContaining('Wrong mount'), findsNothing);
      expect(find.text('Audio only · waveform unavailable'), findsOneWidget);
      await tester.pump(const Duration(seconds: 26));
      expect(clients, hasLength(2));
      final old = clients.last;
      await radio.select(AresRadioStation.chillsynth);
      await tester.pump();
      expect(old.closes, 1);
      expect(clients, hasLength(3));
      final live = clients.last;
      live.sources({
        'listenurl': 'http://fixture/chillsynth.mp3',
        'title': 'New track',
        'artist': 'Second artist',
      });
      old.sources({
        'listenurl': 'http://fixture/erweb.mp3',
        'title': 'Stale track',
      });
      await tester.pump();
      expect(radio.nowPlaying, 'Second artist — New track');
      Navigator.of(tester.element(find.byType(TextField))).pop();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(minutes: 1));
      expect(clients, hasLength(3));
      expect(radio.nowPlaying, isNull);
      expect(radio.status, AresRadioStatus.playing);
      await tester.tap(find.byTooltip('Pause radio'));
      await tester.pumpAndSettle();
      expect(players.last.releases, 1);
      expect(radio.status, AresRadioStatus.paused);
    },
  );

  testWidgets(
    'no metadata endpoint for Radio Paradise; malformed or failed metadata never invents a track',
    (tester) async {
      final radio = create();
      addTearDown(radio.dispose);
      await radio.setEnabled(true);
      await radio.select(AresRadioStation.paradiseMain);
      await radio.play();
      await mount(tester, radio);
      await tester.tap(find.byTooltip('Choose a station'));
      await tester.pumpAndSettle();
      expect(clients, isEmpty);
      await radio.select(AresRadioStation.nightride);
      await tester.pump();
      clients.single.sources({
        'listenurl': 'http://fixture/chillsynth.mp3',
        'title': 'Wrong mount',
      });
      await tester.pump();
      expect(radio.nowPlaying, isNull);
      await tester.pump(const Duration(seconds: 26));
      final pending = clients.last;
      await radio.setEnabled(false);
      expect(pending.closes, 1);
      pending.response.completeError(StateError('fixture late close'));
      await tester.pump();
      expect(radio.nowPlaying, isNull);
      expect(find.text('Radio is off'), findsOneWidget);
      await tester.pump(const Duration(minutes: 1));
      expect(clients.length, 2);
    },
  );

  testWidgets(
    'the hint names every broadcaster and says only Play starts a stream',
    (tester) async {
      final radio = create();
      addTearDown(radio.dispose);
      await mount(tester, radio);
      final hint = find.textContaining('start only when you press Play');
      expect(hint, findsOneWidget);
      final text = tester.widget<Text>(hint).data!;
      for (final broadcaster in [
        'Nightride FM',
        'Radio Paradise',
        'GamingNow',
      ]) {
        expect(text, contains(broadcaster));
      }
      for (final station in AresRadioStation.values) {
        expect(text, contains(station.provider));
      }
      expect(players, isEmpty);
      expect(clients, isEmpty);
    },
  );

  for (final (locale, radioLabel, searchLabel) in [
    (const Locale('ar'), 'الراديو', 'البحث في المحطات المحفوظة مسبقًا'),
    (
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      '電台',
      '搜尋預設電台',
    ),
  ]) {
    testWidgets('controls localize without starting playback ($locale)', (
      tester,
    ) async {
      final radio = create();
      addTearDown(radio.dispose);
      await mount(tester, radio, locale);
      expect(find.text(radioLabel), findsOneWidget);
      expect(
        find.textContaining(AresRadioStation.broadcasters),
        findsOneWidget,
        reason: 'the localised hint names the broadcasters',
      );
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chillsynth'));
      await tester.pumpAndSettle();
      expect(find.text(searchLabel), findsOneWidget);
      expect(players, isEmpty);
      expect(clients, isEmpty);
    });
  }
}
