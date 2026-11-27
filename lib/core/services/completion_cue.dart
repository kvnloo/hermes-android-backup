import 'notification_prefs.dart';

/// Which completion alert sound to use, shared by every non-Windows sink.
///
/// The four names are the tokens [WindowsCompletionSound] already stores and
/// the Windows toast sink already sends (`system`, `mail`, `reminder`,
/// `silent`). Windows plays them as operating-system sound events. Android
/// and Apple play original short tones bundled as `ares_mail` and
/// `ares_reminder` for the two named choices, and Linux asks the desktop
/// sound theme. `system` keeps the platform default. No new package is
/// involved.
class CompletionCue {
  const CompletionCue({
    required this.audible,
    this.androidRaw,
    this.darwinFile,
    this.linuxTheme,
    this.channelSuffix = '',
  });

  /// Play a sound. Silent cues still show the notification.
  final bool audible;

  /// `res/raw` name without an extension. Null keeps the Android default.
  final String? androidRaw;

  /// File name in the Apple app bundle. Null keeps the system sound.
  final String? darwinFile;

  /// freedesktop sound-theme name. Null keeps the server default.
  final String? linuxTheme;

  /// Android channel-id suffix. Empty keeps the historical channel, so a
  /// system sound does not fork a channel the user has already configured.
  /// A non-empty suffix is required because Android 8+ locks a channel's
  /// sound at creation.
  final String channelSuffix;

  /// Android channel suffixes a completion choice can create. The historical
  /// channel (no suffix) also carries failures, so it is never deleted.
  static const choiceSuffixes = {'mail', 'reminder', 'silent'};

  /// The channel suffix a completion or test alert uses for [sound].
  static String channelSuffixFor(WindowsCompletionSound sound) =>
      switch (sound) {
        WindowsCompletionSound.system => '',
        WindowsCompletionSound.mail => 'mail',
        WindowsCompletionSound.reminder => 'reminder',
        WindowsCompletionSound.silent => 'silent',
      };

  /// The Windows toast rule for a completion or test, and the historical
  /// rule for every other kind: the picker never changes approvals, errors
  /// or background alerts.
  static CompletionCue resolve({
    required bool silent,
    required bool onlyAlertOnce,
    required bool ongoing,
    required String payload,
    required HermesNotificationKind? kind,
  }) {
    final test = payload == 'test' && kind == null && !ongoing;
    final completion = kind == HermesNotificationKind.turnDone || test;
    if (!completion) {
      return CompletionCue(audible: !silent);
    }
    if (silent || onlyAlertOnce) {
      return const CompletionCue(audible: false, channelSuffix: 'silent');
    }
    return switch (notificationPrefs.value.completionSound) {
      WindowsCompletionSound.system => const CompletionCue(audible: true),
      WindowsCompletionSound.silent => const CompletionCue(
        audible: false,
        channelSuffix: 'silent',
      ),
      WindowsCompletionSound.mail => const CompletionCue(
        audible: true,
        androidRaw: 'ares_mail',
        darwinFile: 'ares_mail.wav',
        linuxTheme: 'message-new-email',
        channelSuffix: 'mail',
      ),
      WindowsCompletionSound.reminder => const CompletionCue(
        audible: true,
        androidRaw: 'ares_reminder',
        darwinFile: 'ares_reminder.wav',
        linuxTheme: 'alarm-clock-elapsed',
        channelSuffix: 'reminder',
      ),
    };
  }
}
