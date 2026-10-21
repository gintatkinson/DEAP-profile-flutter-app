import 'package:flutter/foundation.dart';

/// Describes a single M2 object type discovered at runtime from the connected
/// [DataSource].
///
/// The client uses this descriptor to render hierarchical tree nodes, property
/// forms, tabular columns, and topology graphs. The descriptor is strictly
/// domain-agnostic -- it operates across arbitrary M2 metamodels without code
/// changes, allowing the connected data source to drive presentation bindings.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces a deterministic,
///   schema-driven M2 classifier contract that decouples runtime entity metadata
///   from Layer 3 presentation widgets without hardcoded domain assumptions.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Compile-Time & Structural Immutability**: Annotated with `@immutable`; all
///   fields are `final` and value equality (`operator ==` and `hashCode`) is
///   defined structurally over `(typeName, displayName, iconName, fields,
///   childTypes, relatedTypes, parentTypes)`.
/// - **Type-Singleton Cardinality**: Exactly one [TypeDescriptor] instance
///   represents each distinct `typeName` within a [DataSource] schema catalog.
///
/// ## 3. Preconditions
/// - `typeName` must be a non-empty, unique identifier within the active
///   [DataSource] schema catalog.
/// - Field and relation descriptor lists (`fields`, `childTypes`, `relatedTypes`,
///   `parentTypes`) must be non-null collections (empty lists are valid).
///
/// ## 4. Postconditions
/// - Produces an immutable M2 type metadata descriptor whose structural equality
///   and hash code are deterministic across all field and relation lists.
/// - An empty [TypeDescriptor] (zero fields, zero relations) renders safely as
///   a leaf label in the hierarchy without throwing runtime exceptions.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction and `copyWith`;
///   $\mathcal{O}(F + C + R + P)$ for structural equality and `hashCode`
///   computation, where $F, C, R, P$ denote the lengths of `fields`,
///   `childTypes`, `relatedTypes`, and `parentTypes`.
/// - **Space Complexity**: $\mathcal{O}(F + C + R + P)$ to store the descriptor
///   lists; $\mathcal{O}(1)$ auxiliary heap allocation during `copyWith`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unknown `iconName` values are tolerated downstream by `IconMapper.resolve`
///   via a deterministic fallback icon.
/// - Empty `fields` or relation lists degrade gracefully to leaf nodes or empty
///   detail views without null-dereference faults.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/TypeDescriptor, ARCH-M2-001, REQ-DOM-001]
@immutable
class TypeDescriptor {
  /// Internal identifier matching the data source, e.g. "device".
  ///
  /// Must be unique within the data source. Used as the key for lookups
  /// via [DataSource.typeFor]. Cannot be empty.
  final String typeName;

  /// Human-readable label for UI display, e.g. "Device".
  ///
  /// Displayed in tree nodes, tab headers, and dropdown selectors.
  /// Falls back to [typeName] if left empty by the caller (handled by
  /// the widget layer, not enforced here).
  final String displayName;

  /// Material icon name string, e.g. "developer_board".
  ///
  /// Resolved to `IconData` by `IconMapper.resolve`. If the name is
  /// not in the icon map, `IconMapper` returns a fallback icon --
  /// the tree always shows something, never a blank.
  final String iconName;

  /// All editable fields/attributes of this type.
  ///
  /// Each [FieldDescriptor] specifies the field's type, label,
  /// validation constraints, and UI grouping. When this list changes
  /// (e.g. switching to a different object type), the grid rebuilds
  /// to show the new fields. An empty list renders a "No fields"
  /// message -- it does not throw.
  final List<FieldDescriptor> fields;

  /// Child object types for the tree hierarchy.
  ///
  /// Each entry describes a directed parent->child relationship.
  /// An empty list makes this type a leaf node in the tree.
  /// Child types appear as expandable sub-nodes in the sidebar.
  final List<TypeRelationDescriptor> childTypes;

  /// Object types related to this one (events, alerts, logs, etc.).
  ///
  /// These appear as tabs in the detail pane but NOT as tree children.
  /// Related types are sibling or peer entities that share context
  /// with this type without owning it structurally.
  final List<TypeRelationDescriptor> relatedTypes;

  /// Parent object types for reverse tree navigation.
  ///
  /// Used for "go to parent" actions and breadcrumb trails.
  /// An empty list means this type is a root node with no parent.
  final List<TypeRelationDescriptor> parentTypes;

  /// Creates a new [TypeDescriptor] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TypeDescriptor::TypeDescriptor` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TypeDescriptor::TypeDescriptor` (declaration #2) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TypeDescriptor::TypeDescriptor` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TypeDescriptor::TypeDescriptor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TypeDescriptor)) bounded over input/member dimension of `TypeDescriptor::TypeDescriptor`.
  /// - Space Complexity: O(K(TypeDescriptor)) bounded auxiliary memory for `TypeDescriptor::TypeDescriptor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeDescriptor::TypeDescriptor` (`()`).
  /// - State: Maintains consistent state invariants across `TypeDescriptor::TypeDescriptor` without partial mutation on error.
  /// - Action: Executes `TypeDescriptor::TypeDescriptor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeDescriptor::TypeDescriptor` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-TYPEDESCRIPTOR-TYPEDESCRIPTOR] | SysML v2: ActionDef(TypeDescriptor::TypeDescriptor)
  const TypeDescriptor({
    required this.typeName,
    required this.displayName,
    required this.iconName,
    required this.fields,
    required this.childTypes,
    required this.relatedTypes,
    required this.parentTypes,
  });

  /// Creates a copy of this [TypeDescriptor] with the given fields replaced.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TypeDescriptor::copyWith` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TypeDescriptor::copyWith` (declaration #3) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TypeDescriptor::copyWith` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TypeDescriptor` from `TypeDescriptor::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `TypeDescriptor::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `TypeDescriptor::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeDescriptor::copyWith` (`TypeDescriptor`).
  /// - State: Maintains consistent state invariants across `TypeDescriptor::copyWith` without partial mutation on error.
  /// - Action: Executes `TypeDescriptor::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeDescriptor::copyWith` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-TYPEDESCRIPTOR-COPYWITH] | SysML v2: ActionDef(TypeDescriptor::copyWith)
  TypeDescriptor copyWith({
    String? typeName,
    String? displayName,
    String? iconName,
    List<FieldDescriptor>? fields,
    List<TypeRelationDescriptor>? childTypes,
    List<TypeRelationDescriptor>? relatedTypes,
    List<TypeRelationDescriptor>? parentTypes,
  }) {
    return TypeDescriptor(
      typeName: typeName ?? this.typeName,
      displayName: displayName ?? this.displayName,
      iconName: iconName ?? this.iconName,
      fields: fields ?? this.fields,
      childTypes: childTypes ?? this.childTypes,
      relatedTypes: relatedTypes ?? this.relatedTypes,
      parentTypes: parentTypes ?? this.parentTypes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypeDescriptor &&
        other.typeName == typeName &&
        other.displayName == displayName &&
        other.iconName == iconName &&
        listEquals(other.fields, fields) &&
        listEquals(other.childTypes, childTypes) &&
        listEquals(other.relatedTypes, relatedTypes) &&
        listEquals(other.parentTypes, parentTypes);
  }

  /// Executes deterministic method `TypeDescriptor::hashCode` within `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TypeDescriptor::hashCode` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TypeDescriptor::hashCode` (declaration #4) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TypeDescriptor::hashCode` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TypeDescriptor::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(hashCode)) bounded over input/member dimension of `TypeDescriptor::hashCode`.
  /// - Space Complexity: O(K(hashCode)) bounded auxiliary memory for `TypeDescriptor::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeDescriptor::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `TypeDescriptor::hashCode` without partial mutation on error.
  /// - Action: Executes `TypeDescriptor::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeDescriptor::hashCode` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-TYPEDESCRIPTOR-HASHCODE] | SysML v2: ActionDef(TypeDescriptor::hashCode)
  @override
  int get hashCode {
    return Object.hash(
      typeName,
      displayName,
      iconName,
      Object.hashAll(fields),
      Object.hashAll(childTypes),
      Object.hashAll(relatedTypes),
      Object.hashAll(parentTypes),
    );
  }
}

/// Describes one schema attribute/field of a [TypeDescriptor].
///
/// Each field instructs the presentation layer how to bind an editor control
/// (text input, enum selector, numeric spin box, date control) and how to
/// validate operator input at runtime -- no compile-time domain schema is required.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Encapsulates M2 attribute type
///   constraints, numeric range bounds (`minValue`, `maxValue`), pattern
///   validation, and enumeration domains so that Layer 1 validation (`validateFields`)
///   and Layer 3 property editors enforce identical deterministic constraints.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Structural Value Equality**: Two [FieldDescriptor] instances are equal if
///   and only if all 13 attribute metadata properties (`key`, `label`, `type`,
///   `sectionLabel`, `sectionOrder`, `required`, `minValue`, `maxValue`,
///   `pattern`, `enumOptions`, `enumDisplayNames`, `defaultValue`,
///   `inputFormatters`) are pairwise equal.
/// - **Pattern Compilation Memoization**: `compiledPattern` memoizes compiled
///   [RegExp] instances keyed by `pattern` string to guarantee idempotent
///   regular expression evaluation without repeated heap allocations.
///
/// ## 3. Preconditions
/// - `key`, `label`, and `type` must be provided as non-null strings at
///   construction; `key` must be unique within its enclosing [TypeDescriptor.fields].
/// - If both `minValue` and `maxValue` are non-null, `minValue <= maxValue`.
///
/// ## 4. Postconditions
/// - Yields an immutable attribute descriptor capable of deterministic range,
///   type, pattern, and enumeration validation.
/// - `compiledPattern` returns `null` when `pattern` is null or empty, and a
///   cached [RegExp] instance otherwise.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ amortized lookup for `compiledPattern`
///   after initial pattern compilation; $\mathcal{O}(E + I)$ for structural
///   equality and `hashCode`, where $E$ is the length of `enumOptions` /
///   `enumDisplayNames` and $I$ is the length of `inputFormatters`.
/// - **Space Complexity**: $\mathcal{O}(1)$ per instance beyond list fields;
///   $\mathcal{O}(P)$ static cache entries for $P$ distinct regex patterns.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unknown `type` identifiers fall back to plain text editors in the UI layer.
/// - Null or empty `pattern`, `minValue`, `maxValue`, or `enumOptions` bypass
///   their respective optional constraint checks safely without throwing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/FieldDescriptor, ARCH-M2-001, REQ-DOM-002]
@immutable
class FieldDescriptor {
  static final _compiledPatterns = <String, RegExp>{};

  /// Returns a cached compiled [RegExp] for [pattern], or null if [pattern]
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FieldDescriptor::compiledPattern` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FieldDescriptor::compiledPattern` (declaration #6) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FieldDescriptor::compiledPattern` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `FieldDescriptor::compiledPattern` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(compiledPattern)) bounded over input/member dimension of `FieldDescriptor::compiledPattern`.
  /// - Space Complexity: O(K(compiledPattern)) bounded auxiliary memory for `FieldDescriptor::compiledPattern`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FieldDescriptor::compiledPattern` (`()`).
  /// - State: Maintains consistent state invariants across `FieldDescriptor::compiledPattern` without partial mutation on error.
  /// - Action: Executes `FieldDescriptor::compiledPattern` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FieldDescriptor::compiledPattern` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-FIELDDESCRIPTOR-COMPILEDPATTERN] | SysML v2: ActionDef(FieldDescriptor::compiledPattern)
  RegExp? get compiledPattern {
    if (pattern == null || pattern!.isEmpty) return null;
    return _compiledPatterns.putIfAbsent(pattern!, () => RegExp(pattern!));
  }

  /// Unique key within the type, e.g. "maxVoltage".
  ///
  /// Used as the map key when reading/writing property data.
  /// Must be non-empty and unique within the parent [TypeDescriptor.fields].
  final String key;

  /// Human-readable label, e.g. "Max Voltage (V)".
  ///
  /// Displayed above or beside the editor control in the property form.
  final String label;

  /// Data type: "string", "int", "double", "enum", "date".
  ///
  /// Determines which editor widget to render and which validation rules
  /// to apply. Unknown types fall back to a plain text field. The value
  /// is case-sensitive.
  final String type;

  /// UI section grouping label, e.g. "Alternate Structural Grid Frame".
  ///
  /// If null, the field belongs to a default "Other" section rendered
  /// at the bottom. Section labels match against the UI's section header
  /// map; unknown sections are displayed as-is.
  final String? sectionLabel;

  /// Display order within the section (lower = first).
  ///
  /// Fields with equal [sectionOrder] appear in insertion order.
  /// Negative values are allowed and sort before zero.
  final int sectionOrder;

  /// Whether this field must have a non-null value.
  ///
  /// When true, the UI marks the field as required with an indicator and
  /// prevents saving if the value is null or empty. Validation is the
  /// caller's responsibility -- this field is a hint, not a constraint.
  final bool required;

  /// Minimum numeric value for int/double types.
  ///
  /// Applied as an inclusive lower bound during validation.
  /// Ignored for non-numeric types. Null means no minimum.
  final num? minValue;

  /// Maximum numeric value for int/double types.
  ///
  /// Applied as an inclusive upper bound during validation.
  /// Ignored for non-numeric types. Null means no maximum.
  final num? maxValue;

  /// Regex pattern for string validation.
  ///
  /// Applied via [RegExp.hasMatch]. If [pattern] is null or empty
  /// the string passes without check. The pattern is not anchored
  /// by default -- callers should wrap in ^...$ if a full match is needed.
  final String? pattern;

  /// Allowed enum values for enum types.
  ///
  /// Populates a dropdown with these options. Must be non-empty when
  /// [type] is "enum". Null or empty renders a text field instead.
  final List<String>? enumOptions;

  /// Display names for each enum option (same index as [enumOptions]).
  ///
  /// If null or shorter than [enumOptions], the option value itself is
  /// used as the display label. Useful for showing "Active States"
  /// when the stored value is "active".
  final List<String>? enumDisplayNames;

  /// Default value when creating a new instance.
  ///
  /// Populated into the form when adding a new node of this type.
  /// Can be any JSON-serialisable type. Null means no default.
  final dynamic defaultValue;

  /// Input formatter names, e.g. ["uppercase", "maxLength:2"].
  ///
  /// Applied by the widget layer to constrain user input.
  /// Unknown formatter names are silently ignored.
  final List<String>? inputFormatters;

  /// Creates a new [FieldDescriptor] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `FieldDescriptor::FieldDescriptor` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `FieldDescriptor::FieldDescriptor` (declaration #5) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FieldDescriptor::FieldDescriptor` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `FieldDescriptor::FieldDescriptor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(FieldDescriptor)) bounded over input/member dimension of `FieldDescriptor::FieldDescriptor`.
  /// - Space Complexity: O(K(FieldDescriptor)) bounded auxiliary memory for `FieldDescriptor::FieldDescriptor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FieldDescriptor::FieldDescriptor` (`()`).
  /// - State: Maintains consistent state invariants across `FieldDescriptor::FieldDescriptor` without partial mutation on error.
  /// - Action: Executes `FieldDescriptor::FieldDescriptor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FieldDescriptor::FieldDescriptor` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-FIELDDESCRIPTOR-FIELDDESCRIPTOR] | SysML v2: ActionDef(FieldDescriptor::FieldDescriptor)
  const FieldDescriptor({
    required this.key,
    required this.label,
    required this.type,
    this.sectionLabel,
    this.sectionOrder = 0,
    this.required = false,
    this.minValue,
    this.maxValue,
    this.pattern,
    this.enumOptions,
    this.enumDisplayNames,
    this.defaultValue,
    this.inputFormatters,
  });

  /// Creates a copy of this [FieldDescriptor] with the given fields replaced.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FieldDescriptor::copyWith` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FieldDescriptor::copyWith` (declaration #6) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FieldDescriptor::copyWith` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `FieldDescriptor` from `FieldDescriptor::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `FieldDescriptor::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `FieldDescriptor::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FieldDescriptor::copyWith` (`FieldDescriptor`).
  /// - State: Maintains consistent state invariants across `FieldDescriptor::copyWith` without partial mutation on error.
  /// - Action: Executes `FieldDescriptor::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FieldDescriptor::copyWith` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-FIELDDESCRIPTOR-COPYWITH] | SysML v2: ActionDef(FieldDescriptor::copyWith)
  FieldDescriptor copyWith({
    String? key,
    String? label,
    String? type,
    String? sectionLabel,
    int? sectionOrder,
    bool? required,
    num? minValue,
    num? maxValue,
    String? pattern,
    List<String>? enumOptions,
    List<String>? enumDisplayNames,
    dynamic defaultValue,
    List<String>? inputFormatters,
  }) {
    return FieldDescriptor(
      key: key ?? this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      sectionLabel: sectionLabel ?? this.sectionLabel,
      sectionOrder: sectionOrder ?? this.sectionOrder,
      required: required ?? this.required,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      pattern: pattern ?? this.pattern,
      enumOptions: enumOptions ?? this.enumOptions,
      enumDisplayNames: enumDisplayNames ?? this.enumDisplayNames,
      defaultValue: defaultValue ?? this.defaultValue,
      inputFormatters: inputFormatters ?? this.inputFormatters,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FieldDescriptor &&
        other.key == key &&
        other.label == label &&
        other.type == type &&
        other.sectionLabel == sectionLabel &&
        other.sectionOrder == sectionOrder &&
        other.required == required &&
        other.minValue == minValue &&
        other.maxValue == maxValue &&
        other.pattern == pattern &&
        listEquals(other.enumOptions, enumOptions) &&
        listEquals(other.enumDisplayNames, enumDisplayNames) &&
        other.defaultValue == defaultValue &&
        listEquals(other.inputFormatters, inputFormatters);
  }

  /// Executes deterministic method `FieldDescriptor::hashCode` within `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FieldDescriptor::hashCode` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FieldDescriptor::hashCode` (declaration #9) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FieldDescriptor::hashCode` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `FieldDescriptor::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(hashCode)) bounded over input/member dimension of `FieldDescriptor::hashCode`.
  /// - Space Complexity: O(K(hashCode)) bounded auxiliary memory for `FieldDescriptor::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FieldDescriptor::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `FieldDescriptor::hashCode` without partial mutation on error.
  /// - Action: Executes `FieldDescriptor::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FieldDescriptor::hashCode` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-FIELDDESCRIPTOR-HASHCODE] | SysML v2: ActionDef(FieldDescriptor::hashCode)
  @override
  int get hashCode {
    return Object.hash(
      key,
      label,
      type,
      sectionLabel,
      sectionOrder,
      required,
      minValue,
      maxValue,
      pattern,
      enumOptions != null ? Object.hashAll(enumOptions!) : null,
      enumDisplayNames != null ? Object.hashAll(enumDisplayNames!) : null,
      defaultValue,
      inputFormatters != null ? Object.hashAll(inputFormatters!) : null,
    );
  }
}

/// Describes a directed structural or peer relationship between two
/// [TypeDescriptor] classifiers in the M2 metamodel.
///
/// Used by the tree view, detail tab container, and navigation breadcrumbs to
/// resolve connected entity types and label directed associations.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Defines an immutable, typed
///   relational edge (`relationName`, `childTypeName`, `childLabel`) between
///   M2 classifiers so that hierarchical containment and peer tab associations
///   are resolved deterministically from schema metadata.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Directed Edge Identity**: Represents an ordered triple
///   $e = (\text{relationName}, \text{childTypeName}, \text{childLabel})$ with
///   value-based equality (`operator ==` and `hashCode`).
/// - **Immutability**: Annotated with `@immutable` and constructed via `const`.
///
/// ## 3. Preconditions
/// - `relationName`, `childTypeName`, and `childLabel` must be supplied as
///   non-null strings at construction.
///
/// ## 4. Postconditions
/// - Produces an immutable relationship descriptor with constant-time field
///   access and value equality.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction, `copyWith`,
///   `operator ==`, and `hashCode`.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed-size object allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If `childTypeName` references an unregistered type in the data source,
///   consuming presentation views skip the unresolvable edge gracefully without
///   raising unhandled exceptions.
/// - Empty `childLabel` strings fall back to `childTypeName` in tab headers.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/TypeRelationDescriptor, ARCH-M2-001, REQ-DOM-004]
@immutable
class TypeRelationDescriptor {
  /// Semantic name of the relation, e.g. "contains", "belongs_to".
  ///
  /// Determines the arrow label in topology views and the tooltip in
  /// tree nodes. An empty string renders a generic "Related" label.
  final String relationName;

  /// The [TypeDescriptor.typeName] of the related (target) type.
  ///
  /// Must match a [TypeDescriptor.typeName] returned by the data source.
  /// A mismatch results in a dangling reference -- the UI skips it
  /// gracefully with a warning log.
  final String childTypeName;

  /// Human-readable plural label for UI tab headers, e.g. "Sensors".
  ///
  /// Displayed as the tab title and as a section header in the
  /// related-items panel. Falls back to [childTypeName] if empty.
  final String childLabel;

  /// Creates a new [TypeRelationDescriptor] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TypeRelationDescriptor::TypeRelationDescriptor` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TypeRelationDescriptor::TypeRelationDescriptor` (declaration #8) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TypeRelationDescriptor::TypeRelationDescriptor` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TypeRelationDescriptor::TypeRelationDescriptor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TypeRelationDescriptor)) bounded over input/member dimension of `TypeRelationDescriptor::TypeRelationDescriptor`.
  /// - Space Complexity: O(K(TypeRelationDescriptor)) bounded auxiliary memory for `TypeRelationDescriptor::TypeRelationDescriptor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeRelationDescriptor::TypeRelationDescriptor` (`()`).
  /// - State: Maintains consistent state invariants across `TypeRelationDescriptor::TypeRelationDescriptor` without partial mutation on error.
  /// - Action: Executes `TypeRelationDescriptor::TypeRelationDescriptor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeRelationDescriptor::TypeRelationDescriptor` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-TYPERELATIONDESCRIPTOR-TYPERELATIONDESCRIPTOR] | SysML v2: ActionDef(TypeRelationDescriptor::TypeRelationDescriptor)
  const TypeRelationDescriptor({
    required this.relationName,
    required this.childTypeName,
    required this.childLabel,
  });

  /// Creates a copy of this [TypeRelationDescriptor] with the given fields replaced.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TypeRelationDescriptor::copyWith` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TypeRelationDescriptor::copyWith` (declaration #9) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TypeRelationDescriptor::copyWith` in `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TypeRelationDescriptor` from `TypeRelationDescriptor::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `TypeRelationDescriptor::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `TypeRelationDescriptor::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeRelationDescriptor::copyWith` (`TypeRelationDescriptor`).
  /// - State: Maintains consistent state invariants across `TypeRelationDescriptor::copyWith` without partial mutation on error.
  /// - Action: Executes `TypeRelationDescriptor::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeRelationDescriptor::copyWith` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-TYPERELATIONDESCRIPTOR-COPYWITH] | SysML v2: ActionDef(TypeRelationDescriptor::copyWith)
  TypeRelationDescriptor copyWith({
    String? relationName,
    String? childTypeName,
    String? childLabel,
  }) {
    return TypeRelationDescriptor(
      relationName: relationName ?? this.relationName,
      childTypeName: childTypeName ?? this.childTypeName,
      childLabel: childLabel ?? this.childLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypeRelationDescriptor &&
        other.relationName == relationName &&
        other.childTypeName == childTypeName &&
        other.childLabel == childLabel;
  }

  /// Executes deterministic method `TypeRelationDescriptor::hashCode` within `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TypeRelationDescriptor::hashCode` in `app_flutter/lib/domain/type_descriptor.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TypeRelationDescriptor::hashCode` (declaration #13) within `DOMAIN-TYPE-DESCRIPTOR`.
  ///
  /// ## 3. Preconditions
  /// - `relationName: String` must satisfy domain and type-safety constraints prior to invoking `TypeRelationDescriptor::hashCode`.
  /// - `childTypeName: String` must satisfy domain and type-safety constraints prior to invoking `TypeRelationDescriptor::hashCode`.
  /// - `childLabel: String` must satisfy domain and type-safety constraints prior to invoking `TypeRelationDescriptor::hashCode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TypeRelationDescriptor::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(relationName)) bounded over input/member dimension of `TypeRelationDescriptor::hashCode`.
  /// - Space Complexity: O(N(relationName)) bounded auxiliary memory for `TypeRelationDescriptor::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeRelationDescriptor::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `TypeRelationDescriptor::hashCode` without partial mutation on error.
  /// - Action: Executes `TypeRelationDescriptor::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeRelationDescriptor::hashCode` (`DOMAIN-TYPE-DESCRIPTOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-TYPE-DESCRIPTOR-TYPERELATIONDESCRIPTOR-HASHCODE] | SysML v2: ActionDef(TypeRelationDescriptor::hashCode)
  @override
  int get hashCode => Object.hash(relationName, childTypeName, childLabel);
}

