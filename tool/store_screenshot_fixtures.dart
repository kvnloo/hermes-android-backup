// Invented sample data and an in-memory gateway for
// tool/render_store_screenshots.dart. Nothing here talks to a network: REST
// reads are answered by a MockClient, JSON-RPC calls by [DemoGateway.call].
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hermes_android/core/services/connection_manager.dart';
import 'package:hermes_android/core/services/dashboard_api_client.dart';
import 'package:hermes_android/core/services/ws_client.dart';
import 'package:hermes_android/nextgen/data/nextgen_gateway.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const demoConnectionId = 'demo';

/// What differs between screens: a phone's model chip has room for a short
/// name only, and each transcript is sized to fill its pane without leaving
/// the first prompt cut in half.
class DemoLook {
  const DemoLook.phone()
    : model = 'gpt-5',
      provider = 'openai',
      effort = null,
      helperModel = 'gpt-5-mini',
      reviewTurns = 1,
      emailTurns = 1,
      tripTurns = 1,
      docsTurns = 1,
      projects = 6,
      brief = false;
  const DemoLook.wide({
    this.reviewTurns = 3,
    this.emailTurns = 3,
    this.tripTurns = 2,
    this.docsTurns = 3,
    this.projects = 12,
    this.brief = false,
  }) : model = 'claude-sonnet-4.5',
       provider = 'anthropic',
       effort = 'medium',
       helperModel = 'claude-haiku-4.5';

  final String model;
  final String provider;
  final String? effort;

  /// The model delegated subagents run on.
  final String helperModel;

  /// How many of each chat's newest turns the transcript holds.
  final int reviewTurns, emailTurns, tripTurns, docsTurns;

  /// How many projects the Projects page lists.
  final int projects;

  /// Drops a closing line from the longer replies (a short, wide window).
  final bool brief;
}

SavedConnection demoConnection() => SavedConnection(
  id: demoConnectionId,
  label: 'My gateway',
  host: 'gateway.example.com',
  port: 443,
  apiKey: '',
  useHttps: true,
  desktopGatewayUrl: 'https://gateway.example.com',
  dashboardProxied: true,
  singleLogin: true,
  signInMethod: 'none',
);

double _epoch(DateTime time) => time.millisecondsSinceEpoch / 1000.0;

/// One sample chat: its sidebar row, its stored transcript and what the
/// gateway reports when the chat attaches to it.
class DemoChat {
  DemoChat({
    required this.id,
    required this.title,
    required this.ago,
    this.pinned = false,
    this.running = false,
    this.unread = false,
    this.turns = const [],
    this.todos,
    this.approval,
  });

  final String id;
  final String title;

  /// How long ago the chat last moved.
  final Duration ago;
  final bool pinned;
  final bool running;

  /// Has a reply this device has not looked at (the green dot).
  final bool unread;

  /// Stored turns, oldest first; each is a list of history rows.
  final List<List<Map<String, dynamic>>> turns;
  final List<Map<String, dynamic>>? todos;
  final Map<String, dynamic>? approval;

  String get runtimeId => 'rt-$id';

  Session row(
    DateTime now,
    String model, {
    String source = 'desktop',
    bool live = true,
    Duration? ago,
  }) => Session(
    id: id,
    title: title,
    model: model,
    source: source,
    messageCount: 2 + turns.length * 2,
    isActive: live && running,
    preview: '',
    startedAt: _epoch(
      now.subtract((ago ?? this.ago) + const Duration(hours: 1)),
    ),
    lastActive: _epoch(now.subtract(ago ?? this.ago)),
    pinned: pinned,
  );
}

Map<String, dynamic> _user(String text, DateTime at) => {
  'role': 'user',
  'content': text,
  'timestamp': _epoch(at),
};

Map<String, dynamic> _assistant(
  String text,
  DateTime at, {
  List<(String, String, String)> tools = const [],
}) => {
  'role': 'assistant',
  'content': text,
  'timestamp': _epoch(at),
  if (tools.isNotEmpty)
    'tool_calls': [
      for (final (id, name, label) in tools)
        {
          'id': id,
          'label': label,
          'function': {'name': name, 'arguments': '{}'},
        },
    ],
};

Map<String, dynamic> _tool(String id, String output, DateTime at) => {
  'role': 'tool',
  'tool_call_id': id,
  'content': output,
  'timestamp': _epoch(at),
};

const _reviewIntro = '''
`parse_config()` turns the JSON settings file into a `Config` object:

- It opens the file at `path` and decodes it
- It reads the `server` section for the host and port
- It returns a `Config` the rest of the app shares

It is called once, at startup.''';

const _reviewReply = '''
It works, but it crashes when a section is missing. Two things are worth changing:

1. **Missing sections** raise `KeyError`. Use `.get()` with a default.
2. **The file handle** is never closed. A `with` block fixes that.

```python
def parse_config(path):
    with open(path) as f:
        raw = json.load(f)
    server = raw.get("server", {})
    host = server.get("host", "localhost")
    port = int(server.get("port", 8080))
    return Config(host, port)
```''';

const _reviewFollowUp = '''
Done. I added `test_missing_section` and ran the suite:

- 14 tests passed, none failed''';

const _reviewFollowUpClosing = '''
- Coverage for `config.py` is now 96%

The new test loads a file with no `server` section and checks that both defaults are applied.''';

const _emailReply = '''
Here is a short draft you can adjust:

**Subject:** Welcome to the Riverside Book Club

Hi there,

Welcome aboard. We meet on the first Thursday of each month at the community library, and everyone gets a say in what we read next.

A few things to know before your first evening:

- This month's book is on the shared shelf by the door
- Bring a favourite quote to open the discussion
- Tea and biscuits are on us
%REPLY%
See you soon,
The organising team''';

const _emailTips = '''
Keep it short: a warm greeting, when and where you meet, and what to bring the first time.''';

const _emailFollowUp = '''
Here is the warmer version, with the picnic added:

**Subject:** Welcome to the Riverside Book Club

Hi there,

We are so glad you are joining us. We meet on the first Thursday of each month at the community library, and everyone gets a say in what we read next.

Before your first evening:

- This month's book is on the shared shelf by the door
- Bring a favourite quote to open the discussion
- Save the date for our summer picnic in the park
%COME%
Warmly,
The organising team''';

const _summaryReply = '''
Here is the short version of the planning doc:

- **Goal:** ship offline mode for the mobile app this quarter
- **Scope:** read access first, editing in a later release
- **Risks:** sync conflicts and the size of the local cache

The open question is who owns the migration script.''';

const _tripCompare = '''
All three work well in May. A quick comparison:

- **Lisbon:** hills, viewpoints and food markets, with easy day trips by train
- **Porto:** smaller and slower, best for riverside walks
- **Seville:** the warmest of the three, at its best in the evenings

For markets, views and a day trip in one weekend, Lisbon fits best.''';

const _docsChanges = '''
Four pages changed since the last release:

- `getting-started.md` has the new install steps
- `configuration.md` documents two more settings
- `faq.md` gained three answers
- `changelog.md` lists the release itself

Everything else is untouched.''';

const _treesReply = '''
A binary search tree keeps values in order so you can find one quickly.

- Smaller values go left, larger values go right
- Each step of a search discards half of what is left

```python
def contains(node, value):
    while node:
        if value == node.value:
            return True
        if value < node.value:
            node = node.left
        else:
            node = node.right
    return False
```''';

const _docsHowTo = '''
The site is generated from the Markdown files in `docs/`:

- `npm run build` renders every page into the `build` folder
- `npm run check-links` follows each internal link
- The result is published from the `main` branch

A full rebuild takes about a minute.''';

List<List<Map<String, dynamic>>> _last(
  List<List<Map<String, dynamic>>> turns,
  int count,
) => turns.sublist((turns.length - count).clamp(0, turns.length));

/// The sample chats, newest first.
List<DemoChat> demoChats(DateTime now, DemoLook look) {
  DateTime at(int minutes) => now.subtract(Duration(minutes: minutes));
  final review = <List<Map<String, dynamic>>>[
    [
      _user('What does parse_config() in config.py do?', at(19)),
      _assistant('', at(19), tools: [('t0', 'read_file', 'src/config.py')]),
      _tool('t0', 'def parse_config(path): ...', at(19)),
      _assistant(_reviewIntro.trim(), at(18)),
    ],
    [
      _user('Can you review parse_config() for me?', at(14)),
      _assistant('', at(14), tools: [('t1', 'read_file', 'src/config.py')]),
      _tool('t1', 'def parse_config(path): ...', at(14)),
      _assistant(_reviewReply.trim(), at(13)),
    ],
    [
      _user('Add a test for the missing-section case, please.', at(11)),
      _assistant(
        '',
        at(11),
        tools: [
          ('t2', 'write_file', 'tests/test_config.py'),
          ('t3', 'terminal', 'pytest -q'),
        ],
      ),
      _tool('t2', 'Wrote tests/test_config.py', at(11)),
      _tool('t3', '14 passed in 0.42s', at(10)),
      _assistant(
        [
          _reviewFollowUp.trim(),
          if (!look.brief) _reviewFollowUpClosing.trim(),
        ].join('\n'),
        at(10),
      ),
    ],
  ];
  // A phone shows the review itself; wide windows add the turns around it.
  final reviewTurns = look.reviewTurns == 1
      ? [review[1]]
      : _last(review, look.reviewTurns);
  final email = <List<Map<String, dynamic>>>[
    [
      _user('What should a welcome email include?', at(55)),
      _assistant(_emailTips.trim(), at(55)),
    ],
    [
      _user(
        'Draft a short welcome email for new members of our book club.',
        at(52),
      ),
      _assistant(
        _emailReply.trim().replaceFirst(
          '%REPLY%',
          look.brief
              ? ''
              : '\nIf anything is unclear, just reply to this email.\n',
        ),
        at(51),
      ),
    ],
    [
      _user(
        'Lovely. Make it a little warmer and mention the summer picnic.',
        at(49),
      ),
      _assistant(
        _emailFollowUp.trim().replaceFirst(
          '%COME%',
          look.brief ? '' : '\nTea and biscuits are on us. Come as you are.\n',
        ),
        at(48),
      ),
    ],
  ];
  // A phone shows the first draft; wide windows add the turns around it.
  final emailTurns = look.emailTurns == 1
      ? [email[1]]
      : _last(email, look.emailTurns);
  final trip = <List<Map<String, dynamic>>>[
    [
      _user('We want a city break in May. Lisbon, Porto or Seville?', at(6)),
      _assistant(_tripCompare.trim(), at(5)),
    ],
    [
      _user(
        'Lisbon it is. Plan a weekend for two: food markets, viewpoints '
        'and one day trip out of the city.',
        at(2),
      ),
    ],
  ];
  final docs = <List<Map<String, dynamic>>>[
    [
      _user('Which pages changed since the last release?', at(12)),
      _assistant(
        '',
        at(12),
        tools: [('d9', 'terminal', 'git diff --stat v2.3')],
      ),
      _tool('d9', '4 files changed', at(12)),
      _assistant(_docsChanges.trim(), at(11)),
    ],
    [
      _user('How is the docs site built?', at(8)),
      _assistant('', at(8), tools: [('d0', 'read_file', 'package.json')]),
      _tool('d0', '{"scripts": {}}', at(8)),
      _assistant(_docsHowTo.trim(), at(7)),
    ],
    [
      _user(
        'It is out of date. Rebuild it from the latest main branch and '
        'check the links.',
        at(3),
      ),
    ],
  ];
  return [
    DemoChat(
      id: 'review',
      title: 'Review parse_config()',
      ago: const Duration(minutes: 10),
      pinned: true,
      turns: reviewTurns,
    ),
    DemoChat(
      id: 'trip',
      title: 'Plan a weekend in Lisbon',
      ago: const Duration(seconds: 20),
      pinned: true,
      running: true,
      turns: _last(trip, look.tripTurns),
      todos: [
        _todo('1', 'Collect ideas for each day', 'completed'),
        _todo('2', 'Pick food markets and viewpoints', 'completed'),
        _todo('3', 'Shortlist neighbourhoods to stay in', 'in_progress'),
        _todo('4', 'Choose a day trip', 'pending'),
        _todo('5', 'Write the day-by-day itinerary', 'pending'),
        _todo('6', 'Add a packing checklist', 'pending'),
      ],
    ),
    DemoChat(
      id: 'docs',
      title: 'Rebuild the docs site',
      ago: const Duration(minutes: 1),
      running: true,
      turns: _last(docs, look.docsTurns),
      approval: {
        'id': 'approval-docs',
        'method': 'approval',
        'params': {
          'session_id': 'rt-docs',
          'tool_name': 'terminal',
          'command': 'rm -rf build && npm run build',
          'description': 'Delete the old build folder and rebuild the site.',
        },
      },
    ),
    DemoChat(
      id: 'summary',
      title: 'Summarise the Q3 planning doc',
      ago: const Duration(minutes: 25),
      unread: true,
      turns: [
        [
          _user('Summarise the Q3 planning doc in a few bullets.', at(27)),
          _assistant(_summaryReply.trim(), at(25)),
        ],
      ],
    ),
    DemoChat(
      id: 'email',
      title: 'Draft a welcome email',
      ago: const Duration(minutes: 48),
      turns: emailTurns,
    ),
    DemoChat(
      id: 'tests',
      title: 'Fix the flaky login test',
      ago: const Duration(hours: 3),
    ),
    DemoChat(
      id: 'reading',
      title: 'Reading list: distributed systems',
      ago: const Duration(hours: 6),
    ),
    DemoChat(
      id: 'meals',
      title: 'Meal plan for the week',
      ago: const Duration(days: 1, hours: 2),
    ),
    DemoChat(
      id: 'trees',
      title: 'Binary search trees',
      ago: const Duration(days: 2, hours: 5),
      turns: [
        [
          _user('Explain binary search trees in simple terms.', at(9)),
          _assistant(_treesReply.trim(), at(8)),
        ],
      ],
    ),
    DemoChat(
      id: 'notes',
      title: 'Compare two note-taking apps',
      ago: const Duration(days: 3, hours: 1),
    ),
    DemoChat(
      id: 'party',
      title: 'Birthday party checklist',
      ago: const Duration(days: 5),
    ),
    DemoChat(
      id: 'translate',
      title: 'Translate release notes to Spanish',
      ago: const Duration(days: 9),
    ),
    DemoChat(
      id: 'standup',
      title: 'Weekly standup summary',
      ago: const Duration(days: 16),
    ),
    DemoChat(
      id: 'garden',
      title: 'Balcony herb garden plan',
      ago: const Duration(days: 23),
    ),
    DemoChat(
      id: 'interview',
      title: 'Interview questions for a designer',
      ago: const Duration(days: 30),
    ),
    DemoChat(
      id: 'changelog',
      title: 'Tidy up the changelog',
      ago: const Duration(days: 37),
    ),
  ];
}

Map<String, dynamic> _todo(String id, String content, String status) => {
  'id': id,
  'content': content,
  'status': status,
};

/// Preference values that mark every chat but the [DemoChat.unread] ones as
/// already looked at, and reopen [openChat] on launch.
Map<String, Object> demoPreferences(
  List<DemoChat> chats,
  DateTime now, {
  String? openChat,
}) {
  final nowSeconds = _epoch(now) + 60;
  return {
    'nextgen_enabled': true,
    'nextgen.seen_chats.$demoConnectionId': jsonEncode({
      'since': _epoch(now.subtract(const Duration(days: 60))),
      'chats': {
        for (final chat in chats)
          if (!chat.unread) chat.id: nowSeconds,
      },
    }),
    'nextgen_last_session.$demoConnectionId': ?openChat,
  };
}

/// The gateway's `commands.catalog` answer.
Map<String, dynamic> demoCatalog() => {
  'pairs': [
    ['/help', 'Show what Hermes can do'],
    ['/title', 'Rename this chat'],
    ['/background', 'Run a prompt in the background'],
    ['/summarise', 'Summarise the chat so far'],
    ['/review', 'Review a change before it ships'],
    ['/tools', 'Choose which tools are on'],
    ['/personality', 'Pick a tone of voice'],
  ],
  'canon': {'/bg': '/background'},
  'categories': [
    {
      'name': 'Session',
      'pairs': [
        ['/help', 'Show what Hermes can do'],
        ['/title', 'Rename this chat'],
      ],
    },
  ],
  'skills': {
    '/review': {'usage': 0, 'origin': 'local'},
    '/summarise': {'usage': 0, 'origin': 'local'},
  },
};

const _projects = <(String, String, String, int)>[
  ('p-site', 'Website redesign', '/projects/website', 12),
  ('p-app', 'Mobile app', '/projects/mobile-app', 9),
  ('p-docs', 'Documentation', '/projects/docs', 7),
  ('p-research', 'Research notes', '/projects/research', 5),
  ('p-home', 'Home automation', '/projects/home', 4),
  ('p-recipes', 'Recipe collection', '/projects/recipes', 3),
  ('p-handbook', 'Team handbook', '/projects/handbook', 6),
  ('p-travel', 'Travel journal', '/projects/travel', 4),
  ('p-garden', 'Garden planner', '/projects/garden', 2),
  ('p-reading', 'Reading tracker', '/projects/reading', 8),
  ('p-language', 'Language practice', '/projects/language', 5),
  ('p-photos', 'Photo archive', '/projects/photos', 3),
];

Map<String, dynamic> _modelInfo(DemoLook look) => {
  'model': look.model,
  'provider': look.provider,
  'auto_context_length': 200000,
  'config_context_length': 0,
  'effective_context_length': 200000,
  'capabilities': {
    'supports_tools': true,
    'supports_vision': true,
    'supports_reasoning': true,
    'context_window': 200000,
    'max_output_tokens': 64000,
  },
};

List<Map<String, dynamic>> _providers(DemoLook look) => [
  for (final provider in _providerRows)
    {
      ...provider,
      if (provider['slug'] == look.provider) ...{
        'is_current': true,
        'usage': {
          'windows': [
            {
              'label': '5-hour session',
              'used_percent': 38.0,
              'scope': 'account',
            },
          ],
        },
      },
    },
];

const _providerRows = <Map<String, dynamic>>[
  {
    'slug': 'anthropic',
    'name': 'Anthropic',
    'models': ['claude-sonnet-4.5', 'claude-opus-4.5', 'claude-haiku-4.5'],
    'total_models': 3,
    'capabilities': {
      'claude-sonnet-4.5': {'fast': true, 'reasoning': true},
      'claude-opus-4.5': {'fast': false, 'reasoning': true},
      'claude-haiku-4.5': {'fast': true, 'reasoning': true},
    },
  },
  {
    'slug': 'openai',
    'name': 'OpenAI',
    'models': ['gpt-5', 'gpt-5-mini'],
    'total_models': 2,
    'capabilities': {
      'gpt-5': {'fast': false, 'reasoning': true},
      'gpt-5-mini': {'fast': true, 'reasoning': true},
    },
  },
  {
    'slug': 'google',
    'name': 'Google',
    'models': ['gemini-2.5-pro', 'gemini-2.5-flash'],
    'total_models': 2,
    'capabilities': {
      'gemini-2.5-pro': {'fast': false, 'reasoning': true},
      'gemini-2.5-flash': {'fast': true, 'reasoning': true},
    },
  },
];

List<Map<String, dynamic>> _auxTasks() => [
  {
    'task': 'vision',
    'provider': 'auto',
    'model': '',
    'base_url': '',
    'reasoning_effort': null,
  },
  {
    'task': 'compression',
    'provider': 'google',
    'model': 'gemini-2.5-flash',
    'base_url': '',
    'reasoning_effort': 'low',
  },
  {
    'task': 'title_generation',
    'provider': 'anthropic',
    'model': 'claude-haiku-4.5',
    'base_url': '',
    'reasoning_effort': null,
  },
];

http.Response _json(Object data, [int status = 200]) => http.Response(
  jsonEncode(data),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// The schema the Models page reads to learn the config's fallback shape:
/// the same recorded contract the app's own tests use.
Map<String, dynamic>? _configSchema() {
  final file = File('test/fixtures/fallback_config_contract.json');
  if (!file.existsSync()) return null;
  final contract = jsonDecode(file.readAsStringSync());
  final schema = contract is Map ? contract['current_schema'] : null;
  return schema is Map ? Map<String, dynamic>.from(schema) : null;
}

http.Client _demoHttp(DemoLook look) => MockClient((request) async {
  final path = request.url.path;
  if (path.endsWith('/openapi.json')) {
    final schema = _configSchema();
    return schema == null ? _json({'detail': 'not found'}, 404) : _json(schema);
  }
  if (path.endsWith('/api/config')) {
    // What steps in when the default model is unavailable: the others.
    return _json({
      'fallback_providers': [
        if (look.provider == 'openai')
          {'provider': 'anthropic', 'model': 'claude-sonnet-4.5'}
        else
          {'provider': 'openai', 'model': 'gpt-5'},
        {'provider': 'google', 'model': 'gemini-2.5-pro'},
      ],
    });
  }
  if (path.endsWith('/providers/custom-endpoints')) {
    return _json({
      'current': {
        'provider': look.provider,
        'model': look.model,
        'base_url': '',
      },
      'endpoints': const <Object>[],
    });
  }
  if (path.endsWith('/model/info')) return _json(_modelInfo(look));
  if (path.endsWith('/model/auxiliary')) return _json({'tasks': _auxTasks()});
  if (path.endsWith('/model/options')) {
    return _json({
      'providers': _providers(look),
      'model': look.model,
      'provider': look.provider,
    });
  }
  return _json(const <String, Object>{});
});

/// Serves the sidebar's rows and each chat's stored transcript.
class DemoApi extends DashboardApiClient {
  DemoApi(super.dashboard, this.chats, this.now, this.look)
    : super.withDashboard();

  final List<DemoChat> chats;
  final DateTime now;
  final DemoLook look;

  @override
  Future<bool?> showSubagentSessions({String? profile}) async => false;

  @override
  Future<SessionListPage> getSessionsPage({
    int limit = 50,
    int offset = 0,
    String? title,
    String? excludeSources,
    bool Function()? maySendSearch,
    Duration timeout = ApiClient.requestTimeout,
  }) async => SessionListPage(
    sessions: offset == 0
        ? [for (final c in chats) c.row(now, look.model)]
        : const [],
    hasMore: false,
  );

  @override
  Future<Uint8List> getMessagesBytes(
    String sessionId, {
    int? limit,
    int offset = 0,
    bool latest = false,
  }) async {
    final chat = chats.where((c) => c.id == sessionId).firstOrNull;
    final rows = offset == 0 && chat != null
        ? [for (final turn in chat.turns) ...turn]
        : const <Map<String, dynamic>>[];
    return utf8.encode(jsonEncode({'messages': rows}));
  }

  @override
  Future<void> setSessionUnread(String sessionId, {required bool unread}) =>
      Future.value();
}

/// A connected gateway that answers from [chats]. Live events and requests
/// are fed through [emit] and the resume snapshot, the way a socket would.
class DemoGateway extends NextGenGateway {
  DemoGateway(this.chats, DateTime now, this.look)
    : super(
        demoConnection(),
        dashboard: DashboardClient.fromConnection(
          demoConnection(),
          httpClient: _demoHttp(look),
        ),
      ) {
    api = DemoApi(dashboard, chats, now, look);
    _socket.onServerRequest = (request) {
      openRequests[request.id] = NgServerRequest(request);
      _requests.add(openRequests[request.id]!);
      notifyListeners();
      return true;
    };
  }

  final List<DemoChat> chats;
  final DemoLook look;
  final WsClient _socket = WsClient('https://gateway.example.com');
  final _liveEvents = StreamController<StreamEvent>.broadcast();
  final _requests = StreamController<NgServerRequest>.broadcast();

  @override
  WsClient? get socket => _socket;

  @override
  NgConnectionState get state =>
      const NgConnectionState(NgConnectionPhase.connected);

  @override
  Stream<StreamEvent> get events => _liveEvents.stream;

  @override
  Stream<NgServerRequest> get serverRequests => _requests.stream;

  @override
  Future<WsClient> connected({
    Duration timeout = const Duration(seconds: 20),
  }) async => _socket;

  /// Feeds one live event for [chat], as its socket would.
  void emit(DemoChat chat, String type, Map<String, dynamic> data) =>
      _liveEvents.add(StreamEvent(type: type, data: data, sessionId: chat.id));

  DemoChat? _chat(Object? id) => chats
      .where((c) => c.id == id || c.runtimeId == id)
      .cast<DemoChat?>()
      .firstOrNull;

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final chat = _chat(params['session_id']);
    switch (method) {
      case 'session.resume':
        if (chat == null) return const {};
        return {
          'session_id': chat.runtimeId,
          'running': chat.running,
          'info': {
            'model': look.model,
            'provider': look.provider,
            'reasoning_effort': look.effort ?? '',
            'title': chat.title,
          },
          if (chat.todos != null)
            'todo_state': {'revision': 4, 'todos': chat.todos},
          if (chat.approval != null) 'open_requests': [chat.approval],
        };
      case 'commands.catalog':
        return demoCatalog();
      case 'complete.slash':
        // Answer from the catalogue, as an older gateway makes the app do.
        throw JsonRpcError(method, 'Method not found', code: -32601);
      case 'projects.list':
        return {
          'projects': [
            for (final (id, name, path, _) in _projects.take(look.projects))
              {
                'id': id,
                'slug': id.substring(2),
                'name': name,
                'primary_path': path,
                'folders': const <Object>[],
              },
          ],
        };
      case 'projects.tree':
        return {
          'projects': [
            for (final (id, name, _, count) in _projects.take(look.projects))
              {'id': id, 'label': name, 'sessionCount': count},
          ],
        };
    }
    return const {};
  }

  @override
  void dispose() {
    _liveEvents.close();
    _requests.close();
    _socket.close();
    super.dispose();
  }
}

/// The same gateway as a Classic (API key) connection.
SavedConnection classicConnection() => SavedConnection(
  id: 'classic-demo',
  label: 'My gateway',
  host: 'gateway.example.com',
  port: 8642,
  apiKey: 'sample',
);

/// The Classic chat's REST client: each chat's stored transcript, and an
/// empty answer for everything else the screen asks while it opens.
ApiClient classicApi(List<DemoChat> chats) => ApiClient(
  baseUrl: 'https://gateway.example.com',
  apiKey: 'sample',
  httpClient: MockClient((request) async {
    final segments = request.url.pathSegments;
    if (segments.isNotEmpty && segments.last == 'messages') {
      final chat = chats.where((c) => segments.contains(c.id)).firstOrNull;
      return _json({
        'data': [
          if (chat != null)
            for (final turn in chat.turns)
              for (final row in turn)
                {...row, if (row['role'] == 'assistant') 'completed': true},
        ],
      });
    }
    return _json(const <String, Object>{});
  }),
);
