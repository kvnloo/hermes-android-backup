import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show ValueListenable;

import '../l10n/l10n.dart';
import '../models/attachment_draft.dart';
import '../services/attachment_audio_service.dart';
import '../utils/attachment_types.dart';

/// Injection boundary for native/file adapters, not a second playback engine.
class AttachmentAudioEnvironment extends InheritedWidget {
  const AttachmentAudioEnvironment({
    super.key,
    required this.createSession,
    required super.child,
  });
  final AttachmentAudioSession Function() createSession;
  @override
  bool updateShouldNotify(AttachmentAudioEnvironment oldWidget) =>
      oldWidget.createSession != createSession;
}

String attachmentAudioExtension(String filename, [String? mime]) {
  final extension = filename.contains('.')
      ? filename.split('.').last.toLowerCase()
      : '';
  if (attachmentIsAudio(extension)) return extension;
  return switch (mime?.split(';').first.trim().toLowerCase()) {
    'audio/mpeg' => 'mp3',
    'audio/wav' || 'audio/x-wav' || 'audio/wave' => 'wav',
    'audio/ogg' => 'ogg',
    'audio/opus' => 'opus',
    'audio/mp4' || 'audio/x-m4a' => 'm4a',
    'audio/flac' || 'audio/x-flac' => 'flac',
    'audio/aac' => 'aac',
    'audio/aiff' || 'audio/x-aiff' => 'aiff',
    _ => '',
  };
}

/// Shared by both composers. The identity includes the immutable cached source,
/// not an index, status or upload progress. Playback never uploads/sends a draft.
class AttachmentDraftAudioPreview extends StatelessWidget {
  const AttachmentDraftAudioPreview({
    super.key,
    required this.draft,
    this.showName = false,
    this.owner,
  });
  final AttachmentDraft draft;
  final bool showName;
  final Object? owner;
  @override
  Widget build(BuildContext context) {
    final extension = attachmentAudioExtension(draft.name, draft.mediaType);
    if (extension.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showName)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${draft.name} • ${context.l10n.assets_audio}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        AttachmentAudioPreview(
          sourceIdentity: (owner, draft.id, draft.cachedPath),
          extension: extension,
          localPath: draft.cachedPath,
        ),
      ],
    );
  }
}

/// Lazy, explicit-play-only audio. Remote callers supply already-authorized,
/// bounded bytes; only composer drafts may supply a local app-cache path.
class AttachmentAudioPreview extends StatefulWidget {
  const AttachmentAudioPreview({
    super.key,
    required this.sourceIdentity,
    required this.extension,
    this.loadBytes,
    this.localPath,
    this.ownerValidity,
  }) : assert((loadBytes == null) != (localPath == null));

  final Object sourceIdentity;
  final String extension;
  final Future<Uint8List?> Function()? loadBytes;
  final String? localPath;
  final ValueListenable<bool>? ownerValidity;
  @override
  State<AttachmentAudioPreview> createState() => _AttachmentAudioPreviewState();
}

class _AttachmentAudioPreviewState extends State<AttachmentAudioPreview>
    with WidgetsBindingObserver {
  AttachmentAudioSession? _session;
  final _subscriptions = <StreamSubscription<dynamic>>[];
  Future<void> _cleanup = Future<void>.value();
  bool _loading = false;
  bool _failed = false;
  bool _playing = false;
  bool _foreground = true;
  bool _routeCurrent = true;
  int _generation = 0;
  int _playIntentEpoch = 0;
  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    final binding = WidgetsBinding.instance;
    binding.addObserver(this);
    widget.ownerValidity?.addListener(_authorityChanged);
    _foreground =
        binding.lifecycleState == null ||
        binding.lifecycleState == AppLifecycleState.resumed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeCurrent =
        (ModalRoute.isCurrentOf(context) ?? true) &&
        TickerMode.valuesOf(context).enabled;
    _syncPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _syncPermission();
  }

  void _authorityChanged() {
    if (!(widget.ownerValidity?.value ?? true)) {
      _retire();
      if (mounted) setState(() {});
    }
  }

  void _syncPermission() {
    final allowed = _foreground && _routeCurrent;
    if (!allowed) _playIntentEpoch++;
    final session = _session;
    if (session != null) {
      unawaited(_command(session, () => session.setAllowed(allowed)));
    }
  }

  bool _current(AttachmentAudioSession session, int generation) =>
      mounted &&
      (widget.ownerValidity?.value ?? true) &&
      identical(_session, session) &&
      generation == _generation;

  Future<void> _toggle() async {
    if (!_foreground ||
        !_routeCurrent ||
        !(widget.ownerValidity?.value ?? true)) {
      return;
    }
    final playIntent = _playIntentEpoch;
    final existing = _session;
    if (existing != null && !_failed) {
      final replay = _duration != null && _position >= _duration!;
      await _command(
        existing,
        _playing ? existing.pause : () => existing.play(replay: replay),
      );
      return;
    }
    final arbitrationIntent = AttachmentAudioSession.claimPlayIntent();
    final create = context
        .getInheritedWidgetOfExactType<AttachmentAudioEnvironment>()
        ?.createSession;
    final session = _session = create?.call() ?? AttachmentAudioSession();
    final generation = _generation;
    final path = widget.localPath;
    final loader = widget.loadBytes ?? () => session.fileStore.readLocal(path!);
    final extension = widget.extension;
    setState(() {
      _loading = true;
      _failed = false;
    });
    _syncPermission();
    try {
      await _cleanup.timeout(const Duration(seconds: 20));
      if (!_current(session, generation)) return;
      final ready = await session
          .open(loader, extension)
          .timeout(const Duration(seconds: 20));
      if (!_current(session, generation) || !ready) return;
      final player = session.player!;
      void changed(VoidCallback change) {
        if (_current(session, generation) && !_failed) setState(change);
      }

      void streamError(Object _, StackTrace _) {
        if (_current(session, generation)) _fail(session);
      }

      _subscriptions.addAll([
        player.onPlayerStateChanged.listen(
          (state) => changed(() {
            _playing = state == PlayerState.playing;
            if (state == PlayerState.completed) {
              _position = _duration ?? _position;
            }
          }),
          onError: streamError,
        ),
        player.onDurationChanged.listen(
          (value) => changed(() => _duration = value),
          onError: streamError,
        ),
        player.onPositionChanged.listen(
          (value) => changed(() => _position = value),
          onError: streamError,
        ),
        player.eventStream.listen((_) {}, onError: streamError),
      ]);
      final duration = await player.getDuration().timeout(
        const Duration(seconds: 5),
      );
      if (!_current(session, generation)) return;
      setState(() {
        _duration = duration;
        _loading = false;
      });
      // A Play tap admitted before suspension must not borrow permission
      // from a later foreground/uncovered route after a held load completes.
      if (playIntent == _playIntentEpoch && _foreground && _routeCurrent) {
        await _command(
          session,
          () => session.play(playIntent: arbitrationIntent),
        );
      }
    } catch (_) {
      if (_current(session, generation)) _fail(session);
    }
  }

  Future<void> _command(
    AttachmentAudioSession session,
    Future<void> Function() action,
  ) async {
    final generation = _generation;
    try {
      await action();
    } catch (_) {
      if (_current(session, generation)) _fail(session);
    }
  }

  void _fail(AttachmentAudioSession session) {
    _retire();
    if (mounted) setState(() => _failed = true);
  }

  void _retire() {
    _generation++;
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
    final session = _session;
    _session = null;
    if (session != null) {
      final closing = session.close().catchError((Object _) {});
      _cleanup = Future.wait<void>([_cleanup, closing]).then((_) {});
    }
    _loading = false;
    _playing = false;
    _position = Duration.zero;
    _duration = null;
  }

  @override
  void didUpdateWidget(AttachmentAudioPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ownerValidity != widget.ownerValidity) {
      oldWidget.ownerValidity?.removeListener(_authorityChanged);
      widget.ownerValidity?.addListener(_authorityChanged);
    }
    if (oldWidget.ownerValidity != widget.ownerValidity ||
        oldWidget.sourceIdentity != widget.sourceIdentity ||
        oldWidget.localPath != widget.localPath ||
        oldWidget.extension != widget.extension) {
      _retire();
      _failed = false;
    }
  }

  @override
  void dispose() {
    widget.ownerValidity?.removeListener(_authorityChanged);
    WidgetsBinding.instance.removeObserver(this);
    _retire();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final duration = _duration;
    return Column(
      key: const Key('attachment-audio-preview'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_failed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              l10n.attachment_audio_failed,
              key: const Key('attachment-audio-error'),
            ),
          ),
        Row(
          children: [
            if (_loading)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Semantics(
                  label: l10n.attachment_loading,
                  child: const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                key: const Key('attachment-audio-play-pause'),
                tooltip: _failed
                    ? l10n.attachment_retry
                    : _playing
                    ? l10n.attachment_video_pause
                    : l10n.attachment_video_play,
                onPressed: (widget.ownerValidity?.value ?? true)
                    ? () => unawaited(_toggle())
                    : null,
                icon: Icon(
                  _failed
                      ? Icons.refresh
                      : _playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
            Expanded(
              child: Semantics(
                label: l10n.attachment_audio_seek,
                child: Slider(
                  key: const Key('attachment-audio-seek'),
                  value: duration != null && duration.inMilliseconds > 0
                      ? (_position.inMilliseconds / duration.inMilliseconds)
                            .clamp(0.0, 1.0)
                      : 0,
                  onChanged:
                      (widget.ownerValidity?.value ?? true) &&
                          !_loading &&
                          duration != null &&
                          duration.inMilliseconds > 0 &&
                          _session != null
                      ? (value) {
                          final session = _session!;
                          unawaited(
                            _command(
                              session,
                              () => session.seek(
                                Duration(
                                  milliseconds:
                                      (value * duration.inMilliseconds).round(),
                                ),
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
        if (duration != null)
          Text(
            '${_time(_position)} / ${_time(duration)}',
            key: const Key('attachment-audio-position'),
          ),
      ],
    );
  }

  static String _time(Duration value) {
    final seconds = value.inSeconds.clamp(0, 359999);
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }
}
