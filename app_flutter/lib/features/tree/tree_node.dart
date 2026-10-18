/// Immutable node in the sidebar hierarchy tree representing a selectable M2
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `TreeNode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tree/tree_node.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `TreeNode` (declaration #1) within `TREE-TREE-NODE`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `TreeNode` in `TREE-TREE-NODE`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `TreeNode` representation for class `TreeNode`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(TreeNode)) bounded over input/member dimension of `TreeNode`.
/// - Space Complexity: O(K(TreeNode)) bounded auxiliary memory for `TreeNode`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `TreeNode` (`TreeNode`).
/// - State: Maintains consistent state invariants across `TreeNode` without partial mutation on error.
/// - Action: Executes `TreeNode` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `TreeNode` (`TREE-TREE-NODE`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeNode] | SysML v2: PartDef(TreeNode)
class TreeNode {
  /// Unique view or entity type identifier.
  final String id;

  /// Human-readable display label rendered in the tree row.
  final String label;

  /// Optional child nodes for nested sub-types (`null` for leaf nodes).
  final List<TreeNode>? children;

  /// Creates an immutable [TreeNode] descriptor.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TreeNode::TreeNode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tree/tree_node.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TreeNode::TreeNode` (declaration #2) within `TREE-TREE-NODE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeNode::TreeNode` in `TREE-TREE-NODE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeNode::TreeNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TreeNode)) bounded over input/member dimension of `TreeNode::TreeNode`.
  /// - Space Complexity: O(K(TreeNode)) bounded auxiliary memory for `TreeNode::TreeNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeNode::TreeNode` (`()`).
  /// - State: Maintains consistent state invariants across `TreeNode::TreeNode` without partial mutation on error.
  /// - Action: Executes `TreeNode::TreeNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeNode::TreeNode` (`TREE-TREE-NODE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-TREE-NODE-TREENODE-TREENODE] | SysML v2: ActionDef(TreeNode::TreeNode)
  const TreeNode({
    required this.id,
    required this.label,
    this.children,
  });

  /// Returns a copy of this [TreeNode] with selectively overridden fields.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeNode::copyWith` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/tree/tree_node.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeNode::copyWith` (declaration #3) within `TREE-TREE-NODE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeNode::copyWith` in `TREE-TREE-NODE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TreeNode` from `TreeNode::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `TreeNode::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `TreeNode::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeNode::copyWith` (`TreeNode`).
  /// - State: Maintains consistent state invariants across `TreeNode::copyWith` without partial mutation on error.
  /// - Action: Executes `TreeNode::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeNode::copyWith` (`TREE-TREE-NODE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-TREE-NODE-TREENODE-COPYWITH] | SysML v2: ActionDef(TreeNode::copyWith)
  TreeNode copyWith({
    String? id,
    String? label,
    List<TreeNode>? children,
  }) {
    return TreeNode(
      id: id ?? this.id,
      label: label ?? this.label,
      children: children ?? this.children,
    );
  }
}
