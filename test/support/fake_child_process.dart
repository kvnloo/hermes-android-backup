import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A child window process stand-in: records what the primary writes to
/// stdin and lets a test write the child's stdout lines and exit.
class FakeChildProcess implements Process {
  FakeChildProcess() {
    stdin = IOSink(_BytesConsumer(_stdin));
  }

  final _stdout = StreamController<List<int>>();
  final _stderr = StreamController<List<int>>();
  final _exit = Completer<int>();
  final _stdin = <int>[];
  bool killed = false;

  @override
  late final IOSink stdin;

  List<String> get stdinLines =>
      const LineSplitter().convert(utf8.decode(_stdin));

  @override
  Stream<List<int>> get stdout => _stdout.stream;

  @override
  Stream<List<int>> get stderr => _stderr.stream;

  @override
  Future<int> get exitCode => _exit.future;

  @override
  int get pid => 4242;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    killed = true;
    exit(-15);
    return true;
  }

  void emit(String line) => _stdout.add(utf8.encode('$line\n'));

  void exit(int code) {
    if (_exit.isCompleted) return;
    _exit.complete(code);
    unawaited(_stdout.close());
    unawaited(_stderr.close());
  }
}

class _BytesConsumer implements StreamConsumer<List<int>> {
  _BytesConsumer(this.bytes);

  final List<int> bytes;

  @override
  Future<void> addStream(Stream<List<int>> stream) async {
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
  }

  @override
  Future<void> close() async {}
}
