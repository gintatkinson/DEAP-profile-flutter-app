/// Canonical Layer 1 M2 Domain Schema Barrel exporting runtime metamodel
/// descriptors, instance records, validation rules, error types, and repository contracts.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides a unified, deterministic
///   Layer 1 domain interface boundary for schema-driven M2 metamodel descriptors,
///   ensuring complete decoupling between functional domain contracts and
///   platform presentation or persistence adapters without domain hardcoding.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Barrel Completeness Invariant**: Re-exports the complete closed set of
///   Layer 1 domain descriptors (`TypeDescriptor`, `FieldDescriptor`,
///   `TypeRelationDescriptor`), instance containers (`InstanceRecord`),
///   algebraic outcomes (`Result`, `Success`, `Failure`), structured error
///   types (`DomainError`), validation logic (`validateFields`), and repository
///   contracts (`DataSource`).
/// - **Zero Stateful Side Effects**: Importing this barrel introduces zero
///   mutable global state or static initialization side effects.
///
/// ## 3. Preconditions
/// - Constituent Layer 1 domain modules must remain free of presentation-layer
///   widget dependencies and external database SDK imports.
///
/// ## 4. Postconditions
/// - Consumers importing `schema.dart` gain compile-time access to all Layer 1
///   M2 schema descriptors and validation primitives.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ compile-time symbol resolution; zero
///   runtime execution overhead.
/// - **Space Complexity**: $\mathcal{O}(1)$ auxiliary heap allocation (zero
///   runtime memory footprint).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Compile-time namespace resolution prevents missing symbol faults across
///   downstream ViewModels and data adapters.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [ARCH-M2-001, REQ-DOM-001, REQ-DOM-002, REQ-DOM-003, REQ-DOM-004, Feat-10/Schema]
library schema;

export 'data_source.dart';
export 'domain_errors.dart';
export 'instance_record.dart';
export 'result.dart';
export 'type_descriptor.dart';
export 'validation.dart';
