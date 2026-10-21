
/// Exception thrown when the native 3D geospatial bridge fails initialization
/// (status code `-1`).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Maps native C/C++ initialization
///   fault codes (`-1`) into a strongly-typed Dart exception so callers cannot
///   silently operate on an uninitialized native engine handle.
///
/// ## 2. Invariants & Mathematical Properties
/// - Bijective status mapping: raised if and only if native status equals `-1`.
///
/// ## 3. Preconditions
/// - [message] must be a non-null diagnostic string describing the initialization failure.
///
/// ## 4. Postconditions
/// - Constructs an immutable exception whose [toString] is prefixed with
///   `CesiumInitializationException:`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ construction and formatting.
/// - **Space Complexity**: $\mathcal{O}(1)$ wrapper overhead.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Prevents uninitialized handle propagation across FFI boundaries.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/CesiumNativeError]
class CesiumInitializationException implements Exception {
  /// Diagnostic message describing the native initialization failure.
  final String message;

  /// Creates a [CesiumInitializationException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumInitializationException::CesiumInitializationException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumInitializationException::CesiumInitializationException` (declaration #2) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CesiumInitializationException::CesiumInitializationException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumInitializationException::CesiumInitializationException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CesiumInitializationException::CesiumInitializationException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CesiumInitializationException::CesiumInitializationException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumInitializationException::CesiumInitializationException` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumInitializationException::CesiumInitializationException` without partial mutation on error.
  /// - Action: Executes `CesiumInitializationException::CesiumInitializationException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumInitializationException::CesiumInitializationException` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMINITIALIZATIONEXCEPTION-CESIUMINITIALIZATIONEXCEPTION] | SysML v2: ActionDef(CesiumInitializationException::CesiumInitializationException)
  CesiumInitializationException(this.message);
  /// Executes deterministic method `CesiumInitializationException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumInitializationException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumInitializationException::toString` (declaration #3) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumInitializationException::toString` in `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CesiumInitializationException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CesiumInitializationException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CesiumInitializationException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumInitializationException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CesiumInitializationException::toString` without partial mutation on error.
  /// - Action: Executes `CesiumInitializationException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumInitializationException::toString` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMINITIALIZATIONEXCEPTION-TOSTRING] | SysML v2: ActionDef(CesiumInitializationException::toString)
  @override
  String toString() => 'CesiumInitializationException: $message';
}

/// Exception thrown when a native 3D camera update or transform operation fails
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `CesiumCameraException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `CesiumCameraException` (declaration #4) within `NATIVE-ERROR-HANDLER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `CesiumCameraException` in `NATIVE-ERROR-HANDLER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `CesiumCameraException` representation for class `CesiumCameraException`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(CesiumCameraException)) bounded over input/member dimension of `CesiumCameraException`.
/// - Space Complexity: O(K(CesiumCameraException)) bounded auxiliary memory for `CesiumCameraException`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `CesiumCameraException` (`CesiumCameraException`).
/// - State: Maintains consistent state invariants across `CesiumCameraException` without partial mutation on error.
/// - Action: Executes `CesiumCameraException` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `CesiumCameraException` (`NATIVE-ERROR-HANDLER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumNativeError] | SysML v2: PartDef(CesiumCameraException)
class CesiumCameraException implements Exception {
  /// Diagnostic message describing the camera fault.
  final String message;

  /// Creates a [CesiumCameraException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumCameraException::CesiumCameraException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumCameraException::CesiumCameraException` (declaration #5) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CesiumCameraException::CesiumCameraException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumCameraException::CesiumCameraException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CesiumCameraException::CesiumCameraException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CesiumCameraException::CesiumCameraException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumCameraException::CesiumCameraException` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumCameraException::CesiumCameraException` without partial mutation on error.
  /// - Action: Executes `CesiumCameraException::CesiumCameraException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumCameraException::CesiumCameraException` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMCAMERAEXCEPTION-CESIUMCAMERAEXCEPTION] | SysML v2: ActionDef(CesiumCameraException::CesiumCameraException)
  CesiumCameraException(this.message);
  /// Executes deterministic method `CesiumCameraException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumCameraException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumCameraException::toString` (declaration #6) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumCameraException::toString` in `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CesiumCameraException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CesiumCameraException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CesiumCameraException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumCameraException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CesiumCameraException::toString` without partial mutation on error.
  /// - Action: Executes `CesiumCameraException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumCameraException::toString` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMCAMERAEXCEPTION-TOSTRING] | SysML v2: ActionDef(CesiumCameraException::toString)
  @override
  String toString() => 'CesiumCameraException: $message';
}

/// Exception thrown when a native 3D tile query or traversal operation fails
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `CesiumTileException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `CesiumTileException` (declaration #7) within `NATIVE-ERROR-HANDLER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `CesiumTileException` in `NATIVE-ERROR-HANDLER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `CesiumTileException` representation for class `CesiumTileException`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(CesiumTileException)) bounded over input/member dimension of `CesiumTileException`.
/// - Space Complexity: O(K(CesiumTileException)) bounded auxiliary memory for `CesiumTileException`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `CesiumTileException` (`CesiumTileException`).
/// - State: Maintains consistent state invariants across `CesiumTileException` without partial mutation on error.
/// - Action: Executes `CesiumTileException` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `CesiumTileException` (`NATIVE-ERROR-HANDLER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumNativeError] | SysML v2: PartDef(CesiumTileException)
class CesiumTileException implements Exception {
  /// Diagnostic message describing the tile operation fault.
  final String message;

  /// Creates a [CesiumTileException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumTileException::CesiumTileException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumTileException::CesiumTileException` (declaration #8) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CesiumTileException::CesiumTileException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumTileException::CesiumTileException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CesiumTileException::CesiumTileException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CesiumTileException::CesiumTileException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumTileException::CesiumTileException` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumTileException::CesiumTileException` without partial mutation on error.
  /// - Action: Executes `CesiumTileException::CesiumTileException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumTileException::CesiumTileException` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMTILEEXCEPTION-CESIUMTILEEXCEPTION] | SysML v2: ActionDef(CesiumTileException::CesiumTileException)
  CesiumTileException(this.message);
  /// Executes deterministic method `CesiumTileException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumTileException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumTileException::toString` (declaration #9) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumTileException::toString` in `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CesiumTileException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CesiumTileException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CesiumTileException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumTileException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CesiumTileException::toString` without partial mutation on error.
  /// - Action: Executes `CesiumTileException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumTileException::toString` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMTILEEXCEPTION-TOSTRING] | SysML v2: ActionDef(CesiumTileException::toString)
  @override
  String toString() => 'CesiumTileException: $message';
}

/// Exception thrown when a native heap allocation fails inside the C/C++ bridge
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `CesiumMemoryException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `CesiumMemoryException` (declaration #10) within `NATIVE-ERROR-HANDLER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `CesiumMemoryException` in `NATIVE-ERROR-HANDLER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `CesiumMemoryException` representation for class `CesiumMemoryException`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(CesiumMemoryException)) bounded over input/member dimension of `CesiumMemoryException`.
/// - Space Complexity: O(K(CesiumMemoryException)) bounded auxiliary memory for `CesiumMemoryException`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `CesiumMemoryException` (`CesiumMemoryException`).
/// - State: Maintains consistent state invariants across `CesiumMemoryException` without partial mutation on error.
/// - Action: Executes `CesiumMemoryException` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `CesiumMemoryException` (`NATIVE-ERROR-HANDLER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumNativeError] | SysML v2: PartDef(CesiumMemoryException)
class CesiumMemoryException implements Exception {
  /// Diagnostic message describing the native memory fault.
  final String message;

  /// Creates a [CesiumMemoryException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumMemoryException::CesiumMemoryException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumMemoryException::CesiumMemoryException` (declaration #11) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CesiumMemoryException::CesiumMemoryException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumMemoryException::CesiumMemoryException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CesiumMemoryException::CesiumMemoryException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CesiumMemoryException::CesiumMemoryException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumMemoryException::CesiumMemoryException` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumMemoryException::CesiumMemoryException` without partial mutation on error.
  /// - Action: Executes `CesiumMemoryException::CesiumMemoryException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumMemoryException::CesiumMemoryException` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMMEMORYEXCEPTION-CESIUMMEMORYEXCEPTION] | SysML v2: ActionDef(CesiumMemoryException::CesiumMemoryException)
  CesiumMemoryException(this.message);
  /// Executes deterministic method `CesiumMemoryException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumMemoryException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumMemoryException::toString` (declaration #12) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumMemoryException::toString` in `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CesiumMemoryException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CesiumMemoryException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CesiumMemoryException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumMemoryException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CesiumMemoryException::toString` without partial mutation on error.
  /// - Action: Executes `CesiumMemoryException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumMemoryException::toString` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMMEMORYEXCEPTION-TOSTRING] | SysML v2: ActionDef(CesiumMemoryException::toString)
  @override
  String toString() => 'CesiumMemoryException: $message';
}

/// Exception thrown when a native 3D pick or raycast intersection query fails
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `CesiumPickException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `CesiumPickException` (declaration #13) within `NATIVE-ERROR-HANDLER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `CesiumPickException` in `NATIVE-ERROR-HANDLER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `CesiumPickException` representation for class `CesiumPickException`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(CesiumPickException)) bounded over input/member dimension of `CesiumPickException`.
/// - Space Complexity: O(K(CesiumPickException)) bounded auxiliary memory for `CesiumPickException`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `CesiumPickException` (`CesiumPickException`).
/// - State: Maintains consistent state invariants across `CesiumPickException` without partial mutation on error.
/// - Action: Executes `CesiumPickException` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `CesiumPickException` (`NATIVE-ERROR-HANDLER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumNativeError] | SysML v2: PartDef(CesiumPickException)
class CesiumPickException implements Exception {
  /// Diagnostic message describing the pick or raycast fault.
  final String message;

  /// Creates a [CesiumPickException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumPickException::CesiumPickException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumPickException::CesiumPickException` (declaration #14) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CesiumPickException::CesiumPickException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumPickException::CesiumPickException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CesiumPickException::CesiumPickException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CesiumPickException::CesiumPickException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumPickException::CesiumPickException` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumPickException::CesiumPickException` without partial mutation on error.
  /// - Action: Executes `CesiumPickException::CesiumPickException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumPickException::CesiumPickException` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMPICKEXCEPTION-CESIUMPICKEXCEPTION] | SysML v2: ActionDef(CesiumPickException::CesiumPickException)
  CesiumPickException(this.message);
  /// Executes deterministic method `CesiumPickException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumPickException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumPickException::toString` (declaration #15) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumPickException::toString` in `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CesiumPickException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CesiumPickException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CesiumPickException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumPickException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CesiumPickException::toString` without partial mutation on error.
  /// - Action: Executes `CesiumPickException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumPickException::toString` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMPICKEXCEPTION-TOSTRING] | SysML v2: ActionDef(CesiumPickException::toString)
  @override
  String toString() => 'CesiumPickException: $message';
}

/// Exception thrown when an unrecoverable internal error occurs in the native
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `CesiumFatalException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `CesiumFatalException` (declaration #16) within `NATIVE-ERROR-HANDLER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `CesiumFatalException` in `NATIVE-ERROR-HANDLER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `CesiumFatalException` representation for class `CesiumFatalException`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(CesiumFatalException)) bounded over input/member dimension of `CesiumFatalException`.
/// - Space Complexity: O(K(CesiumFatalException)) bounded auxiliary memory for `CesiumFatalException`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `CesiumFatalException` (`CesiumFatalException`).
/// - State: Maintains consistent state invariants across `CesiumFatalException` without partial mutation on error.
/// - Action: Executes `CesiumFatalException` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `CesiumFatalException` (`NATIVE-ERROR-HANDLER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumNativeError] | SysML v2: PartDef(CesiumFatalException)
class CesiumFatalException implements Exception {
  /// Diagnostic message describing the fatal native fault.
  final String message;

  /// Creates a [CesiumFatalException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumFatalException::CesiumFatalException` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumFatalException::CesiumFatalException` (declaration #17) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CesiumFatalException::CesiumFatalException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumFatalException::CesiumFatalException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CesiumFatalException::CesiumFatalException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CesiumFatalException::CesiumFatalException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumFatalException::CesiumFatalException` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumFatalException::CesiumFatalException` without partial mutation on error.
  /// - Action: Executes `CesiumFatalException::CesiumFatalException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumFatalException::CesiumFatalException` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMFATALEXCEPTION-CESIUMFATALEXCEPTION] | SysML v2: ActionDef(CesiumFatalException::CesiumFatalException)
  CesiumFatalException(this.message);
  /// Executes deterministic method `CesiumFatalException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumFatalException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/native/error_handler.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumFatalException::toString` (declaration #18) within `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumFatalException::toString` in `NATIVE-ERROR-HANDLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CesiumFatalException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CesiumFatalException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CesiumFatalException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumFatalException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CesiumFatalException::toString` without partial mutation on error.
  /// - Action: Executes `CesiumFatalException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumFatalException::toString` (`NATIVE-ERROR-HANDLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-ERROR-HANDLER-CESIUMFATALEXCEPTION-TOSTRING] | SysML v2: ActionDef(CesiumFatalException::toString)
  @override
  String toString() => 'CesiumFatalException: $message';
}

/// Validates a native C/C++ bridge integer [status] code and translates negative
/// fault codes into strongly-typed exceptions.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces a deterministic fail-closed
///   error barrier at the FFI boundary so negative C return codes are never
///   misinterpreted as valid handles or counts.
///
/// ## 2. Invariants & Mathematical Properties
/// - Partition invariant:
///   - `status == -1` $\implies$ throws [CesiumInitializationException]
///   - `status == -2` $\implies$ throws [CesiumCameraException]
///   - `status == -3` $\implies$ throws [CesiumTileException]
///   - `status == -4` $\implies$ throws [CesiumMemoryException]
///   - `status == -5` $\implies$ throws [CesiumPickException]
///   - `status == -100` $\implies$ throws [CesiumFatalException]
///   - Otherwise returns `status` unchanged.
///
/// ## 3. Preconditions
/// - [status] is the raw `Int32` status or handle returned by a native bridge call.
///
/// ## 4. Postconditions
/// - Returns [status] if and only if it does not match a known fault code.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ constant-time branch evaluation.
/// - **Space Complexity**: $\mathcal{O}(1)$ stack usage.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Deterministically throws the domain-specific exception corresponding to the
///   native fault code.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/CesiumNativeError]
int checkStatus(int status) {
  if (status == -1) throw CesiumInitializationException('Initialization failed');
  if (status == -2) throw CesiumCameraException('Camera operation failed');
  if (status == -3) throw CesiumTileException('Tile operation failed');
  if (status == -4) throw CesiumMemoryException('Memory allocation failed');
  if (status == -5) throw CesiumPickException('Pick/raycast failed');
  if (status == -100) throw CesiumFatalException('Fatal internal error');
  return status;
}
