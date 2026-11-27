/// Pure host, schedule and memory-graph rules. Wire calls live on
/// [WorkspaceTarget] in `remote_workspace.dart`.
library;

/// A matching receipt is the only success signal. Process liveness and a zero
/// exit code do not promote a missing or foreign receipt.
enum HostUpdateVerdict { pending, success, partial, failed, refused, unknown }

class HostUpdateReceipt {
  const HostUpdateReceipt({
    required this.actionId,
    required this.outcome,
    this.followups = const [],
  });

  final String? actionId;
  final String outcome;
  final List<String> followups;
}

class HostUpdateEligibility {
  const HostUpdateEligibility({
    required this.installMethod,
    required this.currentVersion,
    required this.behind,
    required this.updateAvailable,
    required this.canApply,
    required this.held,
    required this.message,
  });

  final String installMethod;
  final String currentVersion;
  final int? behind;
  final bool updateAvailable;
  final bool canApply;
  final String? held;
  final String? message;
}

/// In-place apply is only the gateway's own git install, and only when that
/// install is actually behind and not held.
bool hostUpdateMayStart(HostUpdateEligibility eligibility) =>
    eligibility.installMethod == 'git' &&
    eligibility.canApply &&
    eligibility.held == null &&
    eligibility.updateAvailable;

HostUpdateVerdict judgeHostUpdate({
  required String actionId,
  required bool running,
  required HostUpdateReceipt? receipt,
}) {
  if (receipt == null || receipt.actionId != actionId) {
    return running ? HostUpdateVerdict.pending : HostUpdateVerdict.unknown;
  }
  final owes = receipt.followups.isNotEmpty;
  return switch (receipt.outcome) {
    'running' => HostUpdateVerdict.pending,
    'success' => owes ? HostUpdateVerdict.partial : HostUpdateVerdict.success,
    'partial' => HostUpdateVerdict.partial,
    'failed' => HostUpdateVerdict.failed,
    'refused' => HostUpdateVerdict.refused,
    _ => HostUpdateVerdict.unknown,
  };
}

/// View state only. Node labels, memory prose and identifiers are not encoded.
class MemoryLayout {
  const MemoryLayout({
    required this.zoom,
    required this.playback,
    required this.kind,
    required this.pinnedOnly,
  });

  static const zooms = <double>[1, 1.5, 2, 3, 4];
  static const kinds = {'all', 'skill', 'memory'};

  final double zoom;
  final int playback;
  final String kind;
  final bool pinnedOnly;

  String encode() {
    if (!zooms.contains(zoom) ||
        playback < 0 ||
        playback > 1000 ||
        !kinds.contains(kind)) {
      throw const FormatException('Invalid memory layout');
    }
    final code =
        'HML1|${zoom.toStringAsFixed(1)}|$playback|$kind|${pinnedOnly ? 1 : 0}';
    if (code.length > 32) throw const FormatException('Invalid memory layout');
    return code;
  }

  static MemoryLayout decode(String raw) {
    if (raw.length > 32 || raw.contains(' ')) {
      throw const FormatException('Invalid memory layout');
    }
    final parts = raw.split('|');
    if (parts.length != 5 || parts[0] != 'HML1') {
      throw const FormatException('Invalid memory layout');
    }
    final zoom = double.tryParse(parts[1]);
    final playback = int.tryParse(parts[2]);
    if (zoom == null ||
        !zooms.contains(zoom) ||
        playback == null ||
        !kinds.contains(parts[3]) ||
        (parts[4] != '0' && parts[4] != '1')) {
      throw const FormatException('Invalid memory layout');
    }
    return MemoryLayout(
      zoom: zoom,
      playback: playback,
      kind: parts[3],
      pinnedOnly: parts[4] == '1',
    );
  }
}

final _deliveryId = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,40}$');

/// Comma-separated scheduler targets. The last remaining target stays selected.
String toggleDeliveryTarget(String current, String id) {
  if (!_deliveryId.hasMatch(id)) {
    throw const FormatException('Invalid delivery target');
  }
  final selected = [
    for (final part in current.split(','))
      if (part.isNotEmpty) part,
  ];
  if (selected.any((part) => !_deliveryId.hasMatch(part))) {
    throw const FormatException('Invalid delivery target');
  }
  if (selected.contains(id)) {
    if (selected.length <= 1) return selected.join(',');
    selected.remove(id);
  } else {
    selected.add(id);
  }
  return selected.join(',');
}
