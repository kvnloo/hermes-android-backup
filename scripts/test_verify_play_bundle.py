"""Distribution gates, using a text-XML stand-in for bundletool in unit tests."""
import os
import re
import subprocess
import tempfile
import unittest
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path
from unittest.mock import patch

from scripts import verify_play_bundle as v

ROOT = Path(__file__).resolve().parents[1]


def child(parent, path):
    node = parent.find(path)
    if node is None:
        raise AssertionError(f'Missing fixture element: {path}')
    return node


class VerifyPlayBundleTest(unittest.TestCase):
    def setUp(self):
        old = Path.cwd()
        os.chdir(ROOT)
        self.addCleanup(os.chdir, old)
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.dir = Path(tmp.name)
        self.bundle = self.dir / 'app-release.aab'
        self.xml = self.dir / 'merged.xml'
        match = re.search(r'^version:\s*([^\s+]+)\+(\d+)', Path('pubspec.yaml').read_text(), re.M)
        if match is None:
            self.fail('Missing pubspec version')
        self.version, base = match.groups()
        self.base = int(base)
        decoder = patch.object(v, '_packaged_manifest', side_effect=self.decode_fixture)
        decoder.start()
        self.addCleanup(decoder.stop)

    @staticmethod
    def decode_fixture(bundle, _tool):
        with zipfile.ZipFile(bundle) as z:
            return ET.fromstring(z.read(v.BASE_MANIFEST))

    def manifest(self, car):
        a = v.A
        root = ET.Element('manifest', {'package': v.PLAY_PACKAGE, a+'versionName': self.version,
                                       a+'versionCode': str(self.base + (v.AUTOMOTIVE_OFFSET if car else 0))})
        ET.SubElement(root, 'uses-sdk', {a+'minSdkVersion': '33' if car else '24', a+'targetSdkVersion': '36'})
        app = ET.SubElement(root, 'application', {a+'label': 'Ares'})
        if car:
            ET.SubElement(root, 'uses-feature', {a+'name': v.CAR_FEATURE, a+'required': 'true'})
            activity = ET.SubElement(app, 'activity', {a+'name': '.MainActivity', a+'exported': 'true'})
            intent = ET.SubElement(activity, 'intent-filter')
            ET.SubElement(intent, 'action', {a+'name': 'android.intent.action.MAIN'})
            ET.SubElement(intent, 'category', {a+'name': 'android.intent.category.LAUNCHER'})
        else:
            for name in ('RECORD_AUDIO', 'POST_NOTIFICATIONS'):
                ET.SubElement(root, 'uses-permission', {a+'name': 'android.permission.'+name})
            for name in ('application', 'notification.SmallIcon'):
                ET.SubElement(app, 'meta-data', {a+'name': 'com.google.android.gms.car.'+name})
            ET.SubElement(app, 'receiver', {a+'name': '.AutoMessageReceiver', a+'exported': 'false'})
        return root

    def pack(self, root):
        with zipfile.ZipFile(self.bundle, 'w') as z:
            z.writestr(v.BASE_MANIFEST, ET.tostring(root))
            z.writestr('base/dex/classes.dex', b'unittest')

    def verify(self, car, extra_manifest=None):
        return v.verify(self.bundle, extra_manifest, allow_unsigned=True, automotive=car)

    def test_positive_controls_and_identity(self):
        for car in (False, True):
            self.pack(self.manifest(car))
            result = self.verify(car)
            self.assertEqual(result['package'], v.PLAY_PACKAGE)
            self.assertEqual(result['version_code'], self.base + (1_000_000_000 if car else 0))
            self.assertFalse(result['signed'])
            with self.assertRaisesRegex(ValueError, 'unsigned'):
                v.verify(self.bundle, automotive=car)

    def test_external_xml_cannot_swap_tracks(self):
        for car in (True, False):
            self.pack(self.manifest(not car))
            self.xml.write_bytes(ET.tostring(self.manifest(car)))
            with self.assertRaisesRegex(ValueError, 'versionCode'):
                self.verify(car, self.xml)

    def test_per_track_requirements_fail_closed(self):
        for bad in ('package', 'id', 'optional', 'optimization', 'category', 'receiver', 'mic', 'debuggable', 'sdk'):
            with self.subTest(bad=bad):
                root = self.manifest(True)
                app = child(root, 'application')
                if bad == 'package': root.set('package', v.PLAY_PACKAGE+'.automotive.preview')
                if bad == 'id': root.set(v.A+'versionCode', str(self.base))
                if bad == 'optional': child(root, 'uses-feature').set(v.A+'required', 'false')
                if bad == 'optimization': ET.SubElement(child(app, 'activity'), 'meta-data', {v.A+'name':'distractionOptimized',v.A+'value':'true'})
                if bad == 'category': app.set(v.A+'appCategory','game')
                if bad == 'receiver': ET.SubElement(app, 'receiver', {v.A+'name':'.AutoMessageReceiver'})
                if bad == 'mic': ET.SubElement(root, 'uses-permission', {v.A+'name':'android.permission.RECORD_AUDIO'})
                if bad == 'debuggable': app.set(v.A+'debuggable', 'true')
                if bad == 'sdk': child(root, 'uses-sdk').set(v.A+'targetSdkVersion', '34')
                self.pack(root)
                with self.assertRaises(ValueError): self.verify(True)
        root = self.manifest(False)
        child(root, 'application').remove(child(root, './application/receiver'))
        self.pack(root)
        with self.assertRaisesRegex(ValueError, 'reply receiver'): self.verify(False)

    def test_update_install_authority_rejected_on_both_tracks(self):
        for car in (True, False):
            root = self.manifest(car)
            ET.SubElement(root, 'uses-permission-sdk-23', {v.A+'name':'android.permission.REQUEST_INSTALL_PACKAGES'})
            self.pack(root)
            with self.assertRaisesRegex(ValueError, 'package installation'): self.verify(car)
            root = self.manifest(car)
            ET.SubElement(child(root, 'application'), 'provider', {v.A+'authorities':v.PLAY_PACKAGE+'.update_provider'})
            self.pack(root)
            with self.assertRaisesRegex(ValueError, 'update provider'): self.verify(car)

    def test_version_code_limit(self):
        self.assertEqual(v._expected_code(1_100_000_000, True), 2_100_000_000)
        for base, car in ((0,True),(1_000_000_000,False),(1_100_000_001,True)):
            with self.assertRaises(ValueError): v._expected_code(base, car)

    def test_signature_integrity_and_pin_are_independent(self):
        ok = subprocess.CompletedProcess([], 4, stdout='jar verified, with signer errors.', stderr='')
        fingerprint = f'SHA256: {v.PRODUCTION_CERT_SHA256}\n'
        def cert(start_year, end_year):
            dates = f'Valid from: Sat Jan 01 00:00:00 UTC {start_year} until: Mon Dec 31 23:59:59 UTC {end_year}\n'
            return subprocess.CompletedProcess([], 0, stdout=dates + fingerprint, stderr='')
        pinned = cert(2000, 2200)
        with patch.dict(os.environ, {'JAVA_HOME':'/fixture'}):
            with patch.object(v.subprocess, 'run', side_effect=[ok, pinned]):
                v._verify_signer(self.bundle)
            for results, error in (([subprocess.CompletedProcess([], 16, stdout='jar verified', stderr='')], 'signature'),
                                   ([ok, cert(2000, 2001)], 'not currently valid'),
                                   ([ok, cert(2200, 2201)], 'not currently valid'),
                                   ([ok, subprocess.CompletedProcess([], 0, stdout='SHA256: 00', stderr='')], 'signer')):
                with patch.object(v.subprocess, 'run', side_effect=results), self.assertRaisesRegex(ValueError, error):
                    v._verify_signer(self.bundle)


if __name__ == '__main__':
    unittest.main()
