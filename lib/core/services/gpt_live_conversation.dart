import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../l10n/service_strings.dart';
import 'connection_manager.dart';

/// Which voice engine the active profile selected, and whether GPT-Live can
/// start. Never carries the project API key: the gateway performs session
/// creation and only returns a session id plus the SDP answer.
@immutable
class GptLiveStatus {
  const GptLiveStatus({
    required this.mode,
    required this.available,
    required this.reason,
    required this.model,
    required this.voice,
  });

  final String mode;
  final bool available;
  final String? reason;
  final String model;
  final String voice;
  bool get isLive => mode == 'gpt-live';

  @override
  String toString() => 'GptLiveStatus($mode, available: $available)';
}

@immutable
class GptLiveSession {
  const GptLiveSession({required this.id, required this.sdp});
  final String? id;
  final String sdp;
}

GptLiveStatus? parseGptLiveStatus(Object? body) {
  if (body is! Map || body['ok'] != true) return null;
  final mode = body['mode']?.toString() ?? 'chained';
  return GptLiveStatus(
    mode: mode == 'gpt-live' ? 'gpt-live' : 'chained',
    available: body['available'] == true,
    reason: body['reason']?.toString().trim().isEmpty ?? true
        ? null
        : body['reason']!.toString().trim(),
    model: body['model']?.toString().trim().isEmpty ?? true
        ? 'gpt-live-1'
        : body['model']!.toString().trim(),
    voice: body['voice']?.toString().trim().isEmpty ?? true
        ? 'marin'
        : body['voice']!.toString().trim(),
  );
}

GptLiveSession? parseGptLiveSession(Object? body) {
  if (body is! Map || body['ok'] != true) return null;
  final transport = body['transport'];
  if (transport is! Map) return null;
  final sdp = transport['sdp']?.toString() ?? '';
  if (sdp.trim().isEmpty) return null;
  final session = body['session'];
  final id = session is Map ? session['id']?.toString() : null;
  return GptLiveSession(sdp: sdp, id: id);
}

@immutable
class LiveFragment {
  const LiveFragment({
    required this.speaker,
    required this.text,
    this.startMs = 0,
    this.endMs = 0,
  });
  final String speaker;
  final String text;
  final int startMs;
  final int endMs;
}

/// Last user words become the persisted turn; the recent spoken exchange
/// rides along as model-input context, mirroring Desktop's `delegationPrompt`.
Map<String, String> delegationPrompt(List<LiveFragment> fragments) {
  final turns = <LiveFragment>[];
  for (final fragment in fragments) {
    if (turns.isNotEmpty && turns.last.speaker == fragment.speaker) {
      final previous = turns.removeLast();
      turns.add(
        LiveFragment(
          speaker: previous.speaker,
          text: previous.text + fragment.text,
          startMs: previous.startMs,
          endMs: fragment.endMs,
        ),
      );
    } else {
      turns.add(fragment);
    }
  }
  LiveFragment? lastUser;
  for (final turn in turns.reversed) {
    if (turn.speaker == 'user') {
      lastUser = turn;
      break;
    }
  }
  final prompt = (lastUser?.text ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
  final context = turns
      .map(
        (turn) =>
            '${turn.speaker == 'user' ? 'User' : 'Voice assistant'}: '
            '${turn.text.replaceAll(RegExp(r'\s+'), ' ').trim()}',
      )
      .where((line) => !line.endsWith(': '))
      .join('\n');
  return {
    // Desktop: `prompt || transcript.slice(-400)`, the most recent words.
    'prompt': prompt.isNotEmpty
        ? prompt
        : context.substring(context.length > 400 ? context.length - 400 : 0),
    'context': context,
  };
}

/// How much conversation the backend receives per delegation (Desktop's
/// `CONTEXT_WINDOW_MS` and `CONTEXT_MAX_FRAGMENTS`).
const int liveContextWindowMs = 5 * 60000;
const int liveContextMaxFragments = 80;

/// Recent conversation, oldest first, bounded by time and count. The vendor's
/// `start_ms` / `end_ms` are milliseconds from the start of the session, so
/// the window is measured back from the last fragment's end, never from the
/// wall clock (Desktop's `VoiceLiveSession.contextWindow`).
List<LiveFragment> liveContextWindow(List<LiveFragment> transcript) {
  if (transcript.isEmpty) return const [];
  final floor = transcript.last.endMs - liveContextWindowMs;
  final window = [
    for (final fragment in transcript)
      if (fragment.endMs >= floor) fragment,
  ];
  return window.length > liveContextMaxFragments
      ? window.sublist(window.length - liveContextMaxFragments)
      : window;
}

/// Vendor cap: 500 tokens per append. ~4 chars/token, keep headroom
/// (Desktop's `APPEND_CHAR_LIMIT`).
const int liveAppendCharLimit = 1400;

/// Splits a reply into append-sized chunks on sentence boundaries.
List<String> chunkForCommentary(
  String text, {
  int limit = liveAppendCharLimit,
}) {
  final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (clean.isEmpty) return const [];
  if (clean.length <= limit) return [clean];
  final chunks = <String>[];
  var current = '';
  for (final sentence in clean.split(RegExp(r'(?<=[.!?])\s+'))) {
    if (sentence.length > limit) {
      if (current.isNotEmpty) {
        chunks.add(current);
        current = '';
      }
      for (var i = 0; i < sentence.length; i += limit) {
        chunks.add(
          sentence.substring(i, (i + limit).clamp(0, sentence.length)),
        );
      }
      continue;
    }
    final candidate = current.isEmpty ? sentence : '$current $sentence';
    if (candidate.length > limit) {
      chunks.add(current);
      current = sentence;
    } else {
      current = candidate;
    }
  }
  if (current.isNotEmpty) chunks.add(current);
  return chunks;
}

/// Desktop's per-turn cap on seeded history text.
const int liveHistoryTurnCharLimit = 1200;

/// Seed history for a new Live session from the chat transcript (text turns
/// only), newest kept first. Mirrors Desktop's `toLiveHistory`: every item is
/// a `{type: 'message', role, content}` message, each turn cut to
/// [liveHistoryTurnCharLimit] characters.
List<Map<String, dynamic>> toLiveHistory(
  List<({String role, String text})> turns, {
  int maxMessages = 24,
  int maxChars = 6000,
}) {
  final history = <Map<String, dynamic>>[];
  var budget = maxChars;
  for (final turn in turns.reversed) {
    final clean = turn.text.replaceAll(RegExp(r'\s+'), ' ').trim();
    final text = clean.length > liveHistoryTurnCharLimit
        ? clean.substring(0, liveHistoryTurnCharLimit)
        : clean;
    if (text.isEmpty) continue;
    if (history.length >= maxMessages || budget - text.length < 0) break;
    budget -= text.length;
    history.insert(0, {
      'type': 'message',
      'role': turn.role,
      'content': [
        {
          'type': turn.role == 'assistant' ? 'output_text' : 'input_text',
          'text': text,
        },
      ],
    });
  }
  return history;
}

/// Gateway transport for the two non-secret GPT-Live endpoints. The project
/// key never travels through these calls: session creation happens on the host.
abstract interface class GptLiveTransport {
  Future<Object?> status();
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  });
  void dispose();
}

class GptLiveGatewayTransport implements GptLiveTransport {
  GptLiveGatewayTransport(SavedConnection connection, {this.profile})
    : _dashboard = DashboardClient.fromConnection(connection),
      ownsDashboard = true;

  GptLiveGatewayTransport.fromDashboard(
    DashboardClient dashboard, {
    this.profile,
    this.ownsDashboard = false,
  }) : _dashboard = dashboard;

  final String? profile;
  final DashboardClient _dashboard;
  final bool ownsDashboard;

  Map<String, String> get _query {
    final scope = profile;
    return {'profile': ?scope};
  }

  @override
  Future<Object?> status() async {
    final response = await _dashboard.apiRequest(
      'GET',
      'audio/voice-live/status',
      queryParameters: _query,
    );
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  /// The host dials the vendor before it answers: Desktop's `timeoutMs`.
  static const Duration sessionTimeout = Duration(seconds: 45);

  @override
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  }) async {
    final response = await _dashboard.apiRequest(
      'POST',
      'audio/voice-live/session',
      queryParameters: _query,
      timeout: sessionTimeout,
      body: <String, dynamic>{'sdp': sdp}
        ..addAll(history == null ? <String, dynamic>{} : {'history': history}),
    );
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  @override
  void dispose() {
    if (ownsDashboard) _dashboard.close();
  }
}

/// Minimal interface over the live conversation so callers can inject fakes in
/// tests without a real WebRTC peer.
abstract class LiveConversation {
  bool get active;
  String? get sessionId;
  String? get delegationId;

  Future<bool> start({List<Map<String, dynamic>>? history});
  void speak(String text, {String? delegationId});
  void think(String text, {String? delegationId});
  void instruct(String text);
  void setMuted(bool muted);
  Future<void> close();
  Future<void> forceClose(String reason, [int? usageSeconds]);
  void dispose();

  set onDelegation(
    void Function(String id, Map<String, String> prompt)? callback,
  );
  set onTranscript(void Function(LiveFragment fragment)? callback);
  set onError(void Function(String message, bool fatal)? callback);
  set onClosed(void Function(String reason, int? usageSeconds)? callback);
}

/// Optional capability of a [LiveConversation]: whether it still holds the
/// capture device. A session the user stopped keeps its peer (and so the
/// microphone) until the vendor answers `session.close`; wake-word capture
/// must stay paused until this turns false.
abstract interface class LiveMicrophoneOwner {
  bool get holdsMicrophone;
}

/// Optional capability of a [LiveConversation]: take the status the caller
/// has just read, so the next start does not read `/voice-live/status`
/// again (one status read per start).
abstract interface class LiveStatusPrimer {
  void primeStatus(GptLiveStatus status);
}

/// Optional capability of a [LiveConversation]: whether the voice's audio is
/// playing, measured on the remote track (Desktop's `onSpeakingChange`).
/// Silent where the platform reports no inbound audio level.
abstract interface class LiveSpeakingSignal {
  set onSpeakingChange(void Function(bool speaking)? callback);
}

/// How long a graceful close waits for the vendor's `session.closed` before
/// the peer is closed and the tracks stopped anyway (Desktop's
/// `CLOSE_TIMEOUT_MS`).
const Duration liveCloseTimeout = Duration(seconds: 15);

/// Full-duplex GPT-Live conversation. Owns the WebRTC media session and the
/// `oai-events` data channel; a delegation is handed to the caller as a prompt
/// plus spoken context, and the caller streams Hermes' answer back with
/// [speak]. The vendor key stays on the gateway host.
class GptLiveConversation extends ChangeNotifier
    implements
        LiveConversation,
        LiveMicrophoneOwner,
        LiveSpeakingSignal,
        LiveStatusPrimer {
  GptLiveConversation({
    required this.transport,
    this.onDelegation,
    this.onTranscript,
    this.onError,
    this.onClosed,
    this.peerConnectionFactory,
    this.microphoneFactory,
    this.closeTimeout = liveCloseTimeout,
  });

  final GptLiveTransport transport;

  /// Fallback for a graceful [close] the vendor never answers.
  final Duration closeTimeout;
  final Future<RTCPeerConnection> Function()? peerConnectionFactory;
  final Future<MediaStream> Function()? microphoneFactory;

  /// LiveConversation-facing callbacks (plain fields; auto-getters/setters).
  void Function(String id, Map<String, String> prompt)? onDelegation;
  void Function(String message, bool fatal)? onError;
  void Function(String reason, int? usageSeconds)? onClosed;

  /// Deltas, user or assistant.
  void Function(LiveFragment fragment)? onTranscript;

  /// Fires when the vendor pauses the audio stream without closing.
  void Function()? onGap;

  /// The voice's audio started or stopped playing (inbound audio level).
  @override
  void Function(bool speaking)? onSpeakingChange;

  /// How often the inbound audio level is read (Desktop polls its analyser
  /// every 100 ms; a stats read crosses the platform channel, so less often).
  static const Duration speakingProbeInterval = Duration(milliseconds: 200);

  /// Inbound `audioLevel` (0..1, linear) above which the voice is speaking.
  static const double speakingLevel = 0.02;

  /// Quiet reads before the voice counts as silent (a short hangover, as
  /// Desktop's four 100 ms frames).
  static const int speakingHangover = 2;

  Timer? _speakingProbe;
  bool _probing = false;
  bool _lastSpeaking = false;
  int _quietReads = speakingHangover;

  RTCPeerConnection? _peer;
  RTCDataChannel? _events;
  MediaStream? _microphone;
  final List<LiveFragment> _transcript = [];
  bool _active = false;
  int _eventId = 0;
  String? _delegationId;
  String? _sessionId;

  /// Finalized: the peer, channel and tracks are released (or being
  /// released) and no further event is delivered for that session.
  bool _closed = false;
  bool _disposed = false;

  /// Armed by a graceful [close]; fires [closeTimeout] later.
  Timer? _closeTimer;
  Future<void>? _finishing;

  /// Moved on by every start and every teardown. A start that finds it
  /// changed after an await was torn down and must stop there.
  int _run = 0;

  /// The run of the start in flight, if any.
  int? _startingRun;

  /// The data channel reported closing or closed: nothing more can be sent.
  bool _eventsDead = false;

  @override
  bool get holdsMicrophone => _microphone != null;

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  bool get active => _active;
  @override
  String? get sessionId => _sessionId;
  @override
  String? get delegationId => _delegationId;
  List<LiveFragment> get transcript => List.unmodifiable(_transcript);

  Future<GptLiveStatus?> refreshStatus() async {
    final status = parseGptLiveStatus(await transport.status());
    _safeNotify();
    return status;
  }

  GptLiveStatus? _primedStatus;

  @override
  void primeStatus(GptLiveStatus status) => _primedStatus = status;

  @override
  Future<bool> start({
    List<Map<String, dynamic>>? history,
    Duration iceTimeout = const Duration(seconds: 10),
  }) async {
    if (_disposed || _active || _startingRun != null) return false;
    final run = ++_run;
    _startingRun = run;
    // Teardown (dispose, stop, a hidden chat, sign-out, background) can land
    // during any await below. It releases what the fields hold and moves
    // [_run] on; this run then releases whatever it acquired afterwards and
    // sends nothing more.
    bool cancelled() => _disposed || run != _run;
    RTCPeerConnection? peer;
    MediaStream? microphone;
    RTCDataChannel? events;
    Future<bool> abandon() async {
      await _release(events, peer, microphone);
      if (identical(_microphone, microphone)) _microphone = null;
      return false;
    }

    try {
      // A previous session still waiting for the vendor's `session.closed`
      // is finished first: one peer and one microphone at a time.
      if (_peer != null ||
          _microphone != null ||
          _events != null ||
          _finishing != null) {
        await _finish('close_requested', null, false);
        if (cancelled()) return false;
      }
      _closed = false;
      _eventsDead = false;
      // The caller's fresh read, if it primed one; otherwise read it here.
      final primed = _primedStatus;
      _primedStatus = null;
      final status = primed ?? await refreshStatus();
      if (cancelled()) return false;
      if (status == null || !status.isLive || !status.available) return false;
      peer = await (peerConnectionFactory ?? _createPeer)();
      if (cancelled()) return abandon();
      _peer = peer;
      // A dropped transport ends the session (Desktop: `connection_lost`).
      peer.onConnectionState = (state) {
        if (!identical(_peer, peer)) return;
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
            state ==
                RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
          unawaited(_finish('connection_lost'));
        }
      };
      // The OS permission prompt lives in this await on first use.
      microphone = await (microphoneFactory ?? _defaultGetUserMedia)();
      if (cancelled()) return abandon();
      _microphone = microphone;
      for (final track in microphone.getAudioTracks()) {
        await peer.addTrack(track, microphone);
        if (cancelled()) return abandon();
      }
      // Register the data channel before the offer so its m-line is
      // negotiated.
      events = await peer.createDataChannel('oai-events', RTCDataChannelInit());
      if (cancelled()) return abandon();
      _events = events;
      events.onMessage = (message) {
        if (identical(_events, events)) handleEvent(message.text);
      };
      // Our own close nulls [_events] first, so only a channel that closed
      // under the session lands here (Desktop: `if (!finalized) finish`).
      events.onDataChannelState = (state) {
        if (!identical(_events, events)) return;
        if (state == RTCDataChannelState.RTCDataChannelClosing ||
            state == RTCDataChannelState.RTCDataChannelClosed) {
          _eventsDead = true;
        }
        if (state == RTCDataChannelState.RTCDataChannelClosed) {
          unawaited(_finish('connection_lost'));
        }
      };
      final offer = await peer.createOffer();
      if (cancelled()) return abandon();
      await peer.setLocalDescription(offer);
      if (cancelled()) return abandon();
      await _waitForIce(peer, iceTimeout, cancelled);
      if (cancelled()) return abandon();
      final sdp = (await peer.getLocalDescription())?.sdp ?? '';
      if (cancelled()) return abandon();
      if (sdp.trim().isEmpty) {
        throw StateError('Missing local SDP offer');
      }
      // Never reached after teardown: no vendor session is created for a
      // chat that is gone.
      final result = parseGptLiveSession(
        await transport.createSession(sdp: sdp, history: history),
      );
      // Torn down while the POST was in flight: the answer is not applied
      // and the vendor session ends with the peer released here.
      if (cancelled()) return abandon();
      if (result == null) throw StateError('GPT-Live session creation failed');
      _sessionId = result.id;
      await peer.setRemoteDescription(
        RTCSessionDescription(result.sdp, 'answer'),
      );
      if (cancelled()) return abandon();
      _active = true;
      _armSpeakingProbe(peer);
      _safeNotify();
      return true;
    } catch (error) {
      // A call on a peer that teardown already closed fails; that is the
      // teardown, not a start error.
      if (cancelled()) return abandon();
      onError?.call(serviceStrings.voice_live_start_failed('$error'), true);
      await _finish('start_failed');
      return false;
    } finally {
      if (_startingRun == run) _startingRun = null;
    }
  }

  Future<RTCPeerConnection> _createPeer() =>
      createPeerConnection(<String, dynamic>{}, <String, dynamic>{});

  Future<MediaStream> _defaultGetUserMedia() =>
      RTCFactoryNative.instance.navigator.mediaDevices.getUserMedia({
        'audio': {
          'autoGainControl': true,
          'echoCancellation': true,
          'noiseSuppression': true,
        },
      });

  /// Desktop's `armSpeakingProbe`: reads the remote track's level and reports
  /// when the voice starts and stops speaking. A platform whose stats carry
  /// no inbound audio level reports nothing; the engine then goes by the
  /// output transcript.
  void _armSpeakingProbe(RTCPeerConnection peer) {
    _speakingProbe?.cancel();
    _lastSpeaking = false;
    _quietReads = speakingHangover;
    _speakingProbe = Timer.periodic(
      speakingProbeInterval,
      (_) => unawaited(_probeSpeaking(peer)),
    );
  }

  Future<void> _probeSpeaking(RTCPeerConnection peer) async {
    if (_probing || !_active || !identical(_peer, peer)) return;
    _probing = true;
    try {
      final reports = await peer.getStats();
      if (!_active || !identical(_peer, peer)) return;
      double? level;
      for (final report in reports) {
        final values = report.values;
        final kind = values['kind'] ?? values['mediaType'];
        if (report.type != 'inbound-rtp' || kind != 'audio') continue;
        final raw = values['audioLevel'];
        final value = raw is num ? raw.toDouble() : double.tryParse('$raw');
        if (value != null && (level == null || value > level)) level = value;
      }
      if (level == null) return;
      final loud = level > speakingLevel;
      _quietReads = loud ? 0 : _quietReads + 1;
      final speaking = loud || _quietReads < speakingHangover;
      if (speaking != _lastSpeaking) {
        _lastSpeaking = speaking;
        onSpeakingChange?.call(speaking);
      }
    } catch (_) {
      // No level this time: the conversation goes on without it.
    } finally {
      _probing = false;
    }
  }

  Future<void> _waitForIce(
    RTCPeerConnection peer,
    Duration timeout,
    bool Function() cancelled,
  ) async {
    final deadline = DateTime.now().add(timeout);
    while (!cancelled() &&
        peer.iceGatheringState !=
            RTCIceGatheringState.RTCIceGatheringStateComplete &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Visible for tests: maps a vendor data-channel event to app callbacks.
  @visibleForTesting
  void handleEvent(String raw) {
    Map<String, dynamic> event;
    try {
      event = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return;
    }
    if (_disposed) return;
    // After a graceful close only the vendor's goodbye matters: a late
    // delegation or transcript must not start a turn or change the state.
    if (_closeTimer != null && event['type'] != 'session.closed') return;
    switch (event['type']) {
      case 'session.started':
        final session = event['session'];
        if (session is Map) {
          _sessionId = session['id']?.toString() ?? _sessionId;
        }
        _safeNotify();
      case 'session.input_transcript.delta':
      case 'session.output_transcript.delta':
        final fragment = LiveFragment(
          speaker: event['type'] == 'session.input_transcript.delta'
              ? 'user'
              : 'assistant',
          text: event['delta']?.toString() ?? '',
          startMs: (event['start_ms'] as num?)?.toInt() ?? 0,
          endMs: (event['end_ms'] as num?)?.toInt() ?? 0,
        );
        _transcript.add(fragment);
        if (_transcript.length > 2000) {
          _transcript.removeRange(0, _transcript.length - 1500);
        }
        onTranscript?.call(fragment);
      case 'session.delegation.created':
        final delegation = event['delegation'];
        if (delegation is Map && delegation['id'] != null) {
          _delegationId = delegation['id'].toString();
          onDelegation?.call(
            _delegationId!,
            delegationPrompt(liveContextWindow(_transcript)),
          );
        }
      case 'error':
        final error = event['error'];
        final code = error is Map ? error['code']?.toString() ?? '' : '';
        // Late appends after our own close are expected vendor noise.
        if (code != 'context_injection_incomplete') {
          final message = error is Map
              ? error['message']?.toString() ?? 'GPT-Live error'
              : 'GPT-Live error';
          onError?.call(message, false);
        }
      case 'gap':
        // Vendor pauses the stream without closing the session. Surface it so
        // the caller can keep the conversation alive.
        onGap?.call();
      case 'session.closed':
        final usage = event['usage'];
        unawaited(
          _finish(
            event['reason']?.toString() ?? 'closed',
            usage is Map ? (usage['seconds'] as num?)?.toInt() : null,
          ),
        );
    }
  }

  String _nextEventId(String kind) => '$kind-${++_eventId}';

  bool _send(Map<String, dynamic> payload) {
    final channel = _events;
    if (channel == null || _eventsDead) return false;
    try {
      // A send that fails later (the channel closed under it) must not
      // surface as an unhandled error; the close handling ends the session.
      unawaited(
        channel
            .send(RTCDataChannelMessage(jsonEncode(payload)))
            .catchError((Object _) {}),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  /// Streams an Hermes answer back to the voice model for paraphrasing.
  void speak(String text, {String? delegationId}) {
    final id = delegationId ?? _delegationId;
    for (final chunk in chunkForCommentary(text)) {
      _send({
        'type': 'session.commentary.append',
        'content': chunk,
        'delegation_id': id,
        'event_id': _nextEventId('say'),
      });
    }
  }

  @override
  void think(String text, {String? delegationId}) {
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.isEmpty) return;
    _send({
      'type': 'session.thinking.append',
      'content': clean.substring(0, clean.length.clamp(0, 1400)),
      'delegation_id': delegationId ?? _delegationId,
      'event_id': _nextEventId('think'),
    });
  }

  /// Steers the live persona mid-conversation (session-wide), e.g. "finish
  /// and respond now". Desktop's `VoiceLiveSession.instruct`: the vendor
  /// event is `session.instructions.append` with `content` and an explicit
  /// null `delegation_id`.
  @override
  void instruct(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;
    _send({
      'type': 'session.instructions.append',
      'content': clean.length > liveAppendCharLimit
          ? clean.substring(0, liveAppendCharLimit)
          : clean,
      'delegation_id': null,
      'event_id': _nextEventId('instr'),
    });
  }

  @override
  void setMuted(bool muted) {
    for (final track in _microphone?.getAudioTracks() ?? const []) {
      track.enabled = !muted;
    }
    _send({
      'type': muted ? 'session.input_audio.mute' : 'session.input_audio.unmute',
      'event_id': _nextEventId(muted ? 'mute' : 'unmute'),
    });
  }

  /// Graceful close, as Desktop's `VoiceLiveSession.close`: ask for
  /// `session.closed` and tear down when it arrives, or after
  /// [closeTimeout]. The session stops being [active] at once and its
  /// microphone tracks are disabled, so the controls hide and no more audio
  /// leaves the device while the vendor answers.
  @override
  Future<void> close() async {
    // A start in flight is cancelled, whatever it has acquired so far.
    if (_startingRun != null) {
      await _finish('close_requested');
      return;
    }
    if (_closed || _closeTimer != null) return;
    // No channel to say goodbye on: tear down now.
    if (!_active || !_send({'type': 'session.close'})) {
      await _finish('close_requested');
      return;
    }
    _active = false;
    _speakingProbe?.cancel();
    _speakingProbe = null;
    for (final track
        in _microphone?.getAudioTracks() ?? const <MediaStreamTrack>[]) {
      track.enabled = false;
    }
    _closeTimer = Timer(
      closeTimeout,
      () => unawaited(_finish('close_requested')),
    );
    _safeNotify();
  }

  /// Ends the session at once: sign-out, a hidden or covered chat, app
  /// background, dispose. Says goodbye when the channel is still up (so the
  /// vendor session does not linger), then closes the peer and stops the
  /// tracks without waiting.
  @override
  Future<void> forceClose(String reason, [int? usageSeconds]) {
    if (!_closed && _closeTimer == null && _active) {
      _send({'type': 'session.close'});
    }
    return _finish(reason, usageSeconds);
  }

  /// Finalizes the session exactly once (Desktop's `finish`): stops the
  /// microphone tracks, closes the data channel and the peer, then reports
  /// [reason]. Every teardown also cancels a start in flight, even when
  /// there is nothing left to release; only a start finishing its own
  /// predecessor passes [cancelStart] false.
  Future<void> _finish(
    String reason, [
    int? usageSeconds,
    bool cancelStart = true,
  ]) {
    if (cancelStart) {
      _run++;
      _startingRun = null;
    }
    if (_closed) return _finishing ?? Future<void>.value();
    _closed = true;
    _active = false;
    _closeTimer?.cancel();
    _closeTimer = null;
    _speakingProbe?.cancel();
    _speakingProbe = null;
    final channel = _events;
    final peer = _peer;
    final microphone = _microphone;
    // The handlers compare against these fields, so our own close below is
    // never mistaken for a lost connection. The microphone stays recorded
    // until its tracks have stopped ([holdsMicrophone]).
    _events = null;
    _peer = null;
    return _finishing = () async {
      await _release(channel, peer, microphone);
      if (identical(_microphone, microphone)) _microphone = null;
      _finishing = null;
      if (!_disposed) {
        notifyListeners();
        onClosed?.call(reason, usageSeconds);
      }
    }();
  }

  /// Releases one session's resources. Each step stands alone: the
  /// microphone goes first and is freed even when the peer is already gone
  /// (a native peer answers calls after close with an error).
  static Future<void> _release(
    RTCDataChannel? channel,
    RTCPeerConnection? peer,
    MediaStream? microphone,
  ) async {
    for (final track in microphone?.getTracks() ?? const <MediaStreamTrack>[]) {
      try {
        await track.stop();
      } catch (_) {}
    }
    try {
      await microphone?.dispose();
    } catch (_) {}
    try {
      await channel?.close();
    } catch (_) {}
    try {
      await peer?.close();
    } catch (_) {}
    try {
      await peer?.dispose();
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    unawaited(forceClose('disposed'));
    super.dispose();
  }
}
