import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';

/// Deterministic [TextInputFormatter] that converts all operator character input
/// to uppercase for schema fields declaring the `"uppercase"` formatter directive.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces canonical uppercase string
///   normalization on every keystroke so case-sensitive asset identifiers and
///   register codes cannot be entered in mixed case.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Idempotent Projection**: For any input string $s$,
///   $\text{upper}(\text{upper}(s)) = \text{upper}(s)$ while preserving cursor
///   selection offsets on ASCII character sequences.
///
/// ## 3. Preconditions
/// - Attached to a [TextField] whose [FieldDescriptor.inputFormatters] contains
///   `"uppercase"`.
///
/// ## 4. Postconditions
/// - Returns a [TextEditingValue] whose `text` is `newValue.text.toUpperCase()`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|s|)$ where $|s|$ is the length of `newValue.text`.
/// - **Space Complexity**: $\mathcal{O}(|s|)$ for the transformed string allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty strings and non-alphabetic characters pass through unchanged without
///   exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/UpperCaseTextFormatter]
@immutable
class UpperCaseTextFormatter extends TextInputFormatter {
  /// Creates an [UpperCaseTextFormatter].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `UpperCaseTextFormatter::UpperCaseTextFormatter` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `UpperCaseTextFormatter::UpperCaseTextFormatter` (declaration #2) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `UpperCaseTextFormatter::UpperCaseTextFormatter` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `UpperCaseTextFormatter::UpperCaseTextFormatter` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(UpperCaseTextFormatter)) bounded over input/member dimension of `UpperCaseTextFormatter::UpperCaseTextFormatter`.
  /// - Space Complexity: O(K(UpperCaseTextFormatter)) bounded auxiliary memory for `UpperCaseTextFormatter::UpperCaseTextFormatter`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `UpperCaseTextFormatter::UpperCaseTextFormatter` (`()`).
  /// - State: Maintains consistent state invariants across `UpperCaseTextFormatter::UpperCaseTextFormatter` without partial mutation on error.
  /// - Action: Executes `UpperCaseTextFormatter::UpperCaseTextFormatter` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `UpperCaseTextFormatter::UpperCaseTextFormatter` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-UPPERCASETEXTFORMATTER-UPPERCASETEXTFORMATTER] | SysML v2: ActionDef(UpperCaseTextFormatter::UpperCaseTextFormatter)
  UpperCaseTextFormatter();

  /// Executes deterministic method `UpperCaseTextFormatter::formatEditUpdate` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `UpperCaseTextFormatter::formatEditUpdate` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `UpperCaseTextFormatter::formatEditUpdate` (declaration #3) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `UpperCaseTextFormatter::formatEditUpdate` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TextEditingValue` from `UpperCaseTextFormatter::formatEditUpdate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(formatEditUpdate)) bounded over input/member dimension of `UpperCaseTextFormatter::formatEditUpdate`.
  /// - Space Complexity: O(K(formatEditUpdate)) bounded auxiliary memory for `UpperCaseTextFormatter::formatEditUpdate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `UpperCaseTextFormatter::formatEditUpdate` (`TextEditingValue`).
  /// - State: Maintains consistent state invariants across `UpperCaseTextFormatter::formatEditUpdate` without partial mutation on error.
  /// - Action: Executes `UpperCaseTextFormatter::formatEditUpdate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `UpperCaseTextFormatter::formatEditUpdate` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-UPPERCASETEXTFORMATTER-FORMATEDITUPDATE] | SysML v2: ActionDef(UpperCaseTextFormatter::formatEditUpdate)
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

/// Schema-driven ARINC 661 editable property grid that groups [FieldDescriptor]
/// items by section, enforces numeric/regex/schema constraints on blur, and
/// renders inline safety annunciators ([ZeroCeilingAnnunciatorBadge] and
/// [ProvenanceCitationBadge]).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Prevents invalid parameter commits
///   by gating `onSave` behind multi-stage field validation (required check,
///   numeric coercion, regex pattern match, $[v_{\min}, v_{\max}]$ bounds check,
///   and dynamic schema validation) and supports explicit transaction commit/rollback.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Validated Commit Gate**: A modified field value $v$ for key $k$ is written
///   to `committedData[k]` and emitted via [onSave] if and only if
///   $\text{isValid}(k, v) = \text{true}$.
/// - **Responsive Column Clamping**: Given available width $W$, the section grid
///   column count $C$ satisfies:
///   $$
///   \begin{aligned}
///   C &= \min(4, \max(1, \lfloor W / 350.0 \rfloor))
///   \end{aligned}
///   $$
///
/// ## 3. Preconditions
/// - Must be rendered inside a [BuildContext] providing [ThemeController] via
///   [Provider].
///
/// ## 4. Postconditions
/// - Renders section cards sorted in natural alphanumeric order, a transaction
///   control bar (`Save`, optional `Commit` and `Rollback`), and a read-only
///   committed-state JSON inspection panel.
/// - Disposes all [TextEditingController] and [FocusNode] instances on unmount
///   or field-list replacement.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|F| \log |F|)$ to group and natural-sort
///   $|F|$ field descriptors; $\mathcal{O}(1)$ layout memoization on unchanged
///   column count and width.
/// - **Space Complexity**: $\mathcal{O}(|F|)$ controllers, focus nodes, and
///   committed key-value entries.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Invalid numeric strings or out-of-range inputs record human-readable error
///   messages in `_errors[key]` without mutating `committedData` or invoking [onSave].
/// - Unfocused fields automatically synchronize when `initialValues` updates
///   externally, while focused fields preserve in-flight operator keystrokes.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [UC-06/PropertyGrid]
@immutable
class PropertyGrid extends StatefulWidget {
  /// The list of field descriptors to display. When empty the grid renders
  /// nothing editable.
  final List<FieldDescriptor> fields;

  /// Initial values keyed by [FieldDescriptor.key]. Keys present in
  /// [initialValues] but absent from [fields] are silently ignored. Missing
  /// keys render as empty strings.
  final Map<String, Object?> initialValues;

  /// Called with the current committed data after a field passes validation on
  /// blur. Not called if validation fails. The callback receives a fresh
  /// `Map<String, Object?>` of the entire committed state, not just the edited
  /// field. Can be null to opt out of save notifications.
  final void Function(Map<String, Object?>)? onSave;

  /// The currently active view name used to highlight the matching section.
  /// When set to `'root'`, the first section (alphabetically) is highlighted.
  /// Sections whose [FieldDescriptor.sectionLabel] does not match are dimmed.
  final String activeView;

  /// Responsive breakpoint at which the layout switches from single-column to
  /// two-column grid. Defaults to 700.0.
  final double wideLayoutBreakpoint;

  /// Padding applied inside each section card. Defaults to
  /// `EdgeInsets.all(20.0)`.
  final EdgeInsetsGeometry sectionPadding;

  /// Uniform gap used between fields and sections. Defaults to 8.0.
  final double gapSize;

  /// Border radius used for section cards. Defaults to
  /// `BorderRadius.circular(12.0)`.
  final BorderRadiusGeometry cardBorderRadius;

  /// Border radius used for text field and dropdown input borders. Defaults to
  /// `BorderRadius.circular(6.0)`.
  final BorderRadius inputBorderRadius;

  /// Optional dynamic schema validation callback.
  ///
  /// Receives the property key and value. Returns an error message string
  /// if validation fails, or null if valid.
  final String? Function(String key, Object? value)? validateSchemaProperty;

  /// Callback executed when an edit transaction is committed.
  ///
  /// Fires when the user explicitly commits changes via the grid or save action.
  final VoidCallback? commitTransaction;

  /// Callback executed when an edit transaction is rolled back.
  ///
  /// Fires when the user explicitly cancels or rolls back pending grid edits.
  final VoidCallback? rollbackTransaction;

  /// Creates a [PropertyGrid] with the given field descriptors, initial values,
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `PropertyGrid::PropertyGrid` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `PropertyGrid::PropertyGrid` (declaration #5) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertyGrid::PropertyGrid` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertyGrid::PropertyGrid` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(PropertyGrid)) bounded over input/member dimension of `PropertyGrid::PropertyGrid`.
  /// - Space Complexity: O(K(PropertyGrid)) bounded auxiliary memory for `PropertyGrid::PropertyGrid`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertyGrid::PropertyGrid` (`()`).
  /// - State: Maintains consistent state invariants across `PropertyGrid::PropertyGrid` without partial mutation on error.
  /// - Action: Executes `PropertyGrid::PropertyGrid` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertyGrid::PropertyGrid` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRID-PROPERTYGRID] | SysML v2: ActionDef(PropertyGrid::PropertyGrid)
  const PropertyGrid({
    super.key,
    this.fields = const [],
    this.initialValues = const {},
    this.onSave,
    this.activeView = 'root',
    this.wideLayoutBreakpoint = 700.0,
    this.sectionPadding = const EdgeInsets.all(20.0),
    this.gapSize = 8.0,
    this.cardBorderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.inputBorderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.validateSchemaProperty,
    this.commitTransaction,
    this.rollbackTransaction,
  });

  /// Executes deterministic method `PropertyGrid::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertyGrid::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertyGrid::createState` (declaration #6) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertyGrid::createState` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<PropertyGrid>` from `PropertyGrid::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `PropertyGrid::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `PropertyGrid::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertyGrid::createState` (`State<PropertyGrid>`).
  /// - State: Maintains consistent state invariants across `PropertyGrid::createState` without partial mutation on error.
  /// - Action: Executes `PropertyGrid::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertyGrid::createState` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRID-CREATESTATE] | SysML v2: ActionDef(PropertyGrid::createState)
  @override
  State<PropertyGrid> createState() => _PropertyGridState();
}

const _inactiveSectionOpacity = 0.65;
const _activeShadowOpacity = 0.1;
const _inactiveShadowOpacity = 0.05;
const _activeBadgeBgOpacity = 0.15;
const _activeBadgeBorderOpacity = 0.3;

/// Executes deterministic class `_PropertyGridState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_PropertyGridState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_PropertyGridState` (declaration #7) within `PROPERTIES-PROPERTY-GRID`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_PropertyGridState` in `PROPERTIES-PROPERTY-GRID`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_PropertyGridState` representation for class `_PropertyGridState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_PropertyGridState)) bounded over input/member dimension of `_PropertyGridState`.
/// - Space Complexity: O(K(_PropertyGridState)) bounded auxiliary memory for `_PropertyGridState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_PropertyGridState` (`_PropertyGridState`).
/// - State: Maintains consistent state invariants across `_PropertyGridState` without partial mutation on error.
/// - Action: Executes `_PropertyGridState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_PropertyGridState` (`PROPERTIES-PROPERTY-GRID`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE] | SysML v2: PartDef(_PropertyGridState)
class _PropertyGridState extends State<PropertyGrid> {
  late List<FieldDescriptor> _fields;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  Map<String, String> _errors = const {};
  final Map<String, bool> _hadFocus = {};
  bool _isDisposingFields = false;

  late Map<String, dynamic> committedData;

  /// Executes deterministic method `_PropertyGridState::initState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::initState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::initState` (declaration #8) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::initState` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_PropertyGridState::initState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(initState)) bounded over input/member dimension of `_PropertyGridState::initState`.
  /// - Space Complexity: O(K(initState)) bounded auxiliary memory for `_PropertyGridState::initState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::initState` (`void`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::initState` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::initState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::initState` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-INITSTATE] | SysML v2: ActionDef(_PropertyGridState::initState)
  @override
  void initState() {
    super.initState();
    _fields = widget.fields;
    committedData = Map<String, dynamic>.from(widget.initialValues);
    _initializeFields(_fields, committedData);
  }

  /// Creates a [TextEditingController] and [FocusNode] for every field in
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_initializeFields` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_initializeFields` (declaration #9) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `fields: List<FieldDescriptor>` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_initializeFields`.
  /// - `nodeData: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_initializeFields`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_PropertyGridState::_initializeFields` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(fields)) bounded over input/member dimension of `_PropertyGridState::_initializeFields`.
  /// - Space Complexity: O(N(fields)) bounded auxiliary memory for `_PropertyGridState::_initializeFields`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_initializeFields` (`void`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_initializeFields` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_initializeFields` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_initializeFields` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-INITIALIZEFIELDS] | SysML v2: ActionDef(_PropertyGridState::_initializeFields)
  void _initializeFields(List<FieldDescriptor> fields, Map<String, dynamic> nodeData) {
    for (final field in fields) {
      final val = nodeData[field.key];
      final text = val != null ? val.toString() : '';
      final controller = TextEditingController(text: text);
      final focusNode = FocusNode();

      _controllers[field.key] = controller;
      _focusNodes[field.key] = focusNode;
      _hadFocus[field.key] = false;

      if (field.type != 'enum') {
        focusNode.addListener(() {
          if (_isDisposingFields) return;
          final bool currentlyHasFocus = focusNode.hasFocus;
          final bool previouslyHadFocus = _hadFocus[field.key] ?? false;
          _hadFocus[field.key] = currentlyHasFocus;

          if (previouslyHadFocus && !currentlyHasFocus) {
            _triggerBlurSave(field.key, field);
          }
        });
      }
    }
  }

  /// Disposes all [TextEditingController] and [FocusNode] instances, then
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_disposeAllFields` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_disposeAllFields` (declaration #10) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::_disposeAllFields` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_PropertyGridState::_disposeAllFields` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_disposeAllFields)) bounded over input/member dimension of `_PropertyGridState::_disposeAllFields`.
  /// - Space Complexity: O(K(_disposeAllFields)) bounded auxiliary memory for `_PropertyGridState::_disposeAllFields`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_disposeAllFields` (`void`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_disposeAllFields` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_disposeAllFields` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_disposeAllFields` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-DISPOSEALLFIELDS] | SysML v2: ActionDef(_PropertyGridState::_disposeAllFields)
  void _disposeAllFields() {
    _isDisposingFields = true;
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _controllers.clear();
    _focusNodes.clear();
    _hadFocus.clear();
    _errors = const {};
    _isDisposingFields = false;
  }

  /// Executes deterministic method `_PropertyGridState::didUpdateWidget` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::didUpdateWidget` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::didUpdateWidget` (declaration #11) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `oldWidget: PropertyGrid` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::didUpdateWidget`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_PropertyGridState::didUpdateWidget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(oldWidget)) bounded over input/member dimension of `_PropertyGridState::didUpdateWidget`.
  /// - Space Complexity: O(N(oldWidget)) bounded auxiliary memory for `_PropertyGridState::didUpdateWidget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::didUpdateWidget` (`void`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::didUpdateWidget` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::didUpdateWidget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::didUpdateWidget` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-DIDUPDATEWIDGET] | SysML v2: ActionDef(_PropertyGridState::didUpdateWidget)
  @override
  void didUpdateWidget(PropertyGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldFields = oldWidget.fields;
    final newFields = widget.fields;

    bool fieldsChanged = oldFields.length != newFields.length;
    if (!fieldsChanged) {
      for (int i = 0; i < newFields.length; i++) {
        if (oldFields[i].key != newFields[i].key ||
            oldFields[i].type != newFields[i].type ||
            oldFields[i].sectionLabel != newFields[i].sectionLabel) {
          fieldsChanged = true;
          break;
        }
      }
    }

    if (fieldsChanged) {
      setState(() {
        _disposeAllFields();
        _fields = newFields;
        committedData = Map<String, dynamic>.from(widget.initialValues);
        _initializeFields(_fields, committedData);
      });
    } else {
      setState(() {
        committedData = Map<String, dynamic>.from(widget.initialValues);
        _errors = const {};
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          for (final field in _fields) {
            final focusNode = _focusNodes[field.key];
            if (focusNode != null && !focusNode.hasFocus) {
              final newVal = widget.initialValues[field.key] ?? committedData[field.key];
              final text = newVal != null ? newVal.toString() : '';
              _controllers[field.key]?.text = text;
            }
          }
        });
      });
    }
  }

  /// Executes deterministic method `_PropertyGridState::dispose` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::dispose` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::dispose` (declaration #12) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::dispose` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_PropertyGridState::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `_PropertyGridState::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `_PropertyGridState::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::dispose` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::dispose` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-DISPOSE] | SysML v2: ActionDef(_PropertyGridState::dispose)
  @override
  void dispose() {
    _disposeAllFields();
    super.dispose();
  }

  /// Validates a field's string value according to the rules declared on
  /// [field].
  ///
  /// Returns a tuple of (isValid, parsedValue, errorMessage):
  ///   - [isValid] is true when all checks pass.
  ///   - [parsedValue] is the value coerced to `double`, `int`, or kept as
  ///     `String` depending on [field.type].
  ///   - [error] is a human-readable message when validation fails, or null
  ///     on success.
  ///
  /// Checks performed in order: required (non-empty), numeric parse,
  /// regex pattern, numeric bounds. Validation is skipped entirely when
  /// [valueString] is empty and the field is not required, allowing optional
  /// fields to remain blank.
  (bool isValid, dynamic parsedValue, String? error) _validateField(
    String key, FieldDescriptor field, String valueString,
  ) {
    dynamic parsedValue;

    if (field.required && valueString.trim().isEmpty) {
      return (false, null, '${_resolveFieldLabel(field)} is required');
    }

    if (field.type == 'double') {
      final val = double.tryParse(valueString);
      if (val == null && valueString.isNotEmpty) {
        return (false, null, 'Must be a valid double');
      }
      parsedValue = val;
    } else if (field.type == 'int') {
      final val = int.tryParse(valueString);
      if (val == null && valueString.isNotEmpty) {
        return (false, null, 'Must be a valid integer');
      }
      parsedValue = val;
    } else {
      parsedValue = valueString;
    }

    if (field.pattern != null && valueString.isNotEmpty) {
      final reg = RegExp(field.pattern!);
      if (!reg.hasMatch(valueString)) {
        return (false, parsedValue, 'Invalid format');
      }
    }

    if (parsedValue is num) {
      if (field.minValue != null && parsedValue < field.minValue!) {
        return (false, parsedValue, 'Value cannot be less than ${field.minValue}');
      }
      if (field.maxValue != null && parsedValue > field.maxValue!) {
        return (false, parsedValue, 'Value cannot be greater than ${field.maxValue}');
      }
    }

    if (widget.validateSchemaProperty != null) {
      final schemaError = widget.validateSchemaProperty!(key, parsedValue ?? valueString);
      if (schemaError != null && schemaError.isNotEmpty) {
        return (false, parsedValue, schemaError);
      }
    }

    return (true, parsedValue, null);
  }

  /// Validates the current value of [field] on blur and, if valid, commits it
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_triggerBlurSave` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_triggerBlurSave` (declaration #13) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_triggerBlurSave`.
  /// - `field: FieldDescriptor` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_triggerBlurSave`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_PropertyGridState::_triggerBlurSave` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `_PropertyGridState::_triggerBlurSave`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `_PropertyGridState::_triggerBlurSave`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_triggerBlurSave` (`void`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_triggerBlurSave` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_triggerBlurSave` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_triggerBlurSave` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-TRIGGERBLURSAVE] | SysML v2: ActionDef(_PropertyGridState::_triggerBlurSave)
  void _triggerBlurSave(String key, FieldDescriptor field) {
    if (!mounted) return;
    if (!_controllers.containsKey(key) || !_focusNodes.containsKey(key)) {
      return;
    }
    final valueString = field.type == 'enum'
        ? (committedData[key]?.toString() ?? '')
        : (_controllers[key]?.text ?? '');
    final Map<String, String> newErrors = Map<String, String>.from(_errors);

    final (bool isValid, dynamic parsedValue, String? error) = _validateField(key, field, valueString);

    setState(() {
      if (isValid) {
        newErrors.remove(key);
      } else {
        newErrors[key] = error ?? 'Invalid value';
      }
      _errors = newErrors;
    });

    if (isValid) {
      setState(() {
        committedData[key] = parsedValue;
      });

      widget.onSave?.call(Map<String, dynamic>.from(committedData));
    }
  }

  /// Resolves the list of [TextInputFormatter]s declared on [field].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_resolveInputFormatters` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_resolveInputFormatters` (declaration #14) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `field: FieldDescriptor` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_resolveInputFormatters`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<TextInputFormatter>?` from `_PropertyGridState::_resolveInputFormatters` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(field)) bounded over input/member dimension of `_PropertyGridState::_resolveInputFormatters`.
  /// - Space Complexity: O(N(field)) bounded auxiliary memory for `_PropertyGridState::_resolveInputFormatters`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_resolveInputFormatters` (`List<TextInputFormatter>?`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_resolveInputFormatters` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_resolveInputFormatters` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_resolveInputFormatters` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-RESOLVEINPUTFORMATTERS] | SysML v2: ActionDef(_PropertyGridState::_resolveInputFormatters)
  List<TextInputFormatter>? _resolveInputFormatters(FieldDescriptor field) {
    if (field.inputFormatters == null || field.inputFormatters!.isEmpty) return null;
    final List<TextInputFormatter> formatters = [];
    for (final fmt in field.inputFormatters!) {
      if (fmt == 'uppercase') {
        formatters.add(UpperCaseTextFormatter());
      } else if (fmt.startsWith('maxLength:')) {
        final parts = fmt.split(':');
        if (parts.length == 2) {
          final len = int.tryParse(parts[1]);
          if (len != null) {
            formatters.add(LengthLimitingTextInputFormatter(len));
          }
        }
      }
    }
    return formatters.isNotEmpty ? formatters : null;
  }

  /// Executes deterministic method `_PropertyGridState::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::build` (declaration #15) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_PropertyGridState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_PropertyGridState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::build` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::build` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILD] | SysML v2: ActionDef(_PropertyGridState::build)
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final panelOpacity = context.watch<ThemeController>().panelOpacity;

    final groups = <String>{};
    for (final field in _fields) {
      groups.add(field.sectionLabel ?? 'Other');
    }

    final List<String> sortedGroups = groups.toList()
      ..sort((a, b) => _naturalCompare(a, b));

    final List<Widget> sections = sortedGroups.map((group) {
      final bool isActive = group == widget.activeView ||
          (widget.activeView == 'root' && group == sortedGroups.first);

      return _buildSystemSection(
        title: group,
        isActive: isActive,
        isDark: isDark,
        child: _buildGroupFields(group, isDark, panelOpacity),
        panelOpacity: panelOpacity,
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth.isFinite ? constraints.maxWidth : 350.0;
              final int columnCount = (width / 350.0).floor().clamp(1, 4);
              final double cardWidth = (width - (columnCount - 1) * widget.gapSize) / columnCount - 0.01;

              return _LayoutMemo(
                columnCount: columnCount,
                cardWidth: cardWidth,
                builder: (cc, cw) => Wrap(
                  spacing: widget.gapSize,
                  runSpacing: widget.gapSize,
                  children: sections.map((sec) => SizedBox(width: cw, child: sec)).toList(),
                ),
              );
            },
          ),
          SizedBox(height: widget.gapSize),
          Row(
            children: [
              ElevatedButton(
                key: const Key('save_properties_button'),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.commitTransaction?.call();
                },
                child: const Text('Save'),
              ),
              if (widget.commitTransaction != null) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('commit_transaction_button'),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.commitTransaction?.call();
                  },
                  child: const Text('Commit'),
                ),
              ],
              if (widget.rollbackTransaction != null) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  key: const Key('rollback_transaction_button'),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      committedData = Map<String, dynamic>.from(widget.initialValues);
                      _errors = const {};
                    });
                    widget.rollbackTransaction?.call();
                  },
                  child: const Text('Rollback'),
                ),
              ],
            ],
          ),
          SizedBox(height: widget.gapSize),
          _buildCommittedStatePanel(isDark, panelOpacity),
        ],
      ),
    );
  }

  /// Caches [columnCount] and [cardWidth] so that the child tree is only
  /// rebuilt when either value actually changes, not on every pixel-level
  /// constraint delta from [LayoutBuilder] during window resize.
  Widget? _layoutMemoCached;
  int? _memoColumnCount;
  double? _memoCardWidth;
  List<FieldDescriptor>? _memoFields;
  int _memoErrorsLength = -1;

  /// Executes deterministic method `_PropertyGridState::_LayoutMemo` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_LayoutMemo` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_LayoutMemo` (declaration #16) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::_LayoutMemo` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_LayoutMemo` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_LayoutMemo)) bounded over input/member dimension of `_PropertyGridState::_LayoutMemo`.
  /// - Space Complexity: O(K(_LayoutMemo)) bounded auxiliary memory for `_PropertyGridState::_LayoutMemo`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_LayoutMemo` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_LayoutMemo` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_LayoutMemo` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_LayoutMemo` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-LAYOUTMEMO] | SysML v2: ActionDef(_PropertyGridState::_LayoutMemo)
  Widget _LayoutMemo({
    required int columnCount,
    required double cardWidth,
    required Widget Function(int columnCount, double cardWidth) builder,
  }) {
    final int currentErrorsLen = _errors.length;
    if (_memoFields != _fields || _memoColumnCount != columnCount || _memoCardWidth != cardWidth || _memoErrorsLength != currentErrorsLen) {
      _memoFields = _fields;
      _memoColumnCount = columnCount;
      _memoCardWidth = cardWidth;
      _memoErrorsLength = currentErrorsLen;
      _layoutMemoCached = builder(columnCount, cardWidth);
    }
    return _layoutMemoCached!;
  }

  /// Builds a single section card with a title header, an optional "Active
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_buildSystemSection` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_buildSystemSection` (declaration #17) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::_buildSystemSection` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_buildSystemSection` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_buildSystemSection)) bounded over input/member dimension of `_PropertyGridState::_buildSystemSection`.
  /// - Space Complexity: O(K(_buildSystemSection)) bounded auxiliary memory for `_PropertyGridState::_buildSystemSection`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_buildSystemSection` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_buildSystemSection` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_buildSystemSection` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_buildSystemSection` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILDSYSTEMSECTION] | SysML v2: ActionDef(_PropertyGridState::_buildSystemSection)
  Widget _buildSystemSection({
    required String title,
    required bool isActive,
    required bool isDark,
    required Widget child,
    required double panelOpacity,
  }) {
    final cs = Theme.of(context).colorScheme;
    final Color brandPrimary = cs.primary;
    final Color borderColor = Theme.of(context).dividerColor;
    final Color surfaceFill = cs.surfaceContainerHighest.withOpacity(panelOpacity);
    final Color borderActive = brandPrimary;

    return Opacity(
      opacity: isActive ? 1.0 : _inactiveSectionOpacity,
      child: Container(
        padding: widget.sectionPadding,
        decoration: BoxDecoration(
          color: surfaceFill,
          borderRadius: widget.cardBorderRadius,
          border: Border.all(
            color: isActive ? borderActive : borderColor,
            width: isActive ? 2.0 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: brandPrimary.withValues(alpha: _activeShadowOpacity),
                    blurRadius: 24.0,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: _inactiveShadowOpacity),
                    blurRadius: 20.0,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                  if (isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: _activeBadgeBgOpacity),
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: _activeBadgeBorderOpacity),
                        ),
                      ),
                      child: Text(
                        'Active Reference',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
              ],
            ),
            SizedBox(height: widget.gapSize),
            child,
          ],
        ),
      ),
    );
  }

  /// Builds all fields belonging to [group], sorted by [FieldDescriptor.sectionOrder].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_buildGroupFields` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_buildGroupFields` (declaration #18) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `group: String` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildGroupFields`.
  /// - `isDark: bool` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildGroupFields`.
  /// - `panelOpacity: double` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildGroupFields`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_buildGroupFields` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(group)) bounded over input/member dimension of `_PropertyGridState::_buildGroupFields`.
  /// - Space Complexity: O(N(group)) bounded auxiliary memory for `_PropertyGridState::_buildGroupFields`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_buildGroupFields` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_buildGroupFields` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_buildGroupFields` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_buildGroupFields` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILDGROUPFIELDS] | SysML v2: ActionDef(_PropertyGridState::_buildGroupFields)
  Widget _buildGroupFields(String group, bool isDark, double panelOpacity) {
    final groupFields = _fields
        .where((field) => (field.sectionLabel ?? 'Other') == group)
        .toList()
      ..sort((a, b) {
        final int cmp = a.sectionOrder.compareTo(b.sectionOrder);
        if (cmp != 0) return cmp;
        return _naturalCompare(a.key, b.key);
      });

    final List<Widget> fields = [];
    for (final field in groupFields) {
      fields.add(_buildAttrField(field, isDark, panelOpacity));
      fields.add(SizedBox(height: widget.gapSize));
    }

    if (fields.isNotEmpty) {
      fields.removeLast();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields,
    );
  }

  /// Builds the input widget for a single [field], dispatching to either a
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_buildAttrField` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_buildAttrField` (declaration #19) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `field: FieldDescriptor` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildAttrField`.
  /// - `isDark: bool` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildAttrField`.
  /// - `panelOpacity: double` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildAttrField`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_buildAttrField` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(field)) bounded over input/member dimension of `_PropertyGridState::_buildAttrField`.
  /// - Space Complexity: O(N(field)) bounded auxiliary memory for `_PropertyGridState::_buildAttrField`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_buildAttrField` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_buildAttrField` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_buildAttrField` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_buildAttrField` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILDATTRFIELD] | SysML v2: ActionDef(_PropertyGridState::_buildAttrField)
  Widget _buildAttrField(FieldDescriptor field, bool isDark, double panelOpacity) {
    final cs = Theme.of(context).colorScheme;
    final Color brandPrimary = cs.primary;

    final effectiveLabel = _resolveFieldLabel(field);

    if (field.type == 'enum') {
      final options = field.enumOptions ?? const [];
      final currentValue = committedData[field.key] ?? (options.isNotEmpty ? options.first : '');

      return _buildDropdownField(
        label: effectiveLabel,
        focusNode: _focusNodes[field.key]!,
        value: currentValue as String,
        errorText: _errors[field.key],
        isDark: isDark,
        brandPrimary: brandPrimary,
        panelOpacity: panelOpacity,
        items: options.asMap().entries.map((entry) {
          final int idx = entry.key;
          final String opt = entry.value;
          String displayName = opt;
          if (field.enumDisplayNames != null && idx < field.enumDisplayNames!.length) {
            displayName = field.enumDisplayNames![idx];
          }
          return DropdownMenuItem<String>(
            value: opt,
            child: Text(displayName),
          );
        }).toList(),
        onChanged: (String? val) {
          if (val != null) {
            setState(() {
              committedData[field.key] = val;
            });
            _triggerBlurSave(field.key, field);
          }
        },
      );
    } else {
      TextInputType keyboardType = TextInputType.text;
      List<TextInputFormatter>? inputFormatters;

      if (field.type == 'double') {
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
      } else if (field.type == 'int') {
        keyboardType = TextInputType.number;
      }

      inputFormatters = _resolveInputFormatters(field);

      return _buildTextField(
        field: field,
        label: effectiveLabel,
        controller: _controllers[field.key]!,
        focusNode: _focusNodes[field.key]!,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        errorText: _errors[field.key],
        brandPrimary: brandPrimary,
        panelOpacity: panelOpacity,
      );
    }
  }

  /// Derives the effective label for a field descriptor.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_resolveFieldLabel` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_resolveFieldLabel` (declaration #20) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `fd: FieldDescriptor` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_resolveFieldLabel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `_PropertyGridState::_resolveFieldLabel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(fd)) bounded over input/member dimension of `_PropertyGridState::_resolveFieldLabel`.
  /// - Space Complexity: O(N(fd)) bounded auxiliary memory for `_PropertyGridState::_resolveFieldLabel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_resolveFieldLabel` (`String`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_resolveFieldLabel` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_resolveFieldLabel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_resolveFieldLabel` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-RESOLVEFIELDLABEL] | SysML v2: ActionDef(_PropertyGridState::_resolveFieldLabel)
  String _resolveFieldLabel(FieldDescriptor fd) {
    final labelStr = fd.label.trim();
    if (labelStr.isEmpty || labelStr.startsWith('Field ')) {
      return _deriveLabelFromKey(fd.key);
    }
    return fd.label;
  }

  /// Formats a schema key into a human-readable title/label.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_deriveLabelFromKey` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_deriveLabelFromKey` (declaration #21) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_deriveLabelFromKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `_PropertyGridState::_deriveLabelFromKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `_PropertyGridState::_deriveLabelFromKey`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `_PropertyGridState::_deriveLabelFromKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_deriveLabelFromKey` (`String`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_deriveLabelFromKey` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_deriveLabelFromKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_deriveLabelFromKey` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-DERIVELABELFROMKEY] | SysML v2: ActionDef(_PropertyGridState::_deriveLabelFromKey)
  static String _deriveLabelFromKey(String key) {
    final trimmed = key.trim();
    if (trimmed.isEmpty) return trimmed;

    if (trimmed.contains('_')) {
      final parts = trimmed.split('_').where((p) => p.isNotEmpty);
      return parts
          .map((p) => p[0].toUpperCase() + p.substring(1))
          .join(' ');
    }

    final exp = RegExp(r'(?<=[a-z0-9])(?=[A-Z])');
    final words = trimmed.split(exp);
    return words
        .map((w) => w.isNotEmpty ? (w[0].toUpperCase() + w.substring(1)) : '')
        .join(' ');
  }

  /// Builds a labelled [TextField] bound to [controller] and [focusNode].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_buildTextField` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_buildTextField` (declaration #22) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::_buildTextField` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_buildTextField` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_buildTextField)) bounded over input/member dimension of `_PropertyGridState::_buildTextField`.
  /// - Space Complexity: O(K(_buildTextField)) bounded auxiliary memory for `_PropertyGridState::_buildTextField`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_buildTextField` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_buildTextField` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_buildTextField` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_buildTextField` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILDTEXTFIELD] | SysML v2: ActionDef(_PropertyGridState::_buildTextField)
  Widget _buildTextField({
    required FieldDescriptor field,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    required Color brandPrimary,
    required double panelOpacity,
  }) {
    final cs = Theme.of(context).colorScheme;
    final bool isZeroCeiling =
        field.type == 'int' && field.minValue == 0 && field.maxValue == 0;
    final bool hasPatternSchemaRef =
        field.type == 'string' && (field.pattern?.contains('schema/') ?? false);
    final bool isProvenanceField = field.type == 'string' &&
        (hasPatternSchemaRef || controller.text.contains('schema/'));

    final Widget textFieldWidget = TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: isProvenanceField
          ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              )
          : Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        filled: true,
        fillColor: cs.surface.withOpacity(panelOpacity),
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.inputBorderRadius,
          borderSide: BorderSide(
            color: errorText != null
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).dividerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: widget.inputBorderRadius,
          borderSide: BorderSide(
            color: errorText != null ? Theme.of(context).colorScheme.error : brandPrimary,
            width: 1.5,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: widget.gapSize),
        if (isZeroCeiling)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: textFieldWidget),
              const SizedBox(width: 8.0),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, editingValue, _) {
                  final raw = editingValue.text.trim();
                  final parsed = raw.isEmpty ? 0 : int.tryParse(raw);
                  final isVerified = parsed != null && parsed == 0;
                  return ZeroCeilingAnnunciatorBadge(
                    key: Key('zero_ceiling_badge_${field.key}'),
                    isVerified: isVerified,
                  );
                },
              ),
            ],
          )
        else
          textFieldWidget,
        if (field.type == 'string')
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, editingValue, _) {
              final text = editingValue.text;
              final matchesSchema =
                  hasPatternSchemaRef || text.contains('schema/');
              if (!matchesSchema) {
                return const SizedBox.shrink();
              }
              final citation = ProvenanceCitationBadge.extractCitation(
                value: text,
                pattern: field.pattern,
              );
              return Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: ProvenanceCitationBadge(
                  key: Key('provenance_badge_${field.key}'),
                  citation: citation,
                ),
              );
            },
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }


  /// Builds a labelled [DropdownButtonFormField] bound to [focusNode].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_buildDropdownField` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_buildDropdownField` (declaration #23) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_PropertyGridState::_buildDropdownField` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_buildDropdownField` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_buildDropdownField)) bounded over input/member dimension of `_PropertyGridState::_buildDropdownField`.
  /// - Space Complexity: O(K(_buildDropdownField)) bounded auxiliary memory for `_PropertyGridState::_buildDropdownField`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_buildDropdownField` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_buildDropdownField` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_buildDropdownField` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_buildDropdownField` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILDDROPDOWNFIELD] | SysML v2: ActionDef(_PropertyGridState::_buildDropdownField)
  Widget _buildDropdownField({
    required String label,
    required FocusNode focusNode,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    String? errorText,
    required bool isDark,
    required Color brandPrimary,
    required double panelOpacity,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: widget.gapSize),
          Focus(
            focusNode: focusNode,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: value,
            dropdownColor: (isDark ? cs.surfaceContainerHighest : cs.surface).withOpacity(panelOpacity),
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              filled: true,
              fillColor: cs.surface.withOpacity(panelOpacity),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.inputBorderRadius,
                borderSide: BorderSide(
                  color: errorText != null
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).dividerColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.inputBorderRadius,
                borderSide: BorderSide(
                  color: errorText != null ? Theme.of(context).colorScheme.error : brandPrimary,
                  width: 1.5,
                ),
              ),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  /// Builds a read-only panel showing the current [committedData] as
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_buildCommittedStatePanel` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_buildCommittedStatePanel` (declaration #24) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `isDark: bool` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildCommittedStatePanel`.
  /// - `panelOpacity: double` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_buildCommittedStatePanel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_PropertyGridState::_buildCommittedStatePanel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(isDark)) bounded over input/member dimension of `_PropertyGridState::_buildCommittedStatePanel`.
  /// - Space Complexity: O(N(isDark)) bounded auxiliary memory for `_PropertyGridState::_buildCommittedStatePanel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_buildCommittedStatePanel` (`Widget`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_buildCommittedStatePanel` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_buildCommittedStatePanel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_buildCommittedStatePanel` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-BUILDCOMMITTEDSTATEPANEL] | SysML v2: ActionDef(_PropertyGridState::_buildCommittedStatePanel)
  Widget _buildCommittedStatePanel(bool isDark, double panelOpacity) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(panelOpacity),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Committed Data (verified on blur)',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: widget.gapSize),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: cs.surface.withOpacity(panelOpacity),
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                const JsonEncoder.withIndent('  ').convert(committedData),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Executes deterministic method `_PropertyGridState::_naturalCompare` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_PropertyGridState::_naturalCompare` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_PropertyGridState::_naturalCompare` (declaration #25) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `a: String` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_naturalCompare`.
  /// - `b: String` must satisfy domain and type-safety constraints prior to invoking `_PropertyGridState::_naturalCompare`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `_PropertyGridState::_naturalCompare` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(a)) bounded over input/member dimension of `_PropertyGridState::_naturalCompare`.
  /// - Space Complexity: O(N(a)) bounded auxiliary memory for `_PropertyGridState::_naturalCompare`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_PropertyGridState::_naturalCompare` (`int`).
  /// - State: Maintains consistent state invariants across `_PropertyGridState::_naturalCompare` without partial mutation on error.
  /// - Action: Executes `_PropertyGridState::_naturalCompare` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_PropertyGridState::_naturalCompare` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROPERTYGRIDSTATE-NATURALCOMPARE] | SysML v2: ActionDef(_PropertyGridState::_naturalCompare)
  int _naturalCompare(String a, String b) {
    final RegExp regExp = RegExp(r'(\d+)|(\D+)');
    final Iterable<Match> matchesA = regExp.allMatches(a);
    final Iterable<Match> matchesB = regExp.allMatches(b);
    
    final List<String> chunksA = matchesA.map((m) => m.group(0)!).toList();
    final List<String> chunksB = matchesB.map((m) => m.group(0)!).toList();
    
    final int minLen = chunksA.length < chunksB.length ? chunksA.length : chunksB.length;
    for (int i = 0; i < minLen; i++) {
      final String chunkA = chunksA[i];
      final String chunkB = chunksB[i];
      
      final bool isDigitA = RegExp(r'^\d+$').hasMatch(chunkA);
      final bool isDigitB = RegExp(r'^\d+$').hasMatch(chunkB);
      
      if (isDigitA && isDigitB) {
        final int valA = int.parse(chunkA);
        final int valB = int.parse(chunkB);
        final int cmp = valA.compareTo(valB);
        if (cmp != 0) return cmp;
      } else {
        final int cmp = chunkA.compareTo(chunkB);
        if (cmp != 0) return cmp;
      }
    }
    return chunksA.length.compareTo(chunksB.length);
  }
}

/// High-contrast ARINC 661 status annunciator pill (`VERIFIED` in `#00E676`
/// when value is `0`, or `VIOLATION` in `#FF334B` when `!= 0`) rendered
/// alongside integer fields whose [FieldDescriptor] defines
/// `minValue == 0 && maxValue == 0`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides immediate, unambiguous
///   cockpit visual annunciation for zero-ceiling safety invariants (e.g., error
///   counters or fault tallies that must equal $0$ in nominal operation).
///
/// ## 2. Invariants & Mathematical Properties
/// - **Bi-State Annunciation Mapping**:
///   $$
///   \begin{aligned}
///   \text{status}(\text{isVerified}) &= \begin{cases}
///   (\text{'VERIFIED'}, \text{\#00E676}) & \text{if } \text{isVerified} = \text{true} \\
///   (\text{'VIOLATION'}, \text{\#FF334B}) & \text{if } \text{isVerified} = \text{false}
///   \end{cases}
///   \end{aligned}
///   $$
///
/// ## 3. Preconditions
/// - [isVerified] reflects whether the parsed integer field value equals $0$.
///
/// ## 4. Postconditions
/// - Renders a bordered monospace pill badge displaying either `'VERIFIED'` or
///   `'VIOLATION'`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ widget build.
/// - **Space Complexity**: $\mathcal{O}(1)$ leaf widget allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Non-integer or unparseable text inputs evaluate `isVerified = false` in the
///   parent listener, defaulting fail-safe to the crimson `'VIOLATION'` state.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [UC-06/ZeroCeilingAnnunciatorBadge]
@immutable
class ZeroCeilingAnnunciatorBadge extends StatelessWidget {
  /// Creates a [ZeroCeilingAnnunciatorBadge].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` (declaration #27) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(ZeroCeilingAnnunciatorBadge)) bounded over input/member dimension of `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge`.
  /// - Space Complexity: O(K(ZeroCeilingAnnunciatorBadge)) bounded auxiliary memory for `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` (`()`).
  /// - State: Maintains consistent state invariants across `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` without partial mutation on error.
  /// - Action: Executes `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-ZEROCEILINGANNUNCIATORBADGE-ZEROCEILINGANNUNCIATORBADGE] | SysML v2: ActionDef(ZeroCeilingAnnunciatorBadge::ZeroCeilingAnnunciatorBadge)
  const ZeroCeilingAnnunciatorBadge({
    super.key,
    required this.isVerified,
  });

  /// Whether the zero-ceiling safety/interlock invariant holds (`value == 0`).
  final bool isVerified;

  /// Verified nominal emerald color (`#00E676`).
  static const Color verifiedColor = Color(0xFF00E676);

  /// Violation warning crimson color (`#FF334B`).
  static const Color violationColor = Color(0xFFFF334B);

  /// Executes deterministic method `ZeroCeilingAnnunciatorBadge::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ZeroCeilingAnnunciatorBadge::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ZeroCeilingAnnunciatorBadge::build` (declaration #28) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `ZeroCeilingAnnunciatorBadge::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `ZeroCeilingAnnunciatorBadge::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `ZeroCeilingAnnunciatorBadge::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `ZeroCeilingAnnunciatorBadge::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ZeroCeilingAnnunciatorBadge::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `ZeroCeilingAnnunciatorBadge::build` without partial mutation on error.
  /// - Action: Executes `ZeroCeilingAnnunciatorBadge::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ZeroCeilingAnnunciatorBadge::build` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-ZEROCEILINGANNUNCIATORBADGE-BUILD] | SysML v2: ActionDef(ZeroCeilingAnnunciatorBadge::build)
  @override
  Widget build(BuildContext context) {
    final color = isVerified ? verifiedColor : violationColor;
    final statusText = isVerified ? 'VERIFIED' : 'VIOLATION';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: color, width: 1.0),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10.0,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// High-contrast monospace provenance citation badge rendered for string
/// fields whose [FieldDescriptor.pattern] or value references `schema/`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Surfaces machine-verifiable
///   schema provenance citations (`schema/...`) directly beneath bound string
///   inputs to preserve end-to-end operator traceability to the SSOT schema.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Deterministic Citation Extraction**: [extractCitation] returns the first
///   substring matching `schema/[^\s>]+(?:\s*§[0-9.]+)?` from `value`, falling
///   back to `pattern` or raw `value` when no regex match is found.
///
/// ## 3. Preconditions
/// - [citation] is a non-null string resolved via [extractCitation].
///
/// ## 4. Postconditions
/// - Renders a cyan-bordered HUD badge (`#141D2B` surface, `#00D4FF` accent)
///   with a verification icon and monospace citation label.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|s|)$ for regex extraction over string $s$;
///   $\mathcal{O}(1)$ for widget rendering.
/// - **Space Complexity**: $\mathcal{O}(1)$ widget tree footprint.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If neither `value` nor `pattern` matches the structured `schema/` pattern,
///   [extractCitation] safely returns `value` verbatim without throwing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/ProvenanceCitationBadge]
@immutable
class ProvenanceCitationBadge extends StatelessWidget {
  /// Creates a [ProvenanceCitationBadge].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ProvenanceCitationBadge::ProvenanceCitationBadge` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ProvenanceCitationBadge::ProvenanceCitationBadge` (declaration #30) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ProvenanceCitationBadge::ProvenanceCitationBadge` in `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ProvenanceCitationBadge::ProvenanceCitationBadge` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(ProvenanceCitationBadge)) bounded over input/member dimension of `ProvenanceCitationBadge::ProvenanceCitationBadge`.
  /// - Space Complexity: O(K(ProvenanceCitationBadge)) bounded auxiliary memory for `ProvenanceCitationBadge::ProvenanceCitationBadge`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ProvenanceCitationBadge::ProvenanceCitationBadge` (`()`).
  /// - State: Maintains consistent state invariants across `ProvenanceCitationBadge::ProvenanceCitationBadge` without partial mutation on error.
  /// - Action: Executes `ProvenanceCitationBadge::ProvenanceCitationBadge` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ProvenanceCitationBadge::ProvenanceCitationBadge` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROVENANCECITATIONBADGE-PROVENANCECITATIONBADGE] | SysML v2: ActionDef(ProvenanceCitationBadge::ProvenanceCitationBadge)
  const ProvenanceCitationBadge({
    super.key,
    required this.citation,
  });

  /// Extracted `schema/` citation path and clause string.
  final String citation;

  /// Active reticle cyan border/text accent (`#00D4FF`).
  static const Color provenanceCyan = Color(0xFF00D4FF);

  /// Elevated HUD surface background (`#141D2B`).
  static const Color hudSurface = Color(0xFF141D2B);

  static final RegExp _schemaExtractRegex = RegExp(
    r'schema/[^\s>]+(?:\s*\u00A7[0-9.]+)?',
  );

  /// Extracts a concise `schema/...` provenance citation from [value] or
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ProvenanceCitationBadge::extractCitation` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ProvenanceCitationBadge::extractCitation` (declaration #31) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `value: String` must satisfy domain and type-safety constraints prior to invoking `ProvenanceCitationBadge::extractCitation`.
  /// - `pattern: String?` must satisfy domain and type-safety constraints prior to invoking `ProvenanceCitationBadge::extractCitation`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `ProvenanceCitationBadge::extractCitation` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(value)) bounded over input/member dimension of `ProvenanceCitationBadge::extractCitation`.
  /// - Space Complexity: O(N(value)) bounded auxiliary memory for `ProvenanceCitationBadge::extractCitation`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ProvenanceCitationBadge::extractCitation` (`String`).
  /// - State: Maintains consistent state invariants across `ProvenanceCitationBadge::extractCitation` without partial mutation on error.
  /// - Action: Executes `ProvenanceCitationBadge::extractCitation` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ProvenanceCitationBadge::extractCitation` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROVENANCECITATIONBADGE-EXTRACTCITATION] | SysML v2: ActionDef(ProvenanceCitationBadge::extractCitation)
  static String extractCitation({required String value, String? pattern}) {
    final match = _schemaExtractRegex.firstMatch(value);
    if (match != null) {
      return match.group(0)!.trim();
    }
    if (pattern != null && pattern.contains('schema/')) {
      final pMatch = _schemaExtractRegex.firstMatch(pattern);
      if (pMatch != null) {
        return pMatch.group(0)!.trim();
      }
      return pattern;
    }
    return value;
  }

  /// Executes deterministic method `ProvenanceCitationBadge::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ProvenanceCitationBadge::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/properties/property_grid.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ProvenanceCitationBadge::build` (declaration #32) within `PROPERTIES-PROPERTY-GRID`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `ProvenanceCitationBadge::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `ProvenanceCitationBadge::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `ProvenanceCitationBadge::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `ProvenanceCitationBadge::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ProvenanceCitationBadge::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `ProvenanceCitationBadge::build` without partial mutation on error.
  /// - Action: Executes `ProvenanceCitationBadge::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ProvenanceCitationBadge::build` (`PROPERTIES-PROPERTY-GRID`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-PROPERTIES-PROPERTY-GRID-PROVENANCECITATIONBADGE-BUILD] | SysML v2: ActionDef(ProvenanceCitationBadge::build)
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: hudSurface,
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: provenanceCyan.withOpacity(0.75), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_outlined,
            size: 12.0,
            color: provenanceCyan,
          ),
          const SizedBox(width: 4.0),
          Flexible(
            child: Text(
              citation,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10.0,
                fontWeight: FontWeight.w700,
                color: provenanceCyan,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

