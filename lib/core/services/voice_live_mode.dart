import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../nextgen/data/nextgen_gateway.dart';
import 'connection_mutation_barrier.dart';
import 'desktop_gateway_client.dart';
import 'gpt_live_conversation.dart';

/// Gateway-scoped `voice.voice_chat_mode` (`chained` | `gpt-live`) status and
/// mode switcher, mirroring Hermes Desktop's `store/voice-live.ts`.
///
/// Keyed by `(connectionId, profile)`. A write bumps [_writeEpoch] so an older
/// in-flight status read never overwrites the newly persisted selection. When
/// the host reports `available: false` (for instance, no OpenAI key on the
/// gateway host), [effectiveMode] falls back to `'chained'` while preserving
/// [unavailableReason] so the UI can explain why.
class VoiceLiveModeController extends ChangeNotifier {
  VoiceLiveModeController({
    required this.connectionId,
    String? profile,
    required this.transport,
    this.rpc,
    bool registerShared = true,
  }) : profile = (profile == null || profile.trim().isEmpty)
           ? null
           : profile.trim() {
    _accountEpoch = ConnectionMutationBarrier.capture(connectionId);
    ConnectionMutationBarrier.addListener(_onAccountBarrier);
    if (registerShared) {
      _shared[_scopeKey(connectionId, this.profile)] = this;
    }
  }

  factory VoiceLiveModeController.fromDesktop(DesktopGatewayClient client) {
    return VoiceLiveModeController(
      connectionId: client.connectionId,
      profile: client.gatewayProfile,
      transport: client.createGptLiveTransport(),
      rpc: (method, params) => client.call(method, params),
    );
  }

  factory VoiceLiveModeController.fromNextGen(NextGenGateway gateway) {
    return VoiceLiveModeController(
      connectionId: gateway.connection.id,
      profile: gateway.profile,
      transport: GptLiveGatewayTransport.fromDashboard(
        gateway.dashboard,
        profile: gateway.profile,
      ),
      rpc: (method, params) async {
        if (!gateway.state.isConnected) {
          await gateway.connected(timeout: const Duration(seconds: 15));
        }
        return gateway.call(method, params);
      },
    );
  }

  static final Map<String, VoiceLiveModeController> _shared = {};

  static String _scopeKey(String connectionId, String? profile) =>
      '$connectionId::${(profile ?? '').trim()}';

  static VoiceLiveModeController? sharedForConnection(
    String connectionId, {
    String? profile,
  }) => _shared[_scopeKey(connectionId, profile)];

  static void clearAll() {
    for (final controller in _shared.values.toList()) {
      controller.clearStatus();
    }
  }

  final String connectionId;
  final String? profile;
  final GptLiveTransport transport;
  final Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params,
  )?
  rpc;

  Object? _accountEpoch;
  GptLiveStatus? _status;
  bool _saving = false;
  bool _disposed = false;
  String? _error;
  int _writeEpoch = 0;
  Future<GptLiveStatus?>? _inflight;
  String? _inflightKey;

  GptLiveStatus? get status => _status;
  bool get hasStatus => _status != null;
  bool get saving => _saving;
  String? get error => _error;

  /// Raw mode configured on the gateway (`'chained'` until answered).
  String get selectedMode => _status?.isLive == true ? 'gpt-live' : 'chained';

  /// Whether the gateway host can actually open a GPT-Live session.
  bool get liveAvailable => _status?.available == true;

  /// Effective mode used by the composer: falls back to `'chained'` whenever
  /// GPT-Live is unavailable on the host.
  String get effectiveMode =>
      (_status?.isLive == true && _status?.available == true)
      ? 'gpt-live'
      : 'chained';

  /// True when the profile requested `'gpt-live'` on the gateway, but the host
  /// reported `available: false` so the client fell back to `'chained'`.
  bool get fellBackToChained =>
      _status?.isLive == true && _status?.available != true;

  /// Host-supplied reason why GPT-Live is unavailable, if any.
  String? get unavailableReason {
    final current = _status;
    if (current == null || current.available) return null;
    final raw = current.reason?.trim();
    return (raw == null || raw.isEmpty) ? null : raw;
  }

  String get _flightKey => '${_scopeKey(connectionId, profile)}::$_writeEpoch';

  void _onAccountBarrier() {
    if (_disposed) return;
    if (!ConnectionMutationBarrier.isCurrent(connectionId, _accountEpoch)) {
      _accountEpoch = ConnectionMutationBarrier.capture(connectionId);
      clearStatus();
    }
  }

  /// Drops cached status on sign-out or account mutation.
  void clearStatus() {
    if (_disposed) return;
    _writeEpoch++;
    _inflight = null;
    _inflightKey = null;
    _status = null;
    _error = null;
    _saving = false;
    notifyListeners();
  }

  /// Reads `/api/audio/voice-live/status` for `(connectionId, profile)`.
  Future<GptLiveStatus?> refresh() {
    if (_disposed) return Future<GptLiveStatus?>.value(null);
    final key = _flightKey;
    if (_inflight != null && _inflightKey == key) {
      return _inflight!;
    }
    final future = _fetchStatus(key);
    _inflightKey = key;
    _inflight = future;
    return future;
  }

  Future<GptLiveStatus?> _fetchStatus(String key) async {
    try {
      final parsed = parseGptLiveStatus(await transport.status());
      if (!_disposed && _flightKey == key) {
        _status = parsed;
        _error = null;
        notifyListeners();
      }
      return parsed;
    } catch (_) {
      return null;
    } finally {
      if (_inflightKey == key) {
        _inflight = null;
        _inflightKey = null;
      }
    }
  }

  /// Persists `voice.voice_chat_mode` on the gateway for [profile] and
  /// refreshes the resolved status.
  Future<GptLiveStatus?> setMode(String mode) async {
    if (_disposed) return null;
    if (mode != 'chained' && mode != 'gpt-live') return _status;
    if (mode == 'gpt-live' && !liveAvailable) return _status;
    final caller = rpc;
    if (caller == null) return _status;
    _saving = true;
    _error = null;
    notifyListeners();
    try {
      await caller('config.set', <String, dynamic>{
        'key': 'voice.voice_chat_mode',
        if (profile != null) 'profile': profile,
        'value': mode,
      });
      _writeEpoch++;
      if (!_disposed) {
        _saving = false;
      }
      return await refresh();
    } catch (e) {
      if (!_disposed) {
        _saving = false;
        _error = e.toString();
        notifyListeners();
      }
      return _status;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    final key = _scopeKey(connectionId, profile);
    if (identical(_shared[key], this)) {
      _shared.remove(key);
    }
    ConnectionMutationBarrier.removeListener(_onAccountBarrier);
    transport.dispose();
    super.dispose();
  }
}
