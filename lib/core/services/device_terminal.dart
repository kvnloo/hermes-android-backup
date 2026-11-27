import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Direct transports own a single child/channel. Neither one publishes a
/// service or reads gateway authentication. A broken SSH channel is not a
/// resumable shell; opening a fresh shell always requires a new gesture.
abstract interface class DeviceTerminal {
  Stream<List<int>> get output;
  void write(String text);
  void resize(int columns, int rows);
  Future<void> close();
}

class LocalTerminal implements DeviceTerminal {
  LocalTerminal._(this._process) {
    _process.stderr.drain<void>().ignore();
    _process.stdin.done.ignore();
  }
  final Process _process;
  @override
  Stream<List<int>> get output => _process.stdout;
  static bool get supported =>
      supportedOverride ??
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  /// Test-only replacement for the packaged helper and its working directory.
  @visibleForTesting
  static File? helperOverride;
  @visibleForTesting
  static Directory? directoryOverride;

  /// Test-only platform stand-in. Null follows the real desktop/mobile check.
  @visibleForTesting
  static bool? supportedOverride;

  /// Environment for the packaged helper. Windows `cmd.exe` inherits it, so
  /// it needs `SystemRoot` and a PATH that can see system commands. POSIX
  /// keeps the shell off the user's PATH.
  @visibleForTesting
  static Map<String, String> shellEnvironment({
    required String home,
    required bool windows,
    String? systemRoot,
  }) {
    final env = <String, String>{
      'TERM': 'xterm-256color',
      'LANG': 'en_US.UTF-8',
      'HOME': home,
    };
    if (!windows) {
      env['PATH'] = '/usr/bin:/bin:/usr/sbin:/sbin';
      return env;
    }
    if (systemRoot != null && systemRoot.isNotEmpty) {
      final root = systemRoot.replaceAll(RegExp(r'[\\/]+$'), '');
      env['SystemRoot'] = root;
      env['PATH'] = '$root\\System32;$root';
    }
    return env;
  }

  static Future<LocalTerminal> start({required void Function() check}) async {
    if (!supported) throw UnsupportedError('No local shell on this platform');
    final cwd = directoryOverride ?? await getApplicationSupportDirectory();
    final override = helperOverride;
    if (override != null) return startHelper(override, cwd, check: check);
    final location = File(Platform.resolvedExecutable).parent.uri.resolve(
      Platform.isWindows
          ? 'ares-pty.exe'
          : Platform.isMacOS
          ? '../Helpers/ares-pty'
          : 'ares-pty',
    );
    return startHelper(File.fromUri(location), cwd, check: check);
  }

  @visibleForTesting
  static Future<LocalTerminal> startHelper(
    File helper,
    Directory cwd, {
    required void Function() check,
  }) async {
    if (!helper.isAbsolute || !await helper.exists()) {
      throw UnsupportedError('No packaged PTY helper');
    }
    check();
    final p = await Process.start(
      helper.path,
      const [],
      workingDirectory: cwd.path,
      includeParentEnvironment: false,
      environment: shellEnvironment(
        home: cwd.path,
        windows: Platform.isWindows,
        systemRoot: Platform.environment['SystemRoot'],
      ),
    );
    final term = LocalTerminal._(p);
    try {
      check();
      return term;
    } catch (_) {
      await term.close();
      rethrow;
    }
  }

  @override
  void write(String text) {
    final bytes = utf8.encode(text);
    for (int at = 0; at < bytes.length; at += 65536) {
      final n = (bytes.length - at).clamp(0, 65536);
      _process.stdin.add([
        0,
        0,
        n >> 16,
        (n >> 8) & 255,
        n & 255,
        ...bytes.getRange(at, at + n),
      ]);
    }
  }

  @override
  void resize(int columns, int rows) {
    final c = columns.clamp(2, 2000), r = rows.clamp(2, 1000);
    _process.stdin.add([1, c >> 8, c & 255, r >> 8, r & 255]);
  }

  @override
  Future<void> close() async {
    unawaited(_process.stdin.close().catchError((Object _) {}));
    await _process.exitCode.timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        _process.kill(ProcessSignal.sigkill);
        return _process.exitCode;
      },
    );
  }
}

class VerifiedSshTerminal implements DeviceTerminal {
  VerifiedSshTerminal._(this._client, this._session) {
    _session.stderr.drain<void>().ignore();
  }
  final SSHClient _client;
  final SSHSession _session;
  @override
  Stream<List<int>> get output => _session.stdout.cast<List<int>>();
  static Future<VerifiedSshTerminal> open({
    required String host,
    required int port,
    required String user,
    required String fingerprint,
    required String password,
    required void Function() check,
  }) async {
    if (!(RegExp(r'^[A-Za-z0-9][A-Za-z0-9.-]{0,252}$').hasMatch(host) ||
            InternetAddress.tryParse(host)?.type == InternetAddressType.IPv6) ||
        !RegExp(r'^[A-Za-z0-9_.-]{1,64}$').hasMatch(user) ||
        port < 1 ||
        port > 65535 ||
        !RegExp(r'^SHA256:[A-Za-z0-9+/]{43}$').hasMatch(fingerprint)) {
      throw const FormatException(
        'Invalid SSH destination or host fingerprint',
      );
    }
    if (password.isEmpty) throw const FormatException('Missing SSH credential');
    check();
    final socket = await SSHSocket.connect(
      host,
      port,
      timeout: const Duration(seconds: 8),
    );
    SSHClient? client;
    try {
      check();
      String? secret = password;
      client = SSHClient(
        socket,
        username: user,
        onPasswordRequest: () {
          check();
          final reply = secret;
          secret = null;
          return reply;
        },
        onVerifyHostKey: (type, bytes) {
          check();
          return ascii.decode(bytes) == fingerprint;
        },
      );
      await client.authenticated.timeout(const Duration(seconds: 10));
      check();
      final s = await client
          .shell(pty: const SSHPtyConfig())
          .timeout(const Duration(seconds: 10));
      check();
      return VerifiedSshTerminal._(client, s);
    } catch (_) {
      client?.close();
      socket.destroy();
      rethrow;
    }
  }

  @override
  void write(String text) =>
      _session.write(Uint8List.fromList(utf8.encode(text)));
  @override
  void resize(int columns, int rows) =>
      _session.resizeTerminal(columns.clamp(2, 2000), rows.clamp(2, 1000));
  @override
  Future<void> close() async {
    _session.close();
    _client.close();
    await _client.done;
  }
}
