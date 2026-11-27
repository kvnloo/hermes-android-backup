// Redaction false positives (review probes R1-R4, R6) and the shapes the
// gateway's force-mode export redaction handles (b7ee21c14e agent/redact.py;
// expected outputs in the review's py_gateway_redact.out and
// py_gateway_redact_benign.out, with this app's mark in place of `***`).
//
// On 172cfd30 the secret check matched its own replacement
// (`api_key=[redacted]`), prose ("The secret: rotate-weekly-please") and
// benign code (`os.environ["OPENAI_API_KEY"]`), so a redacted export
// failed, saved rows vanished from the history list and a foreign preview
// with an already-redacted header refused to open.
// Wall-clock budgets: the full suite runs this file alone (-j1) via the
// 'perf' tag (dart_test.yaml), so parallel load can't fail it.
@Tags(['perf'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/history/transcript_redaction.dart';
import 'package:hermes_android/core/services/remote_workspace.dart';

/// Token-shaped fixtures, assembled so no scanner reads them as real.
final _openAi = 'sk-${'proj1234abcdefghijklmnopqrstuvwx'}';
final _google = 'ya29.${'a0AbCdEfGhIjKlMnOpQrStUvWxYz012345'}';

void main() {
  group('R1: redacted output never holds a secret', () {
    final lines = <String>[
      'api_key = os.environ["OPENAI_API_KEY"]',
      'The secret: rotate-weekly-please is our policy',
      'Authorization: Bearer ***',
      'access_token=abcdefgh12345678',
      'api_key=***',
      'api_key=[redacted]',
      "curl -H 'Authorization: token ***' https://api.github.com",
      'api_key: $_openAi',
      'export OPENAI_API_KEY=$_openAi',
      'secret = hunter2hunter2hunter2',
      'see https://user:hunter2hunter2@db.example/app?token=abcdef123456',
    ];
    for (final line in lines) {
      test(line, () {
        final redacted = redactSecrets(line);
        expect(containsSecret(redacted), isFalse);
        expect(redactSecrets(redacted), redacted, reason: 'idempotent');
      });
    }
  });

  test('benign text is left exactly as it is (the gateway leaves it too)', () {
    for (final line in [
      'api_key = os.environ["OPENAI_API_KEY"]',
      'The secret: rotate-weekly-please is our policy',
      'token = process.env.GITHUB_TOKEN',
      r'curl -H "Authorization: Bearer $TOKEN"',
      'api_key=***',
      'Authorization: Bearer ***',
      "curl -H 'Authorization: token ***' https://api.github.com",
      'the secret plan is ready',
      'Set the password in Settings, then pick a token budget.',
    ]) {
      expect(redactSecrets(line), line);
      expect(containsSecret(line), isFalse, reason: line);
    }
  });

  test('the shapes the gateway redacts are redacted here', () {
    expect(redactSecrets('api_key: $_openAi'), 'api_key: [redacted]');
    expect(
      redactSecrets('Authorization: Bearer abcdef0123456789'),
      'Authorization: Bearer [redacted]',
    );
    expect(
      redactSecrets('export OPENAI_API_KEY=$_openAi'),
      'export OPENAI_API_KEY=[redacted]',
    );
    expect(
      redactSecrets('secret = hunter2hunter2hunter2'),
      'secret = [redacted]',
    );
    expect(redactSecrets('access_token=$_google'), 'access_token=[redacted]');
    expect(
      redactSecrets('access_token = get_token_from_keychain()'),
      'access_token = [redacted]',
    );
    expect(redactSecrets('use $_openAi please'), 'use [redacted] please');
    expect(
      redactSecrets('{"password": "correct-horse-battery"}'),
      '{"password": "[redacted]"}',
    );
    expect(
      redactSecrets('postgres://app:s3cretpassw0rd@db/app'),
      'postgres://app:[redacted]@db/app',
    );
    expect(
      redactSecrets(
        '-----BEGIN OPENSSH PRIVATE KEY-----\nabc\n'
        '-----END OPENSSH PRIVATE KEY-----',
      ),
      '[redacted]',
    );
  });

  test('R6: a 2 MiB export is redacted off the UI isolate, and a transcript '
      'with nothing secret-shaped costs one scan', () async {
    final line =
        'assistant: here is the plan, api_key = os.environ["X"] then some '
        'ordinary prose follows, and $_openAi must not survive. ';
    final buffer = StringBuffer();
    while (buffer.length < 2 * 1024 * 1024 - line.length) {
      buffer.write(line);
    }
    final content = buffer.toString();
    expect(content.length, greaterThan(transcriptRedactionInlineLimit));
    final redacted = await redactTranscript(content);
    expect(redacted, isNot(contains(_openAi)));
    expect(redacted, contains('api_key = os.environ["X"]'));
    expect(containsSecret(redacted.substring(0, 4096)), isFalse);

    // Prose with no candidate shape never reaches the rules.
    final prose = 'the quick brown fox jumps over the lazy dog. ' * 46000;
    final watch = Stopwatch()..start();
    expect(identical(redactSecrets(prose), prose), isTrue);
    expect(watch.elapsedMilliseconds, lessThan(1000));
  });
}
