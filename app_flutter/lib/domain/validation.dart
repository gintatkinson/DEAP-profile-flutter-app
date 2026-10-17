import 'package:app_flutter/domain/domain_errors.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';

/// Evaluates M2 schema constraints across an M1 attribute map [input] against
/// an ordered list of [FieldDescriptor] definitions.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces deterministic,
///   schema-driven constraint evaluation (mandatory presence, numeric type
///   parsing, inclusive `[minValue, maxValue]` bounds, regular expression
///   patterns, and closed enumeration membership) before any M1 attribute map
///   is committed to persistence.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Sequential First-Failure Determinism**: Evaluates [descriptors] in
///   iteration order and short-circuits on the first violated constraint,
///   returning a deterministic `Failure<void>` wrapping the exact
///   [DomainError] variant.
/// - **Side-Effect Freedom**: Pure function that neither mutates [input] nor
///   modifies any [FieldDescriptor] element.
///
/// ## 3. Preconditions
/// - [input] and [descriptors] must be non-null collections.
/// - Each [FieldDescriptor] in [descriptors] must specify a valid `key` and
///   `type` (`int`, `double`, `real`, `string`, or `enum`).
///
/// ## 4. Postconditions
/// - Returns `const Result.success(null)` if and only if every descriptor in
///   [descriptors] is satisfied by the corresponding entry in [input].
/// - Returns `Result.failure(DomainError)` carrying `SchemaFieldRequiredError`,
///   `SchemaFieldTypeError`, `SchemaFieldRangeError`,
///   `SchemaFieldPatternError`, or `SchemaFieldEnumError` on the first violation.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(D \cdot L)$ where $D = |\text{descriptors}|$
///   and $L$ is the maximum string/enum evaluation length per attribute.
/// - **Space Complexity**: $\mathcal{O}(1)$ auxiliary heap allocation (reuses
///   cached `FieldDescriptor.compiledPattern` instances).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing or empty optional fields (`required == false`) are skipped safely.
/// - Invalid numeric strings are caught via `int.tryParse` / `double.tryParse`
///   and converted into `SchemaFieldTypeError` without throwing `FormatException`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/Validation, ARCH-M2-001, REQ-DOM-002]
Result<void> validateFields(Map<String, dynamic> input, List<FieldDescriptor> descriptors) {
  for (final fd in descriptors) {
    final value = input[fd.key];

    // If missing/empty, check required constraint. Otherwise skip validation if not required.
    if (value == null || (value is String && value.trim().isEmpty)) {
      if (fd.required) {
        return Result.failure(SchemaFieldRequiredError(
          fieldName: fd.key,
          schemaName: fd.key,
        ));
      }
      continue;
    }

    final strVal = value.toString();
    if (fd.type == 'int') {
      final parsed = int.tryParse(strVal);
      if (parsed == null) {
        return Result.failure(SchemaFieldTypeError(
          fieldName: fd.key,
          expectedType: 'int',
          actualType: value.runtimeType.toString(),
        ));
      }
      if (fd.minValue != null && parsed < fd.minValue!) {
        return Result.failure(SchemaFieldRangeError(
          fieldName: fd.key,
          value: parsed,
          min: fd.minValue,
          max: fd.maxValue,
        ));
      }
      if (fd.maxValue != null && parsed > fd.maxValue!) {
        return Result.failure(SchemaFieldRangeError(
          fieldName: fd.key,
          value: parsed,
          min: fd.minValue,
          max: fd.maxValue,
        ));
      }
    } else if (fd.type == 'double' || fd.type == 'real') {
      final parsed = double.tryParse(strVal);
      if (parsed == null) {
        return Result.failure(SchemaFieldTypeError(
          fieldName: fd.key,
          expectedType: fd.type,
          actualType: value.runtimeType.toString(),
        ));
      }
      if (fd.minValue != null && parsed < fd.minValue!) {
        return Result.failure(SchemaFieldRangeError(
          fieldName: fd.key,
          value: parsed,
          min: fd.minValue,
          max: fd.maxValue,
        ));
      }
      if (fd.maxValue != null && parsed > fd.maxValue!) {
        return Result.failure(SchemaFieldRangeError(
          fieldName: fd.key,
          value: parsed,
          min: fd.minValue,
          max: fd.maxValue,
        ));
      }
    } else if (fd.type == 'string') {
      if (fd.pattern != null && fd.pattern!.isNotEmpty) {
        final regex = fd.compiledPattern ?? RegExp(fd.pattern!);
        if (!regex.hasMatch(strVal)) {
          return Result.failure(SchemaFieldPatternError(
            fieldName: fd.key,
            value: strVal,
            pattern: fd.pattern!,
          ));
        }
      }
    } else if (fd.type == 'enum') {
      if (fd.enumOptions != null && !fd.enumOptions!.contains(strVal)) {
        return Result.failure(SchemaFieldEnumError(
          fieldName: fd.key,
          value: strVal,
          allowedValues: fd.enumOptions!,
        ));
      }
    }
  }
  return const Result.success(null);
}
