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
  const TabbedContainer({super.key});

  @override
  State<TabbedContainer> createState() => _TabbedContainerState();
}

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
  const LazyTab({super.key, required this.child, required this.isSelected});

  /// Tab content widget kept alive across tab switches.
  final Widget child;

  /// Whether this tab is currently the active selected tab.
  final bool isSelected;

  @override
  State<LazyTab> createState() => _LazyTabState();
}

class _LazyTabState extends State<LazyTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Offstage(offstage: !widget.isSelected, child: widget.child);
  }
}
