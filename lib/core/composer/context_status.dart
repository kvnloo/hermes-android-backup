import 'package:shared_preferences/shared_preferences.dart';

/// Status items that stay hidden until the user turns them on. Matches the
/// Desktop bar: cache, context, timers and throughput are diagnostics, not
/// the default chrome.
const kStatusHiddenByDefault = <String>{
  'cache-hit-rate',
  'context-usage',
  'running-timer',
  'session-timer',
  'tokens-per-second',
};

class StatusBarLayout {
  const StatusBarLayout(this.hidden);

  final Set<String> hidden;

  factory StatusBarLayout.defaults() =>
      StatusBarLayout(Set<String>.of(kStatusHiddenByDefault));

  bool visible(String id) => !hidden.contains(id);

  bool get isDefault {
    return hidden.length == kStatusHiddenByDefault.length &&
        kStatusHiddenByDefault.every(hidden.contains);
  }

  StatusBarLayout setVisible(String id, bool show) {
    final next = Set<String>.of(hidden);
    if (show) {
      next.remove(id);
    } else {
      next.add(id);
    }
    return StatusBarLayout(next);
  }

  StatusBarLayout reset() => StatusBarLayout.defaults();
}

const _statusLayoutKey = 'composer_status_hidden_v1';

/// The status bar the person chose, kept across launches (both layouts).
Future<StatusBarLayout> loadStatusLayout() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_statusLayoutKey);
    return saved == null
        ? StatusBarLayout.defaults()
        : StatusBarLayout(saved.toSet());
  } catch (_) {
    return StatusBarLayout.defaults();
  }
}

Future<void> saveStatusLayout(StatusBarLayout layout) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_statusLayoutKey, layout.hidden.toList()..sort());
  } catch (_) {
    // The choice still applies for this session.
  }
}

class ContextCategory {
  const ContextCategory({
    required this.id,
    required this.label,
    required this.tokens,
    this.color,
  });

  final String id;
  final String label;
  final int tokens;
  final String? color;
}

class ContextReading {
  const ContextReading({
    required this.categories,
    this.contextUsed,
    this.contextMax,
    this.contextPercent,
    this.estimated = false,
    this.usable = false,
  });

  final List<ContextCategory> categories;
  final int? contextUsed;
  final int? contextMax;
  final int? contextPercent;
  final bool estimated;

  /// False for a missing payload or a zeroed breakdown (no window and no
  /// categories). The meter stays dark instead of showing invented zeros.
  final bool usable;

  static const empty = ContextReading(categories: []);
}

class UsageReading {
  const UsageReading({
    this.cacheHitPct,
    this.avgTps,
    this.contextUsed,
    this.contextMax,
    this.contextPercent,
    this.estimated = false,
    this.compressions,
  });

  /// Present only when the payload sent `cache_hit_pct`. Zero is reported.
  final double? cacheHitPct;

  /// Present only when the payload sent `avg_tps`.
  final double? avgTps;
  final int? contextUsed;
  final int? contextMax;
  final int? contextPercent;
  final bool estimated;

  /// Present only when the payload sent `compressions`, including zero.
  final int? compressions;
}

int? _int(Object? value) {
  if (value is int) return value;
  if (value is num && value.isFinite) return value.round();
  return null;
}

double? _double(Object? value) {
  if (value is num && value.isFinite) return value.toDouble();
  return null;
}

/// Reads only fields the payload actually carried.
UsageReading parseUsageReading(Object? raw) {
  if (raw is! Map) return const UsageReading();
  final hasPercent = raw.containsKey('context_percent');
  final used = _int(raw['context_used'] ?? raw['context_tokens']);
  final max = _int(raw['context_max'] ?? raw['context_length']);
  int? percent = hasPercent ? _int(raw['context_percent']) : null;
  if (percent == null && used != null && max != null && max > 0) {
    percent = ((used / max) * 100).round().clamp(0, 100);
  }
  return UsageReading(
    cacheHitPct: raw.containsKey('cache_hit_pct')
        ? _double(raw['cache_hit_pct'])
        : null,
    avgTps: raw.containsKey('avg_tps') ? _double(raw['avg_tps']) : null,
    contextUsed: used,
    contextMax: max,
    contextPercent: percent,
    estimated: raw['context_estimated'] == true,
    compressions: raw.containsKey('compressions')
        ? _int(raw['compressions'])
        : null,
  );
}

ContextReading parseContextBreakdown(Object? raw) {
  if (raw is! Map) return ContextReading.empty;
  final categories = <ContextCategory>[];
  final listed = raw['categories'];
  if (listed is List) {
    for (final item in listed) {
      if (item is! Map) continue;
      final id = item['id'];
      final label = item['label'];
      final tokens = _int(item['tokens']);
      if (id is! String || id.isEmpty || label is! String || tokens == null) {
        continue;
      }
      final color = item['color'];
      categories.add(
        ContextCategory(
          id: id,
          label: label,
          tokens: tokens,
          color: color is String && color.isNotEmpty ? color : null,
        ),
      );
    }
  }
  final max = _int(raw['context_max']) ?? 0;
  final used = _int(raw['context_used']);
  if (max <= 0 && categories.isEmpty) return ContextReading.empty;
  final reportedPercent = raw.containsKey('context_percent')
      ? _int(raw['context_percent'])
      : null;
  final percent =
      reportedPercent ??
      (used != null && max > 0
          ? ((used / max) * 100).round().clamp(0, 100)
          : null);
  return ContextReading(
    categories: categories,
    contextUsed: used,
    contextMax: max > 0 ? max : null,
    contextPercent: percent,
    estimated: raw['context_estimated'] == true,
    usable: true,
  );
}

/// `87%` when reported, including zero. Empty when the field was omitted.
String cacheHitLabel(double? pct) {
  if (pct == null || !pct.isFinite) return '';
  return '${pct.round()}%';
}

/// `42 t/s` once a positive average was reported. Zero and omissions stay blank.
String tokensPerSecondLabel(double? tps) {
  if (tps == null || !tps.isFinite || tps <= 0) return '';
  return '${tps.round()} t/s';
}

String formatDuration(int elapsedMs) {
  final totalSeconds = elapsedMs <= 0 ? 0 : elapsedMs ~/ 1000;
  final seconds = totalSeconds % 60;
  final minutes = (totalSeconds ~/ 60) % 60;
  final hours = totalSeconds ~/ 3600;
  final ss = seconds.toString().padLeft(2, '0');
  final mm = minutes.toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$mm:$ss' : '$minutes:$ss';
}

String contextSummary(UsageReading usage) {
  final max = usage.contextMax;
  final used = usage.contextUsed;
  if (max == null || max <= 0 || used == null) return '';
  final mark = usage.estimated ? '~' : '';
  return '$mark$used/$max';
}
