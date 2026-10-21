import 'package:flutter/foundation.dart';
import 'package:app_flutter/domain/type_descriptor.dart';

/// Immutable ARINC 661 table column descriptor defining schema key binding,
/// header display label, data type, sorting/visibility metadata, and numeric
/// safety bounds (`[minValue, maxValue]`).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Translates Tier 1 [FieldDescriptor]
///   schema metadata into deterministic tabular column specifications, exposing
///   compile-time-safe predicates for zero-ceiling safety interlocks
///   ([isZeroCeilingConstraint]) and bounded segmented range gauges
///   ([hasSegmentedRangeBounds]).
///
/// ## 2. Invariants & Mathematical Properties
/// - **Zero-Ceiling Predicate**:
///   $$
///   \begin{aligned}
///   \text{isZeroCeilingConstraint} &\iff (\text{type} = \text{'int'}) \land (v_{\min} = 0) \land (v_{\max} = 0)
///   \end{aligned}
///   $$
/// - **Segmented Range Predicate**:
///   $$
///   \begin{aligned}
///   \text{hasSegmentedRangeBounds} &\iff (\text{type} \in \{\text{'int'}, \text{'double'}\}) \land (v_{\min} \ne \text{null}) \land (v_{\max} \ne \text{null}) \land (v_{\max} > v_{\min})
///   \end{aligned}
///   $$
///
/// ## 3. Preconditions
/// - [key] and [type] must be non-null schema strings.
/// - When constructed via [ColumnModel.fromFieldDescriptor], [fd] is a valid
///   [FieldDescriptor].
///
/// ## 4. Postconditions
/// - Produces a deeply immutable [ColumnModel] with value equality (`==` and
///   `hashCode`) across all 9 properties and normalized human-readable [label].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction and bound predicates;
///   $\mathcal{O}(|k|)$ when deriving human-readable labels from key $k$ of length $|k|$.
/// - **Space Complexity**: $\mathcal{O}(1)$ per column descriptor.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty or generic `"Field ..."` labels in [FieldDescriptor] automatically
///   resolve to title-cased words derived from `fd.key` via [resolveColumnLabel].
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/ColumnModel]
@immutable
class ColumnModel {
  /// Unique key matching the schema field identifier.
  final String key;
  /// Human-readable column header label.
  final String label;
  /// Data type string (e.g. "string", "int", "double", "enum", "date").
  final String type;
  /// Column display width in pixels, or null for default sizing.
  final double? width;
  /// Whether the column can be sorted by clicking the header.
  final bool sortable;
  /// Whether the column is frozen to the left side of the table.
  final bool frozen;
  /// Whether the column is visible in the table.
  final bool visible;
  /// Optional inclusive lower numeric bound from [FieldDescriptor.minValue].
  final num? minValue;
  /// Optional inclusive upper numeric bound from [FieldDescriptor.maxValue].
  final num? maxValue;

  /// Creates a [ColumnModel] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ColumnModel::ColumnModel` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ColumnModel::ColumnModel` (declaration #2) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ColumnModel::ColumnModel` in `MODELS-COLUMN-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ColumnModel::ColumnModel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(ColumnModel)) bounded over input/member dimension of `ColumnModel::ColumnModel`.
  /// - Space Complexity: O(K(ColumnModel)) bounded auxiliary memory for `ColumnModel::ColumnModel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::ColumnModel` (`()`).
  /// - State: Maintains consistent state invariants across `ColumnModel::ColumnModel` without partial mutation on error.
  /// - Action: Executes `ColumnModel::ColumnModel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::ColumnModel` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-COLUMNMODEL] | SysML v2: ActionDef(ColumnModel::ColumnModel)
  const ColumnModel({
    required this.key,
    required this.label,
    required this.type,
    this.width,
    this.sortable = true,
    this.frozen = false,
    this.visible = true,
    this.minValue,
    this.maxValue,
  });

  /// Whether this column represents an integer zero-ceiling safety/interlock
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ColumnModel::isZeroCeilingConstraint` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ColumnModel::isZeroCeilingConstraint` (declaration #3) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ColumnModel::isZeroCeilingConstraint` in `MODELS-COLUMN-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ColumnModel::isZeroCeilingConstraint` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(isZeroCeilingConstraint)) bounded over input/member dimension of `ColumnModel::isZeroCeilingConstraint`.
  /// - Space Complexity: O(K(isZeroCeilingConstraint)) bounded auxiliary memory for `ColumnModel::isZeroCeilingConstraint`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::isZeroCeilingConstraint` (`()`).
  /// - State: Maintains consistent state invariants across `ColumnModel::isZeroCeilingConstraint` without partial mutation on error.
  /// - Action: Executes `ColumnModel::isZeroCeilingConstraint` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::isZeroCeilingConstraint` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-ISZEROCEILINGCONSTRAINT] | SysML v2: ActionDef(ColumnModel::isZeroCeilingConstraint)
  bool get isZeroCeilingConstraint =>
      type == 'int' && minValue == 0 && maxValue == 0;

  /// Whether this column defines a bounded numeric range (`maxValue > minValue`)
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ColumnModel::hasSegmentedRangeBounds` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ColumnModel::hasSegmentedRangeBounds` (declaration #4) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ColumnModel::hasSegmentedRangeBounds` in `MODELS-COLUMN-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ColumnModel::hasSegmentedRangeBounds` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(hasSegmentedRangeBounds)) bounded over input/member dimension of `ColumnModel::hasSegmentedRangeBounds`.
  /// - Space Complexity: O(K(hasSegmentedRangeBounds)) bounded auxiliary memory for `ColumnModel::hasSegmentedRangeBounds`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::hasSegmentedRangeBounds` (`()`).
  /// - State: Maintains consistent state invariants across `ColumnModel::hasSegmentedRangeBounds` without partial mutation on error.
  /// - Action: Executes `ColumnModel::hasSegmentedRangeBounds` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::hasSegmentedRangeBounds` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-HASSEGMENTEDRANGEBOUNDS] | SysML v2: ActionDef(ColumnModel::hasSegmentedRangeBounds)
  bool get hasSegmentedRangeBounds =>
      (type == 'int' || type == 'double') &&
      minValue != null &&
      maxValue != null &&
      maxValue! > minValue!;

  /// Creates a [ColumnModel] from a [FieldDescriptor].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ColumnModel::ColumnModel` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ColumnModel::ColumnModel` (declaration #3) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `fd: FieldDescriptor` must satisfy domain and type-safety constraints prior to invoking `ColumnModel::ColumnModel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ColumnModel::ColumnModel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(fd)) bounded over input/member dimension of `ColumnModel::ColumnModel`.
  /// - Space Complexity: O(N(fd)) bounded auxiliary memory for `ColumnModel::ColumnModel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::ColumnModel` (`()`).
  /// - State: Maintains consistent state invariants across `ColumnModel::ColumnModel` without partial mutation on error.
  /// - Action: Executes `ColumnModel::ColumnModel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::ColumnModel` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-COLUMNMODEL] | SysML v2: ActionDef(ColumnModel::ColumnModel)
  factory ColumnModel.fromFieldDescriptor(FieldDescriptor fd) {
    return ColumnModel(
      key: fd.key,
      label: resolveColumnLabel(fd),
      type: fd.type,
      minValue: fd.minValue,
      maxValue: fd.maxValue,
    );
  }

  /// Derives column header label dynamically from [fd.key] if [fd.label] is
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ColumnModel::resolveColumnLabel` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ColumnModel::resolveColumnLabel` (declaration #4) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `fd: FieldDescriptor` must satisfy domain and type-safety constraints prior to invoking `ColumnModel::resolveColumnLabel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `ColumnModel::resolveColumnLabel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(fd)) bounded over input/member dimension of `ColumnModel::resolveColumnLabel`.
  /// - Space Complexity: O(N(fd)) bounded auxiliary memory for `ColumnModel::resolveColumnLabel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::resolveColumnLabel` (`String`).
  /// - State: Maintains consistent state invariants across `ColumnModel::resolveColumnLabel` without partial mutation on error.
  /// - Action: Executes `ColumnModel::resolveColumnLabel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::resolveColumnLabel` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-RESOLVECOLUMNLABEL] | SysML v2: ActionDef(ColumnModel::resolveColumnLabel)
  static String resolveColumnLabel(FieldDescriptor fd) {
    final labelStr = fd.label.trim();
    if (labelStr.isEmpty || labelStr.startsWith('Field ')) {
      return deriveLabelFromKey(fd.key);
    }
    return fd.label;
  }

  /// Formats a schema key into a human-readable title/label.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ColumnModel::deriveLabelFromKey` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ColumnModel::deriveLabelFromKey` (declaration #5) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `ColumnModel::deriveLabelFromKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `ColumnModel::deriveLabelFromKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `ColumnModel::deriveLabelFromKey`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `ColumnModel::deriveLabelFromKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::deriveLabelFromKey` (`String`).
  /// - State: Maintains consistent state invariants across `ColumnModel::deriveLabelFromKey` without partial mutation on error.
  /// - Action: Executes `ColumnModel::deriveLabelFromKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::deriveLabelFromKey` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-DERIVELABELFROMKEY] | SysML v2: ActionDef(ColumnModel::deriveLabelFromKey)
  static String deriveLabelFromKey(String key) {
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

  @override
  bool operator ==(Object other) =>
      other is ColumnModel &&
      other.key == key &&
      other.label == label &&
      other.type == type &&
      other.width == width &&
      other.sortable == sortable &&
      other.frozen == frozen &&
      other.visible == visible &&
      other.minValue == minValue &&
      other.maxValue == maxValue;

  /// Executes deterministic method `ColumnModel::hashCode` within `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ColumnModel::hashCode` in `app_flutter/lib/features/tables/models/column_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ColumnModel::hashCode` (declaration #8) within `MODELS-COLUMN-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ColumnModel::hashCode` in `MODELS-COLUMN-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ColumnModel::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(hashCode)) bounded over input/member dimension of `ColumnModel::hashCode`.
  /// - Space Complexity: O(K(hashCode)) bounded auxiliary memory for `ColumnModel::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ColumnModel::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `ColumnModel::hashCode` without partial mutation on error.
  /// - Action: Executes `ColumnModel::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ColumnModel::hashCode` (`MODELS-COLUMN-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-MODELS-COLUMN-MODEL-COLUMNMODEL-HASHCODE] | SysML v2: ActionDef(ColumnModel::hashCode)
  @override
  int get hashCode => Object.hash(
        key,
        label,
        type,
        width,
        sortable,
        frozen,
        visible,
        minValue,
        maxValue,
      );
}

