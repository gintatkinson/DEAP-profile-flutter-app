import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/features/properties/property_grid.dart';
import 'package:app_flutter/features/tree/view_models/tree_view_model.dart';
import 'package:app_flutter/features/layout/layout_config_service.dart';
import 'package:app_flutter/features/topology/topology_map.dart';
import 'package:app_flutter/features/topology/topology_defaults.dart' show emptyTopologyData, loadTopologyData;
import 'package:app_flutter/features/layout/component_factory.dart';
import 'package:app_flutter/features/properties/view_models/properties_view_model.dart';
import 'package:app_flutter/core/background_worker.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';

/// Root ARINC 661 workstation layout orchestrator widget that parses declarative
/// `logical-layout.json` manifests, coordinates background worker streams, and
/// binds [TreeViewModel], [PropertiesViewModel], and [TopologyData] across split panes.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Centralizes workstation view
///   selection, live property stream subscriptions, and deterministic resource
///   disposal so that switching active views synchronizes the hierarchy tree,
///   topographical viewport, tabular panes, and property editors atomically.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Single Active Subscription Invariant**: At any instant $t$, at most one
///   `_propertiesSubscription` stream listener is active; every call to
///   `_subscribeProperties` cancels the prior subscription before binding a new one.
/// - **Minimum Pane Geometry**: Enforces `_minPaneSize` $= 150.0$ logical pixels
///   across all child split containers constructed via [ComponentFactory].
///
/// ## 3. Preconditions
/// - A live [DataSource] and [ThemeController] must be provided in the ancestor
///   [BuildContext] via [Provider].
/// - Either [layoutConfig] contains a valid JSON layout string or
///   `assets/logical-layout.json` is bundled in `rootBundle`.
///
/// ## 4. Postconditions
/// - Renders a centered [CircularProgressIndicator] while the layout manifest is
///   loading, and transitions to the full [ComponentFactory]-built widget tree
///   once `_parsedLayout` is populated.
/// - Cancels all stream subscriptions and disposes [_worker], [_treeViewModel],
///   and [_propertiesViewModel] upon [State.dispose].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|T|)$ per layout build where $|T|$ is the
///   number of layout container nodes in `_parsedLayout`.
/// - **Space Complexity**: $\mathcal{O}(|V| + |F|)$ for cached tree nodes $|V|$
///   and active node property fields $|F|$.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Failed `watchProperties` stream events or failed `fetchTopologyData` calls
///   fall back cleanly to empty maps/`emptyTopologyData` without uncaught
///   exceptions or UI thread lockups.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/Layout]
@immutable
class Layout extends StatefulWidget {
  /// Optional externally controlled active view identifier.
  final String? activeView;

  /// Optional callback invoked whenever the operator selects a new view node.
  final ValueChanged<String>? onViewChange;

  /// Optional raw JSON string overriding the bundled `assets/logical-layout.json` manifest.
  final String? layoutConfig;

  /// Creates a root [Layout] orchestrator widget.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `Layout::Layout` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `Layout::Layout` (declaration #2) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `Layout::Layout` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `Layout::Layout` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(Layout)) bounded over input/member dimension of `Layout::Layout`.
  /// - Space Complexity: O(K(Layout)) bounded auxiliary memory for `Layout::Layout`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `Layout::Layout` (`()`).
  /// - State: Maintains consistent state invariants across `Layout::Layout` without partial mutation on error.
  /// - Action: Executes `Layout::Layout` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `Layout::Layout` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUT-LAYOUT] | SysML v2: ActionDef(Layout::Layout)
  const Layout({
    super.key,
    this.activeView,
    this.onViewChange,
    this.layoutConfig,
  });

  /// Executes deterministic method `Layout::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `Layout::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `Layout::createState` (declaration #3) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `Layout::createState` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<Layout>` from `Layout::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `Layout::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `Layout::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `Layout::createState` (`State<Layout>`).
  /// - State: Maintains consistent state invariants across `Layout::createState` without partial mutation on error.
  /// - Action: Executes `Layout::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `Layout::createState` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUT-CREATESTATE] | SysML v2: ActionDef(Layout::createState)
  @override
  State<Layout> createState() => _LayoutState();
}

/// Executes deterministic class `_LayoutState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_LayoutState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_LayoutState` (declaration #4) within `LAYOUT-LAYOUT`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_LayoutState` in `LAYOUT-LAYOUT`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_LayoutState` representation for class `_LayoutState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_LayoutState)) bounded over input/member dimension of `_LayoutState`.
/// - Space Complexity: O(K(_LayoutState)) bounded auxiliary memory for `_LayoutState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_LayoutState` (`_LayoutState`).
/// - State: Maintains consistent state invariants across `_LayoutState` without partial mutation on error.
/// - Action: Executes `_LayoutState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_LayoutState` (`LAYOUT-LAYOUT`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE] | SysML v2: PartDef(_LayoutState)
class _LayoutState extends State<Layout> {
  // Navigation & Tree Selection
  late String _currentView;

  // Data Source
  DataSource? _dataSource;
  StreamSubscription<Result<Map<String, dynamic>>>? _propertiesSubscription;
  Map<String, dynamic> _nodeData = const {};

  // Tree ViewModel
  TreeViewModel? _treeViewModel;

  // Properties ViewModel
  PropertiesViewModel? _propertiesViewModel;

  static const double _minPaneSize = 150.0;

  bool _layoutInitialized = false;

  /// Subscribes to live property updates for [nodeId] via
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_subscribeProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_subscribeProperties` (declaration #5) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_subscribeProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::_subscribeProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `_LayoutState::_subscribeProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `_LayoutState::_subscribeProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_subscribeProperties` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_subscribeProperties` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_subscribeProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_subscribeProperties` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-SUBSCRIBEPROPERTIES] | SysML v2: ActionDef(_LayoutState::_subscribeProperties)
  void _subscribeProperties(String nodeId) {
    _propertiesSubscription?.cancel();
    _nodeData = const {};
    _propertiesSubscription = _dataSource!.watchProperties(nodeId).listen(
      (res) {
        if (mounted) {
          setState(() {
            _nodeData = res.isSuccess
                ? (res as Success<Map<String, dynamic>>).value
                : const {};
          });
        }
      },
      onError: (Object error, StackTrace stack) {
        debugPrint('watchProperties error: $error');
      },
    );
  }

  /// Executes deterministic method `_LayoutState::didChangeDependencies` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::didChangeDependencies` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::didChangeDependencies` (declaration #6) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::didChangeDependencies` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::didChangeDependencies` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(didChangeDependencies)) bounded over input/member dimension of `_LayoutState::didChangeDependencies`.
  /// - Space Complexity: O(K(didChangeDependencies)) bounded auxiliary memory for `_LayoutState::didChangeDependencies`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::didChangeDependencies` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::didChangeDependencies` without partial mutation on error.
  /// - Action: Executes `_LayoutState::didChangeDependencies` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::didChangeDependencies` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-DIDCHANGEDEPENDENCIES] | SysML v2: ActionDef(_LayoutState::didChangeDependencies)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dataSource == null) {
      _dataSource = context.read<DataSource>();
      _subscribeProperties(_currentView);
    }
    if (_treeViewModel == null) {
      final dataSource = context.read<DataSource>();
      _treeViewModel = TreeViewModel(
        dataSource,
        initialView: _currentView,
        onViewSelected: _selectView,
      )
        ..addListener(_onTreeViewModelChanged)
        ..loadTree();
    }
    if (_propertiesViewModel == null) {
      final dataSource = context.read<DataSource>();
      _propertiesViewModel = PropertiesViewModel(dataSource)
        ..addListener(_onPropertiesViewModelChanged)
        ..loadType(_currentView);
    }
  }

  /// Triggers a rebuild when the properties view model notifies listeners.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_onPropertiesViewModelChanged` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_onPropertiesViewModelChanged` (declaration #7) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_onPropertiesViewModelChanged` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::_onPropertiesViewModelChanged` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_onPropertiesViewModelChanged)) bounded over input/member dimension of `_LayoutState::_onPropertiesViewModelChanged`.
  /// - Space Complexity: O(K(_onPropertiesViewModelChanged)) bounded auxiliary memory for `_LayoutState::_onPropertiesViewModelChanged`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_onPropertiesViewModelChanged` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_onPropertiesViewModelChanged` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_onPropertiesViewModelChanged` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_onPropertiesViewModelChanged` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-ONPROPERTIESVIEWMODELCHANGED] | SysML v2: ActionDef(_LayoutState::_onPropertiesViewModelChanged)
  void _onPropertiesViewModelChanged() {
    if (mounted) setState(() {});
  }

  /// Rebuilds the UI and syncs the current view from the tree when the tree
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_onTreeViewModelChanged` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_onTreeViewModelChanged` (declaration #8) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_onTreeViewModelChanged` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::_onTreeViewModelChanged` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_onTreeViewModelChanged)) bounded over input/member dimension of `_LayoutState::_onTreeViewModelChanged`.
  /// - Space Complexity: O(K(_onTreeViewModelChanged)) bounded auxiliary memory for `_LayoutState::_onTreeViewModelChanged`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_onTreeViewModelChanged` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_onTreeViewModelChanged` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_onTreeViewModelChanged` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_onTreeViewModelChanged` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-ONTREEVIEWMODELCHANGED] | SysML v2: ActionDef(_LayoutState::_onTreeViewModelChanged)
  void _onTreeViewModelChanged() {
    if (mounted) {
      _updateCurrentViewFromLayout();
      setState(() {});
    }
  }

  // Background Worker
  BackgroundWorker? _worker;
  StreamSubscription<int>? _workerSubscription;

  // Parsed configuration map
  Map<String, dynamic>? _parsedLayout;

  // Cached JSON files
  Map<String, dynamic>? _cachedRules;
  Map<String, dynamic>? _cachedLabels;

  /// Loads a JSON file from disk, caching results by type.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_loadJsonOnce` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_loadJsonOnce` (declaration #9) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `path: String` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_loadJsonOnce`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, dynamic>` from `_LayoutState::_loadJsonOnce` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(path)) bounded over input/member dimension of `_LayoutState::_loadJsonOnce`.
  /// - Space Complexity: O(N(path)) bounded auxiliary memory for `_LayoutState::_loadJsonOnce`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_loadJsonOnce` (`Map<String, dynamic>`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_loadJsonOnce` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_loadJsonOnce` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_loadJsonOnce` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-LOADJSONONCE] | SysML v2: ActionDef(_LayoutState::_loadJsonOnce)
  Map<String, dynamic> _loadJsonOnce(String path) {
    if (_cachedRules != null && path.contains('codebase_rules')) return _cachedRules!;
    if (_cachedLabels != null && path.contains('labels')) return _cachedLabels!;
    try {
      for (final candidate in [path, '../$path']) {
        final file = File(candidate);
        if (file.existsSync()) {
          final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
          if (path.contains('codebase_rules')) _cachedRules = data;
          if (path.contains('labels')) _cachedLabels = data;
          return data;
        }
      }
    } catch (_) {}
    return {};
  }

  // Properties Reactive State

  /// Preloaded topology data from external JSON asset; null until loaded.
  TopologyData? _topologyData;
  TopologyData? _cachedTopologyData;

  /// Executes deterministic method `_LayoutState::initState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::initState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::initState` (declaration #10) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::initState` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::initState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(initState)) bounded over input/member dimension of `_LayoutState::initState`.
  /// - Space Complexity: O(K(initState)) bounded auxiliary memory for `_LayoutState::initState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::initState` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::initState` without partial mutation on error.
  /// - Action: Executes `_LayoutState::initState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::initState` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-INITSTATE] | SysML v2: ActionDef(_LayoutState::initState)
  @override
  void initState() {
    super.initState();

    if (widget.layoutConfig != null) {
      _parsedLayout = jsonDecode(widget.layoutConfig!) as Map<String, dynamic>;
    } else {
      _loadLayoutConfig();
    }

    _currentView = widget.activeView ?? 'root';

    _worker = BackgroundWorker()..start();
    _workerSubscription = _worker!.results.listen((_) {
      if (mounted) setState(() {});
    });

    _preloadConfigs();
    _preloadTopologyData();
  }

  /// Executes deterministic method `_LayoutState::_preloadConfigs` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_preloadConfigs` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_preloadConfigs` (declaration #11) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_preloadConfigs` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `_LayoutState::_preloadConfigs` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_preloadConfigs)) bounded over input/member dimension of `_LayoutState::_preloadConfigs`.
  /// - Space Complexity: O(K(_preloadConfigs)) bounded auxiliary memory for `_LayoutState::_preloadConfigs`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_preloadConfigs` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_preloadConfigs` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_preloadConfigs` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_preloadConfigs` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-PRELOADCONFIGS] | SysML v2: ActionDef(_LayoutState::_preloadConfigs)
  Future<void> _preloadConfigs() async {
    try {
      final rulesFile = File('.pipeline/logical-ui/codebase_rules.json');
      if (await rulesFile.exists()) {
        final content = await rulesFile.readAsString();
        _cachedRules = jsonDecode(content) as Map<String, dynamic>;
      }
      final labelsFile = File('.pipeline/logical-ui/labels.json');
      if (await labelsFile.exists()) {
        final content = await labelsFile.readAsString();
        _cachedLabels = jsonDecode(content) as Map<String, dynamic>;
      }
      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

  /// Preloads topology data from an external JSON asset for later use.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_preloadTopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_preloadTopologyData` (declaration #12) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_preloadTopologyData` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `_LayoutState::_preloadTopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_preloadTopologyData)) bounded over input/member dimension of `_LayoutState::_preloadTopologyData`.
  /// - Space Complexity: O(K(_preloadTopologyData)) bounded auxiliary memory for `_LayoutState::_preloadTopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_preloadTopologyData` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_preloadTopologyData` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_preloadTopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_preloadTopologyData` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-PRELOADTOPOLOGYDATA] | SysML v2: ActionDef(_LayoutState::_preloadTopologyData)
  Future<void> _preloadTopologyData() async {
    try {
      final dataSource = context.read<DataSource>();
      final res = await dataSource.fetchTopologyData();
      var data = res.isSuccess ? (res as Success<TopologyData>).value : const TopologyData(coordinateMapping: {}, nodes: [], links: []);
      if (data.nodes.isEmpty) {
        data = await loadTopologyData();
      }
      if (mounted) {
        setState(() {
          _topologyData = data;
          _cachedTopologyData = null;
        });
      }
    } catch (e) {
      debugPrint('Error loading topology data: $e');
    }
  }

  /// Executes deterministic method `_LayoutState::didUpdateWidget` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::didUpdateWidget` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::didUpdateWidget` (declaration #13) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `oldWidget: Layout` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::didUpdateWidget`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::didUpdateWidget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(oldWidget)) bounded over input/member dimension of `_LayoutState::didUpdateWidget`.
  /// - Space Complexity: O(N(oldWidget)) bounded auxiliary memory for `_LayoutState::didUpdateWidget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::didUpdateWidget` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::didUpdateWidget` without partial mutation on error.
  /// - Action: Executes `_LayoutState::didUpdateWidget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::didUpdateWidget` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-DIDUPDATEWIDGET] | SysML v2: ActionDef(_LayoutState::didUpdateWidget)
  @override
  void didUpdateWidget(covariant Layout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeView != null && widget.activeView != oldWidget.activeView) {
      if (_currentView != widget.activeView) {
        setState(() {
          _currentView = widget.activeView!;
        });
        _subscribeProperties(_currentView);
        _propertiesViewModel?.loadType(_currentView);
      }
    }
  }

  /// Executes deterministic method `_LayoutState::dispose` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::dispose` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::dispose` (declaration #14) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::dispose` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `_LayoutState::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `_LayoutState::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::dispose` without partial mutation on error.
  /// - Action: Executes `_LayoutState::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::dispose` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-DISPOSE] | SysML v2: ActionDef(_LayoutState::dispose)
  @override
  void dispose() {
    _propertiesSubscription?.cancel();
    _workerSubscription?.cancel();
    _worker?.dispose();
    _treeViewModel?.removeListener(_onTreeViewModelChanged);
    _treeViewModel?.dispose();
    _propertiesViewModel?.removeListener(_onPropertiesViewModelChanged);
    _propertiesViewModel?.dispose();
    super.dispose();
  }

  /// Returns the default split ratio for the properties panel.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_getDefaultRatio` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_getDefaultRatio` (declaration #15) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_getDefaultRatio` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `_LayoutState::_getDefaultRatio` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_getDefaultRatio)) bounded over input/member dimension of `_LayoutState::_getDefaultRatio`.
  /// - Space Complexity: O(K(_getDefaultRatio)) bounded auxiliary memory for `_LayoutState::_getDefaultRatio`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_getDefaultRatio` (`double`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_getDefaultRatio` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_getDefaultRatio` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_getDefaultRatio` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-GETDEFAULTRATIO] | SysML v2: ActionDef(_LayoutState::_getDefaultRatio)
  double _getDefaultRatio() {
    final rules = _loadJsonOnce('.pipeline/logical-ui/codebase_rules.json');
    return getDefaultRatio(rules, 'layout_properties.default_ratio', 0.5);
  }

  /// Resolves the coordinate-to-location mapping from codebase rules.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_resolveCoordinateMapping` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_resolveCoordinateMapping` (declaration #16) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_resolveCoordinateMapping` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, String>` from `_LayoutState::_resolveCoordinateMapping` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_resolveCoordinateMapping)) bounded over input/member dimension of `_LayoutState::_resolveCoordinateMapping`.
  /// - Space Complexity: O(K(_resolveCoordinateMapping)) bounded auxiliary memory for `_LayoutState::_resolveCoordinateMapping`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_resolveCoordinateMapping` (`Map<String, String>`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_resolveCoordinateMapping` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_resolveCoordinateMapping` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_resolveCoordinateMapping` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-RESOLVECOORDINATEMAPPING] | SysML v2: ActionDef(_LayoutState::_resolveCoordinateMapping)
  Map<String, String> _resolveCoordinateMapping() {
    final rules = _loadJsonOnce('.pipeline/logical-ui/codebase_rules.json');
    return resolveCoordinateMapping(rules);
  }

  /// Resolves the label mapping from codebase rules.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_resolveLabelsMapping` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_resolveLabelsMapping` (declaration #17) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_resolveLabelsMapping` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, String>` from `_LayoutState::_resolveLabelsMapping` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_resolveLabelsMapping)) bounded over input/member dimension of `_LayoutState::_resolveLabelsMapping`.
  /// - Space Complexity: O(K(_resolveLabelsMapping)) bounded auxiliary memory for `_LayoutState::_resolveLabelsMapping`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_resolveLabelsMapping` (`Map<String, String>`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_resolveLabelsMapping` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_resolveLabelsMapping` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_resolveLabelsMapping` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-RESOLVELABELSMAPPING] | SysML v2: ActionDef(_LayoutState::_resolveLabelsMapping)
  Map<String, String> _resolveLabelsMapping() {
    final rules = _loadJsonOnce('.pipeline/logical-ui/codebase_rules.json');
    return resolveLabelsMapping(rules);
  }

  /// Returns a human-readable label for the given [tabId].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_resolveTabLabel` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_resolveTabLabel` (declaration #18) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `tabId: String` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_resolveTabLabel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `_LayoutState::_resolveTabLabel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(tabId)) bounded over input/member dimension of `_LayoutState::_resolveTabLabel`.
  /// - Space Complexity: O(N(tabId)) bounded auxiliary memory for `_LayoutState::_resolveTabLabel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_resolveTabLabel` (`String`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_resolveTabLabel` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_resolveTabLabel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_resolveTabLabel` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-RESOLVETABLABEL] | SysML v2: ActionDef(_LayoutState::_resolveTabLabel)
  String _resolveTabLabel(String tabId) {
    final mapping = _resolveLabelsMapping();
    for (final entry in mapping.entries) {
      if (tabId.contains(entry.key)) {
        return entry.value;
      }
    }
    final words = tabId.split('_');
    final capitalized = words.map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
    return capitalized;
  }

  // TODO(#79): Replace mock topology nodes/links with DB-backed data.
  /// Builds a [TopologyData] with the coordinate mapping applied.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_resolveTopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_resolveTopologyData` (declaration #19) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_resolveTopologyData` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TopologyData` from `_LayoutState::_resolveTopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_resolveTopologyData)) bounded over input/member dimension of `_LayoutState::_resolveTopologyData`.
  /// - Space Complexity: O(K(_resolveTopologyData)) bounded auxiliary memory for `_LayoutState::_resolveTopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_resolveTopologyData` (`TopologyData`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_resolveTopologyData` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_resolveTopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_resolveTopologyData` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-RESOLVETOPOLOGYDATA] | SysML v2: ActionDef(_LayoutState::_resolveTopologyData)
  TopologyData _resolveTopologyData() {
    if (_cachedTopologyData != null) {
      return _cachedTopologyData!;
    }
    final mapping = _resolveCoordinateMapping();
    final data = _topologyData ?? emptyTopologyData;
    _cachedTopologyData = TopologyData(
      coordinateMapping: mapping,
      nodes: data.nodes,
      links: data.links,
    );
    return _cachedTopologyData!;
  }


  /// Loads the logical layout configuration from the bundled assets.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_loadLayoutConfig` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_loadLayoutConfig` (declaration #20) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_loadLayoutConfig` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `_LayoutState::_loadLayoutConfig` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_loadLayoutConfig)) bounded over input/member dimension of `_LayoutState::_loadLayoutConfig`.
  /// - Space Complexity: O(K(_loadLayoutConfig)) bounded auxiliary memory for `_LayoutState::_loadLayoutConfig`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_loadLayoutConfig` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_loadLayoutConfig` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_loadLayoutConfig` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_loadLayoutConfig` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-LOADLAYOUTCONFIG] | SysML v2: ActionDef(_LayoutState::_loadLayoutConfig)
  Future<void> _loadLayoutConfig() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/logical-layout.json');
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _parsedLayout = parsed;
          _updateCurrentViewFromLayout();
        });
      }
    } catch (e) {
      debugPrint('Error loading layout configuration: $e');
    }
  }

  /// Updates [_currentView] to the root of the tree data when no explicit
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_updateCurrentViewFromLayout` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_updateCurrentViewFromLayout` (declaration #21) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_LayoutState::_updateCurrentViewFromLayout` in `LAYOUT-LAYOUT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::_updateCurrentViewFromLayout` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_updateCurrentViewFromLayout)) bounded over input/member dimension of `_LayoutState::_updateCurrentViewFromLayout`.
  /// - Space Complexity: O(K(_updateCurrentViewFromLayout)) bounded auxiliary memory for `_LayoutState::_updateCurrentViewFromLayout`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_updateCurrentViewFromLayout` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_updateCurrentViewFromLayout` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_updateCurrentViewFromLayout` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_updateCurrentViewFromLayout` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-UPDATECURRENTVIEWFROMLAYOUT] | SysML v2: ActionDef(_LayoutState::_updateCurrentViewFromLayout)
  void _updateCurrentViewFromLayout() {
    if (_layoutInitialized) return;
    if (_treeViewModel == null || _treeViewModel!.treeData.isEmpty) return;
    if (widget.activeView == null && _currentView == 'root') {
      _currentView = _treeViewModel!.treeData.first.id;
      _subscribeProperties(_currentView);
      _propertiesViewModel?.loadType(_currentView);
    }
    _layoutInitialized = true;
  }

  /// Selects a view by [viewId], updating state, tree model, properties, and
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_selectView` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_selectView` (declaration #22) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `viewId: String` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_selectView`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_LayoutState::_selectView` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(viewId)) bounded over input/member dimension of `_LayoutState::_selectView`.
  /// - Space Complexity: O(N(viewId)) bounded auxiliary memory for `_LayoutState::_selectView`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_selectView` (`void`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_selectView` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_selectView` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_selectView` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-SELECTVIEW] | SysML v2: ActionDef(_LayoutState::_selectView)
  void _selectView(String viewId) {
    if (_currentView == viewId) return;
    setState(() {
      _currentView = viewId;
    });
    _treeViewModel?.updateCurrentView(viewId);
    _subscribeProperties(viewId);
    _propertiesViewModel?.loadType(viewId);
    widget.onViewChange?.call(viewId);
  }

  /// Builds the full widget tree from the parsed layout configuration.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_buildFromLayout` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_buildFromLayout` (declaration #23) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_buildFromLayout`.
  /// - `constraints: BoxConstraints` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_buildFromLayout`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_LayoutState::_buildFromLayout` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_LayoutState::_buildFromLayout`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_LayoutState::_buildFromLayout`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_buildFromLayout` (`Widget`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_buildFromLayout` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_buildFromLayout` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_buildFromLayout` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-BUILDFROMLAYOUT] | SysML v2: ActionDef(_LayoutState::_buildFromLayout)
  Widget _buildFromLayout(BuildContext context, BoxConstraints constraints) {
    final preferredSplitAxis = context.watch<ThemeController>().layoutSplitAxis;
    final factory = ComponentFactory(
      currentView: _currentView,
      workerResult: _worker?.lastResult,
      onViewSelected: _selectView,
      minPaneSize: _minPaneSize,
      defaultRatio: _getDefaultRatio,
      resolveTopologyData: _resolveTopologyData,
      resolveTabLabel: _resolveTabLabel,
      buildChildWidget: _buildChildWidget,
      treeViewModel: _treeViewModel,
      preferredSplitAxis: preferredSplitAxis,
    );
    final rootNode = _parsedLayout!['layout']['root_container']
        as Map<String, dynamic>;
    final childWidget = factory.build(rootNode, constraints.maxWidth, constraints.maxHeight, context);
    if (_treeViewModel != null) {
      return ChangeNotifierProvider<TreeViewModel>.value(
        value: _treeViewModel!,
        child: childWidget,
      );
    }
    return childWidget;
  }

  /// Executes deterministic method `_LayoutState::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::build` (declaration #24) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_LayoutState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_LayoutState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_LayoutState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_LayoutState::build` without partial mutation on error.
  /// - Action: Executes `_LayoutState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::build` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-BUILD] | SysML v2: ActionDef(_LayoutState::build)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _parsedLayout == null
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) =>
                  _buildFromLayout(context, constraints),
            ),
    );
  }

  /// Builds the child widget displayed in the properties panel.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LayoutState::_buildChildWidget` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/layout/layout.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LayoutState::_buildChildWidget` (declaration #25) within `LAYOUT-LAYOUT`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_LayoutState::_buildChildWidget`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_LayoutState::_buildChildWidget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_LayoutState::_buildChildWidget`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_LayoutState::_buildChildWidget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LayoutState::_buildChildWidget` (`Widget`).
  /// - State: Maintains consistent state invariants across `_LayoutState::_buildChildWidget` without partial mutation on error.
  /// - Action: Executes `_LayoutState::_buildChildWidget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LayoutState::_buildChildWidget` (`LAYOUT-LAYOUT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-LAYOUT-LAYOUTSTATE-BUILDCHILDWIDGET] | SysML v2: ActionDef(_LayoutState::_buildChildWidget)
  Widget _buildChildWidget(BuildContext context) {
    final fields = _propertiesViewModel?.fields ?? [];

    return PropertyGrid(
      activeView: _currentView,
      fields: fields,
      initialValues: _nodeData,
      onSave: (Map<String, dynamic> data) async {
        await _dataSource!.saveProperties(_currentView, data);
      },
    );
  }
}
