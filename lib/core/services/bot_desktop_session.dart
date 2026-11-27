import 'dart:async';

import 'package:flutter/foundation.dart';

import 'bot_display_rfb.dart';
import 'remote_workspace.dart';

/// Opens the byte pipe for one `display.observe` ticket. Tests pass a fake.
typedef BotDisplayConnector =
    Future<BotDisplayChannel> Function(
      WorkspaceTarget target,
      DisplayObserveResult observe,
    );

/// Why a take-over ended.
enum BotDesktopClose {
  /// The user handed back or left the viewer.
  handedBack,

  /// The app went to the background.
  background,

  /// Another person took the screen (bridge close code 4000).
  controlTaken,

  /// The live view dropped or failed.
  viewerLost,
}

/// One take-over of a bot's screen: the live viewer and the human lease, held
/// together. The lease is acquired only after the viewer shows the screen,
/// and is released whenever the viewer goes away, so the bot is never locked
/// out of a screen nobody can see or drive.
class BotDesktopSession extends ChangeNotifier {
  BotDesktopSession._(
    this.target,
    this.profile,
    this.viewerId,
    this.rfb,
    this._lease,
  );

  final WorkspaceTarget target;
  final String profile;

  /// The viewer id `display.observe` minted; the lease names it.
  final String viewerId;
  final BotDisplayRfb rfb;
  DisplayLease _lease;
  BotDesktopClose? _closedBecause;
  Future<void>? _closing;

  DisplayLease get lease => _lease;
  bool get isClosed => _closedBecause != null;
  BotDesktopClose? get closedBecause => _closedBecause;

  static Future<BotDisplayChannel> _connect(
    WorkspaceTarget target,
    DisplayObserveResult observe,
  ) => target.openDisplayChannel(observe);

  /// `display.observe`, the viewer socket and its RFB handshake, and only
  /// then `display.lease.acquire`. Any failure leaves the bot in control.
  static Future<BotDesktopSession> open(
    WorkspaceTarget target,
    String profile, {
    BotDisplayConnector? connect,
    String? reason,
  }) async {
    final observe = await target.displayObserve(profile);
    if (observe.viewerId.isEmpty || observe.ticket.isEmpty) {
      throw const WorkspaceException(WorkspaceFailure.invalid);
    }
    final channel = await (connect ?? _connect)(target, observe);
    final rfb = BotDisplayRfb(channel);
    final DisplayLease lease;
    try {
      await rfb.ready.timeout(const Duration(seconds: 12));
      lease = await target.displayLeaseAcquire(
        profile,
        observe.viewerId,
        reason: reason,
      );
    } catch (_) {
      await rfb.close();
      rethrow;
    }
    final session = BotDesktopSession._(
      target,
      profile,
      observe.viewerId,
      rfb,
      lease,
    );
    rfb.onClosed = session._onViewerClosed;
    if (rfb.isClosed) session._onViewerClosed(rfb.error);
    return session;
  }

  void _onViewerClosed(String? error) {
    unawaited(
      close(
        because: rfb.closeCode == 4000
            ? BotDesktopClose.controlTaken
            : BotDesktopClose.viewerLost,
      ),
    );
  }

  /// Hands control back and closes the viewer. Safe to call more than once;
  /// the release is on the wire before this returns its future.
  Future<void> close({BotDesktopClose because = BotDesktopClose.handedBack}) =>
      _closing ??= _close(because);

  Future<void> _close(BotDesktopClose because) async {
    _closedBecause = because;
    final released = _release();
    // The release is on the wire. Listeners hear next turn: close() is also
    // called from dispose, where a listener must not rebuild.
    await null;
    notifyListeners();
    await rfb.close();
    await released;
    notifyListeners();
  }

  Future<void> _release() async {
    try {
      _lease = await target.displayLeaseRelease(profile, viewerId: viewerId);
      return;
    } catch (_) {
      // A viewer id is only good on the connection that minted it: after a
      // reconnect the gateway refuses it. Fall through and check.
    }
    try {
      final status = await target.displayStatus(profile);
      _lease = status.lease;
      // Force only a lease that is still this viewer's own, never the lease
      // of whoever took the screen since.
      if (!status.lease.isAgent &&
          status.lease.viewerHash == botDisplayViewerHash(viewerId)) {
        _lease = await target.displayLeaseRelease(profile, force: true);
      }
    } catch (_) {}
  }
}
