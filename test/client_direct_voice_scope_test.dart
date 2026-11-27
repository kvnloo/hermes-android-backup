// Client-direct voice credentials follow the saved connection: an edit of
// the host or the credentials, a deletion or a sign-out drops every store
// bound to the old connection, so no provider key is ever fetched from (or
// served for) the old host afterwards (review probe S1).
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/client_direct_voice.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/connection_mutation_barrier.dart';

/// Records the host of every request; answers voice-config with a direct
/// TTS key named after the host, unless [hold] is set.
class _Recording extends HttpOverrides {
  final hosts = <String>[];
  Completer<void>? hold;

  @override
  HttpClient createHttpClient(SecurityContext? context) => _Client(this);
}

class _Client implements HttpClient {
  _Client(this._owner);
  final _Recording _owner;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    _owner.hosts.add(url.host);
    await _owner.hold?.future;
    return _Request(url);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Request implements HttpClientRequest {
  _Request(this.uri);
  @override
  final Uri uri;
  @override
  final HttpHeaders headers = _Headers();
  @override
  bool followRedirects = true;
  @override
  int maxRedirects = 5;
  @override
  bool persistentConnection = true;
  @override
  int contentLength = -1;
  @override
  Encoding encoding = utf8;

  @override
  void add(List<int> data) {}
  @override
  Future<void> addStream(Stream<List<int>> stream) => stream.drain<void>();
  @override
  Future<HttpClientResponse> close() async => _Response(uri.host);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Headers implements HttpHeaders {
  final _values = <String, List<String>>{};
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) =>
      _values[name.toLowerCase()] = ['$value'];
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) =>
      (_values[name.toLowerCase()] ??= []).add('$value');
  @override
  void forEach(void Function(String name, List<String> values) action) =>
      _values.forEach(action);
  @override
  String? value(String name) => _values[name.toLowerCase()]?.join(',');
  @override
  List<String>? operator [](String name) => _values[name.toLowerCase()];

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Response extends Stream<List<int>> implements HttpClientResponse {
  _Response(String host)
    : _body = utf8.encode(
        jsonEncode({
          'ok': true,
          'stt': {'mode': 'relay'},
          'tts': {
            'mode': 'direct',
            'wire': 'openai-speech',
            'provider': 'openai',
            'base_url': 'https://api.example.invalid/v1',
            'api_key': 'key-from-$host',
            'model': 'tts-1',
            'voice': 'alloy',
          },
        }),
      );
  final List<int> _body;

  @override
  int get statusCode => 200;
  @override
  String get reasonPhrase => 'OK';
  @override
  int get contentLength => _body.length;
  @override
  HttpHeaders get headers =>
      _Headers()..set('content-type', 'application/json');
  @override
  bool get isRedirect => false;
  @override
  List<RedirectInfo> get redirects => const [];
  @override
  bool get persistentConnection => false;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.value(_body).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// A proxied dashboard: one request per call, no sign-in round trip. The
/// password still differs between edits, as a credential change would.
SavedConnection _account(String host, {String password = 'pw'}) =>
    SavedConnection(
      id: 'scope-account',
      label: 'Account',
      host: host,
      port: 9119,
      apiKey: '',
      dashboardProxied: true,
      dashboardUsername: 'user',
      dashboardPassword: password,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Recording http;
  setUp(() => http = _Recording());
  tearDown(VoiceClientRuntime.closeAll);

  Future<T> withHttp<T>(Future<T> Function() body) =>
      HttpOverrides.runWithHttpOverrides(body, http);

  test('a host edit: voice-config is fetched from the new host only '
      '(review probe S1)', () async {
    await withHttp(() async {
      final before = _account('account-a.invalid');
      final first = VoiceClientRuntime.storeFor(
        before,
        connectionId: before.id,
      );
      expect((await first.configFor('k'))?.tts?.apiKey, isNotNull);

      ConnectionMutationBarrier.begin([before.id]).release();
      final after = _account('account-b.invalid');
      final second = VoiceClientRuntime.storeFor(after, connectionId: after.id);
      final config = await second.configFor('k');

      expect(identical(first, second), isFalse);
      expect(http.hosts.last, 'account-b.invalid');
      expect(config?.tts?.apiKey, 'key-from-account-b.invalid');
    });
  });

  test('a credential edit on the same host makes a new store too', () async {
    await withHttp(() async {
      final before = _account('same.invalid', password: 'old');
      final first = VoiceClientRuntime.storeFor(
        before,
        connectionId: before.id,
      );
      final after = _account('same.invalid', password: 'new');
      final second = VoiceClientRuntime.storeFor(after, connectionId: after.id);
      expect(identical(first, second), isFalse);
      // Same connection, nothing changed: the store is shared.
      expect(
        identical(
          second,
          VoiceClientRuntime.storeFor(
            _account('same.invalid', password: 'new'),
            connectionId: after.id,
          ),
        ),
        isTrue,
      );
    });
  });

  test('a store still held after an edit serves no key and never calls the '
      'old host again', () async {
    await withHttp(() async {
      final before = _account('account-a.invalid');
      final held = VoiceClientRuntime.storeFor(before, connectionId: before.id);
      expect(await held.configFor('k'), isNotNull);
      final calls = http.hosts.length;

      ConnectionMutationBarrier.begin([before.id]).release();

      expect(await held.configFor('k'), isNull);
      expect(await held.configFor('other'), isNull);
      expect(http.hosts, hasLength(calls));
    });
  });

  test('a fetch from the old host still in flight when the edit lands is '
      'dropped, not cached', () async {
    await withHttp(() async {
      final before = _account('account-a.invalid');
      final held = VoiceClientRuntime.storeFor(before, connectionId: before.id);
      http.hold = Completer<void>();
      final pending = held.configFor('k');
      await pumpEventQueue();
      expect(http.hosts, ['account-a.invalid']);

      ConnectionMutationBarrier.begin([before.id]).release();
      http.hold!.complete();
      http.hold = null;

      expect(await pending, isNull);
      expect(await held.configFor('k'), isNull);
    });
  });

  test('a mutation in progress (the edit not committed yet) fetches '
      'nothing', () async {
    await withHttp(() async {
      final account = _account('account-a.invalid');
      final lease = ConnectionMutationBarrier.begin([account.id]);
      final store = VoiceClientRuntime.storeFor(
        account,
        connectionId: account.id,
      );

      expect(await store.configFor('k'), isNull);
      expect(http.hosts, isEmpty);
      lease.release();
    });
  });

  test('deleting the connection drops its stores', () async {
    await withHttp(() async {
      final account = _account('account-a.invalid');
      final held = VoiceClientRuntime.storeFor(
        account,
        connectionId: account.id,
        profile: 'field',
      );
      expect(await held.configFor('k'), isNotNull);

      // ConnectionManager.deleteConnection opens the same barrier.
      ConnectionMutationBarrier.begin([account.id]).release();

      expect(await held.configFor('k'), isNull);
    });
  });

  test('another connection is left alone', () async {
    await withHttp(() async {
      final mine = _account('account-a.invalid');
      final other = SavedConnection(
        id: 'other-account',
        label: 'Other',
        host: 'other.invalid',
        port: 9119,
        apiKey: '',
        dashboardProxied: true,
      );
      final keep = VoiceClientRuntime.storeFor(other, connectionId: other.id);
      expect(await keep.configFor('k'), isNotNull);

      ConnectionMutationBarrier.begin([mine.id]).release();

      expect(await keep.configFor('k'), isNotNull);
      expect(
        identical(
          keep,
          VoiceClientRuntime.storeFor(other, connectionId: other.id),
        ),
        isTrue,
      );
    });
  });

  test('closeAll (sign-out) drops every store', () async {
    await withHttp(() async {
      final account = _account('account-a.invalid');
      final held = VoiceClientRuntime.storeFor(
        account,
        connectionId: account.id,
      );
      expect(await held.configFor('k'), isNotNull);

      VoiceClientRuntime.closeAll();

      expect(await held.configFor('k'), isNull);
      expect(
        identical(
          held,
          VoiceClientRuntime.storeFor(account, connectionId: account.id),
        ),
        isFalse,
      );
    });
  });
}
