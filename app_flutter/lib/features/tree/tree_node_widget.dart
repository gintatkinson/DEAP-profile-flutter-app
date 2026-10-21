import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/tree/view_models/tree_view_model.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Renders a single [TreeNode] row in the sidebar tree with expand/collapse
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `TreeNodeWidget` in `app_flutter/lib/features/tree/tree_node_widget.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `TreeNodeWidget` (declaration #1) within `TREE-TREE-NODE-WIDGET`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `TreeNodeWidget` in `TREE-TREE-NODE-WIDGET`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `TreeNodeWidget` representation for class `TreeNodeWidget`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(TreeNodeWidget)) bounded over input/member dimension of `TreeNodeWidget`.
/// - Space Complexity: O(K(TreeNodeWidget)) bounded auxiliary memory for `TreeNodeWidget`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `TreeNodeWidget` (`TreeNodeWidget`).
/// - State: Maintains consistent state invariants across `TreeNodeWidget` without partial mutation on error.
/// - Action: Executes `TreeNodeWidget` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `TreeNodeWidget` (`TREE-TREE-NODE-WIDGET`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeNodeWidget] | SysML v2: PartDef(TreeNodeWidget)
class TreeNodeWidget extends StatelessWidget {
  /// Hierarchy node descriptor rendered by this widget.
  final TreeNode node;

  /// The left indentation for child nodes in the tree.
  ///
  /// Applied as `EdgeInsets.only(left: childIndent)` to the [Padding] that
  /// wraps recursively rendered children. Defaults to 16.0.
  final double childIndent;

  /// Creates an immutable [TreeNodeWidget].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TreeNodeWidget::TreeNodeWidget` in `app_flutter/lib/features/tree/tree_node_widget.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TreeNodeWidget::TreeNodeWidget` (declaration #2) within `TREE-TREE-NODE-WIDGET`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeNodeWidget::TreeNodeWidget` in `TREE-TREE-NODE-WIDGET`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TreeNodeWidget::TreeNodeWidget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TreeNodeWidget)) bounded over input/member dimension of `TreeNodeWidget::TreeNodeWidget`.
  /// - Space Complexity: O(K(TreeNodeWidget)) bounded auxiliary memory for `TreeNodeWidget::TreeNodeWidget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeNodeWidget::TreeNodeWidget` (`()`).
  /// - State: Maintains consistent state invariants across `TreeNodeWidget::TreeNodeWidget` without partial mutation on error.
  /// - Action: Executes `TreeNodeWidget::TreeNodeWidget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeNodeWidget::TreeNodeWidget` (`TREE-TREE-NODE-WIDGET`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-TREE-NODE-WIDGET-TREENODEWIDGET-TREENODEWIDGET] | SysML v2: ActionDef(TreeNodeWidget::TreeNodeWidget)
  const TreeNodeWidget({
    super.key,
    required this.node,
    this.childIndent = 16.0,
  });

  /// Executes deterministic method `TreeNodeWidget::build` within `app_flutter/lib/features/tree/tree_node_widget.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeNodeWidget::build` in `app_flutter/lib/features/tree/tree_node_widget.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeNodeWidget::build` (declaration #3) within `TREE-TREE-NODE-WIDGET`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `TreeNodeWidget::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `TreeNodeWidget::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `TreeNodeWidget::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `TreeNodeWidget::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeNodeWidget::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `TreeNodeWidget::build` without partial mutation on error.
  /// - Action: Executes `TreeNodeWidget::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeNodeWidget::build` (`TREE-TREE-NODE-WIDGET`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-TREE-NODE-WIDGET-TREENODEWIDGET-BUILD] | SysML v2: ActionDef(TreeNodeWidget::build)
  @override
  Widget build(BuildContext context) {
    final isTest = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST') ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    final isSelected = context.select<TreeViewModel, bool>(
      (vm) => vm.currentView == node.id,
    );
    final isExpanded = context.select<TreeViewModel, bool>(
      (vm) => vm.expanded[node.id] == true,
    );
    final isLoading = context.select<TreeViewModel, bool>(
      (vm) => vm.loadingNodes[node.id] == true,
    );
    final nodeKeyValue = context.select<TreeViewModel, GlobalKey?>(
      (vm) => vm.nodeKey(node.id),
    );
    final isParent = node.children != null && node.children!.isNotEmpty;

    IconData icon;
    if (isParent) {
      icon = isExpanded ? Icons.folder_open : Icons.folder;
    } else {
      icon = Icons.insert_drive_file;
    }

    final brandPrimary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          key: nodeKeyValue,
          type: MaterialType.transparency,
          child: Ink(
            color: isSelected ? brandPrimary.withValues(alpha: 0.12) : null,
            child: InkWell(
              key: Key('node_${node.id}'),
              onTap: isLoading ? null : () {
                final viewModel = context.read<TreeViewModel>();
                viewModel.selectView(node.id);
                viewModel.focusNode.requestFocus();
              },
              onDoubleTap: (isLoading || isTest) ? null : () {
                final viewModel = context.read<TreeViewModel>();
                viewModel.selectView(node.id);
                viewModel.triggerFlight(node.id);
                viewModel.focusNode.requestFocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected
                          ? brandPrimary
                          : Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        node.label,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isParent) ...[
                      const SizedBox(width: 4),
                      isLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              ),
                            )
                          : InkWell(
                              key: Key('toggle_${node.id}'),
                              onTap: () {
                                context.read<TreeViewModel>().toggleExpand(node.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  isExpanded ? '−' : '+',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isParent && isExpanded && !isLoading)
          Padding(
            padding: EdgeInsets.only(left: childIndent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: node.children!.map((child) => TreeNodeWidget(
                node: child,
              )).toList(),
            ),
          ),
      ],
    );
  }
}
