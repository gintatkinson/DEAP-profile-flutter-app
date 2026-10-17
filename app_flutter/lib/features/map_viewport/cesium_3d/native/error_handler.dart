
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
  CesiumInitializationException(this.message);
  @override
  String toString() => 'CesiumInitializationException: $message';
}

/// Exception thrown when a native 3D camera update or transform operation fails
/// (status code `-2`).
///
/// Realises: [Feat-10/CesiumNativeError]
class CesiumCameraException implements Exception {
  /// Diagnostic message describing the camera fault.
  final String message;

  /// Creates a [CesiumCameraException] with the given [message].
  CesiumCameraException(this.message);
  @override
  String toString() => 'CesiumCameraException: $message';
}

/// Exception thrown when a native 3D tile query or traversal operation fails
/// (status code `-3`).
///
/// Realises: [Feat-10/CesiumNativeError]
class CesiumTileException implements Exception {
  /// Diagnostic message describing the tile operation fault.
  final String message;

  /// Creates a [CesiumTileException] with the given [message].
  CesiumTileException(this.message);
  @override
  String toString() => 'CesiumTileException: $message';
}

/// Exception thrown when a native heap allocation fails inside the C/C++ bridge
/// (status code `-4`).
///
/// Realises: [Feat-10/CesiumNativeError]
class CesiumMemoryException implements Exception {
  /// Diagnostic message describing the native memory fault.
  final String message;

  /// Creates a [CesiumMemoryException] with the given [message].
  CesiumMemoryException(this.message);
  @override
  String toString() => 'CesiumMemoryException: $message';
}

/// Exception thrown when a native 3D pick or raycast intersection query fails
/// (status code `-5`).
///
/// Realises: [Feat-10/CesiumNativeError]
class CesiumPickException implements Exception {
  /// Diagnostic message describing the pick or raycast fault.
  final String message;

  /// Creates a [CesiumPickException] with the given [message].
  CesiumPickException(this.message);
  @override
  String toString() => 'CesiumPickException: $message';
}

/// Exception thrown when an unrecoverable internal error occurs in the native
/// C/C++ bridge (status code `-100`).
///
/// Realises: [Feat-10/CesiumNativeError]
class CesiumFatalException implements Exception {
  /// Diagnostic message describing the fatal native fault.
  final String message;

  /// Creates a [CesiumFatalException] with the given [message].
  CesiumFatalException(this.message);
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
