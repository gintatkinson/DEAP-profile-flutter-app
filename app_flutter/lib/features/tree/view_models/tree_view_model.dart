import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/tree/tree_defaults.dart';

/// Immutable state holder for the sidebar hierarchy [TreeViewModel].
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `TreeState` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `TreeState` (declaration #1) within `VIEW-MODELS-TREE-VIEW-MODEL`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `TreeState` in `VIEW-MODELS-TREE-VIEW-MODEL`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `TreeState` representation for class `TreeState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(TreeState)) bounded over input/member dimension of `TreeState`.
/// - Space Complexity: O(K(TreeState)) bounded auxiliary memory for `TreeState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `TreeState` (`TreeState`).
/// - State: Maintains consistent state invariants across `TreeState` without partial mutation on error.
/// - Action: Executes `TreeState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `TreeState` (`VIEW-MODELS-TREE-VIEW-MODEL`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeState] | SysML v2: PartDef(TreeState)
@immutable
class TreeState {
  /// Creates an immutable [TreeState] snapshot.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TreeState::TreeState` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TreeState::TreeState` (declaration #2) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeState::TreeState` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeState::TreeState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TreeState)) bounded over input/member dimension of `TreeState::TreeState`.
  /// - Space Complexity: O(K(TreeState)) bounded auxiliary memory for `TreeState::TreeState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeState::TreeState` (`()`).
  /// - State: Maintains consistent state invariants across `TreeState::TreeState` without partial mutation on error.
  /// - Action: Executes `TreeState::TreeState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeState::TreeState` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREESTATE-TREESTATE] | SysML v2: ActionDef(TreeState::TreeState)
  const TreeState({
    this.treeData = const [],
    this.currentView = '',
    this.expanded = const {},
    this.loadingNodes = const {},
    this.flightTarget,
  });

  /// Current tree nodes.
  final List<TreeNode> treeData;

  /// Currently selected view ID.
  final String currentView;

  /// Map of node expansion state.
  final Map<String, bool> expanded;

  /// Map of node loading state.
  final Map<String, bool> loadingNodes;

  /// Camera flight target node ID.
  final String? flightTarget;

  /// Creates a copy of this state with updated values.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeState::copyWith` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeState::copyWith` (declaration #3) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeState::copyWith` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TreeState` from `TreeState::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `TreeState::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `TreeState::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeState::copyWith` (`TreeState`).
  /// - State: Maintains consistent state invariants across `TreeState::copyWith` without partial mutation on error.
  /// - Action: Executes `TreeState::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeState::copyWith` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREESTATE-COPYWITH] | SysML v2: ActionDef(TreeState::copyWith)
  TreeState copyWith({
    List<TreeNode>? treeData,
    String? currentView,
    Map<String, bool>? expanded,
    Map<String, bool>? loadingNodes,
    String? flightTarget,
    bool clearFlightTarget = false,
  }) {
    return TreeState(
      treeData: treeData ?? this.treeData,
      currentView: currentView ?? this.currentView,
      expanded: expanded ?? this.expanded,
      loadingNodes: loadingNodes ?? this.loadingNodes,
      flightTarget: clearFlightTarget ? null : (flightTarget ?? this.flightTarget),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeState &&
          runtimeType == other.runtimeType &&
          listEquals(treeData, other.treeData) &&
          currentView == other.currentView &&
          mapEquals(expanded, other.expanded) &&
          mapEquals(loadingNodes, other.loadingNodes) &&
          flightTarget == other.flightTarget;

  /// Executes deterministic method `TreeState::hashCode` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeState::hashCode` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeState::hashCode` (declaration #4) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeState::hashCode` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeState::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(hashCode)) bounded over input/member dimension of `TreeState::hashCode`.
  /// - Space Complexity: O(K(hashCode)) bounded auxiliary memory for `TreeState::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeState::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `TreeState::hashCode` without partial mutation on error.
  /// - Action: Executes `TreeState::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeState::hashCode` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREESTATE-HASHCODE] | SysML v2: ActionDef(TreeState::hashCode)
  @override
  int get hashCode => Object.hash(
        Object.hashAll(treeData),
        currentView,
        Object.hashAll(expanded.keys),
        Object.hashAll(expanded.values),
        flightTarget,
      );
}

/// Determines if a [node] represents a primitive leaf attribute descriptor
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for fn `isPrimitiveAttribute` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for fn `isPrimitiveAttribute` (declaration #4) within `VIEW-MODELS-TREE-VIEW-MODEL`.
///
/// ## 3. Preconditions
/// - `node: TreeNode` must satisfy domain and type-safety constraints prior to invoking `isPrimitiveAttribute`.
///
/// ## 4. Postconditions
/// - Returns `bool` from `isPrimitiveAttribute` with deterministic post-execution state.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(N(node)) bounded over input/member dimension of `isPrimitiveAttribute`.
/// - Space Complexity: O(N(node)) bounded auxiliary memory for `isPrimitiveAttribute`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `isPrimitiveAttribute` (`bool`).
/// - State: Maintains consistent state invariants across `isPrimitiveAttribute` without partial mutation on error.
/// - Action: Executes `isPrimitiveAttribute` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `isPrimitiveAttribute` (`VIEW-MODELS-TREE-VIEW-MODEL`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeViewModel] | SysML v2: ActionDef(isPrimitiveAttribute)
bool isPrimitiveAttribute(TreeNode node) {
  final _labelLower = node.label.toLowerCase();
  final _idLower = node.id.toLowerCase();
  const _primitives = {
    'as number', 'cartesian coordinate', 'counter 32', 'domain name',
    'ellipsoid coordinate', 'email address', 'gauge 32', 'geo location',
    'geodetic system', 'hours 32', 'ip version', 'ipv4 address',
    'ipv4 prefix', 'ipv6 address', 'mac address', 'oid', 'physical address',
    'port number', 'reference frame', 'time ticks', 'uri', 'velocity',
    'yang date time',
  };
  return _primitives.contains(_labelLower) || _primitives.contains(_idLower);
}

/// Determines if a [node] is a container entity eligible for root tree
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for fn `isContainerEntity` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for fn `isContainerEntity` (declaration #5) within `VIEW-MODELS-TREE-VIEW-MODEL`.
///
/// ## 3. Preconditions
/// - `node: TreeNode` must satisfy domain and type-safety constraints prior to invoking `isContainerEntity`.
///
/// ## 4. Postconditions
/// - Returns `bool` from `isContainerEntity` with deterministic post-execution state.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(N(node)) bounded over input/member dimension of `isContainerEntity`.
/// - Space Complexity: O(N(node)) bounded auxiliary memory for `isContainerEntity`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `isContainerEntity` (`bool`).
/// - State: Maintains consistent state invariants across `isContainerEntity` without partial mutation on error.
/// - Action: Executes `isContainerEntity` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `isContainerEntity` (`VIEW-MODELS-TREE-VIEW-MODEL`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeViewModel] | SysML v2: ActionDef(isContainerEntity)
bool isContainerEntity(TreeNode node) {
  return !isPrimitiveAttribute(node);
}

/// View model driving the sidebar hierarchy tree: data loading, natural sorting,
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `TreeViewModel` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `TreeViewModel` (declaration #6) within `VIEW-MODELS-TREE-VIEW-MODEL`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `TreeViewModel` in `VIEW-MODELS-TREE-VIEW-MODEL`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `TreeViewModel` representation for class `TreeViewModel`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(TreeViewModel)) bounded over input/member dimension of `TreeViewModel`.
/// - Space Complexity: O(K(TreeViewModel)) bounded auxiliary memory for `TreeViewModel`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `TreeViewModel` (`TreeViewModel`).
/// - State: Maintains consistent state invariants across `TreeViewModel` without partial mutation on error.
/// - Action: Executes `TreeViewModel` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `TreeViewModel` (`VIEW-MODELS-TREE-VIEW-MODEL`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeViewModel] | SysML v2: PartDef(TreeViewModel)
class TreeViewModel extends ChangeNotifier {
  /// Creates a [TreeViewModel] bound to [_treeRepository].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TreeViewModel::TreeViewModel` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TreeViewModel::TreeViewModel` (declaration #7) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `_treeRepository: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::TreeViewModel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::TreeViewModel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(_treeRepository)) bounded over input/member dimension of `TreeViewModel::TreeViewModel`.
  /// - Space Complexity: O(N(_treeRepository)) bounded auxiliary memory for `TreeViewModel::TreeViewModel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::TreeViewModel` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::TreeViewModel` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::TreeViewModel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::TreeViewModel` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-TREEVIEWMODEL] | SysML v2: ActionDef(TreeViewModel::TreeViewModel)
  TreeViewModel(this._treeRepository, {
    String initialView = '',
    this.onViewSelected,
  }) : _state = TreeState(currentView: initialView);

  final TreeRepository _treeRepository;

  /// Optional external callback invoked when [selectView] transitions to a new view ID.
  final ValueChanged<String>? onViewSelected;

  TreeState _state;
  final FocusNode _treeFocusNode = FocusNode();
  final Map<String, GlobalKey> _nodeKeys = {};
  bool _disposed = false;

  /// Current immutable state.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::state` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::state` (declaration #9) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::state` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::state` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(state)) bounded over input/member dimension of `TreeViewModel::state`.
  /// - Space Complexity: O(K(state)) bounded auxiliary memory for `TreeViewModel::state`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::state` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::state` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::state` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::state` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-STATE] | SysML v2: ActionDef(TreeViewModel::state)
  TreeState get state => _state;

  /// Current root-level hierarchy nodes.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::treeData` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::treeData` (declaration #10) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::treeData` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::treeData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(treeData)) bounded over input/member dimension of `TreeViewModel::treeData`.
  /// - Space Complexity: O(K(treeData)) bounded auxiliary memory for `TreeViewModel::treeData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::treeData` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::treeData` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::treeData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::treeData` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-TREEDATA] | SysML v2: ActionDef(TreeViewModel::treeData)
  List<TreeNode> get treeData => _state.treeData;

  /// Identifier of the currently selected view node.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::currentView` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::currentView` (declaration #11) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::currentView` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::currentView` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(currentView)) bounded over input/member dimension of `TreeViewModel::currentView`.
  /// - Space Complexity: O(K(currentView)) bounded auxiliary memory for `TreeViewModel::currentView`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::currentView` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::currentView` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::currentView` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::currentView` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-CURRENTVIEW] | SysML v2: ActionDef(TreeViewModel::currentView)
  String get currentView => _state.currentView;

  /// Map of node IDs to their current expansion state.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::expanded` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::expanded` (declaration #12) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::expanded` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::expanded` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(expanded)) bounded over input/member dimension of `TreeViewModel::expanded`.
  /// - Space Complexity: O(K(expanded)) bounded auxiliary memory for `TreeViewModel::expanded`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::expanded` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::expanded` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::expanded` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::expanded` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-EXPANDED] | SysML v2: ActionDef(TreeViewModel::expanded)
  Map<String, bool> get expanded => _state.expanded;

  /// Map of node IDs currently undergoing asynchronous child loading.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::loadingNodes` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::loadingNodes` (declaration #13) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::loadingNodes` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::loadingNodes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadingNodes)) bounded over input/member dimension of `TreeViewModel::loadingNodes`.
  /// - Space Complexity: O(K(loadingNodes)) bounded auxiliary memory for `TreeViewModel::loadingNodes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::loadingNodes` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::loadingNodes` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::loadingNodes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::loadingNodes` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-LOADINGNODES] | SysML v2: ActionDef(TreeViewModel::loadingNodes)
  Map<String, bool> get loadingNodes => _state.loadingNodes;

  /// Keyboard focus node bound to the sidebar tree container.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::focusNode` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::focusNode` (declaration #14) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::focusNode` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::focusNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(focusNode)) bounded over input/member dimension of `TreeViewModel::focusNode`.
  /// - Space Complexity: O(K(focusNode)) bounded auxiliary memory for `TreeViewModel::focusNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::focusNode` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::focusNode` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::focusNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::focusNode` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-FOCUSNODE] | SysML v2: ActionDef(TreeViewModel::focusNode)
  FocusNode get focusNode => _treeFocusNode;

  /// Returns the [GlobalKey] registered for the node with [id], if any.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::nodeKey` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::nodeKey` (declaration #8) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `id: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::nodeKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `GlobalKey?` from `TreeViewModel::nodeKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(id)) bounded over input/member dimension of `TreeViewModel::nodeKey`.
  /// - Space Complexity: O(N(id)) bounded auxiliary memory for `TreeViewModel::nodeKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::nodeKey` (`GlobalKey?`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::nodeKey` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::nodeKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::nodeKey` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-NODEKEY] | SysML v2: ActionDef(TreeViewModel::nodeKey)
  GlobalKey? nodeKey(String id) => _nodeKeys[id];

  /// Optional node ID targeted for 3D viewport camera flight.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::flightTarget` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::flightTarget` (declaration #16) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::flightTarget` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeViewModel::flightTarget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(flightTarget)) bounded over input/member dimension of `TreeViewModel::flightTarget`.
  /// - Space Complexity: O(K(flightTarget)) bounded auxiliary memory for `TreeViewModel::flightTarget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::flightTarget` (`()`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::flightTarget` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::flightTarget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::flightTarget` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-FLIGHTTARGET] | SysML v2: ActionDef(TreeViewModel::flightTarget)
  String? get flightTarget => _state.flightTarget;

  /// Loads the type hierarchy from the data source and initialises tree data,
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::loadTree` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::loadTree` (declaration #9) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::loadTree` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `TreeViewModel::loadTree` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadTree)) bounded over input/member dimension of `TreeViewModel::loadTree`.
  /// - Space Complexity: O(K(loadTree)) bounded auxiliary memory for `TreeViewModel::loadTree`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::loadTree` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::loadTree` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::loadTree` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::loadTree` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-LOADTREE] | SysML v2: ActionDef(TreeViewModel::loadTree)
  Future<void> loadTree() async {
    final rootRes = await _treeRepository.fetchRootNodes();
    if (_disposed) return;

    final List<TreeNode> roots;
    switch (rootRes) {
      case Success<List<TreeNode>>(:final value):
        roots = value;
      case Failure<List<TreeNode>>():
        roots = <TreeNode>[];
    }

    final loadedTreeData = (roots.isNotEmpty
            ? List<TreeNode>.from(roots)
            : List<TreeNode>.from(defaultTreeData))
        .where(isContainerEntity)
        .toList();
    _sortNodesRecursively(loadedTreeData);

    _nodeKeys.clear();

    String view = _state.currentView;
    if (view.isEmpty && loadedTreeData.isNotEmpty) {
      view = loadedTreeData.first.id;
    }

    final newExpanded = <String, bool>{};
    _expandParentsPath(loadedTreeData, view, newExpanded);

    _state = _state.copyWith(
      treeData: loadedTreeData,
      currentView: view,
      expanded: newExpanded,
      loadingNodes: const {},
    );

    final currentNode = _findNodeById(loadedTreeData, view);
    if (currentNode != null && currentNode.children != null) {
      await expandNode(currentNode);
    }

    _buildNodeKeys(_state.treeData);
    notifyListeners();
  }

  /// Selects [viewId] as the current view, expands its ancestors, scrolls it
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::selectView` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::selectView` (declaration #10) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `viewId: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::selectView`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::selectView` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(viewId)) bounded over input/member dimension of `TreeViewModel::selectView`.
  /// - Space Complexity: O(N(viewId)) bounded auxiliary memory for `TreeViewModel::selectView`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::selectView` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::selectView` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::selectView` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::selectView` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-SELECTVIEW] | SysML v2: ActionDef(TreeViewModel::selectView)
  void selectView(String viewId) {
    if (_state.currentView == viewId) return;
    final newExpanded = Map<String, bool>.from(_state.expanded);
    _expandParentsPath(_state.treeData, viewId, newExpanded);

    _state = _state.copyWith(
      currentView: viewId,
      expanded: newExpanded,
    );

    final node = _findNodeById(_state.treeData, viewId);
    if (node != null && node.children != null && _state.expanded[viewId] != true) {
      expandNode(node);
    }
    _scrollToNode(viewId);
    notifyListeners();
    onViewSelected?.call(viewId);
  }

  /// Sets [flightTarget] to [nodeId] and notifies listeners to initiate camera flight.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::triggerFlight` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::triggerFlight` (declaration #11) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::triggerFlight`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::triggerFlight` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `TreeViewModel::triggerFlight`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `TreeViewModel::triggerFlight`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::triggerFlight` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::triggerFlight` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::triggerFlight` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::triggerFlight` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-TRIGGERFLIGHT] | SysML v2: ActionDef(TreeViewModel::triggerFlight)
  void triggerFlight(String nodeId) {
    _state = _state.copyWith(flightTarget: nodeId);
    notifyListeners();
  }

  /// Clears the active [flightTarget] without notifying listeners.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::clearFlightTarget` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::clearFlightTarget` (declaration #12) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::clearFlightTarget` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::clearFlightTarget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(clearFlightTarget)) bounded over input/member dimension of `TreeViewModel::clearFlightTarget`.
  /// - Space Complexity: O(K(clearFlightTarget)) bounded auxiliary memory for `TreeViewModel::clearFlightTarget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::clearFlightTarget` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::clearFlightTarget` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::clearFlightTarget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::clearFlightTarget` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-CLEARFLIGHTTARGET] | SysML v2: ActionDef(TreeViewModel::clearFlightTarget)
  void clearFlightTarget() {
    _state = _state.copyWith(clearFlightTarget: true);
  }

  /// Updates the current view (without firing [selectView]'s external callback).
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::updateCurrentView` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::updateCurrentView` (declaration #13) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `viewId: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::updateCurrentView`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::updateCurrentView` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(viewId)) bounded over input/member dimension of `TreeViewModel::updateCurrentView`.
  /// - Space Complexity: O(N(viewId)) bounded auxiliary memory for `TreeViewModel::updateCurrentView`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::updateCurrentView` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::updateCurrentView` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::updateCurrentView` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::updateCurrentView` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-UPDATECURRENTVIEW] | SysML v2: ActionDef(TreeViewModel::updateCurrentView)
  void updateCurrentView(String viewId) {
    if (_state.currentView == viewId) return;
    final newExpanded = Map<String, bool>.from(_state.expanded);
    _expandParentsPath(_state.treeData, viewId, newExpanded);

    _state = _state.copyWith(
      currentView: viewId,
      expanded: newExpanded,
    );

    final node = _findNodeById(_state.treeData, viewId);
    if (node != null && node.children != null && _state.expanded[viewId] != true) {
      expandNode(node);
    }
    _scrollToNode(viewId);
    notifyListeners();
  }

  /// Toggles expansion state of the node with [id] and lazily loads children.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::toggleExpand` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::toggleExpand` (declaration #14) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `id: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::toggleExpand`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::toggleExpand` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(id)) bounded over input/member dimension of `TreeViewModel::toggleExpand`.
  /// - Space Complexity: O(N(id)) bounded auxiliary memory for `TreeViewModel::toggleExpand`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::toggleExpand` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::toggleExpand` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::toggleExpand` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::toggleExpand` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-TOGGLEEXPAND] | SysML v2: ActionDef(TreeViewModel::toggleExpand)
  void toggleExpand(String id) {
    final node = _findNodeById(_state.treeData, id);
    if (node != null) {
      expandNode(node);
    } else {
      final newExpanded = Map<String, bool>.from(_state.expanded);
      newExpanded[id] = !(newExpanded[id] ?? false);
      _state = _state.copyWith(expanded: newExpanded);
      notifyListeners();
    }
  }

  /// Recursively expands a node, loading its children if necessary.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::expandNode` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::expandNode` (declaration #15) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `node: TreeNode` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::expandNode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `TreeViewModel::expandNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(node)) bounded over input/member dimension of `TreeViewModel::expandNode`.
  /// - Space Complexity: O(N(node)) bounded auxiliary memory for `TreeViewModel::expandNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::expandNode` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::expandNode` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::expandNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::expandNode` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-EXPANDNODE] | SysML v2: ActionDef(TreeViewModel::expandNode)
  Future<void> expandNode(TreeNode node) async {
    if (_state.expanded[node.id] == true) {
      final newExpanded = Map<String, bool>.from(_state.expanded);
      newExpanded[node.id] = false;
      _state = _state.copyWith(expanded: newExpanded);
      notifyListeners();
      return;
    }

    if (node.children != null && node.children!.isEmpty) {
      if (_state.loadingNodes[node.id] == true) return;

      final newLoading = Map<String, bool>.from(_state.loadingNodes);
      newLoading[node.id] = true;
      _state = _state.copyWith(loadingNodes: newLoading);
      notifyListeners();

      try {
        final childRes = await _treeRepository.fetchChildrenForNode(node.id);
        if (_disposed) return;
        if (!_state.loadingNodes.containsKey(node.id)) return;

        final List<TreeNode> children;
        switch (childRes) {
          case Success<List<TreeNode>>(:final value):
            children = value;
          case Failure<List<TreeNode>>():
            children = <TreeNode>[];
        }

        _sortNodesRecursively(children);
        final newTreeData = List<TreeNode>.from(_state.treeData);
        _replaceNodeInList(newTreeData, node.id, children);
        _buildNodeKeys(children);

        final updatedLoading = Map<String, bool>.from(_state.loadingNodes)..remove(node.id);
        _state = _state.copyWith(treeData: newTreeData, loadingNodes: updatedLoading);
      } catch (e) {
        debugPrint('Error loading children: $e');
        final updatedLoading = Map<String, bool>.from(_state.loadingNodes)..remove(node.id);
        _state = _state.copyWith(loadingNodes: updatedLoading);
      }
    }

    if (_disposed) return;
    final newExpanded = Map<String, bool>.from(_state.expanded);
    newExpanded[node.id] = true;
    _state = _state.copyWith(expanded: newExpanded);
    notifyListeners();
  }

  /// Executes deterministic method `TreeViewModel::_findNodeById` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_findNodeById` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_findNodeById` (declaration #16) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodes: List<TreeNode>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_findNodeById`.
  /// - `id: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_findNodeById`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TreeNode?` from `TreeViewModel::_findNodeById` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodes)) bounded over input/member dimension of `TreeViewModel::_findNodeById`.
  /// - Space Complexity: O(N(nodes)) bounded auxiliary memory for `TreeViewModel::_findNodeById`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_findNodeById` (`TreeNode?`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_findNodeById` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_findNodeById` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_findNodeById` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-FINDNODEBYID] | SysML v2: ActionDef(TreeViewModel::_findNodeById)
  TreeNode? _findNodeById(List<TreeNode> nodes, String id) {
    for (final node in nodes) {
      if (node.id == id) return node;
      if (node.children != null) {
        final found = _findNodeById(node.children!, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Moves selection to the next visible node (depth-first order).
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::handleArrowDown` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::handleArrowDown` (declaration #17) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::handleArrowDown` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::handleArrowDown` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(handleArrowDown)) bounded over input/member dimension of `TreeViewModel::handleArrowDown`.
  /// - Space Complexity: O(K(handleArrowDown)) bounded auxiliary memory for `TreeViewModel::handleArrowDown`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::handleArrowDown` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::handleArrowDown` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::handleArrowDown` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::handleArrowDown` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-HANDLEARROWDOWN] | SysML v2: ActionDef(TreeViewModel::handleArrowDown)
  void handleArrowDown() {
    final visible = _getVisibleNodes();
    final currentIndex = visible.indexWhere((n) => n.id == _state.currentView);
    final nextIndex = currentIndex + 1;
    if (nextIndex < visible.length) {
      selectView(visible[nextIndex].id);
    }
  }

  /// Moves selection to the previous visible node (depth-first order).
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::handleArrowUp` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::handleArrowUp` (declaration #18) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::handleArrowUp` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::handleArrowUp` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(handleArrowUp)) bounded over input/member dimension of `TreeViewModel::handleArrowUp`.
  /// - Space Complexity: O(K(handleArrowUp)) bounded auxiliary memory for `TreeViewModel::handleArrowUp`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::handleArrowUp` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::handleArrowUp` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::handleArrowUp` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::handleArrowUp` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-HANDLEARROWUP] | SysML v2: ActionDef(TreeViewModel::handleArrowUp)
  void handleArrowUp() {
    final visible = _getVisibleNodes();
    final currentIndex = visible.indexWhere((n) => n.id == _state.currentView);
    final prevIndex = currentIndex - 1;
    if (prevIndex >= 0) {
      selectView(visible[prevIndex].id);
    }
  }

  /// Expands the current node or, if already expanded, selects its first child.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::handleArrowRight` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::handleArrowRight` (declaration #19) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::handleArrowRight` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::handleArrowRight` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(handleArrowRight)) bounded over input/member dimension of `TreeViewModel::handleArrowRight`.
  /// - Space Complexity: O(K(handleArrowRight)) bounded auxiliary memory for `TreeViewModel::handleArrowRight`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::handleArrowRight` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::handleArrowRight` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::handleArrowRight` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::handleArrowRight` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-HANDLEARROWRIGHT] | SysML v2: ActionDef(TreeViewModel::handleArrowRight)
  void handleArrowRight() {
    final visible = _getVisibleNodes();
    final currentIndex = visible.indexWhere((n) => n.id == _state.currentView);
    if (currentIndex == -1) return;
    final currentNode = visible[currentIndex];
    if (currentNode.children != null) {
      if (_state.expanded[currentNode.id] != true) {
        expandNode(currentNode);
      } else if (currentNode.children!.isNotEmpty) {
        final firstChild = currentNode.children![0];
        selectView(firstChild.id);
      }
    }
  }

  /// Collapses the current node or, if already collapsed or a leaf, selects
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::handleArrowLeft` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::handleArrowLeft` (declaration #20) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::handleArrowLeft` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::handleArrowLeft` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(handleArrowLeft)) bounded over input/member dimension of `TreeViewModel::handleArrowLeft`.
  /// - Space Complexity: O(K(handleArrowLeft)) bounded auxiliary memory for `TreeViewModel::handleArrowLeft`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::handleArrowLeft` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::handleArrowLeft` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::handleArrowLeft` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::handleArrowLeft` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-HANDLEARROWLEFT] | SysML v2: ActionDef(TreeViewModel::handleArrowLeft)
  void handleArrowLeft() {
    final visible = _getVisibleNodes();
    final currentIndex = visible.indexWhere((n) => n.id == _state.currentView);
    if (currentIndex == -1) return;
    final currentNode = visible[currentIndex];
    if (currentNode.children != null &&
        _state.expanded[currentNode.id] == true) {
      final newExpanded = Map<String, bool>.from(_state.expanded);
      newExpanded[currentNode.id] = false;
      _state = _state.copyWith(expanded: newExpanded);
      notifyListeners();
    } else {
      TreeNode? findParent(List<TreeNode> nodes, String targetId, TreeNode? parent) {
        for (final node in nodes) {
          if (node.id == targetId) return parent;
          if (node.children != null) {
            final found = findParent(node.children!, targetId, node);
            if (found != null) return found;
          }
        }
        return null;
      }

      final parent = findParent(_state.treeData, currentNode.id, null);
      if (parent != null) {
        selectView(parent.id);
      }
    }
  }

  /// Executes deterministic method `TreeViewModel::notifyListeners` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::notifyListeners` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::notifyListeners` (declaration #21) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::notifyListeners` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::notifyListeners` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(notifyListeners)) bounded over input/member dimension of `TreeViewModel::notifyListeners`.
  /// - Space Complexity: O(K(notifyListeners)) bounded auxiliary memory for `TreeViewModel::notifyListeners`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::notifyListeners` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::notifyListeners` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::notifyListeners` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::notifyListeners` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-NOTIFYLISTENERS] | SysML v2: ActionDef(TreeViewModel::notifyListeners)
  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  /// Executes deterministic method `TreeViewModel::dispose` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::dispose` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::dispose` (declaration #22) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::dispose` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `TreeViewModel::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `TreeViewModel::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::dispose` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::dispose` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-DISPOSE] | SysML v2: ActionDef(TreeViewModel::dispose)
  @override
  void dispose() {
    _disposed = true;
    _treeFocusNode.dispose();
    super.dispose();
  }

  /// Executes deterministic method `TreeViewModel::_buildNodeKeys` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_buildNodeKeys` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_buildNodeKeys` (declaration #23) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodes: List<TreeNode>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_buildNodeKeys`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::_buildNodeKeys` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodes)) bounded over input/member dimension of `TreeViewModel::_buildNodeKeys`.
  /// - Space Complexity: O(N(nodes)) bounded auxiliary memory for `TreeViewModel::_buildNodeKeys`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_buildNodeKeys` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_buildNodeKeys` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_buildNodeKeys` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_buildNodeKeys` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-BUILDNODEKEYS] | SysML v2: ActionDef(TreeViewModel::_buildNodeKeys)
  void _buildNodeKeys(List<TreeNode> nodes) {
    for (final node in nodes) {
      _nodeKeys[node.id] = GlobalKey();
      if (node.children != null) {
        _buildNodeKeys(node.children!);
      }
    }
  }

  /// Executes deterministic method `TreeViewModel::_expandParentsPath` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_expandParentsPath` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_expandParentsPath` (declaration #24) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodes: List<TreeNode>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_expandParentsPath`.
  /// - `targetId: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_expandParentsPath`.
  /// - `expandedMap: Map<String, bool>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_expandParentsPath`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::_expandParentsPath` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodes)) bounded over input/member dimension of `TreeViewModel::_expandParentsPath`.
  /// - Space Complexity: O(N(nodes)) bounded auxiliary memory for `TreeViewModel::_expandParentsPath`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_expandParentsPath` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_expandParentsPath` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_expandParentsPath` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_expandParentsPath` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-EXPANDPARENTSPATH] | SysML v2: ActionDef(TreeViewModel::_expandParentsPath)
  void _expandParentsPath(List<TreeNode> nodes, String targetId, Map<String, bool> expandedMap) {
    bool findAndExpand(List<TreeNode> currentNodes, String id, List<String> path) {
      for (final node in currentNodes) {
        if (node.id == id) {
          for (final ancestorId in path) {
            expandedMap[ancestorId] = true;
          }
          return true;
        }
        if (node.children != null) {
          if (findAndExpand(node.children!, id, [...path, node.id])) {
            return true;
          }
        }
      }
      return false;
    }
    findAndExpand(nodes, targetId, []);
  }

  /// Executes deterministic method `TreeViewModel::_getVisibleNodes` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_getVisibleNodes` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_getVisibleNodes` (declaration #25) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeViewModel::_getVisibleNodes` in `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<TreeNode>` from `TreeViewModel::_getVisibleNodes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_getVisibleNodes)) bounded over input/member dimension of `TreeViewModel::_getVisibleNodes`.
  /// - Space Complexity: O(K(_getVisibleNodes)) bounded auxiliary memory for `TreeViewModel::_getVisibleNodes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_getVisibleNodes` (`List<TreeNode>`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_getVisibleNodes` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_getVisibleNodes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_getVisibleNodes` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-GETVISIBLENODES] | SysML v2: ActionDef(TreeViewModel::_getVisibleNodes)
  List<TreeNode> _getVisibleNodes() {
    final List<TreeNode> result = [];
    void traverse(TreeNode node) {
      result.add(node);
      if (node.children != null && _state.expanded[node.id] == true) {
        node.children!.forEach(traverse);
      }
    }
    _state.treeData.forEach(traverse);
    return result;
  }

  /// Executes deterministic method `TreeViewModel::_scrollToNode` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_scrollToNode` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_scrollToNode` (declaration #26) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `viewId: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_scrollToNode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::_scrollToNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(viewId)) bounded over input/member dimension of `TreeViewModel::_scrollToNode`.
  /// - Space Complexity: O(N(viewId)) bounded auxiliary memory for `TreeViewModel::_scrollToNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_scrollToNode` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_scrollToNode` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_scrollToNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_scrollToNode` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-SCROLLTONODE] | SysML v2: ActionDef(TreeViewModel::_scrollToNode)
  void _scrollToNode(String viewId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _nodeKeys[viewId]?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Executes deterministic method `TreeViewModel::_sortNodesRecursively` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_sortNodesRecursively` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_sortNodesRecursively` (declaration #27) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodes: List<TreeNode>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_sortNodesRecursively`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TreeViewModel::_sortNodesRecursively` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodes)) bounded over input/member dimension of `TreeViewModel::_sortNodesRecursively`.
  /// - Space Complexity: O(N(nodes)) bounded auxiliary memory for `TreeViewModel::_sortNodesRecursively`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_sortNodesRecursively` (`void`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_sortNodesRecursively` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_sortNodesRecursively` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_sortNodesRecursively` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-SORTNODESRECURSIVELY] | SysML v2: ActionDef(TreeViewModel::_sortNodesRecursively)
  void _sortNodesRecursively(List<TreeNode> nodes) {
    nodes.sort((a, b) => _naturalCompare(a.id, b.id));
    for (final node in nodes) {
      if (node.children != null && node.children!.isNotEmpty) {
        _sortNodesRecursively(node.children!);
      }
    }
  }

  /// Executes deterministic method `TreeViewModel::_replaceNodeInList` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_replaceNodeInList` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_replaceNodeInList` (declaration #28) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodes: List<TreeNode>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_replaceNodeInList`.
  /// - `targetId: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_replaceNodeInList`.
  /// - `newChildren: List<TreeNode>` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_replaceNodeInList`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `TreeViewModel::_replaceNodeInList` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodes)) bounded over input/member dimension of `TreeViewModel::_replaceNodeInList`.
  /// - Space Complexity: O(N(nodes)) bounded auxiliary memory for `TreeViewModel::_replaceNodeInList`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_replaceNodeInList` (`bool`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_replaceNodeInList` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_replaceNodeInList` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_replaceNodeInList` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-REPLACENODEINLIST] | SysML v2: ActionDef(TreeViewModel::_replaceNodeInList)
  bool _replaceNodeInList(List<TreeNode> nodes, String targetId, List<TreeNode> newChildren) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == targetId) {
        nodes[i] = nodes[i].copyWith(children: newChildren);
        return true;
      }
      if (nodes[i].children != null) {
        if (_replaceNodeInList(nodes[i].children!, targetId, newChildren)) return true;
      }
    }
    return false;
  }

  /// Executes deterministic method `TreeViewModel::_naturalCompare` within `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeViewModel::_naturalCompare` in `app_flutter/lib/features/tree/view_models/tree_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeViewModel::_naturalCompare` (declaration #29) within `VIEW-MODELS-TREE-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `a: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_naturalCompare`.
  /// - `b: String` must satisfy domain and type-safety constraints prior to invoking `TreeViewModel::_naturalCompare`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `TreeViewModel::_naturalCompare` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(a)) bounded over input/member dimension of `TreeViewModel::_naturalCompare`.
  /// - Space Complexity: O(N(a)) bounded auxiliary memory for `TreeViewModel::_naturalCompare`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeViewModel::_naturalCompare` (`int`).
  /// - State: Maintains consistent state invariants across `TreeViewModel::_naturalCompare` without partial mutation on error.
  /// - Action: Executes `TreeViewModel::_naturalCompare` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeViewModel::_naturalCompare` (`VIEW-MODELS-TREE-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-TREE-VIEW-MODEL-TREEVIEWMODEL-NATURALCOMPARE] | SysML v2: ActionDef(TreeViewModel::_naturalCompare)
  int _naturalCompare(String a, String b) {
    final bool isChildOrGcA = a.contains('_Child_') || a.contains('_Grandchild_');
    final bool isChildOrGcB = b.contains('_Child_') || b.contains('_Grandchild_');
    
    if (isChildOrGcA != isChildOrGcB) {
      return isChildOrGcA ? 1 : -1;
    }

    final RegExp regExp = RegExp(r'(\d+)|(\D+)');
    final Iterable<Match> matchesA = regExp.allMatches(a);
    final Iterable<Match> matchesB = regExp.allMatches(b);
    
    final List<String> chunksA = matchesA.map((m) => m.group(0)!).toList();
    final List<String> chunksB = matchesB.map((m) => m.group(0)!).toList();
    
    final int minLen = chunksA.length < chunksB.length ? chunksA.length : chunksB.length;
    for (int i = 0; i < minLen; i++) {
      final String chunkA = chunksA[i];
      final String chunkB = chunksB[i];
      
      final bool isDigitA = RegExp(r'^\d+$').hasMatch(chunkA);
      final bool isDigitB = RegExp(r'^\d+$').hasMatch(chunkB);
      
      if (isDigitA && isDigitB) {
        final int valA = int.parse(chunkA);
        final int valB = int.parse(chunkB);
        final int cmp = valA.compareTo(valB);
        if (cmp != 0) return cmp;
      } else {
        final int cmp = chunkA.compareTo(chunkB);
        if (cmp != 0) return cmp;
      }
    }
    return chunksA.length.compareTo(chunksB.length);
  }
}
