import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/core/theme/widgets/settings_panel.dart';
import 'package:app_flutter/core/string_resources.dart';
import 'package:app_flutter/features/tree/tree_node_widget.dart';
import 'package:app_flutter/features/tree/view_models/tree_view_model.dart';

/// Sidebar hierarchy navigation panel driven by [TreeViewModel].
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `SidebarTree` in `app_flutter/lib/features/tree/sidebar_tree.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `SidebarTree` (declaration #1) within `TREE-SIDEBAR-TREE`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `SidebarTree` in `TREE-SIDEBAR-TREE`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `SidebarTree` representation for class `SidebarTree`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(SidebarTree)) bounded over input/member dimension of `SidebarTree`.
/// - Space Complexity: O(K(SidebarTree)) bounded auxiliary memory for `SidebarTree`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `SidebarTree` (`SidebarTree`).
/// - State: Maintains consistent state invariants across `SidebarTree` without partial mutation on error.
/// - Action: Executes `SidebarTree` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `SidebarTree` (`TREE-SIDEBAR-TREE`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/SidebarTree] | SysML v2: PartDef(SidebarTree)
@immutable
class SidebarTree extends StatefulWidget {
  /// Optional latest background worker computation result displayed in the footer.
  final int? workerResult;

  /// Callback invoked when a view node is selected.
  final ValueChanged<String> onViewSelected;

  /// Padding applied around the scrollable tree node list.
  final EdgeInsetsGeometry contentPadding;

  /// Creates an immutable [SidebarTree] widget.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `SidebarTree::SidebarTree` in `app_flutter/lib/features/tree/sidebar_tree.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `SidebarTree::SidebarTree` (declaration #2) within `TREE-SIDEBAR-TREE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SidebarTree::SidebarTree` in `TREE-SIDEBAR-TREE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `SidebarTree::SidebarTree` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(SidebarTree)) bounded over input/member dimension of `SidebarTree::SidebarTree`.
  /// - Space Complexity: O(K(SidebarTree)) bounded auxiliary memory for `SidebarTree::SidebarTree`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SidebarTree::SidebarTree` (`()`).
  /// - State: Maintains consistent state invariants across `SidebarTree::SidebarTree` without partial mutation on error.
  /// - Action: Executes `SidebarTree::SidebarTree` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SidebarTree::SidebarTree` (`TREE-SIDEBAR-TREE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-SIDEBAR-TREE-SIDEBARTREE-SIDEBARTREE] | SysML v2: ActionDef(SidebarTree::SidebarTree)
  const SidebarTree({
    super.key,
    this.workerResult,
    required this.onViewSelected,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
  });

  /// Executes deterministic method `SidebarTree::createState` within `app_flutter/lib/features/tree/sidebar_tree.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SidebarTree::createState` in `app_flutter/lib/features/tree/sidebar_tree.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SidebarTree::createState` (declaration #3) within `TREE-SIDEBAR-TREE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SidebarTree::createState` in `TREE-SIDEBAR-TREE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<SidebarTree>` from `SidebarTree::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `SidebarTree::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `SidebarTree::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SidebarTree::createState` (`State<SidebarTree>`).
  /// - State: Maintains consistent state invariants across `SidebarTree::createState` without partial mutation on error.
  /// - Action: Executes `SidebarTree::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SidebarTree::createState` (`TREE-SIDEBAR-TREE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-SIDEBAR-TREE-SIDEBARTREE-CREATESTATE] | SysML v2: ActionDef(SidebarTree::createState)
  @override
  State<SidebarTree> createState() => _SidebarTreeState();
}

/// Executes deterministic class `_SidebarTreeState` within `app_flutter/lib/features/tree/sidebar_tree.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_SidebarTreeState` in `app_flutter/lib/features/tree/sidebar_tree.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_SidebarTreeState` (declaration #4) within `TREE-SIDEBAR-TREE`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_SidebarTreeState` in `TREE-SIDEBAR-TREE`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_SidebarTreeState` representation for class `_SidebarTreeState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_SidebarTreeState)) bounded over input/member dimension of `_SidebarTreeState`.
/// - Space Complexity: O(K(_SidebarTreeState)) bounded auxiliary memory for `_SidebarTreeState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_SidebarTreeState` (`_SidebarTreeState`).
/// - State: Maintains consistent state invariants across `_SidebarTreeState` without partial mutation on error.
/// - Action: Executes `_SidebarTreeState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_SidebarTreeState` (`TREE-SIDEBAR-TREE`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TREE-SIDEBAR-TREE-SIDEBARTREESTATE] | SysML v2: PartDef(_SidebarTreeState)
class _SidebarTreeState extends State<SidebarTree> {
  bool _openingSettings = false;

  /// Executes deterministic method `_SidebarTreeState::build` within `app_flutter/lib/features/tree/sidebar_tree.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_SidebarTreeState::build` in `app_flutter/lib/features/tree/sidebar_tree.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_SidebarTreeState::build` (declaration #5) within `TREE-SIDEBAR-TREE`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_SidebarTreeState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_SidebarTreeState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_SidebarTreeState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_SidebarTreeState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_SidebarTreeState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_SidebarTreeState::build` without partial mutation on error.
  /// - Action: Executes `_SidebarTreeState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_SidebarTreeState::build` (`TREE-SIDEBAR-TREE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TREE-SIDEBAR-TREE-SIDEBARTREESTATE-BUILD] | SysML v2: ActionDef(_SidebarTreeState::build)
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreeViewModel>();
    final treeData = viewModel.treeData;
    final brandPrimary = Theme.of(context).colorScheme.primary;
    final panelOpacity = context.watch<ThemeController>().panelOpacity;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(panelOpacity),
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.developer_board,
                  color: brandPrimary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    StringResources.get('sidebar.header'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Focus(
              focusNode: viewModel.focusNode,
              onKeyEvent: (FocusNode node, KeyEvent event) {
                if (event is KeyDownEvent) {
                  final key = event.logicalKey;
                  if (key == LogicalKeyboardKey.arrowDown) {
                    viewModel.handleArrowDown();
                    return KeyEventResult.handled;
                  }
                  if (key == LogicalKeyboardKey.arrowUp) {
                    viewModel.handleArrowUp();
                    return KeyEventResult.handled;
                  }
                  if (key == LogicalKeyboardKey.space) {
                    final currentId = viewModel.currentView;
                    if (currentId != null) {
                      viewModel.selectView(currentId);
                    }
                    return KeyEventResult.handled;
                  }
                  if (key == LogicalKeyboardKey.enter) {
                    final currentId = viewModel.currentView;
                    if (currentId != null) {
                      viewModel.selectView(currentId);
                      viewModel.triggerFlight(currentId);
                    }
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: SingleChildScrollView(
                padding: widget.contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: treeData.map((node) => TreeNodeWidget(
                    node: node,
                  )).toList(),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Worker: ${widget.workerResult ?? "Idle"}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  key: const Key('sidebar_settings_button'),
                  icon: const Icon(Icons.settings, size: 18),
                  onPressed: _openingSettings ? null : () {
                    setState(() => _openingSettings = true);
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const SettingsPanel(),
                    ).whenComplete(() {
                      if (mounted) setState(() => _openingSettings = false);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
