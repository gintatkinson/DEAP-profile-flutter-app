import 'package:flutter/foundation.dart';

/// Sealed algebraic base class representing Layer 1 M2 domain validation and
/// serialization errors with structured diagnostic context.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces Domain Engineering
///   Standards 2, 4, and 5 by replacing untyped runtime exceptions and raw error
///   strings with an immutable, exhaustive `sealed class` hierarchy.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Closed Sum Type**: Every [DomainError] instance is an element of the
///   disjoint union
///   $\{\text{SchemaFieldRequiredError}, \text{SchemaFieldTypeError},
///   \text{SchemaFieldRangeError}, \text{SchemaFieldPatternError},
///   \text{SchemaFieldEnumError}, \text{SerializationError}\}$.
/// - **Compile-Time Immutability**: Annotated with `@immutable` and constructed
///   via `const`.
///
/// ## 3. Preconditions
/// - Concrete subclasses must supply non-null diagnostic field identifiers and
///   constraint parameters.
///
/// ## 4. Postconditions
/// - Enables exhaustive compile-time `switch` pattern matching across all
///   domain failure variants.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for `const` instantiation and pattern
///   dispatch.
/// - **Space Complexity**: $\mathcal{O}(1)$ per error instance.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Prevents unhandled exception propagation across Layer 1, Layer 2, and
///   Layer 3 boundaries when paired with `Result<T>`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
sealed class DomainError {
  /// Abstract const constructor for [DomainError].
  const DomainError();
}

/// Domain error raised when a mandatory M2 schema field is missing or blank.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Reports mandatory attribute
///   omissions deterministically during M2 schema validation without throwing
///   runtime exceptions.
///
/// ## 2. Invariants & Mathematical Properties
/// - Both [fieldName] and [schemaName] are immutable, non-null string
///   identifiers identifying the violated mandatory field contract.
///
/// ## 3. Preconditions
/// - Triggered when `FieldDescriptor.required == true` and the input value is
///   `null` or an empty/whitespace-only string.
///
/// ## 4. Postconditions
/// - Carries exact [fieldName] and [schemaName] provenance inside a `Failure<T>`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ instantiation and field access.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed-size allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Safely surfaced to presentation forms to highlight required input controls.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
final class SchemaFieldRequiredError extends DomainError {
  /// Creates a [SchemaFieldRequiredError] for [fieldName] in [schemaName].
  const SchemaFieldRequiredError({
    required this.fieldName,
    required this.schemaName,
  });

  /// The name of the required field.
  final String fieldName;

  /// The name or identifier of the target schema.
  final String schemaName;
}

/// Domain error raised when an M1 attribute value violates the data type
/// declared by its M2 `FieldDescriptor`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Prevents ill-typed attribute values
///   (e.g., non-numeric strings for `int` or `double` fields) from corrupting
///   persisted domain records or display widgets.
///
/// ## 2. Invariants & Mathematical Properties
/// - Captures the ordered triple `(fieldName, expectedType, actualType)` as
///   immutable strings.
///
/// ## 3. Preconditions
/// - Triggered when `int.tryParse` or `double.tryParse` fails for a numeric
///   `FieldDescriptor.type`.
///
/// ## 4. Postconditions
/// - Encapsulates the expected M2 type alongside the actual runtime type name.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ instantiation.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed-size allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Returned inside `Result.failure` to halt invalid property persistence.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
final class SchemaFieldTypeError extends DomainError {
  /// Creates a [SchemaFieldTypeError].
  const SchemaFieldTypeError({
    required this.fieldName,
    required this.expectedType,
    required this.actualType,
  });

  /// The name of the field with invalid type.
  final String fieldName;

  /// The expected type identifier or name.
  final String expectedType;

  /// The actual type received or encountered.
  final String actualType;
}

/// Domain error raised when a numeric M1 attribute value falls outside the
/// closed interval `[min, max]` declared by its M2 `FieldDescriptor`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces bounded numeric domain
///   constraints ($v \in [\text{min}, \text{max}]$) prior to state mutation or
///   persistence.
///
/// ## 2. Invariants & Mathematical Properties
/// - Holds the offending numeric [value] alongside the optional inclusive
///   bounds [min] and [max] where $v < \text{min}$ or $v > \text{max}$.
///
/// ## 3. Preconditions
/// - Triggered when a parsed `int` or `double` attribute violates a non-null
///   `FieldDescriptor.minValue` or `FieldDescriptor.maxValue`.
///
/// ## 4. Postconditions
/// - Provides exact numeric boundary diagnostic values for operator feedback.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ instantiation.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed-size allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Prevents out-of-range numeric parameters from being committed to storage.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
final class SchemaFieldRangeError extends DomainError {
  /// Creates a [SchemaFieldRangeError].
  const SchemaFieldRangeError({
    required this.fieldName,
    required this.value,
    this.min,
    this.max,
  });

  /// The name of the out-of-range field.
  final String fieldName;

  /// The value that violated the range constraint.
  final num value;

  /// The minimum allowable value, if bounded below.
  final num? min;

  /// The maximum allowable value, if bounded above.
  final num? max;
}

/// Domain error raised when a string M1 attribute value fails to match the
/// regular expression pattern declared by its M2 `FieldDescriptor`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Guarantees lexical conformance of
///   string attributes against schema-defined regular expression grammars.
///
/// ## 2. Invariants & Mathematical Properties
/// - Records the immutable triple `(fieldName, value, pattern)` where
///   `!RegExp(pattern).hasMatch(value)`.
///
/// ## 3. Preconditions
/// - Triggered when a non-empty string attribute fails `FieldDescriptor.pattern`
///   evaluation.
///
/// ## 4. Postconditions
/// - Supplies the rejected string [value] and required [pattern] inside a
///   `Failure` result.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ instantiation.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed-size allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Rejects lexically malformed string inputs without throwing runtime exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
final class SchemaFieldPatternError extends DomainError {
  /// Creates a [SchemaFieldPatternError].
  const SchemaFieldPatternError({
    required this.fieldName,
    required this.value,
    required this.pattern,
  });

  /// The name of the field failing pattern match.
  final String fieldName;

  /// The string value that failed regex matching.
  final String value;

  /// The regex pattern string that was evaluated against.
  final String pattern;
}

/// Domain error raised when an M1 enumeration attribute value is not a member
/// of the finite allowed set declared by its M2 `FieldDescriptor`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces closed-set membership
///   ($v \in \text{allowedValues}$) for discrete enumeration attributes.
///
/// ## 2. Invariants & Mathematical Properties
/// - Records `(fieldName, value, allowedValues)` where
///   `!allowedValues.contains(value)`.
///
/// ## 3. Preconditions
/// - Triggered when `FieldDescriptor.type == 'enum'` and the input string is
///   absent from `FieldDescriptor.enumOptions`.
///
/// ## 4. Postconditions
/// - Preserves the complete list of [allowedValues] for deterministic error
///   reporting in the UI.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ instantiation.
/// - **Space Complexity**: $\mathcal{O}(1)$ reference storage to [allowedValues].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Prevents unrecognised discrete state tokens from entering persistence.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
final class SchemaFieldEnumError extends DomainError {
  /// Creates a [SchemaFieldEnumError].
  const SchemaFieldEnumError({
    required this.fieldName,
    required this.value,
    required this.allowedValues,
  });

  /// The name of the enum field.
  final String fieldName;

  /// The actual invalid enum value provided.
  final String value;

  /// The list of valid permitted enum string representations.
  final List<String> allowedValues;
}

/// Domain error raised when data source serialization, deserialization, or
/// persistence I/O fails.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Translates low-level storage,
///   JSON, SQLite, or network transport exceptions into a strongly-typed Layer 1
///   [DomainError] variant.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves [targetType] and [reason] as non-null strings and optionally
///   captures the raw offending [payload].
///
/// ## 3. Preconditions
/// - Constructed by data source adapters or seed/layout services when an I/O
///   or decoding fault occurs.
///
/// ## 4. Postconditions
/// - Encapsulates adapter failure context inside `Result.failure` so callers
///   handle storage faults deterministically.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ instantiation.
/// - **Space Complexity**: $\mathcal{O}(1)$ wrapper overhead beyond [payload].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Guarantees zero raw storage or JSON exceptions escape into Layer 2
///   ViewModels or Layer 3 widgets.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DomainError, ARCH-M2-001, REQ-DOM-002]
@immutable
final class SerializationError extends DomainError {
  /// Creates a [SerializationError].
  const SerializationError({
    required this.targetType,
    required this.reason,
    this.payload,
  });

  /// The target type attempted during serialization/deserialization.
  final String targetType;

  /// The structured rationale or cause description.
  final String reason;

  /// Optional raw payload data associated with the failure.
  final Object? payload;
}

