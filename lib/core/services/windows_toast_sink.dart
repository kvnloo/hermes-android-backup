part of 'turn_notification_service.dart';

/// Captured by the producer, never parsed out of gateway event content or
/// inferred from whichever account happens to be on-screen later.
class WindowsToastTarget {
  const WindowsToastTarget(
    this.connectionId,
    this.sessionId,
    this.account,
    this.mutation,
  );
  final String connectionId, sessionId, account, mutation;
  static WindowsToastTarget? capture(
    SavedConnection? origin,
    String? id,
    String? session,
  ) {
    if (!isWindowsPlatform ||
        origin == null ||
        id != origin.id ||
        session == null ||
        session.isEmpty ||
        session.length > 512 ||
        session == '__new__' ||
        ConnectionMutationBarrier.isPending(origin.id)) {
      return null;
    }
    final scope = NotificationApprovalAuthority.origin(origin);
    return WindowsToastTarget(
      origin.id,
      session,
      scope['approvalAccount']!,
      scope['approvalMutation']!,
    );
  }

  bool matches(SavedConnection? connection) =>
      connection != null &&
      connection.id == connectionId &&
      NotificationApprovalAuthority.matchesOrigin(
        connection,
        account,
        mutation,
      );
  Map<String, String> toJson() => {
    'connection': connectionId,
    'session': sessionId,
    'account': account,
    'mutation': mutation,
  };
  static WindowsToastTarget? decode(Object? value) {
    if (value case {
      'connection': String id,
      'session': String session,
      'account': String account,
      'mutation': String mutation,
    }) {
      if (id.isNotEmpty &&
          session.isNotEmpty &&
          session != '__new__' &&
          session.length <= 512) {
        return WindowsToastTarget(id, session, account, mutation);
      }
    }
    return null;
  }
}

/// Windows can only navigate, never answer. Not an FLN action payload.
class WindowsToastResponse extends NotificationResponse {
  const WindowsToastResponse(this.target)
    : super(
        notificationResponseType: NotificationResponseType.selectedNotification,
      );
  final WindowsToastTarget target;
}

class WindowsToastSink implements TurnNotificationSink {
  static const channel = MethodChannel('ares/windows_toast');
  static const ledgerKey = WindowsToastLedger.key;
  static final _ticket = RegExp(r'^[a-f0-9]{32}$');
  static const retention = Duration(days: 3);
  static const maxEntries = 256;
  Future<T> _serialized<T>(Future<T> Function() op) =>
      WindowsToastLedger.serialized(op);

  /// Kind, id, outcome and error class only, never a ticket or text.
  static void _record(
    String kind,
    String outcome, {
    int? id,
    String? detail,
    Object? error,
    String? errorClass,
  }) => TurnNotificationService.recordAttempt(
    kind,
    '',
    outcome,
    detail: detail,
    id: id,
    error:
        errorClass ??
        (error == null ? null : TurnNotificationService.errorClass(error)),
  );

  @override
  Future<void> initialize() async {}
  @override
  Future<bool> checkPermission() async =>
      await channel.invokeMethod<bool>('permission') == true;
  // Windows has no runtime prompt: only the user can change OS settings.
  @override
  Future<bool> requestPermission() => checkPermission();

  Map<String, dynamic> _read(SharedPreferences prefs) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final raw = prefs.getString(ledgerKey);
    if (raw == null) return {};
    final entries = jsonDecode(raw) as Map<String, dynamic>;
    entries.removeWhere(
      (_, row) =>
          row is! Map ||
          row['expires'] is! int ||
          (row['expires'] as int) <= now,
    );
    return entries;
  }

  /// Starts every read/modify/write from accepted state, under the lock.
  /// Other stores reload the same process-wide preferences cache outside this
  /// lock: a reload whose snapshot predates a ledger write can complete after
  /// it and roll the new ticket out of the cache, so the next write would
  /// persist the ledger without it. The platform store keeps every accepted
  /// write, so reread it first.
  Future<Map<String, dynamic>> _load(SharedPreferences prefs) async {
    await prefs.reload();
    return _read(prefs);
  }

  Future<void> _save(
    SharedPreferences prefs,
    Map<String, dynamic> entries,
  ) async {
    if (!await prefs.setString(ledgerKey, jsonEncode(entries))) {
      throw StateError('Toast ticket storage unavailable');
    }
  }

  /// Best effort: puts tickets back for a toast Windows may still show.
  Future<void> _restore(
    SharedPreferences prefs,
    Map<String, dynamic> rows,
  ) async {
    if (rows.isEmpty) return;
    try {
      await _save(prefs, (await _load(prefs))..addAll(rows));
    } catch (_) {
      // Nothing more to do; the next ledger write starts from disk again.
    }
  }

  /// Takes [rows] out of the ledger, then toast [id] off the screen. The ledger
  /// goes first so a click queued behind this lock cannot use a withdrawn
  /// ticket. If Windows cannot confirm the removal the toast may still be
  /// visible, so its ticket goes back rather than leaving a dead toast.
  Future<void> _withdraw(
    SharedPreferences prefs,
    Map<String, dynamic> rows,
    int id, {
    required bool native,
  }) async {
    try {
      final entries = await _load(prefs)
        ..removeWhere((token, _) => rows.containsKey(token));
      try {
        await _save(prefs, entries);
      } catch (_) {
        // Revocation is idempotent: retry the same snapshot once if storage
        // rejected or lost the write.
        await _save(prefs, entries);
      }
    } finally {
      if (native) {
        try {
          await channel.invokeMethod<void>('cancel', id);
        } catch (error) {
          _record('cancel', 'failed', id: id, error: error);
          await _restore(prefs, rows);
        }
      }
    }
  }

  @override
  Future<void> show(TurnNotification n) => _serialized(() async {
    final prefs = await SharedPreferences.getInstance();
    final kind = n.kind;
    final test = n.payload == 'test' && kind == null && !n.ongoing;
    if (!test &&
        (!notificationPrefs.value.enabled ||
            (kind != null && !notificationKindEnabled(kind)))) {
      throw StateError('Notification disabled');
    }
    // No gateway text, chat title, action buttons or raw event payload in OS history.
    final strings = lookupAppLocalizations(
      resolvePreferredLocale(
        PlatformDispatcher.instance.locales,
        AppLocalizations.supportedLocales,
      ),
    );
    final message = switch (kind) {
      HermesNotificationKind.turnDone => strings.response_complete,
      HermesNotificationKind.turnError => strings.turn_failed,
      HermesNotificationKind.approval => strings.approval_needed,
      HermesNotificationKind.input => strings.input_needed,
      HermesNotificationKind.backgroundDone =>
        strings.background_task_completed,
      HermesNotificationKind.plugin => strings.plugin_notifications,
      HermesNotificationKind.credits => strings.credit_notifications,
      null =>
        test
            ? strings.test_notification_body
            : strings.ongoing_chat_channel_name,
    };
    final target = n.windowsTarget;
    if (n.windowsStillNeeded?.call() == false ||
        (target != null &&
            !NotificationApprovalAuthority.isCurrentIssuer(
              target.connectionId,
              target.mutation,
            ))) {
      throw StateError('Notification superseded');
    }
    final entries = await _load(prefs);
    // Windows replaces a toast with the same tag, and its ticket goes with it.
    final replaced = entries.values.any((e) => e['id'] == n.id);
    entries.removeWhere((_, e) => e['id'] == n.id);
    final evicted = <int>{};
    while (entries.length >= maxEntries) {
      final row = entries.remove(entries.keys.first);
      if (row is Map && row['id'] is int) evicted.add(row['id'] as int);
    }
    final token = const Uuid().v4().replaceAll('-', '');
    entries[token] = {
      'id': n.id,
      'expires': DateTime.now().add(retention).millisecondsSinceEpoch,
      'kind': kind?.name,
      'test': test,
      if (n.windowsTarget != null) 'target': n.windowsTarget!.toJson(),
    };
    await _save(prefs, entries);
    // A toast whose ticket fell off the bounded ledger would be dead.
    for (final id in evicted) {
      if (entries.values.any((e) => e['id'] == id)) continue;
      try {
        await channel.invokeMethod<void>('cancel', id);
      } catch (_) {
        // Cancelling by id is idempotent; nothing else depends on it.
      }
    }
    // Once 'show' is invoked, Windows may have posted the toast even if the
    // call then fails. A replaced toast has likewise lost its ticket.
    var posted = replaced;
    try {
      if (n.windowsStillNeeded?.call() == false) {
        throw StateError('Notification withdrawn');
      }
      posted = true;
      final delivery = await channel.invokeMethod<String>('show', {
        'id': n.id,
        'ticket': token,
        'body': message,
        'quiet':
            n.onlyAlertOnce ||
            n.silent ||
            n.importance == TurnNotificationImportance.low,
        'sound': n.silent || n.onlyAlertOnce
            ? 'silent'
            : kind == HermesNotificationKind.turnDone || test
            ? notificationPrefs.value.completionSound.name
            : 'system',
      });
      // Windows accepted the toast, but its notification setting will not
      // display it: report a failure, not delivery. An unreadable setting
      // ('unknown') keeps the toast and its live ticket.
      if (delivery == 'blocked') {
        throw StateError('Windows notifications are off');
      }
      if (delivery == 'unknown') {
        _record(
          'setting',
          'unknown',
          id: n.id,
          detail: 'Windows did not report its notification setting',
          errorClass: 'SettingUnreadable',
        );
      }
      if (n.windowsStillNeeded?.call() == false) {
        throw StateError('Notification withdrawn');
      }
    } catch (_) {
      // Keep queued activations behind cleanup, and never leave a visible
      // toast without its ticket. Dismiss this exact id, never a sibling.
      try {
        await _withdraw(prefs, {token: entries[token]}, n.id, native: posted);
      } catch (_) {
        // Report why the post failed, not a secondary cleanup failure.
      }
      rethrow;
    }
  });

  Future<WindowsToastResponse?> _consume(Object? token) async {
    if (token is! String || token.length != 32 || !_ticket.hasMatch(token)) {
      return null;
    }
    return _serialized(() async {
      final prefs = await SharedPreferences.getInstance();
      final entries = await _load(prefs);
      final row = entries.remove(token);
      if (row is! Map) {
        // A click Windows delivered that no live ticket backs: consumed,
        // expired, revoked, or never stored. The ticket itself is not kept.
        _record('activation', 'failed', errorClass: 'UnknownTicket');
        return null;
      }
      final id = row['id'] is int ? row['id'] as int : null;
      await _save(
        prefs,
        entries,
      ); // one-shot, including across process restarts
      final kind = row['kind'];
      if (row['test'] != true &&
          (!notificationPrefs.value.enabled ||
              (kind != null &&
                  !HermesNotificationKind.values.any(
                    (k) => k.name == kind && notificationKindEnabled(k),
                  )))) {
        _record(
          'activation',
          'skipped',
          id: id,
          detail: 'notifications are off',
        );
        return null;
      }
      final target = WindowsToastTarget.decode(row['target']);
      final mutation = target == null
          ? null
          : NotificationApprovalAuthority.adoptWindowsMutation(
              target.connectionId,
              target.mutation,
            );
      await channel.invokeMethod<void>('focus');
      final opens = target != null && mutation != null;
      _record('activation', opens ? 'opened' : 'focused', id: id);
      if (!opens) return null;
      return WindowsToastResponse(
        WindowsToastTarget(
          target.connectionId,
          target.sessionId,
          target.account,
          mutation,
        ),
      );
    });
  }

  @override
  Future<NotificationResponse?> takeInitialLaunchResponse() async {
    channel.setMethodCallHandler((call) async {
      if (call.method != 'activate') return;
      final response = await _consume(call.arguments);
      if (response != null) notificationResponseHandler?.call(response);
    });
    return _consume(await channel.invokeMethod<String>('listen'));
  }

  @override
  Future<void> cancel(int id) => _serialized(() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await _load(prefs);
    final rows = {
      for (final MapEntry(:key, :value) in entries.entries)
        if (value['id'] == id) key: value,
    };
    if (rows.isNotEmpty) {
      entries.removeWhere((token, _) => rows.containsKey(token));
      await _save(prefs, entries);
    }
    try {
      await channel.invokeMethod<void>('cancel', id);
    } catch (error) {
      _record('cancel', 'failed', id: id, error: error);
      await _restore(prefs, rows);
      rethrow;
    }
  });
  @override
  Future<void> cancelAll() => _serialized(() async {
    final prefs = await SharedPreferences.getInstance();
    final rows = await _load(prefs);
    await _save(prefs, {});
    try {
      await channel.invokeMethod<void>('cancelAll');
    } catch (error) {
      _record('cancel', 'failed', error: error);
      await _restore(prefs, rows);
      rethrow;
    }
  });
}
