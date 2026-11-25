"""Capture the canonical gateway's replay/control wire shapes in memory.

Run with the backend interpreter, bytecode writes off:
  python -B tools/capture_canonical_replay_fixture.py BACKEND_ROOT
Writes test/fixtures/canonical_replay_contract.json.

Every frame, replay reply and refusal below comes from the backend's own code:
``gateway.session_events.SessionEvents`` (per-session replay epoch, sequence
stamping, ring eviction, the overflow ``session.replay_gap`` notice),
``AuthorityConnection.events_since`` (the canonical ``session.events.since``
handler), ``SessionAuthority.interrupt`` / ``session_busy_controls.correct``
(the canonical Stop/Steer generation fences), ``completion_payload`` (the
canonical ``message.complete`` payload) and the legacy ``tui_gateway``
dispatcher (``server.handle_request``, which rejects unknown params). Only the
owner's persistence is stubbed (a fixed ``SessionHandle``) and resume
snapshots are assembled from a real ``SessionEvents.watermark()`` and
validated against the backend's ``CanonicalSnapshot`` result model. No
service is started, no socket is opened (an audit hook refuses connects) and
no credential or user state is read: HERMES_HOME is a disposable directory.
"""
import asyncio
from dataclasses import asdict
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
from types import MethodType, SimpleNamespace

backend = Path(sys.argv[1]).resolve()
out = Path("test/fixtures/canonical_replay_contract.json")

with tempfile.TemporaryDirectory(prefix="canonical-replay-", dir=os.environ["TMPDIR"]) as home:
    os.environ["HERMES_HOME"] = home
    os.environ["HERMES_DISABLE_LAZY_INSTALLS"] = "1"
    sys.path.insert(0, str(backend))

    def guard(event, args):
        if event in {"socket.connect", "socket.getaddrinfo"}:
            raise RuntimeError("Contract capture must not contact any server")
    sys.addaudithook(guard)

    from gateway.session_authority import SessionAuthority
    from gateway.session_busy_controls import correct
    from gateway.session_contract import AdmissionReceipt, PendingAdmission, SessionHandle, SessionRef
    from gateway.session_controls import AuthorityConnection, _refusal_data
    from gateway.session_events import SessionEvents
    from gateway.session_settlement_recovery import completion_payload
    from persistence.core.errors import AuthorityRefusal
    from tui_gateway import event_replay, server as legacy_server
    from tui_gateway.contracts.canonical_sessions import (
        CanonicalCorrectionResult, CanonicalEventsResult, CanonicalPendingAdmission, CanonicalSessionHandle,
        CanonicalSnapshot,
    )
    from tui_gateway.contracts.canonical import AdmissionStatus
    from tui_gateway.contracts.registry import CANONICAL_METHODS, canonical_param_problems

    SID = "local-0123456789abcdef"
    PROFILE = "default"
    AUTHORITY_EPOCH = 7
    ref = SessionRef(PROFILE, SID)

    def stream(generation, admission):
        events = SessionEvents()
        frames = []
        # A synchronous observer receives exactly the frame fanout writes to a viewer's socket.
        events.observers.add(lambda frame: frames.append(json.loads(json.dumps(frame))))
        events.execution = {"authority_epoch": AUTHORITY_EPOCH, "execution_generation": generation,
                            "admission_id": admission}
        return events, frames

    def publish(events, event_type, payload):
        events.publish(SID, payload, event_type=event_type)

    def complete(events, admission, text):
        publish(events, "message.complete", completion_payload(
            {"admission_id": admission}, {"outcome": "completed"}, text, {}))

    def since(events, params):
        # The real canonical handler; only its connection bookkeeping is a namespace.
        connection = SimpleNamespace(
            actor=None, subscriptions={}, handed_back=set(), reconnects=set(), replay_cursors={},
            authority=SimpleNamespace(authorize=lambda *_: None,
                                      sessions={SID: SimpleNamespace(event_stream=events)}))
        reply = asyncio.run(AuthorityConnection.events_since(connection, ref, {"session_id": SID, **params}))
        CanonicalEventsResult.model_validate(reply)
        return reply

    def snapshot(events, *, running, generation, revision=1):
        epoch, sequence = events.watermark()
        body = {"session_id": SID, "stored_session_id": SID, "messages": [], "messages_omitted": True,
                "message_count": 2, "running": running, "authority_epoch": AUTHORITY_EPOCH,
                "replay_epoch": epoch, "last_sequence": sequence, "subscription_id": "sub-fixture",
                "revision": revision, "execution_generation": generation, "pending": [], "prompts": [],
                "info": {"desktop_protocol": "hermes-gateway-v1", "model": "fixture-model"},
                "pending_connection": None, "todo_state": None, "open_requests": []}
        CanonicalSnapshot.model_validate(body)
        return body

    process_epoch = event_replay.replay_epoch()
    ready = {"jsonrpc": "2.0", "method": "event", "params": {"type": "gateway.ready", "payload": {
        "change_events": True, "heartbeat": True, "replay_epoch": process_epoch, "session_authority": True}}}

    # A turn (generation 3) followed by the next claim (generation 4) on one stream.
    turn, turn_frames = stream(3, "adm-a")
    publish(turn, "message.start", {})
    publish(turn, "message.delta", {"text": "Autumn "})
    turn_snapshot_running = snapshot(turn, running=True, generation=3)
    publish(turn, "message.delta", {"text": "moon "})
    publish(turn, "message.delta", {"text": "rises"})
    complete(turn, "adm-a", "Autumn moon rises")
    turn_since_after_2 = since(turn, {"replay_epoch": turn.epoch, "last_sequence": 2})
    turn_since_no_epoch = since(turn, {"last_seen": 2})
    turn_since_process_epoch = since(turn, {"replay_epoch": process_epoch, "last_sequence": 2})
    turn_snapshot_complete = snapshot(turn, running=False, generation=3)
    turn.execution = {"authority_epoch": AUTHORITY_EPOCH, "execution_generation": 4, "admission_id": "adm-b"}
    publish(turn, "message.start", {})
    turn_snapshot_next = snapshot(turn, running=True, generation=4)
    assert turn.epoch != process_epoch

    # Gateway restart: a new SessionEvents lifetime for the same public session.
    restarted, restarted_frames = stream(5, "adm-c")
    publish(restarted, "message.start", {})
    publish(restarted, "message.delta", {"text": "After "})
    restart_since_old = since(restarted, {"replay_epoch": turn.epoch, "last_sequence": 6})
    restart_snapshot = snapshot(restarted, running=True, generation=5)
    publish(restarted, "message.delta", {"text": "restart"})
    complete(restarted, "adm-c", "After restart")
    assert restarted.epoch != turn.epoch

    # A released stream (no viewer left) that publishes again starts a new epoch.
    released, released_frames = stream(8, "adm-d")
    publish(released, "message.start", {})
    new_stream_snapshot_before = snapshot(released, running=True, generation=8)
    publish(released, "message.delta", {"text": "Before release"})
    released_old_epoch = released.epoch
    released.release()
    publish(released, "message.delta", {"text": "New stream"})
    new_stream_since_old = since(released, {"replay_epoch": released_old_epoch, "last_sequence": 2})
    new_stream_snapshot = snapshot(released, running=True, generation=8)
    publish(released, "message.delta", {"text": " continues"})
    assert released.epoch != released_old_epoch

    # Ring overflow: more than the bounded replay ring holds since the client's cursor.
    flooded, flooded_frames = stream(6, "adm-e")
    publish(flooded, "message.start", {})
    publish(flooded, "message.delta", {"text": "x"})
    overflow_snapshot_before = snapshot(flooded, running=True, generation=6)
    for _ in range(event_replay._REPLAY_BUFFER_MAX + 40):
        publish(flooded, "message.delta", {"text": "."})
    overflow_since = since(flooded, {"replay_epoch": flooded.epoch, "last_sequence": 2})
    overflow_snapshot = snapshot(flooded, running=True, generation=6)
    assert overflow_since["truncated"] and overflow_since["snapshot_required"]

    # Fanout overflow: the real overflow closure builds the replay-gap notice for a viewer whose
    # subscription the owner retired; the ring still replays what it missed.
    gapped, gapped_frames = stream(6, "adm-f")
    publish(gapped, "message.start", {})
    publish(gapped, "message.delta", {"text": "Kept "})
    gap_snapshot_before = snapshot(gapped, running=True, generation=6)
    notices = []

    class OverflowingFanout:
        def write(self, frame, overflow):
            notices.append(json.loads(json.dumps(overflow("slow-viewer"))))
            return False
    healthy_fanout = gapped.fanout
    gapped.fanout = OverflowingFanout()
    publish(gapped, "message.delta", {"text": "replayed"})
    gapped.fanout = healthy_fanout
    replay_gap = notices[0]
    gap_since = since(gapped, {"replay_epoch": gapped.epoch, "last_sequence": 2})
    gap_snapshot_after = snapshot(gapped, running=True, generation=6)
    assert not gap_since["snapshot_required"] and [e["seq"] for e in gap_since["events"]] == [3]

    # A terminal frame published before the snapshot that a reloading client is still holding.
    held, held_frames = stream(9, "adm-g")
    publish(held, "message.start", {})
    held_snapshot_start = snapshot(held, running=True, generation=9)
    publish(held, "message.delta", {"text": "Done "})
    held_snapshot_running = snapshot(held, running=True, generation=9)
    publish(held, "message.delta", {"text": "now"})
    complete(held, "adm-g", "Done now")
    held_snapshot = snapshot(held, running=False, generation=9)
    held_since_after_2 = since(held, {"replay_epoch": held.epoch, "last_sequence": 2})
    held_since_without_epoch = since(held, {"last_seen": 2})

    # Controls: params, fences and acknowledgements.
    def wire_error(exc):
        return {"code": getattr(exc, "wire_code", 4001), "message": getattr(exc, "wire_message", exc.reason),
                "data": _refusal_data(exc)}

    def owner(generation, state="running"):
        authority = SimpleNamespace(profile_id=PROFILE, epoch=AUTHORITY_EPOCH, _managed_workers={},
                                    authorize=lambda *_: None,
                                    sessions={SID: SimpleNamespace(event_stream=SessionEvents())})
        authority._handle = lambda _ref: SessionHandle(ref, "instance-fixture", AUTHORITY_EPOCH, 1,
                                                        generation, state)
        authority.check_approval_generation = MethodType(SessionAuthority.check_approval_generation, authority)
        return authority

    def refusal(coro):
        try:
            asyncio.run(coro)
        except AuthorityRefusal as exc:
            return wire_error(exc)
        raise AssertionError("expected a refusal")

    stale_interrupt = refusal(SessionAuthority.interrupt(owner(4), None, ref, 3))
    missing_generation_interrupt = refusal(SessionAuthority.interrupt(owner(4), None, ref, None))
    connection = SimpleNamespace(actor=None, authority=owner(4))
    steer_without_generation = refusal(correct(connection, ref, {"session_id": SID, "text": "Focus"},
                                               verb="steer"))
    stale_steer = refusal(correct(connection, ref, {"session_id": SID, "text": "Focus",
                                                    "execution_generation": 3}, verb="steer"))
    connection.authority.steer_agent = lambda _ref, _generation, _text: (None, True)
    steer_queued = asyncio.run(correct(connection, ref, {"session_id": SID, "text": "Focus",
                                                         "execution_generation": 4}, verb="steer"))
    connection.authority.steer_agent = lambda _ref, _generation, _text: (None, False)
    steer_rejected = asyncio.run(correct(connection, ref, {"session_id": SID, "text": "Focus",
                                                           "execution_generation": 4}, verb="steer"))
    for ack in (steer_queued, steer_rejected):
        CanonicalCorrectionResult.model_validate(ack)
    interrupt_ack = asdict(SessionHandle(ref, "instance-fixture", AUTHORITY_EPOCH, 1, 4, "running"))
    CanonicalSessionHandle.model_validate(interrupt_ack)
    submit_ack = asdict(AdmissionReceipt("adm-b", ref, 2, "started", None, AUTHORITY_EPOCH, 4))
    AdmissionStatus.model_validate(submit_ack)
    pending_row = asdict(PendingAdmission("adm-q", ref, 3, "queued", None, AUTHORITY_EPOCH, None,
                                          input_id="input-q", text="Then summarise", controls=["steer"]))
    CanonicalPendingAdmission.model_validate(pending_row)
    snapshot_with_pending = {**turn_snapshot_running, "pending": [pending_row]}
    CanonicalSnapshot.model_validate(snapshot_with_pending)

    canonical_params = {
        "interrupt": {"session_id": SID, "execution_generation": 4},
        "steer": {"session_id": SID, "execution_generation": 4, "text": "Focus"},
        "events_since": {"session_id": SID, "replay_epoch": turn.epoch, "last_sequence": 2},
    }
    for method, params in (("session.interrupt", canonical_params["interrupt"]),
                           ("session.steer", canonical_params["steer"]),
                           ("session.events.since", canonical_params["events_since"])):
        assert canonical_param_problems(CANONICAL_METHODS[method], params) == [], method

    def legacy(method, params):
        return legacy_server.handle_request({"jsonrpc": "2.0", "id": 1, "method": method, "params": params})

    legacy_sid = "legacy-runtime-1"
    legacy_frames = []
    for event_type, payload in (("message.start", {}), ("message.delta", {"text": "Le"}),
                                ("message.delta", {"text": "gacy"}),
                                ("message.complete", {"text": "Legacy", "status": "complete"})):
        frame = {"jsonrpc": "2.0", "method": "event",
                 "params": {"type": event_type, "session_id": legacy_sid, "payload": payload}}
        event_replay._stamp_event(frame)
        legacy_frames.append(frame)
    legacy_since = legacy("session.events.since", {"session_id": legacy_sid, "last_seen": 1})
    legacy_controls = {
        "interrupt_with_generation": legacy("session.interrupt", {"session_id": legacy_sid,
                                                                  "execution_generation": 4}),
        "steer_with_generation": legacy("session.steer", {"session_id": legacy_sid,
                                                          "execution_generation": 4, "text": "Focus"}),
        "events_since_canonical_keys": legacy("session.events.since", {
            "session_id": legacy_sid, "replay_epoch": process_epoch, "last_sequence": 1}),
    }
    for name, response in legacy_controls.items():
        assert response["error"]["code"] == 4000 and "Extra inputs are not permitted" in response["error"]["message"], name
    legacy_ready = {"jsonrpc": "2.0", "method": "event", "params": {"type": "gateway.ready", "payload": {
        "change_events": True, "heartbeat": True, "replay_epoch": process_epoch}}}

    commit = subprocess.run(["git", "-C", str(backend), "rev-parse", "HEAD"], check=True,
                            capture_output=True, text=True).stdout.strip()
    fixture = {
        "_provenance": {
            "backend_commit": commit,
            "generator": "tools/capture_canonical_replay_fixture.py",
            "note": "Epochs are random per run; tests read them from this file.",
        },
        "session_id": SID,
        "process_epoch": process_epoch,
        "ready_frame": ready,
        "turn": {"frames": turn_frames, "snapshot_running": turn_snapshot_running,
                 "since_after_2": turn_since_after_2, "since_without_epoch": turn_since_no_epoch,
                 "since_process_epoch": turn_since_process_epoch,
                 "snapshot_complete": turn_snapshot_complete, "snapshot_next": turn_snapshot_next},
        "restart": {"frames": restarted_frames, "since_old_epoch": restart_since_old,
                    "snapshot": restart_snapshot},
        "new_stream": {"frames": released_frames, "old_epoch": released_old_epoch,
                       "snapshot_before": new_stream_snapshot_before,
                       "since_old_epoch": new_stream_since_old, "snapshot": new_stream_snapshot},
        "overflow": {"first_frames": flooded_frames[:3], "last_frame": flooded_frames[-1],
                     "snapshot_before": overflow_snapshot_before,
                     "since_after_2": overflow_since, "snapshot": overflow_snapshot},
        "replay_gap": {"frames": gapped_frames, "snapshot_before": gap_snapshot_before,
                       "notice": replay_gap, "since_after_2": gap_since,
                       "snapshot_after": gap_snapshot_after},
        "held_terminal": {"frames": held_frames, "snapshot_start": held_snapshot_start,
                          "snapshot_running": held_snapshot_running, "snapshot": held_snapshot,
                          "since_after_2": held_since_after_2,
                          "since_without_epoch": held_since_without_epoch},
        "controls": {
            "canonical_params": canonical_params,
            "stale_interrupt": stale_interrupt,
            "interrupt_without_generation": missing_generation_interrupt,
            "steer_without_generation": steer_without_generation,
            "stale_steer": stale_steer,
            "steer_queued": steer_queued,
            "steer_rejected": steer_rejected,
            "interrupt_ack": interrupt_ack,
            "submit_ack": submit_ack,
            "snapshot_with_pending": snapshot_with_pending,
        },
        "legacy": {"ready_frame": legacy_ready, "frames": legacy_frames, "since_after_1": legacy_since,
                   "controls": legacy_controls},
    }
    out.write_text(json.dumps(fixture, indent=2, sort_keys=True) + "\n")
    print(f"wrote {out}")
