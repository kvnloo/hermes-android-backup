import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/preview/chat_preview.dart';
import 'package:hermes_android/core/preview/preview_evidence.dart';
import 'package:hermes_android/core/preview/preview_messages.dart';
import 'package:hermes_android/core/preview/reader_document.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/l10n/app_localizations.dart'
    show lookupAppLocalizations;
import 'package:http/testing.dart';

Map<String, dynamic> _catalog(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

String _german(String key) {
  final english = _catalog('en');
  final german = _catalog('de');
  expect(english, contains(key));
  expect(german, contains(key));
  final translated = german[key] as String;
  expect(translated, isNotEmpty);
  expect(translated, isNot(english[key]), reason: '$key must be translated');
  return translated;
}

Widget _app(Widget child, {Locale locale = const Locale('de')}) => MaterialApp(
  locale: locale,
  supportedLocales: const [Locale('de'), Locale('en')],
  // Deliberately omit the generated app delegate, like shared NextGen widgets.
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('preview localizes its unbound state without an app delegate', (
    tester,
  ) async {
    final dashboard = DashboardClient(
      host: 'preview-fixture.invalid',
      useHttps: true,
      httpClient: MockClient((_) async {
        throw StateError('An unbound preview must not perform network I/O');
      }),
    );
    final owner = RemoteWorkspaceOwner(
      connectionId: 'preview-l10n-fixture',
      expectedBaseUrl: dashboard.baseUrl,
      profile: null,
      dashboard: dashboard,
      connect: () async => throw StateError('No stored chat to connect'),
      ownsSocket: (_) => false,
    );
    addTearDown(owner.close);
    addTearDown(dashboard.close);
    final preview = ChatPreview(
      owner: owner,
      route: owner.route(),
      service: AttachmentDraftService(),
      existing: const [],
      commit: (_, _) {},
      visible: true,
      hide: () {},
      close: () {},
    );
    await tester.pumpWidget(_app(preview));
    await tester.pumpAndSettle();

    for (final suffix in ['title', 'reconnect', 'reader_mode_help']) {
      expect(find.text(_german('release_preview_$suffix')), findsOneWidget);
    }
    for (final suffix in ['hide', 'close_and_forget', 'go_to_address']) {
      expect(
        find.byTooltip(_german('release_preview_$suffix')),
        findsOneWidget,
      );
    }
    final address = tester.widget<TextField>(
      find.byKey(const Key('preview-address')),
    );
    expect(
      address.decoration!.labelText,
      _german('release_preview_site_address'),
    );
    expect(
      find.text(
        _german(
          'release_preview_unavailable_reason',
        ).replaceAll('{reason}', _german('history_error_unbound')),
      ),
      findsOneWidget,
    );
    final visible = [
      ...tester
          .widgetList<RichText>(find.byType(RichText, skipOffstage: false))
          .map((text) => text.text.toPlainText()),
      ...tester
          .widgetList<Tooltip>(find.byType(Tooltip, skipOffstage: false))
          .map((tooltip) => tooltip.message ?? ''),
    ].join('\n');
    for (final english in [
      'Browser preview',
      'Hide preview',
      'Close and forget page',
      'Site address',
      'Go to address',
      'Reconnect preview',
      'Preview unavailable:',
      'Reader mode: HTML and text.',
    ]) {
      expect(visible, isNot(contains(english)));
    }

    // Keep the same preview State and refusal; only the ambient locale changes.
    await tester.pumpWidget(_app(preview, locale: const Locale('en')));
    await tester.pumpAndSettle();
    expect(
      find.text(_catalog('en')['release_preview_title'] as String),
      findsOneWidget,
    );
    expect(
      find.text(
        (_catalog('en')['release_preview_unavailable_reason'] as String)
            .replaceAll(
              '{reason}',
              _catalog('en')['history_error_unbound'] as String,
            ),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  test('typed reader failures resolve against the rendering locale', () {
    final german = lookupAppLocalizations(const Locale('de'));
    const cases = {
      PreviewFailure.address: 'address_not_approved',
      PreviewFailure.pageLimit: 'page_limit',
      PreviewFailure.unreadable: 'page_unreadable',
      PreviewFailure.complex: 'page_complex',
      PreviewFailure.http: 'http_failed',
      PreviewFailure.contentType: 'unsupported_type',
      PreviewFailure.secureLoad: 'load_insecure',
      PreviewFailure.capture: 'capture_failed',
    };
    expect(cases.keys.toSet(), PreviewFailure.values.toSet());
    for (final entry in cases.entries) {
      final error = PreviewError(entry.key, statusCode: 418);
      expect(
        previewNoticeText(german, error),
        _german(
          'release_preview_${entry.value}',
        ).replaceAll('{statusCode}', '418'),
      );
      expect(previewNoticeText(german, error), isNot(error.message));
    }
    for (final failure in WorkspaceFailure.values) {
      expect(
        previewNoticeText(german, WorkspaceException(failure)),
        _german('release_preview_unavailable_reason').replaceAll(
          '{reason}',
          _german(switch (failure) {
            WorkspaceFailure.unbound => 'history_error_unbound',
            WorkspaceFailure.ineligible => 'history_error_denied',
            _ => 'release_core_workspace_failure_${failure.name}',
          }),
        ),
      );
    }
    const notices = {
      PreviewNotice.chatChanged: 'chat_changed',
      PreviewNotice.authenticating: 'authenticating_chat',
      PreviewNotice.addedToDraft: 'added_to_draft',
    };
    for (final entry in notices.entries) {
      expect(
        previewNoticeText(german, entry.key),
        _german('release_preview_${entry.value}'),
      );
    }
    expect(
      previewNoticeText(german, StateError('Do not show this diagnostic')),
      _german('release_preview_operation_failed'),
    );
  });

  test('attachment refusals map locally without leaking English diagnostics', () {
    final german = lookupAppLocalizations(const Locale('de'));
    const cases = {
      'Preview crop exceeds its limit.': 'crop_limit',
      'The selected image is empty or unreadable.': 'image_unreadable',
      'The selected image exceeds the 64 MiB draft budget.': 'image_budget',
      'Unsupported image format. Choose a JPEG, PNG, or WebP image.':
          'image_format',
      'The selected JPEG, PNG, or WebP image could not be decoded safely.':
          'image_decode',
      'Unable to sanitize this image. Choose a valid JPEG, PNG, or WebP image.':
          'image_sanitize',
      'Attachments are limited to 64 MiB total per draft.': 'draft_budget',
      'Generic files are limited to 16 MiB each.': 'generic_file_limit',
      'Remote images must be sanitized before upload.': 'image_not_sanitized',
    };
    for (final entry in cases.entries) {
      expect(
        previewNoticeText(german, AttachmentDraftException(entry.key)),
        _german('release_preview_${entry.value}'),
      );
    }
    expect(
      previewNoticeText(
        german,
        const AttachmentDraftException(
          'You can attach up to 10 items to one Remote Gateway draft.',
        ),
      ),
      _german(
        'you_can_attach_up_to_items',
      ).replaceAll('{maxRemoteAttachmentDrafts}', '10'),
    );
    expect(
      previewNoticeText(
        german,
        const AttachmentDraftException('Unexpected untranslated service error'),
      ),
      _german('release_preview_stage_failed'),
    );
  });

  test(
    'retained reader logs translate again when copied in another locale',
    () {
      final german = lookupAppLocalizations(const Locale('de'));
      final english = lookupAppLocalizations(const Locale('en'));
      _german('release_preview_request_loaded');
      final log = PreviewConsoleLog()
        ..addRequest('https://first.example', 1)
        ..addRequest('https://second.example', 2);
      expect(log.export(l10n: german), [
        german.release_preview_request_loaded('https://first.example', 1),
        german.release_preview_request_loaded('https://second.example', 2),
      ]);
      log.toggle(log.lines.last.id);
      expect(log.export(l10n: german), [
        german.release_preview_request_loaded('https://second.example', 2),
      ]);
      expect(log.export(l10n: english), [
        english.release_preview_request_loaded('https://second.example', 2),
      ]);
      expect(log.export(l10n: german), isNot(log.export(l10n: english)));
      expect(
        log.export(l10n: german).single,
        isNot(contains('reader elements')),
      );
    },
  );

  test(
    'annotation evidence localizes its introduction without altering notes',
    () {
      final german = lookupAppLocalizations(const Locale('de'));
      const origin = 'https://preview.example:9443';
      final prompt = annotationPrompt(origin, [
        PreviewPin(
          2,
          const Rect.fromLTWH(10, 20, 30, 40),
          'body > p:nth-of-type(1)',
          'User-authored note',
          Uint8List(0),
        ),
      ], introduction: german.release_preview_annotation_intro);
      expect(
        prompt.split('\n').first,
        _german(
          'release_preview_annotation_intro',
        ).replaceAll('{origin}', origin),
      );
      expect(
        prompt,
        contains(
          '#2 · body > p:nth-of-type(1) · 10,20 (30 × 40): User-authored note',
        ),
      );
      expect(prompt, isNot(contains('Review these comments')));
    },
  );

  test('reader policy and parser retain typed context-free failures', () {
    final policy = PreviewPolicy(Uri.parse('https://gateway.invalid'));
    expect(
      () => policy.accept('file:///private/file'),
      throwsA(
        isA<PreviewError>().having(
          (error) => error.reason,
          'reason',
          PreviewFailure.address,
        ),
      ),
    );
    expect(
      () => ReaderDocument.parse(
        Uri.parse('https://preview.example'),
        'long',
        limit: 1,
      ),
      throwsA(
        isA<PreviewError>().having(
          (error) => error.reason,
          'reason',
          PreviewFailure.pageLimit,
        ),
      ),
    );
    // Existing isolate timeout tests consume this diagnostic, not UI copy.
    expect(
      const PreviewError(PreviewFailure.complex).message,
      'This page is too complex for reader mode.',
    );
  });
}
