import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/config_backup_service.dart';
import 'package:hermes_android/core/services/retired_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('the removed update check leaves no saved state behind', () async {
    SharedPreferences.setMockInitialValues({
      'app_update_last_check_v1': 1764100000000,
      'app_update_etag_v1': 'W/"etag"',
      'app_update_cached_release_v1': '{"tag_name":"v4.0.17"}',
      'app_update_skipped_version_v1': '4.0.17',
      'app_update_check_on_launch_v1': true,
      'theme_mode': 'dark',
    });
    final prefs = await SharedPreferences.getInstance();
    await clearRetiredPreferences(prefs);
    for (final key in retiredPreferenceKeys) {
      expect(prefs.containsKey(key), isFalse, reason: key);
    }
    expect(prefs.getString('theme_mode'), 'dark');
    // Running again on the next launch is a no-op.
    await clearRetiredPreferences(prefs);
    expect(prefs.getKeys(), {'theme_mode'});
  });

  test('backups never carry a retired key', () {
    for (final key in retiredPreferenceKeys) {
      expect(ConfigBackupService.isBackedUpKey(key), isFalse, reason: key);
    }
  });
}
