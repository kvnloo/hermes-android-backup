import 'package:shared_preferences/shared_preferences.dart';

/// Preference keys written by features that no longer exist.
///
/// The GitHub update check (removed in 4.0.18) kept its throttle, cached
/// release, skipped version and launch switch here.
const retiredPreferenceKeys = <String>[
  'app_update_last_check_v1',
  'app_update_etag_v1',
  'app_update_cached_release_v1',
  'app_update_skipped_version_v1',
  'app_update_check_on_launch_v1',
];

/// Deletes [retiredPreferenceKeys]. Safe to run on every launch: a missing
/// key costs nothing, and a failure only leaves unused data behind.
Future<void> clearRetiredPreferences(SharedPreferences preferences) async {
  for (final key in retiredPreferenceKeys) {
    if (!preferences.containsKey(key)) continue;
    try {
      await preferences.remove(key);
    } catch (_) {}
  }
}
