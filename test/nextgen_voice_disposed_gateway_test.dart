// A NextGen chat can outlive its gateway by a frame: a connection switch
// disposes the gateway first and the chat view leaves on the next frame. The
// view keeps the voice controllers it bound (inert once disposed) and never
// builds a fresh one on the disposed gateway, which asserted from
// GatewayWakeTransport.fromNextGen and left the rest of the tree undisposed.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/voice_live_harness.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'a chat that outlives its gateway builds no voice controller on it',
    (tester) async {
      // No injected wake controller: the view uses the gateway's own.
      final fixture = NextGenLiveFixture();
      await tester.pumpWidget(await fixture.app());
      await settleLive(tester);

      fixture.gateway.dispose();
      // The chat still changes (a late page lands) before the view leaves.
      fixture.chat.debugApplyHistory(const [
        {'role': 'user', 'content': 'late row'},
      ]);
      await tester.pump();
      expect(tester.takeException(), isNull);

      await unmountLive(tester);
      expect(tester.takeException(), isNull);
    },
  );
}
