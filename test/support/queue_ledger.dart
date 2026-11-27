import 'dart:convert';
import 'dart:io';

import 'workspace_worker_peer.dart';

/// Raw canonical envelopes (not Desktop's frontend adapter projection). The
/// fixture shares the owner's records, not client cache, across socket opens.
class QueueLedger {
  QueueLedger(this.peer) {
    peer.handle = rpc;
  }
  final WorkerPeer peer;
  static const sid = 'stored-A', profile = '/fixture/profiles/work';
  int seq = 0, cursor = 2;
  bool unknownAck = false;
  final rows = <Map<String, Object?>>[];
  Map<String, Object?> add(
    String text, {
    String state = 'queued',
    String? input,
  }) {
    final row = <String, Object?>{
      'admission_id': 'host-${++seq}',
      'ref': {'profile_id': profile, 'session_id': sid},
      'sequence': seq,
      'status': state,
      'outcome': null,
      'authority_epoch': 9,
      'execution_generation': state == 'unknown' ? 3 : null,
      'input_id': input ?? 'client-$seq',
      'text': text,
      if (state == 'queued') 'controls': ['replace', 'steer'],
    };
    rows.add(row);
    return row;
  }

  void notify() {
    ++cursor;
    for (final ws in peer.sockets.where(
      (ws) => ws.readyState == WebSocket.open,
    )) {
      ws.add(
        jsonEncode({
          'jsonrpc': '2.0',
          'method': 'event',
          'params': {
            'session_id': sid,
            'type': 'session.info',
            'seq': cursor,
            'payload': {
              'pending': rows.where((r) => r['status'] != 'terminal').toList(),
              'running': true,
            },
          },
        }),
      );
    }
  }

  Map<String, Object?> receipt(Map<String, Object?> row) => {
    for (final key in [
      'admission_id',
      'ref',
      'sequence',
      'status',
      'outcome',
      'authority_epoch',
      'execution_generation',
    ])
      key: row[key],
  };
  Map<String, Object?>? rpc(String method, Map params) {
    if (method == 'session.resume') {
      return {
        'result': {
          'session_id': sid,
          'stored_session_id': sid,
          'running': false,
          'authority_epoch': 9,
          'replay_epoch': 'fifo',
          'last_sequence': cursor,
          'execution_generation': 21,
          'pending': rows.where((r) => r['status'] != 'terminal').toList(),
          'info': {'profile_id': profile, 'profile_name': 'work'},
        },
      };
    }
    if (!method.startsWith('prompt.')) return null;
    if (params['session_id'] != sid || params['profile'] != 'work') {
      return {
        'error': {'code': 403},
      };
    }
    Map<String, Object?>? row = rows
        .where((r) => r['admission_id'] == params['admission_id'])
        .firstOrNull;
    switch (method) {
      case 'prompt.receipt':
        break;
      case 'prompt.submit':
        row = add(
          params['text'] as String,
          input: params['submission_id'] as String,
        );
      case 'prompt.cancel':
        row!['status'] = 'terminal';
        row['outcome'] = 'cancelled';
      case 'prompt.steer_queued':
        row!['status'] = 'started';
        row['steering'] = true;
        row['execution_generation'] = 21;
      case 'prompt.replace_queued':
        if (row?['status'] != 'queued') {
          return {
            'error': {
              'code': 4001,
              'data': {'reason': 'admission_started'},
            },
          };
        }
        row!['status'] = 'terminal';
        row['outcome'] = 'cancelled';
        row = add(
          params['text'] as String,
          input: params['submission_id'] as String,
        );
      case 'prompt.resolve_unknown':
        if (row?['status'] != 'unknown' ||
            params['execution_generation'] != row?['execution_generation']) {
          return {
            'error': {'code': 4001},
          };
        }
        row!['status'] = 'terminal';
        row['outcome'] = 'interrupted';
      default:
        return {
          'error': {'code': -32601},
        };
    }
    if (row == null) {
      return {
        'error': {'code': 404},
      };
    }
    if (method != 'prompt.receipt') {
      notify();
      if (unknownAck) {
        return {
          'result': {
            'ref': {'session_id': 'wrong'},
          },
        };
      }
    }
    return {'result': receipt(row)};
  }
}
