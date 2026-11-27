"""Run both cold-activation controls with separate issuing and consuming VMs."""
import os
from pathlib import Path
import subprocess
import tempfile

root = Path(__file__).resolve().parents[2]
with tempfile.TemporaryDirectory(prefix="ares-receipts-") as temp:
    for edit in ("no", "yes"):
        for phase in ("issue", "consume"):
            subprocess.run(
                ["flutter", "test", "--no-pub", "-r", "expanded", "test/fixtures/windows/cold_activation_fixture.dart"],
                check=True, cwd=root,
                env={**os.environ, "ARES_TEST_RECEIPT_FILE": str(Path(temp) / (edit + ".json")),
                     "RECEIPT_PHASE": phase, "RECEIPT_EDIT": edit},
            )
