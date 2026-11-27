// Regression tests cut from the independent review of v5/bots @ d74ba224
// (evidence/bots-review-d74ba224, probes B1-B10). Each test failed on the
// reviewed code and names the probe it replaces.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/screens/bots_screen.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';
import 'package:hermes_android/l10n/app_localizations.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/ui/nextgen_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/bots_review_fixture.dart';
import 'support/fake_rfb_screen.dart';

void wide(WidgetTester tester, [Size size = const Size(900, 1200)]) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// The app going to the background, through the states the platform sends.
void background(WidgetTester tester) {
  for (final state in const [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(state);
  }
}

void foreground(WidgetTester tester) {
  if (tester.binding.lifecycleState == AppLifecycleState.resumed ||
      tester.binding.lifecycleState == null) {
    return;
  }
  for (final state in const [
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(state);
  }
}

void main() {
  group('B7 relay', () {
    test('the fixture refuses bot_relay.deliver without a 32-64 hex id, as '
        'tools/bot_live_delivery.py does', () async {
      final gateway = BotsReviewGateway();
      final refused = await gateway.handle('bot_relay.deliver', {
        'profile': 'workbot',
        'message': 'hello',
        'from_profile': 'work',
        'from_handle': 'work',
        'from_connection': 'c-bots',
      });
      expect(refused['error'], containsPair('code', 4090));
      final accepted = await gateway.handle('bot_relay.deliver', {
        'id': '0123456789abcdef0123456789abcdef',
        'profile': 'workbot',
        'message': 'hello',
      });
      expect(accepted['result'], containsPair('status', 'settled'));
      final unknown = await gateway.handle('bots.not_a_method', {});
      expect(unknown['error'], containsPair('code', -32601));
    });

    testWidgets('there is no Relay tab or Send relay action, and nothing '
        'sends bot_relay.deliver', (tester) async {
      wide(tester);
      final gateway = BotsReviewGateway();
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await botsShown(tester, find.text('WorkBot'));
      expect(find.text('Relay'), findsNothing);
      for (final tab in ['Rooms', 'Screen', 'Routines', 'Roster']) {
        await tester.tap(find.text(tab));
        await botsStep(tester, 4);
        expect(find.text('Relay'), findsNothing);
      }
      await tester.tap(find.text('WorkBot'));
      await botsShown(tester, find.text('Open Bot Chat'));
      expect(find.text('Send relay'), findsNothing);
      expect(gateway.named('bot_relay.deliver'), isEmpty);
      // Every call the screen made was one the gateway accepts.
      expect(gateway.refusals, isEmpty);
    });
  });

  group('B10 New routine form', () {
    Future<BotsReviewGateway> openForm(WidgetTester tester) async {
      wide(tester);
      final gateway = BotsReviewGateway();
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await openBotsRoutinesTab(tester);
      await tester.tap(find.byTooltip('Add routine'));
      await botsStep(tester, 4);
      return gateway;
    }

    FilledButton addButton(WidgetTester tester) =>
        tester.widget<FilledButton>(find.byKey(const Key('bots-routine-add')));

    testWidgets('Add enables as the user types, and a daily routine created '
        'with the defaults keeps running', (tester) async {
      final gateway = await openForm(tester);
      expect(addButton(tester).onPressed, isNull);
      await tester.enterText(
        find.byKey(const Key('bots-routine-title')),
        'Digest',
      );
      await tester.pump();
      expect(addButton(tester).onPressed, isNull, reason: 'no instruction');
      await tester.enterText(
        find.byKey(const Key('bots-routine-instruction')),
        'Summarise the day',
      );
      await tester.pump();
      expect(addButton(tester).onPressed, isNotNull);
      // The run limit starts empty: unlimited.
      final repeat = tester.widget<TextField>(
        find.byKey(const Key('bots-routine-repeat')),
      );
      expect(repeat.controller!.text, isEmpty);
      expect(find.text('Repeat (days)'), findsNothing);

      await tester.tap(find.byKey(const Key('bots-routine-add')));
      await botsStep(tester);
      final add = gateway
          .named('cron.manage')
          .singleWhere((c) => c.params['action'] == 'add');
      expect(add.params['name'], '[bot:workbot] Digest');
      expect(add.params['prompt'], 'Summarise the day');
      expect(add.params['schedule'], '0 9 * * *');
      expect(add.params['profile'], 'workbot');
      expect(add.params.containsKey('repeat'), isFalse);
      // The gateway's own row says the job never retires.
      expect(gateway.jobs['workbot']!.last['repeat'], 'forever');
      expect(gateway.refusals, isEmpty);
      expect(find.byType(AlertDialog), findsNothing);
      await botsShown(tester, find.text('Digest'));
    });

    testWidgets('an interval with a run limit sends "every <n><unit>" and '
        'the limit as a count', (tester) async {
      final gateway = await openForm(tester);
      await tester.enterText(
        find.byKey(const Key('bots-routine-title')),
        'Poll',
      );
      await tester.enterText(
        find.byKey(const Key('bots-routine-instruction')),
        'Check the queue',
      );
      await tester.tap(find.byKey(const Key('bots-routine-schedule-kind')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Interval').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('bots-routine-interval')),
        '2',
      );
      await tester.enterText(find.byKey(const Key('bots-routine-repeat')), '3');
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('bots-routine-add')));
      await tester.tap(find.byKey(const Key('bots-routine-add')));
      await botsStep(tester);
      final add = gateway
          .named('cron.manage')
          .singleWhere((c) => c.params['action'] == 'add');
      expect(add.params['schedule'], 'every 2h');
      expect(add.params['repeat'], 3);
      expect(gateway.jobs['workbot']!.last['repeat'], '3 times');
      expect(gateway.refusals, isEmpty);
    });

    testWidgets('an interval of 0 is not a schedule: Add stays disabled and '
        'nothing is sent', (tester) async {
      final gateway = await openForm(tester);
      await tester.enterText(
        find.byKey(const Key('bots-routine-title')),
        'Digest',
      );
      await tester.enterText(
        find.byKey(const Key('bots-routine-instruction')),
        'Summarise the day',
      );
      await tester.tap(find.byKey(const Key('bots-routine-schedule-kind')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Interval').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('bots-routine-interval')),
        '0',
      );
      await tester.pump();
      expect(addButton(tester).onPressed, isNull);
      expect(
        gateway.named('cron.manage').where((c) => c.params['action'] == 'add'),
        isEmpty,
      );
    });
  });

  group('destructive bot actions ask first; Cancel sends nothing', () {
    final dialog = find.byKey(const Key('bots-confirm-dialog'));
    Future<void> answer(WidgetTester tester, {required bool ok}) async {
      expect(dialog, findsOneWidget);
      await tester.tap(
        find.byKey(Key(ok ? 'bots-confirm-ok' : 'bots-confirm-cancel')),
      );
      await botsStep(tester);
      expect(dialog, findsNothing);
    }

    Future<BotsReviewGateway> open(
      WidgetTester tester, {
      Map<String, dynamic>? display,
      bool routines = false,
    }) async {
      wide(tester, const Size(900, 900));
      final gateway = BotsReviewGateway()..displayOverride = display;
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await (routines
          ? openBotsRoutinesTab(tester)
          : openBotsScreenTab(tester));
      return gateway;
    }

    testWidgets('B2 Stop Bot Desktop', (tester) async {
      final gateway = await open(tester);
      await tester.tap(find.text('Stop'));
      await botsStep(tester, 3);
      expect(find.text('Stop Bot Desktop for workbot?'), findsOneWidget);
      expect(gateway.named('display.stop'), isEmpty);
      await answer(tester, ok: false);
      expect(gateway.named('display.stop'), isEmpty);
      expect(find.text('Running'), findsOneWidget);
      await tester.tap(find.text('Stop'));
      await botsStep(tester, 3);
      await answer(tester, ok: true);
      expect(gateway.named('display.stop'), hasLength(1));
      await botsShown(tester, find.text('Stopped'));
      expect(gateway.refusals, isEmpty);
    });

    testWidgets('B3 Adopt sandbox image', (tester) async {
      final gateway = await open(
        tester,
        display: {
          'image_switch': {'current_image': 'a:1', 'target_image': 'b:2'},
        },
      );
      await botsShown(tester, find.text('Adopt image'));
      await tester.tap(find.text('Adopt image'));
      await botsStep(tester, 3);
      expect(find.text('Adopt the new sandbox image?'), findsOneWidget);
      expect(find.textContaining('a:1 to b:2'), findsOneWidget);
      await answer(tester, ok: false);
      expect(gateway.named('display.switchSandboxImage'), isEmpty);
      await tester.tap(find.text('Adopt image'));
      await botsStep(tester, 3);
      await answer(tester, ok: true);
      final call = gateway.named('display.switchSandboxImage').single;
      expect(call.params['approve'], isTrue);
      expect(call.params['profile'], 'workbot');
      expect(gateway.refusals, isEmpty);
    });

    testWidgets('B4 Remove routine', (tester) async {
      final gateway = await open(tester, routines: true);
      Iterable<BotsReviewCall> removes() => gateway
          .named('cron.manage')
          .where((c) => c.params['action'] == 'remove');
      await tester.tap(find.byTooltip('Remove'));
      await botsStep(tester, 3);
      expect(find.text('Remove routine Stand-up?'), findsOneWidget);
      await answer(tester, ok: false);
      expect(removes(), isEmpty);
      expect(find.text('Stand-up'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove'));
      await botsStep(tester, 3);
      await answer(tester, ok: true);
      expect(removes().single.params, containsPair('name', 'job-standup'));
      await botsShown(tester, find.text('No routines for this bot.'));
      expect(gateway.refusals, isEmpty);
    });
  });

  group('a late reply for another bot is dropped', () {
    Future<void> pickBot(WidgetTester tester, String name) async {
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await botsStep(tester, 6);
      await tester.tap(find.text(name).last);
      await botsStep(tester);
    }

    testWidgets("B5 routines: workbot's list arriving after the switch to "
        'researchbot is not shown', (tester) async {
      wide(tester, const Size(900, 900));
      final gateway = BotsReviewGateway();
      final hold = Completer<void>();
      gateway.holds['cron.manage:workbot:list'] = hold;
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await botsShown(tester, find.text('WorkBot'));
      await tester.tap(find.text('Routines'));
      await botsStep(tester, 3);
      await pickBot(tester, 'researchbot');
      expect(find.text('No routines for this bot.'), findsOneWidget);
      hold.complete();
      await botsStep(tester);
      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.initialValue, 'researchbot');
      expect(find.text('Stand-up'), findsNothing);
      expect(find.text('No routines for this bot.'), findsOneWidget);
    });

    testWidgets("B6 screen: workbot's status arriving after the switch to "
        'researchbot is not shown', (tester) async {
      wide(tester, const Size(900, 900));
      final gateway = BotsReviewGateway();
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await openBotsScreenTab(tester);
      final hold = Completer<void>();
      gateway.holds['display.status:workbot:'] = hold;
      await pickBot(tester, 'researchbot');
      expect(find.text('Not installed'), findsOneWidget);
      // Back to workbot (its status is held), then away again.
      await pickBot(tester, 'workbot');
      await pickBot(tester, 'researchbot');
      expect(find.text('Not installed'), findsOneWidget);
      hold.complete();
      await botsStep(tester);
      expect(find.text('Running'), findsNothing);
      expect(find.text('Not installed'), findsOneWidget);
      // And its thumbnail poll is not left running for the other bot.
      final before = gateway.named('display.thumbnail').length;
      await tester.pump(const Duration(seconds: 9));
      await botsStep(tester, 2);
      expect(gateway.named('display.thumbnail'), hasLength(before));
    });

    testWidgets('a start reply for the bot that was left does not paint the '
        'bot now selected', (tester) async {
      wide(tester, const Size(900, 900));
      final gateway = BotsReviewGateway()..running.clear();
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await botsShown(tester, find.text('WorkBot'));
      await tester.tap(find.text('Screen'));
      await botsShown(tester, find.text('Stopped'));
      final hold = Completer<void>();
      gateway.holds['display.start:workbot:'] = hold;
      await tester.tap(find.text('Start'));
      await botsStep(tester, 2);
      await pickBot(tester, 'researchbot');
      hold.complete();
      await botsStep(tester);
      expect(find.text('Running'), findsNothing);
      expect(find.text('Not installed'), findsOneWidget);
    });
  });

  group('B9 Bot Desktop thumbnail', () {
    const png =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
        '60e6kgAAAABJRU5ErkJggg==';

    testWidgets('the data: URL is decoded in memory and never fetched', (
      tester,
    ) async {
      wide(tester, const Size(900, 900));
      final gateway = BotsReviewGateway()
        ..thumbnailDataUrl = 'data:image/png;base64,$png';
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await openBotsScreenTab(tester);
      final image = tester.widget<Image>(
        find.byKey(const Key('bots-thumbnail-image')),
      );
      expect(image.gaplessPlayback, isTrue);
      var provider = image.image;
      if (provider is ResizeImage) provider = provider.imageProvider;
      expect(provider, isA<MemoryImage>());
      expect((provider as MemoryImage).bytes, base64Decode(png));
      expect(
        find.byWidgetPredicate((w) => w is Image && w.image is NetworkImage),
        findsNothing,
      );
      expect(find.text('Thumbnail unavailable'), findsNothing);
    });

    testWidgets('a frame that is not a bounded image is shown as unavailable', (
      tester,
    ) async {
      wide(tester, const Size(900, 900));
      final gateway = BotsReviewGateway()
        ..thumbnailDataUrl = 'data:text/html;base64,PGI+eDwvYj4=';
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await openBotsScreenTab(tester);
      expect(find.byKey(const Key('bots-thumbnail-image')), findsNothing);
      expect(find.text('Thumbnail unavailable'), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is Image && w.image is NetworkImage),
        findsNothing,
      );
    });

    test('DisplayThumbnail decodes only bounded image data URLs', () {
      Object? bytesOf(String? url) =>
          (DisplayThumbnail.fromJson({'data_url': url}) as dynamic).bytes;
      expect(bytesOf('data:image/png;base64,$png'), base64Decode(png));
      expect(bytesOf(null), isNull);
      expect(bytesOf('https://example.invalid/a.png'), isNull);
      expect(bytesOf('data:text/html;base64,PGI+eDwvYj4='), isNull);
      expect(bytesOf('data:image/png;base64,@@not-base64@@'), isNull);
      final huge = 'data:image/jpeg;base64,${'A' * (6 * 1024 * 1024)}';
      expect(bytesOf(huge), isNull);
    });
  });

  group('B1 Bot Desktop lease', () {
    late List<FakeRfbScreen> screens;
    late int acquiresWhenLive;

    Future<BotsReviewGateway> open(
      WidgetTester tester, {
      Future<FakeRfbScreen> Function()? connect,
    }) async {
      wide(tester, const Size(900, 900));
      addTearDown(() => foreground(tester));
      final gateway = BotsReviewGateway();
      screens = [];
      acquiresWhenLive = -1;
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(
        botsReviewApp(
          owner,
          displayConnector: (target, observe) async {
            expect(observe.ticket, 'ticket-${observe.viewerId}');
            final screen = connect != null
                ? await connect()
                : FakeRfbScreen(
                    onLive: () => acquiresWhenLive = gateway
                        .named('display.lease.acquire')
                        .length,
                  );
            screens.add(screen);
            return screen;
          },
        ),
      );
      await openBotsScreenTab(tester);
      await tester.tap(find.byKey(const Key('bots-take-over')));
      await botsStep(tester);
      return gateway;
    }

    final viewer = find.byKey(const Key('bots-viewer'));
    String status(WidgetTester tester) =>
        tester.widget<Text>(find.byKey(const Key('bots-viewer-status'))).data!;
    Iterable<BotsReviewCall> releases(BotsReviewGateway gateway) =>
        gateway.named('display.lease.release');

    testWidgets('take over opens the live screen first and only then takes '
        'the lease; the background hands it back', (tester) async {
      final gateway = await open(tester);
      expect(viewer, findsOneWidget);
      expect(acquiresWhenLive, 0, reason: 'the screen was live first');
      expect(gateway.leaseOf('workbot')['holder'], 'human');
      expect(gateway.leaseViewer('workbot'), 'viewer-1');
      expect(status(tester), contains('You control this screen'));

      background(tester);
      await botsStep(tester);
      expect(releases(gateway).single.params, {
        'viewer_id': 'viewer-1',
        'profile': 'workbot',
      });
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
      expect(screens.single.closeCode, 1000);
      // Frames resume with the app; the live screen then says what happened.
      foreground(tester);
      await botsStep(tester);
      expect(status(tester), contains('left the foreground'));
      expect(gateway.refusals, isEmpty);
    });

    testWidgets('leaving the bots screen hands the lease back', (tester) async {
      final gateway = await open(tester);
      expect(gateway.leaseOf('workbot')['holder'], 'human');
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await botsStep(tester);
      expect(releases(gateway), hasLength(1));
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
      expect(screens.single.isClosed, isTrue);
      expect(gateway.refusals, isEmpty);
    });

    testWidgets('Hand back closes the live screen and releases', (
      tester,
    ) async {
      final gateway = await open(tester);
      await tester.tap(find.byKey(const Key('bots-viewer-hand-back')));
      await botsStep(tester);
      expect(viewer, findsNothing);
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
      expect(screens.single.closeCode, 1000);
      // Nothing is held, so there is nothing to force back.
      expect(find.byKey(const Key('bots-force-hand-back')), findsNothing);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const Key('bots-take-over')))
            .onPressed,
        isNotNull,
      );
    });

    testWidgets('a dropped live screen hands the lease back', (tester) async {
      final gateway = await open(tester);
      screens.single.drop(1006);
      await botsStep(tester);
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
      expect(status(tester), contains('live view was lost'));
    });

    testWidgets('no live screen, no lease', (tester) async {
      final gateway = await open(
        tester,
        connect: () async => throw const SocketException('refused'),
      );
      expect(viewer, findsNothing);
      expect(gateway.named('display.observe'), hasLength(1));
      expect(gateway.named('display.lease.acquire'), isEmpty);
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
      expect(find.textContaining('Take over failed'), findsOneWidget);
    });

    testWidgets('a screen that refuses the viewer leaves the bot in control', (
      tester,
    ) async {
      final gateway = await open(
        tester,
        connect: () async => FakeRfbScreen(refuse: 'Too many viewers'),
      );
      expect(viewer, findsNothing);
      expect(gateway.named('display.lease.acquire'), isEmpty);
      expect(find.textContaining('Too many viewers'), findsOneWidget);
    });

    testWidgets('after a reconnect the plain release is refused; the lease '
        'is forced back only because it is still this viewer’s', (
      tester,
    ) async {
      final gateway = await open(tester);
      // A new socket: the gateway no longer knows the ids the old one minted.
      gateway.minted.clear();
      await tester.tap(find.byKey(const Key('bots-viewer-hand-back')));
      await botsStep(tester);
      expect(gateway.refusals, hasLength(1));
      expect(releases(gateway).last.params, {
        'force': true,
        'profile': 'workbot',
      });
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
    });

    testWidgets('control taken by someone else is not forced back; the '
        'screen tab offers a confirmed Hand back', (tester) async {
      final gateway = await open(tester);
      final other = await gateway.handle('display.observe', {
        'profile': 'workbot',
      });
      final otherViewer = (other['result'] as Map)['viewer_id'] as String;
      await gateway.handle('display.lease.acquire', {
        'profile': 'workbot',
        'viewer_id': otherViewer,
      });
      screens.single.drop(4000);
      await botsStep(tester);
      expect(status(tester), contains('Someone else took control'));
      expect(gateway.leaseViewer('workbot'), otherViewer);
      expect(
        releases(gateway).where((c) => c.params['force'] == true),
        isEmpty,
      );

      await tester.tap(find.byKey(const Key('bots-viewer-hand-back')));
      await botsStep(tester);
      await tester.tap(find.byKey(const Key('bots-force-hand-back')));
      await botsStep(tester, 3);
      expect(find.byKey(const Key('bots-confirm-dialog')), findsOneWidget);
      await tester.tap(find.byKey(const Key('bots-confirm-cancel')));
      await botsStep(tester);
      expect(gateway.leaseViewer('workbot'), otherViewer);
      await tester.tap(find.byKey(const Key('bots-force-hand-back')));
      await botsStep(tester, 3);
      await tester.tap(find.byKey(const Key('bots-confirm-ok')));
      await botsStep(tester);
      expect(gateway.leaseOf('workbot')['holder'], 'agent');
    });
  });

  group('display.install', () {
    Future<BotsReviewGateway> startInstall(WidgetTester tester) async {
      wide(tester, const Size(900, 1000));
      final gateway = BotsReviewGateway();
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      await tester.pumpWidget(botsReviewApp(owner));
      await openBotsScreenTab(tester);
      // researchbot's host has no screen packages yet.
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await botsStep(tester, 6);
      await tester.tap(find.text('researchbot').last);
      await botsStep(tester);
      expect(find.text('Not installed'), findsOneWidget);
      await tester.tap(find.text('Install'));
      await botsStep(tester);
      expect(gateway.named('display.install').single.params, {
        'profile': 'researchbot',
      });
      return gateway;
    }

    testWidgets('shows the log, answers the sudo prompt only in its own '
        'response, and adopts the status the install ends with', (
      tester,
    ) async {
      const secret = 'fixture-sudo-pass';
      final gateway = await startInstall(tester);
      expect(find.byKey(const Key('bots-install-card')), findsOneWidget);
      expect(find.textContaining('sudo apt-get install'), findsOneWidget);

      gateway.emit('display.install.log', {
        'profile_key': 'key-researchbot',
        'line': 'Reading package lists...',
      });
      // Another profile's install is not this one's output.
      gateway.emit('display.install.log', {
        'profile_key': 'key-workbot',
        'line': 'NOT MINE',
      });
      await botsStep(tester, 2);
      expect(find.textContaining('Reading package lists...'), findsOneWidget);
      expect(find.textContaining('NOT MINE'), findsNothing);

      final answer = gateway.ask('display.install.sudo', {
        'session_id': '',
        'profile_key': 'key-researchbot',
      });
      await botsStep(tester, 4);
      final field = tester.widget<TextField>(
        find.byKey(const Key('bots-sudo-password')),
      );
      expect(field.obscureText, isTrue);
      expect(field.autocorrect, isFalse);
      expect(field.enableSuggestions, isFalse);
      await tester.enterText(
        find.byKey(const Key('bots-sudo-password')),
        secret,
      );
      await tester.tap(find.byKey(const Key('bots-sudo-submit')));
      await botsStep(tester, 4);
      expect(await answer, {'value': secret});
      // Not in any call the app made, and not left on screen.
      expect(
        gateway.calls.where((c) => '${c.params}'.contains(secret)),
        isEmpty,
      );
      expect(find.textContaining(secret), findsNothing);
      expect(find.byKey(const Key('bots-sudo-dialog')), findsNothing);

      gateway.installed.add('researchbot');
      gateway.emit('display.install.done', {
        'profile_key': 'key-researchbot',
        'code': 0,
        'status': gateway.statusOf('researchbot'),
      });
      await botsStep(tester, 4);
      expect(find.byKey(const Key('bots-install-card')), findsNothing);
      expect(find.text('Stopped'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      expect(gateway.refusals, isEmpty);
    });

    testWidgets('a cancelled sudo prompt answers empty, and an install '
        'that ends without sudo says what to do', (tester) async {
      final gateway = await startInstall(tester);
      final answer = gateway.ask('display.install.sudo', {
        'session_id': '',
        'profile_key': 'key-researchbot',
      });
      await botsStep(tester, 4);
      await tester.tap(find.byKey(const Key('bots-sudo-cancel')));
      await botsStep(tester, 4);
      expect(await answer, {'value': ''});

      gateway.emit('display.install.done', {
        'profile_key': 'key-researchbot',
        'code': -2,
        'status': gateway.statusOf('researchbot'),
      });
      await botsStep(tester, 4);
      expect(
        tester.widget<Text>(find.byKey(const Key('bots-install-error'))).data,
        contains('sudo is not available'),
      );
      expect(find.text('Not installed'), findsOneWidget);
      // The watch ended with the install: a later prompt is not taken.
      expect(
        await gateway.ask('display.install.sudo', {
          'session_id': '',
          'profile_key': 'key-researchbot',
        }),
        isNull,
      );
    });
  });

  group('Bot Chat runs on the bot’s own profile', () {
    testWidgets('the roster opens the chat scoped to the bot, not to the '
        'connection’s profile', (tester) async {
      wide(tester);
      final gateway = BotsReviewGateway();
      final owner = botsReviewOwner(gateway);
      addTearDown(owner.close);
      final opened = <BotChatPage>[];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home:
              Function.apply(BotsScreen.new, const [], {
                    #owner: owner,
                    #route: owner.route(),
                    #connection: botsReviewConnection,
                    #openBotChat:
                        (BuildContext context, BotChatPage page) async {
                          opened.add(page);
                        },
                  })
                  as Widget,
        ),
      );
      await botsShown(tester, find.text('ResearchBot'));
      await tester.tap(find.text('ResearchBot'));
      await botsShown(tester, find.text('Open Bot Chat'));
      await botsStep(tester); // the sheet has slid in
      await tester.tap(find.text('Open Bot Chat'));
      await botsStep(tester);
      final page = opened.single;
      // The chat was found (here: minted) in researchbot's profile...
      expect(
        gateway.named('session.list').single.params['profile'],
        'researchbot',
      );
      expect(page.storedId, 'sess-canonical-researchbot');
      // ...and is opened there, while the saved connection stays on 'work'.
      expect(page.connection.gatewayProfile, 'work');
      final scoped = (page as dynamic).chatConnection as SavedConnection;
      expect(scoped.gatewayProfile, 'researchbot');
      expect(scoped.id, page.connection.id);
      expect(scoped.host, page.connection.host);
    });

    Widget page(Map<Symbol, dynamic> seams) =>
        Function.apply(BotChatPage.new, const [], {
              #connection: botsReviewConnection,
              #storedId: 'sess-canonical-researchbot',
              #title: 'Bot Chat',
              #profile: 'researchbot',
              ...seams,
            })
            as Widget;

    testWidgets('Classic shows its own chat screen on the scoped connection', (
      tester,
    ) async {
      final seen = <(SavedConnection, Session)>[];
      await tester.pumpWidget(
        MaterialApp(
          home: page({
            #classicChatBuilder: (SavedConnection connection, Session session) {
              seen.add((connection, session));
              return const Text('classic chat');
            },
          }),
        ),
      );
      await tester.pump();
      expect(find.text('classic chat'), findsOneWidget);
      expect(seen.last.$1.gatewayProfile, 'researchbot');
      expect(seen.last.$1.id, botsReviewConnection.id);
      expect(seen.last.$2.id, 'sess-canonical-researchbot');
      expect(botsReviewConnection.gatewayProfile, 'work');
    });

    testWidgets('NextGen builds a gateway of its own for the bot’s profile', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final ambient = NextGenGateway(botsReviewConnection);
      addTearDown(ambient.dispose);
      final seen = <SavedConnection>[];
      Future<void> never([Object? _]) async {}
      await tester.pumpWidget(
        NgScope(
          connManager: ConnectionManager(prefs, nativePushSupported: false),
          gateway: ambient,
          connections: [botsReviewConnection],
          switchTo: never,
          addGateway: never,
          signOut: never,
          reload: never,
          signInAgain: never,
          child: MaterialApp(
            home: page({
              #gatewayFactory: (SavedConnection connection) {
                seen.add(connection);
                throw StateError('fixture stops here');
              },
            }),
          ),
        ),
      );
      await tester.pump();
      expect(seen.single.gatewayProfile, 'researchbot');
      expect(ambient.profile, 'work');
      expect(find.textContaining('fixture stops here'), findsOneWidget);
    });

    test(
      'a gateway on the scoped connection is owned by the bot’s profile',
      () {
        final scoped = botsReviewConnection.copyWith(
          gatewayProfile: 'researchbot',
        );
        final gateway = NextGenGateway(scoped);
        addTearDown(gateway.dispose);
        expect(gateway.profile, 'researchbot');
        expect(gateway.workspace.profile, 'researchbot');
        expect(gateway.workspace.connectionId, botsReviewConnection.id);
      },
    );
  });
}
