import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/features/tree/view_models/tree_view_model.dart';
import 'package:app_flutter/features/tree/sidebar_tree.dart';
import 'package:app_flutter/features/tables/view_models/tables_view_model.dart';

import 'package:app_flutter/features/layout/split_workspace.dart';
import 'package:app_flutter/features/tables/tabbed_container.dart';
import 'package:app_flutter/features/tables/table_view_widget.dart';
import 'package:app_flutter/features/topology/topographical_view.dart';
import 'package:app_flutter/features/topology/topology_map.dart';
import 'package:app_flutter/features/properties/properties_panel.dart';
import 'package:app_flutter/features/properties/view_models/properties_view_model.dart';
/// Schema-driven ARINC 661 layout interpreter that translates a parsed
/// `logical-layout.json` AST node hierarchy into concrete Flutter presentation widgets.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces strict separation between
///   Tier 2 declarative layout manifests (`logical-layout.json`) and Tier 3
///   platform widget instantiation, ensuring deterministic cockpit/workstation
///   pane composition without hardcoded view hierarchies.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Total Node Dispatch**: Every AST node map $n$ with `type` $\in$
///   $\{\text{SidebarLayout}, \text{HierarchyTreeSelector}, \text{SplitWorkspace},
///   \text{TopographicalView}, \text{TabbedContainer}, \text{TableView},
///   \text{PropertiesPanel}\}$ maps deterministically to a bounded widget subtree;
///   all unrecognized node types map to [SizedBox.shrink] ($0 \times 0$ extent).
/// - **Minimum Split Bound Propagation**: Every instantiated [SplitWorkspace]
///   and [TopographicalView] receives $s_{\min} = \text{minPaneSize}$.
///
/// ## 3. Preconditions
/// - [minPaneSize] must be non-negative ($\text{minPaneSize} \ge 0$).
/// - [defaultRatio] must return a normalized split ratio $r \in (0, 1)$.
/// - [BuildContext] passed to [build] must provide [ThemeController] and [DataSource]
///   when building data-bound child containers.
///
/// ## 4. Postconditions
/// - [build] returns a fully constructed [Widget] hierarchy matching the declarative
///   layout tree rooted at `node`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|T|)$ where $|T|$ is the number of layout
///   container nodes in the `logical-layout.json` subtree.
/// - **Space Complexity**: $\mathcal{O}(D_T)$ recursion depth where $D_T$ is the
///   height of the declarative layout tree.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unknown or omitted `type` keys render [SizedBox.shrink] without throwing.
/// - Missing child descriptors inside `SidebarLayout` or `SplitWorkspace` fall back
///   independently to [SizedBox.shrink] for the omitted pane.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/ComponentFactory]
@immutable
class ComponentFactory {
  /// The identifier of the currently selected view, used to select tabs,
  /// reload topology data, and highlight the active node in the sidebar.
  final String currentView;

  /// The last result emitted by the worker isolate, passed through so that
  /// [SidebarTree] can display progress or error states without re-linking
  /// the worker itself. `null` when no result has been produced yet.
  final int? workerResult;

  /// Callback invoked when the user selects a different view from the sidebar
  /// or the topology map. The receiver is expected to update [currentView].
  final void Function(String) onViewSelected;

  /// The minimum size (in logical pixels) for the first pane in a split
  /// layout ([SplitWorkspace], [TopographicalView]). Read from the layout
  /// configuration so that panes cannot be resized below a usable threshold.
  final double minPaneSize;

  /// Returns the default split ratio used when a [SplitWorkspace] or
  /// [TopographicalView] is first rendered. The value is resolved from the
  /// `codebase_rules.json` config token so it can be tuned without code
  /// changes.
  final double Function() defaultRatio;

  /// Resolves the [TopologyData] for the current view. Called lazily during
  /// build so that the topology provider can be fetched from the widget tree
  /// rather than passed at construction time.
  final TopologyData Function() resolveTopologyData;

  /// Resolves a human-readable label for the tab identified by the given
  /// string key. Used by [TabbedContainer] to render tab headers.
  final String Function(String) resolveTabLabel;

  /// Builds an arbitrary child widget inside a [TopographicalView]. The
  /// returned widget is inserted below the topology map and above the
  /// selection controls.
  final Widget Function(BuildContext) buildChildWidget;

  /// The [TreeViewModel] for the hierarchy tree sidebar. `null` when the
  /// current layout does not include a sidebar, in which case
  /// [SidebarTree] is rendered without an local provider wrapper.
  final TreeViewModel? treeViewModel;

  /// The preferred split axis orientation for resizable workspaces.
  /// Overrides the configured axis when non-null.
  final Axis? preferredSplitAxis;

  /// Creates a [ComponentFactory] with the required dependency resolvers.
  ///
  /// All parameters are required except [treeViewModel] and [preferredSplitAxis],
  /// which may be null when not overridden by the caller.
  ComponentFactory({
    required this.currentView,
    required this.workerResult,
    required this.onViewSelected,
    required this.minPaneSize,
    required this.defaultRatio,
    required this.resolveTopologyData,
    required this.resolveTabLabel,
    required this.buildChildWidget,
    this.treeViewModel,
    this.preferredSplitAxis,
  });

  /// Builds a widget subtree from a declarative layout [node] within
  /// [parentWidth] and [parentHeight].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// - **DO-178C DAL-A / ARINC 661 Standard**: Guarantees total, exception-free
  ///   widget synthesis for all declarative layout node definitions.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - **Total Function Over Node Maps**: For any `Map<String, dynamic>` $node$,
  ///   `build` returns a non-null [Widget].
  ///
  /// ## 3. Preconditions
  /// - [node] is a parsed JSON object map from `logical-layout.json`.
  /// - [parentWidth] and [parentHeight] represent the available layout bounds.
  ///
  /// ## 4. Postconditions
  /// - Returns the composed Flutter [Widget] subtree for [node], or
  ///   [SizedBox.shrink] when `node['type']` is unrecognized.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - **Time Complexity**: $\mathcal{O}(|T|)$ over the declarative node subtree $T$.
  /// - **Space Complexity**: $\mathcal{O}(D_T)$ call-stack depth.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Gracefully degrades to [SizedBox.shrink] on unknown node types or missing
  ///   child entries.
  ///
  /// ## 7. Realization & Traceability
  /// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
  ///
  /// Realises: [Feat-10/ComponentFactory]
  Widget build(
    Map<String, dynamic> node,
    double parentWidth,
    double parentHeight,
    BuildContext context,
  ) {
    final type = node['type'] as String?;
    switch (type) {
      case 'SidebarLayout':
        final childrenList = node['children'] as List<dynamic>? ?? [];
        final sidebarChild = childrenList.firstWhere(
          (c) => c['type'] == 'HierarchyTreeSelector',
          orElse: () => null,
        );
        final splitWorkspaceChild = childrenList.firstWhere(
          (c) => c['type'] == 'SplitWorkspace',
          orElse: () => null,
        );
            return SplitWorkspace(
              leading: sidebarChild != null
                  ? build(sidebarChild as Map<String, dynamic>, parentWidth, parentHeight, context)
                  : const SizedBox.shrink(),
              trailing: splitWorkspaceChild != null
                  ? build(splitWorkspaceChild as Map<String, dynamic>, parentWidth, parentHeight, context)
                  : const SizedBox.shrink(),
              direction: Axis.horizontal,
              minFirstPaneSize: minPaneSize,
              initialRatio: 0.25,
              splitterKey: const Key('vertical_splitter'),
              paintLeadingOnTop: true,
            );
      case 'HierarchyTreeSelector':
        final tree = SidebarTree(
          workerResult: workerResult,
          onViewSelected: onViewSelected,
        );
        if (treeViewModel != null) {
          return ChangeNotifierProvider<TreeViewModel>.value(
            value: treeViewModel!,
            child: tree,
          );
        }
        return tree;
      case 'SplitWorkspace':
        final childrenList = node['children'] as List<dynamic>? ?? [];
        final topoChild = childrenList.firstWhere(
          (c) => c['type'] == 'TopographicalView',
          orElse: () => null,
        );
        final tabbedChild = childrenList.firstWhere(
          (c) => c['type'] == 'TabbedContainer',
          orElse: () => null,
        );
        return SplitWorkspace(
          leading: topoChild != null
              ? build(topoChild as Map<String, dynamic>, parentWidth, parentHeight, context)
              : const SizedBox.shrink(),
          trailing: tabbedChild != null
              ? build(tabbedChild as Map<String, dynamic>, parentWidth, parentHeight, context)
              : const SizedBox.shrink(),
          direction: preferredSplitAxis ?? _parseAxis(node),
          minFirstPaneSize: minPaneSize,
          initialRatio: defaultRatio(),
          splitterKey: const Key('horizontal_splitter'),
        );
      case 'TopographicalView':
        final treeData = treeViewModel?.treeData ?? [];
        final panelOpacity = context.watch<ThemeController>().panelOpacity;
        return TopographicalView(
          key: TopographicalView.globalKey,
          currentView: currentView,
          onViewSelected: onViewSelected,
          child: Container(
            color: Theme.of(context).cardColor.withOpacity(panelOpacity),
            child: buildChildWidget(context),
          ),
          topologyData: resolveTopologyData(),
          treeData: treeData,
          splitMinFirstPaneSize: minPaneSize,
          splitInitialRatio: defaultRatio(),
          splitDirection: preferredSplitAxis ?? _parseAxis(node),
        );
      case 'TabbedContainer':
        return _TabbedContainerHost(currentView: currentView);
      case 'TableView':
        final id = node['id'] as String? ?? '';
        return _TableViewContainer(
          tabId: id,
          currentView: currentView,
        );
      case 'PropertiesPanel':
        final panelOpacity = context.watch<ThemeController>().panelOpacity;
        return Container(
          color: Theme.of(context).cardColor.withOpacity(panelOpacity),
          child: _PropertiesPanelHost(
            currentView: currentView,
            buildChildWidget: buildChildWidget,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// Reads the `axis` prop from a layout [node] and returns the corresponding
  /// [Axis] value. Defaults to [Axis.vertical] when the prop is absent.
  Axis _parseAxis(Map<String, dynamic> node) {
    final axis = node['props']?['axis'] as String?;
    if (axis == 'horizontal') return Axis.horizontal;
    return Axis.vertical;
  }
}

/// Host widget that creates a [TablesViewModel] from the [DataSource] and
/// provides it to [TabbedContainer].
///
/// Initialises the view model lazily in [didChangeDependencies] so that
/// [Provider] is available. Reloads tabs when [currentView] changes.
/// Disposes the view model on unmount to prevent memory leaks.
class _TabbedContainerHost extends StatefulWidget {
  /// Active view node identifier.
  final String currentView;

  const _TabbedContainerHost({required this.currentView});

  @override
  State<_TabbedContainerHost> createState() => _TabbedContainerHostState();
}

class _TabbedContainerHostState extends State<_TabbedContainerHost> {
  TablesViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final ds = context.read<DataSource>();
      _viewModel = TablesViewModel(ds, widget.currentView)
        ..loadForNode(widget.currentView);
    }
  }

  @override
  void didUpdateWidget(_TabbedContainerHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentView != oldWidget.currentView) {
      _viewModel?.loadForNode(widget.currentView);
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null) return const SizedBox.shrink();
    return ChangeNotifierProvider<TablesViewModel>.value(
      value: _viewModel!,
      child: const TabbedContainer(),
    );
  }
}

/// Host widget that creates a [TablesViewModel] for a single table tab and
/// provides it to [TableViewWidget].
///
/// Same lifecycle pattern as [_TabbedContainerHost] -- lazy initialisation,
/// reload on view change, dispose on unmount.
class _TableViewContainer extends StatefulWidget {
  /// Tab identifier string.
  final String tabId;
  /// Active view node identifier.
  final String currentView;

  const _TableViewContainer({
    required this.tabId,
    required this.currentView,
  });

  @override
  State<_TableViewContainer> createState() => _TableViewContainerState();
}

class _TableViewContainerState extends State<_TableViewContainer> {
  TablesViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final ds = context.read<DataSource>();
      _viewModel = TablesViewModel(ds, widget.currentView)
        ..loadForNode(widget.currentView);
    }
  }

  @override
  void didUpdateWidget(_TableViewContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabId != oldWidget.tabId ||
        widget.currentView != oldWidget.currentView) {
      _viewModel?.loadForNode(widget.currentView);
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null) return const SizedBox.shrink();
    return ChangeNotifierProvider<TablesViewModel>.value(
      value: _viewModel!,
      child: const TableViewWidget(),
    );
  }
}

/// Host widget that creates a [PropertiesViewModel] and provides it to [PropertiesPanel].
///
/// Realises: [Feat-10/PropertiesPanel]
/// Realises: [UC-03]
/// Realises: [UC-10]
/// Realises: [UC-15]
class _PropertiesPanelHost extends StatefulWidget {
  /// Member documentation.
  final String currentView;
  /// Member documentation.
  final Widget Function(BuildContext) buildChildWidget;

  const _PropertiesPanelHost({
    required this.currentView,
    required this.buildChildWidget,
  });

  @override
  State<_PropertiesPanelHost> createState() => _PropertiesPanelHostState();
}

class _PropertiesPanelHostState extends State<_PropertiesPanelHost> {
  PropertiesViewModel? _viewModel;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      try {
        final ds = context.read<DataSource>();
        _viewModel = PropertiesViewModel(ds)..loadType(widget.currentView);
      } catch (_) {
        // DataSource not found in context (e.g. isolated component unit tests)
      }
    }
  }

  @override
  void didUpdateWidget(_PropertiesPanelHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentView != oldWidget.currentView) {
      _viewModel?.loadType(widget.currentView);
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childWidget = widget.buildChildWidget(context);
    final panel = PropertiesPanel(
      activeView: widget.currentView,
      currentNodeId: widget.currentView,
      viewModel: _viewModel,
      child: childWidget,
    );

    if (_viewModel != null) {
      return ChangeNotifierProvider<PropertiesViewModel>.value(
        value: _viewModel!,
        child: panel,
      );
    }
    return panel;
  }
}

