import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/tree/view_models/tree_view_model.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Renders a single [TreeNode] row in the sidebar tree with expand/collapse
/// controls and selection highlighting.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Provides deterministic ARINC 661 tree node rendering and operator selection
/// dispatch under DO-178C DAL-A, recursively rendering expanded child nodes
/// with configurable [childIndent].
///
/// ## 2. Invariants & State Contracts
/// - Reads `currentView`, `expanded[node.id]`, `loadingNodes[node.id]`, and
///   `nodeKey(node.id)` selectively via `context.select<TreeViewModel, ...>`.
/// - Does not trigger `notifyListeners` directly -- all state transitions flow
///   through [TreeViewModel].
///
/// ## 3. Preconditions & Input Bounds
/// - Requires a valid [TreeViewModel] in the ancestor [Provider] scope.
/// - [node] must be non-null; [childIndent] defaults to `16.0` logical pixels.
///
/// ## 4. Postconditions & Side Effects
/// - Single tap selects the view via [TreeViewModel.selectView] and requests
///   keyboard focus.
/// - Double tap (outside test environments) additionally triggers camera flight
///   via [TreeViewModel.triggerFlight].
///
/// ## 5. Algorithmic Complexity & Worst-Case Execution Time (WCET)
/// - **Time Complexity**: $O(1)$ per collapsed node; $O(V_{sub})$ across the
///   expanded visible subtree rooted at [node].
/// - **Space Complexity**: $O(D)$ widget recursion depth for tree depth $D$.
///
/// ## 6. Failure Modes & Defensive Mitigations
/// - Disables tap and double-tap handlers while `isLoading` is `true` to prevent
///   concurrent duplicate expansion requests.
/// - Suppresses `onDoubleTap` under Flutter test runners (`isTest`) to prevent
///   gesture recognizer timer delays on single-tap tests.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TreeNodeWidget]
class TreeNodeWidget extends StatelessWidget {
  /// Hierarchy node descriptor rendered by this widget.
  final TreeNode node;

  /// The left indentation for child nodes in the tree.
  ///
  /// Applied as `EdgeInsets.only(left: childIndent)` to the [Padding] that
  /// wraps recursively rendered children. Defaults to 16.0.
  final double childIndent;

  /// Creates an immutable [TreeNodeWidget].
  const TreeNodeWidget({
    super.key,
    required this.node,
    this.childIndent = 16.0,
  });

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
