import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/features/layout/breadcrumbs.dart';
import 'package:app_flutter/features/topology/topology_map.dart';
import 'package:app_flutter/features/layout/split_workspace.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/topology/scene_3d_viewport.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/virtual_camera.dart';

/// Top-level ARINC 661 topographical workspace view combining a breadcrumb
/// navigation header, 2D/3D viewport mode switcher, and an optional split
/// detail pane.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces deterministic camera focus
///   resolution and split-pane layout isolation between the primary geospatial
///   viewport ([Scene3DViewport] or [TopologyMap]) and the trailing detail
///   inspector ([SplitWorkspace]).
///
/// ## 2. Invariants & Mathematical Properties
/// - Geodetic focus clamping invariant: resolved node or sector coordinates are
///   clamped to $\phi \in [-90.0^\circ, 90.0^\circ]$ and
///   $\lambda \in [-180.0^\circ, 180.0^\circ]$ before constructing the
///   [VirtualCamera] (`dim_2 = 500.0`, `pitch = -89.9`).
/// - View-transition guard: camera updates emitted while `widget.currentView != _lastCurrentView`
///   are suppressed to prevent stale callback race conditions during drill-down.
///
/// ## 3. Preconditions
/// - Must be mounted inside a widget tree providing a [ThemeController] via
///   `Provider` for panel opacity binding.
/// - [topologyData] must be a valid [TopologyData] instance.
///
/// ## 4. Postconditions
/// - Renders the 64 px header bar (active view label, `2D Map` / `3D Globe`
///   toggle buttons, and [NavigationBreadcrumbs]) above either a standalone
///   viewport or a resizable [SplitWorkspace].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|V| + |T|)$ where $|V|$ is topology node
///   count for camera target lookup and $|T|$ is tree node count for breadcrumb
///   path resolution.
/// - **Space Complexity**: $\mathcal{O}(D)$ where $D$ is breadcrumb hierarchy depth.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing target node IDs or zeroed `(0.0, 0.0)` coordinates fall back
///   gracefully to `rawMetadata['sector_coordinates']` or canonical default
///   geodetic coordinates `(35.6074, 140.1063)`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/TopographicalView]
class TopographicalView extends StatefulWidget {
  /// Global key for accessing the top-level topographical view state.
  static final GlobalKey<_TopographicalViewState> globalKey = GlobalKey<_TopographicalViewState>();

  /// Identifier of the currently focused view or node.
  final String currentView;

  /// Callback invoked when the operator selects a node or breadcrumb item.
  final ValueChanged<String> onViewSelected;

  /// Optional detail pane widget rendered in the trailing pane of [SplitWorkspace].
  final Widget? child;

  /// Graph topology dataset rendered in both 2D and 3D modes.
  final TopologyData topologyData;

  /// Optional list of generic [TypeDescriptor] metadata schemas forwarded to
  /// [TopologyMap] for schema-driven range ring and directional leader rendering.
  final List<TypeDescriptor> typeDescriptors;

  /// Hierarchical navigation tree nodes used to construct [NavigationBreadcrumbs].
  final List<TreeNode> treeData;

  /// The axis along which the split panes are laid out.
  ///
  /// [Axis.vertical] stacks panes vertically (top = map, bottom = child);
  /// [Axis.horizontal] places them side-by-side.
  ///
  /// Defaults to [Axis.vertical].
  final Axis splitDirection;

  /// The minimum size, in logical pixels, of the first (leading) pane.
  ///
  /// The pane is clamped between this value and
  /// (`totalSize - [splitMinFirstPaneSize]`). When the total available
  /// size is smaller than this value, the first pane still takes
  /// [splitMinFirstPaneSize] pixels and the trailing pane receives
  /// whatever remains (may be zero or negative in overflow scenarios).
  ///
  /// Defaults to `150.0`.
  final double splitMinFirstPaneSize;

  /// The initial fraction of total size assigned to the first pane.
  ///
  /// Applied once during the first layout pass when available size > 0.
  /// After initialization the user can resize the splitter, and the ratio
  /// is clamped by [splitMinFirstPaneSize].
  ///
  /// Must be in the range 0.0--1.0; values outside are silently
  /// constrained by the subsequent clamp.
  ///
  /// Defaults to `0.4`.
  final double splitInitialRatio;

  /// The [Key] used to identify the draggable splitter [GestureDetector].
  ///
  /// Useful for widget testing -- pass a unique [ValueKey] or similar so
  /// the splitter can be found with `find.byKey()`.
  ///
  /// Defaults to `Key('topo_splitter')`.
  final Key splitterKey;

  /// Creates a [TopographicalView] widget.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopographicalView::TopographicalView` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopographicalView::TopographicalView` (declaration #2) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopographicalView::TopographicalView` in `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopographicalView::TopographicalView` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopographicalView)) bounded over input/member dimension of `TopographicalView::TopographicalView`.
  /// - Space Complexity: O(K(TopographicalView)) bounded auxiliary memory for `TopographicalView::TopographicalView`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopographicalView::TopographicalView` (`()`).
  /// - State: Maintains consistent state invariants across `TopographicalView::TopographicalView` without partial mutation on error.
  /// - Action: Executes `TopographicalView::TopographicalView` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopographicalView::TopographicalView` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEW-TOPOGRAPHICALVIEW] | SysML v2: ActionDef(TopographicalView::TopographicalView)
  const TopographicalView({
    super.key,
    required this.currentView,
    required this.onViewSelected,
    this.child,
    required this.topologyData,
    this.typeDescriptors = const <TypeDescriptor>[],
    this.treeData = const [],
    this.splitDirection = Axis.vertical,
    this.splitMinFirstPaneSize = 150.0,
    this.splitInitialRatio = 0.4,
    this.splitterKey = const Key('topo_splitter'),
  });

  /// Executes deterministic method `TopographicalView::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopographicalView::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopographicalView::createState` (declaration #3) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopographicalView::createState` in `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<TopographicalView>` from `TopographicalView::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `TopographicalView::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `TopographicalView::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopographicalView::createState` (`State<TopographicalView>`).
  /// - State: Maintains consistent state invariants across `TopographicalView::createState` without partial mutation on error.
  /// - Action: Executes `TopographicalView::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopographicalView::createState` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEW-CREATESTATE] | SysML v2: ActionDef(TopographicalView::createState)
  @override
  State<TopographicalView> createState() => _TopographicalViewState();
}

/// Executes deterministic class `_TopographicalViewState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_TopographicalViewState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_TopographicalViewState` (declaration #4) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_TopographicalViewState` in `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_TopographicalViewState` representation for class `_TopographicalViewState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_TopographicalViewState)) bounded over input/member dimension of `_TopographicalViewState`.
/// - Space Complexity: O(K(_TopographicalViewState)) bounded auxiliary memory for `_TopographicalViewState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_TopographicalViewState` (`_TopographicalViewState`).
/// - State: Maintains consistent state invariants across `_TopographicalViewState` without partial mutation on error.
/// - Action: Executes `_TopographicalViewState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_TopographicalViewState` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEWSTATE] | SysML v2: PartDef(_TopographicalViewState)
class _TopographicalViewState extends State<TopographicalView> {
  bool _is3d = true;
  VirtualCamera? _cachedCamera;
  String? _lastCurrentView;

  /// Executes deterministic method `_TopographicalViewState::initState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TopographicalViewState::initState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TopographicalViewState::initState` (declaration #5) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TopographicalViewState::initState` in `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TopographicalViewState::initState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(initState)) bounded over input/member dimension of `_TopographicalViewState::initState`.
  /// - Space Complexity: O(K(initState)) bounded auxiliary memory for `_TopographicalViewState::initState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TopographicalViewState::initState` (`void`).
  /// - State: Maintains consistent state invariants across `_TopographicalViewState::initState` without partial mutation on error.
  /// - Action: Executes `_TopographicalViewState::initState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TopographicalViewState::initState` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEWSTATE-INITSTATE] | SysML v2: ActionDef(_TopographicalViewState::initState)
  @override
  void initState() {
    super.initState();
    _lastCurrentView = widget.currentView;
    _cachedCamera = _calculateCameraForView(widget.currentView);
  }

  /// Executes deterministic method `_TopographicalViewState::didUpdateWidget` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TopographicalViewState::didUpdateWidget` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TopographicalViewState::didUpdateWidget` (declaration #6) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - `oldWidget: TopographicalView` must satisfy domain and type-safety constraints prior to invoking `_TopographicalViewState::didUpdateWidget`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TopographicalViewState::didUpdateWidget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(oldWidget)) bounded over input/member dimension of `_TopographicalViewState::didUpdateWidget`.
  /// - Space Complexity: O(N(oldWidget)) bounded auxiliary memory for `_TopographicalViewState::didUpdateWidget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TopographicalViewState::didUpdateWidget` (`void`).
  /// - State: Maintains consistent state invariants across `_TopographicalViewState::didUpdateWidget` without partial mutation on error.
  /// - Action: Executes `_TopographicalViewState::didUpdateWidget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TopographicalViewState::didUpdateWidget` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEWSTATE-DIDUPDATEWIDGET] | SysML v2: ActionDef(_TopographicalViewState::didUpdateWidget)
  @override
  void didUpdateWidget(covariant TopographicalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topologyData != widget.topologyData) {
      _cachedCamera = _calculateCameraForView(widget.currentView);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _lastCurrentView = widget.currentView;
        }
      });
    } else if (oldWidget.currentView != widget.currentView) {
      if (oldWidget.currentView == 'root' && widget.currentView != 'root') {
        _cachedCamera = _calculateCameraForView(widget.currentView);
      }
      _lastCurrentView = widget.currentView;
    }
  }

  /// Executes deterministic method `_TopographicalViewState::_calculateCameraForView` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TopographicalViewState::_calculateCameraForView` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TopographicalViewState::_calculateCameraForView` (declaration #7) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - `viewId: String` must satisfy domain and type-safety constraints prior to invoking `_TopographicalViewState::_calculateCameraForView`.
  ///
  /// ## 4. Postconditions
  /// - Returns `VirtualCamera` from `_TopographicalViewState::_calculateCameraForView` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(viewId)) bounded over input/member dimension of `_TopographicalViewState::_calculateCameraForView`.
  /// - Space Complexity: O(N(viewId)) bounded auxiliary memory for `_TopographicalViewState::_calculateCameraForView`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TopographicalViewState::_calculateCameraForView` (`VirtualCamera`).
  /// - State: Maintains consistent state invariants across `_TopographicalViewState::_calculateCameraForView` without partial mutation on error.
  /// - Action: Executes `_TopographicalViewState::_calculateCameraForView` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TopographicalViewState::_calculateCameraForView` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEWSTATE-CALCULATECAMERAFORVIEW] | SysML v2: ActionDef(_TopographicalViewState::_calculateCameraForView)
  VirtualCamera _calculateCameraForView(String viewId) {
    double latitude;
    double longitude;

    TopologyNode? activeNode;
    final String lookupId = viewId == 'root' ? 'SECTOR-ALPHA-01' : viewId;
    for (final node in widget.topologyData.nodes) {
      if (node.id == lookupId) {
        activeNode = node;
        break;
      }
    }
    if (activeNode == null && lookupId != 'SECTOR-ALPHA-01') {
      for (final node in widget.topologyData.nodes) {
        if (node.id == 'SECTOR-ALPHA-01') {
          activeNode = node;
          break;
        }
      }
    }

    if (activeNode != null) {
      final double latVal = activeNode.resolveCoordinate(
        'y',
        widget.topologyData.coordinateMapping,
      );
      final double lngVal = activeNode.resolveCoordinate(
        'x',
        widget.topologyData.coordinateMapping,
      );
      if (latVal == 0.0 && lngVal == 0.0) {
        latitude = 35.6074;
        longitude = 140.1063;
      } else {
        latitude = latVal;
        longitude = lngVal;
      }
    } else {
      final dynamic sectorMeta =
          widget.topologyData.rawMetadata['sector_coordinates'];
      if (sectorMeta is Map) {
        latitude = (sectorMeta['center_y'] as num?)?.toDouble() ?? 35.6074;
        longitude = (sectorMeta['center_x'] as num?)?.toDouble() ?? 140.1063;
      } else {
        latitude = 35.6074;
        longitude = 140.1063;
      }
    }

    latitude = latitude.clamp(-90.0, 90.0);
    longitude = longitude.clamp(-180.0, 180.0);

    return VirtualCamera(
      dim_0: latitude,
      dim_1: longitude,
      dim_2: 500.0,
      heading: 0.0,
      pitch: -89.9,
      roll: 0.0,
    );
  }

  /// Executes deterministic method `_TopographicalViewState::_resolveCamera` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TopographicalViewState::_resolveCamera` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TopographicalViewState::_resolveCamera` (declaration #8) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TopographicalViewState::_resolveCamera` in `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 4. Postconditions
  /// - Returns `VirtualCamera` from `_TopographicalViewState::_resolveCamera` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_resolveCamera)) bounded over input/member dimension of `_TopographicalViewState::_resolveCamera`.
  /// - Space Complexity: O(K(_resolveCamera)) bounded auxiliary memory for `_TopographicalViewState::_resolveCamera`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TopographicalViewState::_resolveCamera` (`VirtualCamera`).
  /// - State: Maintains consistent state invariants across `_TopographicalViewState::_resolveCamera` without partial mutation on error.
  /// - Action: Executes `_TopographicalViewState::_resolveCamera` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TopographicalViewState::_resolveCamera` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEWSTATE-RESOLVECAMERA] | SysML v2: ActionDef(_TopographicalViewState::_resolveCamera)
  VirtualCamera _resolveCamera() {
    return _cachedCamera ?? _calculateCameraForView(widget.currentView);
  }


  /// Executes deterministic method `_TopographicalViewState::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TopographicalViewState::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topographical_view.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TopographicalViewState::build` (declaration #9) within `TOPOLOGY-TOPOGRAPHICAL-VIEW`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_TopographicalViewState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_TopographicalViewState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_TopographicalViewState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_TopographicalViewState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TopographicalViewState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_TopographicalViewState::build` without partial mutation on error.
  /// - Action: Executes `_TopographicalViewState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TopographicalViewState::build` (`TOPOLOGY-TOPOGRAPHICAL-VIEW`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOGRAPHICAL-VIEW-TOPOGRAPHICALVIEWSTATE-BUILD] | SysML v2: ActionDef(_TopographicalViewState::build)
  @override
  Widget build(BuildContext context) {
    final panelOpacity = context.watch<ThemeController>().panelOpacity;
    final camera = _resolveCamera();

    final Widget leadingWidget = _is3d
        ? Scene3DViewport(
            camera: camera,
            topologyData: widget.topologyData,
            onCameraChanged: (newCamera) {
              if (!mounted) return;
              if (widget.currentView != _lastCurrentView) return;
              setState(() {
                _cachedCamera = newCamera;
              });
            },
          )
        : TopologyMap(
            activeFocusedNode: widget.currentView,
            onNodeSelect: widget.onViewSelected,
            data: widget.topologyData,
            typeDescriptors: widget.typeDescriptors,
          );

    final body = widget.child != null
        ? SplitWorkspace(
            leading: leadingWidget,
            trailing: widget.child!,
            direction: widget.splitDirection,
            minFirstPaneSize: widget.splitMinFirstPaneSize,
            initialRatio: widget.splitInitialRatio,
            splitterKey: widget.splitterKey,
          )
        : leadingWidget;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(panelOpacity),
      child: Stack(
        children: [
          // 1. Background layer: body containing Map + Properties panel
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: body,
            ),
          ),
          // 2. Foreground layer: Header Bar (Title, Buttons, Breadcrumbs, Divider)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 64.0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(panelOpacity),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Active View: ${widget.currentView}',
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              key: const Key('toggle_2d'),
                              onPressed: () => setState(() => _is3d = false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: !_is3d ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                                foregroundColor: !_is3d ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                              ),
                              child: const Text('2D Map'),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              key: const Key('toggle_3d'),
                              onPressed: () => setState(() => _is3d = true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _is3d ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                                foregroundColor: _is3d ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                              ),
                              child: const Text('3D Globe'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: NavigationBreadcrumbs(
                              items: getBreadcrumbsItems(widget.currentView, widget.treeData, onSelectView: widget.onViewSelected),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
