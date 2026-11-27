import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../l10n/service_strings.dart';
import 'connection_manager.dart';
import 'connection_mutation_barrier.dart';

/// Process-wide, scope-keyed stores. A store is bound to one saved
/// connection exactly as it was when the store was made (host, ports,
/// prefixes, credentials, headers, certificate): its credentials are dropped
/// by [VoiceClientConfigStore.clear] on background, and the whole store is
/// closed when that connection is edited or deleted (through
/// [ConnectionMutationBarrier]) or on sign-out ([closeAll]). A store a caller
/// still holds after that serves nothing, so no provider key can come from
/// the old host; [storeFor] then makes a new one for the new connection.
class VoiceClientRuntime {
  VoiceClientRuntime._();

  static final Map<String, _VoiceStoreEntry> _stores = {};
  static bool _observing = false;

  static VoiceClientConfigStore storeFor(
    SavedConnection connection, {
    required String connectionId,
    String? profile,
  }) {
    _observe();
    final key = '$connectionId::${profile ?? ''}';
    final identity = _connectionIdentity(connection);
    final existing = _stores[key];
    if (existing != null) {
      if (existing.identity == identity && existing.current) {
        return existing.store;
      }
      _stores.remove(key);
      existing.close();
    }
    // Dedicated client: a chat closing its own dashboard must not invalidate
    // the cached credentials resolver.
    final dashboard = DashboardClient.fromConnection(connection);
    final epoch = ConnectionMutationBarrier.capture(connectionId);
    late final _VoiceStoreEntry entry;
    final store = VoiceClientConfigStore(
      fetchConfig: () async {
        // Never while the connection is being edited, nor after: the old
        // host must not be asked for keys again.
        if (!entry.current) return null;
        final response = await dashboard.apiRequest(
          'GET',
          'audio/voice-config',
          queryParameters: profile == null ? null : {'profile': profile},
        );
        if (!entry.current || response.statusCode != 200) return null;
        return jsonDecode(response.body);
      },
    );
    entry = _VoiceStoreEntry(
      connectionId: connectionId,
      epoch: epoch,
      identity: identity,
      store: store,
      dashboard: dashboard,
    );
    _stores[key] = entry;
    return store;
  }

  static void _observe() {
    if (_observing) return;
    _observing = true;
    ConnectionMutationBarrier.addListener(_onConnectionMutation);
  }

  /// An edit or deletion of a saved connection begins here, before anything
  /// is committed: close every store bound to it.
  static void _onConnectionMutation() {
    final stale = [
      for (final entry in _stores.entries)
        if (!entry.value.current) entry.key,
    ];
    for (final key in stale) {
      _stores.remove(key)?.close();
    }
  }

  /// Sign-out: drops every store and the credentials it holds.
  static void closeAll() {
    final entries = _stores.values.toList();
    _stores.clear();
    for (final entry in entries) {
      entry.close();
    }
  }
}

class _VoiceStoreEntry {
  _VoiceStoreEntry({
    required this.connectionId,
    required this.epoch,
    required this.identity,
    required this.store,
    required this.dashboard,
  });

  final String connectionId;
  final Object? epoch;
  final int identity;
  final VoiceClientConfigStore store;
  final DashboardClient dashboard;
  bool _closed = false;

  /// Still the connection the store was made for, with no edit in progress.
  bool get current =>
      !_closed && ConnectionMutationBarrier.isCurrent(connectionId, epoch);

  void close() {
    if (_closed) return;
    _closed = true;
    store.dispose();
    dashboard.close();
  }
}

/// Everything about a saved connection that decides which host is asked and
/// with which credentials. In memory only.
int _connectionIdentity(SavedConnection c) {
  final headers = c.customHeaders.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return Object.hashAll([
    c.host,
    c.port,
    c.useHttps,
    c.gatewayPrefix,
    c.dashboardPrefix,
    c.dashboardProxied,
    c.desktopGatewayUrl,
    c.dashboardPortOverride,
    c.dashboardUsername,
    c.dashboardPassword,
    c.gatewayProfile,
    c.singleLogin,
    c.signInMethod,
    c.apiKey,
    c.deploymentToken,
    c.clientCertificate,
    for (final header in headers) ...[header.key, header.value],
  ]);
}

/// Client-direct voice: the gateway resolves the active profile's provider
/// credentials through the same chain its relay endpoints use, and the client
/// calls those provider HTTP APIs itself. Keys live in this object's memory
/// only: never preferences, secure storage, logs, crash reports or wire
/// responses back to the gateway. `{"mode":"relay"}` (unknown provider,
/// server-host-only engine, resolution error, older backend) keeps callers on
/// the existing `/api/audio/*` relay path.
@immutable
class DirectSttConfig {
  const DirectSttConfig({
    required this.wire,
    required this.provider,
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    required this.language,
    required this.timeoutSeconds,
    required this.hallucinationPhrases,
    required this.repeatPattern,
  });

  final String wire;
  final String provider;
  final String baseUrl;
  final String apiKey;
  final String? model;
  final String? language;
  final double timeoutSeconds;
  final List<String> hallucinationPhrases;
  final String? repeatPattern;

  @override
  String toString() => 'DirectSttConfig($wire, $provider)'; // never the key
}

@immutable
class DirectTtsConfig {
  const DirectTtsConfig({
    required this.wire,
    required this.provider,
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    required this.voice,
    required this.speed,
    required this.extraBody,
  });

  final String wire;
  final String provider;
  final String baseUrl;
  final String apiKey;
  final String? model;
  final String? voice;
  final double? speed;
  final Map<String, dynamic> extraBody;

  @override
  String toString() => 'DirectTtsConfig($wire, $provider)'; // never the key
}

@immutable
class VoiceClientConfig {
  const VoiceClientConfig({required this.stt, required this.tts});

  final DirectSttConfig? stt;
  final DirectTtsConfig? tts;

  bool get sttIsDirect => stt != null;
  bool get ttsIsDirect => tts != null;
}

/// Provider rejection: callers surface a short, key-free message. A rejected
/// direct request is NOT retried through the relay — that would repeat the
/// same failure through a slower path and hide the real error.
class ClientDirectVoiceException implements Exception {
  const ClientDirectVoiceException(this.message);
  final String message;
  @override
  String toString() => message;
}

String _trim(Object? value) => value?.toString().trim() ?? '';

double? _positiveSeconds(Object? value) {
  final number = value is num ? value : double.tryParse(_trim(value));
  return number != null && number > 0 ? number.toDouble() : null;
}

DirectSttConfig? _parseStt(Object? raw) {
  if (raw is! Map || raw['mode'] != 'direct') return null;
  final wire = _trim(raw['wire']);
  if (!const {'openai-multipart', 'xai-stt', 'elevenlabs-stt'}.contains(wire)) {
    return null;
  }
  final key = _trim(raw['api_key']);
  final base = _trim(raw['base_url']);
  if (key.isEmpty || base.isEmpty) return null;
  final filter = raw['hallucination_filter'];
  final phrases = <String>[];
  String? repeat;
  if (filter is Map) {
    final values = filter['phrases'];
    if (values is List) {
      for (final value in values) {
        final phrase = _trim(value).toLowerCase();
        if (phrase.isNotEmpty) phrases.add(phrase);
      }
    }
    repeat = _trim(filter['repeat_regex']).isEmpty
        ? null
        : _trim(filter['repeat_regex']);
  }
  return DirectSttConfig(
    wire: wire,
    provider: _trim(raw['provider']),
    baseUrl: base.replaceFirst(RegExp(r'/+$'), ''),
    apiKey: key,
    model: _trim(raw['model']).isEmpty ? null : _trim(raw['model']),
    language: _trim(raw['language']).isEmpty ? null : _trim(raw['language']),
    timeoutSeconds: _positiveSeconds(raw['timeout_s']) ?? 60,
    hallucinationPhrases: List.unmodifiable(phrases),
    repeatPattern: repeat,
  );
}

DirectTtsConfig? _parseTts(Object? raw) {
  if (raw is! Map || raw['mode'] != 'direct') return null;
  final wire = _trim(raw['wire']);
  if (!const {'openai-speech', 'elevenlabs-tts'}.contains(wire)) return null;
  final key = _trim(raw['api_key']);
  final base = _trim(raw['base_url']);
  if (key.isEmpty || base.isEmpty) return null;
  final speed = _positiveSeconds(raw['speed']);
  final extra = raw['extra_body'];
  return DirectTtsConfig(
    wire: wire,
    provider: _trim(raw['provider']),
    baseUrl: base.replaceFirst(RegExp(r'/+$'), ''),
    apiKey: key,
    model: _trim(raw['model']).isEmpty ? null : _trim(raw['model']),
    voice: _trim(raw['voice']).isEmpty ? null : _trim(raw['voice']),
    speed: speed,
    extraBody: extra is Map
        ? Map<String, dynamic>.from(extra)
        : <String, dynamic>{},
  );
}

/// Parses a `GET /api/audio/voice-config` response. A malformed or absent
/// direction is a relay verdict, never a reason to surface provider details.
VoiceClientConfig? parseVoiceClientConfig(Object? body) {
  if (body is! Map || body['ok'] != true) return null;
  return VoiceClientConfig(
    stt: _parseStt(body['stt']),
    tts: _parseTts(body['tts']),
  );
}

/// In-memory, scope-keyed config cache. Dropped on sign-out/profile mutation,
/// connection switch and app background; it has no disk backing whatsoever.
class VoiceClientConfigStore {
  VoiceClientConfigStore({
    required this.fetchConfig,
    this.ttl = const Duration(seconds: 60),
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client() {
    // A plain observer, not an AppLifecycleListener: the listener asserts a
    // strict state order (resumed > inactive > hidden > paused) that some
    // platforms and the app's own tests skip, and one live listener makes
    // every such jump throw. Hidden, paused and detached all clear the cache.
    _lifetime = _VoiceConfigLifecycle(_onLifecycle);
    WidgetsBinding.instance.addObserver(_lifetime);
    ConnectionMutationBarrier.addListener(_onAccountMutation);
  }

  /// Fetches the profile-scoped config JSON, or null on an older/unreachable
  /// backend. Injected so tests use a fake gateway.
  final Future<Object?> Function() fetchConfig;
  final Duration ttl;
  final http.Client _http;
  late final _VoiceConfigLifecycle _lifetime;

  String? _scopeKey;
  VoiceClientConfig? _cached;
  DateTime? _cachedAt;
  Future<VoiceClientConfig?>? _inFlight;
  bool _disposed = false;

  void _onLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      clear();
    }
  }

  void _onAccountMutation() => clear();

  /// Discards every held credential. Safe to call from any sign-out, profile
  /// change, connection switch or backgrounding path.
  void clear() {
    _scopeKey = null;
    _cached = null;
    _cachedAt = null;
    _inFlight = null;
  }

  /// The scope's config, or null to relay. A backend's answer is kept for
  /// [ttl] whichever way it went: a backend that relays (an older one, or no
  /// client-callable provider) is not asked again before every spoken reply.
  /// A failed fetch is not an answer and is retried on the next call.
  Future<VoiceClientConfig?> configFor(String scopeKey) async {
    if (_disposed) return null;
    final now = DateTime.now();
    if (_scopeKey == scopeKey &&
        _cachedAt != null &&
        now.difference(_cachedAt!).compareTo(ttl) < 0) {
      return _cached;
    }
    final pending = _inFlight;
    if (pending != null && _scopeKey == scopeKey) return pending;

    _scopeKey = scopeKey;
    final flight = _load(scopeKey);
    _inFlight = flight;
    try {
      return await flight;
    } finally {
      if (identical(_inFlight, flight)) _inFlight = null;
    }
  }

  Future<VoiceClientConfig?> _load(String scopeKey) async {
    try {
      final config = parseVoiceClientConfig(await fetchConfig());
      if (_disposed || _scopeKey != scopeKey) return null;
      _cached = config;
      _cachedAt = DateTime.now();
      return config;
    } catch (_) {
      // Older backend / transient gateway failure → the caller relays.
      return null;
    }
  }

  /// Uploads one recording to the configured provider. Returns the transcript,
  /// or null when this direction is not client-callable so callers relay.
  Future<String?> transcribe(
    String path, {
    required String fileName,
    required String mimeType,
    VoiceClientConfig? config,
    String scopeKey = 'local',
  }) async {
    final stt = config?.stt ?? (await configFor(scopeKey))?.stt;
    if (stt == null) return null;
    final uri = stt.wire == 'xai-stt'
        ? Uri.parse('${stt.baseUrl}/stt')
        : stt.wire == 'elevenlabs-stt'
        ? Uri.parse('${stt.baseUrl}/speech-to-text')
        : Uri.parse('${stt.baseUrl}/audio/transcriptions');
    final request = http.MultipartRequest('POST', uri);
    if (stt.wire == 'elevenlabs-stt') {
      request.headers['xi-api-key'] = stt.apiKey;
    } else {
      request.headers['Authorization'] = 'Bearer ${stt.apiKey}';
    }
    request.files.add(
      await http.MultipartFile.fromPath('file', path, filename: fileName),
    );
    if (stt.wire == 'openai-multipart') {
      if (stt.model != null) request.fields['model'] = stt.model!;
      request.fields['response_format'] = 'text';
      if (stt.language != null) request.fields['language'] = stt.language!;
    } else if (stt.wire == 'xai-stt') {
      if (stt.model != null) request.fields['model'] = stt.model!;
      if (stt.language != null) {
        request.fields['language'] = stt.language!;
        request.fields['format'] = 'true';
      }
    } else {
      if (stt.model != null) request.fields['model_id'] = stt.model!;
      if (stt.language != null) request.fields['language_code'] = stt.language!;
    }

    http.StreamedResponse response;
    try {
      response = await _http
          .send(request)
          .timeout(Duration(milliseconds: (stt.timeoutSeconds * 1000).round()));
    } on TimeoutException {
      throw ClientDirectVoiceException(
        serviceStrings.voice_direct_stt_timeout(
          '${stt.timeoutSeconds}',
          stt.provider,
        ),
      );
    }
    final body = await http.Response.fromStream(response);
    if (body.statusCode < 200 || body.statusCode >= 300) {
      throw ClientDirectVoiceException(
        serviceStrings.voice_direct_stt_error(
          stt.provider,
          '${body.statusCode}',
        ),
      );
    }
    final transcript = transcriptFromProviderBody(stt.wire, body.body);
    return isSilenceHallucination(transcript, stt) ? '' : transcript;
  }

  /// Synthesizes one reply segment to MP3 bytes. Returns null when this
  /// direction is not client-callable so callers use the relay/TTS fallback.
  Future<Uint8List?> synthesize(
    String text, {
    VoiceClientConfig? config,
    String scopeKey = 'local',
  }) async {
    final tts = config?.tts ?? (await configFor(scopeKey))?.tts;
    if (tts == null || text.trim().isEmpty) return null;
    final isOpenAi = tts.wire == 'openai-speech';
    final uri = isOpenAi
        ? Uri.parse('${tts.baseUrl}/audio/speech')
        : Uri.parse(
            '${tts.baseUrl}/text-to-speech/${Uri.encodeComponent(tts.voice ?? '')}',
          );
    final payload = <String, dynamic>{
      if (isOpenAi) ...tts.extraBody,
      if (isOpenAi) 'model': tts.model,
      if (isOpenAi) 'voice': tts.voice,
      'input': text.trim(),
      if (isOpenAi) 'response_format': 'mp3',
      if (!isOpenAi) 'model_id': tts.model,
    };
    if (isOpenAi && tts.speed != null && tts.speed != 1) {
      payload['speed'] = tts.speed;
    }
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (isOpenAi) 'Authorization': 'Bearer ${tts.apiKey}',
      if (!isOpenAi) 'xi-api-key': tts.apiKey,
      if (!isOpenAi) 'Accept': 'audio/mpeg',
    };
    late final http.Response response;
    try {
      response = await _http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );
    } catch (_) {
      throw ClientDirectVoiceException(
        serviceStrings.voice_direct_tts_failed(tts.provider),
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ClientDirectVoiceException(
        serviceStrings.voice_direct_tts_error(
          tts.provider,
          '${response.statusCode}',
        ),
      );
    }
    return response.bodyBytes.isEmpty ? null : response.bodyBytes;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    clear();
    ConnectionMutationBarrier.removeListener(_onAccountMutation);
    WidgetsBinding.instance.removeObserver(_lifetime);
    _http.close();
  }
}

/// Mistral Voxtral ignores `response_format=text` and returns `{text: ...}`.
String transcriptFromProviderBody(String wire, String body) {
  final trimmed = body.trim();
  if (trimmed.isEmpty) return '';
  if (wire == 'openai-multipart' && !trimmed.startsWith('{')) return trimmed;
  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is Map) {
      final text = decoded['text'];
      if (text is String) return text.trim();
    }
  } catch (_) {
    if (wire == 'openai-multipart') return trimmed;
  }
  return '';
}

/// Mirrors the relay's Whisper-silence filter, including repetitive filler.
bool isSilenceHallucination(String transcript, DirectSttConfig stt) {
  final cleaned = transcript.trim().toLowerCase();
  if (cleaned.isEmpty) return true;
  final stripped = cleaned.replaceFirst(RegExp(r'[.!]+$'), '');
  if (stt.hallucinationPhrases.contains(stripped)) return true;
  final pattern = stt.repeatPattern;
  if (pattern == null) return false;
  try {
    return RegExp(pattern, caseSensitive: false).hasMatch(cleaned);
  } catch (_) {
    return false;
  }
}

/// Forwards app lifecycle changes to the config store without the ordering
/// assertions of [AppLifecycleListener].
class _VoiceConfigLifecycle with WidgetsBindingObserver {
  _VoiceConfigLifecycle(this._onChange);

  final void Function(AppLifecycleState state) _onChange;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => _onChange(state);
}
