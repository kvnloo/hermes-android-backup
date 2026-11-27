import '../l10n/l10n.dart';
import '../l10n/service_strings.dart';

/// Prompts this client has not admitted yet.
///
/// Desktop 0.23.4 keeps this list in the composer and parks it on Stop or
/// Esc. A healthy gateway FIFO is a different queue: nothing here holds,
/// releases or reorders it. Classic persists the texts beside the draft;
/// reopening restores them parked and does not send them.
final class ClientHeldPrompt {
  ClientHeldPrompt(this.id, this.text);

  final String id;
  final String text;
}

final class ClientHeldQueue {
  final List<ClientHeldPrompt> entries = [];
  bool parked = false;
  var _sequence = 0;

  bool get isEmpty => entries.isEmpty;

  /// A newly typed prompt is fresh intent, so it lifts a park from an earlier
  /// Stop. It does not itself send.
  void enqueue(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    entries.add(ClientHeldPrompt('held-$_sequence', trimmed));
    _sequence += 1;
    parked = false;
  }

  /// Stop or Esc. An empty list cannot be parked, or a later prompt would
  /// inherit a stale hold.
  bool park() {
    if (entries.isEmpty) return false;
    parked = true;
    return true;
  }

  void unpark() => parked = false;

  /// Reopen. The texts come back parked, so nothing is sent until Resume or
  /// a row send.
  void restoreParked(Iterable<String> texts) {
    entries.clear();
    _sequence = 0;
    parked = false;
    for (final text in texts) {
      final trimmed = text.trim();
      if (trimmed.isEmpty) continue;
      entries.add(ClientHeldPrompt('held-$_sequence', trimmed));
      _sequence += 1;
    }
    parked = entries.isNotEmpty;
  }

  /// Next automatic drain. [skipId] is the row whose editor is open; later
  /// rows may still drain, in their original order. The entry stays until
  /// the send is accepted.
  ClientHeldPrompt? peekAuto({String? skipId}) {
    if (parked) return null;
    for (final entry in entries) {
      if (entry.id == skipId) continue;
      return entry;
    }
    return null;
  }

  bool promote(String id) {
    final index = entries.indexWhere((entry) => entry.id == id);
    if (index < 0) return false;
    if (index == 0) return true;
    entries.insert(0, entries.removeAt(index));
    return true;
  }

  /// [manual] is Resume, Enter or a row send: it lifts the park. An automatic
  /// drain leaves a park in place and takes nothing.
  ClientHeldPrompt? takeHead({required bool manual}) {
    if (entries.isEmpty) return null;
    if (!manual && parked) return null;
    final head = entries.removeAt(0);
    if (manual || entries.isEmpty) parked = false;
    return head;
  }

  bool remove(String id) {
    final before = entries.length;
    entries.removeWhere((entry) => entry.id == id);
    if (entries.isEmpty) parked = false;
    return entries.length != before;
  }

  bool edit(String id, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    final index = entries.indexWhere((entry) => entry.id == id);
    if (index < 0) return false;
    entries[index] = ClientHeldPrompt(id, trimmed);
    return true;
  }
}

String clientHeldQueueLabel({
  required int count,
  required bool parked,
  AppLocalizations? strings,
}) {
  final l10n = strings ?? serviceStrings;
  return parked
      ? l10n.release_core_client_queue_paused_count(count)
      : l10n.release_core_client_queue_count(count);
}

const heldPromptMissingMessage =
    'That unsent prompt is no longer in the queue.';
