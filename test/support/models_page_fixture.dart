// A gateway for the NextGen Models page tests: the model routes, the raw
// config route and its schema, answered from in-memory state that writes
// change the way the real gateway does.
import 'dart:async';
import 'dart:convert';

import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fallback_config_contract.dart';

final modelsConnection = SavedConnection(
  id: 'models',
  label: 'Research',
  host: 'example.test',
  port: 8642,
  apiKey: 'synthetic',
  gatewayProfile: 'research & development',
  dashboardPrefix: '/proxy',
  dashboardProxied: true,
);

class ModelsFixture {
  final requests = <http.Request>[];

  /// Bodies sent to `model/set`, in order.
  final modelWrites = <Map<String, dynamic>>[];

  /// Bodies sent to `PUT config`, in order.
  final configWrites = <Map<String, dynamic>>[];

  bool accept = true;
  bool persist = true;
  bool failInfo = false;
  bool failOptions = false;
  bool failAux = false;
  int schemaStatus = 200;
  int routeStatus = 200;

  /// The gateway's warning for a model it wants confirmed first.
  String? confirmMessage;

  /// The address saved with the default model when its provider is not a
  /// named endpoint; empty for none. A default on a named endpoint reports
  /// that endpoint's address unless this overrides it.
  String endpoint = '';

  /// Replaces the custom-endpoints answer when set.
  Map<String, dynamic>? routeOverride;
  Completer<http.Response>? heldWrite;
  Completer<http.Response>? heldInfo;

  Map<String, dynamic> info = {
    'model': 'claude-opus-4.5',
    'provider': 'anthropic',
    'auto_context_length': 200000,
    'config_context_length': 0,
    'effective_context_length': 200000,
    'capabilities': {
      'supports_tools': true,
      'supports_vision': true,
      'supports_reasoning': true,
      'context_window': 200000,
      'max_output_tokens': 64000,
      'model_family': 'claude-opus',
    },
  };

  List<Map<String, dynamic>> providers = [
    {
      'slug': 'anthropic',
      'name': 'Anthropic',
      'models': ['claude-opus-4.5', 'claude-haiku-4.5'],
      'total_models': 2,
      'is_current': true,
      'pricing': {
        'claude-opus-4.5': {
          'input': r'$5.00',
          'output': r'$25.00',
          'cache': r'$0.50',
          'free': false,
        },
        'claude-haiku-4.5': {
          'input': r'$1.00',
          'output': r'$5.00',
          'cache': null,
          'free': false,
        },
      },
      'capabilities': {
        'claude-opus-4.5': {'fast': true, 'reasoning': true},
        'claude-haiku-4.5': {'fast': false, 'reasoning': true},
      },
      'usage': {
        'windows': [
          {
            'label': '5-hour session',
            'used_percent': 42.4,
            'resets_at': '2030-01-01T10:00:00+00:00',
            'scope': 'account',
          },
        ],
      },
    },
    {
      'slug': 'openrouter',
      'name': 'OpenRouter',
      'models': ['google/gemini-flash', 'meta/llama-free', 'openai/gpt-pro'],
      'total_models': 340,
      'pricing': {
        'google/gemini-flash': {
          'input': r'$0.30',
          'output': r'$2.50',
          'cache': null,
          'free': false,
        },
        'meta/llama-free': {
          'input': 'free',
          'output': 'free',
          'cache': null,
          'free': true,
        },
      },
      'capabilities': {
        'google/gemini-flash': {'fast': false, 'reasoning': true},
        'meta/llama-free': {'fast': false, 'reasoning': false},
        'openai/gpt-pro': {'fast': false, 'reasoning': true},
      },
      'unavailable_models': ['openai/gpt-pro'],
    },
    {
      'slug': 'homelab',
      'name': 'Homelab',
      'models': ['local-llm'],
      'is_user_defined': true,
      'api_url': 'http://private.example:8000/v1',
      'key_env': 'HOMELAB_SECRET_KEY',
    },
  ];

  List<Map<String, dynamic>> tasks = [
    {
      'task': 'vision',
      'provider': 'auto',
      'model': '',
      'base_url': '',
      'reasoning_effort': null,
    },
    {
      'task': 'compression',
      'provider': 'openrouter',
      'model': 'google/gemini-flash',
      'base_url': '',
      'reasoning_effort': 'low',
    },
    {
      'task': 'acme_summary',
      'provider': 'auto',
      'model': '',
      'base_url': '',
      'reasoning_effort': null,
      'label': 'Acme summary',
      'hint': 'Summarises Acme tickets',
      'plugin': 'acme',
      'inherit_from': 'compression',
      'effective': {
        'provider': 'openrouter',
        'model': 'google/gemini-flash',
        'base_url': '',
      },
    },
    {
      'task': 'custom_route',
      'provider': 'custom',
      'model': 'private-model',
      'base_url': 'https://private.example/v1',
    },
    // An older gateway: no thinking level reported, no name for the task.
    {'task': 'web_extract', 'provider': 'auto', 'model': '', 'base_url': ''},
  ];

  Map<String, dynamic> config = {
    'fallback_providers': [
      {'provider': 'openrouter', 'model': 'google/gemini-flash'},
    ],
  };

  http.Response _json(Object data, [int status = 200]) => http.Response(
    jsonEncode(data),
    status,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );

  Iterable<http.Request> at(String suffix, [String? method]) => requests.where(
    (r) =>
        r.url.path.endsWith(suffix) && (method == null || r.method == method),
  );

  late final DashboardClient client = DashboardClient.fromConnection(
    modelsConnection,
    httpClient: MockClient((request) async {
      requests.add(request);
      final path = request.url.path;
      if (path.endsWith('/openapi.json')) {
        return _json(fallbackConfigSchema(), schemaStatus);
      }
      if (path.endsWith('/api/config')) {
        if (request.method == 'PUT') {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          configWrites.add(body);
          if (heldWrite != null) return heldWrite!.future;
          if (accept && persist) {
            config = {...config, ...body['config'] as Map<String, dynamic>};
          }
          return _json({'ok': accept});
        }
        return _json(config);
      }
      if (path.endsWith('/providers/custom-endpoints')) {
        if (routeOverride != null) return _json(routeOverride!, routeStatus);
        // As `config_env._custom_endpoint_response` builds it. `providers:`
        // entries are in use when the default names them; legacy
        // `custom_providers` entries (slug `custom:<id>`) only when the
        // default is a bare `custom` at their address; and a made-up
        // `custom` row stands for a bare `custom` default that matches no
        // entry.
        final rows = [
          for (final p in providers)
            if (p['is_user_defined'] == true && p['api_url'] is String) p,
        ];
        final provider = '${info['provider']}';
        final bareCustom = provider.toLowerCase() == 'custom';
        String bare(Object? url) =>
            '$url'.trim().replaceFirst(RegExp(r'/+$'), '').toLowerCase();
        bool legacy(Map<String, dynamic> p) =>
            '${p['slug']}'.startsWith('custom:');
        bool inUse(Map<String, dynamic> p) => legacy(p)
            ? bareCustom &&
                  endpoint.isNotEmpty &&
                  bare(p['api_url']) == bare(endpoint)
            : p['slug'] == provider ||
                  'custom:${p['slug']}' == provider.toLowerCase();
        final own = rows.where((p) => !legacy(p) && inUse(p));
        final address = endpoint.isNotEmpty || own.isEmpty
            ? endpoint
            : own.first['api_url'] as String;
        return _json({
          'current': {
            'provider': info['provider'],
            'model': info['model'],
            'base_url': address,
          },
          'endpoints': [
            for (final p in rows)
              {
                'id': legacy(p)
                    ? '${p['slug']}'.substring('custom:'.length)
                    : p['slug'],
                'name': p['name'],
                'base_url': p['api_url'],
                'is_current': inUse(p),
                'source': legacy(p) ? 'custom_providers' : 'providers',
                'has_api_key': true,
                'api_key_preview': 'sk-...cret',
              },
            if (bareCustom && endpoint.isNotEmpty && !rows.any(inUse))
              {
                'id': 'custom',
                'name': 'Custom',
                'base_url': endpoint,
                'is_current': true,
                'source': 'direct-config',
              },
          ],
        }, routeStatus);
      }
      if (path.endsWith('/model/set')) {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        modelWrites.add(body);
        if (heldWrite != null) return heldWrite!.future;
        if (confirmMessage != null &&
            body['model'] != '' &&
            body['confirm_expensive_model'] != true) {
          return _json({
            'ok': false,
            'confirm_required': true,
            'confirm_message': confirmMessage,
          });
        }
        if (accept && persist) {
          if (body['scope'] == 'main') {
            info = {
              ...info,
              'provider': body['provider'],
              'model': body['model'],
            };
            // The gateway writes the new provider's own address.
            endpoint = '';
          } else {
            tasks = [
              for (final task in tasks)
                if (task['task'] == body['task'])
                  {
                    ...task,
                    'provider': body['provider'],
                    'model': body['model'],
                    if (body.containsKey('reasoning_effort'))
                      'reasoning_effort': body['reasoning_effort'],
                  }
                else
                  task,
            ];
          }
        }
        return _json({'ok': accept});
      }
      if (path.endsWith('/model/info')) {
        if (heldInfo != null) return heldInfo!.future;
        return failInfo ? _json({'detail': 'secret-detail'}, 500) : _json(info);
      }
      if (path.endsWith('/model/auxiliary')) {
        return failAux
            ? _json({'detail': 'secret-detail'}, 500)
            : _json({'tasks': tasks});
      }
      if (path.endsWith('/model/options')) {
        return failOptions
            ? _json({'detail': 'secret-detail'}, 500)
            : _json({
                'providers': providers,
                'model': info['model'],
                'provider': info['provider'],
              });
      }
      return _json({'detail': 'not found'}, 404);
    }),
  );
}
