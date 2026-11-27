// A permanently failed native disposal intentionally fences process-wide
// attachment arbitration. Keep this acceptance case in its own test isolate.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/widgets/attachment_audio_preview.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'support/audio_preview_fixture.dart';

void main() {
  testWidgets(
    'unconfirmed native disposal retains its source and fences later playback',
    (tester) async {
      final fixture = AudioFixture();
      final player = AudioFixturePlayer()
        ..disposeError = StateError('native reader unknown');
      var creates = 0;
      fixture.makePlayer = () => creates++ == 0 ? player : AudioFixturePlayer();
      Future<void> mount(String identity) => tester.pumpWidget(
        fixture.wrap(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: AttachmentAudioPreview(
                sourceIdentity: identity,
                extension: 'wav',
                localPath: '/private/synthetic-cache.bin',
              ),
            ),
          ),
        ),
      );
      await mount('a');
      await tester.tap(find.byKey(const Key('attachment-audio-play-pause')));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(player.disposals, 1);
      expect(fixture.store.files.single.closes, 0);
      await mount('b');
      await tester.tap(find.byKey(const Key('attachment-audio-play-pause')));
      await tester.pumpAndSettle();
      expect(fixture.players.last.plays, 0);
      expect(find.byKey(const Key('attachment-audio-error')), findsOneWidget);
      expect(fixture.store.files.first.closes, 0);
      expect(fixture.store.files.last.closes, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // These are inert fake streams, not native release/cleanup authority.
      await player.states.close();
      await player.positions.close();
      await player.durations.close();
      await player.events.close();
    },
  );
}
