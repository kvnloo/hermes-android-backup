import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

import '../../l10n/app_localizations.dart';
import '../../nextgen/data/nextgen_gateway.dart';
import '../l10n/service_strings.dart';
import 'canonical_wire.dart' show canonicalConfigAvailable;
import 'connection_mutation_barrier.dart';
import 'desktop_gateway_client.dart';
import 'ws_client.dart';

/// Input device offered by the local OS microphone backend (`package:record`).
@immutable
class WakeClientInputDevice {
  const WakeClientInputDevice({required this.id, required this.label});
  final String id;
  final String label;

  @override
  bool operator ==(Object other) =>
      other is WakeClientInputDevice && other.id == id && other.label == label;

  @override
  int get hashCode => Object.hash(id, label);
}

/// PortAudio input-device diagnostics reported by `wake.status`.
@immutable
class WakeServerInputDevice {
  const WakeServerInputDevice({
    this.selector,
    this.name,
    this.error,
    this.maxInputChannels,
    this.defaultSampleRate,
    this.hostApi,
  });

  final Object? selector;
  final String? name;
  final String? error;
  final int? maxInputChannels;
  final double? defaultSampleRate;
  final String? hostApi;

  factory WakeServerInputDevice.fromJson(Map<String, dynamic> json) {
    final rate = json['default_samplerate'];
    final channels = json['max_input_channels'];
    return WakeServerInputDevice(
      selector: json['selector'],
      name: json['name']?.toString(),
      error: json['error']?.toString(),
      maxInputChannels: channels is num ? channels.toInt() : null,
      defaultSampleRate: rate is num ? rate.toDouble() : null,
      hostApi: json['hostapi']?.toString(),
    );
  }
}

/// Payload of a gateway `wake.detected` notification.
@immutable
class WakeDetectedEvent {
  const WakeDetectedEvent({
    required this.phrase,
    this.profile,
    this.startNewSession = true,
  });

  final String phrase;
  final String? profile;
  final bool startNewSession;

  factory WakeDetectedEvent.fromData(
    Map<String, dynamic> data, {
    String fallbackPhrase = 'hey hermes',
  }) {
    final rawPhrase = data['phrase']?.toString().trim() ?? '';
    final rawProfile = data['profile']?.toString().trim();
    return WakeDetectedEvent(
      phrase: rawPhrase.isEmpty ? fallbackPhrase : rawPhrase,
      profile: (rawProfile == null || rawProfile.isEmpty) ? null : rawProfile,
      startNewSession: data['start_new_session'] != false,
    );
  }
}

/// Snapshot of gateway wake-word state for Classic and NextGen UIs.
@immutable
class GatewayWakeState {
  const GatewayWakeState({
    this.available = false,
    this.enabled = false,
    this.listening = false,
    this.paused = false,
    this.pending = false,
    this.audioSilent = false,
    this.phrase = 'hey hermes',
    this.provider = '',
    this.capture = 'auto',
    this.configuredSurface = 'auto',
    this.ownerSurface,
    this.ownedByCaller = false,
    this.localInputAvailable = false,
    this.sampleRate = 16000,
    this.frameLength = 1280,
    this.reason,
    this.hint = '',
    this.notice = '',
    this.serverInputDevice,
    this.clientCaptureActive = false,
  });

  final bool available;
  final bool enabled;
  final bool listening;
  final bool paused;
  final bool pending;
  final bool audioSilent;
  final String phrase;
  final String provider;
  final String capture;
  final String configuredSurface;
  final String? ownerSurface;
  final bool ownedByCaller;
  final bool localInputAvailable;
  final int sampleRate;
  final int frameLength;
  final String? reason;
  final String hint;
  final String notice;
  final WakeServerInputDevice? serverInputDevice;
  final bool clientCaptureActive;

  bool get usesClientMic {
    final mode = capture.trim().toLowerCase();
    return mode == 'client' || mode == 'remote' || mode == 'external';
  }

  /// Whether the wake word is offered at all. As Desktop's `$wakeWord`: the
  /// toggle stays hidden until `wake.status` says the feature can run here
  /// (or config already has it on), so a gateway that does not serve
  /// `wake.*` (a 0.23+ session-authority gateway answers -32601) or has not
  /// answered yet shows nothing to tap.
  bool get offered => available || enabled || listening || paused || pending;

  GatewayWakeState copyWith({
    bool? available,
    bool? enabled,
    bool? listening,
    bool? paused,
    bool? pending,
    bool? audioSilent,
    String? phrase,
    String? provider,
    String? capture,
    String? configuredSurface,
    Object? ownerSurface = _unset,
    bool? ownedByCaller,
    bool? localInputAvailable,
    int? sampleRate,
    int? frameLength,
    Object? reason = _unset,
    String? hint,
    String? notice,
    Object? serverInputDevice = _unset,
    bool? clientCaptureActive,
  }) {
    return GatewayWakeState(
      available: available ?? this.available,
      enabled: enabled ?? this.enabled,
      listening: listening ?? this.listening,
      paused: paused ?? this.paused,
      pending: pending ?? this.pending,
      audioSilent: audioSilent ?? this.audioSilent,
      phrase: phrase ?? this.phrase,
      provider: provider ?? this.provider,
      capture: capture ?? this.capture,
      configuredSurface: configuredSurface ?? this.configuredSurface,
      ownerSurface: identical(ownerSurface, _unset)
          ? this.ownerSurface
          : ownerSurface as String?,
      ownedByCaller: ownedByCaller ?? this.ownedByCaller,
      localInputAvailable: localInputAvailable ?? this.localInputAvailable,
      sampleRate: sampleRate ?? this.sampleRate,
      frameLength: frameLength ?? this.frameLength,
      reason: identical(reason, _unset) ? this.reason : reason as String?,
      hint: hint ?? this.hint,
      notice: notice ?? this.notice,
      serverInputDevice: identical(serverInputDevice, _unset)
          ? this.serverInputDevice
          : serverInputDevice as WakeServerInputDevice?,
      clientCaptureActive: clientCaptureActive ?? this.clientCaptureActive,
    );
  }

  static const Object _unset = Object();
}

/// Active PCM capture handle for `wake.feed`.
abstract interface class WakeClientPcmSession {
  Stream<Uint8List> get pcmInt16Le;
  Future<void> stop();
}

/// Cross-platform client microphone source for remote wake-word streaming.
abstract interface class WakeClientPcmSource {
  Future<bool> hasPermission({bool request = false});
  Future<List<WakeClientInputDevice>> listInputDevices();
  Future<WakeClientPcmSession> startStream({
    required int sampleRate,
    WakeClientInputDevice? device,
  });
}

class _RecordWakePcmSession implements WakeClientPcmSession {
  _RecordWakePcmSession(this._recorder, this.pcmInt16Le);

  final AudioRecorder _recorder;
  @override
  final Stream<Uint8List> pcmInt16Le;
  bool _stopped = false;

  @override
  Future<void> stop() async {
    if (_stopped) return;
    _stopped = true;
    try {
      await _recorder.stop();
    } catch (_) {}
    try {
      await _recorder.dispose();
    } catch (_) {}
  }
}

/// Default `package:record` implementation supporting Android, iOS, macOS,
/// Windows, and Linux.
class RecordWakeClientPcmSource implements WakeClientPcmSource {
  const RecordWakeClientPcmSource();

  @override
  Future<bool> hasPermission({bool request = false}) async {
    final recorder = AudioRecorder();
    try {
      return await recorder.hasPermission(request: request);
    } catch (_) {
      return false;
    } finally {
      try {
        await recorder.dispose();
      } catch (_) {}
    }
  }

  @override
  Future<List<WakeClientInputDevice>> listInputDevices() async {
    final recorder = AudioRecorder();
    try {
      final devices = await recorder.listInputDevices();
      return [
        for (final d in devices)
          WakeClientInputDevice(id: d.id, label: d.label),
      ];
    } catch (_) {
      return const [];
    } finally {
      try {
        await recorder.dispose();
      } catch (_) {}
    }
  }

  @override
  Future<WakeClientPcmSession> startStream({
    required int sampleRate,
    WakeClientInputDevice? device,
  }) async {
    final recorder = AudioRecorder();
    try {
      final supported = await recorder.isEncoderSupported(
        AudioEncoder.pcm16bits,
      );
      if (!supported) {
        await recorder.dispose();
        throw StateError('16-bit PCM microphone capture is unsupported here.');
      }
      final stream = await recorder.startStream(
        RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
          autoGain: true,
          echoCancel: true,
          noiseSuppress: true,
          device: device == null
              ? null
              : InputDevice(id: device.id, label: device.label),
        ),
      );
      return _RecordWakePcmSession(recorder, stream);
    } catch (_) {
      try {
        await recorder.dispose();
      } catch (_) {}
      rethrow;
    }
  }
}

/// Transport adapter uniting Classic's [DesktopGatewayClient], NextGen's
/// [NextGenGateway], and unit-test fakes under one owner-scoped contract.
class GatewayWakeTransport {
  GatewayWakeTransport({
    required this.connectionId,
    required String? profile,
    required this.events,
    required this.ready,
    required bool Function() isConnected,
    required Future<Map<String, dynamic>> Function(
      String method,
      Map<String, dynamic> params, {
      Duration timeout,
    })
    call,
    void Function()? disposeHook,
    bool Function()? sessionAuthority,
  }) : profile = (profile == null || profile.trim().isEmpty)
           ? null
           : profile.trim(),
       // ignore: prefer_initializing_formals
       _isConnected = isConnected,
       // ignore: prefer_initializing_formals
       _sessionAuthority = sessionAuthority,
       // ignore: prefer_initializing_formals
       _call = call,
       // ignore: prefer_initializing_formals
       _disposeHook = disposeHook;

  factory GatewayWakeTransport.fromDesktop(DesktopGatewayClient client) {
    return GatewayWakeTransport(
      connectionId: client.connectionId,
      profile: client.gatewayProfile,
      events: client.gatewayEvents,
      ready: client.socketReady,
      isConnected: () => client.isSocketConnected,
      sessionAuthority: () => client.sessionAuthority,
      call: (method, params, {timeout = const Duration(seconds: 30)}) =>
          client.call(method, params, timeout: timeout),
    );
  }

  factory GatewayWakeTransport.fromNextGen(NextGenGateway gateway) {
    final readyController = StreamController<void>.broadcast();
    var wasConnected = gateway.state.isConnected;
    void onGatewayChange() {
      final nowConnected = gateway.state.isConnected;
      if (nowConnected && !wasConnected && !readyController.isClosed) {
        readyController.add(null);
      }
      wasConnected = nowConnected;
    }

    gateway.addListener(onGatewayChange);
    final reconnectedSub = gateway.reconnected.listen((_) {
      if (!readyController.isClosed) readyController.add(null);
    });
    return GatewayWakeTransport(
      connectionId: gateway.connection.id,
      profile: gateway.profile,
      events: gateway.events,
      ready: readyController.stream,
      isConnected: () => gateway.state.isConnected,
      sessionAuthority: () => gateway.sessionAuthority,
      call: (method, params, {timeout = const Duration(seconds: 30)}) async {
        if (!gateway.state.isConnected) {
          await gateway.connected(
            timeout: timeout < const Duration(seconds: 20)
                ? timeout
                : const Duration(seconds: 20),
          );
        }
        return gateway.call(method, params, timeout: timeout);
      },
      disposeHook: () {
        gateway.removeListener(onGatewayChange);
        unawaited(reconnectedSub.cancel());
        unawaited(readyController.close());
      },
    );
  }

  final String connectionId;
  final String? profile;
  final Stream<StreamEvent> events;
  final Stream<void> ready;
  final bool Function() _isConnected;
  final bool Function()? _sessionAuthority;
  final Future<Map<String, dynamic>> Function(
    String method,
    Map<String, dynamic> params, {
    Duration timeout,
  })
  _call;
  final void Function()? _disposeHook;

  bool get isConnected => _isConnected();

  /// Whether the socket's gateway is a 0.23+ session authority
  /// (`gateway.ready` advertised `session_authority`), whose closed
  /// `config.set` contract decides which settings Ares may change.
  bool get sessionAuthority => _sessionAuthority?.call() ?? false;

  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) => _call(method, params, timeout: timeout);

  void dispose() => _disposeHook?.call();
}

/// Friendly fallback text for gateway wake refusal codes (mirrors Desktop's
/// `REASON_TEXT` in `store/wake-word.ts`), in the app's language. An unknown
/// code is shown as the gateway sent it.
String formatWakeRefusalReason(
  String? reason, {
  String? ownerSurface,
  AppLocalizations? strings,
}) {
  final code = reason?.trim() ?? '';
  if (code.isEmpty) return '';
  final l10n = strings ?? serviceStrings;
  final owner = ownerSurface?.trim() ?? '';
  return switch (code) {
    'disabled' => l10n.wake_word_reason_disabled,
    'disabled_for_surface' => l10n.wake_word_reason_surface,
    'owned' || 'not_owner' =>
      owner.isNotEmpty
          ? l10n.wake_word_reason_owned_by(owner)
          : l10n.wake_word_reason_owned,
    'unavailable' => l10n.wake_word_reason_unavailable,
    'permission_denied' => l10n.wake_word_reason_permission_denied,
    'permission_required' => l10n.wake_word_reason_permission_required,
    _ => code,
  };
}

String _noticeFromPayload(
  Map<String, dynamic> data, {
  String? fallbackOwnerSurface,
}) {
  final hint = data['hint']?.toString().trim() ?? '';
  if (hint.isNotEmpty) return hint;
  final reason = data['reason']?.toString().trim();
  final owner = data['owner_surface']?.toString() ?? fallbackOwnerSurface;
  return formatWakeRefusalReason(reason, ownerSurface: owner);
}

/// Downsamples mono little-endian int16 PCM to 16 kHz when a platform recorder
/// delivers a higher rate than requested.
@visibleForTesting
Uint8List downsampleInt16LeTo16k(Uint8List bytes, int inputRate) {
  const targetRate = 16000;
  if (inputRate <= 0 || bytes.length < 2) return Uint8List(0);
  if (inputRate == targetRate) {
    final evenLen = bytes.length & ~1;
    return evenLen == bytes.length
        ? bytes
        : Uint8List.sublistView(bytes, 0, evenLen);
  }
  final sampleCount = bytes.length ~/ 2;
  final view = ByteData.sublistView(bytes, 0, sampleCount * 2);
  final ratio = inputRate / targetRate;
  final outSamples = math.max(1, (sampleCount / ratio).floor());
  final out = ByteData(outSamples * 2);
  for (var i = 0; i < outSamples; i++) {
    final start = (i * ratio).floor();
    final end = math.min(sampleCount, ((i + 1) * ratio).floor());
    var sum = 0;
    var count = 0;
    for (var j = start; j < end; j++) {
      sum += view.getInt16(j * 2, Endian.little);
      count++;
    }
    final avg = count > 0 ? (sum ~/ count).clamp(-32768, 32767) : 0;
    out.setInt16(i * 2, avg, Endian.little);
  }
  return out.buffer.asUint8List();
}

class _WakePcmFeeder {
  _WakePcmFeeder({
    required this.session,
    required this.frameLength,
    required this.inputSampleRate,
    required this.sendFeed,
    required this.onFatalError,
    required this.silenceFramesThreshold,
    required this.stallTimeout,
    required this.maxConsecutiveFeedFailures,
  });

  static const int targetSampleRate = 16000;
  static const int silencePeakInt16 = 32; // ~ -60 dBFS, matches Desktop 0.001
  static const int maxQueuedFrames = 24;
  static const int maxFramesPerFeed = 4;

  final WakeClientPcmSession session;
  final int frameLength;
  final int inputSampleRate;
  final Future<Map<String, dynamic>> Function(String base64Pcm, int sampleRate)
  sendFeed;
  final void Function(String message) onFatalError;
  final int silenceFramesThreshold;
  final Duration stallTimeout;
  final int maxConsecutiveFeedFailures;

  StreamSubscription<Uint8List>? _sub;
  Timer? _stallTimer;
  final List<Uint8List> _queue = <Uint8List>[];
  final BytesBuilder _carry = BytesBuilder(copy: false);
  int? _oddByte;
  bool _stopped = false;
  bool _failed = false;
  bool _draining = false;
  int _silentFrames = 0;
  int _feedFailures = 0;

  bool get active => !_stopped && !_failed;

  void start() {
    _armStallTimer();
    _sub = session.pcmInt16Le.listen(
      _onChunk,
      onError: (Object error) {
        _fail(serviceStrings.rel_svc_misc_wake_microphone_failed('$error'));
      },
      onDone: () {
        if (!_stopped && !_failed) {
          _fail(serviceStrings.rel_svc_misc_wake_track_ended);
        }
      },
    );
  }

  Future<void> stop() async {
    if (_stopped) return;
    _stopped = true;
    _queue.clear();
    _carry.clear();
    _oddByte = null;
    _stallTimer?.cancel();
    _stallTimer = null;
    final sub = _sub;
    _sub = null;
    try {
      await sub?.cancel();
    } catch (_) {}
    await session.stop();
  }

  void _armStallTimer() {
    if (_stopped || _failed) return;
    _stallTimer?.cancel();
    _stallTimer = Timer(stallTimeout, () {
      _fail(serviceStrings.rel_svc_misc_wake_capture_stalled);
    });
  }

  void _fail(String message) {
    if (_stopped || _failed) return;
    _failed = true;
    unawaited(stop());
    onFatalError(message);
  }

  void _onChunk(Uint8List raw) {
    if (_stopped || _failed || raw.isEmpty) return;
    _armStallTimer();

    Uint8List aligned;
    if (_oddByte != null) {
      final combined = Uint8List(raw.length + 1);
      combined[0] = _oddByte!;
      combined.setRange(1, combined.length, raw);
      _oddByte = null;
      aligned = combined;
    } else {
      aligned = raw;
    }
    if (aligned.length.isOdd) {
      _oddByte = aligned.last;
      aligned = Uint8List.sublistView(aligned, 0, aligned.length - 1);
    }
    if (aligned.isEmpty) return;

    final pcm16k = inputSampleRate == targetSampleRate
        ? aligned
        : downsampleInt16LeTo16k(aligned, inputSampleRate);
    if (pcm16k.isEmpty) return;

    _carry.add(pcm16k);
    final merged = _carry.takeBytes();
    final frameBytes = frameLength * 2;
    var offset = 0;

    while (offset + frameBytes <= merged.length) {
      final frame = Uint8List.fromList(
        Uint8List.sublistView(merged, offset, offset + frameBytes),
      );
      offset += frameBytes;

      final view = ByteData.sublistView(frame);
      var peak = 0;
      for (var i = 0; i < frameLength; i++) {
        final sample = view.getInt16(i * 2, Endian.little);
        final abs = sample == -32768 ? 32768 : sample.abs();
        if (abs > peak) peak = abs;
      }

      if (peak < silencePeakInt16) {
        _silentFrames++;
        if (_silentFrames >= silenceFramesThreshold) {
          _fail(serviceStrings.rel_svc_misc_wake_capture_silent);
          return;
        }
        continue;
      }

      _silentFrames = 0;
      _enqueue(frame);
    }

    if (offset < merged.length) {
      _carry.add(Uint8List.sublistView(merged, offset));
    }
  }

  void _enqueue(Uint8List frame) {
    if (_stopped || _failed) return;
    _queue.add(frame);
    while (_queue.length > maxQueuedFrames) {
      _queue.removeAt(0);
    }
    unawaited(_drain());
  }

  Future<void> _drain() async {
    if (_draining || _stopped || _failed) return;
    _draining = true;
    try {
      while (!_stopped && !_failed && _queue.isNotEmpty) {
        final count = math.min(maxFramesPerFeed, _queue.length);
        final batch = _queue.sublist(0, count);
        _queue.removeRange(0, count);

        final merged = BytesBuilder(copy: false);
        for (final f in batch) {
          merged.add(f);
        }
        final bytes = merged.takeBytes();

        try {
          final result = await sendFeed(base64Encode(bytes), targetSampleRate);
          final accepted = result['fed'] != false;
          _noteFeedResult(accepted, result['reason']?.toString());
        } catch (_) {
          _noteFeedResult(false, null);
        }
      }
    } finally {
      _draining = false;
      if (!_stopped && !_failed && _queue.isNotEmpty) {
        unawaited(_drain());
      }
    }
  }

  void _noteFeedResult(bool accepted, String? reason) {
    if (_stopped || _failed) return;
    if (accepted) {
      _feedFailures = 0;
      return;
    }
    _feedFailures++;
    if (_feedFailures >= maxConsecutiveFeedFailures) {
      final detail = (reason != null && reason.isNotEmpty) ? ' ($reason)' : '';
      _fail(
        serviceStrings.rel_svc_misc_wake_feed_refused(_feedFailures, detail),
      );
    }
  }
}

/// Controller for gateway-backed wake-word detection (`wake.start`, `wake.stop`,
/// `wake.pause`, `wake.resume`, `wake.status`, `wake.feed` and `wake.detected`).
///
/// Mirrors Hermes Desktop (`apps/desktop/src/store/wake-word.ts` +
/// `lib/wake-client-capture.ts`) while remaining opt-in and off by default:
/// `persist: true` is sent ONLY on explicit user gestures (`toggle`,
/// `startExplicit`, `stopExplicit`).
class GatewayWakeWordController extends ChangeNotifier {
  /// Controllers created by a chat's Desktop gateway are shared with Classic
  /// settings by connection id: two owners would fight over wake ownership.
  static final Map<String, GatewayWakeWordController> _sharedByConnection = {};
  static GatewayWakeWordController? sharedForConnection(String connectionId) =>
      _sharedByConnection[connectionId];

  GatewayWakeWordController({
    required this.transport,
    WakeClientPcmSource? pcmSource,
    this.onWakeDetected,
    this.wakeStartTimeout = const Duration(seconds: 180),
    this.resumeRetryDelay = const Duration(milliseconds: 1200),
    this.silenceFramesThreshold = 100,
    this.stallTimeout = const Duration(seconds: 3),
    this.maxConsecutiveFeedFailures = 5,
  }) : _pcmSource = pcmSource ?? const RecordWakeClientPcmSource(),
       _account = ConnectionMutationBarrier.capture(transport.connectionId) {
    _sharedByConnection.putIfAbsent(transport.connectionId, () => this);
    _eventSub = transport.events.listen(_handleGatewayEvent);
    _readySub = transport.ready.listen((_) {
      unawaited(syncOnGatewayReady());
    });
    ConnectionMutationBarrier.addListener(_onAccountMutated);
    if (transport.isConnected) {
      unawaited(syncOnGatewayReady());
    }
  }

  final GatewayWakeTransport transport;
  final WakeClientPcmSource _pcmSource;
  void Function(WakeDetectedEvent event)? onWakeDetected;
  final Duration wakeStartTimeout;
  final Duration resumeRetryDelay;
  final int silenceFramesThreshold;
  final Duration stallTimeout;
  final int maxConsecutiveFeedFailures;

  final Object? _account;
  StreamSubscription<StreamEvent>? _eventSub;
  StreamSubscription<void>? _readySub;
  _WakePcmFeeder? _feeder;

  GatewayWakeState _state = const GatewayWakeState();
  GatewayWakeState get state => _state;

  List<WakeClientInputDevice> _clientDevices = const [];
  List<WakeClientInputDevice> get clientDevices => _clientDevices;
  WakeClientInputDevice? _selectedClientDevice;
  WakeClientInputDevice? get selectedClientDevice => _selectedClientDevice;

  bool _disposed = false;
  bool _appForeground = true;
  bool _voiceActive = false;
  bool _pausedBySelf = false;
  int _epoch = 0;
  String? _boundSessionId;
  Future<void>? _pauseBarrier;

  bool get isOwnerCurrent =>
      !_disposed &&
      ConnectionMutationBarrier.isCurrent(transport.connectionId, _account);

  bool get _shouldPause => !_appForeground || _voiceActive;

  void bindSessionId(String? sessionId) {
    final trimmed = sessionId?.trim();
    _boundSessionId = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Map<String, dynamic> _scopedParams([Map<String, dynamic>? extra]) {
    return <String, dynamic>{
      if (transport.profile != null) 'profile': transport.profile,
      ...?extra,
    };
  }

  void _setState(GatewayWakeState next) {
    _state = next;
    if (!_disposed) notifyListeners();
  }

  void _onAccountMutated() {
    if (!isOwnerCurrent) {
      _epoch++;
      _pausedBySelf = false;
      unawaited(_stopClientCapture());
      _setState(const GatewayWakeState());
    }
  }

  Future<void> refreshClientInputDevices() async {
    if (!isOwnerCurrent) return;
    final devices = await _pcmSource.listInputDevices();
    if (!isOwnerCurrent) return;
    _clientDevices = List.unmodifiable(devices);
    if (_selectedClientDevice != null &&
        !_clientDevices.contains(_selectedClientDevice)) {
      _selectedClientDevice = null;
    }
    notifyListeners();
  }

  Future<void> selectClientInputDevice(WakeClientInputDevice? device) async {
    if (!isOwnerCurrent || _selectedClientDevice == device) return;
    _selectedClientDevice = device;
    notifyListeners();
    if (_state.listening && _state.usesClientMic && !_shouldPause) {
      await _maybeStartClientCapture(
        captureMode: _state.capture,
        sampleRate: _state.sampleRate,
        frameLength: _state.frameLength,
        allowPermissionPrompt: false,
      );
    }
  }

  /// Queries `wake.status` without arming or mutating `wake_word.enabled`.
  Future<GatewayWakeState> refreshStatus() async {
    if (!isOwnerCurrent) return _state;
    final callEpoch = _epoch;
    try {
      final res = await transport.call(
        'wake.status',
        _scopedParams({'surface': 'gui', 'client_capture': true}),
      );
      if (!isOwnerCurrent || callEpoch != _epoch) return _state;
      _applyStatusPayload(res);
    } catch (error) {
      // Older backends without wake.* keep the opt-in off default quietly.
      _noteUnserved(error, callEpoch);
    }
    return _state;
  }

  /// A gateway that answered a status probe with -32601 does not serve the
  /// wake word: nothing is offered (the toggle hides).
  void _noteUnserved(Object error, int callEpoch) {
    if (!_isUnservedMethod(error) || !isOwnerCurrent || callEpoch != _epoch) {
      return;
    }
    _setState(
      _state.copyWith(
        available: false,
        enabled: false,
        listening: false,
        paused: false,
        pending: false,
        notice: '',
      ),
    );
  }

  /// Syncs state when the gateway socket becomes ready. Never flips config
  /// (`persist` is omitted) and never opens the mic unless `wake_word.enabled`
  /// is already true AND OS mic permission is already granted.
  Future<void> syncOnGatewayReady() async {
    if (!isOwnerCurrent) return;
    final callEpoch = _epoch;
    Map<String, dynamic> status;
    try {
      status = await transport.call(
        'wake.status',
        _scopedParams({'surface': 'gui', 'client_capture': true}),
      );
    } catch (error) {
      _noteUnserved(error, callEpoch);
      return;
    }
    if (!isOwnerCurrent || callEpoch != _epoch) return;
    _applyStatusPayload(status);

    if (!_state.available || !_state.enabled) {
      return;
    }
    if (_shouldPause) {
      _pausedBySelf = true;
      _setState(_state.copyWith(listening: false, paused: true));
      return;
    }
    if (_state.listening) {
      if (_state.usesClientMic) {
        await _maybeStartClientCapture(
          captureMode: _state.capture,
          sampleRate: _state.sampleRate,
          frameLength: _state.frameLength,
          allowPermissionPrompt: false,
        );
      }
      return;
    }

    if (_state.usesClientMic) {
      final permitted = await _pcmSource.hasPermission(request: false);
      if (!isOwnerCurrent || callEpoch != _epoch) return;
      if (!permitted) {
        _setState(
          _state.copyWith(
            listening: false,
            reason: 'permission_required',
            notice: formatWakeRefusalReason('permission_required'),
          ),
        );
        return;
      }
    }

    try {
      final started = await transport.call(
        'wake.start',
        _scopedParams({
          'surface': 'gui',
          'client_capture': true,
          if (_boundSessionId != null) 'session_id': _boundSessionId,
        }),
        timeout: wakeStartTimeout,
      );
      if (!isOwnerCurrent || callEpoch != _epoch) return;
      await _applyStartPayload(started, allowPermissionPrompt: false);
    } catch (_) {
      // Transient failure on auto-sync leaves last known status intact.
    }
  }

  /// Explicit user gesture: stops when listening (or enabled+paused), starts
  /// otherwise. Sends `persist: true`.
  Future<bool> toggle({String? sessionId}) {
    if (sessionId != null) bindSessionId(sessionId);
    if (_state.pending) return Future<bool>.value(_state.listening);
    if (_state.listening || (_state.enabled && _state.paused)) {
      return stopExplicit();
    }
    return startExplicit(sessionId: sessionId);
  }

  /// Explicit user gesture to enable and arm wake word (`persist: true`).
  ///
  /// As Desktop's `toggleWakeWord`: the host is asked first, and the
  /// microphone permission is requested only once it has armed client
  /// capture (in [_applyStartPayload]). A gateway that has not offered the
  /// wake word (see [GatewayWakeState.offered]) is never asked to arm.
  Future<bool> startExplicit({String? sessionId}) async {
    if (!isOwnerCurrent || _state.pending || !_state.offered) return false;
    if (sessionId != null) bindSessionId(sessionId);
    final callEpoch = ++_epoch;

    final wasEnabled = _state.enabled;
    _setState(
      _state.copyWith(
        pending: true,
        notice: serviceStrings.wake_word_arming,
        reason: null,
      ),
    );

    try {
      final result = await transport.call(
        'wake.start',
        _scopedParams({
          'persist': true,
          'surface': 'gui',
          'client_capture': true,
          if (_boundSessionId != null) 'session_id': _boundSessionId,
        }),
        timeout: wakeStartTimeout,
      );
      if (!isOwnerCurrent || callEpoch != _epoch) return false;
      final armed = await _applyStartPayload(
        result,
        allowPermissionPrompt: true,
      );
      if (!armed &&
          result['started'] == true &&
          !wasEnabled &&
          isOwnerCurrent &&
          callEpoch == _epoch) {
        // The host armed and saved `enabled`, but this device's microphone
        // was refused: undo the saved choice, so a denied permission leaves
        // the wake word off rather than on-but-deaf.
        try {
          await transport.call('wake.stop', _scopedParams({'persist': true}));
        } catch (_) {}
        if (isOwnerCurrent && callEpoch == _epoch) {
          _setState(_state.copyWith(enabled: false));
        }
      }
      return armed;
    } catch (error) {
      if (!isOwnerCurrent || callEpoch != _epoch) return false;
      await _stopClientCapture();
      // A gateway that does not serve wake.* (a 0.23+ session-authority
      // gateway) has proved it cannot arm: stop offering the toggle.
      final unserved = _isUnservedMethod(error);
      _setState(
        _state.copyWith(
          available: unserved ? false : null,
          enabled: unserved ? false : null,
          listening: false,
          pending: false,
          notice: unserved ? '' : _cleanError(error),
        ),
      );
      return false;
    }
  }

  /// The gateway does not serve the method (Desktop's `isMissingRpcMethod`:
  /// the code decides; a codeless error by its message).
  static bool _isUnservedMethod(Object error) {
    if (error is! JsonRpcError) return false;
    if (error.code != null) return error.code == -32601;
    return error.message.toLowerCase().contains('unknown method');
  }

  /// Explicit user gesture to stop and disable wake word (`persist: true`).
  Future<bool> stopExplicit() async {
    if (!isOwnerCurrent || _state.pending) return false;
    final callEpoch = ++_epoch;
    _pausedBySelf = false;
    await _stopClientCapture();
    _setState(_state.copyWith(pending: true, notice: ''));

    try {
      final result = await transport.call(
        'wake.stop',
        _scopedParams({'persist': true}),
      );
      if (!isOwnerCurrent || callEpoch != _epoch) return false;
      final stopped = result['stopped'] == true;
      final disabledPersisted = result['disabled_persisted'] == true;
      _setState(
        _state.copyWith(
          enabled: disabledPersisted ? false : false,
          listening: false,
          paused: false,
          pending: false,
          reason: stopped ? null : result['reason']?.toString(),
          notice: stopped
              ? ''
              : _noticeFromPayload(
                  result,
                  fallbackOwnerSurface: _state.ownerSurface,
                ),
          clientCaptureActive: false,
        ),
      );
      return true;
    } catch (error) {
      if (!isOwnerCurrent || callEpoch != _epoch) return false;
      _setState(
        _state.copyWith(
          listening: false,
          paused: false,
          pending: false,
          notice: _cleanError(error),
          clientCaptureActive: false,
        ),
      );
      return false;
    }
  }

  /// Whether `wake_word.capture` can be changed from this app. A 0.23+
  /// session authority's closed `config.set` contract has no such key
  /// (Desktop has no capture control either), so Settings disables the
  /// choice there and says why instead of sending a request the wire guard
  /// refuses.
  bool get captureConfigurable =>
      !transport.sessionAuthority ||
      canonicalConfigAvailable('wake_word.capture');

  /// Updates `wake_word.capture` (`auto` | `client` | `local`) on the owning
  /// profile via `config.set`, then reconciles status / capture. Sends
  /// nothing where [captureConfigurable] is false.
  Future<void> setCapturePreference(String mode) async {
    final normalized = mode.trim().toLowerCase();
    if (!const {'auto', 'client', 'local'}.contains(normalized)) return;
    if (!isOwnerCurrent || !captureConfigurable) return;
    await transport.call(
      'config.set',
      _scopedParams({'key': 'wake_word.capture', 'value': normalized}),
    );
    if (!isOwnerCurrent) return;
    if (_state.listening) {
      await rearm();
    } else {
      await refreshStatus();
    }
  }

  /// Re-arms an enabled wake listener without flipping `persist`.
  Future<void> rearm() async {
    if (!isOwnerCurrent) return;
    await _stopClientCapture();
    try {
      await transport.call('wake.stop', _scopedParams());
    } catch (_) {}
    if (!isOwnerCurrent) return;
    final callEpoch = ++_epoch;
    try {
      final result = await transport.call(
        'wake.start',
        _scopedParams({
          'surface': 'gui',
          'client_capture': true,
          if (_boundSessionId != null) 'session_id': _boundSessionId,
        }),
        timeout: wakeStartTimeout,
      );
      if (!isOwnerCurrent || callEpoch != _epoch) return;
      await _applyStartPayload(result, allowPermissionPrompt: true);
    } catch (error) {
      if (!isOwnerCurrent || callEpoch != _epoch) return;
      _setState(
        _state.copyWith(
          listening: false,
          pending: false,
          notice: _cleanError(error),
        ),
      );
    }
  }

  /// Updates app foreground state; backgrounding pauses wake detection and
  /// releases the client mic immediately, and resuming reconciles it.
  void setAppForeground(bool foreground) {
    if (_appForeground == foreground || _disposed) return;
    _appForeground = foreground;
    _syncPauseState();
  }

  /// Updates hands-free / dictation / TTS / live-voice activity; active voice
  /// pauses wake detection and releases the mic, and ending reconciles it.
  void setPausedForVoice(bool active) {
    if (_voiceActive == active || _disposed) return;
    _voiceActive = active;
    _syncPauseState();
  }

  /// Awaitable barrier that releases the client mic and finishes `wake.pause`
  /// before a voice conversation or dictation opens the capture device.
  Future<void> pauseForVoice() {
    _voiceActive = true;
    _syncPauseState();
    return _pauseBarrier ?? Future<void>.value();
  }

  void _syncPauseState() {
    if (!isOwnerCurrent) return;
    if (_shouldPause) {
      final wasActive =
          _state.listening ||
          _state.enabled ||
          _feeder != null ||
          _pausedBySelf;
      if (!wasActive) return;
      _pausedBySelf = _state.listening || _state.enabled || _pausedBySelf;
      final pauseEpoch = ++_epoch;
      final stoppingClient = _stopClientCapture();
      if (_state.listening || _state.enabled) {
        _setState(
          _state.copyWith(
            listening: false,
            paused: true,
            pending: false,
            clientCaptureActive: false,
          ),
        );
      }
      final barrier = () async {
        await stoppingClient;
        if (!isOwnerCurrent || pauseEpoch != _epoch || !transport.isConnected) {
          return;
        }
        try {
          await transport.call('wake.pause', _scopedParams());
        } catch (_) {}
      }();
      _pauseBarrier = barrier;
      return;
    }

    _pauseBarrier = null;
    if (_pausedBySelf) {
      _pausedBySelf = false;
      unawaited(_resumeAfterPause());
    }
  }

  Future<void> _resumeAfterPause() async {
    if (!isOwnerCurrent || _shouldPause || !transport.isConnected) return;
    final callEpoch = ++_epoch;
    try {
      await transport.call('wake.resume', _scopedParams());
    } catch (_) {
      if (isOwnerCurrent && callEpoch == _epoch) {
        _setState(_state.copyWith(paused: false));
      }
      return;
    }

    for (var attempt = 0; attempt < 3; attempt++) {
      if (!isOwnerCurrent || callEpoch != _epoch || _shouldPause) return;
      try {
        final status = await transport.call(
          'wake.status',
          _scopedParams({'surface': 'gui', 'client_capture': true}),
        );
        if (!isOwnerCurrent || callEpoch != _epoch || _shouldPause) return;
        _applyStatusPayload(status);

        if (!_state.enabled || !_state.available) {
          _setState(_state.copyWith(paused: false, listening: false));
          return;
        }
        if (_state.listening) {
          _setState(_state.copyWith(paused: false));
          if (_state.usesClientMic) {
            await _maybeStartClientCapture(
              captureMode: _state.capture,
              sampleRate: _state.sampleRate,
              frameLength: _state.frameLength,
              allowPermissionPrompt: false,
            );
          }
          return;
        }

        final started = await transport.call(
          'wake.start',
          _scopedParams({
            'surface': 'gui',
            'client_capture': true,
            if (_boundSessionId != null) 'session_id': _boundSessionId,
          }),
          timeout: wakeStartTimeout,
        );
        if (!isOwnerCurrent || callEpoch != _epoch || _shouldPause) return;
        final ok = await _applyStartPayload(
          started,
          allowPermissionPrompt: false,
        );
        if (ok) return;
        final reason = started['reason']?.toString();
        if (reason == 'owned' ||
            reason == 'disabled' ||
            reason == 'disabled_for_surface' ||
            reason == 'unavailable') {
          return;
        }
      } catch (_) {
        // Transient mic-release race; retry after delay.
      }
      if (attempt < 2 && resumeRetryDelay > Duration.zero) {
        await Future<void>.delayed(resumeRetryDelay);
      }
    }
    if (isOwnerCurrent && callEpoch == _epoch) {
      _setState(_state.copyWith(paused: false));
    }
  }

  void _applyStatusPayload(Map<String, dynamic> status) {
    final listening = status['listening'] == true;
    final silent = status['audio_silent'] == true;
    final phrase = status['phrase']?.toString().trim() ?? '';
    final sampleRate = (status['sample_rate'] as num?)?.toInt() ?? 16000;
    final frameLength = (status['frame_length'] as num?)?.toInt() ?? 1280;
    final rawDevice = status['input_device'];
    final device = rawDevice is Map<String, dynamic>
        ? WakeServerInputDevice.fromJson(rawDevice)
        : rawDevice is Map
        ? WakeServerInputDevice.fromJson(Map<String, dynamic>.from(rawDevice))
        : null;
    final hint = status['hint']?.toString().trim() ?? '';
    final notice = (listening && !silent)
        ? ''
        : _noticeFromPayload(
            status,
            fallbackOwnerSurface: status['owner_surface']?.toString(),
          );
    _setState(
      _state.copyWith(
        available: status['available'] == true,
        enabled: status['enabled'] == true,
        listening: listening,
        paused: _shouldPause && (status['enabled'] == true || listening),
        audioSilent: silent,
        phrase: phrase.isEmpty ? _state.phrase : phrase,
        provider: status['provider']?.toString() ?? _state.provider,
        capture: status['capture']?.toString() ?? _state.capture,
        configuredSurface:
            status['configured_surface']?.toString() ??
            _state.configuredSurface,
        ownerSurface: status['owner_surface']?.toString(),
        ownedByCaller: status['owned_by_caller'] == true,
        localInputAvailable: status['local_input_available'] == true,
        sampleRate: sampleRate > 0 ? sampleRate : 16000,
        frameLength: math.max(160, frameLength),
        hint: hint,
        notice: notice,
        serverInputDevice: device,
      ),
    );
  }

  Future<bool> _applyStartPayload(
    Map<String, dynamic> result, {
    required bool allowPermissionPrompt,
  }) async {
    final started = result['started'] == true;
    final phrase = result['phrase']?.toString().trim() ?? '';
    final capture = result['capture']?.toString() ?? _state.capture;
    final sampleRate =
        (result['sample_rate'] as num?)?.toInt() ?? _state.sampleRate;
    final frameLength =
        (result['frame_length'] as num?)?.toInt() ?? _state.frameLength;

    if (started) {
      _setState(
        _state.copyWith(
          available: true,
          enabled: true,
          listening: !_shouldPause,
          paused: _shouldPause,
          pending: false,
          audioSilent: false,
          phrase: phrase.isEmpty ? _state.phrase : phrase,
          provider: result['provider']?.toString() ?? _state.provider,
          capture: capture,
          ownerSurface: result['owner_surface']?.toString() ?? 'gui',
          ownedByCaller: true,
          sampleRate: sampleRate > 0 ? sampleRate : 16000,
          frameLength: math.max(160, frameLength),
          reason: null,
          hint: '',
          notice: '',
        ),
      );
      if (_shouldPause) {
        _pausedBySelf = true;
        await _stopClientCapture();
        try {
          await transport.call('wake.pause', _scopedParams());
        } catch (_) {}
        return true;
      }
      await _maybeStartClientCapture(
        captureMode: capture,
        sampleRate: sampleRate > 0 ? sampleRate : 16000,
        frameLength: math.max(160, frameLength),
        allowPermissionPrompt: allowPermissionPrompt,
      );
      return _state.listening;
    }

    await _stopClientCapture();
    final reason = result['reason']?.toString();
    _setState(
      _state.copyWith(
        available: reason == 'unavailable' ? false : _state.available,
        listening: false,
        paused: false,
        pending: false,
        ownerSurface:
            result['owner_surface']?.toString() ?? _state.ownerSurface,
        ownedByCaller: false,
        capture: capture,
        reason: reason,
        hint: result['hint']?.toString().trim() ?? '',
        notice: _noticeFromPayload(
          result,
          fallbackOwnerSurface: _state.ownerSurface,
        ),
        clientCaptureActive: false,
      ),
    );
    return false;
  }

  Future<void> _maybeStartClientCapture({
    required String captureMode,
    required int sampleRate,
    required int frameLength,
    required bool allowPermissionPrompt,
  }) async {
    await _stopClientCapture();
    final mode = captureMode.trim().toLowerCase();
    if (mode != 'client' && mode != 'remote' && mode != 'external') {
      _setState(_state.copyWith(clientCaptureActive: false));
      return;
    }

    final callEpoch = _epoch;
    try {
      final permitted = await _pcmSource.hasPermission(
        request: allowPermissionPrompt,
      );
      if (!isOwnerCurrent || callEpoch != _epoch) return;
      if (!permitted) {
        throw StateError(
          allowPermissionPrompt
              ? formatWakeRefusalReason('permission_denied')
              : formatWakeRefusalReason('permission_required'),
        );
      }

      final session = await _pcmSource.startStream(
        sampleRate: sampleRate,
        device: _selectedClientDevice,
      );
      if (!isOwnerCurrent || callEpoch != _epoch || _shouldPause) {
        await session.stop();
        return;
      }

      final feeder = _WakePcmFeeder(
        session: session,
        frameLength: math.max(160, frameLength),
        inputSampleRate: sampleRate,
        silenceFramesThreshold: silenceFramesThreshold,
        stallTimeout: stallTimeout,
        maxConsecutiveFeedFailures: maxConsecutiveFeedFailures,
        sendFeed: (b64, rate) => transport.call(
          'wake.feed',
          _scopedParams({'pcm': b64, 'sample_rate': rate}),
        ),
        onFatalError: (message) {
          if (!isOwnerCurrent) return;
          _feeder = null;
          _setState(
            _state.copyWith(
              listening: false,
              pending: false,
              notice: message,
              clientCaptureActive: false,
            ),
          );
          unawaited(
            transport
                .call('wake.stop', _scopedParams())
                .then<void>((_) {}, onError: (_, _) {}),
          );
        },
      );
      _feeder = feeder;
      feeder.start();
      _setState(_state.copyWith(clientCaptureActive: true));
    } catch (error) {
      if (!isOwnerCurrent || callEpoch != _epoch) return;
      _setState(
        _state.copyWith(
          listening: false,
          pending: false,
          notice: _cleanError(error),
          clientCaptureActive: false,
        ),
      );
      try {
        await transport.call('wake.stop', _scopedParams());
      } catch (_) {}
    }
  }

  Future<void> _stopClientCapture() async {
    final active = _feeder;
    _feeder = null;
    if (active != null) {
      await active.stop();
    }
  }

  void _handleGatewayEvent(StreamEvent event) {
    if (event.type != 'wake.detected' || !isOwnerCurrent) return;
    unawaited(_stopClientCapture());
    if (!_appForeground) {
      _pausedBySelf = true;
      _setState(
        _state.copyWith(
          listening: false,
          paused: true,
          clientCaptureActive: false,
        ),
      );
      return;
    }
    _pausedBySelf = true;
    _voiceActive = true;
    _setState(
      _state.copyWith(
        listening: false,
        paused: true,
        clientCaptureActive: false,
      ),
    );
    final detected = WakeDetectedEvent.fromData(
      event.data,
      fallbackPhrase: _state.phrase,
    );
    onWakeDetected?.call(detected);
  }

  static String _cleanError(Object error) {
    final raw = error.toString().trim();
    return raw
        .replaceFirst('Bad state: ', '')
        .replaceFirst('Exception: ', '')
        .replaceFirst(RegExp(r'^JsonRpcError\([^)]*\):\s*'), '');
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _epoch++;
    ConnectionMutationBarrier.removeListener(_onAccountMutated);
    unawaited(_eventSub?.cancel());
    unawaited(_readySub?.cancel());
    unawaited(_stopClientCapture());
    if (_state.listening && transport.isConnected) {
      unawaited(
        transport
            .call('wake.stop', _scopedParams())
            .then<void>((_) {}, onError: (_, _) {}),
      );
    }
    if (identical(_sharedByConnection[transport.connectionId], this)) {
      _sharedByConnection.remove(transport.connectionId);
    }
    transport.dispose();
    super.dispose();
  }
}
