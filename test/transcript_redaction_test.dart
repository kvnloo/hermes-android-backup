import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/history/transcript_redaction.dart';

void main() {
  const secret = 'sk-ant-api03-SECRETVALUE12';

  test('redacts token shapes and leaves ordinary sentences', () {
    expect(redactSecrets('use $secret please'), 'use [redacted] please');
    expect(redactSecrets('api_key=abcdefghij'), 'api_key=[redacted]');
    expect(containsSecret(redactSecrets('ghp_AB12345678')), isFalse);
    expect(
      redactSecrets('the secret plan is ready'),
      'the secret plan is ready',
    );
  });
}
