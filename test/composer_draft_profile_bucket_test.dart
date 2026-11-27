import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/chat_presentation_state.dart';
import 'package:hermes_android/core/services/composer_draft_store.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

SavedConnection _account(String profile) => SavedConnection(
  id: 'conn',
  label: 'test',
  host: 'host-a',
  port: 443,
  apiKey: 'fixture',
  gatewayProfile: profile,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'a named profile keeps drafts and held prompts in the saved connection bucket',
    () async {
      final connection = _account('work');
      // Shipped releases saved every draft under the saved connection id,
      // whatever its gateway profile. An upgrade must still hydrate it.
      await ComposerDraftStore.save(
        connectionId: connection.id,
        sessionId: 'stored',
        text: 'typed before upgrade',
      );
      final registry = ChatPresentationRegistry.forConnection(connection);
      final writer = registry.chatFor('stored').openWriter();
      expect(writer.draftHandle.connectionId, connection.id);
      expect(await writer.read(), 'typed before upgrade');
      writer.edit('typed after upgrade');
      await writer.close();
      expect(
        await ComposerDraftStore.read(
          connectionId: connection.id,
          sessionId: 'stored',
        ),
        'typed after upgrade',
      );

      // The application session publishes local -> stored aliases under the
      // saved connection id; the registry's writers must follow that alias.
      final local = registry.chatFor('local').openWriter()
        ..edit('unsent local');
      await local.close();
      await ComposerDraftStore.bind(
        connectionId: connection.id,
        localSessionId: 'local',
        storedSessionId: 'bound',
      );
      final bound = registry.chatFor('bound').openWriter();
      expect(await bound.read(), 'unsent local');
      await bound.close();

      await ComposerDraftStore.saveHeldPrompts(
        connectionId: writer.draftHandle.connectionId,
        sessionId: 'stored',
        texts: ['held prompt'],
      );
      expect(
        await ComposerDraftStore.readHeldPrompts(
          connectionId: connection.id,
          sessionId: 'stored',
        ),
        ['held prompt'],
      );
      registry.close();
    },
  );

  test(
    'another profile on the same connection cannot recover it across chats',
    () async {
      final work = ChatPresentationRegistry.forConnection(_account('work'));
      final source = work.chatFor('orphan').openWriter()..edit('work draft');
      await source.close();
      final home = ChatPresentationRegistry.forConnection(_account('home'));
      final target = home.chatFor('dest').openWriter();
      expect(
        await ComposerDraftStore.recoveryCandidates(target.draftHandle),
        isEmpty,
      );
      expect(
        await ComposerDraftStore.recoveryText(target.draftHandle, 'orphan'),
        isNull,
      );
      final own = work.chatFor('dest-work').openWriter();
      expect(await ComposerDraftStore.recoveryCandidates(own.draftHandle), [
        'orphan',
      ]);
      await target.close();
      await own.close();
      home.close();
      work.close();
    },
  );
}
