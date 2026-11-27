#!/usr/bin/env python3
"""Read-only audit of Ares's pinned upstream managed-SSH API contract.

No Hermes import, HTTP request, SSH connection or running gateway is needed.
The source repository is supplied explicitly; git show reads only the pinned
commit, never the working tree. This is contract evidence, not an integration
or application acceptance test.
"""

import argparse
import ast
import hashlib
import json
import subprocess

REVISION = "b7ee21c14e38316273f88d8ed112491ba1c87d15"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("upstream_repository")
    args = parser.parse_args()
    sources = {}

    def source(path):
        text = subprocess.run(
            ["git", "-C", args.upstream_repository, "show", f"{REVISION}:{path}"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        sources[path] = hashlib.sha256(text.encode()).hexdigest()
        return text

    reach = ast.parse(source("hermes_cli/web_routers/gateway_connections_reach.py"))
    ssh = ast.parse(source("hermes_cli/gateway_connections_ssh.py"))
    transport = source("hermes_cli/gateway_connections_ssh_transport.py")
    browser = source("apps/desktop/src/lib/browser-saved-connections.ts")
    updates = source("apps/desktop/src/store/managed-updates.ts")
    remote = source("hermes_cli/gateway_connections_ssh_remote.py")

    def function(tree, name):
        return next(
            node
            for node in tree.body
            if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef))
            and node.name == name
        )

    routes = {}
    for name in ("ssh_status", "ssh_connect", "ssh_disconnect"):
        node = function(reach, name)
        decorator = node.decorator_list[0]
        assert isinstance(decorator, ast.Call)
        assert isinstance(decorator.func, ast.Attribute)
        routes[name] = {
            "method": decorator.func.attr.upper(),
            "path": ast.literal_eval(decorator.args[0]),
            "arguments": [arg.arg for arg in node.args.args],
        }
        assert routes[name]["arguments"] == ["connection_id"]
        assert routes[name]["path"] == "/api/gateway-connections/{connection_id}/ssh"

    assert routes["ssh_connect"]["method"] == "POST"
    assert routes["ssh_disconnect"]["method"] == "DELETE"
    connect = ast.unparse(function(reach, "ssh_connect"))
    assert "ssh.ensure_tunnel(_ssh_entry(connection_id))" in connect
    # It is a threadpool call awaited until ensure_tunnel finishes, not a job ID.
    assert "await _call" in connect

    status = function(ssh, "tunnel_status")
    returned = next(
        node.value
        for node in ast.walk(status)
        if isinstance(node, ast.Return) and isinstance(node.value, ast.Dict)
    )
    assert all(key is not None for key in returned.keys)
    status_fields = [ast.literal_eval(key) for key in returned.keys if key is not None]
    assert status_fields == [
        "localPort", "remotePort", "pid", "reused", "hermesVersion", "host"
    ]
    # This fingerprint is registry configuration identity, NOT a host key.
    configuration_fingerprint = ast.unparse(function(ssh, "_fingerprint"))
    assert "keyPath" in configuration_fingerprint
    assert "remoteProfile" in configuration_fingerprint
    for name in ("ensure_tunnel", "disconnect"):
        node = function(ssh, name)
        assert any(
            isinstance(part, ast.With)
            and any("_connection_lock(connection_id)" in ast.unparse(item.context_expr)
                    for item in part.items)
            for part in ast.walk(node)
        ), name

    assert '"StrictHostKeyChecking=accept-new"' in transport
    assert '"BatchMode=yes"' in transport
    assert '"host-key-changed"' in transport
    assert "updateManaged" not in browser
    assert "window.hermesDesktop?.connections?.updateManaged ?? null" in updates
    assert "which the Webapp does not reach yet" in browser
    assert "Hermes is not installed on the remote host" in remote

    print(json.dumps({
        "revision": REVISION,
        "routes": routes,
        "ssh_status_fields": status_fields,
        "observations": {
            "trust_on_first_use": True,
            "gateway_classifies_changed_key": True,
            "batch_mode_no_password_prompt": True,
            "connect_and_disconnect_share_per_connection_lock": True,
            "ssh_status_reports_host_key_fingerprint": False,
            "ssh_rest_connect_takes_body_or_trust_parameter": False,
            "browser_bridge_exposes_managed_update": False,
            "browser_roster_explicitly_refuses_ssh": True,
            "remote_requires_existing_hermes_install": True,
        },
        "source_sha256": sources,
        "boundary": "Static source-contract audit only; no live accounts, SSH or inference.",
    }, indent=2))


if __name__ == "__main__":
    main()
