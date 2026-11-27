// This file intentionally uses only APIs present at the feature base. Copying
// it to 49d29803 reproduces both missing-widget gaps without compilation errors.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/remote_files_client.dart';
import 'package:hermes_android/core/utils/media_tags.dart';
import 'package:hermes_android/core/widgets/attachment_draft_tile.dart';
import 'package:hermes_android/core/widgets/media_artifact_card.dart';
import 'package:hermes_android/l10n/app_localizations.dart';

Widget _app(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

class _Files extends Fake implements RemoteFilesDataSource {}

void main() {
  testWidgets(
    'picked file audio has a playback affordance, not only a document icon',
    (tester) async {
      await tester.pumpWidget(
        _app(
          AttachmentDraftTile(
            draft: AttachmentDraft(
              id: 'picked',
              cachedPath: '/private/synthetic.bin',
              name: 'clip.wav',
              byteLength: 3,
              mediaType: 'audio/wav',
              kind: AttachmentDraftKind.genericFile,
            ),
            index: 0,
            total: 1,
            busy: false,
            onMovePrevious: () {},
            onMoveNext: () {},
            onRetry: () {},
            onRemove: () {},
          ),
        ),
      );
      expect(
        find.byKey(const Key('attachment-audio-play-pause')),
        findsOneWidget,
      );
    },
  );
  testWidgets('delivered audio has playback, not only download and share', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        MediaArtifactCard(
          ref: const MediaTagRef(path: '/gateway/clip.wav'),
          filesClient: () => _Files(),
          sourceIdentity: 'synthetic-owner',
        ),
      ),
    );
    expect(
      find.byKey(const Key('attachment-audio-play-pause')),
      findsOneWidget,
    );
  });
}
