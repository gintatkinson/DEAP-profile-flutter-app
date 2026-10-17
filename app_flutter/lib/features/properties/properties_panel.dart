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

  PropertiesViewModel? _resolveViewModel(BuildContext context) {
    if (viewModel != null) return viewModel;
    try {
      return context.read<PropertiesViewModel>();
    } catch (_) {
      return null;
    }
  }

  void _triggerConfigureLocation(BuildContext context) {
    final targetId = currentNodeId ?? activeView;
    onConfigureLocation?.call(targetId);
    _resolveViewModel(context)?.configureLocation(targetId);
  }

  void _triggerDrillHierarchy(BuildContext context) {
    final targetId = currentNodeId ?? activeView;
    onDrillHierarchy?.call(targetId);
    _resolveViewModel(context)?.drillHierarchy(targetId);
  }

  void _triggerProvisionNe(BuildContext context) {
    final targetId = currentNodeId ?? activeView;
    onProvisionNe?.call(targetId);
    _resolveViewModel(context)?.provisionNe(targetId);
  }

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

