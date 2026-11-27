import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/hermes_deeplink.dart';

void main() {
  group('parseHermesDeepLink', () {
    test('launch route is accepted and does not navigate', () {
      final link = parseHermesDeepLink('hermes://launch')!;
      expect(link.kind, HermesDeepLinkKind.launch);
      expect(link.isIgnored, isFalse);
    });

    test('open route with a safe path', () {
      final link = parseHermesDeepLink('hermes://open/settings/appearance')!;
      expect(link.kind, HermesDeepLinkKind.open);
      expect(link.path, '/settings/appearance');
    });

    test('open route rejects traversal, backslashes, and colons', () {
      for (final url in [
        'hermes://open/../etc/passwd',
        'hermes://open/a\\b',
        'hermes://open/a:b',
        'hermes://open/',
      ]) {
        expect(parseHermesDeepLink(url)!.isIgnored, isTrue, reason: url);
      }
    });

    test('open route rejects unknown params but keeps allowlisted ones', () {
      final link = parseHermesDeepLink(
        'hermes://open/settings?session=abc123&prefill=hello&arbitrary=nope',
      )!;
      expect(link.kind, HermesDeepLinkKind.open);
      expect(link.prefill, 'hello');
      expect(link.params.containsKey('session'), isTrue);
      expect(link.params.containsKey('arbitrary'), isFalse);
    });

    test('settings route requires a known tab', () {
      final ok = parseHermesDeepLink('hermes://settings/appearance')!;
      expect(ok.kind, HermesDeepLinkKind.settings);

      final bad = parseHermesDeepLink('hermes://settings/unknown-tab')!;
      expect(bad.isIgnored, isTrue);
    });

    test('session route validates the id', () {
      final ok = parseHermesDeepLink('hermes://session/abc-123_xyz.1')!;
      expect(ok.kind, HermesDeepLinkKind.session);
      expect(ok.sessionId, 'abc-123_xyz.1');

      final bad = parseHermesDeepLink('hermes://session/not valid!')!;
      expect(bad.isIgnored, isTrue);
    });

    test('session prefill is sanitized', () {
      final link = parseHermesDeepLink(
        'hermes://session/abc?prefill=hello%3Ctag%3E',
      )!;
      expect(link.sessionId, 'abc');
      // The prefill is sanitized, never executed.
      expect(link.prefill, contains('hello'));
    });

    test('non-hermes schemes are ignored', () {
      for (final url in [
        'https://evil.com/open/settings',
        'file:///etc/passwd',
        'HTTP://example.com',
        'settings/appearance',
        '',
        'hermes://',
      ]) {
        expect(parseHermesDeepLink(url)!.isIgnored, isTrue, reason: url);
      }
    });

    test('describeHermesDeepLink never echoes a session id', () {
      final link = parseHermesDeepLink('hermes://session/abc-123')!;
      final desc = describeHermesDeepLink(link);
      expect(desc, isNot(contains('abc-123')));
    });

    test('launch route ignores trailing path and query completely', () {
      final link = parseHermesDeepLink('hermes://launch/extra?prefill=evil')!;
      expect(link.kind, HermesDeepLinkKind.launch);
      expect(link.prefill, isNull);
      expect(link.path, isNull);
    });

    test('chat alias parses identically to session route', () {
      final link = parseHermesDeepLink(
        'hermes://chat/chat-42?prefill=Draft+hi',
      )!;
      expect(link.kind, HermesDeepLinkKind.session);
      expect(link.sessionId, 'chat-42');
      expect(link.prefill, 'Draft hi');
    });

    test('malformed percent-encoding returns ignore without throwing', () {
      for (final raw in [
        'hermes://session/abc?prefill=%ZZ',
        'hermes://open/settings?prefill=100%',
        'hermes://skill/install?identifier=%E0%A4%A',
      ]) {
        final link = parseHermesDeepLink(raw)!;
        expect(link.isIgnored, isTrue, reason: raw);
      }
    });

    test(
      'install routes validate target and identifier without echoing ids',
      () {
        final skill = parseHermesDeepLink(
          'hermes://skill/install?identifier=nous/weather-skill',
        )!;
        expect(skill.kind, HermesDeepLinkKind.install);
        expect(skill.installTarget, 'skill');
        expect(skill.installId, 'nous/weather-skill');
        expect(describeHermesDeepLink(skill), 'install skill');

        final plugin = parseHermesDeepLink(
          'hermes://plugin/install?catalog=kanban',
        )!;
        expect(plugin.kind, HermesDeepLinkKind.install);
        expect(plugin.installTarget, 'plugin');
        expect(plugin.installId, 'kanban');

        final mcp = parseHermesDeepLink('hermes://mcp/install?name=mempalace')!;
        expect(mcp.kind, HermesDeepLinkKind.install);
        expect(mcp.installTarget, 'mcp');
        expect(mcp.installId, 'mempalace');

        for (final rejected in [
          'hermes://skill/exec?identifier=demo',
          'hermes://skill/install?identifier=../escape',
          'hermes://plugin/install?repo=https://evil.test/repo',
          'hermes://plugin/install?catalog=bad\\path',
          'hermes://mcp/install?name=',
          'hermes://mcp/install?name=bad space',
        ]) {
          expect(
            parseHermesDeepLink(rejected)!.isIgnored,
            isTrue,
            reason: rejected,
          );
        }
      },
    );
  });

  group('HermesDeepLinkService', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test(
      'consumes initial link and runtime channel callbacks safely',
      () async {
        const channel = MethodChannel('test.ares/deeplink');
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'getInitialLink') {
                return 'hermes://launch';
              }
              return null;
            });
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null),
        );

        final service = HermesDeepLinkService(channel: channel);
        addTearDown(service.dispose);
        await service.initialize();
        expect(service.launchCount, 1);
        expect(service.pendingLink.value, isNull);

        expect(service.handleRawLink('https://untrusted.example/x'), isFalse);
        expect(service.pendingLink.value, isNull);

        expect(
          service.handleRawLink('hermes://session/sess-7?prefill=hello'),
          isTrue,
        );
        expect(service.pendingLink.value?.sessionId, 'sess-7');
        expect(service.pendingLink.value?.prefill, 'hello');
        final taken = service.takePendingLink();
        expect(taken?.sessionId, 'sess-7');
        expect(service.pendingLink.value, isNull);
      },
    );
  });
}
