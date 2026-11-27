import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/chat_screen.dart';
import 'package:hermes_android/core/screens/files_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/gateway_turn_application_controller.dart';
import 'package:hermes_android/core/widgets/markdown_file_preview.dart';
import 'package:hermes_android/core/widgets/session_files_view.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/chat_controller.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/nextgen_preferences.dart';
import 'package:hermes_android/nextgen/theme/nextgen_theme.dart';
import 'package:hermes_android/nextgen/ui/chat_view.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_voice_composer_adapter.dart';
import 'support/markdown_file_fixture.dart';
import 'support/pump_chat_updates.dart';
import 'support/session_files_gateway.dart';
import 'support/audio_preview_fixture.dart';

enum _Chat { classic, nextGen }

// Keep Flutter's network isolation for everything except this test's server,
// including the remote image embedded in the Markdown preview fixture.
class _FixtureOnly extends HttpOverrides {
  _FixtureOnly(this.port);
  final int port;
  final blocked = <Uri>[];

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..findProxy = ((_) => 'DIRECT')
        ..connectionFactory = (uri, _, _) {
          if (uri.host != '127.0.0.1' || uri.port != port) {
            blocked.add(uri);
            throw StateError('Request outside the Session files fixture: $uri');
          }
          return Socket.startConnect(InternetAddress.loopbackIPv4, port);
        };
}

Finder get _pane => find.byType(SessionFilesView);
Finder _inside(Finder match) => find.descendant(of: _pane, matching: match);
Finder get _file => _inside(find.text(SessionFilesGateway.name));
Finder get _source => _inside(find.byType(TextField));
Finder _composer(_Chat chat, {bool skipOffstage = true}) => find.byKey(
  ValueKey(
    chat == _Chat.classic ? 'chat-message-composer' : 'ng-composer-field',
  ),
  skipOffstage: skipOffstage,
);

// Socket and HTTP replies advance in real time; pump only until the requested
// UI is present (dialogs can animate while the pane still has a busy bar).
Future<void> _wait(WidgetTester tester, Finder match) async {
  for (var i = 0; i < 250; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    if (match.evaluate().isNotEmpty) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
  }
  expect(match, findsOneWidget);
}

Future<void> _waitCondition(WidgetTester tester, bool Function() done) async {
  for (var i = 0; i < 250 && !done(); i++) {
    await tester.pump(const Duration(milliseconds: 16));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
  }
  expect(done(), isTrue);
}

Future<void> _tap(WidgetTester tester, Finder match) async {
  await _wait(tester, match.hitTestable());
  await tester.tap(match.hitTestable());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _withChat(
  WidgetTester tester,
  _Chat shell,
  Future<void> Function(SessionFilesGateway wire) exercise, {
  String terminalBackend = 'local',
  bool draft = false,
  AudioFixture? audio,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 900);
  addTearDown(tester.view.reset);
  final wire = (await tester.runAsync(SessionFilesGateway.start))!;
  wire.terminalBackend = terminalBackend;
  wire.audioFiles = audio != null;
  final connection = wire.connection;
  final previous = HttpOverrides.current;
  final network = _FixtureOnly(connection.port);
  HttpOverrides.global = network;
  addTearDown(() => HttpOverrides.global = previous);
  final Widget home;
  final Future<void> Function() close;
  if (shell == _Chat.classic) {
    final owner = GatewayTurnApplicationController();
    close = owner.close;
    home = ChatScreen(
      connection: connection,
      session: Session(
        id: draft ? 'local-draft' : SessionFilesGateway.session,
        title: 'Field chat',
        model: 'fixture',
        source: 'desktop',
        messageCount: draft ? 0 : 1,
        isActive: false,
        preview: '',
        startedAt: 1,
        isLocalDraft: draft,
      ),
      turnApplicationController: owner,
      testVoiceComposerAdapter: FakeVoiceComposerAdapter(),
      testDesktopGateway: (gateway) {
        wire.rebindClient = () async {
          wire.runtime = 'live-field-rebound';
          await gateway.call('session.resume', {
            'session_id': SessionFilesGateway.session,
            'source': 'desktop',
            'omit_messages': true,
            'defer_history': true,
          });
        };
      },
    );
  } else {
    final gateway = NextGenGateway(connection);
    wire.rebindClient = () async {
      wire.runtime = 'live-field-rebound';
      await gateway.call('session.resume', {
        'session_id': SessionFilesGateway.session,
        'source': 'desktop',
        'omit_messages': true,
        'defer_history': true,
      });
    };
    final chat = NgChatController(
      gateway,
      sessionId: SessionFilesGateway.session,
      title: 'Field chat',
    );
    close = () async {
      chat.dispose();
      gateway.dispose();
    };
    await tester.runAsync(chat.open);
    home = NgScope(
      gateway: gateway,
      connManager: ConnectionManager(await SharedPreferences.getInstance()),
      connections: [connection],
      switchTo: (_) async {},
      addGateway: () async {},
      signOut: (_) async {},
      reload: () async {},
      signInAgain: () async {},
      child: NgChatView(chat: chat, onOpenSidebar: () {}, onNewChat: () {}),
    );
  }
  try {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: shell == _Chat.nextGen
            ? nextGenTheme(Brightness.light, NextGenLook.instance)
            : null,
        builder: (context, child) => audio?.wrap(child!) ?? child!,
        home: home,
      ),
    );
    if (draft) {
      await _wait(tester, find.bySemanticsLabel('Add attachment'));
    } else {
      await _wait(
        tester,
        find.text(SessionFilesGateway.transcript, findRichText: true),
      );
    }
    expect(_pane, findsNothing);
    await exercise(wire);
    expect(network.blocked, isEmpty);
    expect(wire.methods, isNot(contains('prompt.submit')));
    expect(wire.methods, isNot(contains('session.create')));
    expect(
      wire.requests.map((r) => r.$2.path),
      isNot(contains('/api/fs/write-text')),
    );
    expect(tester.takeException(), isNull);
  } finally {
    final gate = wire.audioGate;
    if (gate != null && !gate.isCompleted) gate.complete();
    await tester.pumpWidget(const SizedBox.shrink());
    await close();
    await tester.runAsync(wire.close);
    await tester.pump(const Duration(seconds: 16));
  }
}

Future<void> _openFolder(WidgetTester tester) async {
  await _tap(tester, find.byTooltip('Session files'));
  await _tap(tester, _inside(find.text('docs')));
  await _wait(tester, _file);
}

/// Pinned to hermes-agent b7ee21c14e `REFERENCE_PATTERN`.
final _gatewayReference = RegExp(
  r'''(?<![\w/])@(?:(?:diff|staged)\b|(?:file|folder|git|url):(?:(?:`[^`\n]+`|"[^"\n]+"|'[^'\n]+')(?::\d+(?:-\d+)?)?|\S+))''',
);

List<String> _gatewayRefs(String text) =>
    _gatewayReference.allMatches(text).map((match) => match.group(0)!).toList();

Future<void> _openNamed(WidgetTester tester, String name) async {
  await _tap(tester, find.byTooltip('Session files'));
  await _tap(tester, _inside(find.text(name)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(mockChatImageRecovery);
  setUp(() => SharedPreferences.setMockInitialValues({'verbose_mode': false}));

  for (final shell in _Chat.values) {
    for (final held in [true, false]) {
      testWidgets(
        '${shell.name}: audio rejects same-owner same-route runtime replacement (held=$held)',
        (tester) async {
          final audio = AudioFixture();
          await _withChat(tester, shell, (wire) async {
            if (held) wire.audioGate = Completer<void>();
            await _openNamed(tester, SessionFilesGateway.audioName);
            final original = tester.widget<SessionFilesView>(_pane);
            final play = _inside(
              find.byKey(const Key('attachment-audio-play-pause')),
            );
            await _wait(tester, play);
            await _tap(tester, play);
            await _waitCondition(tester, () => wire.audioEntered.isCompleted);
            if (!held) await _wait(tester, _inside(find.byTooltip('Pause')));
            var rebound = false;
            Object? rebindError;
            unawaited(
              wire.rebindClient!().then<void>(
                (_) => rebound = true,
                onError: (Object error) {
                  rebindError = error;
                  rebound = true;
                },
              ),
            );
            await _waitCondition(tester, () => rebound);
            expect(rebindError, isNull);
            final replacement = tester.widget<SessionFilesView>(_pane);
            expect(identical(original.owner, replacement.owner), isTrue);
            expect(original.route, replacement.route);
            wire.audioGate?.complete();
            await pumpChatUpdates(tester);
            if (held) {
              expect(
                audio.players,
                isEmpty,
                reason: 'The old download must never create a native player.',
              );
            } else {
              expect(audio.players.single.disposals, 1);
              expect(audio.store.files.single.closes, 1);
            }
            final control = tester.widget<IconButton>(play);
            expect(control.onPressed, isNull);
          }, audio: audio);
        },
      );
    }

    testWidgets(
      '${shell.name}: session file audio uses the owning gateway and stops when returning to the tree',
      (tester) async {
        final audio = AudioFixture();
        await _withChat(tester, shell, (wire) async {
          await _openNamed(tester, SessionFilesGateway.audioName);
          final play = _inside(
            find.byKey(const Key('attachment-audio-play-pause')),
          );
          await _wait(tester, play);
          expect(audio.players, isEmpty);
          expect(
            wire.requests.where((r) => r.$2.path == '/api/fs/download'),
            isEmpty,
          );
          await _tap(tester, play);
          await _wait(tester, _inside(find.byTooltip('Pause')));
          expect(audio.players.single.plays, 1);
          final download = wire.requests
              .singleWhere((r) => r.$2.path == '/api/fs/download')
              .$2;
          expect(
            download.queryParameters['profile'],
            SessionFilesGateway.profile,
          );
          expect(
            download.queryParameters['session_id'],
            SessionFilesGateway.session,
          );
          await _tap(tester, _inside(find.byType(IconButton)).first);
          await pumpChatUpdates(tester);
          expect(audio.players.single.disposals, 1);
          expect(audio.store.files.single.closes, 1);
        }, audio: audio);
      },
    );

    testWidgets(
      '${shell.name}: Session files refreshes an expanded tree, previews Markdown and attaches to the existing draft across a resize',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          final composer = _composer(shell);
          await tester.enterText(composer, 'My unsent question');
          final draft = tester.widget<TextField>(composer).controller!;
          await _openFolder(tester);
          expect(
            composer,
            findsNothing,
            reason: 'Phone: only the pane is visible.',
          );
          expect(
            tester
                .widget<TextField>(_composer(shell, skipOffstage: false))
                .controller,
            same(draft),
          );
          expect(_inside(find.text('before.txt')), findsOneWidget);
          wire.sibling = 'after.txt';
          await _tap(tester, find.byTooltip('Refresh tree'));
          await _wait(tester, _inside(find.text('after.txt')));
          expect(_inside(find.text('before.txt')), findsNothing);
          await _tap(tester, _file);
          await _wait(tester, find.byType(MarkdownFilePreview));
          await verifyMarkdownPreview(tester);

          tester.view.physicalSize = const Size(1120, 900);
          await tester.pumpAndSettle();
          expect(
            tester.getRect(composer).right,
            lessThanOrEqualTo(tester.getRect(_pane).left),
            reason: 'Wide: the composer and pane do not overlap.',
          );
          expect(
            find.text(SessionFilesGateway.transcript, findRichText: true),
            findsOneWidget,
          );
          await _tap(tester, _inside(find.text('Select lines')));
          final field = tester.widget<TextField>(_source);
          expect(field.readOnly, isTrue);
          expect(field.controller!.text, markdownFixture);
          // Set a selection just as the platform text controls do. An end offset
          // at the next line's start must not include that next line.
          field.controller!.selection = TextSelection(
            baseOffset: markdownFixture.indexOf('## Observations'),
            extentOffset: markdownFixture.indexOf('- Gamma'),
          );
          await _tap(tester, _inside(find.text('Attach selected lines')));
          await _wait(tester, find.byTooltip('Session files'));
          expect(_pane, findsNothing);
          expect(tester.widget<TextField>(composer).controller, same(draft));
          expect(
            draft.text,
            'My unsent question\n@file:${SessionFilesGateway.path}:3-5 ',
          );
          expect(wire.replacements, isEmpty);
        });
      },
    );
    testWidgets(
      '${shell.name}: guarded save preserves a conflicting draft, reviews the current host version, then saves and reads it back',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          await _openNamed(tester, SessionFilesGateway.leaf);
          await _tap(tester, _inside(find.text('Edit')));
          const edit = '# My reconciled café notes\n';
          const other = '# Changed on the gateway\n';
          await tester.enterText(_source, edit);
          wire.competingWrite = other;
          await _tap(tester, _inside(find.text('Save')));
          expect(
            wire.replacements,
            isEmpty,
            reason: 'Confirmation precedes dispatch.',
          );
          await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));
          final review = _inside(find.text('Review gateway version'));
          await _wait(tester, review);
          expect(wire.replacements.single, {
            'session_id': SessionFilesGateway.session,
            'cwd': SessionFilesGateway.root,
            'path': SessionFilesGateway.leafPath,
            'expected_sha256': SessionFilesGateway.hash(markdownFixture),
            'content': edit,
          });
          expect(wire.text, other);
          expect(tester.widget<TextField>(_source).controller!.text, edit);
          expect(
            tester
                .widget<TextButton>(
                  _inside(find.widgetWithText(TextButton, 'Save')),
                )
                .onPressed,
            isNull,
          );
          await _tap(tester, review);
          await _wait(
            tester,
            find.descendant(
              of: find.byType(AlertDialog),
              matching: find.text(other),
            ),
          );
          await _tap(tester, find.text('Keep draft against this version'));
          expect(
            wire.replacements,
            hasLength(1),
            reason: 'Review is not confirmation to write.',
          );
          expect(tester.widget<TextField>(_source).controller!.text, edit);
          await _tap(tester, _inside(find.text('Save')));
          await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));
          await _wait(
            tester,
            _inside(find.text('Saved and verified on the gateway.')),
          );
          expect(wire.replacements.map((p) => p['expected_sha256']), [
            SessionFilesGateway.hash(markdownFixture),
            SessionFilesGateway.hash(other),
          ]);
          expect(wire.text, edit);
          expect(
            wire.reads.last,
            edit,
            reason: 'A receipt alone does not verify the bytes.',
          );
          expect(
            _inside(find.text('My reconciled café notes', findRichText: true)),
            findsOneWidget,
          );
        });
      },
    );
    testWidgets(
      '${shell.name}: reloading a preflight conflict discards only the file draft without sending a write',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          await tester.enterText(_composer(shell), 'Separate chat draft');
          await _openNamed(tester, SessionFilesGateway.leaf);
          await _tap(tester, _inside(find.text('Edit')));
          await tester.enterText(_source, 'Discard this file draft');
          wire.text = '# New host text before save';
          await _tap(tester, _inside(find.text('Save')));
          await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));
          final review = _inside(find.text('Review gateway version'));
          await _wait(tester, review);
          expect(wire.reads.last, wire.text);
          wire.text = '# Latest at review';
          await _tap(tester, review);
          await _wait(
            tester,
            find.descendant(
              of: find.byType(AlertDialog),
              matching: find.text(wire.text),
            ),
          );
          await _tap(tester, find.text('Discard draft and reload'));
          expect(
            _inside(find.text('Latest at review', findRichText: true)),
            findsOneWidget,
          );
          expect(_source, findsNothing);
          await _tap(tester, find.byTooltip('Back to tree'));
          await _tap(tester, find.byTooltip('Close session files'));
          expect(
            tester.widget<TextField>(_composer(shell)).controller!.text,
            'Separate chat draft',
          );
          expect(wire.replacements, isEmpty);
        });
      },
    );
    testWidgets(
      '${shell.name}: review: file references match the gateway grammar',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          final composer = _composer(shell);
          await tester.enterText(composer, 'My unsent question');
          await _openFolder(tester);
          await _tap(tester, _file);
          await _tap(tester, _inside(find.text('Select lines')));
          final field = tester.widget<TextField>(_source);
          field.controller!.selection = TextSelection(
            baseOffset: markdownFixture.indexOf('## Observations'),
            extentOffset: markdownFixture.indexOf('- Gamma'),
          );
          await _tap(tester, _inside(find.text('Attach selected lines')));
          await _wait(tester, find.byTooltip('Session files'));
          expect(
            _gatewayRefs(tester.widget<TextField>(composer).controller!.text),
            ['@file:${SessionFilesGateway.path}:3-5'],
          );
          await _tap(tester, find.byTooltip('Session files'));
          final spaced = _inside(find.text(SessionFilesGateway.spaced));
          await _wait(tester, spaced);
          await tester.ensureVisible(spaced);
          await _tap(
            tester,
            find.byTooltip('Actions for ${SessionFilesGateway.spaced}'),
          );
          await _tap(tester, find.text('Attach file reference'));
          await _wait(tester, find.byTooltip('Session files'));
          expect(
            _gatewayRefs(tester.widget<TextField>(composer).controller!.text),
            [
              '@file:${SessionFilesGateway.path}:3-5',
              '@file:`${SessionFilesGateway.spacedPath}`',
            ],
          );
          expect(wire.replacements, isEmpty);
        });
      },
    );
    testWidgets(
      '${shell.name}: review: a confirmed directory change reloads the tree',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          await _tap(tester, find.byTooltip('Session files'));
          await _wait(tester, _inside(find.text('docs')));
          await _tap(tester, find.byTooltip('Change working directory'));
          final field = find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextFormField),
          );
          await _wait(tester, field);
          await tester.enterText(field, '${SessionFilesGateway.folder}/');
          await _tap(
            tester,
            find.widgetWithText(FilledButton, 'Change directory'),
          );
          await _wait(tester, _inside(find.text(SessionFilesGateway.name)));
          expect(wire.mutations, hasLength(1));
          expect(wire.mutations.single['payload'], {
            'cwd': SessionFilesGateway.folder,
          });
          expect(wire.cwd, SessionFilesGateway.folder);
          expect(find.byTooltip('Change working directory'), findsOneWidget);
          expect(
            find.text(
              'The gateway returned an unsafe path or invalid file response.',
            ),
            findsNothing,
          );
        });
      },
    );
    testWidgets(
      '${shell.name}: review: guarded save is offered only when it can succeed',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          await _openNamed(tester, SessionFilesGateway.leaf);
          await _wait(tester, _inside(find.text('Edit')));
          await _tap(tester, find.byTooltip('Back to tree'));
          await _tap(tester, _inside(find.text('docs')));
          await _tap(tester, _inside(find.text(SessionFilesGateway.name)));
          await _wait(
            tester,
            _inside(
              find.text(
                'Only a file directly in the working directory can be saved.',
              ),
            ),
          );
          expect(_inside(find.text('Edit')), findsNothing);
          await _tap(tester, find.byTooltip('Back to tree'));
          await _tap(tester, _inside(find.text(SessionFilesGateway.hidden)));
          await _wait(
            tester,
            _inside(find.text("Hidden files can't be saved by the gateway.")),
          );
          expect(_inside(find.text('Edit')), findsNothing);
          await _tap(tester, find.byTooltip('Back to tree'));
          await tester.ensureVisible(
            _inside(find.text(SessionFilesGateway.database)),
          );
          await _tap(tester, _inside(find.text(SessionFilesGateway.database)));
          await _wait(
            tester,
            _inside(find.text("This file can't be saved by the gateway")),
          );
          expect(_inside(find.text('Edit')), findsNothing);
          expect(wire.replacements, isEmpty);
        });
      },
    );
    testWidgets('${shell.name}: review: a stock gateway stays read-only', (
      tester,
    ) async {
      await _withChat(tester, shell, (wire) async {
        wire.stock = true;
        await _openNamed(tester, SessionFilesGateway.leaf);
        await _wait(
          tester,
          _inside(find.text("Guarded saving isn't available on this gateway")),
        );
        expect(_inside(find.text('Edit')), findsNothing);
        expect(wire.replacements, isEmpty);
      });
    });
    testWidgets(
      '${shell.name}: review: a refused save names the gateway limit',
      (tester) async {
        await _withChat(tester, shell, (wire) async {
          wire.forbidSave = true;
          await _openNamed(tester, SessionFilesGateway.leaf);
          await _tap(tester, _inside(find.text('Edit')));
          await tester.enterText(_source, '# edited\n');
          await _tap(tester, _inside(find.text('Save')));
          await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));
          await _wait(
            tester,
            _inside(find.text("This file can't be saved by the gateway")),
          );
          expect(
            _inside(find.text('The gateway denied this operation.')),
            findsNothing,
          );
        });
      },
    );
  }

  testWidgets(
    'classic: review: non-local backend keeps the server file browser',
    (tester) async {
      await _withChat(tester, _Chat.classic, (wire) async {
        for (
          var i = 0;
          i < 50 && !wire.methods.contains('session.resume');
          i++
        ) {
          await tester.pump(const Duration(milliseconds: 16));
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 10)),
          );
        }
        expect(wire.methods, contains('session.resume'));
        await _tap(tester, find.bySemanticsLabel('Add attachment'));
        await _tap(tester, find.text('Browse server files'));
        await _wait(tester, find.byType(FilesScreen));
        expect(find.byType(SessionFilesView), findsNothing);
        expect(
          find.text('Start the session before attaching gateway files.'),
          findsNothing,
        );
      }, terminalBackend: 'ssh');
    },
  );

  testWidgets('classic: review: a draft chat keeps the server file browser', (
    tester,
  ) async {
    await _withChat(tester, _Chat.classic, (wire) async {
      await _tap(tester, find.bySemanticsLabel('Add attachment'));
      await _tap(tester, find.text('Browse server files'));
      await _wait(tester, find.byType(FilesScreen));
      expect(find.byType(SessionFilesView), findsNothing);
      expect(
        find.text('Start the session before attaching gateway files.'),
        findsNothing,
      );
    }, draft: true);
  });
}
