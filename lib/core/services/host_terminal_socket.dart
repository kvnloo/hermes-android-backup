part of 'connection_manager.dart';

/// Only this fixed upgrade takes a Webapp host-terminal ticket. Never send a
/// chat bearer/cookie instead, including to HTTP or WebSocket redirects.
extension HostTerminalSocket on DashboardClient {
  Future<WebSocket> openHostTerminal({
    required String? profile,
    String? cwd,
    String? attach,
    bool close = false,
    required void Function() check,
  }) async {
    final base = Uri.parse(baseUrl);
    if (base.scheme != 'https' &&
        !(base.scheme == 'http' &&
            const {'127.0.0.1', '::1', 'localhost'}.contains(base.host))) {
      throw const FormatException('Unsafe terminal origin');
    }
    if ((attach != null && !validHostTerminalId(attach)) ||
        (close && attach == null) ||
        (gatewayProfile != null && gatewayProfile != profile)) {
      throw const FormatException('Invalid attachment');
    }
    final ticket =
        await _workspaceJson(
              ['webapp', 'socket-ticket'],
              query: {'socket': 'host-terminal'},
              check: check,
              mintHostTerminalTicket: true,
            )
            as String;
    if (!RegExp(r'^[A-Za-z0-9_-]{1,512}$').hasMatch(ticket)) {
      throw const FormatException('Invalid ticket');
    }
    check();
    final uri = base.replace(
      scheme: base.scheme == 'https' ? 'wss' : 'ws',
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'api',
        'host-terminal',
      ],
      queryParameters: {
        'profile': ?profile,
        'cwd': ?cwd,
        'attach': ?attach,
        if (close) 'action': 'close',
      },
    );
    final http = _TerminalUpgrade(_upgradeClient(), check);
    var opened = false;
    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        customClient: http,
        headers: {
          ..._customHeaders,
          ...HermesSignInVault.instance.accessHeadersFor(uri),
        },
        protocols: ['hermes-gateway-v1', 'hermes-gateway-ticket.$ticket'],
      ).timeout(const Duration(seconds: 10));
      opened = true;
      // force-closing the client here kills the upgraded socket. Keep it
      // until that socket ends, including the frames that follow the greeting.
      unawaited(socket.done.whenComplete(() => http.close(force: true)));
      try {
        check();
      } catch (_) {
        unawaited(socket.close());
        rethrow;
      }
      return socket;
    } finally {
      if (!opened) http.close(force: true);
    }
  }
}

bool validHostTerminalId(String id) =>
    RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(id);

class _TerminalUpgrade implements HttpClient {
  _TerminalUpgrade(this.inner, this.check);
  final HttpClient inner;
  final void Function() check;
  @override
  Future<HttpClientRequest> openUrl(String method, Uri uri) async {
    check();
    final request = await inner.openUrl(method, uri);
    try {
      check();
    } catch (_) {
      request.abort();
      rethrow;
    }
    return request..followRedirects = false;
  }

  @override
  void close({bool force = false}) => inner.close(force: force);
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Not an upgrade');
}
