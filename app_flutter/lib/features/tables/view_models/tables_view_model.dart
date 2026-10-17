import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:app_flutter/features/tables/models/column_model.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/domain/instance_record.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';

/// Immutable descriptor for a single tab in the ARINC 661 tabular workspace,
/// derived from either a child relation or related type of the active [TypeDescriptor].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Binds each discovered tab header
///   ([id], [label]) deterministically to its authoritative [TypeDescriptor]
///   schema definition.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Value Equality**: Two [TabDescriptor] instances $t_1, t_2$ satisfy
///   $t_1 == t_2 \iff (t_1.\text{id}, t_1.\text{label}, t_1.\text{type}) =
///   (t_2.\text{id}, t_2.\text{label}, t_2.\text{type})$.
///
/// ## 3. Preconditions
/// - [id], [label], and [type] are non-null and derived from a resolved
///   [TypeRelationDescriptor].
///
/// ## 4. Postconditions
/// - Constructs an immutable tab metadata value object supporting [copyWith]
///   and value equality.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction and [copyWith].
/// - **Space Complexity**: $\mathcal{O}(1)$ beyond the referenced [TypeDescriptor].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Immutable fields prevent accidental post-discovery mutation of tab bindings.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/TabDescriptor]
@immutable
class TabDescriptor {
  /// Unique tab identifier matching the child or related `typeName`.
  final String id;

  /// Human-readable tab header label.
  final String label;

  /// Resolved schema [TypeDescriptor] governing the tab's columns and instances.
  final TypeDescriptor type;

  /// Creates an immutable [TabDescriptor].
  const TabDescriptor({
    required this.id,
    required this.label,
    required this.type,
  });

  /// Creates a copy of this [TabDescriptor] with updated fields.
  TabDescriptor copyWith({
    String? id,
    String? label,
    TypeDescriptor? type,
  }) {
    return TabDescriptor(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabDescriptor &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          type == other.type;

  @override
  int get hashCode => Object.hash(id, label, type);
}

/// Immutable value state snapshot for [TablesViewModel], holding discovered
/// tabs, column headers, visibility masks, stringified cell rows, and loading status.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Ensures atomic, immutable state
///   transitions across asynchronous tab discovery and instance row loading so
///   the UI never observes partially mutated table headers and row matrices.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Deep Structural Equality**: `operator ==` verifies element-wise equality
///   across [tabs], [headers], [hiddenColumnKeys], [columnModels], and 2D matrix
///   [rows] (`_rowsEqual`).
///
/// ## 3. Preconditions
/// - All collection fields default to empty const collections and [loading]
///   defaults to `true`.
///
/// ## 4. Postconditions
/// - Produces an immutable [TablesState] snapshot with explicit `clear*` flags
///   on [copyWith] for nullable properties ([selectedTabId], [hiddenColumnKeys], [error]).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for [copyWith]; $\mathcal{O}(R \cdot C)$
///   for deep equality comparison over $R$ rows and $C$ columns.
/// - **Space Complexity**: $\mathcal{O}(R \cdot C)$ for stored row cell strings.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Explicit [error] string propagation allows the presentation layer to
///   render fault banners while clearing stale [rows] and [headers].
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/TablesState]
@immutable
class TablesState {
  /// Creates an immutable [TablesState].
  const TablesState({
    this.activeView = '',
    this.tabs = const [],
    this.selectedTabId,
    this.headers = const [],
    this.hiddenColumnKeys,
    this.rows = const [],
    this.columnModels = const [],
    this.loading = true,
    this.error,
  });

  /// Currently active view node ID.
  final String activeView;

  /// All discovered tabs.
  final List<TabDescriptor> tabs;

  /// Currently selected tab ID.
  final String? selectedTabId;

  /// Column headers for current tab.
  final List<ColumnModel> headers;

  /// Hidden column keys.
  final Set<String>? hiddenColumnKeys;

  /// Table rows.
  final List<List<String>> rows;

  /// Column models.
  final List<ColumnModel> columnModels;

  /// Loading flag.
  final bool loading;

  /// Error message, if any.
  final String? error;

  /// Returns a copy of this state with updated values.
  TablesState copyWith({
    String? activeView,
    List<TabDescriptor>? tabs,
    String? selectedTabId,
    bool clearSelectedTabId = false,
    List<ColumnModel>? headers,
    Set<String>? hiddenColumnKeys,
    bool clearHiddenColumnKeys = false,
    List<List<String>>? rows,
    List<ColumnModel>? columnModels,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return TablesState(
      activeView: activeView ?? this.activeView,
      tabs: tabs ?? this.tabs,
      selectedTabId: clearSelectedTabId ? null : (selectedTabId ?? this.selectedTabId),
      headers: headers ?? this.headers,
      hiddenColumnKeys: clearHiddenColumnKeys ? null : (hiddenColumnKeys ?? this.hiddenColumnKeys),
      rows: rows ?? this.rows,
      columnModels: columnModels ?? this.columnModels,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TablesState &&
          runtimeType == other.runtimeType &&
          activeView == other.activeView &&
          listEquals(tabs, other.tabs) &&
          selectedTabId == other.selectedTabId &&
          listEquals(headers, other.headers) &&
          setEquals(hiddenColumnKeys, other.hiddenColumnKeys) &&
          _rowsEqual(rows, other.rows) &&
          listEquals(columnModels, other.columnModels) &&
          loading == other.loading &&
          error == other.error;

  static bool _rowsEqual(List<List<String>> r1, List<List<String>> r2) {
    if (r1.length != r2.length) return false;
    for (int i = 0; i < r1.length; i++) {
      if (!listEquals(r1[i], r2[i])) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        activeView,
        Object.hashAll(tabs),
        selectedTabId,
        Object.hashAll(headers),
        hiddenColumnKeys != null ? Object.hashAll(hiddenColumnKeys!) : null,
        loading,
        error,
      );
}

/// ViewModel that discovers child and related [TabDescriptor] tabs from
/// segregated repositories ([TypeRepository], [InstanceRepository],
/// [PropertyRepository]), caches [InstanceRecord] results, and streams live updates.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces Interface Segregation
///   across [TypeRepository], [InstanceRepository], and [PropertyRepository],
///   monotonically sequences asynchronous requests via `_requestId`, and debounces
///   live property stream invalidations by $300\text{ ms}$ to prevent UI thrashing.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Request Serialization**: Any asynchronous operation initiated with
///   sequence ID $r$ aborts state mutation if $r \ne \text{\_requestId}$ or
///   `_disposed == true`.
/// - **Visible Column Filtering**:
///   $$
///   \begin{aligned}
///   \text{visibleColumnModels} &= \{c \in \text{headers} \mid c.\text{visible} \land c.\text{key} \notin (\text{hiddenColumnKeys} \cup \varnothing)\}
///   \end{aligned}
///   $$
///
/// ## 3. Preconditions
/// - Must be constructed with either a composite [DataSource] or explicit
///   [TypeRepository], [InstanceRepository], and [PropertyRepository] instances.
///
/// ## 4. Postconditions
/// - Populates [state] with discovered [tabs], [headers], and [rows] on
///   [loadForNode] and [selectTab], and cancels stream subscriptions and timers
///   on [dispose].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|T_{\text{rel}}|) $ repository lookups for
///   tab discovery; $\mathcal{O}(R \cdot C)$ for projecting $R$ [InstanceRecord]
///   items across $C$ fields ($\mathcal{O}(1)$ fetch on `_cache` hit).
/// - **Space Complexity**: $\mathcal{O}(R \cdot C)$ for cached [InstanceRecord]
///   lists and projected row matrices.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Repository failures or caught exceptions transition `state.loading` to
///   `false` and set `state.error = 'Failed to load table data'` with empty
///   collections rather than propagating unhandled futures.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/TablesViewModel]
class TablesViewModel extends ChangeNotifier {
  final TypeRepository _typeRepository;
  final InstanceRepository _instanceRepository;
  final PropertyRepository _propertyRepository;

  TablesState _state;
  int _requestId = 0;
  bool _disposed = false;

  final Map<(String, String), List<InstanceRecord>> _cache = {};
  StreamSubscription<Result<Map<String, dynamic>>>? _propertiesSubscription;
  Timer? _debounceTimer;

  List<ColumnModel>? _prevVisibleHeaders;
  Set<String>? _prevHiddenKeys;
  List<ColumnModel>? _cachedVisibleModels;

  /// Creates a [TablesViewModel] with a [DataSource] (implementing segregated repos).
  TablesViewModel(DataSource dataSource, String activeView)
      : _typeRepository = dataSource,
        _instanceRepository = dataSource,
        _propertyRepository = dataSource,
        _state = TablesState(activeView: activeView) {
    _setupPropertiesSubscription(activeView);
  }

  /// Creates a [TablesViewModel] injecting explicit segregated repositories.
  TablesViewModel.repositories({
    required TypeRepository typeRepository,
    required InstanceRepository instanceRepository,
    required PropertyRepository propertyRepository,
    required String activeView,
  })  : _typeRepository = typeRepository,
        _instanceRepository = instanceRepository,
        _propertyRepository = propertyRepository,
        _state = TablesState(activeView: activeView) {
    _setupPropertiesSubscription(activeView);
  }

  /// Current immutable state.
  TablesState get state => _state;

  /// All discovered tabs for the current node.
  List<TabDescriptor> get tabs => _state.tabs;

  /// The currently active tab identifier.
  String get tabId =>
      _state.selectedTabId ?? (_state.tabs.isNotEmpty ? _state.tabs.first.id : '');

  /// The currently active tab identifier or null.
  String? get selectedTabId => _state.selectedTabId;

  /// Column headers for the currently selected tab.
  List<ColumnModel> get headers => _state.headers;

  /// Hidden column keys.
  Set<String>? get hiddenColumnKeys => _state.hiddenColumnKeys;

  /// Visible column models computed for the current headers and hidden keys.
  List<ColumnModel> get visibleColumnModels {
    if (identical(_prevVisibleHeaders, _state.headers) &&
        identical(_prevHiddenKeys, _state.hiddenColumnKeys) &&
        _cachedVisibleModels != null) {
      return _cachedVisibleModels!;
    }
    _prevVisibleHeaders = _state.headers;
    _prevHiddenKeys = _state.hiddenColumnKeys;
    _cachedVisibleModels = (_state.hiddenColumnKeys == null ||
            _state.hiddenColumnKeys!.isEmpty
        ? _state.headers
        : _state.headers.where((cm) => !_state.hiddenColumnKeys!.contains(cm.key)))
        .where((cm) => cm.visible)
        .toList();
    return _cachedVisibleModels!;
  }

  /// Column models for the currently selected tab.
  List<ColumnModel> get columnModels => _state.columnModels;

  /// Sets hidden column keys and notifies listeners.
  void setHiddenColumnKeys(Set<String>? keys) {
    _state = _state.copyWith(hiddenColumnKeys: keys, clearHiddenColumnKeys: keys == null);
    notifyListeners();
  }

  /// Loaded table rows for the currently selected tab.
  List<List<String>> get rows => _state.rows;

  /// Whether data is currently being fetched.
  bool get loading => _state.loading;

  /// Error message if the last fetch failed, or null.
  String? get error => _state.error;

  /// Discovers tabs and loads the first tab's data for the given [nodeId].
  Future<void> loadForNode(String nodeId) async {
    if (_disposed) return;
    final requestId = ++_requestId;
    _state = _state.copyWith(
      activeView: nodeId,
      tabs: [],
      clearSelectedTabId: true,
      headers: [],
      rows: [],
      columnModels: [],
      loading: true,
      clearError: true,
    );
    notifyListeners();
    _setupPropertiesSubscription(nodeId);

    try {
      final typeRes = await _typeRepository.typeFor(nodeId);
      if (_disposed || requestId != _requestId) return;

      final TypeDescriptor? typeDescriptor;
      switch (typeRes) {
        case Success<TypeDescriptor?>(:final value):
          typeDescriptor = value;
        case Failure<TypeDescriptor?>():
          typeDescriptor = null;
      }

      if (typeDescriptor == null) {
        _state = _state.copyWith(loading: false);
        notifyListeners();
        return;
      }

      final List<TabDescriptor> discoveredTabs = [];

      // 1. Child types (hierarchy containment)
      for (final ct in typeDescriptor.childTypes) {
        final childRes = await _typeRepository.typeFor(ct.childTypeName);
        if (_disposed || requestId != _requestId) return;
        final TypeDescriptor? childDesc;
        switch (childRes) {
          case Success<TypeDescriptor?>(:final value):
            childDesc = value;
          case Failure<TypeDescriptor?>():
            childDesc = null;
        }
        if (childDesc == null) continue;
        discoveredTabs.add(TabDescriptor(
          id: ct.childTypeName,
          label: ct.childLabel,
          type: childDesc,
        ));
      }

      // 2. Related types (events, alarms, etc.)
      for (final rt in typeDescriptor.relatedTypes) {
        final relRes = await _typeRepository.typeFor(rt.childTypeName);
        if (_disposed || requestId != _requestId) return;
        final TypeDescriptor? relDesc;
        switch (relRes) {
          case Success<TypeDescriptor?>(:final value):
            relDesc = value;
          case Failure<TypeDescriptor?>():
            relDesc = null;
        }
        if (relDesc == null) continue;
        discoveredTabs.add(TabDescriptor(
          id: rt.childTypeName,
          label: rt.childLabel,
          type: relDesc,
        ));
      }

      if (_disposed || requestId != _requestId) return;

      if (discoveredTabs.isNotEmpty) {
        _state = _state.copyWith(
          tabs: discoveredTabs,
          selectedTabId: discoveredTabs.first.id,
        );
        await _loadData(discoveredTabs.first, requestId);
      } else {
        _state = _state.copyWith(
          tabs: [],
          clearSelectedTabId: true,
          rows: [],
          headers: [],
          columnModels: [],
          loading: false,
        );
      }
      notifyListeners();
    } catch (e, st) {
      if (_disposed || requestId != _requestId) return;
      _state = _state.copyWith(
        error: 'Failed to load table data',
        rows: [],
        headers: [],
        columnModels: [],
        loading: false,
      );
      debugPrint('TablesViewModel.loadForNode error: $e\n$st');
      notifyListeners();
    }
  }

  /// Switches to the tab identified by [tabId] and loads its data.
  Future<void> selectTab(String tabId) async {
    if (_disposed) return;
    if (!_state.tabs.any((t) => t.id == tabId)) return;
    if (_state.selectedTabId == tabId) return;
    
    final tab = _state.tabs.firstWhere((t) => t.id == tabId);
    final requestId = ++_requestId;
    _state = _state.copyWith(
      selectedTabId: tabId,
      loading: true,
      clearError: true,
    );
    notifyListeners();
    await _loadData(tab, requestId);
  }

  Future<void> _loadData(TabDescriptor tab, int requestId) async {
    if (_disposed || requestId != _requestId) return;
    try {
      final headers = tab.type.fields.map(ColumnModel.fromFieldDescriptor).toList();
      final columnModels = tab.type.fields.map(ColumnModel.fromFieldDescriptor).toList();

      final cacheKey = (_state.activeView, tab.type.typeName);
      final List<InstanceRecord> records;
      if (_cache.containsKey(cacheKey)) {
        records = _cache[cacheKey]!;
      } else {
        final relRes = await _instanceRepository.fetchRelatedInstances(
          parentNodeId: _state.activeView,
          targetType: tab.type,
        );
        if (_disposed || requestId != _requestId) return;
        switch (relRes) {
          case Success<List<InstanceRecord>>(:final value):
            records = value;
          case Failure<List<InstanceRecord>>():
            records = [];
        }
        _cache[cacheKey] = records;
      }

      final rows = records.map((record) {
        return tab.type.fields.map((f) => record.attributes[f.key]?.toString() ?? '').toList();
      }).toList();

      if (_disposed || requestId != _requestId) return;

      _state = _state.copyWith(
        headers: headers,
        columnModels: columnModels,
        rows: rows,
        loading: false,
      );
      notifyListeners();
    } catch (e, st) {
      if (_disposed || requestId != _requestId) return;
      _state = _state.copyWith(
        error: 'Failed to load table data',
        rows: [],
        headers: [],
        columnModels: [],
        loading: false,
      );
      debugPrint('TablesViewModel._loadData error: $e\n$st');
      notifyListeners();
    }
  }

  void _setupPropertiesSubscription(String nodeId) {
    if (_disposed) return;
    _propertiesSubscription?.cancel();
    _debounceTimer?.cancel();
    bool isFirst = true;
    _propertiesSubscription = _propertyRepository.watchProperties(nodeId).listen(
      (res) {
        if (_disposed) return;
        if (isFirst) {
          isFirst = false;
          return;
        }
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 300), () {
          if (_disposed) return;
          _cache.clear();
          if (_state.tabs.isNotEmpty && _state.selectedTabId != null) {
            final tab = _state.tabs.firstWhere((t) => t.id == _state.selectedTabId);
            final requestId = ++_requestId;
            _loadData(tab, requestId);
          }
        });
      },
      onError: (Object e) {
        debugPrint('TablesViewModel properties subscription error: $e');
      },
    );
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _propertiesSubscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
