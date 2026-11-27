import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/capabilities/capability_admin.dart';

void main() {
  CapabilityAdmin adminWith(CapabilityResponse response) => CapabilityAdmin(
    rest: (method, path, {query, body, timeout}) async => response,
  );

  test('validation carries a reason and retains legacy English', () async {
    final admin = adminWith(const CapabilityResponse(200, '{}'));
    await expectLater(
      admin.skillContent(''),
      throwsA(
        isA<CapabilityException>()
            .having((e) => e.reason, 'reason', CapabilityFailure.chooseASkill)
            .having((e) => e.message, 'message', 'Choose a skill.')
            .having((e) => e.toString(), 'toString', 'Choose a skill.'),
      ),
    );
  });

  test('unreadable gateway responses have a localisable reason', () async {
    await expectLater(
      adminWith(const CapabilityResponse(200, 'not json')).skills(),
      throwsA(
        isA<CapabilityException>().having(
          (e) => e.reason,
          'reason',
          CapabilityFailure.theGatewayReturnedAResponseThatCouldNotBeRead,
        ),
      ),
    );
  });

  test('HTTP fallback preserves status and exact English', () async {
    await expectLater(
      adminWith(const CapabilityResponse(503, 'not json')).skills(),
      throwsA(
        isA<CapabilityException>()
            .having(
              (e) => e.reason,
              'reason',
              CapabilityFailure.theGatewayRefusedTheRequestStatus,
            )
            .having((e) => e.statusCode, 'statusCode', 503)
            .having(
              (e) => e.message,
              'message',
              'The gateway refused the request (503).',
            ),
      ),
    );
  });

  test('missing socket keeps the wire method as structured data', () async {
    await expectLater(
      adminWith(const CapabilityResponse(200, '{}')).plugins(),
      throwsA(
        isA<CapabilityException>()
            .having(
              (e) => e.reason,
              'reason',
              CapabilityFailure
                  .thisConnectionHasNoGatewaySocketSoMethodIsUnavailable,
            )
            .having((e) => e.method, 'method', 'plugins.manage')
            .having(
              (e) => e.message,
              'message',
              'This connection has no gateway socket, so plugins.manage is unavailable.',
            ),
      ),
    );
  });

  test('vault validation exposes no secret in structured failures', () {
    const draft = VaultDraft.login(
      label: '',
      origin: 'https://example.com',
      identifier: 'test',
      password: 'private-test-secret',
    );
    expect(
      draft.secret,
      throwsA(
        isA<VaultFormException>()
            .having((e) => e.reason, 'reason', CapabilityFailure.enterALabel)
            .having((e) => e.message, 'message', 'Enter a label.')
            .having((e) => e.toString(), 'toString', 'Enter a label.'),
      ),
    );
  });

  test('gateway diagnostics are data, not local reason identifiers', () async {
    await expectLater(
      adminWith(
        const CapabilityResponse(403, '{"detail":"Remote policy refusal"}'),
      ).skills(),
      throwsA(
        isA<CapabilityException>()
            .having((e) => e.reason, 'reason', isNull)
            .having((e) => e.message, 'message', 'Remote policy refusal')
            .having((e) => e.statusCode, 'statusCode', 403),
      ),
    );
  });
}
