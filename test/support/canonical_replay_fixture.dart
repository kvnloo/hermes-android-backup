// Backend-produced canonical gateway shapes for the replay/control tests.
//
// `test/fixtures/canonical_replay_contract.json` is written by
// `tools/capture_canonical_replay_fixture.py`, which runs the Hermes backend's
// own SessionEvents, `session.events.since` handler, Stop/Steer fences and the
// legacy dispatcher in memory. Nothing here invents an epoch or a sequence.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'strict_nextgen_gateway.dart';

Map<String, dynamic>? _cached;

/// The captured contract (decoded once per test isolate).
Map<String, dynamic> canonicalFixture() => _cached ??=
    jsonDecode(
          File(
            'test/fixtures/canonical_replay_contract.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;

/// A deep copy of one fixture value, so a test cannot edit another's data.
T fixtureCopy<T>(Object? value) => jsonDecode(jsonEncode(value)) as T;

Object? _at(List<String> path) {
  Object? node = canonicalFixture();
  for (final key in path) {
    node = (node as Map)[key];
  }
  return node;
}

Map<String, dynamic> fixtureMap(List<String> path) =>
    fixtureCopy<Map<String, dynamic>>(_at(path));

List<Map<String, dynamic>> fixtureFrames(List<String> path) => [
  for (final frame in _at(path) as List)
    fixtureCopy<Map<String, dynamic>>(frame),
];

/// A wire frame as the socket hands it to NextGen.
StreamEvent fixtureEvent(Map<String, dynamic> frame) =>
    WsClient.parseGatewayEvent(
      Map<String, dynamic>.from(frame['params'] as Map),
    )!;

String get fixtureSessionId => canonicalFixture()['session_id'] as String;

SavedConnection fixtureConnection() => SavedConnection(
  id: 'c1',
  label: 'Home',
  host: '10.0.0.5',
  port: 9119,
  apiKey: '',
  desktopGatewayUrl: 'http://10.0.0.5:9119',
  singleLogin: true,
  signInMethod: 'none',
  dashboardProxied: true,
);

/// A loopback socket that only greets: NextGen asks `socket.isConnected`
/// before a catch-up, while the RPCs themselves go through [FixtureGateway].
Future<({HttpServer server, WsClient socket})> greetingSocket(
  Map<String, dynamic> readyFrame,
) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((request) async {
    final ws = await WebSocketTransformer.upgrade(request);
    ws.add(jsonEncode(readyFrame));
    ws.listen((_) {});
  });
  final socket = WsClient('http://127.0.0.1:${server.port}');
  await socket.connect().timeout(const Duration(seconds: 5));
  await socket.waitForGatewayReady().timeout(const Duration(seconds: 5));
  return (server: server, socket: socket);
}

typedef FixtureHandler =
    FutureOr<Map<String, dynamic>> Function(Map<String, dynamic> params);

/// The dashboard's REST transcript for a [FixtureGateway].
class FixtureHistory {
  FixtureHistory(this.rows);

  List<Map<String, dynamic>> rows;
  int reads = 0;

  /// Held while not null: a history read waits for it.
  Completer<void>? hold;

  late final client = MockClient((request) async {
    if (!request.url.path.contains('/messages')) {
      return http.Response(
        jsonEncode({'model': 'fixture-model', 'provider': 'fixture'}),
        200,
        headers: {'content-type': 'application/json'},
      );
    }
    reads++;
    final held = hold;
    if (held != null) await held.future;
    return http.Response(
      jsonEncode({'messages': rows}),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
}

/// A NextGen gateway whose RPCs answer from captured backend shapes and whose
/// REST history is served by [rest].
class FixtureGateway extends NextGenGateway {
  factory FixtureGateway({
    required Map<String, dynamic> readyFrame,
    required WsClient liveSocket,
    List<Map<String, dynamic>> history = const [],
    Map<String, FixtureHandler>? handlers,
  }) => FixtureGateway._(
    FixtureHistory(history),
    readyFrame,
    liveSocket,
    handlers ?? {},
  );

  FixtureGateway._(
    this.rest,
    Map<String, dynamic> ready,
    this.liveSocket,
    this.handlers,
  ) : super(
        fixtureConnection(),
        dashboard: DashboardClient(
          host: '10.0.0.5',
          proxied: true,
          httpClient: rest.client,
        ),
      ) {
    readyFrame = ready;
  }

  final FixtureHistory rest;
  final WsClient liveSocket;
  final Map<String, FixtureHandler> handlers;
  final calls = <({String method, Map<String, dynamic> params})>[];

  /// Fires the chats' reconnect handling, as a fresh socket does.
  final reconnects = StreamController<void>.broadcast();

  List<({String method, Map<String, dynamic> params})> callsTo(String m) =>
      calls.where((c) => c.method == m).toList();

  @override
  Stream<void> get reconnected => reconnects.stream;

  /// The fixture's socket is already open: no ticket loop or backoff timer.
  @override
  void start() {}

  @override
  void retry() {}

  @override
  void dispose() {
    unawaited(reconnects.close());
    super.dispose();
  }

  @override
  WsClient? get socket => liveSocket;

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => liveSocket;

  /// On an authority ready frame the call goes through the client's guard
  /// and the strict contract check, as the real socket does; [calls] then
  /// holds the frames as they would go on the wire.
  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) => sessionAuthority
      ? strictCall(this, method, params, _answer)
      : _answer(method, params);

  Future<Map<String, dynamic>> _answer(
    String method,
    Map<String, dynamic> params,
  ) async {
    calls.add((method: method, params: Map<String, dynamic>.from(params)));
    final handler = handlers[method];
    if (handler == null) return <String, dynamic>{};
    return Map<String, dynamic>.from(await handler(params));
  }
}

/// The gateway's refusal of [method] exactly as its error frame carries it.
JsonRpcError fixtureRefusal(String method, Map<String, dynamic> wireError) =>
    JsonRpcError.fromGateway(method, wireError, fallbackMessage: method);
