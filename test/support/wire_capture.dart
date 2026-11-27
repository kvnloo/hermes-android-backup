// Records what real producers put on a session-authority socket, for
// `tool/canonical_wire_check.py` to validate against the gateway's own
// pydantic contracts.
//
// A capture suite drives production code against a `StrictAuthorityGateway`
// and wraps each producer call in [WireCaptureLog.record]. Every frame the
// gateway received inside the call is written to
// `build/canonical-wire/<name>.json` (or `$ARES_WIRE_CAPTURE_DIR`), with the
// requests the client refused before the wire listed as such.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/canonical_wire.dart';
import 'package:hermes_android/core/services/ws_client.dart';

import 'strict_authority_gateway.dart' show canonicalWirePin;
import 'strict_authority_server.dart';

class WireCaptureLog {
  WireCaptureLog(this.name);

  /// The capture file's base name.
  final String name;
  final rows = <Map<String, dynamic>>[];

  void _take(
    StrictAuthorityGateway gateway,
    int from,
    String layout,
    String producer,
  ) {
    for (final frame in gateway.frames.skip(from)) {
      rows.add({
        'id': '$producer#${rows.length}',
        'layout': layout,
        'producer': producer,
        'socket': 'authority',
        'method': frame.method,
        'params': frame.params,
        'strict_fake': frame.refusal == null ? 'accepted' : 'refused',
      });
    }
  }

  /// Runs one producer and records every frame it put on the wire. The
  /// strict gateway must have accepted them all.
  Future<T> record<T>(
    StrictAuthorityGateway gateway, {
    required String layout,
    required String producer,
    required Future<T> Function() run,
    Duration settle = Duration.zero,
  }) async {
    final from = gateway.frames.length;
    try {
      final value = await run();
      if (settle > Duration.zero) await Future<void>.delayed(settle);
      return value;
    } finally {
      _take(gateway, from, layout, producer);
      expect(
        [
          for (final frame in gateway.frames.skip(from))
            if (frame.refusal != null)
              '${frame.method} ${jsonEncode(frame.params)} -> '
                  '${jsonEncode(frame.refusal)}',
        ],
        isEmpty,
        reason: '$producer sent a request the authority refuses',
      );
    }
  }

  /// Runs a producer whose request has no canonical form: the client must
  /// refuse it before the wire, naming [kind], and send nothing.
  Future<void> recordRefused(
    StrictAuthorityGateway gateway, {
    required String layout,
    required String producer,
    required String method,
    required CanonicalRefusalKind kind,
    required Future<void> Function() run,
  }) async {
    final from = gateway.frames.length;
    Object? caught;
    try {
      await run();
    } catch (error) {
      caught = error;
    }
    final refusal = caught is JsonRpcError
        ? CanonicalWireRefusal.fromData(caught.data)
        : null;
    expect(
      refusal?.kind,
      kind,
      reason: '$producer was not refused before the wire: $caught',
    );
    expect(
      gateway.frames.skip(from).map((frame) => frame.method),
      isNot(contains(method)),
      reason: '$producer still sent $method',
    );
    _take(gateway, from, layout, producer);
    rows.add({
      'id': '$producer#${rows.length}',
      'layout': layout,
      'producer': producer,
      'socket': 'authority',
      'method': method,
      'refused_before_wire': true,
      'message': (caught as JsonRpcError).message,
    });
  }

  /// Writes the capture file. Call from `tearDownAll`.
  void write() {
    final directory = Directory(
      Platform.environment['ARES_WIRE_CAPTURE_DIR'] ?? 'build/canonical-wire',
    )..createSync(recursive: true);
    File('${directory.path}/$name.json').writeAsStringSync(
      '${const JsonEncoder.withIndent(' ').convert({'pin': canonicalWirePin, 'captures': rows})}\n',
    );
  }
}
