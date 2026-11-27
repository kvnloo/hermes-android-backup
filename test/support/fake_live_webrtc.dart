// Fake WebRTC peer, data channel, microphone and gateway transport for the
// GPT-Live suites: the real GptLiveConversation / VoiceLiveEngine run over
// these, with no native plugin, no vendor call and no network.
import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hermes_android/core/services/gpt_live_conversation.dart';

class FakeLiveTrack implements MediaStreamTrack {
  bool stopped = false;
  bool _enabled = true;

  @override
  bool get enabled => _enabled;
  @override
  set enabled(bool value) => _enabled = value;

  @override
  Future<void> stop() async => stopped = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLiveStream implements MediaStream {
  FakeLiveStream(this.track);
  final FakeLiveTrack track;

  @override
  List<MediaStreamTrack> getAudioTracks() => [track];
  @override
  List<MediaStreamTrack> getTracks() => [track];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLiveChannel implements RTCDataChannel {
  /// Every JSON event the client sent, in order.
  final sent = <Map<String, dynamic>>[];
  bool closed = false;

  @override
  Function(RTCDataChannelMessage data)? onMessage;
  @override
  Function(RTCDataChannelState state)? onDataChannelState;

  @override
  Future<void> send(RTCDataChannelMessage message) async {
    sent.add(jsonDecode(message.text) as Map<String, dynamic>);
  }

  /// As the native channel: its own close reports the closed state.
  @override
  Future<void> close() async {
    if (closed) return;
    closed = true;
    onDataChannelState?.call(RTCDataChannelState.RTCDataChannelClosed);
  }

  /// A vendor event arriving on `oai-events`.
  void receive(Map<String, dynamic> event) =>
      onMessage?.call(RTCDataChannelMessage(jsonEncode(event)));

  /// The remote side (or the network) closed the channel.
  void remoteClose() =>
      onDataChannelState?.call(RTCDataChannelState.RTCDataChannelClosed);

  List<Map<String, dynamic>> sentOfType(String type) =>
      sent.where((event) => event['type'] == type).toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSender implements RTCRtpSender {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLivePeer implements RTCPeerConnection {
  FakeLivePeer({this.offerSdp = fakeLiveOffer});

  final String offerSdp;
  final channel = FakeLiveChannel();
  bool closed = false;
  RTCSessionDescription? local;
  RTCSessionDescription? remote;

  /// Native flutter_webrtc answers calls on a closed peer with an error
  /// ("peerConnection is null"); model that when asked.
  bool throwWhenClosed = false;

  /// Inbound audio level reported by [getStats]; null reports no audio stat.
  double? audioLevel;
  int statsCalls = 0;

  @override
  Function(RTCPeerConnectionState state)? onConnectionState;
  @override
  Function(RTCIceGatheringState state)? onIceGatheringState;
  @override
  Function(RTCTrackEvent event)? onTrack;

  @override
  RTCIceGatheringState? get iceGatheringState =>
      RTCIceGatheringState.RTCIceGatheringStateComplete;

  void _guard(String call) {
    if (closed && throwWhenClosed) {
      throw StateError('$call: peerConnection is null');
    }
  }

  @override
  Future<RTCRtpSender> addTrack(
    MediaStreamTrack track, [
    MediaStream? stream,
  ]) async {
    _guard('addTrack');
    return _FakeSender();
  }

  @override
  Future<RTCDataChannel> createDataChannel(
    String label,
    RTCDataChannelInit dataChannelDict,
  ) async {
    _guard('createDataChannel');
    return channel;
  }

  @override
  Future<RTCSessionDescription> createOffer([
    Map<String, dynamic>? constraints,
  ]) async {
    _guard('createOffer');
    return RTCSessionDescription(offerSdp, 'offer');
  }

  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {
    _guard('setLocalDescription');
    local = description;
  }

  @override
  Future<RTCSessionDescription?> getLocalDescription() async => local;

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    _guard('setRemoteDescription');
    remote = description;
  }

  @override
  Future<List<StatsReport>> getStats([MediaStreamTrack? track]) async {
    statsCalls++;
    final level = audioLevel;
    return [
      if (level != null)
        StatsReport('in-audio', 'inbound-rtp', 0, {
          'kind': 'audio',
          'audioLevel': level,
        }),
    ];
  }

  @override
  Future<void> close() async => closed = true;

  @override
  Future<void> dispose() async => closed = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const fakeLiveOffer =
    'v=0\r\no=- 1 2 IN IP4 127.0.0.1\r\ns=-\r\nm=audio 9 UDP\r\n';

class FakeLiveTransport implements GptLiveTransport {
  String? sdp;
  List<Map<String, dynamic>>? history;
  int statusCalls = 0;
  int sessionCalls = 0;

  /// Holds POST /voice-live/session open until completed.
  Completer<void>? sessionGate;

  @override
  Future<Object?> status() async {
    statusCalls++;
    return {
      'ok': true,
      'mode': 'gpt-live',
      'available': true,
      'reason': null,
      'model': 'gpt-live-1',
      'voice': 'marin',
    };
  }

  @override
  Future<Object?> createSession({
    required String sdp,
    List<Map<String, dynamic>>? history,
  }) async {
    sessionCalls++;
    this.sdp = sdp;
    this.history = history;
    await sessionGate?.future;
    return {
      'ok': true,
      'session': {'id': 'sess_fake'},
      'transport': {'type': 'webrtc', 'sdp': 'v=0\r\nanswer\r\n'},
    };
  }

  @override
  void dispose() {}
}

/// A live conversation and the fakes under it.
typedef StartedLive = ({
  GptLiveConversation conversation,
  FakeLivePeer peer,
  FakeLiveTrack track,
  FakeLiveTransport transport,
});

/// A live conversation over fakes that has not started yet (hand it to a
/// [VoiceLiveEngine] as its `session`, or call `start` yourself).
StartedLive newFakeLive() {
  final transport = FakeLiveTransport();
  final peer = FakeLivePeer();
  final track = FakeLiveTrack();
  final conversation = GptLiveConversation(
    transport: transport,
    peerConnectionFactory: () async => peer,
    microphoneFactory: () async => FakeLiveStream(track),
  );
  return (
    conversation: conversation,
    peer: peer,
    track: track,
    transport: transport,
  );
}

Future<StartedLive> startFakeLive({List<Map<String, dynamic>>? history}) async {
  final live = newFakeLive();
  final started = await live.conversation.start(history: history);
  if (!started) throw StateError('fake live conversation did not start');
  return live;
}

/// Delivers a transcript delta as the vendor sends it: `start_ms` / `end_ms`
/// are milliseconds from the start of the session, never wall-clock time.
Map<String, dynamic> liveTranscriptDelta(
  String speaker,
  String delta,
  int startMs,
  int endMs,
) => {
  'type': speaker == 'user'
      ? 'session.input_transcript.delta'
      : 'session.output_transcript.delta',
  'delta': delta,
  'start_ms': startMs,
  'end_ms': endMs,
};
