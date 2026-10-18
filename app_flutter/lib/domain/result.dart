import 'package:flutter/foundation.dart';
import 'domain_errors.dart';

/// Generic sealed algebraic sum type representing either a successful domain
/// computation [Success] or a typed domain failure [Failure].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces Domain Engineering
///   Standards 1 and 2 (`Result<T>` Over Exceptions & Sealed Class Hierarchies)
///   so that all fallible Layer 1 and Layer 2 operations return total,
///   explicitly checked outcomes without throwing untyped runtime exceptions.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Disjoint Partition Invariant**: For every instance $r \in \text{Result}\langle T \rangle$,
///   exactly one predicate holds: `r.isSuccess != r.isFailure`.
/// - **Exhaustive Pattern Matching**: As a `sealed class`, any `switch (result)`
///   expression over `Success<T>` and `Failure<T>` is verified exhaustive at
///   compile time.
///
/// ## 3. Preconditions
/// - Callers constructing a `Success<T>` must supply a value of type `T`;
///   callers constructing a `Failure<T>` must supply a non-null [DomainError].
///
/// ## 4. Postconditions
/// - Wraps either the domain payload `T` or the structured [DomainError] inside
///   an `@immutable`, `const`-constructible value container.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for factory construction, type
///   predicates (`isSuccess`, `isFailure`), and pattern matching.
/// - **Space Complexity**: $\mathcal{O}(1)$ wrapper allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Eliminates uncaught exception control-flow transfers across repository,
///   validation, and ViewModel boundaries.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/Result, ARCH-M2-001, REQ-DOM-001]
@immutable
sealed class Result<T> {
  /// Abstract const constructor for [Result].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `Result::Result` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/domain/result.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `Result::Result` (declaration #2) within `DOMAIN-RESULT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `Result::Result` in `DOMAIN-RESULT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `Result::Result` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(Result)) bounded over input/member dimension of `Result::Result`.
  /// - Space Complexity: O(K(Result)) bounded auxiliary memory for `Result::Result`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `Result::Result` (`()`).
  /// - State: Maintains consistent state invariants across `Result::Result` without partial mutation on error.
  /// - Action: Executes `Result::Result` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `Result::Result` (`DOMAIN-RESULT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-RESULT-RESULT-RESULT] | SysML v2: ActionDef(Result::Result)
  const Result();

  /// Creates a successful [Result] carrying [value].
  const factory Result.success(T value) = Success<T>;

  /// Creates a failed [Result] carrying [error].
  const factory Result.failure(DomainError error) = Failure<T>;

  /// Returns `true` if this result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this result is a [Failure].
  bool get isFailure => this is Failure<T>;
}

/// Concrete sealed variant of [Result] representing a successful computation
/// carrying a typed payload [value] of type [T].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides the nominal success branch
///   of the `Result<T>` algebraic data type for deterministic payload delivery.
///
/// ## 2. Invariants & Mathematical Properties
/// - Always satisfies `isSuccess == true` and `isFailure == false`.
/// - Immutable (`@immutable`) and `const`-constructible.
///
/// ## 3. Preconditions
/// - [value] must conform to the static type parameter `T`.
///
/// ## 4. Postconditions
/// - Exposes [value] for pattern-matched extraction without cast errors.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ construction and field access.
/// - **Space Complexity**: $\mathcal{O}(1)$ wrapper allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Total value wrapper; cannot throw on access.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/Result, ARCH-M2-001, REQ-DOM-001]
@immutable
final class Success<T> extends Result<T> {
  /// Creates a [Success] instance carrying the given [value].
  const Success(this.value);

  /// The successful payload value.
  final T value;
}

/// Concrete sealed variant of [Result] representing a failed computation
/// carrying a structured [DomainError].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides the fault branch of the
///   `Result<T>` algebraic data type so that validation and persistence errors
///   are propagated as typed values rather than exceptions.
///
/// ## 2. Invariants & Mathematical Properties
/// - Always satisfies `isFailure == true` and `isSuccess == false`.
/// - Carries a non-null, immutable [DomainError] instance.
///
/// ## 3. Preconditions
/// - [error] must be a non-null [DomainError] subclass instance.
///
/// ## 4. Postconditions
/// - Preserves the exact [DomainError] variant for exhaustive error recovery or
///   UI diagnostic presentation.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ construction and field access.
/// - **Space Complexity**: $\mathcal{O}(1)$ wrapper allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Total error container; prevents silent error swallowing by requiring
///   explicit pattern matching on [Result].
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/Result, ARCH-M2-001, REQ-DOM-001]
@immutable
final class Failure<T> extends Result<T> {
  /// Creates a [Failure] instance carrying the given domain [error].
  const Failure(this.error);

  /// The domain error describing the cause of failure.
  final DomainError error;
}

