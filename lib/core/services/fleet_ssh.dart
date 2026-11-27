import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Direct OpenSSH channels. No TCP listener, proxy, `ssh -D`, inherited jump
/// command, remote command string, forwarded agent or saved gateway bearer.
/// A remote shell is a distinct, explicit user action and has its own child.
enum FleetSshFailure {
  invalidDestination,
  publicKeyRequired,
  invalidPublicKey,
  invalidSavedKey,
  enrollmentUnverified,
  differentKeyPinned,
  openSshUnavailable,
  confirmHostKey,
  absoluteIdentityRequired,
  invalidRemotePort,
  previewTooLarge,
  connectionRefused,
  httpNotOk,
  encodedResponse,
  previewTypeUnsupported,
  healthUnconfirmed,
  enrollHostKeyFirst,
}

class FleetSshException implements Exception {
  const FleetSshException(this.reason);
  final FleetSshFailure reason;
  @override
  String toString() => 'FleetSshException(${reason.name})';
}

Never _refuse(FleetSshFailure reason) => throw FleetSshException(reason);

class SshDestination {
  SshDestination(this.host, this.port, this.user) {
    final dns = RegExp(r'^[A-Za-z0-9][A-Za-z0-9.-]{0,252}$');
    if ((!dns.hasMatch(host) &&
            InternetAddress.tryParse(host)?.type != InternetAddressType.IPv6) ||
        host.trim() != host ||
        host.contains('%') ||
        !RegExp(r'^[a-zA-Z0-9_][a-zA-Z0-9._-]{0,63}$').hasMatch(user) ||
        port < 1 ||
        port > 65535) {
      _refuse(FleetSshFailure.invalidDestination);
    }
  }
  final String host, user;
  final int port;
  String get label => '$user@$host:$port';
  String get pinKey =>
      sha256.convert(utf8.encode('${host.toLowerCase()}:$port')).toString();
}

class SshPublicKey {
  SshPublicKey._(this.encoded, this.fingerprint);
  final String encoded, fingerprint;
  factory SshPublicKey.parse(String input) {
    final parts = input.trim().split(RegExp(r'\s+'));
    // A complete OpenSSH ed25519 public key from an independent source;
    // accepting only its canonical binary representation prevents injection of
    // markers, host patterns or options into the known_hosts file.
    if (parts.length < 2 ||
        parts[0] != 'ssh-ed25519' ||
        !RegExp(r'^[A-Za-z0-9+/]{68}$').hasMatch(parts[1])) {
      _refuse(FleetSshFailure.publicKeyRequired);
    }
    final bytes = base64.decode(parts[1]);
    final prefix = [0, 0, 0, 11, ...ascii.encode('ssh-ed25519'), 0, 0, 0, 32];
    if (bytes.length != 51 ||
        !List.generate(
          prefix.length,
          (i) => bytes[i] == prefix[i],
        ).every((b) => b)) {
      _refuse(FleetSshFailure.invalidPublicKey);
    }
    return SshPublicKey._(
      parts[1],
      'SHA256:${base64.encode(sha256.convert(bytes).bytes).replaceAll('=', '')}',
    );
  }
  String get line => 'ares-pinned ssh-ed25519 $encoded\n';
}

class FleetSsh {
  FleetSsh(this.directory);
  final Directory directory;
  static bool get supported =>
      Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  String get _binary => Platform.isWindows
      ? '${Platform.environment['SystemRoot']}\\System32\\OpenSSH\\ssh.exe'
      : '/usr/bin/ssh';
  Directory _dir(SshDestination d) =>
      Directory.fromUri(directory.uri.resolve('${d.pinKey}/'));
  File _pin(SshDestination d) => File.fromUri(_dir(d).uri.resolve('host.pin'));
  Future<SshPublicKey?> enrolled(SshDestination d) async {
    final f = _pin(d);
    if (!await f.exists()) return null;
    final s = await f.readAsString();
    // An empty pin is an enrollment interrupted between exclusive creation
    // and the write. It pins nothing, so the host is still unenrolled.
    if (s.isEmpty) return null;
    if (!s.startsWith('ares-pinned ')) _refuse(FleetSshFailure.invalidSavedKey);
    final key = SshPublicKey.parse(s.substring('ares-pinned '.length));
    if (s != key.line) _refuse(FleetSshFailure.invalidSavedKey);
    return key;
  }

  static final _pinning = <String, Future<void>>{};

  /// Called only after the user compares the displayed fingerprint and agrees.
  /// No rotation-on-connect or overwrite-on-mismatch: a key is written only
  /// into an empty pin, and the empty check and write happen together under
  /// an in-process queue plus an OS file lock (other windows are other
  /// processes). An empty pin left by an interrupted enrollment pins nothing,
  /// so it may be completed; a written pin is never replaced.
  Future<void> enroll(SshDestination d, SshPublicKey key) async {
    final dir = _dir(d);
    await dir.create(recursive: true);
    final f = _pin(d);
    final id = f.absolute.path;
    final previous = _pinning[id];
    final mine = Completer<void>();
    _pinning[id] = mine.future;
    try {
      await previous;
      // Append mode creates without truncating an existing pin.
      final raf = await f.open(mode: FileMode.append);
      try {
        await raf.lock(FileLock.blockingExclusive);
        if (await raf.length() == 0) {
          await raf.writeString(key.line);
          await raf.flush();
        }
      } finally {
        await raf.close(); // Also releases the lock.
      }
    } finally {
      mine.complete();
      if (identical(_pinning[id], mine.future)) _pinning.remove(id);
    }
    final existing = await enrolled(d);
    if (existing?.encoded == key.encoded) return;
    if (existing == null) _refuse(FleetSshFailure.enrollmentUnverified);
    _refuse(FleetSshFailure.differentKeyPinned);
  }

  Future<Process> _start(
    SshDestination d,
    List<String> mode, {
    String? identity,
  }) async {
    if (!supported || !await File(_binary).exists()) {
      _refuse(FleetSshFailure.openSshUnavailable);
    }
    if (await enrolled(d) == null) {
      _refuse(FleetSshFailure.confirmHostKey);
    }
    if (identity != null &&
        (!File(identity).isAbsolute ||
            identity.contains(RegExp(r'[\x00-\x1f%]')))) {
      _refuse(FleetSshFailure.absoluteIdentityRequired);
    }
    final env = Platform.environment;
    return Process.start(
      _binary,
      [
        '-F',
        'none',
        '-o',
        'BatchMode=yes',
        '-o',
        'StrictHostKeyChecking=yes',
        '-o',
        'HostKeyAlias=ares-pinned',
        '-o',
        'HostKeyAlgorithms=ssh-ed25519',
        '-o',
        'UserKnownHostsFile=host.pin',
        '-o',
        'GlobalKnownHostsFile=none',
        '-o',
        'UpdateHostKeys=no',
        '-o',
        'VerifyHostKeyDNS=no',
        '-o',
        'ForwardAgent=no',
        '-o',
        'ForwardX11=no',
        '-o',
        'ClearAllForwardings=yes',
        '-o',
        'ControlMaster=no',
        '-o',
        'ControlPath=none',
        '-o',
        'ConnectTimeout=8',
        '-o',
        'ConnectionAttempts=1',
        '-o',
        'ServerAliveInterval=15',
        '-o',
        'ServerAliveCountMax=2',
        '-o',
        'IdentityFile=none',
        if (identity != null) ...['-o', 'IdentitiesOnly=yes', '-i', identity],
        '-l',
        d.user,
        '-p',
        '${d.port}',
        ...mode,
        '--',
        d.host,
      ],
      workingDirectory: _dir(d).path,
      runInShell: false,
      includeParentEnvironment: false,
      environment: {
        if (identity == null) 'SSH_AUTH_SOCK': ?env['SSH_AUTH_SOCK'],
        'SystemRoot': ?env['SystemRoot'],
        'TERM': 'dumb',
        'LC_ALL': 'C',
      },
    );
  }

  /// Open one direct-tcpip stream to a remote loopback service. Only the
  /// fixed GET below is sent; responses never execute, redirect or fetch URLs.
  Future<String> readLoopback(
    SshDestination d, {
    required bool preview,
    required int port,
    required String Function(int port) healthMessage,
    String? identity,
  }) async {
    if (port < 1 || port > 65535) _refuse(FleetSshFailure.invalidRemotePort);
    final p = await _start(d, [
      '-T',
      '-W',
      '127.0.0.1:$port',
    ], identity: identity);
    final bytes = BytesBuilder(copy: false);
    final stderr = p.stderr.drain<void>();
    final timer = Timer(const Duration(seconds: 15), p.kill);
    try {
      p.stdin.write(
        'GET ${preview ? '/' : '/api/health'} HTTP/1.0\r\nHost: 127.0.0.1:$port\r\nAccept-Encoding: identity\r\nConnection: close\r\n\r\n',
      );
      await p.stdin.flush();
      await for (final chunk in p.stdout) {
        if (bytes.length + chunk.length > 65536) {
          _refuse(FleetSshFailure.previewTooLarge);
        }
        bytes.add(chunk);
      }
      if (await p.exitCode != 0) {
        _refuse(FleetSshFailure.connectionRefused);
      }
      final raw = bytes.takeBytes();
      final s = latin1.decode(raw);
      final i = s.indexOf('\r\n\r\n');
      if (i < 0 ||
          i > 8192 ||
          !RegExp(r'^HTTP/1\.[01] 200(?: |\r)').hasMatch(s)) {
        _refuse(FleetSshFailure.httpNotOk);
      }
      final headers = s.substring(0, i).toLowerCase().split('\r\n');
      if (headers.any(
        (l) =>
            l.startsWith('transfer-encoding:') ||
            l.startsWith('content-encoding:'),
      )) {
        _refuse(FleetSshFailure.encodedResponse);
      }
      final body = utf8.decode(raw.sublist(i + 4));
      if (preview) {
        if (!headers.any(
          (l) => RegExp(
            r'^content-type:\s*text/(plain|html)(?:\s*;|$)',
          ).hasMatch(l),
        )) {
          _refuse(FleetSshFailure.previewTypeUnsupported);
        }
        return body;
      }
      final value = jsonDecode(body);
      if (value is! Map || value['ok'] != true) {
        _refuse(FleetSshFailure.healthUnconfirmed);
      }
      return healthMessage(port);
    } finally {
      timer.cancel();
      p.kill();
      await p.exitCode;
      await stderr;
    }
  }

  Future<Process> shell(SshDestination d, {String? identity}) =>
      _start(d, ['-tt'], identity: identity);
}
