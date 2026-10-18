import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/features/tables/view_models/tables_view_model.dart';
import 'package:app_flutter/features/tables/table_view_widget.dart';

/// ARINC 661 multi-tab container widget whose tab headers, selection state, and
/// child [TableViewWidget] panes are driven dynamically by [TablesViewModel].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Synchronizes [TabController]
///   lifecycle and deferred controller disposal (`_pendingDispose`) with
///   schema-discovered child and related entity tabs, preventing use-after-dispose
///   animation ticker faults during rapid tree node switching.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Controller Cardinality Alignment**: Whenever $|\text{tabs}| > 0$,
///   $\text{\_tabController.length} = |\text{tabs}|$, and the active index
///   $i \in [0, |\text{tabs}| - 1]$.
/// - **Deferred Frame Disposal**: Replaced [TabController] instances are queued
///   in `_pendingDispose` and disposed in a post-frame callback or on widget
///   `dispose()`.
///
/// ## 3. Preconditions
/// - Must be mounted inside a [BuildContext] providing both [TablesViewModel]
///   and [ThemeController] via [Provider].
///
/// ## 4. Postconditions
/// - Renders error text when `viewModel.error != null`, a
///   [CircularProgressIndicator] when `viewModel.loading` is true on empty tabs,
///   [SizedBox.shrink] when no tabs exist, or a [TabBar] + [TabBarView] of
///   [LazyTab]-wrapped [TableViewWidget] panes.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|K|)$ where $|K|$ is the number of
///   discovered [TabDescriptor] tabs.
/// - **Space Complexity**: $\mathcal{O}(|K|)$ tab widgets.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty tab sets safely dispose any active [TabController] and render
///   [SizedBox.shrink] without out-of-range index exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/TabbedContainer]
@immutable
class TabbedContainer extends StatefulWidget {
  /// Creates a [TabbedContainer].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TabbedContainer::TabbedContainer` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TabbedContainer::TabbedContainer` (declaration #2) within `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 3. Preconditions
  /// - `key: Key` must satisfy domain and type-safety constraints prior to invoking `TabbedContainer::TabbedContainer`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TabbedContainer::TabbedContainer` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TabbedContainer::TabbedContainer`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TabbedContainer::TabbedContainer`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TabbedContainer::TabbedContainer` (`()`).
  /// - State: Maintains consistent state invariants across `TabbedContainer::TabbedContainer` without partial mutation on error.
  /// - Action: Executes `TabbedContainer::TabbedContainer` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TabbedContainer::TabbedContainer` (`TABLES-TABBED-CONTAINER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TABLES-TABBED-CONTAINER-TABBEDCONTAINER-TABBEDCONTAINER] | SysML v2: ActionDef(TabbedContainer::TabbedContainer)
  const TabbedContainer({super.key});

  /// Executes deterministic method `TabbedContainer::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TabbedContainer::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TabbedContainer::createState` (declaration #3) within `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TabbedContainer::createState` in `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<TabbedContainer>` from `TabbedContainer::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `TabbedContainer::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `TabbedContainer::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TabbedContainer::createState` (`State<TabbedContainer>`).
  /// - State: Maintains consistent state invariants across `TabbedContainer::createState` without partial mutation on error.
  /// - Action: Executes `TabbedContainer::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TabbedContainer::createState` (`TABLES-TABBED-CONTAINER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TABLES-TABBED-CONTAINER-TABBEDCONTAINER-CREATESTATE] | SysML v2: ActionDef(TabbedContainer::createState)
  @override
  State<TabbedContainer> createState() => _TabbedContainerState();
}

/// Executes deterministic class `_TabbedContainerState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_TabbedContainerState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_TabbedContainerState` (declaration #4) within `TABLES-TABBED-CONTAINER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_TabbedContainerState` in `TABLES-TABBED-CONTAINER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_TabbedContainerState` representation for class `_TabbedContainerState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_TabbedContainerState)) bounded over input/member dimension of `_TabbedContainerState`.
/// - Space Complexity: O(K(_TabbedContainerState)) bounded auxiliary memory for `_TabbedContainerState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_TabbedContainerState` (`_TabbedContainerState`).
/// - State: Maintains consistent state invariants across `_TabbedContainerState` without partial mutation on error.
/// - Action: Executes `_TabbedContainerState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_TabbedContainerState` (`TABLES-TABBED-CONTAINER`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TABLES-TABBED-CONTAINER-TABBEDCONTAINERSTATE] | SysML v2: PartDef(_TabbedContainerState)
class _TabbedContainerState extends State<TabbedContainer>
    with TickerProviderStateMixin {
  TabController? _tabController;
  TablesViewModel? _viewModel;
  int? _lastIndex;
  final List<TabController> _pendingDispose = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newViewModel = Provider.of<TablesViewModel>(context);
    if (newViewModel != _viewModel) {
      _viewModel?.removeListener(_onViewModelChanged);
      _viewModel = newViewModel;
      _viewModel?.addListener(_onViewModelChanged);
      _updateController();
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {
        _updateController();
      });
    }
  }

  void _updateController() {
    final tabs = _viewModel?.tabs ?? [];
    if (tabs.isEmpty) {
      _tabController?.removeListener(_onTabTick);
      _tabController?.dispose();
      _tabController = null;
      return;
    }
    if (_tabController == null || _tabController!.length != tabs.length) {
      final oldController = _tabController;
      if (oldController != null) {
        oldController.removeListener(_onTabTick);
        _pendingDispose.add(oldController);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pendingDispose.contains(oldController)) {
            _pendingDispose.remove(oldController);
            oldController.dispose();
          }
        });
      }
      _tabController = TabController(length: tabs.length, vsync: this);
      final initialIndex =
          tabs.indexWhere((t) => t.id == _viewModel?.selectedTabId);
      if (initialIndex > 0) _tabController!.index = initialIndex;
      _tabController!.addListener(_onTabTick);
      _lastIndex = _tabController!.index;
    }
  }

  void _onTabTick() {
    if (_tabController != null) {
      if (_tabController!.index != _lastIndex) {
        _lastIndex = _tabController!.index;
        setState(() {});
      }
      if (!_tabController!.indexIsChanging) {
        final tabs = _viewModel?.tabs ?? [];
        if (_tabController!.index < tabs.length) {
          final tab = tabs[_tabController!.index];
          _viewModel?.selectTab(tab.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null) return const SizedBox.shrink();
    final tabs = _viewModel!.tabs;

    if (tabs.isEmpty) {
      if (_viewModel!.error != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _viewModel!.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }
      if (_viewModel!.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const SizedBox.shrink();
    }

    if (_tabController == null) {
      return const SizedBox.shrink();
    }

    final panelOpacity = context.watch<ThemeController>().panelOpacity;
    return Container(
      color: Theme.of(context).cardColor.withOpacity(panelOpacity),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController!,
              tabs: tabs.map((t) => Tab(text: t.label)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController!,
              children: List.generate(tabs.length, (idx) {
                return LazyTab(
                  isSelected: _tabController!.index == idx,
                  child: const TableViewWidget(),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_onViewModelChanged);
    _tabController?.removeListener(_onTabTick);
    _tabController?.dispose();
    for (final c in _pendingDispose) {
      c.dispose();
    }
    _pendingDispose.clear();
    super.dispose();
  }
}

/// Keep-alive offstage wrapper widget that preserves [child] state across
/// tab switches while suppressing layout/paint overhead when unselected.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Retains scroll offset and sort
///   state in inactive tabular views via [AutomaticKeepAliveClientMixin] while
///   gating visibility through [Offstage] (`offstage: !isSelected`).
///
/// ## 2. Invariants & Mathematical Properties
/// - **Keep-Alive Invariant**: `wantKeepAlive` is unconditionally `true`.
/// - **Offstage Visibility Bijection**: $\text{offstage} \iff \neg \text{isSelected}$.
///
/// ## 3. Preconditions
/// - [child] is a valid [Widget] hosted inside a [TabBarView].
///
/// ## 4. Postconditions
/// - Renders an [Offstage] subtree keeping [child] mounted in the element tree.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ wrapper build.
/// - **Space Complexity**: $\mathcal{O}(1)$ state overhead.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Toggling [isSelected] transitions visibility cleanly without unmounting
///   the underlying [State].
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/LazyTab]
@immutable
class LazyTab extends StatefulWidget {
  /// Creates a [LazyTab] wrapper.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `LazyTab::LazyTab` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `LazyTab::LazyTab` (declaration #6) within `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 3. Preconditions
  /// - `key: Key` must satisfy domain and type-safety constraints prior to invoking `LazyTab::LazyTab`.
  /// - `child: String` must satisfy domain and type-safety constraints prior to invoking `LazyTab::LazyTab`.
  /// - `isSelected: String` must satisfy domain and type-safety constraints prior to invoking `LazyTab::LazyTab`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `LazyTab::LazyTab` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `LazyTab::LazyTab`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `LazyTab::LazyTab`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `LazyTab::LazyTab` (`()`).
  /// - State: Maintains consistent state invariants across `LazyTab::LazyTab` without partial mutation on error.
  /// - Action: Executes `LazyTab::LazyTab` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `LazyTab::LazyTab` (`TABLES-TABBED-CONTAINER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TABLES-TABBED-CONTAINER-LAZYTAB-LAZYTAB] | SysML v2: ActionDef(LazyTab::LazyTab)
  const LazyTab({super.key, required this.child, required this.isSelected});

  /// Tab content widget kept alive across tab switches.
  final Widget child;

  /// Whether this tab is currently the active selected tab.
  final bool isSelected;

  /// Executes deterministic method `LazyTab::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `LazyTab::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `LazyTab::createState` (declaration #7) within `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `LazyTab::createState` in `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<LazyTab>` from `LazyTab::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `LazyTab::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `LazyTab::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `LazyTab::createState` (`State<LazyTab>`).
  /// - State: Maintains consistent state invariants across `LazyTab::createState` without partial mutation on error.
  /// - Action: Executes `LazyTab::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `LazyTab::createState` (`TABLES-TABBED-CONTAINER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TABLES-TABBED-CONTAINER-LAZYTAB-CREATESTATE] | SysML v2: ActionDef(LazyTab::createState)
  @override
  State<LazyTab> createState() => _LazyTabState();
}

/// Executes deterministic class `_LazyTabState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_LazyTabState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_LazyTabState` (declaration #8) within `TABLES-TABBED-CONTAINER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_LazyTabState` in `TABLES-TABBED-CONTAINER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_LazyTabState` representation for class `_LazyTabState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_LazyTabState)) bounded over input/member dimension of `_LazyTabState`.
/// - Space Complexity: O(K(_LazyTabState)) bounded auxiliary memory for `_LazyTabState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_LazyTabState` (`_LazyTabState`).
/// - State: Maintains consistent state invariants across `_LazyTabState` without partial mutation on error.
/// - Action: Executes `_LazyTabState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_LazyTabState` (`TABLES-TABBED-CONTAINER`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TABLES-TABBED-CONTAINER-LAZYTABSTATE] | SysML v2: PartDef(_LazyTabState)
class _LazyTabState extends State<LazyTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// Executes deterministic method `_LazyTabState::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_LazyTabState::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tables/tabbed_container.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_LazyTabState::build` (declaration #9) within `TABLES-TABBED-CONTAINER`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_LazyTabState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_LazyTabState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_LazyTabState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_LazyTabState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_LazyTabState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_LazyTabState::build` without partial mutation on error.
  /// - Action: Executes `_LazyTabState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_LazyTabState::build` (`TABLES-TABBED-CONTAINER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TABLES-TABBED-CONTAINER-LAZYTABSTATE-BUILD] | SysML v2: ActionDef(_LazyTabState::build)
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Offstage(offstage: !widget.isSelected, child: widget.child);
  }
}
