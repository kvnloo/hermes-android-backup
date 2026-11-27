part of 'remote_workspace.dart';

const _terminalMeta = '\x00HERMES_TERMINAL_META:';

typedef ProcessChange = ({String id, String? chunk});
typedef ProcessSnapshot = ({String id, String tail, String status});

extension WorkspaceTerminals on WorkspaceTarget {
  GatewayTerminal terminal({required void Function() checkPane}) =>
      GatewayTerminal._(this, checkPane);

  Future<List<ProcessSnapshot>> processSnapshot() async {
    final r = await read(WorkspaceRead.processes) as Map;
    return [
      for (final p in r['processes'] as List)
        if (p is Map &&
            p['session_id'] is String &&
            (p['session_id'] as String).isNotEmpty)
          (
            id: p['session_id'] as String,
            tail: p['output_tail'] as String? ?? '',
            status: p['status'] as String? ?? '',
          ),
    ];
  }

  void Function() watchProcesses(void Function(ProcessChange) onChange) {
    checkCurrent();
    final runtime = runtimeSessionId;
    if (runtime == null) _fail(WorkspaceFailure.unbound);
    return _socket.watchSessionEvents(runtime, (e) {
      if (!isCurrent || e.sessionId != runtime) return;
      final id = e.data['process_id'];
      if (id is! String || id.isEmpty) return;
      if (e.type == 'terminal.close') onChange((id: id, chunk: null));
      if (e.type == 'agent.terminal.output' && e.data['chunk'] is String) {
        onChange((id: id, chunk: e.data['chunk'] as String));
      }
    });
  }
}

/// The server owns the shell. Only a confirmed creation may acquire an ID;
/// no recovery path omits `attach` or silently changes the chat's host/cwd.
class GatewayTerminal {
  GatewayTerminal._(this._target, this._checkPane);
  final void Function() _checkPane;
  WorkspaceTarget _target;
  WorkspacePane? _replacement;
  WebSocket? _socket;
  String? _id;
  bool _attempted = false;
  bool get retained => _id != null;
  bool _up = false;
  bool replayTrimmed = false;
  int _epoch = 0;
  Future<void> _bindAgain({bool requirePane = true}) async {
    if (requirePane) _checkPane();
    final fresh = _target._owner.pane();
    try {
      final t = await fresh.bind(_target.route);
      if (t._row != _target._row) _fail(WorkspaceFailure.mismatch);
      if (requirePane) _checkPane();
      _replacement?.close();
      _replacement = fresh;
      _target = t;
    } catch (_) {
      fresh.close();
      rethrow;
    }
  }

  Future<void> connect({
    required void Function(String) output,
    required void Function(bool trimmed) reset,
    required void Function(int? code) disconnected,
  }) async {
    final attempt = ++_epoch;
    void check() {
      _checkPane();
      _target.checkCurrent();
      if (_epoch != attempt) _fail(WorkspaceFailure.stale);
    }

    final resume = _attempted;
    if (resume && _id == null) _fail(WorkspaceFailure.unbound);
    _attempted = true;
    if (resume) await _bindAgain();
    await _guard(check, () async {
      await _target.verifySession();
      if (_target.canonicalCwd == null) _fail(WorkspaceFailure.unbound);
      if (_target._binding?.backend != null &&
          _target._binding!.backend != 'local') {
        _fail(WorkspaceFailure.unbound);
      }
      final backend = await _target.read(WorkspaceRead.terminalBackends) as Map;
      if (backend['active'] != 'local') _fail(WorkspaceFailure.unbound);
      await _target.verifySession();
      final socket = await _target._owner._dashboard.openHostTerminal(
        profile: _target.effectiveProfile,
        cwd: _target.canonicalCwd,
        attach: _id,
        check: check,
      );
      final ready = Completer<void>();
      void fail([WorkspaceFailure why = WorkspaceFailure.unavailable]) {
        if (!ready.isCompleted) ready.completeError(WorkspaceException(why));
      }

      final decoded = const Utf8Decoder(allowMalformed: true)
          .startChunkedConversion(
            StringConversionSink.fromStringSink(_TerminalText(output)),
          );
      try {
        check();
        _socket = socket;
        socket.listen(
          (dynamic frame) {
            try {
              check();
              if (!ready.isCompleted) {
                if (frame is! String || !frame.startsWith(_terminalMeta)) {
                  _fail(WorkspaceFailure.invalid);
                }
                final m = jsonDecode(frame.substring(_terminalMeta.length));
                if (m is! Map ||
                    m['terminalId'] is! String ||
                    !validHostTerminalId(m['terminalId'] as String) ||
                    m['reconnected'] != resume ||
                    (resume && m['terminalId'] != _id) ||
                    m['cwd'] != _target.canonicalCwd ||
                    m['shell'] is! String ||
                    (m['shell'] as String).isEmpty) {
                  _fail(WorkspaceFailure.mismatch);
                }
                _id = m['terminalId'] as String;
                replayTrimmed = resume && m['truncated'] == true;
                if (resume) reset(m['truncated'] == true);
                _up = true;
                ready.complete();
              } else if (frame is List<int> && frame.length <= 1024 * 1024) {
                decoded.add(frame);
              } else if (frame is String && frame.length <= 1024 * 1024) {
                output(frame);
              } else {
                _fail(WorkspaceFailure.invalid);
              }
            } catch (e) {
              fail(
                e is WorkspaceException ? e.reason : WorkspaceFailure.invalid,
              );
              unawaited(socket.close());
            }
          },
          onError: (Object _) {
            fail();
          },
          onDone: () {
            fail();
            if (attempt != _epoch) return;
            _up = false;
            _socket = null;
            if (socket.closeCode == 4410) _id = null;
            disconnected(socket.closeCode);
          },
        );
        await ready.future.timeout(const Duration(seconds: 10));
        check();
      } catch (_) {
        _up = false;
        unawaited(socket.close());
        rethrow;
      }
    });
  }

  void write(String s) {
    _checkPane();
    _target.checkCurrent();
    if (_up) _socket?.add(utf8.encode(s));
  }

  void resize(int cols, int rows) {
    _checkPane();
    _target.checkCurrent();
    if (_up) {
      _socket?.add(
        '\x1b[RESIZE:${cols.clamp(2, 2000)};${rows.clamp(2, 1000)}]',
      );
    }
  }

  void detach() {
    ++_epoch;
    _up = false;
    final s = _socket;
    _socket = null;
    if (s != null) unawaited(s.close());
  }

  Future<void> closeShell({bool requirePane = true}) async {
    detach();
    final id = _id;
    if (id == null) return;
    await _bindAgain(requirePane: requirePane);
    void check() {
      if (requirePane) _checkPane();
      _target.checkCurrent();
    }

    await _guard(check, () async {
      await _target.verifySession();
      final s = await _target._owner._dashboard.openHostTerminal(
        profile: _target.effectiveProfile,
        attach: id,
        close: true,
        check: check,
      );
      try {
        final frames = StreamIterator(s.timeout(const Duration(seconds: 10)));
        try {
          if (!await frames.moveNext()) _fail(WorkspaceFailure.unavailable);
          final raw = frames.current;
          if (raw is! String || !raw.startsWith(_terminalMeta)) {
            _fail(WorkspaceFailure.invalid);
          }
          final m = jsonDecode(raw.substring(_terminalMeta.length));
          if (m is! Map ||
              m['terminalId'] != id ||
              m['closed'] != true ||
              await frames.moveNext() ||
              s.closeCode != 1000) {
            _fail(WorkspaceFailure.mismatch);
          }
        } finally {
          await frames.cancel();
        }
        check();
        _id = null;
      } finally {
        unawaited(s.close());
      }
    });
  }

  void dispose() {
    detach();
    _replacement?.close();
  }
}

class _TerminalText implements StringSink {
  _TerminalText(this.emit);
  final void Function(String) emit;
  @override
  void write(Object? obj) => emit('$obj');
  @override
  void writeCharCode(int code) => emit(String.fromCharCode(code));
  @override
  void writeln([Object? obj = '']) => emit('$obj\n');
  @override
  void writeAll(Iterable objects, [String separator = '']) =>
      emit(objects.join(separator));
}
