import 'package:app_flutter/features/tree/tree_node.dart';

/// Deterministic fallback hierarchy nodes used when the repository returns an
/// empty root node list.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Supplies a deterministic baseline M2 metamodel root node sequence under
/// DO-178C DAL-A and ARINC 661 so the navigation tree remains operable even
/// when external data sources return no root hierarchy.
///
/// ## 2. Invariants & State Contracts
/// - Always returns a non-empty list of 3 constant [TreeNode] descriptors
///   (`Master_1`, `Master_2`, `Master_3`).
/// - Elements are compile-time `const` instances with `null` children.
///
/// ## 3. Preconditions & Input Bounds
/// - None; pure top-level getter with no input parameters.
///
/// ## 4. Postconditions & Side Effects
/// - Returns a freshly allocated `List<TreeNode>` containing the 3 fallback
///   root nodes without mutating global state.
///
/// ## 5. Algorithmic Complexity & Worst-Case Execution Time (WCET)
/// - **Time Complexity**: $O(1)$ constant-time list literal allocation.
/// - **Space Complexity**: $O(1)$ fixed 3-element list wrapper around `const`
///   [TreeNode] instances.
///
/// ## 6. Failure Modes & Defensive Mitigations
/// - Cannot fail or throw; callers may safely mutate or filter the returned
///   list instance without affecting subsequent invocations.
///
/// ## 7. Realization & Traceability
/// Realises: [ARCH-TREE-001, REQ-TREE-001]
/// Realises: [Feat-10/TreeDefaults]
List<TreeNode> get defaultTreeData => [
  const TreeNode(id: 'Master_1', label: 'Master 1'),
  const TreeNode(id: 'Master_2', label: 'Master 2'),
  const TreeNode(id: 'Master_3', label: 'Master 3'),
];
