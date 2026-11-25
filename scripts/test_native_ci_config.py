"""Exercise the actual native CI configuration script in a disposable checkout."""

import os
import re
import subprocess
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class NativeCiConfigurationTest(unittest.TestCase):
    def run_configuration(self, pubspec):
        workflow = (ROOT / ".github/workflows/native-server.yml").read_text()
        script = textwrap.dedent(
            workflow.split("          python3 - <<'PY'\n", 1)[1].split(
                "          PY\n", 1
            )[0]
        )
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "android").mkdir()
            (root / "pubspec.yaml").write_text(pubspec)
            result = subprocess.run(
                [sys.executable, "-c", script],
                cwd=root,
                env={
                    **os.environ,
                    "FLUTTER_ROOT": "/fixture/flutter",
                    "ANDROID_HOME": "/fixture/android",
                },
                capture_output=True,
                text=True,
            )
            properties = root / "android/local.properties"
            return result, properties.read_text() if properties.exists() else None

    def test_native_gradle_receives_the_real_rc_identity(self):
        result, text = self.run_configuration("version: 3.0.0-rc.1+3000\n")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        assert text is not None
        properties = dict(line.split("=", 1) for line in text.splitlines())
        self.assertEqual(properties["flutter.versionCode"], "3000")
        self.assertEqual(properties["flutter.versionName"], "3.0.0-rc.1")
        self.assertEqual(properties["flutter.buildMode"], "debug")
        self.assertEqual(properties["flutter.sdk"], "/fixture/flutter")
        self.assertEqual(properties["sdk.dir"], "/fixture/android")

    def test_native_job_supplies_the_pinned_gradle_without_an_ignored_wrapper(self):
        workflow = (ROOT / ".github/workflows/native-server.yml").read_text()
        wrapper = (ROOT / "android/gradle/wrapper/gradle-wrapper.properties").read_text()
        version = re.search(r"distributionUrl=.*gradle-([\d.]+)-all\.zip", wrapper)
        self.assertIsNotNone(version, "Wrapper must pin a Gradle release")
        assert version is not None
        self.assertIn("gradle/actions/setup-gradle@v6", workflow)
        self.assertIn(f"gradle-version: '{version.group(1)}'", workflow)
        self.assertIn("run: gradle :app:testDebugUnitTest", workflow)
        self.assertNotIn("run: ./gradlew", workflow)

    def test_setup_gradle_never_engages_proprietary_caching(self):
        workflow = (ROOT / ".github/workflows/native-server.yml").read_text()
        setup = workflow.split("uses: gradle/actions/setup-gradle@v6\n", 1)[1]
        setup = setup.split("      - name:", 1)[0]
        self.assertIn("cache-disabled: true", setup)
        self.assertIn("cache-provider: basic", setup)
        self.assertNotIn("build-scan-terms-of-use-agree", workflow)
        cache = workflow.split("name: Cache open-source Gradle dependencies\n", 1)[1]
        cache = cache.split("      - name:", 1)[0]
        self.assertIn("uses: actions/cache@v6", cache)
        paths = cache.split("path: |\n", 1)[1].split("          key:", 1)[0]
        self.assertEqual(
            {line.strip() for line in paths.splitlines() if line.strip()},
            {"~/.gradle/caches/modules-2", "~/.gradle/wrapper/dists"},
        )
        for build_input in ("android/**/*.gradle*", "android/gradle.properties",
                            "android/gradle/wrapper/gradle-wrapper.properties", "pubspec.lock"):
            self.assertIn(build_input, cache)

    def test_ci_runs_tts_correlation_and_retains_both_native_reports(self):
        workflow = (ROOT / ".github/workflows/native-server.yml").read_text()
        self.assertIn(
            "run: gradle :app:testDebugUnitTest :flutter_tts:testDebugUnitTest",
            workflow,
        )
        self.assertIn(
            "python3 -m unittest scripts.test_prepare_voice_inputs scripts.test_native_ci_config",
            workflow,
        )
        for module in ("app", "flutter_tts"):
            self.assertIn(f"build/{module}/reports/tests/testDebugUnitTest", workflow)
            self.assertIn(f"build/{module}/test-results/testDebugUnitTest", workflow)

    def test_app_and_tts_share_one_robolectric_version(self):
        properties = dict(
            line.split("=", 1)
            for line in (ROOT / "android/gradle.properties").read_text().splitlines()
            if "=" in line and not line.startswith("#")
        )
        self.assertEqual(properties.get("robolectricVersion"), "4.18.1")
        app = (ROOT / "android/app/build.gradle.kts").read_text()
        tts = (ROOT / "android/flutter-tts-patch.gradle").read_text()
        self.assertIn('providers.gradleProperty("robolectricVersion").get()', app)
        self.assertIn("providers.gradleProperty('robolectricVersion').get()", tts)
        self.assertIn('org.robolectric:robolectric:$robolectricVersion', app)
        self.assertIn('org.robolectric:robolectric:${robolectricVersion}', tts)

    def test_ci_caches_robolectric_runtime_downloads_separately_from_gradle(self):
        workflow = (ROOT / ".github/workflows/native-server.yml").read_text()
        marker = "      - name: Cache Robolectric runtimes\n"
        self.assertIn(marker, workflow)
        cache = workflow.split(marker, 1)[1]
        cache = cache.split("      - name:", 1)[0]
        self.assertIn("uses: actions/cache@v6", cache)
        self.assertIn("path: ~/.m2/repository/org/robolectric/android-all-instrumented", cache)
        self.assertIn("key: robolectric-${{ runner.os }}-", cache)
        for source in (
            "android/gradle.properties",
            "android/app/src/test/**",
            "android/flutter_tts_tests/**",
        ):
            self.assertIn(source, cache)
        self.assertLess(
            workflow.index("      - name: Cache Robolectric runtimes"),
            workflow.index("      - name: Run native lifecycle"),
        )

    def test_missing_pubspec_identity_fails_before_writing_properties(self):
        result, text = self.run_configuration("name: hermes_android\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(text)


if __name__ == "__main__":
    unittest.main()
