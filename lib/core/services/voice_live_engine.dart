import 'dart:async';

import 'package:flutter/foundation.dart';

import '../l10n/service_strings.dart';
import '../parked_automotive.dart';
import '../utils/speech_text.dart';
import '../utils/voice_stop_word.dart';
import 'connection_mutation_barrier.dart';
import 'gpt_live_conversation.dart';

/// Live conversation state, surfaced by the composer UI.
enum VoiceLiveState { idle, listening, thinking, speaking }

/// Chat-scoped GPT-Live conversation. Owns one [LiveConversation] (WebRTC
/// peer + data channel) per chat and tracks the host-declared status
/// (chained vs gpt-live). The vendor key stays on the gateway host; this
/// class only talks to the two gateway endpoints.
///
/// Every surface that finishes a turn (chat switch, connection/profile
/// change, app background, sign-out, dispose) must call [stop] or
/// [dispose]. All callbacks and events refuse to fire after teardown so a
/// late session event can never land in a stale composer.
class VoiceLiveEngine extends ChangeNotifier {
  VoiceLiveEngine({
    required this.transport,
    LiveConversation? session,
    this.connectionId,
    this.utteranceSettleDuration = const Duration(milliseconds: 1500),
    this.speechQuietDuration = const Duration(milliseconds: 1500),
  }) : super() {
    _conversation = session ?? GptLiveConversation(transport: transport);
    _wireCallbacks();
    if (connectionId != null) {
      _accountEpoch = ConnectionMutationBarrier.capture(connectionId!);
      ConnectionMutationBarrier.addListener(_onAccountBarrier);
    }
  }

  /// Gateway transport (status + session creation). Not closed by the
  /// engine — the owner controls the lifecycle.
  final GptLiveTransport transport;

  /// Optional connection id for automatic teardown on sign-out / mutation.
  final String? connectionId;

  /// Quiet window after user transcript deltas before checking stop phrases.
  final Duration utteranceSettleDuration;

  /// With no audio level from the peer: how long after the voice's last
  /// output (a transcript fragment, or a reply sent to it) it counts as
  /// done speaking.
  final Duration speechQuietDuration;

  /// The remote track's level said the voice is playing (true) or silent
  /// (false); null until the peer has reported one.
  bool? _audioSpeaking;
  Timer? _speechQuietTimer;

  late final LiveConversation _conversation;

  Object? _accountEpoch;
  GptLiveStatus? _status;
  VoiceLiveState _state = VoiceLiveState.idle;
  bool _muted = false;
  bool _disposing = false;
  bool _stopped = false;
  int _startEpoch = 0;
  Future<bool>? _startFlight;

  String? _delegationId;
  String _spokenRaw = '';
  String _spokenText = '';
  int _spokenCursor = 0;
  String _lastToolLabel = '';
  String _pendingUserUtterance = '';
  Timer? _utteranceSettleTimer;

  LiveConversation get conversation => _conversation;

  GptLiveStatus? get status => _status;
  bool get isLive => _status?.isLive == true;
  bool get available => _status?.available == true;
  bool get startable => isLive && available;
  VoiceLiveState get state => _state;
  bool get active => _conversation.active;
  bool get muted => _muted;
  bool get liveOwningMic => startable && active;

  /// The session still holds the capture device: live, or stopped and
  /// waiting for the vendor's goodbye (at most [liveCloseTimeout]). Wake-word
  /// capture stays paused until this is false.
  bool get holdsMicrophone {
    final Object conversation = _conversation;
    return conversation is LiveMicrophoneOwner
        ? conversation.holdsMicrophone
        : _conversation.active;
  }

  /// Something to tear down: a session that is live, starting, or closing.
  bool get engaged =>
      _conversation.active || holdsMicrophone || _startFlight != null;

  String? get delegationId => _delegationId;
  int get startEpoch => _startEpoch;
  int get spokenCursor => _spokenCursor;

  /// Last spoken reply text the engine has sent to the model.
  String get spokenText => _spokenText;

  /// The host's reason the live engine cannot start, if any.
  String? get reason {
    final status = _status;
    if (status == null) return null;
    if (!status.available && status.reason != null) return status.reason;
    if (status.available && !status.isLive) {
      return serviceStrings.voice_live_not_enabled;
    }
    return null;
  }

  // callbacks (set by the composer after the engine is created)
  void Function(String id, Map<String, String> prompt)? onDelegation;
  void Function(String message)? onError;
  void Function(String reason)? onClosed;
  void Function()? onStopWord;

  void _wireCallbacks() {
    _conversation.onDelegation = _handleDelegation;
    _conversation.onTranscript = _handleTranscript;
    _conversation.onError = _handleError;
    _conversation.onClosed = _handleClosed;
    final Object conversation = _conversation;
    if (conversation is LiveSpeakingSignal) {
      conversation.onSpeakingChange = _handleSpeakingChange;
    }
  }

  // --- speaking state (Desktop's refreshStatus) ---

  /// The voice produced output: speaking now, and listening (or thinking)
  /// again once it goes quiet.
  void _markSpeaking() {
    if (_state != VoiceLiveState.speaking) {
      _state = VoiceLiveState.speaking;
      notifyListeners();
    }
    _speechQuietTimer?.cancel();
    _speechQuietTimer = Timer(speechQuietDuration, () {
      _speechQuietTimer = null;
      // The remote track says it is still playing: it ends it.
      if (_audioSpeaking == true) return;
      _leaveSpeaking();
    });
  }

  /// Back to what the session is doing once the voice stopped: thinking
  /// while a delegation is in Hermes, listening otherwise.
  void _leaveSpeaking() {
    if (_disposing || _stopped || !_conversation.active) return;
    if (_state != VoiceLiveState.speaking) return;
    _state = _delegationId != null
        ? VoiceLiveState.thinking
        : VoiceLiveState.listening;
    notifyListeners();
  }

  void _handleSpeakingChange(bool speaking) {
    if (_disposing || _stopped || !_conversation.active) return;
    _audioSpeaking = speaking;
    if (speaking) {
      _speechQuietTimer?.cancel();
      _speechQuietTimer = null;
      if (_state != VoiceLiveState.speaking) {
        _state = VoiceLiveState.speaking;
        notifyListeners();
      }
    } else {
      _speechQuietTimer?.cancel();
      _speechQuietTimer = null;
      _leaveSpeaking();
    }
  }

  void _resetSpeaking() {
    _speechQuietTimer?.cancel();
    _speechQuietTimer = null;
    _audioSpeaking = null;
  }

  void _onAccountBarrier() {
    final id = connectionId;
    if (_disposing || id == null) return;
    if (!ConnectionMutationBarrier.isCurrent(id, _accountEpoch)) {
      _accountEpoch = ConnectionMutationBarrier.capture(id);
      // Sign-out or a connection edit: the session belongs to the account
      // that just changed. Close the peer and stop the tracks at once.
      if (_conversation.active ||
          holdsMicrophone ||
          _state != VoiceLiveState.idle) {
        unawaited(stopNow('signed_out'));
      }
    }
  }

  void _clearUtteranceTimer() {
    _utteranceSettleTimer?.cancel();
    _utteranceSettleTimer = null;
    _pendingUserUtterance = '';
  }

  // --- lifecycle ---

  Future<GptLiveStatus?> _refreshOnce() async {
    final status = parseGptLiveStatus(await transport.status());
    if (!_disposing) {
      _status = status;
      notifyListeners();
    }
    return _status;
  }

  /// Fetch the host-declared status. Returns null when the gateway did not
  /// answer (caller still falls back to chained).
  Future<GptLiveStatus?> refresh() async {
    if (_disposing) return null;
    try {
      return await _refreshOnce();
    } catch (_) {
      return null;
    }
  }

  /// Start the live conversation. Returns false — without throwing — when
  /// the host refuses (chained mode, unavailable, no mic). The caller
  /// decides whether to fall through to the chained composer.
  ///
  /// [status] is a `/voice-live/status` the caller has just read (the
  /// composer reads it to choose the engine); it is used as is, so a start
  /// reads the status once. Without it the engine reads it here.
  Future<bool> start({
    List<Map<String, dynamic>>? history,
    GptLiveStatus? status,
  }) {
    if (isParkedAutomotive || _disposing) return Future<bool>.value(false);
    // One start at a time: a second tap on Start joins the one in flight
    // instead of cancelling it (or opening a second peer and microphone).
    final flight = _startFlight;
    if (flight != null) return flight;
    late final Future<bool> run;
    run = _start(history: history, status: status).whenComplete(() {
      if (identical(_startFlight, run)) _startFlight = null;
    });
    return _startFlight = run;
  }

  Future<bool> _start({
    List<Map<String, dynamic>>? history,
    GptLiveStatus? status,
  }) async {
    final epoch = ++_startEpoch;
    if (status != null) {
      _status = status;
      notifyListeners();
    } else {
      await refresh();
    }
    if (_disposing || epoch != _startEpoch) return false;
    if (!startable) {
      onError?.call(reason ?? serviceStrings.voice_live_not_available);
      return false;
    }
    if (_conversation.active) return false;
    _stopped = false;
    _clearUtteranceTimer();
    // The conversation dials with the status just read, not a second read.
    final Object conversation = _conversation;
    final current = _status;
    if (conversation is LiveStatusPrimer && current != null) {
      conversation.primeStatus(current);
    }
    final started = await _conversation.start(history: history);
    if (_disposing || _stopped || epoch != _startEpoch) {
      // Torn down while starting. The conversation cancels its own start;
      // only a session that still came up is closed here, so a newer start
      // already in flight is left alone.
      if (started) await _conversation.forceClose('cancelled');
      return false;
    }
    if (started) {
      _resetSpeaking();
      _state = VoiceLiveState.listening;
      _muted = false;
      _delegationId = null;
      _spokenRaw = '';
      _spokenText = '';
      _spokenCursor = 0;
      _lastToolLabel = '';
      notifyListeners();
      return true;
    }
    _state = VoiceLiveState.idle;
    notifyListeners();
    return false;
  }

  void _beginStop() {
    _startEpoch++;
    // The start in flight (if any) is cancelled; a start after this stop is
    // a new one, not a join of the cancelled one.
    _startFlight = null;
    _stopped = true;
    _clearUtteranceTimer();
    _resetSpeaking();
    _delegationId = null;
    _spokenRaw = '';
    _spokenText = '';
    _spokenCursor = 0;
    _lastToolLabel = '';
  }

  /// Stop the live session on the user's request (Stop, a spoken stop
  /// phrase). The session leaves [active] at once; its peer and tracks are
  /// released when the vendor answers `session.close`, or after Desktop's
  /// 15 s fallback ([holdsMicrophone] until then).
  Future<void> stop() async {
    if (_disposing) return;
    _beginStop();
    try {
      await _conversation.close();
    } catch (_) {
      await _conversation.forceClose('stopped');
    }
    if (_disposing) return;
    _state = VoiceLiveState.idle;
    _muted = false;
    notifyListeners();
  }

  /// End the live session at once, with no wait for the vendor: sign-out or
  /// a connection edit, a hidden or covered chat, app background.
  Future<void> stopNow([String reason = 'stopped']) async {
    if (_disposing) return;
    _beginStop();
    _state = VoiceLiveState.idle;
    _muted = false;
    try {
      await _conversation.forceClose(reason);
    } catch (_) {}
    if (_disposing) return;
    notifyListeners();
  }

  void setMuted(bool muted) {
    if (_disposing || _stopped) return;
    _muted = muted;
    _conversation.setMuted(muted);
    notifyListeners();
  }

  /// Nudges the full-duplex voice model to answer now (Desktop's `stopTurn`).
  void stopTurn() {
    instruct('The user has finished speaking. Respond now to what they said.');
  }

  // --- reply feed ---

  static int _lastSentenceBoundary(String text) {
    var best = -1;
    for (final marker in const ['. ', '! ', '? ']) {
      final idx = text.lastIndexOf(marker, text.length - 2);
      if (idx > best) best = idx;
    }
    return best;
  }

  /// Append the pending reply to the live model. Only the new part of the
  /// text is sent — completed sentences while streaming, everything left on
  /// [flush]. The caller passes the whole pending reply each call; the engine
  /// tracks which of it has already been sent.
  void speak(String text, {String? delegationId, bool flush = false}) {
    if (_disposing || _stopped || !_conversation.active) return;
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.isEmpty) return;
    if (_spokenRaw.isNotEmpty && !clean.startsWith(_spokenRaw)) {
      // The reply changed under us (new turn, re-read). Start over.
      _spokenRaw = '';
      _spokenText = '';
      _spokenCursor = 0;
    }
    _spokenRaw = clean;
    final sanitized = sanitizeTextForSpeech(clean);
    if (sanitized.isEmpty) return;
    _spokenText = sanitized;
    if (flush) {
      if (sanitized.length > _spokenCursor) {
        _conversation.speak(
          sanitized.substring(_spokenCursor),
          delegationId: delegationId ?? _delegationId,
        );
        _spokenCursor = sanitized.length;
      }
    } else if (sanitized.length >= 2) {
      // Append only completed sentences while streaming; the tail lands on settle.
      final boundary = _lastSentenceBoundary(sanitized);
      final cut = boundary > _spokenCursor ? boundary + 1 : _spokenCursor;
      if (cut > _spokenCursor) {
        _conversation.speak(
          sanitized.substring(_spokenCursor, cut),
          delegationId: delegationId ?? _delegationId,
        );
        _spokenCursor = cut;
      }
    }
    // The voice is about to say it; the quiet timer (or the remote track's
    // level) brings the pill back when it is done.
    _markSpeaking();
  }

  /// Flush the held tail (turn settled or chat switched away).
  void flushSpoken({String? delegationId}) {
    speak(_spokenRaw, delegationId: delegationId, flush: true);
  }

  /// Surface tool progress to the voice model.
  void think(String text, {String? delegationId}) {
    if (_disposing || _stopped || !_conversation.active) return;
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.isEmpty || clean == _lastToolLabel) return;
    _lastToolLabel = clean;
    _conversation.think(clean, delegationId: delegationId ?? _delegationId);
  }

  /// Instruction to the model (e.g. "finish and respond now").
  void instruct(String text) {
    if (_disposing || _stopped || !_conversation.active) return;
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.isEmpty) return;
    _conversation.instruct(clean);
  }

  /// Turn settled (the composer stopped streaming replies). Back to
  /// listening, unless the remote track says the voice is still playing it
  /// (Desktop's refreshStatus); the end of that audio brings it back.
  void settle() {
    if (_disposing || _stopped) return;
    flushSpoken();
    if (_audioSpeaking == true && _state == VoiceLiveState.speaking) {
      _speechQuietTimer?.cancel();
      _speechQuietTimer = null;
    } else if (_state == VoiceLiveState.thinking ||
        _state == VoiceLiveState.speaking) {
      _speechQuietTimer?.cancel();
      _speechQuietTimer = null;
      _state = VoiceLiveState.listening;
      notifyListeners();
    }
    _delegationId = null;
    _spokenRaw = '';
    _spokenText = '';
    _spokenCursor = 0;
    _lastToolLabel = '';
  }

  // --- internal event wiring ---

  void _handleTranscript(LiveFragment fragment) {
    if (_disposing || _stopped || !_conversation.active) return;
    if (fragment.speaker == 'assistant') {
      if (fragment.text.trim().isNotEmpty) _markSpeaking();
      return;
    }
    if (fragment.speaker != 'user') return;
    _pendingUserUtterance += fragment.text;
    _utteranceSettleTimer?.cancel();
    final epoch = _startEpoch;
    _utteranceSettleTimer = Timer(utteranceSettleDuration, () {
      _utteranceSettleTimer = null;
      final utterance = _pendingUserUtterance;
      _pendingUserUtterance = '';
      if (_disposing ||
          _stopped ||
          !_conversation.active ||
          epoch != _startEpoch) {
        return;
      }
      if (isVoiceStopCommand(utterance)) {
        unawaited(stop());
        onStopWord?.call();
      }
    });
  }

  void _handleDelegation(String id, Map<String, String> prompt) {
    if (_disposing || _stopped) return;
    _clearUtteranceTimer();
    final utterance = (prompt['prompt'] ?? '').trim();
    if (utterance.isNotEmpty && isVoiceStopCommand(utterance)) {
      unawaited(stop());
      onStopWord?.call();
      return;
    }
    _delegationId = id;
    _state = VoiceLiveState.thinking;
    _spokenRaw = '';
    _spokenText = '';
    _spokenCursor = 0;
    _lastToolLabel = '';
    notifyListeners();
    onDelegation?.call(id, prompt);
  }

  void _handleError(String message, bool fatal) {
    if (_disposing || _stopped) return;
    onError?.call(message);
  }

  void _handleClosed(String reason, int? usageSeconds) {
    if (_disposing) return;
    // A session this engine stopped itself has now released its peer and
    // microphone: listeners re-sync (wake resumes), but only a close the
    // user did not ask for is announced.
    final stoppedHere = _stopped;
    _clearUtteranceTimer();
    _resetSpeaking();
    _state = VoiceLiveState.idle;
    _muted = false;
    _delegationId = null;
    _spokenText = '';
    notifyListeners();
    if (!stoppedHere) onClosed?.call(reason);
  }

  @override
  void dispose() {
    _disposing = true;
    _stopped = true;
    _startEpoch++;
    _clearUtteranceTimer();
    _resetSpeaking();
    if (connectionId != null) {
      ConnectionMutationBarrier.removeListener(_onAccountBarrier);
    }
    _conversation.dispose();
    super.dispose();
  }
}
