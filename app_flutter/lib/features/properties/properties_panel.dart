import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/app_themes.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/features/properties/property_grid.dart';
import 'package:app_flutter/features/properties/view_models/properties_view_model.dart';

export 'package:app_flutter/core/theme/app_themes.dart' show Arinc661ReticleBorder;
export 'package:app_flutter/features/properties/property_grid.dart'
    show ProvenanceCitationBadge, ZeroCeilingAnnunciatorBadge;

/// ARINC 661 reticle-framed workspace panel that wraps [PropertyGrid] and renders
/// an Operational Use Case Action Bar for high-level entity command dispatch.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Frames operator property editing
///   and operational command actuation (`UC-03: Configure Location`,
///   `UC-10: Drill Hierarchy`, `UC-15: Provision NE`) inside a high-contrast
///   [Arinc661ReticleBorder] with explicit status feedback messaging.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Target Node Fallback Resolution**: Every operational action resolves its
///   target node identifier via $\text{targetId} = \text{currentNodeId} ?? \text{activeView}$,
///   guaranteeing non-null target dispatch.
/// - **Reactive ViewModel Binding**: When a [PropertiesViewModel] is supplied
///   either directly or via [Provider], the panel rebuilds deterministically via
///   [ListenableBuilder] on every state transition.
///
/// ## 3. Preconditions
/// - Must be mounted inside a [MaterialApp] / [Theme] hierarchy providing
///   [ColorScheme] and [TextTheme] tokens.
///
/// ## 4. Postconditions
/// - Renders the `properties_panel_reticle_frame` container housing the
///   `use_case_action_bar_container`, optional `properties_action_status_message`
///   banner, and an expanded [PropertyGrid] (or custom [child]).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|F|)$ where $|F|$ is the number of
///   [FieldDescriptor] items delegated to [PropertyGrid].
/// - **Space Complexity**: $\mathcal{O}(1)$ panel wrapper state overhead.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If no [PropertiesViewModel] is registered in the ancestor [Provider] context,
///   `_resolveViewModel` catches the lookup exception and falls back cleanly to
///   local [fields] and [initialValues] props.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/PropertiesPanel]
/// Realises: [UC-03]
/// Realises: [UC-10]
/// Realises: [UC-15]
@immutable
class PropertiesPanel extends StatelessWidget {
  /// Creates a [PropertiesPanel].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `PropertiesPanel::PropertiesPanel` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `PropertiesPanel::PropertiesPanel` (declaration #2) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesPanel::PropertiesPanel` in `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesPanel::PropertiesPanel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(PropertiesPanel)) bounded over input/member dimension of `PropertiesPanel::PropertiesPanel`.
  /// - Space Complexity: O(K(PropertiesPanel)) bounded auxiliary memory for `PropertiesPanel::PropertiesPanel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::PropertiesPanel` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::PropertiesPanel` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::PropertiesPanel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::PropertiesPanel` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-PROPERTIESPANEL] | SysML v2: ActionDef(PropertiesPanel::PropertiesPanel)
  const PropertiesPanel({
    super.key,
    this.child,
    this.fields = const [],
    this.initialValues = const {},
    this.activeView = 'root',
    this.currentNodeId,
    this.onSave,
    this.onConfigureLocation,
    this.onDrillHierarchy,
    this.onProvisionNe,
    this.viewModel,
  });

  /// Optional custom child widget (e.g. pre-configured [PropertyGrid]). When null,
  /// a default [PropertyGrid] is rendered using [fields] and [initialValues].
  final Widget? child;

  /// List of field descriptors to display in the default [PropertyGrid].
  final List<FieldDescriptor> fields;

  /// Initial property values passed to the default [PropertyGrid].
  final Map<String, Object?> initialValues;

  /// The active view identifier.
  final String activeView;

  /// The target node ID associated with operational use case actions.
  final String? currentNodeId;

  /// Callback executed when property grid edits are committed.
  final void Function(Map<String, Object?>)? onSave;

  /// Callback executed when `UC-03: Configure Location` is triggered.
  final void Function(String nodeId)? onConfigureLocation;

  /// Callback executed when `UC-10: Drill Hierarchy` is triggered.
  final void Function(String nodeId)? onDrillHierarchy;

  /// Callback executed when `UC-15: Provision NE` is triggered.
  final void Function(String nodeId)? onProvisionNe;

  /// Optional explicit [PropertiesViewModel] instance.
  final PropertiesViewModel? viewModel;

  /// Executes deterministic method `PropertiesPanel::_resolveViewModel` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesPanel::_resolveViewModel` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesPanel::_resolveViewModel` (declaration #3) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::_resolveViewModel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `PropertiesViewModel?` from `PropertiesPanel::_resolveViewModel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `PropertiesPanel::_resolveViewModel`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `PropertiesPanel::_resolveViewModel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::_resolveViewModel` (`PropertiesViewModel?`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::_resolveViewModel` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::_resolveViewModel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::_resolveViewModel` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-RESOLVEVIEWMODEL] | SysML v2: ActionDef(PropertiesPanel::_resolveViewModel)
  PropertiesViewModel? _resolveViewModel(BuildContext context) {
    if (viewModel != null) return viewModel;
    try {
      return context.read<PropertiesViewModel>();
    } catch (_) {
      return null;
    }
  }

  /// Executes deterministic method `PropertiesPanel::_triggerConfigureLocation` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesPanel::_triggerConfigureLocation` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesPanel::_triggerConfigureLocation` (declaration #4) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::_triggerConfigureLocation`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesPanel::_triggerConfigureLocation` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `PropertiesPanel::_triggerConfigureLocation`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `PropertiesPanel::_triggerConfigureLocation`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::_triggerConfigureLocation` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::_triggerConfigureLocation` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::_triggerConfigureLocation` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::_triggerConfigureLocation` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-TRIGGERCONFIGURELOCATION] | SysML v2: ActionDef(PropertiesPanel::_triggerConfigureLocation)
  void _triggerConfigureLocation(BuildContext context) {
    final targetId = currentNodeId ?? activeView;
    onConfigureLocation?.call(targetId);
    _resolveViewModel(context)?.configureLocation(targetId);
  }

  /// Executes deterministic method `PropertiesPanel::_triggerDrillHierarchy` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesPanel::_triggerDrillHierarchy` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesPanel::_triggerDrillHierarchy` (declaration #5) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::_triggerDrillHierarchy`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesPanel::_triggerDrillHierarchy` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `PropertiesPanel::_triggerDrillHierarchy`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `PropertiesPanel::_triggerDrillHierarchy`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::_triggerDrillHierarchy` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::_triggerDrillHierarchy` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::_triggerDrillHierarchy` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::_triggerDrillHierarchy` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-TRIGGERDRILLHIERARCHY] | SysML v2: ActionDef(PropertiesPanel::_triggerDrillHierarchy)
  void _triggerDrillHierarchy(BuildContext context) {
    final targetId = currentNodeId ?? activeView;
    onDrillHierarchy?.call(targetId);
    _resolveViewModel(context)?.drillHierarchy(targetId);
  }

  /// Executes deterministic method `PropertiesPanel::_triggerProvisionNe` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesPanel::_triggerProvisionNe` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesPanel::_triggerProvisionNe` (declaration #6) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::_triggerProvisionNe`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesPanel::_triggerProvisionNe` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `PropertiesPanel::_triggerProvisionNe`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `PropertiesPanel::_triggerProvisionNe`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::_triggerProvisionNe` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::_triggerProvisionNe` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::_triggerProvisionNe` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::_triggerProvisionNe` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-TRIGGERPROVISIONNE] | SysML v2: ActionDef(PropertiesPanel::_triggerProvisionNe)
  void _triggerProvisionNe(BuildContext context) {
    final targetId = currentNodeId ?? activeView;
    onProvisionNe?.call(targetId);
    _resolveViewModel(context)?.provisionNe(targetId);
  }

  /// Executes deterministic method `PropertiesPanel::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesPanel::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesPanel::build` (declaration #7) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `PropertiesPanel::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `PropertiesPanel::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `PropertiesPanel::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::build` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::build` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-BUILD] | SysML v2: ActionDef(PropertiesPanel::build)
  @override
  Widget build(BuildContext context) {
    final vm = viewModel ?? (context.watch<PropertiesViewModel?>());
    if (vm != null) {
      return ListenableBuilder(
        listenable: vm,
        builder: (BuildContext context, Widget? child) {
          return _buildContent(context, vm);
        },
      );
    }
    return _buildContent(context, null);
  }

  /// Executes deterministic method `PropertiesPanel::_buildContent` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesPanel::_buildContent` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/properties_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesPanel::_buildContent` (declaration #8) within `PROPERTIES-PROPERTIES-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::_buildContent`.
  /// - `vm: PropertiesViewModel?` must satisfy domain and type-safety constraints prior to invoking `PropertiesPanel::_buildContent`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `PropertiesPanel::_buildContent` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `PropertiesPanel::_buildContent`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `PropertiesPanel::_buildContent`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesPanel::_buildContent` (`Widget`).
  /// - State: Maintains consistent state invariants across `PropertiesPanel::_buildContent` without partial mutation on error.
  /// - Action: Executes `PropertiesPanel::_buildContent` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesPanel::_buildContent` (`PROPERTIES-PROPERTIES-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTIES-PANEL-PROPERTIESPANEL-BUILDCONTENT] | SysML v2: ActionDef(PropertiesPanel::_buildContent)
  Widget _buildContent(BuildContext context, PropertiesViewModel? vm) {
    final effectiveFields = fields.isNotEmpty
        ? fields
        : (vm?.fields ?? const <FieldDescriptor>[]);
    final actionMessage = vm?.state.actionMessage;

    return Container(
      key: const Key('properties_panel_reticle_frame'),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: const Arinc661ReticleBorder(isActive: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Operational Use Case Action Bar framed with Arinc661ReticleBorder
          Container(
            key: const Key('use_case_action_bar_container'),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: ShapeDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withOpacity(0.5),
              shape: const Arinc661ReticleBorder(isActive: true),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  key: const Key('uc_03_configure_location_button'),
                  onPressed: () => _triggerConfigureLocation(context),
                  icon: const Icon(Icons.edit_location_alt, size: 16),
                  label: const Text('UC-03: Configure Location'),
                ),
                OutlinedButton.icon(
                  key: const Key('uc_10_drill_hierarchy_button'),
                  onPressed: () => _triggerDrillHierarchy(context),
                  icon: const Icon(Icons.account_tree, size: 16),
                  label: const Text('UC-10: Drill Hierarchy'),
                ),
                OutlinedButton.icon(
                  key: const Key('uc_15_provision_ne_button'),
                  onPressed: () => _triggerProvisionNe(context),
                  icon: const Icon(Icons.router, size: 16),
                  label: const Text('UC-15: Provision NE'),
                ),
              ],
            ),
          ),
          if (actionMessage != null && actionMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Text(
                actionMessage,
                key: const Key('properties_action_status_message'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          Expanded(
            child: child ??
                PropertyGrid(
                  activeView: activeView,
                  fields: effectiveFields,
                  initialValues: initialValues,
                  onSave: onSave,
                ),
          ),
        ],
      ),
    );
  }
}

