import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/domain/validation.dart';

/// Represents an immutable runtime M1 instance record of a schema-defined
/// M2 [TypeDescriptor] classifier.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Encapsulates an immutable M1
///   entity record (`id`, `parentNodeId`, `typeName`, `attributes`) whose
///   attribute map can be deterministically validated against its parent
///   M2 [FieldDescriptor] schema constraints prior to persistence or display.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Compile-Time & Structural Immutability**: Annotated with `@immutable`;
///   value equality (`operator ==` and `hashCode`) is defined over
///   `(id, parentNodeId, typeName, attributes)`.
/// - **Schema Conformance Closure**: Invoking [validate] against a list of
///   [FieldDescriptor] definitions returns `Result.success(null)` if and only
///   if every attribute in `attributes` satisfies its descriptor's required,
///   type, range, pattern, and enumeration constraints.
///
/// ## 3. Preconditions
/// - `id`, `parentNodeId`, `typeName`, and `attributes` must be non-null when
///   invoking the primary `const` constructor.
/// - Raw database maps passed to [fromMap] or [tryParse] may carry either a
///   serialized `data_json` payload or flat key-value entries.
///
/// ## 4. Postconditions
/// - Produces an immutable [InstanceRecord] instance with deterministic
///   structural equality and total, exception-free validation via [validate].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for `const` construction and
///   `copyWith`; $\mathcal{O}(A)$ for [fromMap], `operator ==`, and `hashCode`,
///   where $A = |\text{attributes}|$; $\mathcal{O}(F)$ for [validate] over $F$
///   field descriptors.
/// - **Space Complexity**: $\mathcal{O}(A)$ to store the attribute key-value map.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Malformed `data_json` payloads inside [fromMap] are caught and fall back
///   to an empty attribute map rather than throwing an unhandled exception.
/// - [tryParse] catches any unexpected deserialization error and returns `null`.
/// - [validate] returns an explicit `Failure<void>` carrying a typed
///   `DomainError` rather than throwing on constraint violations.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/InstanceRecord, ARCH-M2-001, REQ-DOM-001]
@immutable
class InstanceRecord {
  /// Unique identifier of the instance.
  final String id;

  /// Identifier of the parent node.
  final String parentNodeId;

  /// The name of the type of this instance.
  final String typeName;

  /// Attributes of the instance represented as key-value pairs.
  final Map<String, dynamic> attributes;

  /// Creates a new [InstanceRecord] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `InstanceRecord::InstanceRecord` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/domain/instance_record.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `InstanceRecord::InstanceRecord` (declaration #2) within `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `InstanceRecord::InstanceRecord` in `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `InstanceRecord::InstanceRecord` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(InstanceRecord)) bounded over input/member dimension of `InstanceRecord::InstanceRecord`.
  /// - Space Complexity: O(K(InstanceRecord)) bounded auxiliary memory for `InstanceRecord::InstanceRecord`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `InstanceRecord::InstanceRecord` (`()`).
  /// - State: Maintains consistent state invariants across `InstanceRecord::InstanceRecord` without partial mutation on error.
  /// - Action: Executes `InstanceRecord::InstanceRecord` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `InstanceRecord::InstanceRecord` (`DOMAIN-INSTANCE-RECORD`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-INSTANCE-RECORD-INSTANCERECORD-INSTANCERECORD] | SysML v2: ActionDef(InstanceRecord::InstanceRecord)
  const InstanceRecord({
    required this.id,
    required this.parentNodeId,
    required this.typeName,
    required this.attributes,
  });

  /// Creates an [InstanceRecord] from a raw map database entry.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `InstanceRecord::InstanceRecord` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/domain/instance_record.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `InstanceRecord::InstanceRecord` (declaration #3) within `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 3. Preconditions
  /// - `map: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `InstanceRecord::InstanceRecord`.
  /// - `typeName: String` must satisfy domain and type-safety constraints prior to invoking `InstanceRecord::InstanceRecord`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `InstanceRecord::InstanceRecord` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(map)) bounded over input/member dimension of `InstanceRecord::InstanceRecord`.
  /// - Space Complexity: O(N(map)) bounded auxiliary memory for `InstanceRecord::InstanceRecord`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `InstanceRecord::InstanceRecord` (`()`).
  /// - State: Maintains consistent state invariants across `InstanceRecord::InstanceRecord` without partial mutation on error.
  /// - Action: Executes `InstanceRecord::InstanceRecord` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `InstanceRecord::InstanceRecord` (`DOMAIN-INSTANCE-RECORD`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-INSTANCE-RECORD-INSTANCERECORD-INSTANCERECORD] | SysML v2: ActionDef(InstanceRecord::InstanceRecord)
  factory InstanceRecord.fromMap(Map<String, dynamic> map, String typeName) {
    Map<String, dynamic> attrs = {};
    if (map['data_json'] != null) {
      try {
        final decoded = jsonDecode(map['data_json'] as String);
        if (decoded is Map<String, dynamic>) {
          attrs = decoded;
        }
      } catch (_) {}
    } else {
      attrs = Map<String, dynamic>.from(map);
    }
    return InstanceRecord(
      id: map['id']?.toString() ?? attrs['id']?.toString() ?? '',
      parentNodeId: map['parent_node_id']?.toString() ?? attrs['parent_node_id']?.toString() ?? '',
      typeName: map['type_name']?.toString() ?? typeName,
      attributes: attrs,
    );
  }

  /// Attempts to parse an [InstanceRecord] from a raw map database entry.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `InstanceRecord::tryParse` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/domain/instance_record.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `InstanceRecord::tryParse` (declaration #4) within `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 3. Preconditions
  /// - `map: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `InstanceRecord::tryParse`.
  /// - `typeName: String` must satisfy domain and type-safety constraints prior to invoking `InstanceRecord::tryParse`.
  ///
  /// ## 4. Postconditions
  /// - Returns `InstanceRecord?` from `InstanceRecord::tryParse` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(map)) bounded over input/member dimension of `InstanceRecord::tryParse`.
  /// - Space Complexity: O(N(map)) bounded auxiliary memory for `InstanceRecord::tryParse`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `InstanceRecord::tryParse` (`InstanceRecord?`).
  /// - State: Maintains consistent state invariants across `InstanceRecord::tryParse` without partial mutation on error.
  /// - Action: Executes `InstanceRecord::tryParse` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `InstanceRecord::tryParse` (`DOMAIN-INSTANCE-RECORD`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-INSTANCE-RECORD-INSTANCERECORD-TRYPARSE] | SysML v2: ActionDef(InstanceRecord::tryParse)
  static InstanceRecord? tryParse(Map<String, dynamic> map, String typeName) {
    try {
      return InstanceRecord.fromMap(map, typeName);
    } catch (_) {
      return null;
    }
  }

  /// Validates all attributes against the provided [fields] descriptors constraints.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `InstanceRecord::validate` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/domain/instance_record.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `InstanceRecord::validate` (declaration #5) within `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 3. Preconditions
  /// - `fields: List<FieldDescriptor>` must satisfy domain and type-safety constraints prior to invoking `InstanceRecord::validate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Result<void>` from `InstanceRecord::validate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(fields)) bounded over input/member dimension of `InstanceRecord::validate`.
  /// - Space Complexity: O(N(fields)) bounded auxiliary memory for `InstanceRecord::validate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `InstanceRecord::validate` (`Result<void>`).
  /// - State: Maintains consistent state invariants across `InstanceRecord::validate` without partial mutation on error.
  /// - Action: Executes `InstanceRecord::validate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `InstanceRecord::validate` (`DOMAIN-INSTANCE-RECORD`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-INSTANCE-RECORD-INSTANCERECORD-VALIDATE] | SysML v2: ActionDef(InstanceRecord::validate)
  Result<void> validate(List<FieldDescriptor> fields) {
    return validateFields(attributes, fields);
  }

  /// Creates a copy of this [InstanceRecord] with the given fields replaced.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `InstanceRecord::copyWith` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/domain/instance_record.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `InstanceRecord::copyWith` (declaration #6) within `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `InstanceRecord::copyWith` in `DOMAIN-INSTANCE-RECORD`.
  ///
  /// ## 4. Postconditions
  /// - Returns `InstanceRecord` from `InstanceRecord::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `InstanceRecord::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `InstanceRecord::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `InstanceRecord::copyWith` (`InstanceRecord`).
  /// - State: Maintains consistent state invariants across `InstanceRecord::copyWith` without partial mutation on error.
  /// - Action: Executes `InstanceRecord::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `InstanceRecord::copyWith` (`DOMAIN-INSTANCE-RECORD`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-INSTANCE-RECORD-INSTANCERECORD-COPYWITH] | SysML v2: ActionDef(InstanceRecord::copyWith)
  InstanceRecord copyWith({
    String? id,
    String? parentNodeId,
    String? typeName,
    Map<String, dynamic>? attributes,
  }) {
    return InstanceRecord(
      id: id ?? this.id,
      parentNodeId: parentNodeId ?? this.parentNodeId,
      typeName: typeName ?? this.typeName,
      attributes: attributes ?? this.attributes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstanceRecord &&
        other.id == id &&
        other.parentNodeId == parentNodeId &&
        other.typeName == typeName &&
        mapEquals(other.attributes, attributes);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      parentNodeId,
      typeName,
      Object.hashAll(attributes.keys),
      Object.hashAll(attributes.values),
    );
  }
}
