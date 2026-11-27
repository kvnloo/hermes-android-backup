/// Sandboxed renderer contract shared by Classic and NextGen.
///
/// A widget may ask the owning chat to continue, but only through a
/// token-matched intent that the user gestured and that names this widget's
/// opaque origin. Chat text is never evaluated as a program.
library;

const intentMessageType = 'hermes-inline-preview-intent';

/// Over-long intents are rejected whole. They are never sliced.
const maxIntentLength = 500;

/// One accepted intent per widget per second. Acceptance is stamped before
/// delivery starts, and nothing is accepted while a delivery is in flight.
const intentThrottleMs = 1000;

const minFrameHeight = 120;
const maxFrameHeight = 1200;

String opaqueWidgetOrigin(String widgetId) => 'opaque://widget/$widgetId';

sealed class IntentDecision {
  const IntentDecision();
}

class IntentAccepted extends IntentDecision {
  const IntentAccepted(this.prompt, {this.id});

  final String prompt;
  final int? id;
}

class IntentRejected extends IntentDecision {
  const IntentRejected(
    this.error, {
    this.id,
    this.maxLength,
    this.retryAfterMs,
  });

  /// `invalid`, `too_long`, `throttled`, `undelivered`, or `no_gesture`.
  final String error;
  final int? id;
  final int? maxLength;
  final int? retryAfterMs;
}

int? _intentId(Object? value) =>
    value is int && value.bitLength < 53 ? value : null;

/// Pure gate for a widget post. A wrong token or a foreign origin is ignored
/// (`null`) so the caller does not acknowledge a frame it does not own.
/// A matching frame always gets an explicit accept or reject.
IntentDecision? evaluateWidgetIntent({
  required Object? data,
  required String token,
  required int nowMs,
  required int lastAcceptedAtMs,
  required bool userGesture,
  required String origin,
  required String expectedOrigin,
  bool inFlight = false,
}) {
  if (data is! Map) return null;
  if (data['type'] != intentMessageType || data['token'] != token) {
    return null;
  }
  if (origin != expectedOrigin) return null;
  final id = _intentId(data['id']);
  if (!userGesture) {
    return IntentRejected('no_gesture', id: id);
  }
  final raw = data['prompt'];
  final prompt = raw is String ? raw.trim() : '';
  if (prompt.isEmpty) {
    return IntentRejected('invalid', id: id);
  }
  if (prompt.length > maxIntentLength) {
    return IntentRejected('too_long', id: id, maxLength: maxIntentLength);
  }
  if (inFlight) {
    return IntentRejected('throttled', id: id, retryAfterMs: intentThrottleMs);
  }
  if (lastAcceptedAtMs > 0) {
    final elapsed = nowMs - lastAcceptedAtMs;
    if (elapsed < intentThrottleMs) {
      return IntentRejected(
        'throttled',
        id: id,
        retryAfterMs: intentThrottleMs - elapsed,
      );
    }
  }
  return IntentAccepted(prompt, id: id);
}

/// Starting height from a directive attribute. Measurement may replace it.
int? directiveFrameHeight(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final parsed = int.tryParse(raw);
  if (parsed == null) return null;
  return parsed.clamp(minFrameHeight, maxFrameHeight);
}
