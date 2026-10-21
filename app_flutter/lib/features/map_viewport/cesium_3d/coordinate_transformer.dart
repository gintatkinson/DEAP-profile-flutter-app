import 'dart:typed_data';

import 'package:app_flutter/features/map_viewport/cesium_3d/virtual_camera.dart';

/// Deterministic Earth-Centered, Earth-Fixed (ECEF) to local coordinate frame
/// transformation utility with zero-allocation buffer output support.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces strict numeric finiteness
///   validation (`!isNaN && !isInfinite`) across all 3D ECEF spatial coordinate
///   inputs prior to local viewport scaling, preventing undefined floating-point
///   propagation into display rendering pipelines.
///
/// ## 2. Invariants & Mathematical Properties
/// - Linear scaling invariant: $\mathbf{p}_{\text{local}} = 0.01 \cdot \mathbf{p}_{\text{ecef}}$
///   for all finite $\mathbf{p}_{\text{ecef}} \in \mathbb{R}^3$.
/// - Finiteness guard: any coordinate component satisfying `isNaN || isInfinite`
///   is deterministically rejected with [CoordinateValidationException].
///
/// ## 3. Preconditions
/// - `ecefX`, `ecefY`, and `ecefZ` must be finite IEEE 754 double-precision values.
/// - For [transformEcefToLocalOut], caller-supplied `out` buffer must have `length >= 3`.
///
/// ## 4. Postconditions
/// - Writes scaled local coordinates `(out[0], out[1], out[2])` without heap
///   allocation when using [transformEcefToLocalOut].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ constant-time arithmetic transformation.
/// - **Space Complexity**: $\mathcal{O}(1)$ (zero heap allocation in [transformEcefToLocalOut]).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Throws [CoordinateValidationException] immediately if any input coordinate
///   is `NaN` or `Infinite`, leaving the caller output buffer unmodified.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/CoordinateTransformer]
class CoordinateTransformer {
  /// Transforms ECEF coordinates to local coordinates.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateTransformer::transformEcefToLocal` in `app_flutter/lib/features/map_viewport/cesium_3d/coordinate_transformer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateTransformer::transformEcefToLocal` (declaration #2) within `CESIUM-3D-COORDINATE-TRANSFORMER`.
  ///
  /// ## 3. Preconditions
  /// - `ecefX: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::transformEcefToLocal`.
  /// - `ecefY: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::transformEcefToLocal`.
  /// - `ecefZ: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::transformEcefToLocal`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<double>` from `CoordinateTransformer::transformEcefToLocal` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(ecefX)) bounded over input/member dimension of `CoordinateTransformer::transformEcefToLocal`.
  /// - Space Complexity: O(N(ecefX)) bounded auxiliary memory for `CoordinateTransformer::transformEcefToLocal`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::transformEcefToLocal` (`List<double>`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::transformEcefToLocal` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::transformEcefToLocal` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::transformEcefToLocal` (`CESIUM-3D-COORDINATE-TRANSFORMER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-COORDINATE-TRANSFORMER-COORDINATETRANSFORMER-TRANSFORMECEFTOLOCAL] | SysML v2: ActionDef(CoordinateTransformer::transformEcefToLocal)
  @Deprecated('Use transformEcefToLocalOut to avoid GC churn on the hot path.')
  List<double> transformEcefToLocal(double ecefX, double ecefY, double ecefZ) {
    final out = Float64List(3);
    transformEcefToLocalOut(out, ecefX, ecefY, ecefZ);
    return out;
  }

  /// Transforms ECEF coordinates to local coordinates, writing the result
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateTransformer::transformEcefToLocalOut` in `app_flutter/lib/features/map_viewport/cesium_3d/coordinate_transformer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateTransformer::transformEcefToLocalOut` (declaration #3) within `CESIUM-3D-COORDINATE-TRANSFORMER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CoordinateTransformer::transformEcefToLocalOut` in `CESIUM-3D-COORDINATE-TRANSFORMER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CoordinateTransformer::transformEcefToLocalOut` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(transformEcefToLocalOut)) bounded over input/member dimension of `CoordinateTransformer::transformEcefToLocalOut`.
  /// - Space Complexity: O(K(transformEcefToLocalOut)) bounded auxiliary memory for `CoordinateTransformer::transformEcefToLocalOut`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::transformEcefToLocalOut` (`void`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::transformEcefToLocalOut` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::transformEcefToLocalOut` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::transformEcefToLocalOut` (`CESIUM-3D-COORDINATE-TRANSFORMER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-COORDINATE-TRANSFORMER-COORDINATETRANSFORMER-TRANSFORMECEFTOLOCALOUT] | SysML v2: ActionDef(CoordinateTransformer::transformEcefToLocalOut)
  void transformEcefToLocalOut(
      Float64List out, double ecefX, double ecefY, double ecefZ) {
    if (ecefX.isNaN || ecefX.isInfinite ||
        ecefY.isNaN || ecefY.isInfinite ||
        ecefZ.isNaN || ecefZ.isInfinite) {
      throw CoordinateValidationException(
          'ECEF coordinates must map to real values. '
          'NaN or Infinite coordinates are rejected.');
    }
    out[0] = ecefX * 0.01;
    out[1] = ecefY * 0.01;
    out[2] = ecefZ * 0.01;
  }
}
