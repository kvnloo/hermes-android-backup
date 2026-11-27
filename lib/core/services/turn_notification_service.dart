import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'
    show MethodChannel, MissingPluginException, PlatformException;
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../parked_automotive.dart';
import '../../l10n/app_localizations.dart';
import '../l10n/l10n.dart' show resolvePreferredLocale;
import '../utils/platform_capabilities.dart';
import 'completion_cue.dart';
import 'notification_prefs.dart';
import 'windows_toast_ledger.dart';
import 'notification_approval_authority.dart';
import 'auto_messaging_service.dart';
import 'connection_manager.dart';
import 'connection_mutation_barrier.dart';
import 'mobile_push_service.dart';

part 'windows_toast_sink.dart';

/// Delivered to the app root when the user taps a notification body or one of
/// its action buttons. Set once by the root widget; every service instance
/// wires its plugin to this single handler so tap routing cannot depend on
/// which screen happened to initialise last.
void Function(NotificationResponse response)? notificationResponseHandler;

/// The Android/iOS notification channel a [TurnNotification] belongs to.
///
/// Phase 3 of the daily-driver roadmap replaces the single Hermes Turns
/// channel with four prioritized channels; describing the channel as data
/// keeps that change testable.
class TurnNotificationChannel {
  final String id;
  final String name;
  final String description;

  const TurnNotificationChannel({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// Visual urgency for a notification: [high] lets the OS show a heads-up card
/// (attention kinds), [low] keeps finished background work quiet.
enum TurnNotificationImportance { low, defaultImportance, high }

/// An action button rendered on the notification itself. Pressing it brings
/// the app forward (`showsUserInterface`) so the live app answers the request
/// instead of a background isolate that cannot reach the gateway.
class TurnNotificationAction {
  final String id;
  final String label;

  const TurnNotificationAction({required this.id, required this.label});
}

/// Frozen producer authority. A delayed platform post cannot mint a new car
/// action after an account mutation, including a same-value ABA edit.
class ConversationNotificationTarget {
  ConversationNotificationTarget(
    this.manager,
    SavedConnection connection,
    this.data,
  ) : mutation = ConnectionMutationBarrier.capture(connection.id);
  final ConnectionManager manager;
  final Map<String, dynamic> data;
  final Object? mutation;
  bool get isCurrent {
    final id = data['connectionId'] as String;
    final saved = manager.getConnections().where((c) => c.id == id).firstOrNull;
    return ConnectionMutationBarrier.isCurrent(id, mutation) &&
        saved != null &&
        MobilePushService.binding(saved) == data['binding'];
  }
}

/// A notification Hermes wants Android to post, described as plain data.
class TurnNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  final TurnNotificationChannel channel;
  final List<TurnNotificationAction> actions;
  final TurnNotificationImportance importance;
  final bool ongoing;
  final bool silent;
  final bool onlyAlertOnce;
  final HermesNotificationKind? kind;
  final WindowsToastTarget? windowsTarget;
  // Live producer state is never serialised into a ticket or sent to Windows.
  final bool Function()? windowsStillNeeded;
  final ConversationNotificationTarget? conversation;

  const TurnNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.channel,
    this.actions = const [],
    this.importance = TurnNotificationImportance.defaultImportance,
    this.ongoing = false,
    this.silent = false,
    this.onlyAlertOnce = false,
    this.conversation,
    this.windowsTarget,
    this.windowsStillNeeded,
    this.kind,
  });
}

/// Platform details for one notification.
///
/// Completion and test alerts follow [CompletionCue]. Every other kind keeps
/// its previous sound. Android Auto conversation posts return before this and
/// stay on their own native path.
NotificationDetails turnNotificationDetails(TurnNotification notification) {
  final strings = notificationStrings();
  final cue = CompletionCue.resolve(
    silent: notification.silent,
    onlyAlertOnce: notification.onlyAlertOnce,
    ongoing: notification.ongoing,
    payload: notification.payload,
    kind: notification.kind,
  );
  final (importance, priority) = switch (notification.importance) {
    TurnNotificationImportance.high => (Importance.high, Priority.high),
    TurnNotificationImportance.low => (Importance.low, Priority.low),
    TurnNotificationImportance.defaultImportance => (
      Importance.defaultImportance,
      Priority.defaultPriority,
    ),
  };
  final channel = notification.channel;
  final suffix = cue.channelSuffix;
  final androidDetails = AndroidNotificationDetails(
    suffix.isEmpty ? channel.id : '${channel.id}_$suffix',
    suffix.isEmpty
        ? channel.name
        : '${channel.name} (${_choiceLabel(strings, suffix)})',
    channelDescription: channel.description,
    // A white silhouette, as Android expects in the status bar; the
    // launcher's adaptive icon shows as a blank circle there.
    icon: 'ic_stat_mobile_push',
    importance: importance,
    priority: priority,
    autoCancel: !notification.ongoing,
    ongoing: notification.ongoing,
    silent: notification.silent,
    onlyAlertOnce: notification.onlyAlertOnce,
    playSound: cue.audible,
    enableVibration: cue.audible,
    sound: cue.audible && cue.androidRaw != null
        ? RawResourceAndroidNotificationSound(cue.androidRaw!)
        : null,
    actions: [
      for (final action in notification.actions)
        AndroidNotificationAction(
          action.id,
          action.label,
          showsUserInterface: true,
        ),
    ],
  );
  final hasApprovalActions = notification.actions.any(
    (action) => action.id == 'approve',
  );
  final darwinDetails = DarwinNotificationDetails(
    presentAlert: !notification.silent,
    presentBadge: !notification.silent,
    presentSound: cue.audible,
    sound: cue.audible ? cue.darwinFile : null,
    categoryIdentifier: hasApprovalActions ? 'hermes_approval' : null,
    interruptionLevel: notification.silent
        ? InterruptionLevel.passive
        : notification.importance == TurnNotificationImportance.high
        ? InterruptionLevel.timeSensitive
        : InterruptionLevel.active,
  );
  return NotificationDetails(
    android: androidDetails,
    iOS: darwinDetails,
    macOS: darwinDetails,
    linux: LinuxNotificationDetails(
      suppressSound: !cue.audible,
      sound: cue.audible && cue.linuxTheme != null
          ? ThemeLinuxSound(cue.linuxTheme!)
          : null,
      defaultActionName: strings.notification_open_action,
      actions: [
        for (final action in notification.actions)
          LinuxNotificationAction(key: action.id, label: action.label),
      ],
    ),
  );
}

/// The app's strings for text the operating system shows outside any widget:
/// channel names and notification actions follow the device language.
AppLocalizations notificationStrings() => lookupAppLocalizations(
  resolvePreferredLocale(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  ),
);

/// The completion choice a channel suffix belongs to, as the settings name it.
String _choiceLabel(AppLocalizations strings, String suffix) =>
    switch (suffix) {
      'mail' => strings.completion_sound_mail,
      'reminder' => strings.completion_sound_reminder,
      'silent' => strings.completion_sound_silent,
      _ => suffix,
    };

/// The platform seam [TurnNotificationService] posts through.
///
/// The production implementation is [PluginTurnNotificationSink]; tests supply
/// a recording double so notification behaviour can be verified without a
/// platform channel.
abstract class TurnNotificationSink {
  Future<void> initialize();

  /// Reads current OS authorisation without displaying a permission prompt.
  /// Returns null only when the platform has no notification permission gate.
  Future<bool?> checkPermission();

  /// Asks the platform for permission to post notifications.
  ///
  /// Returns `true` when granted, `false` when denied, and `null` when the
  /// platform has no notification implementation — in which case posting
  /// has no permission gate here.
  Future<bool?> requestPermission();

  /// The tap or action that launched a terminated app, when the platform
  /// reports one. Consumed once by the service so a cold start still routes.
  Future<NotificationResponse?> takeInitialLaunchResponse();

  Future<void> show(TurnNotification notification);

  Future<void> cancel(int id);

  Future<void> cancelAll();
}

/// A sink that can delete Android notification channels it created.
abstract interface class TurnNotificationChannelCleaner {
  Future<void> deleteChannel(String id);
}

/// Windows uses a runner channel; FLN v18 still owns Android and Darwin.
TurnNotificationSink defaultTurnNotificationSink({
  FlutterLocalNotificationsPlugin? plugin,
}) => isWindowsPlatform
    ? WindowsToastSink()
    : PluginTurnNotificationSink(plugin: plugin);

/// Default sink backed by `flutter_local_notifications`.
class PluginTurnNotificationSink
    implements TurnNotificationSink, TurnNotificationChannelCleaner {
  final FlutterLocalNotificationsPlugin _plugin;

  PluginTurnNotificationSink({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> deleteChannel(String id) async => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.deleteNotificationChannel(id);

  @override
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      'ic_stat_mobile_push',
    );
    final strings = notificationStrings();
    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // Approve/Deny action buttons on iOS and macOS notifications. The
      // category id matches the channel used for attention notifications.
      notificationCategories: [
        DarwinNotificationCategory(
          'hermes_approval',
          actions: [
            DarwinNotificationAction.plain('approve', strings.approve),
            DarwinNotificationAction.plain('reject', strings.deny),
          ],
        ),
      ],
    );
    final settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      // Linux previously threw on startup because this was omitted. The
      // default sound is the desktop theme's message sound; a completion
      // choice replaces it per notification.
      linux: LinuxInitializationSettings(
        defaultActionName: notificationStrings().notification_open_action,
        defaultSound: ThemeLinuxSound('message'),
      ),
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        notificationResponseHandler?.call(response);
      },
    );
  }

  @override
  Future<bool?> checkPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final permissions = await ios.checkPermissions();
      return permissions?.isEnabled == true ||
          permissions?.isProvisionalEnabled == true;
    }

    final macos = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macos != null) {
      final permissions = await macos.checkPermissions();
      return permissions?.isEnabled == true ||
          permissions?.isProvisionalEnabled == true;
    }

    return null;
  }

  @override
  Future<bool?> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return android.requestNotificationsPermission();
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return ios.requestPermissions(alert: true, badge: true, sound: true);
    }

    final macos = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macos != null) {
      return macos.requestPermissions(alert: true, badge: true, sound: true);
    }

    // No platform implementation resolved: nothing gates posting here.
    return null;
  }

  @override
  Future<NotificationResponse?> takeInitialLaunchResponse() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    return details?.notificationResponse;
  }

  @override
  Future<void> show(TurnNotification notification) async {
    // Only app-proven assistant finals become conversations. Attention,
    // failures, tests and generic push hints keep their existing private path.
    final target = notification.conversation;
    if (target != null && defaultTargetPlatform == TargetPlatform.android) {
      if (!notificationKindEnabled(HermesNotificationKind.turnDone)) {
        throw StateError('Conversation disabled');
      }
      if (!target.isCurrent) throw StateError('Conversation account changed');
      final ticket = await AutoMessagingService.platform.invokeMethod<int>(
        'ticket',
        target.data,
      );
      if (ticket == null || !target.isCurrent) {
        throw StateError('Conversation account changed');
      }
      final locale = resolvePreferredLocale(
        PlatformDispatcher.instance.locales,
        AppLocalizations.supportedLocales,
      );
      final strings = lookupAppLocalizations(locale);
      final sent = await AutoMessagingService.platform
          .invokeMethod<bool>('show', {
            'id': notification.id,
            'title': notification.title,
            'body': notification.body,
            'replyLabel': strings.send,
            'readLabel': strings.ng_mark_as_read,
            'userLabel': strings.task_role_user,
            'channelLabel': notification.channel.name,
            ...target.data,
            'ticket': ticket,
          });
      if (sent != true) throw StateError('Conversation authority unavailable');
      return;
    }
    final details = turnNotificationDetails(notification);

    await _plugin.show(
      notification.id,
      notification.title,
      notification.body,
      details,
      payload: notification.payload,
    );
  }

  @override
  Future<void> cancel(int id) async {
    // Only terminal-namespace IDs can carry a native conversation (the native
    // poster rejects every other ID). Ongoing/attention cleanup must neither
    // depend on the car owner nor bump its ticket epoch for unrelated chats.
    final failure =
        defaultTargetPlatform == TargetPlatform.android &&
            id >= _conversationIdMin &&
            id <= _conversationIdMax
        ? await _fenceConversations('cancel', {'id': id})
        : null;
    // The ordinary record is independent cleanup: a missing or failing car
    // owner must never strand an ongoing/terminal notification.
    await _plugin.cancel(id);
    if (failure != null) Error.throwWithStackTrace(failure.$1, failure.$2);
  }

  @override
  Future<void> cancelAll() async {
    final failure = defaultTargetPlatform == TargetPlatform.android
        ? await _fenceConversations('cancelAll', null)
        : null;
    await _plugin.cancelAll();
    if (failure != null) Error.throwWithStackTrace(failure.$1, failure.$2);
  }

  static const _conversationIdMin = 0x10000000;
  static const _conversationIdMax = 0x1fffffff;

  /// Revokes native conversation authority. An engine without the car owner
  /// registered cannot have minted a conversation, so that is not a failure;
  /// any other error is returned for the caller to report AFTER ordinary
  /// cleanup, keeping the ID retained for a later retry.
  static Future<(Object, StackTrace)?> _fenceConversations(
    String method,
    Map<String, Object?>? arguments,
  ) async {
    try {
      await AutoMessagingService.platform.invokeMethod<void>(method, arguments);
      return null;
    } on MissingPluginException {
      return null;
    } catch (e, s) {
      return (e, s);
    }
  }
}

/// Delivers Android notifications when a gateway turn completes while the app
/// is backgrounded, mirroring the Hermes Desktop tray notification behaviour.
///
/// One app-wide sink owns terminal/attention channels and optional ongoing
/// per-chat status entries. Initialization is headless-safe; only foreground
/// callers explicitly opt in to requesting notification permission.
/// One notification Ares tried to post, kept for Settings' "Recent
/// notifications" so a missing one can be explained on the device itself.
@immutable
class NotificationAttempt {
  const NotificationAttempt({
    required this.at,
    required this.kind,
    required this.title,
    required this.outcome,
    this.detail,
    this.id,
    this.error,
  });

  final DateTime at;
  final String kind;

  /// This run only: titles are never stored. Empty for earlier runs.
  final String title;

  /// `posted`, `skipped` or `failed`; Windows clicks are `opened`.
  final String outcome;

  /// This run only: free text is never stored.
  final String? detail;

  /// The platform notification id, when one was assigned.
  final int? id;

  /// The failure's type and platform code (see
  /// [TurnNotificationService.errorClass]), never its message text.
  final String? error;

  /// Posted, or a Windows click that reached Ares.
  bool get succeeded => const {'posted', 'opened', 'focused'}.contains(outcome);

  /// `#id · error class`, empty when neither is known.
  String get reference => [if (id != null) '#$id', ?error].join(' · ');

  /// Stored fields only: no title, body or free-text detail.
  Map<String, Object> toJson() => {
    'at': at.millisecondsSinceEpoch,
    'kind': kind,
    'outcome': outcome,
    'id': ?id,
    'error': ?error,
  };

  static NotificationAttempt? fromJson(Object? json) {
    if (json case {
      'at': int at,
      'kind': String kind,
      'outcome': String outcome,
    }) {
      final id = json['id'], error = json['error'];
      return NotificationAttempt(
        at: DateTime.fromMillisecondsSinceEpoch(at),
        kind: kind,
        title: '',
        outcome: outcome,
        id: id is int ? id : null,
        error: error is String ? error : null,
      );
    }
    return null;
  }
}

class TurnNotificationService {
  /// The latest attempts, newest first (at most [maxAttempts]), including
  /// earlier runs' entries once [loadRecentAttempts] has read them.
  static final ValueNotifier<List<NotificationAttempt>> recentAttempts =
      ValueNotifier(const []);
  static const maxAttempts = 50;

  /// Kind, id, outcome and error class only; not in configuration backups.
  static const attemptsStorageKey = 'notification_attempts_v1';
  static Future<void>? _attemptsLoad;
  static bool _attemptsDirty = false, _attemptsWriting = false;

  static void recordAttempt(
    String kind,
    String title,
    String outcome, {
    String? detail,
    int? id,
    String? error,
  }) {
    recentAttempts.value = [
      NotificationAttempt(
        at: DateTime.now(),
        kind: kind,
        title: title,
        outcome: outcome,
        detail: detail,
        id: id,
        error: error,
      ),
      ...recentAttempts.value.take(maxAttempts - 1),
    ];
    _attemptsDirty = true;
    if (_attemptsWriting) return;
    _attemptsWriting = true;
    unawaited(_writeAttempts());
  }

  /// Adds the stored attempts of earlier runs once per process, after any
  /// recorded in this one. Diagnostics only: failures are ignored.
  static Future<void> loadRecentAttempts() => _attemptsLoad ??= _readAttempts();

  static Future<void> _readAttempts() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(
        attemptsStorageKey,
      );
      if (raw == null) return;
      final stored = (jsonDecode(raw) as List)
          .map(NotificationAttempt.fromJson)
          .nonNulls;
      recentAttempts.value = [
        ...recentAttempts.value,
        ...stored,
      ].take(maxAttempts).toList(growable: false);
    } catch (_) {
      // A missing or unreadable log never affects notifications.
    }
  }

  static Future<void> _writeAttempts() async {
    try {
      // Never replace an earlier run's log before it has been read.
      await loadRecentAttempts();
      while (_attemptsDirty) {
        _attemptsDirty = false;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          attemptsStorageKey,
          jsonEncode([
            for (final attempt in recentAttempts.value.take(maxAttempts))
              attempt.toJson(),
          ]),
        );
      }
    } catch (_) {
      // Diagnostics only. The next attempt writes the whole log again.
    } finally {
      _attemptsWriting = false;
    }
  }

  @visibleForTesting
  static void debugResetAttempts() {
    recentAttempts.value = const [];
    _attemptsLoad = null;
    _attemptsDirty = false;
    _attemptsWriting = false;
  }

  /// Fixed sink errors whose message is a known, content-free reason.
  static const _knownStateErrors = {
    'Notification disabled',
    'Notification superseded',
    'Notification withdrawn',
    'Toast ticket storage unavailable',
    'Windows notifications are off',
    'Ongoing notification bookkeeping unavailable',
    'Notifications belong to the primary window.',
  };
  static final _windowsError = RegExp(r'^Windows notification error (-?\d+)$');

  /// What kind of failure [error] was, without its message text, which on
  /// some platforms can carry notification content. Windows runner errors
  /// keep their HRESULT.
  static String errorClass(Object error) {
    switch (error) {
      case PlatformException(:final code, :final message):
        final hresult = _windowsError.firstMatch(message ?? '')?.group(1);
        if (hresult == null) return 'PlatformException($code)';
        final hex = (int.parse(hresult) & 0xffffffff).toRadixString(16);
        return 'PlatformException($code 0x${hex.padLeft(8, '0')})';
      case StateError(:final message) when _knownStateErrors.contains(message):
        return 'StateError($message)';
      default:
        return error.runtimeType.toString();
    }
  }

  /// Posts [notification], initialising first when an earlier start failed,
  /// and records what happened instead of failing silently.
  Future<bool> _post(String kind, TurnNotification notification) async {
    if (!_initialized) await ensureInitialized(refreshPermission: false);
    if (!_initialized) {
      recordAttempt(
        kind,
        notification.title,
        'failed',
        detail: 'not initialised',
        id: notification.id,
        error: 'NotInitialised',
      );
      return false;
    }
    try {
      await _sink.show(notification);
      recordAttempt(
        kind,
        notification.title,
        'posted',
        detail: _permissionGranted ? null : 'permission denied',
        id: notification.id,
      );
      return true;
    } catch (e) {
      recordAttempt(
        kind,
        notification.title,
        'failed',
        detail: '$e',
        id: notification.id,
        error: errorClass(e),
      );
      return false;
    }
  }

  static TurnNotificationChannel get turnChannel {
    final strings = notificationStrings();
    return TurnNotificationChannel(
      id: 'hermes_turn_notifications',
      name: strings.rel_svc_push_channel_turns_name,
      description: strings.rel_svc_push_channel_turns_description,
    );
  }

  /// Attention kinds get their own high-importance channel so approvals and
  /// input requests can surface as heads-up cards while the app is away.
  static TurnNotificationChannel get attentionChannel {
    final strings = notificationStrings();
    return TurnNotificationChannel(
      id: 'hermes_attention',
      name: strings.rel_svc_push_channel_attention_name,
      description: strings.rel_svc_push_channel_attention_description,
    );
  }

  /// Finished background work: quiet by design.
  static TurnNotificationChannel get backgroundChannel {
    final strings = notificationStrings();
    return TurnNotificationChannel(
      id: 'hermes_background',
      name: strings.rel_svc_push_channel_background_name,
      description: strings.rel_svc_push_channel_background_description,
    );
  }

  /// Gateway notices: credits and plugin messages.
  static TurnNotificationChannel get noticesChannel {
    final strings = notificationStrings();
    return TurnNotificationChannel(
      id: 'hermes_notices',
      name: strings.rel_svc_push_channel_notices_name,
      description: strings.rel_svc_push_channel_notices_description,
    );
  }

  /// Diagnostic details retain stable reason tokens, not translated text.
  /// Resolve them when rendering so retained attempts follow locale changes.
  /// Unknown platform/server text stays raw rather than being misclassified.
  static String localizedAttemptDetail(
    AppLocalizations strings,
    String detail,
  ) {
    if (detail.startsWith('conversation: ')) {
      return strings.rel_svc_push_diag_conversation_error(
        detail.substring('conversation: '.length),
      );
    }
    if (detail.endsWith(' is off')) {
      final kind = detail.substring(0, detail.length - ' is off'.length);
      if (HermesNotificationKind.values.any((value) => value.name == kind)) {
        return strings.rel_svc_push_diag_kind_off(kind);
      }
    }
    return switch (detail) {
      'not initialised' => strings.rel_svc_push_diag_not_initialised,
      'permission denied' => strings.rel_svc_notification_permission_denied,
      'replies are off' => strings.rel_svc_push_diag_replies_off,
      'conversation' => strings.rel_svc_push_diag_conversation,
      'conversation; permission denied' =>
        strings.rel_svc_push_diag_conversation_permission_denied,
      'failures are off' => strings.rel_svc_push_diag_failures_off,
      'Windows did not report its notification setting' =>
        strings.rel_svc_push_diag_windows_setting_unknown,
      'notifications are off' => strings.rel_svc_notifications_off,
      'Ares was on screen' => strings.ng_release_notification_foreground,
      'the turn was stopped' => strings.ng_release_notification_stopped,
      _ => detail,
    };
  }

  /// The app-wide instance used outside tests, so every dispatcher shares one
  /// plugin, one initialisation and one tap handler.
  static TurnNotificationService? _shared;

  static TurnNotificationService get shared =>
      _shared ??= TurnNotificationService();

  /// Swaps the app-wide instance (tests record what would be posted).
  @visibleForTesting
  static set debugShared(TurnNotificationService? service) => _shared = service;

  static TurnNotificationChannel get ongoingChannel {
    final locale = resolvePreferredLocale(
      PlatformDispatcher.instance.locales,
      AppLocalizations.supportedLocales,
    );
    final strings = lookupAppLocalizations(locale);
    return TurnNotificationChannel(
      id: 'hermes_ongoing_chats',
      name: strings.ongoing_chat_channel_name,
      description: strings.ongoing_chat_channel_description,
    );
  }

  /// Numeric IDs only: no titles, chat contents, credentials or routing data.
  /// Not included in configuration backups.
  static const ongoingIdsStorageKey = 'hermes_ongoing_chat_notification_ids';
  final Set<int> _ongoingIds = {};
  SharedPreferences? _ongoingPrefs;
  Future<void>? _ongoingTail;

  Future<void> _queueOngoing(Future<void> Function() operation) {
    final previous = _ongoingTail;
    final result = previous == null
        ? operation()
        : previous.then((_) => operation());
    late final Future<void> tail;
    void release() {
      if (identical(_ongoingTail, tail)) _ongoingTail = null;
    }

    tail = result.then<void>(
      (_) => release(),
      onError: (Object _, StackTrace _) => release(),
    );
    _ongoingTail = tail;
    return result;
  }

  Future<void> _persistOngoingIds() async {
    final prefs = _ongoingPrefs;
    if (prefs == null ||
        !await prefs.setStringList(
          ongoingIdsStorageKey,
          _ongoingIds.map((id) => id.toString()).toList()..sort(),
        )) {
      throw StateError('Ongoing notification bookkeeping unavailable');
    }
  }

  Future<void> _cleanOrphanedOngoingChats() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Optional ongoing entries need durable bookkeeping. Other notification
      // kinds remain usable if this store is unavailable.
      return;
    }
    _ongoingPrefs = prefs;
    final raw = prefs.get(ongoingIdsStorageKey);
    if (raw is List) {
      for (final value in raw) {
        final id = value is String ? int.tryParse(value) : null;
        // Never cancel native 4705, push or terminal entries, even if a
        // corrupt/imported preference names them.
        if (id != null && id >= 0x20000000 && id <= 0x2fffffff) {
          _ongoingIds.add(id);
        }
      }
    }
    for (final id in _ongoingIds.toList()) {
      await _cancel(id);
      _ongoingIds.remove(id);
    }
    if (raw != null) await _persistOngoingIds();
  }

  /// One replaceable, quiet entry per local chat, independent of turn/stored
  /// identity changes. The native service's mandatory disclosure is separate.
  Future<void> showOngoingChat({
    SavedConnection? origin,
    required String connectionId,
    required String localSessionId,
    String? storedSessionId,
    required String title,
    required String turnId,
    required String status,
  }) => _queueOngoing(() async {
    await ensureInitialized(refreshPermission: false);
    if (!_initialized) return;
    final id = ongoingChatNotificationIdFor(
      connectionId: connectionId,
      localSessionId: localSessionId,
    );
    if (!notificationPrefs.value.enabled || !_permissionGranted) {
      await _cancelOngoingId(id);
      return;
    }
    // If bookkeeping cannot be saved, do not create an uncleanable orphan.
    if (_ongoingPrefs == null) return;
    _ongoingIds.add(id);
    await _persistOngoingIds();
    if (!notificationPrefs.value.enabled || !_permissionGranted) {
      await _cancelOngoingId(id);
      return;
    }
    try {
      await _sink.show(
        TurnNotification(
          kind: null,
          windowsTarget: WindowsToastTarget.capture(
            origin,
            connectionId,
            storedSessionId ?? localSessionId,
          ),
          id: id,
          title: title,
          body: status,
          payload: jsonEncode({
            'connectionId': connectionId,
            'sessionId': storedSessionId?.isNotEmpty == true
                ? storedSessionId
                : localSessionId,
            'localSessionId': localSessionId,
            'turnId': turnId,
          }),
          channel: ongoingChannel,
          importance: TurnNotificationImportance.low,
          ongoing: true,
          silent: true,
          onlyAlertOnce: true,
        ),
      );
    } catch (e) {
      recordAttempt(
        'ongoing',
        title,
        'failed',
        detail: '$e',
        id: id,
        error: errorClass(e),
      );
      rethrow;
    }
    recordAttempt('ongoing', title, 'posted', id: id);
  });

  Future<void> cancelOngoingChat({
    required String connectionId,
    required String localSessionId,
  }) => _queueOngoing(() async {
    await ensureInitialized(refreshPermission: false);
    if (!_initialized) return;
    await _cancelOngoingId(
      ongoingChatNotificationIdFor(
        connectionId: connectionId,
        localSessionId: localSessionId,
      ),
    );
  });

  Future<void> _cancelOngoingId(int id) async {
    await _cancel(id);
    _ongoingIds.remove(id);
    if (_ongoingPrefs != null) await _persistOngoingIds();
  }

  /// Targeted cleanup only. Never calls the plugin's broad cancelAll, which
  /// could remove the foreground-service disclosure or attention notifications.
  Future<void> cancelAllOngoingChats() => _queueOngoing(() async {
    await ensureInitialized(refreshPermission: false);
    if (!_initialized) return;
    for (final id in _ongoingIds.toList()) {
      await _cancelOngoingId(id);
    }
  });

  /// The channel a [kind] posts on.
  static TurnNotificationChannel channelFor(HermesNotificationKind kind) =>
      switch (kind) {
        HermesNotificationKind.approval ||
        HermesNotificationKind.input => attentionChannel,
        HermesNotificationKind.turnDone ||
        HermesNotificationKind.turnError => turnChannel,
        HermesNotificationKind.backgroundDone => backgroundChannel,
        HermesNotificationKind.credits ||
        HermesNotificationKind.plugin => noticesChannel,
      };

  /// Visual urgency a [kind] posts with.
  static TurnNotificationImportance importanceFor(
    HermesNotificationKind kind,
  ) => switch (kind) {
    HermesNotificationKind.approval ||
    HermesNotificationKind.input => TurnNotificationImportance.high,
    HermesNotificationKind.backgroundDone => TurnNotificationImportance.low,
    _ => TurnNotificationImportance.defaultImportance,
  };

  final TurnNotificationSink _sink;

  /// Native conversation posts still awaiting their platform result. A
  /// targeted cancellation (or cancelAll) during that window supersedes the
  /// attempt, so a rejected conversation cannot fall back to an ordinary alert
  /// that would recreate a notification the app has already taken down.
  final Set<_ConversationFlight> _conversationFlights = {};

  bool _initialized = false;
  bool _permissionGranted = !isParkedAutomotive;
  bool _permissionRequested = false;
  Future<void>? _initializing;
  Future<void>? _requestingPermission;
  Future<void>? _refreshingAuthorization;
  int _permissionRevision = 0;
  int _authorizationDemand = 0;
  int _authorizationSatisfied = 0;

  TurnNotificationService({
    TurnNotificationSink? sink,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _sink = sink ?? defaultTurnNotificationSink(plugin: plugin);

  /// Whether the platform currently allows Hermes to post notifications.
  ///
  /// Refreshed by [ensureInitialized], including after returning from OS
  /// Settings. A denial or unavailable permission check is not a grant.
  bool get permissionGranted => _permissionGranted;

  /// Initialises once and passively refreshes current OS authorisation.
  ///
  /// Only explicit foreground callers may request permission, once after a
  /// successful platform request. Later checks never re-prompt, even after a
  /// denial. Failed platform operations degrade silently and may be retried.
  Future<void> ensureInitialized({
    bool requestPermission = false,
    bool refreshPermission = true,
  }) async {
    if (isParkedAutomotive) return;
    if (!_initialized) {
      final flight = _initializing ??= _initialize();
      try {
        await flight;
      } finally {
        if (identical(_initializing, flight)) _initializing = null;
      }
    }
    // Background/headless callers never ask for UI permission. The foreground
    // app root or Settings explicitly opts in, even after headless init.
    if (!_initialized) return;
    if (requestPermission && !_permissionRequested) {
      final flight = _requestingPermission ??= _requestPermission();
      try {
        await flight;
      } finally {
        if (identical(_requestingPermission, flight)) {
          _requestingPermission = null;
        }
      }
    } else if (refreshPermission) {
      await refreshAuthorization();
    }
  }

  Future<void> _initialize() async {
    unawaited(loadRecentAttempts());
    try {
      await _sink.initialize();
      await _cleanOrphanedOngoingChats();
      _initialized = true;
    } catch (_) {
      // Missing plugins must not break startup; a later call may retry.
      return;
    }
    await pruneCompletionChannels();
  }

  /// Android locks a channel's sound when it is created, so each completion
  /// choice posts on its own channel. Deletes the choice channels the current
  /// choice does not use, so they do not pile up in the system settings.
  /// Called when the choice changes and on startup.
  Future<void> pruneCompletionChannels() async {
    final sink = _sink;
    if (sink is! TurnNotificationChannelCleaner ||
        defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    final cleaner = sink as TurnNotificationChannelCleaner;
    final keep = CompletionCue.channelSuffixFor(
      notificationPrefs.value.completionSound,
    );
    for (final suffix in CompletionCue.choiceSuffixes) {
      if (suffix == keep) continue;
      try {
        await cleaner.deleteChannel('${turnChannel.id}_$suffix');
      } catch (_) {
        // A channel that cannot be deleted now is retried next time.
      }
    }
  }

  Future<void> _requestPermission() async {
    ++_permissionRevision;
    try {
      _permissionGranted = await _sink.requestPermission() ?? true;
      _permissionRequested = true;
    } catch (_) {
      // Unknown is not a grant. Allow an explicit foreground retry later.
      _permissionGranted = false;
    }
  }

  /// Foreground resume/Settings may observe grants or revocations made in OS
  /// settings. Refreshing is separate from the one-shot permission prompt:
  /// denial never causes repeated dialogs, and headless initialization does
  /// neither. Join an active prompt and fence older passive results behind it.
  Future<void> refreshAuthorization() async {
    if (isParkedAutomotive) return;
    // Register demand before initialization awaits. Joining an older platform
    // read is not evidence about an OS change observed by a later caller.
    ++_authorizationDemand;
    if (!_initialized) {
      final flight = _initializing ??= _initialize();
      try {
        await flight;
      } finally {
        if (identical(_initializing, flight)) _initializing = null;
      }
    }
    if (!_initialized) return;
    final request = _requestingPermission;
    if (request != null) await request;
    // Coalesce callers before each read, but drain a fresh trailing read when
    // demand arrives after its snapshot. The watermark also covers callers
    // joining a completed flight before its finalizer has cleared the slot.
    while (_authorizationSatisfied < _authorizationDemand) {
      final flight = _refreshingAuthorization ??= _refreshAuthorization();
      try {
        await flight;
      } finally {
        if (identical(_refreshingAuthorization, flight)) {
          _refreshingAuthorization = null;
        }
      }
    }
  }

  Future<void> _refreshAuthorization() async {
    final demand = _authorizationDemand;
    final revision = _permissionRevision;
    var granted = false;
    try {
      granted = await _sink.checkPermission() ?? true;
    } catch (_) {
      // An unavailable permission read is not a grant.
    }
    if (revision == _permissionRevision && demand == _authorizationDemand) {
      _permissionGranted = granted;
    }
    // A newer explicit prompt owns permission; do not let this passive caller
    // finish against the old cache while that prompt is still unresolved.
    final request = _requestingPermission;
    if (request != null) await request;
    _authorizationSatisfied = demand;
  }

  /// Posts a notification when a gateway turn completes while the app is
  /// backgrounded.
  ///
  /// [turnSummary] is a short description (e.g. session title or prompt
  /// excerpt); [turnId] ensures the notification is stable and replaceable.
  /// [sessionId]/[connectionId] are carried in the payload so a tap can route
  /// back to the originating chat, even across multiple connections.
  Future<void> showTurnCompleted({
    SavedConnection? origin,
    required String title,
    required String turnSummary,
    required String turnId,
    String? sessionId,
    String? connectionId,
    ConversationNotificationTarget? conversation,
  }) async {
    if (!notificationKindEnabled(HermesNotificationKind.turnDone)) {
      recordAttempt('reply', title, 'skipped', detail: 'replies are off');
      return;
    }
    final identity = _turnIdentity(
      turnId: turnId,
      sessionId: sessionId,
      connectionId: connectionId,
    );
    // Replayed settlement callbacks must not alert repeatedly.
    if (_throttled('${HermesNotificationKind.turnDone.name}:$identity')) {
      return;
    }

    final notification = TurnNotification(
      kind: HermesNotificationKind.turnDone,
      windowsTarget: WindowsToastTarget.capture(
        origin,
        connectionId,
        sessionId,
      ),
      id: notificationIdFor(identity),
      title: title,
      body: turnSummary,
      payload: _turnPayload(
        turnId: turnId,
        sessionId: sessionId,
        connectionId: connectionId,
      ),
      channel: turnChannel,
    );
    // A car conversation stands in for this alert only when the native owner
    // accepts it: when that owner is absent or rejects the post, keep the
    // existing ordinary notification rather than losing the alert.
    if (conversation != null &&
        await _postConversation('reply', notification, conversation) !=
            _ConversationPost.unavailable) {
      return;
    }
    await _post('reply', notification);
  }

  /// Posts an application-owned classic final as a native car conversation.
  ///
  /// Returns true when the alert is handled: the conversation was posted, a
  /// replay was throttled, replies are off, or a targeted cancellation
  /// superseded it. Returns false when the conversation owner is unavailable
  /// or rejected the post, so the caller keeps its existing generic alert.
  Future<bool> showConversationReply({
    required String title,
    required String body,
    required String turnId,
    required ConversationNotificationTarget conversation,
    String? sessionId,
    String? connectionId,
  }) async {
    if (!notificationKindEnabled(HermesNotificationKind.turnDone)) {
      recordAttempt('reply', title, 'skipped', detail: 'replies are off');
      return true;
    }
    final identity = _turnIdentity(
      turnId: turnId,
      sessionId: sessionId,
      connectionId: connectionId,
    );
    if (_throttled('${HermesNotificationKind.turnDone.name}:$identity')) {
      return true;
    }
    return await _postConversation(
          'reply',
          TurnNotification(
            id: notificationIdFor(identity),
            title: title,
            body: body,
            payload: _turnPayload(
              turnId: turnId,
              sessionId: sessionId,
              connectionId: connectionId,
            ),
            channel: turnChannel,
          ),
          conversation,
        ) !=
        _ConversationPost.unavailable;
  }

  Future<_ConversationPost> _postConversation(
    String kind,
    TurnNotification notification,
    ConversationNotificationTarget conversation,
  ) async {
    if (defaultTargetPlatform != TargetPlatform.android ||
        !AutoMessagingService.ownerAvailable) {
      return _ConversationPost.unavailable;
    }
    if (!_initialized) await ensureInitialized(refreshPermission: false);
    if (!_initialized) return _ConversationPost.unavailable;
    final flight = _ConversationFlight(notification.id);
    _conversationFlights.add(flight);
    try {
      await _sink.show(
        TurnNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
          channel: notification.channel,
          actions: notification.actions,
          importance: notification.importance,
          ongoing: notification.ongoing,
          silent: notification.silent,
          onlyAlertOnce: notification.onlyAlertOnce,
          conversation: conversation,
        ),
      );
      recordAttempt(
        kind,
        notification.title,
        'posted',
        detail: _permissionGranted
            ? 'conversation'
            : 'conversation; permission denied',
        id: notification.id,
      );
      return _ConversationPost.posted;
    } catch (e) {
      recordAttempt(
        kind,
        notification.title,
        'failed',
        detail: 'conversation: $e',
        id: notification.id,
        error: errorClass(e),
      );
      return flight.superseded
          ? _ConversationPost.superseded
          : _ConversationPost.unavailable;
    } finally {
      _conversationFlights.remove(flight);
    }
  }

  /// Every cancellation goes through here so an in-flight conversation post
  /// for the same ID cannot later fall back to an ordinary alert.
  Future<void> _cancel(int id) {
    if (isParkedAutomotive) return Future.value();
    for (final flight in _conversationFlights) {
      if (flight.id == id) flight.superseded = true;
    }
    return _sink.cancel(id);
  }

  /// Frozen account provenance at the producer, not a lookup from the currently
  /// selected connection when a delayed notification finally posts.
  static ConversationNotificationTarget? conversationTarget(
    ConnectionManager manager,
    SavedConnection connection,
    String? sessionId,
  ) {
    // Car conversations are an Android notification feature only; other
    // platforms keep their existing ordinary alerts.
    if (defaultTargetPlatform != TargetPlatform.android ||
        sessionId == null ||
        sessionId.isEmpty ||
        sessionId == '__new__' ||
        !ConnectionMutationBarrier.isCurrent(
          connection.id,
          ConnectionMutationBarrier.capture(connection.id),
        )) {
      return null;
    }
    final metadata = manager.mobilePushConsentMetadata(connection.id);
    if (metadata == null) return null;
    return ConversationNotificationTarget(manager, connection, {
      'connectionId': connection.id,
      'sessionId': sessionId,
      'binding': MobilePushService.binding(connection),
      'metadata': metadata,
    });
  }

  /// Cancels a specific turn notification.
  Future<void> cancelTurnCompleted(
    String turnId, {
    String? sessionId,
    String? connectionId,
  }) async {
    if (!_initialized) return;
    await _cancel(
      notificationIdFor(
        _turnIdentity(
          turnId: turnId,
          sessionId: sessionId,
          connectionId: connectionId,
        ),
      ),
    );
  }

  /// Posts the failure counterpart of [showTurnCompleted] on the same channel,
  /// so the two kinds share one Android channel but keep separate toggles.
  Future<void> showTurnFailed({
    SavedConnection? origin,
    required String title,
    required String turnSummary,
    required String turnId,
    String? sessionId,
    String? connectionId,
  }) async {
    if (!notificationKindEnabled(HermesNotificationKind.turnError)) {
      recordAttempt('failure', title, 'skipped', detail: 'failures are off');
      return;
    }
    final identity = _turnIdentity(
      turnId: turnId,
      sessionId: sessionId,
      connectionId: connectionId,
    );
    // Replayed settlement callbacks must not alert repeatedly.
    if (_throttled('${HermesNotificationKind.turnError.name}:$identity')) {
      return;
    }

    await _post(
      'failure',
      TurnNotification(
        kind: HermesNotificationKind.turnError,
        windowsTarget: WindowsToastTarget.capture(
          origin,
          connectionId,
          sessionId,
        ),
        id: notificationIdFor(identity),
        title: title,
        body: turnSummary,
        payload: _turnPayload(
          turnId: turnId,
          sessionId: sessionId,
          connectionId: connectionId,
        ),
        channel: turnChannel,
      ),
    );
  }

  /// JSON payload so a tap can route back to the originating chat, even
  /// across multiple connections.
  static String _turnPayload({
    required String turnId,
    String? sessionId,
    String? connectionId,
  }) => jsonEncode({
    'turnId': turnId,
    if (sessionId != null && sessionId.isNotEmpty) 'sessionId': sessionId,
    if (connectionId != null && connectionId.isNotEmpty)
      'connectionId': connectionId,
  });

  static String _turnIdentity({
    required String turnId,
    String? sessionId,
    String? connectionId,
  }) => jsonEncode([connectionId ?? '', sessionId ?? '', turnId]);

  // De-dupe replayed events for the same full event identity. Self-evicting:
  // entries older than the window are pruned on every dispatch, so the map
  // can't grow.
  static const _throttleWindowMs = 1000;
  final Map<String, int> _lastFiredAt = {};

  bool _throttled(String key) {
    final now = DateTime.now().millisecondsSinceEpoch;
    _lastFiredAt.removeWhere((_, at) => now - at >= _throttleWindowMs);
    if (_lastFiredAt.containsKey(key)) return true;
    _lastFiredAt[key] = now;
    return false;
  }

  /// Posts one native notification for [kind] when the device allows it.
  ///
  /// Callers gate on the app being backgrounded; this method enforces the
  /// user's per-kind preferences and the 1s replay throttle. Returns whether
  /// the notification was handed to the platform. [onlyAlertOnce] updates one
  /// already up for the same identity in place, without alerting again.
  Future<bool> showKind({
    required HermesNotificationKind kind,
    SavedConnection? origin,
    required String title,
    required String body,
    required String eventId,
    String? sessionId,
    String? connectionId,
    List<TurnNotificationAction> actions = const [],
    String? payload,
    bool onlyAlertOnce = false,
    bool Function()? windowsStillNeeded,
  }) async {
    if (!notificationKindEnabled(kind)) {
      recordAttempt(kind.name, title, 'skipped', detail: '${kind.name} is off');
      return false;
    }

    final identity = jsonEncode([
      kind.name,
      connectionId ?? '',
      sessionId ?? '',
      eventId,
    ]);
    // An in-place update is silent: the replay throttle is for new alerts.
    if (!onlyAlertOnce && _throttled(identity)) return false;

    return _post(
      kind.name,
      TurnNotification(
        kind: kind,
        windowsTarget: WindowsToastTarget.capture(
          origin,
          connectionId,
          sessionId,
        ),
        id: notificationIdFor(identity),
        title: title,
        body: body,
        payload: payload ?? '',
        windowsStillNeeded: windowsStillNeeded,
        channel: channelFor(kind),
        actions: actions,
        importance: importanceFor(kind),
        onlyAlertOnce: onlyAlertOnce,
      ),
    );
  }

  /// Takes down what [showKind] posted for the same identity: a request that
  /// was answered or withdrawn, or anything once the app is back in sight.
  Future<void> cancelKind({
    required HermesNotificationKind kind,
    required String eventId,
    String? sessionId,
    String? connectionId,
  }) async {
    if (!_initialized) return;
    final identity = jsonEncode([
      kind.name,
      connectionId ?? '',
      sessionId ?? '',
      eventId,
    ]);
    await _cancel(notificationIdFor(identity));
  }

  /// Settings "send test": bypasses gating like the desktop panel does, so a
  /// silent OS-level permission failure can be told apart from a dead feature.
  Future<bool> sendTestNotification({
    required String title,
    required String body,
  }) async {
    await ensureInitialized(requestPermission: true, refreshPermission: false);
    await refreshAuthorization();
    final id = notificationIdFor('hermes-notification-test');
    if (!_initialized || !_permissionGranted) {
      recordAttempt(
        'test',
        title,
        'failed',
        detail: _initialized ? 'permission denied' : 'not initialised',
        id: id,
        error: _initialized ? 'PermissionDenied' : 'NotInitialised',
      );
      return false;
    }

    try {
      await _sink.show(
        TurnNotification(
          id: id,
          title: title,
          body: body,
          payload: 'test',
          channel: turnChannel,
        ),
      );
      recordAttempt('test', title, 'posted', id: id);
      return true;
    } catch (e) {
      recordAttempt(
        'test',
        title,
        'failed',
        detail: '$e',
        id: id,
        error: errorClass(e),
      );
      return false;
    }
  }

  bool _initialLaunchConsumed = false;

  /// The tap or action that launched a terminated app, if any — consumed once
  /// so a cold start still routes to the originating chat.
  Future<NotificationResponse?> takeInitialNotificationResponse() async {
    if (isParkedAutomotive || _initialLaunchConsumed) return null;
    _initialLaunchConsumed = true;
    try {
      return await _sink.takeInitialLaunchResponse();
    } catch (_) {
      return null;
    }
  }

  /// Removes all Hermes turn notifications.
  Future<void> cancelAll() async {
    if (!_initialized) return;
    for (final flight in _conversationFlights) {
      flight.superseded = true;
    }
    await _sink.cancelAll();
  }

  /// Stable, non-negative Android notification id derived from [turnId].
  ///
  /// Masking instead of negating keeps the id inside the 31-bit range Android
  /// accepts, and keeps one turn mapped to exactly one notification so a turn
  /// replaces its own notification instead of stacking duplicates.
  static int notificationIdFor(String turnId) =>
      0x10000000 | _stableHash(turnId);

  /// The local id remains stable when a draft gains its canonical stored id.
  static int ongoingChatNotificationIdFor({
    required String connectionId,
    required String localSessionId,
  }) => 0x20000000 | _stableHash(jsonEncode([connectionId, localSessionId]));

  // FNV-1a over UTF-8, explicitly bounded on every multiplication. Do not use
  // String.hashCode: the language does not guarantee it across processes.
  static int _stableHash(String identity) {
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode(identity)) {
      hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
    }
    return hash & 0x0fffffff;
  }
}

/// A notification tap or action, parsed from the platform response payload.
///
/// Current payloads are JSON (`sessionId`/`connectionId`/`requestId`); older
/// turn notifications carried a plain turn id, which parses to a route with
/// no routing fields.
@immutable
class NotificationRoute {
  final String? sessionId;
  final String? connectionId;
  final String? requestId;
  final String? actionId;
  final String? localSessionId;
  final String? turnId;
  final String? approvalAccount;
  final String? approvalMutation;

  const NotificationRoute({
    this.sessionId,
    this.connectionId,
    this.requestId,
    this.actionId,
    this.localSessionId,
    this.turnId,
    this.approvalAccount,
    this.approvalMutation,
  });

  static NotificationRoute fromResponse(NotificationResponse response) {
    String? sessionId;
    String? connectionId;
    String? requestId;
    String? localSessionId;
    String? turnId;
    String? approvalAccount;
    String? approvalMutation;
    final raw = response.payload;
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          sessionId = decoded['sessionId']?.toString();
          connectionId = decoded['connectionId']?.toString();
          requestId = decoded['requestId']?.toString();
          localSessionId = decoded['localSessionId']?.toString();
          turnId = decoded['turnId']?.toString();
          approvalAccount = decoded['approvalAccount'] as String?;
          approvalMutation = decoded['approvalMutation'] as String?;
        }
      } catch (_) {
        // A plain-string payload (older turns) carries only the turn id.
      }
    }
    return NotificationRoute(
      sessionId: sessionId,
      connectionId: connectionId,
      requestId: requestId,
      actionId: response.actionId,
      localSessionId: localSessionId,
      turnId: turnId,
      approvalAccount: approvalAccount,
      approvalMutation: approvalMutation,
    );
  }

  /// The approval choice an action press maps to, or null for a body tap.
  String? get approvalChoice => switch (actionId) {
    'approve' => 'once',
    'reject' => 'deny',
    _ => null,
  };
}

/// An approval a notification action could not answer directly — the request
/// belongs to an open chat's route-local gateway. That chat screen consumes
/// this and responds through its own gateway.
@immutable
class PendingNotificationApproval {
  /// The connection the notification named, so ids can never cross gateways.
  final String connectionId;
  final String sessionId;
  final String requestId;
  final String choice;

  /// Optional only for decoding/legacy fixture compatibility. Unscoped entries
  /// have no automatic-answer authority and are never admitted to the queue.
  final NotificationApprovalAuthority? authority;

  const PendingNotificationApproval({
    required this.connectionId,
    required this.sessionId,
    required this.requestId,
    required this.choice,
    this.authority,
  });
}

/// Approvals notification actions left behind for open chats to answer.
///
/// A list, not a single slot: several taps in a row (or two sessions on one
/// connection) must not overwrite each other. Entries stay until the owning
/// chat confirms the answer, so a cold start or a throw never loses a tap.
final ValueNotifier<List<PendingNotificationApproval>>
pendingNotificationApprovals = ValueNotifier(const []);

/// Queues only live captured authority; deduplication stays inside that exact
/// account/mutation/owner plus session/request, never across replacements.
void addPendingNotificationApproval(PendingNotificationApproval approval) {
  if (approval.authority?.isCurrent != true) return;
  prunePendingNotificationApprovals();
  final existing = pendingNotificationApprovals.value;
  final duplicate = existing.any(
    (item) =>
        item.connectionId == approval.connectionId &&
        item.sessionId == approval.sessionId &&
        item.requestId == approval.requestId &&
        item.authority?.sameCapture(approval.authority!) == true,
  );
  if (duplicate) return;
  pendingNotificationApprovals.value = [...existing, approval];
}

/// Removes [approval] once its owner confirmed it was answered.
void removePendingNotificationApproval(PendingNotificationApproval approval) {
  if (!pendingNotificationApprovals.value.any(
    (item) => identical(item, approval),
  )) {
    return;
  }
  pendingNotificationApprovals.value = [
    for (final item in pendingNotificationApprovals.value)
      if (!identical(item, approval)) item,
  ];
}

void prunePendingNotificationApprovals() {
  final existing = pendingNotificationApprovals.value;
  final current = existing
      .where((item) => item.authority?.isCurrent == true)
      .toList();
  if (current.length != existing.length) {
    pendingNotificationApprovals.value = current;
  }
}

final _answeringNotificationApprovals = <PendingNotificationApproval>{};

bool claimNotificationApproval(PendingNotificationApproval approval) {
  if (approval.authority?.isCurrent != true ||
      _answeringNotificationApprovals.any(
        (item) =>
            item.authority?.isCurrent == true &&
            item.connectionId == approval.connectionId &&
            item.sessionId == approval.sessionId &&
            item.requestId == approval.requestId &&
            item.authority!.sameCapture(approval.authority!),
      )) {
    return false;
  }
  return _answeringNotificationApprovals.add(approval);
}

void releaseNotificationApproval(PendingNotificationApproval approval) =>
    _answeringNotificationApprovals.remove(approval);

enum _ConversationPost { posted, superseded, unavailable }

class _ConversationFlight {
  _ConversationFlight(this.id);
  final int id;
  bool superseded = false;
}
