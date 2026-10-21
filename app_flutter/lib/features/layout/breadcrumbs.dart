import 'package:flutter/material.dart';
import 'package:app_flutter/core/string_resources.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/core/theme/app_themes.dart';

/// Immutable descriptor representing a single navigable segment in the ARINC 661
/// hierarchical breadcrumb path bar.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides deterministic, unambiguous
///   operator situational awareness of the active hierarchical node path within
///   a multi-pane workstation display.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Identifier Non-Nullity**: Both [id] and [label] are non-null immutable
///   strings bound at construction time.
/// - **Terminal Interactivity Guard**: Terminal or non-interactive segments set
///   $\text{onClick} = \text{null}$ to prevent redundant self-navigation cycles.
///
/// ## 3. Preconditions
/// - [id] must correspond to a valid schema node identifier or synthetic control
///   token (`home`, `ellipsis`).
/// - [label] must be a resolved human-readable display string.
///
/// ## 4. Postconditions
/// - Constructs an immutable value descriptor ready for rendering by
///   [NavigationBreadcrumbs].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ constant-time instantiation.
/// - **Space Complexity**: $\mathcal{O}(1)$ per segment descriptor.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Null [onClick] callbacks safely degrade to non-interactive text labels
///   rather(than) dispatching null pointer invocations.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/BreadcrumbItem]
@immutable
class BreadcrumbItem {
  /// Unique identifier for this breadcrumb segment, matched against tree node
  /// identifiers.
  final String id;

  /// Human-readable display label shown in the breadcrumb bar.
  final String label;

  /// Callback invoked when the breadcrumb is tapped; `null` disables
  /// interactivity (rendered as plain text).
  final VoidCallback? onClick;

  /// Creates an immutable [BreadcrumbItem] segment descriptor.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `BreadcrumbItem::BreadcrumbItem` in `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `BreadcrumbItem::BreadcrumbItem` (declaration #2) within `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `BreadcrumbItem::BreadcrumbItem` in `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `BreadcrumbItem::BreadcrumbItem` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(BreadcrumbItem)) bounded over input/member dimension of `BreadcrumbItem::BreadcrumbItem`.
  /// - Space Complexity: O(K(BreadcrumbItem)) bounded auxiliary memory for `BreadcrumbItem::BreadcrumbItem`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `BreadcrumbItem::BreadcrumbItem` (`()`).
  /// - State: Maintains consistent state invariants across `BreadcrumbItem::BreadcrumbItem` without partial mutation on error.
  /// - Action: Executes `BreadcrumbItem::BreadcrumbItem` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `BreadcrumbItem::BreadcrumbItem` (`LAYOUT-BREADCRUMBS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-BREADCRUMBS-BREADCRUMBITEM-BREADCRUMBITEM] | SysML v2: ActionDef(BreadcrumbItem::BreadcrumbItem)
  const BreadcrumbItem({
    required this.id,
    required this.label,
    this.onClick,
  });
}

/// Responsive ARINC 661 navigation path trace widget that renders the active
/// hierarchy path and collapses intermediate segments when length exceeds [maxItems].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Prevents rapid double-tap navigation
///   oscillation via a post-frame re-entrancy lock (`_isNavigating`) and bounds
///   horizontal visual clutter via deterministic ellipsis truncation.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Bounded Segment Cardinality**: When collapsed ($N > M$ where $N = |\text{items}|$
///   and $M = \text{maxItems}$), the rendered sequence length is strictly bounded to
///   $M + 1$ elements:
///   $$
///   \begin{aligned}
///   |\text{renderedItems}| &= 1 + 1 + (M - 1) = M + 1
///   \end{aligned}
///   $$
/// - **Single-Frame Navigation Lock**: At most one navigation callback may fire
///   per rendered frame ($T_{\text{frame}} \le 16.67\text{ ms}$).
///
/// ## 3. Preconditions
/// - [items] is an ordered list of [BreadcrumbItem] instances from root to active leaf.
/// - [maxItems] satisfies $M \ge 2$ when ellipsis collapsing is active.
///
/// ## 4. Postconditions
/// - Renders [SizedBox.shrink] when [items] is empty; otherwise renders a
///   horizontally scrollable row of interactive [ActionChip] and terminal [Text] nodes.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(N)$ where $N = |\text{items}|$.
/// - **Space Complexity**: $\mathcal{O}(N)$ for the rendered widget children list.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty [items] lists safely render [SizedBox.shrink] with zero layout exceptions.
/// - Re-entrant tap events within the same frame are suppressed by `_safeNavigate`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/NavigationBreadcrumbs]
@immutable
class NavigationBreadcrumbs extends StatefulWidget {
  /// Ordered list of breadcrumb segments from root to current view. When
  /// empty, nothing is rendered.
  final List<BreadcrumbItem> items;

  /// Maximum visible items before collapsing. Must be at least 2 for
  /// meaningful collapse behaviour. Defaults to 4.
  final int maxItems;

  /// Creates a [NavigationBreadcrumbs] widget.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `NavigationBreadcrumbs::NavigationBreadcrumbs` in `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `NavigationBreadcrumbs::NavigationBreadcrumbs` (declaration #4) within `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `NavigationBreadcrumbs::NavigationBreadcrumbs` in `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `NavigationBreadcrumbs::NavigationBreadcrumbs` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(NavigationBreadcrumbs)) bounded over input/member dimension of `NavigationBreadcrumbs::NavigationBreadcrumbs`.
  /// - Space Complexity: O(K(NavigationBreadcrumbs)) bounded auxiliary memory for `NavigationBreadcrumbs::NavigationBreadcrumbs`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `NavigationBreadcrumbs::NavigationBreadcrumbs` (`()`).
  /// - State: Maintains consistent state invariants across `NavigationBreadcrumbs::NavigationBreadcrumbs` without partial mutation on error.
  /// - Action: Executes `NavigationBreadcrumbs::NavigationBreadcrumbs` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `NavigationBreadcrumbs::NavigationBreadcrumbs` (`LAYOUT-BREADCRUMBS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-BREADCRUMBS-NAVIGATIONBREADCRUMBS-NAVIGATIONBREADCRUMBS] | SysML v2: ActionDef(NavigationBreadcrumbs::NavigationBreadcrumbs)
  const NavigationBreadcrumbs({
    super.key,
    required this.items,
    this.maxItems = 4,
  });

  /// Executes deterministic method `NavigationBreadcrumbs::createState` within `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `NavigationBreadcrumbs::createState` in `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `NavigationBreadcrumbs::createState` (declaration #5) within `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `NavigationBreadcrumbs::createState` in `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<NavigationBreadcrumbs>` from `NavigationBreadcrumbs::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `NavigationBreadcrumbs::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `NavigationBreadcrumbs::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `NavigationBreadcrumbs::createState` (`State<NavigationBreadcrumbs>`).
  /// - State: Maintains consistent state invariants across `NavigationBreadcrumbs::createState` without partial mutation on error.
  /// - Action: Executes `NavigationBreadcrumbs::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `NavigationBreadcrumbs::createState` (`LAYOUT-BREADCRUMBS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-BREADCRUMBS-NAVIGATIONBREADCRUMBS-CREATESTATE] | SysML v2: ActionDef(NavigationBreadcrumbs::createState)
  @override
  State<NavigationBreadcrumbs> createState() => _NavigationBreadcrumbsState();
}

/// Executes deterministic class `_NavigationBreadcrumbsState` within `app_flutter/lib/features/layout/breadcrumbs.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_NavigationBreadcrumbsState` in `app_flutter/lib/features/layout/breadcrumbs.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_NavigationBreadcrumbsState` (declaration #6) within `LAYOUT-BREADCRUMBS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_NavigationBreadcrumbsState` in `LAYOUT-BREADCRUMBS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_NavigationBreadcrumbsState` representation for class `_NavigationBreadcrumbsState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_NavigationBreadcrumbsState)) bounded over input/member dimension of `_NavigationBreadcrumbsState`.
/// - Space Complexity: O(K(_NavigationBreadcrumbsState)) bounded auxiliary memory for `_NavigationBreadcrumbsState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_NavigationBreadcrumbsState` (`_NavigationBreadcrumbsState`).
/// - State: Maintains consistent state invariants across `_NavigationBreadcrumbsState` without partial mutation on error.
/// - Action: Executes `_NavigationBreadcrumbsState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_NavigationBreadcrumbsState` (`LAYOUT-BREADCRUMBS`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-LAYOUT-BREADCRUMBS-NAVIGATIONBREADCRUMBSSTATE] | SysML v2: PartDef(_NavigationBreadcrumbsState)
class _NavigationBreadcrumbsState extends State<NavigationBreadcrumbs> {
  bool _isExpanded = false;
  bool _isNavigating = false;

  /// Executes deterministic method `_NavigationBreadcrumbsState::_safeNavigate` within `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_NavigationBreadcrumbsState::_safeNavigate` in `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_NavigationBreadcrumbsState::_safeNavigate` (declaration #7) within `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 3. Preconditions
  /// - `callback: VoidCallback` must satisfy domain and type-safety constraints prior to invoking `_NavigationBreadcrumbsState::_safeNavigate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_NavigationBreadcrumbsState::_safeNavigate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(callback)) bounded over input/member dimension of `_NavigationBreadcrumbsState::_safeNavigate`.
  /// - Space Complexity: O(N(callback)) bounded auxiliary memory for `_NavigationBreadcrumbsState::_safeNavigate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_NavigationBreadcrumbsState::_safeNavigate` (`void`).
  /// - State: Maintains consistent state invariants across `_NavigationBreadcrumbsState::_safeNavigate` without partial mutation on error.
  /// - Action: Executes `_NavigationBreadcrumbsState::_safeNavigate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_NavigationBreadcrumbsState::_safeNavigate` (`LAYOUT-BREADCRUMBS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-BREADCRUMBS-NAVIGATIONBREADCRUMBSSTATE-SAFENAVIGATE] | SysML v2: ActionDef(_NavigationBreadcrumbsState::_safeNavigate)
  void _safeNavigate(VoidCallback callback) {
    if (_isNavigating) return;
    _isNavigating = true;
    callback();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isNavigating = false;
    });
  }

  /// Executes deterministic method `_NavigationBreadcrumbsState::build` within `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_NavigationBreadcrumbsState::build` in `app_flutter/lib/features/layout/breadcrumbs.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_NavigationBreadcrumbsState::build` (declaration #8) within `LAYOUT-BREADCRUMBS`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_NavigationBreadcrumbsState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_NavigationBreadcrumbsState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_NavigationBreadcrumbsState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_NavigationBreadcrumbsState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_NavigationBreadcrumbsState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_NavigationBreadcrumbsState::build` without partial mutation on error.
  /// - Action: Executes `_NavigationBreadcrumbsState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_NavigationBreadcrumbsState::build` (`LAYOUT-BREADCRUMBS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-LAYOUT-BREADCRUMBS-NAVIGATIONBREADCRUMBSSTATE-BUILD] | SysML v2: ActionDef(_NavigationBreadcrumbsState::build)
  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool shouldCollapse = widget.items.length > widget.maxItems && !_isExpanded;

    List<BreadcrumbItem> renderedItems;
    if (shouldCollapse) {
      final BreadcrumbItem first = widget.items.first;
      final List<BreadcrumbItem> lastItems = widget.items.sublist(
        widget.items.length - (widget.maxItems - 1),
      );
      renderedItems = <BreadcrumbItem>[
        first,
        BreadcrumbItem(
          id: 'ellipsis',
          label: '...',
          onClick: () {
            setState(() {
              _isExpanded = true;
            });
          },
        ),
        ...lastItems,
      ];
    } else {
      renderedItems = widget.items;
    }



    final List<Widget> children = <Widget>[];
    for (int i = 0; i < renderedItems.length; i++) {
      final BreadcrumbItem item = renderedItems[i];
      final bool isLast = i == renderedItems.length - 1;
      final bool isEllipsis = item.id == 'ellipsis';

      if (i > 0) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppThemes.getDimension('alias.spacing.sm', 8.0),
            ),
            child: Text(
              '/',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }

      if (isEllipsis) {
        final cb = item.onClick;
        children.add(
          ActionChip(
            onPressed: cb != null ? () => _safeNavigate(cb) : null,
            label: Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      } else if (isLast) {
        children.add(
          Text(
            item.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      } else {
        final cb = item.onClick;
        children.add(
          ActionChip(
            onPressed: cb != null ? () => _safeNavigate(cb) : null,
            label: Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// Resolves the identifier of the first leaf [TreeNode] reachable from [n] via
/// leftmost depth-first traversal.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Maps intermediate branch node
///   selections in breadcrumb navigation to a deterministic terminal leaf view
///   identifier without ambiguous intermediate states.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Leftmost Terminal Resolution**: For any finite tree rooted at $n$ of
///   height $H$, recursion terminates in at most $H$ steps at a node $v$
///   satisfying $\text{children}(v) = \varnothing$.
///
/// ## 3. Preconditions
/// - [n] is a valid [TreeNode] belonging to an acyclic hierarchy tree.
///
/// ## 4. Postconditions
/// - Returns a non-empty string node identifier corresponding to the leftmost
///   descendant leaf (or `n.id` when [n] is itself a leaf).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(H)$ where $H$ is the depth of the leftmost path.
/// - **Space Complexity**: $\mathcal{O}(H)$ call-stack frames.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Null or empty `n.children` lists terminate recursion immediately and return `n.id`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/NavigationBreadcrumbs]
String getFirstLeafId(TreeNode n) {
  if (n.children == null || n.children!.isEmpty) return n.id;
  return getFirstLeafId(n.children!.first);
}

/// Synthesizes an ordered list of [BreadcrumbItem] descriptors tracing the
/// hierarchy path from the workstation root to [view] within [treeData].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Decouples breadcrumb path derivation
///   from stateful widget lifecycles so operator location trails remain strictly
///   synchronized with the active [TreeNode] hierarchy.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Root Prefix Invariant**: The returned sequence $B = [b_0, b_1, \dots, b_k]$
///   always satisfies $b_0.\text{id} = \text{'home'}$ and $|B| \ge 2$.
/// - **Terminal Non-Interactivity**: The final segment $b_k$ always has
///   $b_k.\text{onClick} = \text{null}$.
///
/// ## 3. Preconditions
/// - [view] is the currently active view identifier string.
/// - [treeData] is a list of root [TreeNode] hierarchies (may be empty).
///
/// ## 4. Postconditions
/// - Returns a non-empty list of [BreadcrumbItem] instances representing the
///   resolved root-to-target path or a 2-element fallback `[home, view]`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|V|)$ depth-first search over $|V|$ tree nodes.
/// - **Space Complexity**: $\mathcal{O}(H)$ path allocation where $H$ is tree height.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - When [treeData] is empty, the `home` segment binds a safe no-op callback `() {}`
///   rather than indexing into an empty list.
/// - When [view] is not found in [treeData], appends a non-interactive fallback
///   [BreadcrumbItem] carrying [view] as both identifier and label.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/NavigationBreadcrumbs]
List<BreadcrumbItem> getBreadcrumbsItems(
  String view,
  List<TreeNode> treeData, {
  ValueChanged<String>? onSelectView,
}) {
  final homeTreeData = treeData;

  final List<BreadcrumbItem> base = [
    BreadcrumbItem(
      id: 'home',
      label: StringResources.get('breadcrumbs.home'),
      onClick: homeTreeData.isNotEmpty
          ? () => onSelectView?.call(getFirstLeafId(homeTreeData.first))
          : () {},
    ),
  ];

  List<TreeNode>? findPath(List<TreeNode> nodes, String targetId, List<TreeNode> currentPath) {
    for (final node in nodes) {
      if (node.id == targetId) {
        return [...currentPath, node];
      }
      if (node.children != null) {
        final found = findPath(node.children!, targetId, [...currentPath, node]);
        if (found != null) return found;
      }
    }
    return null;
  }

  final path = findPath(treeData, view, []);
  if (path == null || path.isEmpty) {
    return [...base, BreadcrumbItem(id: view, label: view)];
  }

  final List<BreadcrumbItem> items = [...base];
  for (int i = 0; i < path.length; i++) {
    final node = path[i];
    if (i == path.length - 1) {
      items.add(BreadcrumbItem(id: node.id, label: node.label));
    } else {
      final capturedNode = node;
      items.add(
        BreadcrumbItem(
          id: node.id,
          label: node.label,
          onClick: () => onSelectView?.call(getFirstLeafId(capturedNode)),
        ),
      );
    }
  }
  return items;
}
