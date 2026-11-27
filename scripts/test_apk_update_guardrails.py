"""Regression checks that the GitHub APK updater stays removed.

Ares 4.0.17 and earlier could check GitHub Releases, download an APK and hand
it to the Android installer. Updates now come only from the store or site the
app was installed from, so no build may regain that path by accident.
"""

import json
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ANDROID = "{http://schemas.android.com/apk/res/android}"
TOOLS_NODE = "{http://schemas.android.com/tools}node"
INSTALL_PERMISSION = "android.permission.REQUEST_INSTALL_PACKAGES"
REMOVED_SOURCES = (
    "lib/core/services/app_update_service.dart",
    "lib/core/services/apk_update_installer.dart",
    "lib/core/widgets/update_available_dialog.dart",
    "android/app/src/main/kotlin/com/hermesagent/hermes_android/ApkUpdateInstaller.kt",
    "android/app/src/main/kotlin/com/hermesagent/hermes_android/ApkUpdateTransfer.kt",
    "android/app/src/main/res/xml/update_file_paths.xml",
)


class ApkUpdateGuardrailsTest(unittest.TestCase):
    def test_app_cannot_install_packages(self):
        manifest = ET.parse(ROOT / "android/app/src/main/AndroidManifest.xml").getroot()
        entries = [item for item in manifest if item.tag.startswith("uses-permission")]
        declared = [item.get(ANDROID + "name") for item in entries if item.get(TOOLS_NODE) != "remove"]
        self.assertTrue(declared)
        self.assertNotIn(INSTALL_PERMISSION, declared)
        # Every lane, the default GitHub and F-Droid APK included, strips the
        # permission if a dependency ever declares it.
        removed = [item.get(ANDROID + "name") for item in entries if item.get(TOOLS_NODE) == "remove"]
        self.assertIn(INSTALL_PERMISSION, removed)
        authorities = [
            item.get(ANDROID + "authorities", "")
            for item in manifest.findall("./application/provider")
        ]
        self.assertFalse([value for value in authorities if "update_provider" in value])

    def test_store_overlays_strip_a_dependency_supplied_install_permission(self):
        for overlay in ("play", "parked"):
            root = ET.parse(ROOT / f"android/app/src/{overlay}/AndroidManifest.xml").getroot()
            permission = next(
                item
                for item in root.findall("uses-permission")
                if item.get(ANDROID + "name") == INSTALL_PERMISSION
            )
            self.assertEqual(permission.get(TOOLS_NODE), "remove", overlay)

    def test_no_release_check_or_installer_remains(self):
        for path in REMOVED_SOURCES:
            self.assertFalse((ROOT / path).exists(), path)
        sources = []
        for directory in ("lib", "android/app/src/main/kotlin", "ios", "macos", "windows", "linux", "apple"):
            sources.extend(
                path for path in (ROOT / directory).rglob("*")
                if path.suffix in {".dart", ".kt", ".swift", ".m", ".mm", ".cpp", ".h"}
            )
        self.assertTrue(sources)
        for source in sources:
            text = source.read_text(encoding="utf-8")
            for marker in ("api.github.com", "application/vnd.android.package-archive", "ACTION_INSTALL_PACKAGE", "PackageInstaller", "AppUpdateService", "ApkUpdateInstaller", "supportsApkSelfUpdate", "update_available_dialog", "checkForUpdate"):
                self.assertNotIn(marker, text, f"{marker} in {source.relative_to(ROOT)}")

    def test_retired_update_strings_are_absent_in_every_locale(self):
        removed_keys = {
            "update_now", "you_re_on_the_latest_version",
            "a_newer_hermes_android_build_is_available_on_github",
            "check_for_updates", "update_allow_install", "check_for_updates_on_launch",
            "skip_this_version", "couldn_t_check_for_updates", "update_downloading",
            "update_failed", "update_install", "view_release", "update_available",
            "later", "release_notes",
        }
        catalogues = list((ROOT / "lib/l10n").glob("*.arb"))
        self.assertEqual(len(catalogues), 14)  # English plus 13 translated locales.
        for catalogue in catalogues:
            keys = {key.removeprefix("@") for key in json.loads(catalogue.read_text())}
            self.assertFalse(keys & removed_keys, catalogue.name)

    def test_both_ci_workflows_run_the_removal_guard(self):
        for workflow in ("release.yml", "pr-quality.yml"):
            self.assertIn(
                "scripts.test_apk_update_guardrails",
                (ROOT / ".github/workflows" / workflow).read_text(),
                workflow,
            )

    def test_network_config_keeps_only_the_gateway_trust_rules(self):
        root = ET.parse(ROOT / "android/app/src/main/res/xml/network_security_config.xml").getroot()
        self.assertEqual(root.findall("domain-config"), [])
        self.assertEqual(
            {entry.get("src") for entry in root.findall("./base-config/trust-anchors/certificates")},
            {"system", "user"},
        )

    def test_play_build_wiring_and_legal_links_remain(self):
        gradle = (ROOT / "android/app/build.gradle.kts").read_text()
        self.assertIn('providers.environmentVariable("ARES_PLAY_BUILD")', gradle)
        self.assertIn('require(playBuild == dartFlag("ARES_PLAY_BUILD"))', gradle)
        self.assertIn('sourceSets.getByName("release").manifest.srcFile("src/play/AndroidManifest.xml")', gradle)
        self.assertTrue((ROOT / "PRIVACY.md").is_file())
        links = (ROOT / "lib/core/services/legal_links.dart").read_text()
        self.assertIn("/PRIVACY.md", links)
        self.assertIn("/issues/new", links)


if __name__ == "__main__":
    unittest.main()
