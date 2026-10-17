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
  const InstanceRecord({
    required this.id,
    required this.parentNodeId,
    required this.typeName,
    required this.attributes,
  });

  /// Creates an [InstanceRecord] from a raw map database entry.
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
  /// Returns `null` if parsing fails.
  static InstanceRecord? tryParse(Map<String, dynamic> map, String typeName) {
    try {
      return InstanceRecord.fromMap(map, typeName);
    } catch (_) {
      return null;
    }
  }

  /// Validates all attributes against the provided [fields] descriptors constraints.
  ///
  /// Returns [Result.success] if valid, or [Result.failure] with a [DomainError] on failure.
  Result<void> validate(List<FieldDescriptor> fields) {
    return validateFields(attributes, fields);
  }

  /// Creates a copy of this [InstanceRecord] with the given fields replaced.
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
