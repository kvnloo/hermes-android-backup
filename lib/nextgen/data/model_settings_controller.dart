// Loads and changes the selected profile's model settings for the Models
// page: the default model, the fallback list and the helper-task models.
//
// Every change is read back from the gateway before it counts as saved, one
// change runs at a time, and an answer that arrives after the page has moved
// to another gateway or closed is dropped.
import 'package:flutter/foundation.dart';

import '../../core/models/fallback_config.dart';
import '../../core/services/connection_manager.dart';
import 'model_catalog.dart';

/// How a change ended.
sealed class NgModelSave {
  const NgModelSave();
}

class NgModelSaved extends NgModelSave {
  const NgModelSaved();
}

/// The gateway wants the user to agree to its warning first. Nothing changed.
class NgModelNeedsConfirmation extends NgModelSave {
  const NgModelNeedsConfirmation(this.message);
  final String message;
}

/// Not saved, or saved but not confirmed by reading it back.
class NgModelSaveFailed extends NgModelSave {
  const NgModelSaveFailed();
}

class NgModelSettingsController extends ChangeNotifier {
  NgModelSettingsController(this._client);

  final DashboardClient _client;
  int _generation = 0;
  bool _disposed = false;

  // Default model.
  NgMainModel? main;
  bool mainLoading = true;
  bool mainFailed = false;
  bool _routeVerified = false;
  bool _endpointRoute = false;

  // Providers and their models.
  NgModelCatalog? catalog;
  bool catalogLoading = true;
  bool catalogFailed = false;

  // Helper tasks.
  List<NgAuxTask>? auxTasks;
  bool auxLoading = true;
  bool auxFailed = false;

  // Fallback list.
  FallbackConfig? fallback;
  List<FallbackEntry> fallbackDraft = const [];
  bool fallbackLoading = true;
  bool fallbackFailed = false;

  /// A change is being saved and read back.
  bool saving = false;

  bool get loading =>
      mainLoading || catalogLoading || auxLoading || fallbackLoading;

  /// The default model's route was read and matches what `model/info` names.
  bool get routeVerified => _routeVerified;

  /// The default model runs on an endpoint set up on the gateway, or its
  /// route could not be confirmed. Either way it is not changed from here.
  bool get customRoute =>
      !_routeVerified || _endpointRoute || (main?.customEndpoint ?? true);

  bool get canChangeMain =>
      !saving &&
      !mainLoading &&
      !mainFailed &&
      main != null &&
      catalog != null &&
      !customRoute;

  bool get canEditFallbacks =>
      !saving && !fallbackLoading && !fallbackFailed && fallback != null;

  bool get canEditAux =>
      !saving && !auxLoading && !auxFailed && auxTasks != null;

  bool get fallbackDirty {
    final saved = fallback?.entries;
    if (saved == null || saved.length != fallbackDraft.length) {
      return saved != null;
    }
    for (var i = 0; i < saved.length; i++) {
      if (!_sameJson(saved[i].toJson(), fallbackDraft[i].toJson())) return true;
    }
    return false;
  }

  /// A fallback the app cannot rebuild: it carries routing details, or names
  /// a provider that is not in the list models are assigned from.
  bool fallbackLocked(FallbackEntry entry) =>
      entry.hasMetadata ||
      (catalog != null &&
          !catalog!.assignable.any((p) => p.slug == entry.provider));

  bool _alive(int generation) => !_disposed && generation == _generation;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }

  /// Reads everything again. Does nothing while a change is being saved, so
  /// a reload can never overtake a read-back.
  Future<void> load() async {
    if (saving || _disposed) return;
    // Edits to the fallback list that are not saved yet survive a refresh.
    final keepDraft = fallbackDirty;
    final generation = ++_generation;
    mainLoading = catalogLoading = auxLoading = fallbackLoading = true;
    mainFailed = catalogFailed = auxFailed = fallbackFailed = false;
    _notify();
    await Future.wait([
      _loadMain(generation),
      _loadCatalog(generation),
      _loadAux(generation),
      _loadFallback(generation, keepDraft),
    ]);
  }

  Future<void> _loadMain(int generation) async {
    try {
      final results = await Future.wait<Object?>([
        _client.getModelInfo(),
        _readRoute(),
      ]);
      if (!_alive(generation)) return;
      main = NgMainModel.fromInfo(results[0] as Map<String, dynamic>);
      _acceptRoute(results[1] as _Route?);
    } catch (_) {
      if (!_alive(generation)) return;
      mainFailed = true;
    }
    mainLoading = false;
    _notify();
  }

  Future<void> _loadCatalog(int generation) async {
    try {
      final data = await _client.getModelOptions();
      if (!_alive(generation)) return;
      catalog = NgModelCatalog.fromOptions(data);
    } catch (_) {
      if (!_alive(generation)) return;
      catalog = null;
      catalogFailed = true;
    }
    catalogLoading = false;
    _notify();
  }

  Future<void> _loadAux(int generation) async {
    try {
      final data = await _client.getAuxiliaryModels();
      if (!_alive(generation)) return;
      auxTasks = NgAuxTask.parseAll(data);
    } catch (_) {
      if (!_alive(generation)) return;
      auxTasks = null;
      auxFailed = true;
    }
    auxLoading = false;
    _notify();
  }

  Future<void> _loadFallback(int generation, bool keepDraft) async {
    try {
      final config = await _client.getFallbackConfig();
      if (!_alive(generation)) return;
      fallback = config;
      if (!keepDraft) fallbackDraft = config.entries.toList();
    } catch (_) {
      if (!_alive(generation)) return;
      // A list that cannot be read in full must not be left half editable.
      fallback = null;
      fallbackDraft = const [];
      fallbackFailed = true;
    }
    fallbackLoading = false;
    _notify();
  }

  // `model/info` leaves the endpoint out, so it cannot show that there is
  // none. Only the route the gateway reports for this profile can.
  Future<_Route?> _readRoute() async {
    try {
      final route = await _client.getMainModelRoute();
      return _Route(route.provider, route.model, route.hasEndpoint);
    } catch (_) {
      return null;
    }
  }

  void _acceptRoute(_Route? route) {
    _routeVerified =
        route != null &&
        route.provider == main?.provider &&
        route.model == main?.model;
    _endpointRoute = route?.hasEndpoint ?? false;
  }

  /// Makes [model] the profile's default. Pass [confirmed] only after the
  /// user has agreed to the warning from [NgModelNeedsConfirmation].
  Future<NgModelSave> setMain(
    String provider,
    String model, {
    bool confirmed = false,
  }) async {
    if (!canChangeMain || !catalog!.canAssign(provider, model)) {
      return const NgModelSaveFailed();
    }
    return _save((generation) async {
      final result = await _client.assignMainModel(
        provider,
        model,
        confirmExpensive: confirmed,
      );
      if (!_alive(generation)) return const NgModelSaveFailed();
      final refused = _refusal(result, confirmed);
      if (refused != null) return refused;
      final readback = await Future.wait<Object?>([
        _client.getModelInfo(),
        _readRoute(),
      ]);
      if (!_alive(generation)) return const NgModelSaveFailed();
      final info = NgMainModel.fromInfo(readback[0] as Map<String, dynamic>);
      if (info.provider != provider || info.model != model) {
        return const NgModelSaveFailed();
      }
      main = info;
      _acceptRoute(readback[1] as _Route?);
      return customRoute ? const NgModelSaveFailed() : const NgModelSaved();
    });
  }

  /// Sets a helper task's model. `auto` with an empty model returns it to
  /// the default model.
  Future<NgModelSave> setAux(
    String task,
    String provider,
    String model, {
    bool confirmed = false,
  }) => _writeAux(task, provider, model, confirmed: confirmed);

  /// Sets a helper task's thinking level and leaves its model as it is. Null
  /// goes back to the level the default model uses.
  Future<NgModelSave> setAuxEffort(
    String task,
    String? effort, {
    bool confirmed = false,
  }) {
    final row = _auxTask(task);
    if (row == null || !row.effortSupported) {
      return Future.value(const NgModelSaveFailed());
    }
    return _writeAux(
      task,
      row.provider,
      row.model,
      confirmed: confirmed,
      setEffort: true,
      effort: effort,
    );
  }

  NgAuxTask? _auxTask(String task) {
    for (final row in auxTasks ?? const <NgAuxTask>[]) {
      if (row.task == task) return row;
    }
    return null;
  }

  Future<NgModelSave> _writeAux(
    String task,
    String provider,
    String model, {
    bool confirmed = false,
    bool setEffort = false,
    String? effort,
  }) async {
    final current = _auxTask(task);
    final auto = provider == 'auto' && model.isEmpty;
    final unchangedRoute =
        current != null &&
        current.provider == provider &&
        current.model == model;
    if (!canEditAux ||
        current == null ||
        // Assigning over an endpoint would drop it on the gateway.
        current.endpoint ||
        (!auto &&
            !unchangedRoute &&
            !(catalog?.canAssign(provider, model) ?? false))) {
      return const NgModelSaveFailed();
    }
    return _save((generation) async {
      final result = await _client.assignAuxiliaryModel(
        task: task,
        provider: provider,
        model: model,
        confirmExpensive: confirmed,
        setReasoningEffort: setEffort,
        reasoningEffort: effort,
      );
      if (!_alive(generation)) return const NgModelSaveFailed();
      final refused = _refusal(result, confirmed);
      if (refused != null) return refused;
      final rows = NgAuxTask.parseAll(await _client.getAuxiliaryModels());
      if (!_alive(generation)) return const NgModelSaveFailed();
      auxTasks = rows;
      final saved = _auxTask(task);
      return saved != null &&
              saved.provider == provider &&
              saved.model == model &&
              (!setEffort || saved.effort == effort)
          ? const NgModelSaved()
          : const NgModelSaveFailed();
    });
  }

  // HTTP 200 with ok:false is a refusal, or a request to confirm an
  // expensive model. Neither is a save.
  NgModelSave? _refusal(Map<String, dynamic> result, bool confirmed) {
    if (result['ok'] == true) return null;
    final message = result['confirm_message'];
    if (!confirmed &&
        result['confirm_required'] == true &&
        message is String &&
        message.trim().isNotEmpty) {
      return NgModelNeedsConfirmation(message.trim());
    }
    return const NgModelSaveFailed();
  }

  /// Adds a fallback to the end of the draft. Nothing is sent until
  /// [saveFallbacks].
  bool addFallback(String provider, String model) {
    if (!canEditFallbacks ||
        !(catalog?.canAssign(provider, model) ?? false) ||
        fallbackDraft.any((e) => e.provider == provider && e.model == model)) {
      return false;
    }
    fallbackDraft = [
      ...fallbackDraft,
      FallbackEntry({'provider': provider, 'model': model}),
    ];
    _notify();
    return true;
  }

  void removeFallback(int index) {
    if (!canEditFallbacks || index < 0 || index >= fallbackDraft.length) return;
    fallbackDraft = [...fallbackDraft]..removeAt(index);
    _notify();
  }

  void moveFallback(int index, int by) {
    final to = index + by;
    if (!canEditFallbacks ||
        index < 0 ||
        index >= fallbackDraft.length ||
        to < 0 ||
        to >= fallbackDraft.length) {
      return;
    }
    final rows = [...fallbackDraft];
    rows.insert(to, rows.removeAt(index));
    fallbackDraft = rows;
    _notify();
  }

  void revertFallbacks() {
    if (!canEditFallbacks) return;
    fallbackDraft = fallback!.entries.toList();
    _notify();
  }

  /// Replaces the saved fallback list with the draft, in order. The draft is
  /// kept when the save cannot be confirmed.
  Future<NgModelSave> saveFallbacks() async {
    if (!canEditFallbacks || fallbackDraft.any((e) => !e.complete)) {
      return const NgModelSaveFailed();
    }
    final before = fallback!;
    final expected = List<FallbackEntry>.of(fallbackDraft);
    return _save((generation) async {
      if (!await _client.setFallbackProviders(expected)) {
        return const NgModelSaveFailed();
      }
      if (!_alive(generation)) return const NgModelSaveFailed();
      final actual = await _client.getFallbackConfig();
      if (!_alive(generation)) return const NgModelSaveFailed();
      if (!actual.confirms(expected, before)) return const NgModelSaveFailed();
      fallback = actual;
      fallbackDraft = actual.entries.toList();
      return const NgModelSaved();
    });
  }

  Future<NgModelSave> _save(
    Future<NgModelSave> Function(int generation) run,
  ) async {
    final generation = _generation;
    saving = true;
    _notify();
    NgModelSave result;
    try {
      result = await run(generation);
    } catch (_) {
      result = const NgModelSaveFailed();
    }
    if (_alive(generation)) {
      saving = false;
      _notify();
    }
    return result;
  }
}

class _Route {
  const _Route(this.provider, this.model, this.hasEndpoint);
  final String provider;
  final String model;
  final bool hasEndpoint;
}

bool _sameJson(Object? a, Object? b) {
  if (a is Map && b is Map) {
    return a.length == b.length &&
        a.keys.every((k) => b.containsKey(k) && _sameJson(a[k], b[k]));
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_sameJson(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}
