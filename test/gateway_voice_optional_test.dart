// Gateway voice is optional for a chat: a client that serves none (closed,
// or a stand-in relaying a chat's turns only) reads as wake not offered and
// no voice mode, instead of throwing on first touch or building a fresh
// controller on a closed client.
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/desktop_gateway_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implements the chat surface only, as older suites' doubles do.
class _TurnsOnlyClient implements DesktopGatewayClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError(
    'Unexpected DesktopGatewayClient.${invocation.memberName}',
  );
}

final _connection = SavedConnection(
  id: 'voice-optional',
  label: 'Voice optional fixture',
  host: 'voice-optional.invalid',
  port: 443,
  useHttps: true,
  apiKey: '',
  desktopGatewayUrl: 'https://voice-optional.invalid:443',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a stand-in client serves no voice and is never asked for it', () {
    final client = _TurnsOnlyClient();
    expect(client.servedWakeWord, isNull);
    expect(client.servedVoiceLiveMode, isNull);
  });

  test('a client serves voice until it is closed, then none', () {
    final client = DesktopGatewayClient.fromConnection(_connection);
    final wake = client.servedWakeWord;
    final mode = client.servedVoiceLiveMode;
    expect(wake, isNotNull);
    expect(mode, isNotNull);
    expect(client.servedWakeWord, same(wake));
    expect(client.servedVoiceLiveMode, same(mode));

    client.close();
    expect(client.servedWakeWord, isNull);
    expect(client.servedVoiceLiveMode, isNull);
  });
}
