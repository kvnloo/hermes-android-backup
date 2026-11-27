"""Validate the JSON-RPC requests Ares sends on a session-authority (Hermes
0.23+) socket against the gateway's own wire contracts.

Runs offline against an extracted Hermes tree, never an installed one:

    R=~/.hermes/hermes-agent PIN=b7ee21c14e TREE=$(mktemp -d)
    git -C $R archive $PIN $(git -C $R ls-tree --name-only $PIN | grep -E '\\.py$') \\
        acp_adapter agent cron gateway hermes_cli hermes_platform persistence plugins \\
        providers session_rules tools tui_gateway utils locales | tar -x -C $TREE
    $R/venv/bin/python -I tool/canonical_wire_check.py $TREE build/canonical-wire/*.json

(`-I` keeps the interpreter isolated; the tree is the only import root added.
The interpreter needs pydantic, which the Hermes venv has.)

For every captured frame it replays what `tui_gateway/ws.py::_dispatch_request`
and `gateway/session_controls.py::AuthorityConnection.dispatch` do, using the
tree's own tables and models:

1. `profile` naming the socket's own home is dropped for the verbs in
   `_PROFILE_IMPLICIT`.
2. A verb in `CANONICAL_METHODS` is checked with the dispatcher's own
   `canonical_param_problems` (`4001 invalid_params`, with the fields).
3. The route: an authority handler, a group control, or `-32601`; a `-32601`
   falls back to the legacy sidecar only where `legacy_fallback_allowed` says
   so, and the sidecar refuses unknown keys with `4000` (`validate_params`).
4. The handler's own closed key set (the hand-written `set(params) - {...}`
   checks), quoted from the tree: each rule names its file and the exact source
   text it was read from, and the run stops if that text is no longer there.
5. `session.mutate` payloads go through the store's `parse_mutation`.
6. The declared pydantic model is validated in full (types, required keys):
   the same check `check_params_accepted` logs as a contract violation.

`--emit-dart FILE` writes the closed key sets as a Dart table for the strict
test gateway (test/support/strict_authority_gateway.dart), so the fakes refuse
what the real gateway refuses.

Exit status: 0 when every captured frame is accepted, 1 otherwise, 2 on usage
or an unreadable tree.
"""
import argparse
import json
import os
import sys
import typing


def _load(tree):
    sys.path.insert(0, tree)
    import tui_gateway.contracts  # noqa: F401  (fills the registry)
    from tui_gateway.contracts import registry
    from gateway import session_controls
    from gateway.session_connections import METHODS as connection_methods, session_owned
    from gateway.session_group_controls import GROUP_METHODS
    from tui_gateway import ws_legacy_fallback as fallback
    from gateway import session_control_actions
    from persistence.authority.runtime import parse_mutation
    from persistence.core.errors import AuthorityRefusal

    connection = object.__new__(session_controls.AuthorityConnection)
    handlers = frozenset(session_controls.AuthorityConnection.handlers(connection))
    return {
        'registry': registry,
        'handlers': handlers,
        'groups': frozenset(GROUP_METHODS),
        'connections': frozenset(connection_methods),
        'session_owned': session_owned,
        'profile_implicit': frozenset(session_controls._PROFILE_IMPLICIT),
        'fallback': fallback,
        'parse_mutation': parse_mutation,
        'validate_control': session_control_actions._validate,
        'control_actions': frozenset(session_control_actions._ACTION_COMMANDS)
        | frozenset(session_control_actions._SUBGOAL_ACTIONS),
        'refusal': AuthorityRefusal,
    }


# The authority handlers' own closed key sets. `anchor` is the source text the
# rule was read from; `keys` the keys it allows; `required` the ones the same
# check (or the lines right after it) demands; `strings` marks handlers that
# refuse any non-string value.
_ANCILLARY = 'gateway/session_ancillary.py'
_TUI_OPS = 'gateway/session_tui_ops.py'
_HANDOFF = 'gateway/session_handoff.py'
_BUSY = 'gateway/session_busy_controls.py'
_CONTROLS = 'gateway/session_controls.py'
_READ_ANCHOR = "fields = {'session_id', 'profile'} | ({'subagent_id'} if kind == 'tail' else set())"
_APPROVAL_ANCHOR = "fields = {'session_id', 'profile'} | ({'request_id'} if ack else set())"
_SUBAGENT_ANCHOR = "fields = {'session_id', 'profile', 'subagent_id'} | ({'text'} if steer else set())"
_SESSION_ONLY_ANCHOR = "if set(params) - {'session_id', 'profile'} or not isinstance(ref.session_id, str) or not ref.session_id:"
_ROLLBACK_ANCHOR = "_ROLLBACK_FIELDS = {'list': {'session_id', 'profile', 'undo_since', 'undo_message_id'}, 'diff': {'session_id', 'profile', 'hash'},"
_ROLLBACK_ANCHOR_2 = "'restore': {'session_id', 'profile', 'hash', 'file_path', 'all'},"
_DISCOVERY_ANCHOR = "allowed = {'profile', 'text', 'session_id'} if completion else {'profile', 'session_id'}"
_COMMAND_ANCHOR = "allowed = {'session_id', 'profile', 'name', 'arg'} if dispatch else {'session_id', 'profile', 'command'}"
_SIDE_ANCHOR = "if (set(params) - {'session_id', 'profile', required, *optional} or not isinstance(ref.session_id, str)"
_CORRECT_ANCHOR = "if (set(params) - {'session_id', 'profile', 'text', 'execution_generation'}"


def _rule(path, anchor, keys, required=('session_id',), strings=False, exact=False):
    return {'file': path, 'anchor': anchor, 'keys': frozenset(keys), 'required': frozenset(required),
            'strings': strings, 'exact': exact}


HANDLER_RULES = {
    'session.control.read': _rule(_ANCILLARY, _READ_ANCHOR, {'session_id', 'profile'}),
    'process.list': _rule(_ANCILLARY, _READ_ANCHOR, {'session_id', 'profile'}),
    'subagent.list': _rule(_ANCILLARY, _READ_ANCHOR, {'session_id', 'profile'}),
    'subagent.tail': _rule(_ANCILLARY, _READ_ANCHOR, {'session_id', 'profile', 'subagent_id'},
                           ('session_id', 'subagent_id')),
    'approval.pending': _rule(_ANCILLARY, _APPROVAL_ANCHOR, {'session_id', 'profile'}),
    'approval.received': _rule(_ANCILLARY, _APPROVAL_ANCHOR, {'session_id', 'profile', 'request_id'},
                               ('session_id', 'request_id')),
    'subagent.steer': _rule(_ANCILLARY, _SUBAGENT_ANCHOR, {'session_id', 'profile', 'subagent_id', 'text'},
                            ('session_id', 'subagent_id', 'text')),
    'subagent.interrupt': _rule(_ANCILLARY, _SUBAGENT_ANCHOR, {'session_id', 'profile', 'subagent_id'},
                                ('session_id', 'subagent_id')),
    'file.attach': _rule(_ANCILLARY,
                         "if (set(params) - {'session_id', 'profile', 'path', 'data_url', 'name', 'staged_upload'} or not ref.session_id",
                         {'session_id', 'profile', 'path', 'data_url', 'name', 'staged_upload'}),
    'process.kill': _rule(_ANCILLARY, "if (set(params) - {'session_id', 'process_id', 'profile'} or not ref.session_id",
                          {'session_id', 'process_id', 'profile'}, ('session_id', 'process_id')),
    'process.stop': _rule(_ANCILLARY, _SESSION_ONLY_ANCHOR, {'session_id', 'profile'}),
    'tools.show': _rule(_ANCILLARY, _SESSION_ONLY_ANCHOR, {'session_id', 'profile'}),
    'skills.reload': _rule(_ANCILLARY, _SESSION_ONLY_ANCHOR, {'session_id', 'profile'}),
    'reload.mcp': _rule(_ANCILLARY, "if set(params) - {'session_id', 'confirm', 'rev', 'profile'}:",
                        {'session_id', 'confirm', 'rev', 'profile'}, ()),
    'prompt.background': _rule('gateway/session_tui_side.py', _SIDE_ANCHOR, {'session_id', 'profile', 'text'},
                               ('session_id', 'text')),
    'prompt.btw': _rule('gateway/session_tui_side.py', _SIDE_ANCHOR, {'session_id', 'profile', 'text'},
                        ('session_id', 'text')),
    'handoff.request': _rule(_HANDOFF, "_session(connection, ref, params, {'session_id', 'profile', 'platform'}, 'session:control')",
                             {'session_id', 'profile', 'platform'}),
    'handoff.state': _rule(_HANDOFF, "_session(connection, ref, params, {'session_id', 'profile'}, 'session:read')",
                           {'session_id', 'profile'}),
    'handoff.fail': _rule(_HANDOFF, "_session(connection, ref, params, {'session_id', 'profile', 'error'}, 'session:control')",
                          {'session_id', 'profile', 'error'}),
    'session.control': _rule('gateway/session_control_actions.py',
                             "if set(params) - {'session_id', 'profile', 'action', 'args'} or not ref.session_id:",
                             {'session_id', 'profile', 'action', 'args'}, ('session_id', 'action')),
    'session.context_breakdown': _rule('gateway/session_tui_reads.py', _SESSION_ONLY_ANCHOR, {'session_id', 'profile'}),
    'session.history': _rule(_TUI_OPS, "_live_ref(connection, ref, params, {'session_id', 'profile'}, 'session:read')",
                             {'session_id', 'profile'}),
    'session.save': _rule(_TUI_OPS, "_live_ref(connection, ref, params, {'session_id', 'profile'}, 'session:read')",
                          {'session_id', 'profile'}),
    'session.export': _rule(_TUI_OPS, "_live_ref(connection, ref, params, {'session_id', 'profile', 'format', 'redact'}, 'session:read')",
                            {'session_id', 'profile', 'format', 'redact'}),
    'rollback.list': _rule(_TUI_OPS, _ROLLBACK_ANCHOR, {'session_id', 'profile', 'undo_since', 'undo_message_id'}),
    'rollback.diff': _rule(_TUI_OPS, _ROLLBACK_ANCHOR, {'session_id', 'profile', 'hash'}, ('session_id', 'hash')),
    'rollback.restore': _rule(_TUI_OPS, _ROLLBACK_ANCHOR_2, {'session_id', 'profile', 'hash', 'file_path', 'all'},
                              ('session_id', 'hash')),
    'rollback.session_diff': _rule(_TUI_OPS, "'session_diff': {'session_id', 'profile'}}", {'session_id', 'profile'}),
    'commands.catalog': _rule('gateway/session_discovery.py', _DISCOVERY_ANCHOR, {'profile', 'session_id'}, (),
                              strings=True),
    'complete.slash': _rule('gateway/session_discovery.py', _DISCOVERY_ANCHOR, {'profile', 'text', 'session_id'}, (),
                            strings=True),
    'complete.path': _rule('gateway/session_complete_path.py', "if (set(params) - {'session_id', 'profile', 'word', 'cwd'}",
                           {'session_id', 'profile', 'word', 'cwd'}, (), strings=True),
    'slash.exec': _rule('gateway/session_commands.py', _COMMAND_ANCHOR, {'session_id', 'profile', 'command'},
                        ('command',), strings=True),
    'command.dispatch': _rule('gateway/session_commands.py', _COMMAND_ANCHOR, {'session_id', 'profile', 'name', 'arg'},
                              ('name',), strings=True),
    'session.active_list': _rule('gateway/session_active_list.py', "if set(params) - {'profile', 'current_session_id'}:",
                                 {'profile', 'current_session_id'}, ()),
    'session.steer': _rule(_BUSY, _CORRECT_ANCHOR, {'session_id', 'profile', 'text', 'execution_generation'},
                           ('session_id', 'text', 'execution_generation')),
    'session.redirect': _rule(_BUSY, _CORRECT_ANCHOR, {'session_id', 'profile', 'text', 'execution_generation'},
                              ('session_id', 'text', 'execution_generation')),
    'config.get': _rule('gateway/session_config.py', "if set(params) - {'session_id', 'profile', 'key', 'cwd'}:",
                        {'session_id', 'profile', 'key', 'cwd'}, ('key',)),
    'image.attach_bytes': _rule('gateway/session_images.py',
                                "or set(params) - {'session_id', 'profile', 'content_base64', 'data', 'filename', 'ext'}",
                                {'session_id', 'profile', 'content_base64', 'data', 'filename', 'ext'}, strings=True),
    'session.info': _rule(_CONTROLS, "if set(params) != {'session_id'}:", {'session_id'}, exact=True),
    'approval.respond': _rule(_CONTROLS, 'if set(params) != {"session_id", "execution_generation", "prompt_id", "choice"}:',
                              {'session_id', 'execution_generation', 'prompt_id', 'choice'}, exact=True),
    'clarify.respond': _rule(_CONTROLS, 'if set(params) != {"session_id", "execution_generation", "prompt_id", "answer"}:',
                             {'session_id', 'execution_generation', 'prompt_id', 'answer'}, exact=True),
    'prompt.resolve_unknown': _rule(_CONTROLS, "if set(params) != {'session_id', 'admission_id', 'execution_generation'}:",
                                    {'session_id', 'admission_id', 'execution_generation'}, exact=True),
    'session.detach': _rule(_CONTROLS, "if set(params) - {'end_reason'} != {'session_id', 'subscription_id'}:",
                            {'session_id', 'subscription_id', 'end_reason'}, ('session_id', 'subscription_id')),
    'session.list': _rule(_CONTROLS,
                          "if (set(params) - {'limit', 'title', 'include_hidden', 'scope', 'workspace', 'picker', 'query', 'cursor'}",
                          {'limit', 'title', 'include_hidden', 'scope', 'workspace', 'picker', 'query', 'cursor'}, ()),
    'prompt.submit': _rule(_CONTROLS,
                           "forbidden = set(params) - {'session_id', 'text', 'submission_id', 'input_id', 'queued', 'attachments', 'finite', 'unattended',",
                           {'session_id', 'text', 'submission_id', 'input_id', 'queued', 'attachments', 'finite',
                            'unattended', 'surface', 'voice_context', 'interrupted', 'voice_turn', 'display_kind',
                            'title_preview', 'turn_author', 'api_text', 'model_override', 'clarify_batch'},
                           ('session_id',)),
    'session.mutate': _rule('gateway/session_mutations.py', "if (set(params) - {'expected_generation'} != _FIELDS",
                            {'session_id', 'request_id', 'expected_revision', 'operation', 'payload',
                             'expected_generation'},
                            ('session_id', 'request_id', 'expected_revision', 'operation', 'payload')),
}

# `config.set` keys the owner serves (gateway/session_tui_config.py::config_set
# and gateway/session_busy_controls.py::busy_config); any other key is
# `invalid_params`. `model` is recognised only to be refused.
_CONFIG_SET_ANCHORS = (
    ('gateway/session_tui_config.py',
     "_SESSION_CONTROL_KEYS = frozenset({'busy', 'verbose', 'yolo', 'show_reasoning', 'service_tier', 'model'})"),
    ('gateway/session_tui_config.py',
     "_DISPLAY_TOGGLE_KEYS = frozenset({'display.message_reactions', 'display.in_app_tips', 'display.in_app_tours'})"),
    ('gateway/session_tui_config.py', "if set(params) - {'session_id', 'profile', 'key', 'value'}:"),
    ('gateway/session_tui_config.py', "if (set(params) - {'session_id', 'profile', 'key', 'value', 'scope'} or not ref.session_id"),
    ('gateway/session_tui_config.py', "if key in ('approvals.mode', 'approval_mode'):"),
    ('gateway/session_tui_config.py', "if key in _DISPLAY_TOGGLE_KEYS or key == 'voice.voice_chat_mode':"),
    (_BUSY, "raise AuthorityRefusal('use_session_mutation_model')"),
    (_BUSY, "or (write and params.get('value') not in ('interrupt', 'steer', 'queue'))):"),
)
CONFIG_SET_SESSION_KEYS = ('busy', 'verbose', 'yolo', 'show_reasoning', 'service_tier')
CONFIG_SET_PROFILE_KEYS = (
    'fast', 'personality', 'approvals.mode', 'approval_mode', 'voice.voice_chat_mode', 'daybreak',
    'display.message_reactions', 'display.in_app_tips', 'display.in_app_tours',
    'density', 'battery', 'timestamps', 'statusbar', 'mouse', 'theme', 'indicator', 'details_mode',
    'details_mode.thinking', 'details_mode.tools', 'details_mode.subagents', 'details_mode.activity',
    'focus', 'skin',
)
# Mutations that must name the execution generation they were decided against:
# the policy edits (gateway/session_mutations.py) and the transcript edits the
# store fences itself (persistence/sqlite/authority/_mutation.py).
_POLICY_OPERATIONS = ('model', 'reasoning', 'workspace', 'editor_mcp', 'edit_policy',
                      'delete', 'rewind', 'reset', 'branch', 'compress')
_POLICY_ANCHORS = (
    ('gateway/session_mutations.py',
     "_POLICY = frozenset({'model', 'reasoning', 'workspace', 'editor_mcp', 'edit_policy'})"),
    ('persistence/sqlite/authority/_mutation.py',
     "if operation in {'delete', 'rewind', 'reset', 'branch', 'model', 'compress'} and expected_generation is None:"),
)


def _check_anchors(tree):
    """Every quoted rule must still be in the tree it is applied to."""
    wanted = {}
    for rule in HANDLER_RULES.values():
        wanted.setdefault(rule['file'], set()).add(rule['anchor'])
    for path, anchor in (*_CONFIG_SET_ANCHORS, *_POLICY_ANCHORS):
        wanted.setdefault(path, set()).add(anchor)
    drifted = []
    for path, anchors in sorted(wanted.items()):
        try:
            with open(os.path.join(tree, path), encoding='utf-8') as fh:
                text = fh.read()
        except OSError as exc:
            drifted.append(f'{path}: {exc}')
            continue
        drifted.extend(f'{path}: missing {anchor!r}' for anchor in sorted(anchors) if anchor not in text)
    return drifted


def _config_set_problem(params):
    key = params.get('key')
    if key == 'model':
        return 'use_session_mutation_model'
    if key == 'reasoning' or (key == 'yolo' and 'scope' in params):
        if set(params) - {'session_id', 'profile', 'key', 'value', 'scope'} or not params.get('session_id'):
            return 'invalid_params (reasoning/yolo: keys or missing session_id)'
        scope = params.get('scope', 'session')
        if scope not in ('session', 'global'):
            return 'invalid_params (scope)'
        if key == 'yolo' and scope != 'global':
            return 'invalid_params (yolo scope must be global)'
        if key == 'reasoning' and not str(params.get('value') or '').strip():
            return 'invalid_params (reasoning needs a value)'
        return None
    if set(params) - {'session_id', 'profile', 'key', 'value'}:
        return f"invalid_params (keys: {sorted(set(params) - {'session_id', 'profile', 'key', 'value'})})"
    if key in CONFIG_SET_SESSION_KEYS:
        if not params.get('session_id'):
            return f'invalid_params ({key} needs session_id)'
        if key == 'busy' and params.get('value') not in ('interrupt', 'steer', 'queue'):
            return 'invalid_params (busy value)'
        return None
    if key not in CONFIG_SET_PROFILE_KEYS:
        return f'invalid_params (config key {key!r} is not served by the owner)'
    return None


def _handler_problem(rule, params):
    keys = set(params)
    if rule['exact']:
        return None if keys == rule['keys'] else f"invalid_params (keys must be exactly {sorted(rule['keys'])})"
    extra = sorted(keys - rule['keys'])
    if extra:
        return f'invalid_params (unknown keys {extra})'
    missing = sorted(key for key in rule['required'] if params.get(key) in (None, ''))
    if missing:
        return f'invalid_params (missing {missing})'
    if rule['strings']:
        bad = sorted(key for key, value in params.items() if not isinstance(value, str))
        if bad:
            return f'invalid_params (non-string {bad})'
    return None


def _model_errors(contract, params):
    from pydantic import ValidationError
    try:
        contract.params.model_validate(params)
    except ValidationError as exc:
        return ['.'.join(str(part) for part in err.get('loc', ())) + ': ' + str(err.get('type')) for err in exc.errors()]
    return []


def check(ctx, method, params):
    """The verdict the pinned gateway gives one request on an authority socket."""
    registry = ctx['registry']
    out = {'method': method, 'route': None, 'contract': None, 'ok': False, 'verdict': None, 'problems': []}
    if method == 'gateway.ping':
        out.update(route='frame (tui_gateway/ws.py read loop)', ok=True, verdict='accepted')
        return out
    if not isinstance(params, dict):
        out.update(verdict='4001 invalid_params', problems=['params is not an object'])
        return out
    params = dict(params)
    profile = params.get('profile')
    if isinstance(profile, str) and profile and method in ctx['profile_implicit']:
        params.pop('profile')
    canonical = registry.CANONICAL_METHODS.get(method)
    legacy = registry.METHODS.get(method)
    if canonical is not None:
        out['contract'] = f'CANONICAL_METHODS[{method}] = {canonical.params.__name__}'
        problems = registry.canonical_param_problems(canonical, params)
        if problems:
            out.update(route='authority', verdict='4001 invalid_params', problems=problems)
            return out
    if method in ctx['groups'] or method == 'profiles.list':
        route = 'authority (group control)'
    elif method not in ctx['handlers'] or (method in ctx['connections'] and not ctx['session_owned'](params)):
        fallback = ctx['fallback']
        allowed = (legacy is not None and method not in fallback._PROCESS_GLOBAL
                   and not (method.startswith(fallback._SESSION_NAMESPACES)
                            and method not in fallback._SESSION_FALLBACK_ALLOWED))
        if not allowed:
            out.update(route='authority', verdict='-32601 unknown method',
                       problems=[registry.unknown_method_message(method)])
            return out
        out.update(route='legacy sidecar (authority answered -32601)',
                   contract=f'METHODS[{method}] = {legacy.params.__name__}')
        _, problem = registry.validate_params(legacy, params)
        if problem is not None:
            out.update(verdict='4000 invalid params', problems=[problem.split(' — ')[0]])
            return out
        errors = _model_errors(legacy, params)
        if errors:
            out.update(verdict='contract violation', problems=errors)
            return out
        out.update(ok=True, verdict='accepted')
        return out
    else:
        route = 'authority'
    out['route'] = route
    contract = canonical or legacy
    if contract is not None and out['contract'] is None:
        out['contract'] = f'METHODS[{method}] = {contract.params.__name__}'
    rule = HANDLER_RULES.get(method)
    if rule is not None:
        problem = _handler_problem(rule, params)
        if problem is not None:
            out.update(verdict='4001 ' + problem.split(' ')[0], problems=[f"{rule['file']}: {problem}"])
            return out
    if method == 'config.set':
        problem = _config_set_problem(params)
        if problem is not None:
            out.update(verdict='4001 ' + problem.split(' ')[0], problems=[problem])
            return out
    if method == 'session.mutate':
        operation = params.get('operation')
        if operation in _POLICY_OPERATIONS and params.get('expected_generation') is None:
            out.update(verdict='4001 invalid_params', problems=[f'{operation} needs expected_generation'])
            return out
        try:
            ctx['parse_mutation'](operation, params.get('payload'))
        except ctx['refusal'] as exc:
            out.update(verdict=f'4001 {exc.reason}',
                       problems=[f'parse_mutation refused {operation!r} payload {params.get("payload")!r}'])
            return out
    if method == 'session.control':
        action, args = params.get('action'), params.get('args')
        try:
            if not isinstance(action, str):
                raise ctx['refusal']('invalid_params')
            ctx['validate_control'](action.strip(), {} if args is None else args)
        except ctx['refusal'] as exc:
            out.update(verdict=f'4001 {exc.reason}',
                       problems=[f'session_control_actions._validate refused {action!r} args {args!r}'])
            return out
    if method == 'prompt.submit' and not (params.get('submission_id') or params.get('input_id')):
        out.update(verdict='4001 invalid_params', problems=['prompt.submit needs submission_id or input_id'])
        return out
    if contract is not None:
        errors = _model_errors(contract, params)
        if errors:
            out.update(verdict='contract violation', problems=errors)
            return out
    out.update(ok=True, verdict='accepted')
    return out


def _captures(paths):
    """Rows of the capture files: a JSON document with `captures`, or (a suite's tap) one JSON
    object per line, whose producer is the file's name."""
    for path in paths:
        with open(path, encoding='utf-8') as fh:
            if path.endswith('.jsonl'):
                stem = os.path.basename(path)[:-len('.jsonl')]
                rows = [{'layout': 'shared', 'producer': f'suite {stem}', **json.loads(line)}
                        for line in fh if line.strip()]
            else:
                data = json.load(fh)
                rows = data.get('captures') if isinstance(data, dict) else data
        for index, row in enumerate(rows or ()):
            yield path, index, row


def _type_tag(annotation):
    """A coarse top-level type for the Dart table: enough to refuse a string where an int travels."""
    origin = typing.get_origin(annotation)
    args = typing.get_args(annotation)
    if annotation is typing.Any:
        return 'any'
    if origin is typing.Literal:
        return 'enum:' + '|'.join(str(arg) for arg in args)
    if origin in (typing.Union, getattr(__import__('types'), 'UnionType')):
        tags = [_type_tag(arg) for arg in args if arg is not type(None)]
        if len(tags) == 1:
            return tags[0] + '?'
        if all(tag in ('int', 'num', 'str') for tag in tags):
            return 'any?'
        return 'any?'
    if origin is typing.Annotated:
        return _type_tag(args[0])
    if annotation is bool:
        return 'bool'
    if annotation is int:
        return 'int'
    if annotation is float:
        return 'num'
    if annotation is str:
        return 'str'
    if origin in (list, tuple) or annotation in (list, tuple):
        return 'list'
    if origin is dict or annotation is dict:
        return 'map'
    if isinstance(annotation, type):
        try:
            from pydantic import BaseModel
            if issubclass(annotation, BaseModel):
                return 'map'
        except ImportError:  # pragma: no cover
            pass
    return 'any'


def _dart_string(value):
    return "'" + str(value).replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$') + "'"


def _dart_set(values):
    return '{' + ', '.join(_dart_string(value) for value in sorted(values)) + '}'


def emit_dart(ctx, pin):
    registry, fallback = ctx['registry'], ctx['fallback']
    names = sorted(set(registry.METHODS) | set(registry.CANONICAL_METHODS) | ctx['handlers'] | ctx['groups'])
    lines = [
        '// GENERATED by tool/canonical_wire_check.py --emit-dart. Do not edit.',
        f'// Source: Hermes {pin} (tui_gateway/contracts, gateway/session_controls.py,',
        '// tui_gateway/ws_legacy_fallback.py and the authority handlers its rules quote).',
        '//',
        '// What a session-authority (Hermes 0.23+) socket does with each method: the',
        '// route it takes and the closed key set that route enforces.',
        '// ignore_for_file: lines_longer_than_80_chars',
        '',
        '/// Where `AuthorityConnection.dispatch` sends a method.',
        'enum WireRoute {',
        '  /// An authority handler (`4001` refusals).',
        '  authority,',
        '',
        '  /// A group control (`groups.*`, `profiles.list`), on the authority.',
        '  group,',
        '',
        '  /// The authority answers `-32601`; the legacy sidecar serves it and',
        '  /// refuses unknown keys with `4000`.',
        '  legacy,',
        '',
        '  /// `-32601` on an authority socket: neither side serves it there.',
        '  unknown,',
        '}',
        '',
        'class WireContract {',
        '  const WireContract(',
        '    this.route, {',
        '    this.canonical = false,',
        '    this.shared = false,',
        '    this.profileImplicit = false,',
        '    this.sessionOwnedOnly = false,',
        '    this.exact = false,',
        '    this.strings = false,',
        '    this.keys = const {},',
        '    this.required = const {},',
        '    this.types = const {},',
        '    this.legacyKeys,',
        '  });',
        '',
        '  final WireRoute route;',
        '',
        '  /// Declared in `CANONICAL_METHODS`: the dispatcher refuses unknown and',
        '  /// missing keys itself, naming them in `data.fields`.',
        '  final bool canonical;',
        '',
        '  /// Also declared in `METHODS`: the dispatcher refuses mistyped values',
        '  /// too, and leaves missing keys to the handler.',
        '  final bool shared;',
        '',
        '  /// `profile` naming the socket\'s own home is dropped before the check.',
        '  final bool profileImplicit;',
        '',
        '  /// Served by the authority only for `owner.type == session`; any other',
        '  /// owner is the legacy sidecar\'s.',
        '  final bool sessionOwnedOnly;',
        '',
        '  /// The handler demands exactly [keys], no fewer.',
        '  final bool exact;',
        '',
        '  /// The handler refuses any non-string value.',
        '  final bool strings;',
        '  final Set<String> keys;',
        '  final Set<String> required;',
        '',
        '  /// Top-level value types: str, int, num, bool, list, map, any, or',
        '  /// `enum:a|b`; a trailing `?` allows null.',
        '  final Map<String, String> types;',
        '',
        '  /// The legacy sidecar\'s key set, for a method the authority hands back.',
        '  final Set<String>? legacyKeys;',
        '}',
        '',
        f"const canonicalWirePin = {_dart_string(pin)};",
        '',
        f'const configSetSessionKeys = {_dart_set(CONFIG_SET_SESSION_KEYS)};',
        f'const configSetProfileKeys = {_dart_set(CONFIG_SET_PROFILE_KEYS)};',
        f'const mutationPolicyOperations = {_dart_set(_POLICY_OPERATIONS)};',
        f"const sessionControlActions = {_dart_set(ctx['control_actions'])};",
        '',
        'const canonicalWireContracts = <String, WireContract>{',
    ]
    for name in names:
        canonical = registry.CANONICAL_METHODS.get(name)
        legacy = registry.METHODS.get(name)
        rule = HANDLER_RULES.get(name)
        on_authority = name in ctx['handlers']
        if name in ctx['groups'] or name == 'profiles.list':
            route = 'group'
        elif on_authority:
            route = 'authority'
        elif (legacy is not None and name not in fallback._PROCESS_GLOBAL
              and not (name.startswith(fallback._SESSION_NAMESPACES)
                       and name not in fallback._SESSION_FALLBACK_ALLOWED)):
            route = 'legacy'
        else:
            route = 'unknown'
        model = (canonical or legacy).params if (canonical or legacy) is not None else None
        fields = model.model_fields if model is not None else {}
        keys = set(rule['keys']) if rule is not None else set(fields)
        if canonical is not None and rule is not None:
            keys &= set(fields) | ({'profile'} if name in ctx['profile_implicit'] else set())
        required = set(rule['required']) if rule is not None else set()
        if canonical is not None:
            required |= {key for key, field in fields.items() if field.is_required()}
        types = {key: _type_tag(field.annotation) for key, field in sorted(fields.items())}
        args = [f'WireRoute.{route}']
        if canonical is not None:
            args.append('canonical: true')
        if canonical is not None and legacy is not None:
            args.append('shared: true')
        if name in ctx['profile_implicit']:
            args.append('profileImplicit: true')
        if name in ctx['connections']:
            args.append('sessionOwnedOnly: true')
        if rule is not None and rule['exact']:
            args.append('exact: true')
        if rule is not None and rule['strings']:
            args.append('strings: true')
        if route != 'unknown':
            args.append(f'keys: {_dart_set(keys)}')
            if required:
                args.append(f'required: {_dart_set(required)}')
            if types:
                args.append('types: {' + ', '.join(
                    f'{_dart_string(key)}: {_dart_string(tag)}' for key, tag in types.items()) + '}')
        if name in ctx['connections'] and legacy is not None:
            args.append(f'legacyKeys: {_dart_set(legacy.params.model_fields)}')
        lines.append(f'  {_dart_string(name)}: WireContract(' + ', '.join(args) + '),')
    lines += ['};', '']
    return '\n'.join(lines)


def main(argv):
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('tree', help='extracted Hermes tree (git archive of the pinned commit)')
    parser.add_argument('captures', nargs='*', help='capture JSON files written by the Dart harness')
    parser.add_argument('--emit-dart', metavar='FILE', help='write the strict fake\'s contract table')
    parser.add_argument('--pin', default='b7ee21c14e', help='commit label written into generated output')
    parser.add_argument('--json', metavar='FILE', help='write every verdict as JSON')
    parser.add_argument('--markdown', metavar='FILE', help='write the per-method result table')
    args = parser.parse_args(argv)
    if not os.path.isdir(os.path.join(args.tree, 'tui_gateway', 'contracts')):
        print(f'{args.tree}: not an extracted Hermes tree (no tui_gateway/contracts)', file=sys.stderr)
        return 2
    drifted = _check_anchors(args.tree)
    if drifted:
        print('the tree does not match the handler rules this tool quotes:', file=sys.stderr)
        for line in drifted:
            print('  ' + line, file=sys.stderr)
        return 2
    ctx = _load(args.tree)
    if args.emit_dart:
        with open(args.emit_dart, 'w', encoding='utf-8') as fh:
            fh.write(emit_dart(ctx, args.pin))
    verdicts, parity = [], []
    for path, index, row in _captures(args.captures):
        if row.get('refused_before_wire'):
            verdicts.append({'file': os.path.basename(path), 'index': index, **{
                key: row.get(key) for key in ('id', 'layout', 'producer', 'method', 'socket')},
                'route': 'not sent', 'contract': None, 'ok': True,
                'verdict': 'refused before the wire', 'problems': [row.get('message') or '']})
            continue
        verdict = check(ctx, row.get('method'), row.get('params'))
        fake = row.get('strict_fake')
        if (fake in ('accepted', 'refused') and (fake == 'accepted') != verdict['ok']
                and verdict['verdict'] != 'contract violation'):
            # The Dart strict fake and the gateway disagree: the fake is what the suites trust. It
            # models routes, key sets and top-level types; a value constraint (a pattern, a nested
            # model) is this tool's own check and fails the frame without being a disagreement.
            parity.append(f"{row.get('producer') or row.get('id')}: {row.get('method')} "
                          f"{json.dumps(row.get('params'), sort_keys=True)}: strict fake {fake}, "
                          f"gateway {verdict['verdict']} {verdict['problems']}")
        verdicts.append({'file': os.path.basename(path), 'index': index, **{
            key: row.get(key) for key in ('id', 'layout', 'producer', 'socket')}, **verdict,
            'params': row.get('params'), 'strict_fake': fake, 'expect': row.get('expect')})
    by_method = {}
    for verdict in verdicts:
        entry = by_method.setdefault(verdict['method'], {'pass': 0, 'fail': 0, 'refused': 0, 'expected': 0,
                                                         'routes': set(), 'problems': []})
        if verdict['verdict'] == 'refused before the wire':
            entry['refused'] += 1
        elif verdict.get('expect') == 'refused':
            # A deliberately wrong frame (the strict fake's own corpus): the gateway must refuse it.
            if verdict['ok']:
                entry['fail'] += 1
                entry['problems'].append(f"{verdict.get('id') or verdict.get('producer')}: the gateway accepts "
                                         f"a frame the corpus expects it to refuse")
            else:
                entry['expected'] += 1
        elif verdict['ok']:
            entry['pass'] += 1
        else:
            entry['fail'] += 1
            entry['problems'].append(f"{verdict.get('id') or verdict.get('producer')}: {verdict['verdict']} "
                                     f"{verdict['problems']}")
        if verdict['route']:
            entry['routes'].add(verdict['route'])
    failed = sum(entry['fail'] for entry in by_method.values())
    if args.json:
        with open(args.json, 'w', encoding='utf-8') as fh:
            json.dump({'pin': args.pin, 'verdicts': verdicts}, fh, indent=1, default=sorted)
            fh.write('\n')
    table = ['| Method | Route | Frames | Result |', '| --- | --- | --- | --- |']
    for method in sorted(by_method):
        entry = by_method[method]
        result = 'FAIL' if entry['fail'] else 'pass'
        counts = f"{entry['pass']} accepted"
        if entry['refused']:
            counts += f", {entry['refused']} refused before the wire"
        if entry['expected']:
            counts += f", {entry['expected']} refused as the corpus expects"
        if entry['fail']:
            counts += f", {entry['fail']} rejected"
        table.append(f"| `{method}` | {'; '.join(sorted(entry['routes']))} | {counts} | {result} |")
    if args.markdown:
        with open(args.markdown, 'w', encoding='utf-8') as fh:
            fh.write('\n'.join(table) + '\n')
    for method in sorted(by_method):
        entry = by_method[method]
        status = 'FAIL' if entry['fail'] else 'pass'
        print(f"{status}  {method}  accepted={entry['pass']} refused_before_wire={entry['refused']} "
              f"rejected={entry['fail']}" + (f" corpus_refusals={entry['expected']}" if entry['expected'] else ''))
        for problem in entry['problems']:
            print('      ' + problem)
    for line in parity:
        print('PARITY  ' + line)
    print(f"{len(verdicts)} frames, {len(by_method)} methods, {failed} rejected, "
          f"{len(parity)} strict-fake disagreements (pin {args.pin})")
    return 1 if failed or parity else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
