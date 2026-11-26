"""Verify a mobile (default) or parked Automotive Play AAB and its upload signer."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
from datetime import datetime, timezone
import tempfile
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

if __package__:
    from .check_parked_automotive import A, CAR_FEATURE, PLAY_PACKAGE, check_manifest
    from .verify_release_apks import PRODUCTION_CERT_SHA256
else:
    from check_parked_automotive import A, CAR_FEATURE, PLAY_PACKAGE, check_manifest
    from verify_release_apks import PRODUCTION_CERT_SHA256

BASE_MANIFEST = "base/manifest/AndroidManifest.xml"
AUTOMOTIVE_OFFSET = 1_000_000_000
MAX_PLAY_CODE = 2_100_000_000


def _sha256(path: Path) -> str:
    state = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            state.update(chunk)
    return state.hexdigest()


def _expected_code(base: int, automotive: bool) -> int:
    if base <= 0 or (not automotive and base >= AUTOMOTIVE_OFFSET):
        raise ValueError("base versionCode is outside the mobile lane")
    code = base + AUTOMOTIVE_OFFSET if automotive else base
    if code > MAX_PLAY_CODE:
        raise ValueError("Automotive versionCode exceeds the Play limit")
    return code


def _manifest(root: ET.Element, version: str, code: int, automotive: bool) -> None:
    if root.tag != "manifest" or root.get("package") != PLAY_PACKAGE:
        raise ValueError("Play manifest has the wrong package")
    if root.get(A + "versionName") != version:
        raise ValueError("Play manifest has the wrong versionName")
    if root.get(A + "versionCode") != str(code) or root.get(A + "versionCodeMajor", "0") != "0":
        raise ValueError(f"Play AAB must use the expected un-split versionCode {code}")
    uses_sdk = root.find("uses-sdk")
    if uses_sdk is None or uses_sdk.get(A + "targetSdkVersion") != "36":
        raise ValueError("Play manifest must target API 36")
    permissions = {item.get(A + "name") for item in root if item.tag.startswith("uses-permission")}
    if "android.permission.REQUEST_INSTALL_PACKAGES" in permissions:
        raise ValueError("Play manifest still requests package installation")
    for item in root.findall("./application/provider"):
        if any(a.endswith(".update_provider") for a in item.get(A + "authorities", "").split(";")):
            raise ValueError("Play manifest still contains the APK update provider")
    app = root.find("application")
    if app is None or app.get(A + "label") != "Ares" or app.get(A + "debuggable", "false") != "false":
        raise ValueError("Play application must be a non-debuggable Ares release")
    if automotive:
        check_manifest(root, play=True)
        return
    if root.find(f".//uses-feature[@{A}name='{CAR_FEATURE}']") is not None:
        raise ValueError("mobile Play bundle declares Automotive hardware")
    if uses_sdk.get(A + "minSdkVersion") != "24":
        raise ValueError("mobile Play manifest must retain minSdk 24")
    if not {"android.permission.RECORD_AUDIO", "android.permission.POST_NOTIFICATIONS"} <= permissions:
        raise ValueError("mobile Play manifest lost the phone microphone/notification permissions")
    required_metadata = {"com.google.android.gms.car.application", "com.google.android.gms.car.notification.SmallIcon"}
    if not required_metadata <= {item.get(A + "name") for item in app.findall("meta-data")}:
        raise ValueError("mobile Play manifest lost Android Auto projection metadata")
    if not any(item.get(A + "name") in (".AutoMessageReceiver", PLAY_PACKAGE + ".AutoMessageReceiver")
               and item.get(A + "exported") == "false" for item in app.findall("receiver")):
        raise ValueError("mobile Play manifest lost its private phone reply receiver")


def _bundle(path: Path) -> bool:
    with zipfile.ZipFile(path) as archive:
        names = archive.namelist()
        if len(names) != len(set(names)):
            raise ValueError("Play AAB contains duplicate ZIP entries")
        if BASE_MANIFEST not in names:
            raise ValueError("Play AAB has no base manifest")
        if not any(name.startswith("base/dex/") for name in names):
            raise ValueError("Play AAB has no application DEX")
        return any(name.startswith("META-INF/") and name.endswith((".RSA", ".DSA", ".EC")) for name in names)


def _java_tool(name: str) -> Path:
    java_home = os.environ.get("JAVA_HOME")
    if not java_home:
        raise ValueError("JAVA_HOME is required for Play AAB verification")
    return Path(java_home) / "bin" / name


def _packaged_manifest(bundle: Path, bundletool: Path | None) -> ET.Element:
    if bundletool is not None:
        xml = subprocess.check_output([
            _java_tool("java"), "-jar", bundletool, "dump", "manifest", "--module=base", f"--bundle={bundle}"
        ], timeout=120)
        return ET.fromstring(xml)

    # Existing mobile CI has the Android SDK but not the standalone bundletool JAR.
    # AAPT2 expects proto resources at APK paths. Wrap only the AAB's actual
    # manifest and an empty ResourceTable; no project/merged XML is an input.
    sdk = os.environ.get("ANDROID_HOME") or os.environ.get("ANDROID_SDK_ROOT")
    if not sdk:
        raise ValueError("set ANDROID_HOME for SDK decoding or pass --bundletool <bundletool-all.jar>")
    aapt2 = Path(sdk) / "build-tools/36.0.0/aapt2"
    analyzer = Path(sdk) / "cmdline-tools/latest/bin/apkanalyzer"
    with tempfile.TemporaryDirectory(prefix="ares-aab-manifest-") as tmp:
        proto, binary = (Path(tmp) / name for name in ("proto.apk", "binary.apk"))
        with zipfile.ZipFile(bundle) as aab, zipfile.ZipFile(proto, "w") as apk:
            apk.writestr("AndroidManifest.xml", aab.read(BASE_MANIFEST))
            apk.writestr("resources.pb", b"")
        subprocess.run([aapt2, "convert", proto, "--output-format", "binary", "-o", binary], check=True, timeout=60)
        return ET.fromstring(subprocess.check_output([analyzer, "manifest", "print", binary], timeout=60))


def _verify_signer(path: Path) -> None:
    # Strict verification rejects unsigned payload entries even when a valid
    # pinned certificate can still be read elsewhere in the same JAR. JDK bit 4
    # alone is normal for a privately issued upload key (no public trust chain).
    locale = ["-J-Duser.language=en", "-J-Duser.country=US", "-J-Duser.timezone=UTC"]
    integrity = subprocess.run([_java_tool("jarsigner"), *locale, "-verify", "-strict", path],
                               capture_output=True, text=True, timeout=180)
    if integrity.returncode not in (0, 4) or "jar verified" not in integrity.stdout:
        raise ValueError("Play AAB has an invalid or incomplete JAR signature")
    result = subprocess.run([_java_tool("keytool"), *locale, "-printcert", "-jarfile", path],
                            capture_output=True, text=True, timeout=180)
    if result.returncode != 0:
        raise ValueError("keytool could not read the Play AAB signer")
    fingerprints = [match.replace(":", "").lower() for match in
                    re.findall(r"(?im)^\s*SHA-?256:\s*([0-9A-Fa-f:]+)\s*$", result.stdout)]
    if fingerprints != [PRODUCTION_CERT_SHA256]:
        raise ValueError("Play AAB signer does not match the production certificate")
    # Jarsigner bit 4 covers time-invalid certificates as well as self-signed ones.
    # Locale/timezone above force a stable keytool date representation.
    dates = re.findall(r"(?m)^Valid from: ([^\r\n]+) until: ([^\r\n]+)$", result.stdout)
    if len(dates) != 1:
        raise ValueError("missing or ambiguous signer validity interval")
    start, end = (datetime.strptime(s, "%a %b %d %H:%M:%S UTC %Y").replace(tzinfo=timezone.utc)
                  for s in dates[0])
    if not start <= datetime.now(timezone.utc) <= end:
        raise ValueError("Play upload certificate is not currently valid")


def verify(bundle: Path, manifest: Path | None = None, allow_unsigned: bool = False, *,
           automotive: bool = False, bundletool: Path | None = None) -> dict:
    match = re.search(r"^version:\s*([^\s+]+)\+(\d+)\s*$", Path("pubspec.yaml").read_text(), re.M)
    if match is None:
        raise ValueError("pubspec.yaml must declare versionName+versionCode")
    version, base_text = match.groups()
    code = _expected_code(int(base_text), automotive)
    signed = _bundle(bundle)
    if not signed and not allow_unsigned:
        raise ValueError("Play AAB is unsigned")
    _manifest(_packaged_manifest(bundle, bundletool), version, code, automotive)
    if manifest is not None:  # Additional check only; never a substitute for the packaged manifest.
        _manifest(ET.parse(manifest).getroot(), version, code, automotive)
    if signed:
        _verify_signer(bundle)
    return {
        "bundle": bundle.name,
        "variant": "automotive" if automotive else "mobile",
        "version_name": version,
        "version_code": code,
        "package": PLAY_PACKAGE,
        "target_api": 36,
        "install_permission_removed": True,
        "update_provider_removed": True,
        "signed": signed,
        "signer_sha256": PRODUCTION_CERT_SHA256 if signed else None,
        "sha256": _sha256(bundle),
        "size": bundle.stat().st_size,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bundle", required=True, type=Path)
    parser.add_argument("--automotive", action="store_true", help="expect the same-listing parked Automotive release")
    parser.add_argument("--bundletool", type=Path, help="trusted bundletool-all.jar; otherwise use local Android SDK tools")
    parser.add_argument("--merged-manifest", type=Path, help="also verify this intermediate; never used as bundle evidence")
    parser.add_argument("--allow-unsigned", action="store_true", help="local unsigned QA only; signed bundles always require the upload signer")
    args = parser.parse_args()
    try:
        report = verify(args.bundle, args.merged_manifest, args.allow_unsigned,
                        automotive=args.automotive, bundletool=args.bundletool)
    except (OSError, ValueError, ET.ParseError, zipfile.BadZipFile, subprocess.SubprocessError) as error:
        raise SystemExit(f"Play AAB verification failed: {error}") from error
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
