// The pieces NextGen's command send is built from: the line parser, the
// shared result parser's extra fields, the refusal/transport classification
// and the catalogue's run-or-prompt decision.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/models/slash_command.dart';
import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/slash_command_errors.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:hermes_android/nextgen/data/slash_catalog.dart';
import 'package:hermes_android/nextgen/data/slash_exec.dart';

class _Gateway extends NextGenGateway {
  _Gateway()
    : super(
        SavedConnection(
          id: 'unit',
          label: 'Home',
          host: '10.0.0.5',
          port: 9119,
          apiKey: '',
          desktopGatewayUrl: 'http://10.0.0.5:9119',
          singleLogin: true,
          signInMethod: 'none',
        ),
      );

  Completer<Map<String, dynamic>>? hold;
  int catalogCalls = 0;
  WsClient current = WsClient('http://10.0.0.5:9119');

  @override
  WsClient? get socket => current;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    catalogCalls++;
    final held = hold;
    if (held != null) return held.future;
    return {
      'pairs': [
        ['/help', 'Show help'],
        ['/background', 'Run in the background'],
      ],
      'canon': {'/bg': '/background'},
      'plugin_commands': {'deploy': 'Deploy'},
      'skills': {'review': <String, dynamic>{}},
    };
  }
}

void main() {
  group('NgSlashLine', () {
    test('parses the way the highlight and the gateway split a line', () {
      final line = NgSlashLine.parse('/Title  My trip\nto Rome')!;
      expect(line.name, 'title');
      expect(line.arg, 'My trip\nto Rome');
      expect(line.line, 'title My trip\nto Rome');
      expect(line.label, '/title My trip\nto Rome');
      expect(NgSlashLine.parse('/help')!.line, 'help');
      for (final prose in [
        '/',
        'please /help',
        '/usr/bin/env',
        '//help',
        'hello',
      ]) {
        expect(NgSlashLine.parse(prose), isNull, reason: prose);
      }
    });

    test('an alias keeps the typed argument after the target\'s own', () {
      const line = NgSlashLine('bg', 'run tests');
      expect(line.aliasedTo('/background')!.line, 'background run tests');
      expect(
        line.aliasedTo('status --brief')!.line,
        'status --brief run tests',
      );
      expect(line.aliasedTo('/usr/bin'), isNull);
    });

    test('local routes', () {
      for (final name in ['new', 'reset', 'stop', 'model']) {
        expect(NgSlashLine(name, '').isLocal, isTrue);
      }
      expect(const NgSlashLine('help', '').isLocal, isFalse);
    });
  });

  group('SlashCommandResult keeps what NextGen needs', () {
    test('send/skill carry display and notice; text stays the message', () {
      final skill = SlashCommandResult.fromResult({
        'type': 'skill',
        'message': 'BODY',
        'display': '/review x',
      });
      expect(skill.isPrompt, isTrue);
      expect(skill.text, 'BODY');
      expect(skill.display, '/review x');
      final send = SlashCommandResult.fromResult({
        'type': 'send',
        'message': 'Go',
        'notice': 'Plan mode on',
      });
      expect(
        (send.text, send.display, send.notice),
        ('Go', '', 'Plan mode on'),
      );
    });

    test('alias exposes its target and keeps Classic\'s text', () {
      final alias = SlashCommandResult.fromResult({
        'type': 'alias',
        'target': 'background',
      });
      expect(alias.isExecuted, isTrue);
      expect(alias.text, '/background');
      expect(alias.aliasTarget, '/background');
    });

    test('output stays authoritative and prefill carries its notice', () {
      final out = SlashCommandResult.fromResult({
        'type': 'alias',
        'target': 'x',
        'output': 'ran',
      });
      expect((out.text, out.aliasTarget), ('ran', ''));
      final prefill = SlashCommandResult.fromResult({
        'type': 'prefill',
        'message': 'last prompt',
        'notice': 'Undid one turn',
      });
      expect(prefill.isPrefill, isTrue);
      expect(prefill.notice, 'Undid one turn');
    });
  });

  group('classification', () {
    JsonRpcError e(String message, {int? code, String? reason}) => JsonRpcError(
      'slash.exec',
      message,
      code: code,
      reason: reason,
      data: {'reason': ?reason},
    );

    test("refusals are #303's: the exact reason, or the legacy forms", () {
      expect(
        isSlashCommandRefusal(
          e('x', code: 4001, reason: 'unsupported_command'),
        ),
        isTrue,
      );
      expect(
        isSlashCommandRefusal(e('unsupported_command', code: 4018)),
        isTrue,
      );
      expect(
        isSlashCommandRefusal(
          e('not a quick/plugin/bundle/skill command: x', code: 4018),
        ),
        isTrue,
      );
      expect(
        isSlashCommandRefusal(e('quick command failed', code: 4018)),
        isFalse,
        reason: 'a naked 4018 can be a command that ran and failed',
      );
      expect(
        isSlashCommandRefusal(e('busy', code: 4009, reason: 'session_busy')),
        isFalse,
      );
    });

    test('the explicit dispatch redirect, and nothing broader', () {
      expect(
        ngIsDispatchRedirect(
          e('skill command: use command.dispatch for /review', code: 4018),
        ),
        isTrue,
      );
      expect(
        ngIsDispatchRedirect(
          e(
            'snapshot restore mutates live config/state; use command.dispatch '
            'for /snapshot restore',
            code: 4018,
          ),
        ),
        isTrue,
      );
      expect(
        ngIsDispatchRedirect(e('quick command failed', code: 4018)),
        isFalse,
      );
      expect(
        ngIsDispatchRedirect(e('use command.dispatch', code: 5030)),
        isFalse,
      );
    });

    test('lost replies and missing methods', () {
      expect(isSlashDeliveryUnknown(e('Timeout')), isTrue);
      expect(
        isSlashDeliveryUnknown(e('closed', reason: 'connection_closed')),
        isTrue,
      );
      expect(isSlashDeliveryUnknown(e('refused', code: 4001)), isFalse);
      expect(ngIsMethodNotFound(e('unknown method', code: -32601)), isTrue);
      expect(ngIsMethodNotFound(e('unknown method', code: 4000)), isFalse);
    });
  });

  group('NgSlashCatalog decides run or prompt', () {
    test('local routes always run; the catalogue decides the rest', () async {
      final gateway = _Gateway();
      final reader = NgSlashCatalog()..scopeTo(gateway);
      for (final name in ['new', 'reset', 'stop', 'model']) {
        expect(reader.resolve(name), isNotNull, reason: name);
      }
      await reader.ensureLoaded();
      expect(await reader.runsOnGateway('deploy'), isTrue, reason: 'plugin');
      expect(await reader.runsOnGateway('review'), isTrue, reason: 'skill');
      expect(await reader.runsOnGateway('BG'), isTrue, reason: 'alias');
      expect(
        await reader.runsOnGateway('status'),
        isFalse,
        reason: 'a loaded catalogue is authoritative over the fallback',
      );
      expect(await reader.runsOnGateway('frobnicate'), isFalse);
      reader.dispose();
    });

    test('a slow catalogue is awaited only briefly, then the fallback set '
        'decides', () async {
      final gateway = _Gateway()..hold = Completer();
      final reader = NgSlashCatalog()..scopeTo(gateway);
      const wait = Duration(milliseconds: 30);
      expect(await reader.runsOnGateway('status', wait: wait), isTrue);
      expect(await reader.runsOnGateway('deploy', wait: wait), isFalse);
      expect(gateway.catalogCalls, 1, reason: 'one flight');
      reader.dispose();
    });

    test('a connection without slash.exec runs only the local routes, until '
        'it reconnects', () async {
      final gateway = _Gateway();
      final reader = NgSlashCatalog()..scopeTo(gateway);
      await reader.ensureLoaded();
      ngMarkSlashExecUnsupported(gateway.current);
      expect(await reader.runsOnGateway('help'), isFalse);
      expect(reader.resolve('help'), isNull);
      expect(reader.resolve('new'), isNotNull);
      gateway.current = WsClient('http://10.0.0.5:9119');
      expect(await reader.runsOnGateway('help'), isTrue);
      reader.dispose();
    });
  });
}
