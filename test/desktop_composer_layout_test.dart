// Desktop composer layout: on Windows and macOS the send and mic buttons must
// sit flush against the composer's right edge and never overlap the text
// field. Both shells are pumped at desktop window sizes (including the docked
// sidebar / list-detail widths the desktop ports use) and measured with
// rects; Android runs the same checks as the touch control.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/services/attachment_draft_service.dart';
import 'package:hermes_android/core/models/attachment_draft.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/theme/hermes_theme.dart';
import 'package:hermes_android/core/widgets/voice_composer_controls.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/completed_stock_turn.dart';
import 'support/fake_voice_composer_adapter.dart';
import 'support/pump_chat_updates.dart';

const _tolerance = 1.0;

/// `--dart-define=ARES_COMPOSER_TRACE=true` prints every measured rect.
const _trace = bool.fromEnvironment('ARES_COMPOSER_TRACE');

const _shortModel = 'gpt-5';
const _longModel =
    'anthropic/claude-opus-4-6-extended-thinking-preview-20260101-'
    'with-an-unusually-long-deployment-name';
const _multiLineDraft = 'First line of a draft\nsecond line\nthird line';

/// Width taken by the desktop ports' docked NextGen sessions sidebar plus its
/// 1 dp divider (feat/windows-port `NgMainPage`, `dockedSidebarWidth`).
const _ngDockedSidebar = 301.0;

/// Width taken by the desktop ports' Classic chats list plus its divider
/// (feat/windows-port `WorkspaceScreen` list+detail).
const _classicListPane = 381.0;

class _Window {
  const _Window(this.label, this.size, {this.leadingPane = 0});

  final String label;
  final Size size;

  /// Width of a docked pane to the left of the chat, if any.
  final double leadingPane;
}

const _desktopWindows = <_Window>[
  _Window('1280x800', Size(1280, 800)),
  _Window('900x700', Size(900, 700)),
];

const _phone = _Window('412x915 phone', Size(412, 915));
const _tablet = _Window('1280x800 tablet', Size(1280, 800));

const _textScales = <double>[1.0, 1.3];

/// Global rect of a render box, from its own paint transform.
Rect _globalRect(RenderBox box) =>
    MatrixUtils.transformRect(box.getTransformTo(null), Offset.zero & box.size);

/// The text field's actual editing surface (the RenderEditable), not the
/// decorator around it.
Rect _editableRect(WidgetTester tester, Finder field) {
  final editable = tester.renderObject<RenderEditable>(
    find.descendant(
      of: field,
      matching: find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == '_Editable',
      ),
    ),
  );
  // Clip to the scroll viewport that shows it: a multi-line field may be
  // taller than what is painted.
  final viewport = tester.renderObject<RenderBox>(
    find.descendant(of: field, matching: find.byType(EditableText)),
  );
  return _globalRect(editable).intersect(_globalRect(viewport));
}

Finder _iconButtonWithIcon(IconData icon) => find.ancestor(
  of: find.byIcon(icon),
  matching: find.byWidgetPredicate((w) => w is IconButton),
);

/// The nearest Row that holds [child]: the composer's control row.
Finder _rowOf(Finder child) =>
    find.ancestor(of: child, matching: find.byType(Row)).first;

String _r(Rect r) =>
    'L${r.left.toStringAsFixed(1)} T${r.top.toStringAsFixed(1)} '
    'R${r.right.toStringAsFixed(1)} B${r.bottom.toStringAsFixed(1)}';

/// Collects every violated layout invariant so one red run reports them all.
class _Checks {
  final failures = <String>[];

  void near(String what, double actual, double expected) {
    if ((actual - expected).abs() > _tolerance) {
      failures.add(
        '$what: ${actual.toStringAsFixed(1)} != '
        '${expected.toStringAsFixed(1)}',
      );
    }
  }

  void noOverlap(String what, Rect a, Rect b) {
    if (a.overlaps(b)) failures.add('$what overlap: ${_r(a)} vs ${_r(b)}');
  }

  void leftOf(String what, Rect a, Rect b) {
    if (a.right > b.left + _tolerance) {
      failures.add('$what: ${_r(a)} is not left of ${_r(b)}');
    }
  }

  void inside(String what, Rect inner, Rect outer) {
    if (inner.left < outer.left - _tolerance ||
        inner.right > outer.right + _tolerance ||
        inner.top < outer.top - _tolerance ||
        inner.bottom > outer.bottom + _tolerance) {
      failures.add('$what: ${_r(inner)} outside ${_r(outer)}');
    }
  }
}

/// Runs [body] with the target platform overridden. The override is cleared
/// in the body itself: the binding checks foundation invariants before
/// tear-downs run.
Future<void> _onPlatform(
  TargetPlatform platform,
  Future<void> Function() body,
) async {
  debugDefaultTargetPlatformOverride = platform;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

void _sizeWindow(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Places the chat where the desktop ports put it: beside a docked pane when
/// [leadingPane] is set.
Widget _besidePane(double leadingPane, Widget chat) => leadingPane == 0
    ? chat
    : Row(
        children: [
          SizedBox(width: leadingPane),
          Expanded(child: chat),
        ],
      );

Widget _scaled(BuildContext context, Widget? child, double textScale) =>
    MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    );

// ---------------------------------------------------------------- NextGen --

SavedConnection _ngConnection() => SavedConnection(
  id: 'desktop-layout',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: 'fixture-key',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
);

enum _NgState { idle, draft, running, runningDraft, listening }

/// Answers the speech plugin so NextGen dictation can enter its listening
/// state on desktop without a microphone.
void _mockSpeechPlugin() {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const channel = MethodChannel('plugin.csdcorp.com/speech_to_text');
  messenger.setMockMethodCallHandler(channel, (call) async {
    return switch (call.method) {
      'has_permission' || 'initialize' || 'listen' => true,
      'locales' => <dynamic>[],
      _ => null,
    };
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}

Future<void> _checkNextGen(
  WidgetTester tester, {
  required _Window window,
  required double textScale,
  required _Checks checks,
}) async {
  final prefs = await SharedPreferences.getInstance();
  for (final model in <String?>[null, _shortModel, _longModel]) {
    for (final state in _NgState.values) {
      final platform = defaultTargetPlatform;
      // Android dictation runs through the native hands-free channel, not the
      // speech plugin; its listening state only swaps the mic glyph.
      if (state == _NgState.listening && platform == TargetPlatform.android) {
        continue;
      }
      final label =
          '${platform.name} ${window.label} x$textScale '
          '${model ?? 'default'} ${state.name}';
      final gateway = NextGenGateway(_ngConnection());
      final chat = NgChatController(gateway, sessionId: 'stored')
        ..model = model
        ..reasoningEffort = model == _longModel ? 'high' : null
        ..running = state == _NgState.running || state == _NgState.runningDraft;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: nextGenTheme(Brightness.dark, NextGenLook.instance),
          builder: (context, child) => _scaled(context, child, textScale),
          home: NgScope(
            connManager: ConnectionManager(prefs),
            gateway: gateway,
            connections: [gateway.connection],
            switchTo: (_) async {},
            addGateway: () async {},
            signOut: (_) async {},
            reload: () async {},
            signInAgain: () async {},
            child: Scaffold(
              body: _besidePane(
                window.leadingPane,
                NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final field = find.byKey(const ValueKey('ng-composer-field'));
      if (state == _NgState.draft || state == _NgState.runningDraft) {
        await tester.enterText(field, _multiLineDraft);
        await tester.pump();
      }
      if (state == _NgState.listening) {
        await tester.tap(_iconButtonWithIcon(Icons.mic_none));
        await tester.pump();
        await tester.pump();
        expect(
          _iconButtonWithIcon(Icons.mic),
          findsOneWidget,
          reason: '$label: dictation did not start',
        );
      }

      final showsStop = state == _NgState.running;
      final action = showsStop
          ? _iconButtonWithIcon(Icons.stop_rounded)
          : _iconButtonWithIcon(Icons.arrow_upward_rounded);
      expect(action, findsOneWidget, reason: '$label: send/stop');
      final mic = _iconButtonWithIcon(
        state == _NgState.listening ? Icons.mic : Icons.mic_none,
      );
      expect(mic, findsOneWidget, reason: '$label: mic');

      final row = tester.getRect(_rowOf(action));
      final fieldRect = tester.getRect(field);
      final editable = _editableRect(tester, field);
      final actionRect = tester.getRect(action);
      final micRect = tester.getRect(mic);
      final pillRect = tester.getRect(
        find.byKey(const ValueKey('ng-model-picker')),
      );
      final attachRect = tester.getRect(
        _iconButtonWithIcon(Icons.add_circle_outline),
      );
      if (_trace) {
        debugPrint(
          'TRACE nextgen $label | row ${_r(row)} | field ${_r(fieldRect)} | '
          'text ${_r(editable)} | attach ${_r(attachRect)} | '
          'pill ${_r(pillRect)} | mic ${_r(micRect)} | '
          '${showsStop ? 'stop' : 'send'} ${_r(actionRect)}',
        );
      }
      // The model pill keeps its geometry: it hugs the attach button and is
      // capped at half of the width the fixed controls leave free.
      final freeWidth =
          row.width - attachRect.width - micRect.width - actionRect.width;
      checks.near(
        '$label pill.left vs attach.right',
        pillRect.left,
        attachRect.right,
      );
      if (pillRect.width > freeWidth / 2 + _tolerance) {
        checks.failures.add(
          '$label pill width ${pillRect.width.toStringAsFixed(1)} exceeds '
          'half the free width ${(freeWidth / 2).toStringAsFixed(1)}',
        );
      }

      // The control row spans the composer: same edges as the text field.
      checks.near(
        '$label row.right vs field.right',
        row.right,
        fieldRect.right,
      );
      checks.near(
        '$label ${showsStop ? 'stop' : 'send'}.right vs composer right',
        actionRect.right,
        row.right,
      );
      checks.near(
        '$label mic.right vs send.left',
        micRect.right,
        actionRect.left,
      );
      checks.leftOf('$label model picker before mic', pillRect, micRect);
      checks.inside('$label send in composer', actionRect, row);
      checks.inside('$label mic in composer', micRect, row);
      checks.noOverlap('$label send/text', actionRect, editable);
      checks.noOverlap('$label mic/text', micRect, editable);
      checks.noOverlap('$label send/field', actionRect, fieldRect);
      checks.noOverlap('$label mic/field', micRect, fieldRect);

      await tester.pumpWidget(const SizedBox.shrink());
      chat.dispose();
      gateway.dispose();
    }
  }
}

// ---------------------------------------------------------------- Classic --

class _NoAttachments extends AttachmentDraftService {
  @override
  Future<String> readDataUrl(AttachmentDraft draft) async =>
      'data:text/plain;base64,Zml4dHVyZQ==';

  @override
  Future<void> removeCachedFile(AttachmentDraft draft) async {}
}

enum _ClassicState { idle, draft, streaming, streamingDraft, listening }

Future<void> _checkClassic(
  WidgetTester tester, {
  required _Window window,
  required double textScale,
  required _Checks checks,
}) async {
  for (final state in _ClassicState.values) {
    final label =
        '${defaultTargetPlatform.name} ${window.label} x$textScale '
        '${state.name}';
    final turn = Completer<void>();
    final voice = FakeVoiceComposerAdapter();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: hermesTheme(Brightness.dark),
        builder: (context, child) => _scaled(context, child, textScale),
        home: _besidePane(
          window.leadingPane,
          ChatScreen(
            connection: SavedConnection(
              id: 'desktop-layout',
              label: 'Fixture',
              host: 'fixture.invalid',
              port: 8642,
              apiKey: 'fixture-key',
            ),
            session: Session(
              id: 'desktop-layout-session',
              title: 'Chat',
              model: 'fixture',
              source: 'test',
              messageCount: 0,
              isActive: true,
              preview: '',
              startedAt: 1,
            ),
            testAttachmentDraftService: _NoAttachments(),
            testApiClient: ApiClient(
              baseUrl: 'http://fixture.invalid',
              apiKey: 'fixture-key',
              httpClient: MockClient(
                (_) async => http.Response('{"data":[]}', 200),
              ),
            ),
            testVoiceComposerAdapter: voice,
            testRemotePromptSubmit: completedStockTurn(({
              required sessionId,
              required text,
              required onEvent,
              required onSent,
            }) async {
              onSent();
              await turn.future;
            }),
          ),
        ),
      ),
    );
    await pumpChatUpdates(tester);

    final field = find.byKey(const Key('chat-message-composer'));
    if (state == _ClassicState.streaming ||
        state == _ClassicState.streamingDraft) {
      await tester.enterText(field, 'Start a turn');
      await tester.tap(find.byKey(const Key('chat-send-message')));
      await tester.pump();
      await tester.pump();
      expect(
        find.byKey(const Key('chat-stop-response')),
        findsOneWidget,
        reason: '$label: turn did not start streaming',
      );
    }
    if (state == _ClassicState.draft || state == _ClassicState.streamingDraft) {
      await tester.enterText(field, _multiLineDraft);
      await tester.pump();
    }
    if (state == _ClassicState.listening) {
      await tester.tap(find.byType(VoiceComposerStartButton));
      await tester.pump();
      await tester.pump();
      expect(
        find.byKey(VoiceComposerIndicator.indicatorKey),
        findsOneWidget,
        reason: '$label: dictation did not start',
      );
    }

    final send = find.byKey(const Key('chat-send-message'));
    final row = tester.getRect(_rowOf(send));
    // The keyed Container's rect includes its outer margin; its decoration
    // (border and fill) is the visible pill.
    final pill = tester.getRect(
      find
          .descendant(
            of: find.byKey(const Key('chat-composer-pill')),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final fieldRect = tester.getRect(field);
    final editable = _editableRect(tester, field);
    final sendRect = tester.getRect(send);

    // Controls right of the field, in row order, ending at the pill's right.
    final controls = <String, Rect>{
      if (find.byKey(const Key('hands-free-start')).evaluate().isNotEmpty)
        'hands-free': tester.getRect(find.byKey(const Key('hands-free-start'))),
      if (find.byType(VoiceComposerStartButton).evaluate().isNotEmpty)
        'mic': tester.getRect(find.byType(VoiceComposerStartButton)),
      'spoken replies': tester.getRect(
        _iconButtonWithIcon(Icons.volume_up).first,
      ),
      if (find.byKey(const Key('chat-stop-response')).evaluate().isNotEmpty)
        'stop': tester.getRect(find.byKey(const Key('chat-stop-response'))),
      'send': sendRect,
    };

    if (_trace) {
      debugPrint(
        'TRACE classic $label | pill ${_r(pill)} | row ${_r(row)} | '
        'field ${_r(fieldRect)} | text ${_r(editable)} | '
        '${controls.entries.map((e) => '${e.key} ${_r(e.value)}').join(' | ')}',
      );
    }
    // The pill draws a 1 dp border and 2 dp padding around the control row.
    checks.near('$label row.right vs pill content', row.right, pill.right - 3);
    checks.near(
      '$label send.right vs composer right',
      sendRect.right,
      row.right,
    );
    var previous = fieldRect;
    var previousName = 'field';
    for (final entry in controls.entries) {
      checks.leftOf(
        '$label $previousName before ${entry.key}',
        previous,
        entry.value,
      );
      checks.inside('$label ${entry.key} in composer', entry.value, row);
      checks.noOverlap('$label ${entry.key}/text', entry.value, editable);
      checks.noOverlap('$label ${entry.key}/field', entry.value, fieldRect);
      previous = entry.value;
      previousName = entry.key;
    }

    if (!turn.isCompleted) turn.complete();
    await pumpChatUpdates(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  }
}

// ------------------------------------------------------------------- main --

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'verbose_mode': false});
    NextGenLook.instance
      ..themeMode = ThemeMode.dark
      ..accent = NgAccent.blue
      ..pureBlack = false
      ..glow = true;
  });
  setUp(mockChatImageRecovery);
  setUp(_mockSpeechPlugin);

  final nextGenCases = <(TargetPlatform, _Window)>[
    for (final platform in [TargetPlatform.windows, TargetPlatform.macOS]) ...[
      for (final window in _desktopWindows) (platform, window),
      (
        platform,
        const _Window(
          '1280x800 docked sidebar',
          Size(1280, 800),
          leadingPane: _ngDockedSidebar,
        ),
      ),
      (
        platform,
        const _Window(
          '900x700 docked sidebar',
          Size(900, 700),
          leadingPane: _ngDockedSidebar,
        ),
      ),
    ],
    (TargetPlatform.android, _phone),
    (TargetPlatform.android, _tablet),
  ];

  final classicCases = <(TargetPlatform, _Window)>[
    for (final platform in [TargetPlatform.windows, TargetPlatform.macOS]) ...[
      for (final window in _desktopWindows) (platform, window),
      (
        platform,
        const _Window(
          '1280x800 list+detail',
          Size(1280, 800),
          leadingPane: _classicListPane,
        ),
      ),
      (
        platform,
        const _Window(
          '900x700 list+detail',
          Size(900, 700),
          leadingPane: _classicListPane,
        ),
      ),
    ],
    (TargetPlatform.android, _phone),
    (TargetPlatform.android, _tablet),
  ];

  group('NextGen composer', () {
    for (final (platform, window) in nextGenCases) {
      for (final textScale in _textScales) {
        testWidgets(
          '${platform.name} ${window.label} x$textScale: send and mic flush '
          'right, clear of the text',
          (tester) async {
            _sizeWindow(tester, window.size);
            final checks = _Checks();
            await _onPlatform(
              platform,
              () => _checkNextGen(
                tester,
                window: window,
                textScale: textScale,
                checks: checks,
              ),
            );
            expect(
              checks.failures,
              isEmpty,
              reason: checks.failures.join('\n'),
            );
          },
        );
      }
    }
  });

  group('Classic composer', () {
    for (final (platform, window) in classicCases) {
      for (final textScale in _textScales) {
        testWidgets(
          '${platform.name} ${window.label} x$textScale: send flush right, '
          'controls clear of the text',
          (tester) async {
            _sizeWindow(tester, window.size);
            final checks = _Checks();
            await _onPlatform(
              platform,
              () => _checkClassic(
                tester,
                window: window,
                textScale: textScale,
                checks: checks,
              ),
            );
            expect(
              checks.failures,
              isEmpty,
              reason: checks.failures.join('\n'),
            );
          },
        );
      }
    }
  });
}
