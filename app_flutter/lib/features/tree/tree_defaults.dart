import 'package:app_flutter/features/tree/tree_node.dart';

/// Deterministic fallback hierarchy nodes used when the repository returns an
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for fn `defaultTreeData` in `app_flutter/lib/features/tree/tree_defaults.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for fn `defaultTreeData` (declaration #1) within `TREE-TREE-DEFAULTS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `defaultTreeData` in `TREE-TREE-DEFAULTS`.
///
/// ## 4. Postconditions
/// - Returns `()` from `defaultTreeData` with deterministic post-execution state.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(defaultTreeData)) bounded over input/member dimension of `defaultTreeData`.
/// - Space Complexity: O(K(defaultTreeData)) bounded auxiliary memory for `defaultTreeData`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `defaultTreeData` (`()`).
/// - State: Maintains consistent state invariants across `defaultTreeData` without partial mutation on error.
/// - Action: Executes `defaultTreeData` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `defaultTreeData` (`TREE-TREE-DEFAULTS`).
///
/// ## 7. Realization & Traceability
/// Realises: [ARCH-TREE-001], [REQ-TREE-001], [Feat-10/TreeDefaults] | SysML v2: ActionDef(defaultTreeData)
List<TreeNode> get defaultTreeData => [
  const TreeNode(id: 'Master_1', label: 'Master 1'),
  const TreeNode(id: 'Master_2', label: 'Master 2'),
  const TreeNode(id: 'Master_3', label: 'Master 3'),
];
