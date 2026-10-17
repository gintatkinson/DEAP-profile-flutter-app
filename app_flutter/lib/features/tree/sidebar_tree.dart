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
/// Provides the primary ARINC 661 hierarchical navigation surface for the M2
/// metamodel entity inventory under DO-178C DAL-A, supporting keyboard arrow
/// traversal, space selection, enter camera flight, and settings modal access.
///
/// ## 2. Invariants & State Contracts
/// - Subscribes to [TreeViewModel] and [ThemeController] via `context.watch`.
/// - Guard flag `_openingSettings` prevents duplicate concurrent modal sheets.
///
/// ## 3. Preconditions & Input Bounds
/// - Requires a valid [TreeViewModel] and [ThemeController] in the ancestor
///   [Provider] scope.
/// - [onViewSelected] must be non-null; [workerResult] may be `null` when idle.
///
/// ## 4. Postconditions & Side Effects
/// - Renders the sidebar header, scrollable [TreeNodeWidget] list, and footer
///   status bar with settings trigger.
///
/// ## 5. Algorithmic Complexity & Worst-Case Execution Time (WCET)
/// - **Time Complexity**: $O(R)$ top-level row allocations where $R$ is the root
///   node count in [TreeViewModel.treeData].
/// - **Space Complexity**: $O(R)$ widget references.
///
/// ## 6. Failure Modes & Defensive Mitigations
/// - Null `currentView` during Space/Enter key events is guarded prior to
///   invoking `selectView` or `triggerFlight`.
/// - Unmounted widget state on modal completion is guarded via `if (mounted)`.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/SidebarTree]
@immutable
class SidebarTree extends StatefulWidget {
  /// Optional latest background worker computation result displayed in the footer.
  final int? workerResult;

  /// Callback invoked when a view node is selected.
  final ValueChanged<String> onViewSelected;

  /// Padding applied around the scrollable tree node list.
  final EdgeInsetsGeometry contentPadding;

  /// Creates an immutable [SidebarTree] widget.
  const SidebarTree({
    super.key,
    this.workerResult,
    required this.onViewSelected,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
  });

  @override
  State<SidebarTree> createState() => _SidebarTreeState();
}

class _SidebarTreeState extends State<SidebarTree> {
  bool _openingSettings = false;

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
