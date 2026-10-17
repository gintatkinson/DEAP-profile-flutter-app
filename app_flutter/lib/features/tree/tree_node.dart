/// Immutable node in the sidebar hierarchy tree representing a selectable M2
/// metamodel view or entity type.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Models hierarchical navigation descriptors for the ARINC 661 sidebar tree
/// under DO-178C DAL-A, binding a unique view [id], human-readable [label],
/// and optional recursive [children].
///
/// ## 2. Invariants & State Contracts
/// - Leaf nodes carry `children == null`.
/// - Expandable parent nodes whose children have not yet been lazily fetched
///   carry an empty list (`children != null && children!.isEmpty`).
/// - Equality is identity-based as nodes are reconstructed on tree refresh.
///
/// ## 3. Preconditions & Input Bounds
/// - [id] and [label] must be non-null strings.
/// - [children] may be `null` or a list of child [TreeNode] instances.
///
/// ## 4. Postconditions & Side Effects
/// - Pure immutable value carrier; [copyWith] returns a new [TreeNode] with
///   selectively overridden fields without mutating the receiver.
///
/// ## 5. Algorithmic Complexity & Worst-Case Execution Time (WCET)
/// - **Time Complexity**: $O(1)$ for construction and [copyWith].
/// - **Space Complexity**: $O(1)$ per node shell (excluding descendant tree).
///
/// ## 6. Failure Modes & Defensive Mitigations
/// - Omitted parameters in [copyWith] preserve the existing field references.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeNode]
class TreeNode {
  /// Unique view or entity type identifier.
  final String id;

  /// Human-readable display label rendered in the tree row.
  final String label;

  /// Optional child nodes for nested sub-types (`null` for leaf nodes).
  final List<TreeNode>? children;

  /// Creates an immutable [TreeNode] descriptor.
  const TreeNode({
    required this.id,
    required this.label,
    this.children,
  });

  /// Returns a copy of this [TreeNode] with selectively overridden fields.
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
