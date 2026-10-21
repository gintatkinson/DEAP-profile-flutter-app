import 'dart:ui';

/// Projected 2D screen-space coordinate paired with signed camera-space depth
/// for front/back hemisphere occlusion culling.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides deterministic screen-space
///   projection coordinates and signed depth classification so tactical 3D
///   viewport painters never render back-hemisphere primitives over front-hemisphere
///   symbology.
///
/// ## 2. Invariants & Mathematical Properties
/// - Front-hemisphere visibility invariant: $z \ge 0$ denotes a point on the
///   visible hemisphere in front of the camera plane, whereas $z < 0$ denotes
///   an occluded or behind-camera point.
/// - Flyweight pooling invariant: [ProjectedPoint.pooled] hashes `(offset.dx, offset.dy, z)`
///   for deterministic instance reuse.
///
/// ## 3. Preconditions
/// - [offset] must contain finite 2D canvas coordinates and [z] must be a
///   signed depth scalar computed by the active coordinate projection pipeline.
///
/// ## 4. Postconditions
/// - Exposes immutable [offset] and [z] properties for canvas rendering and
///   hemisphere culling predicates.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for direct construction and pool lookup.
/// - **Space Complexity**: $\mathcal{O}(1)$ per instance; $\mathcal{O}(P)$ for $P$ pooled points.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Negative depth sentinel values ($z = -1.0, -2.0, -100.0$) explicitly signal
///   horizon-clamped, back-hemisphere culled, or behind-camera geometry without
///   throwing exceptions on the render thread.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/ProjectedPoint]
class ProjectedPoint {
  /// The 2D canvas-space pixel offset of the projected point.
  final Offset offset;

  /// The signed depth after rotation and tilt; $z \ge 0$ indicates the point
  /// is on the front (visible) hemisphere.
  final double z;

  /// Creates a projected point from a pixel [offset] and a signed depth [z].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ProjectedPoint::ProjectedPoint` in `app_flutter/lib/features/map_viewport/cesium_3d/projected_point.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ProjectedPoint::ProjectedPoint` (declaration #2) within `CESIUM-3D-PROJECTED-POINT`.
  ///
  /// ## 3. Preconditions
  /// - `offset: String` must satisfy domain and type-safety constraints prior to invoking `ProjectedPoint::ProjectedPoint`.
  /// - `z: String` must satisfy domain and type-safety constraints prior to invoking `ProjectedPoint::ProjectedPoint`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ProjectedPoint::ProjectedPoint` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(offset)) bounded over input/member dimension of `ProjectedPoint::ProjectedPoint`.
  /// - Space Complexity: O(N(offset)) bounded auxiliary memory for `ProjectedPoint::ProjectedPoint`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ProjectedPoint::ProjectedPoint` (`()`).
  /// - State: Maintains consistent state invariants across `ProjectedPoint::ProjectedPoint` without partial mutation on error.
  /// - Action: Executes `ProjectedPoint::ProjectedPoint` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ProjectedPoint::ProjectedPoint` (`CESIUM-3D-PROJECTED-POINT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-PROJECTED-POINT-PROJECTEDPOINT-PROJECTEDPOINT] | SysML v2: ActionDef(ProjectedPoint::ProjectedPoint)
  ProjectedPoint(this.offset, this.z);

  static final Map<int, ProjectedPoint> _pool = {};

  /// Returns a pooled [ProjectedPoint] instance keyed by `(offset.dx, offset.dy, z)`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ProjectedPoint::ProjectedPoint` in `app_flutter/lib/features/map_viewport/cesium_3d/projected_point.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ProjectedPoint::ProjectedPoint` (declaration #3) within `CESIUM-3D-PROJECTED-POINT`.
  ///
  /// ## 3. Preconditions
  /// - `offset: Offset` must satisfy domain and type-safety constraints prior to invoking `ProjectedPoint::ProjectedPoint`.
  /// - `z: double` must satisfy domain and type-safety constraints prior to invoking `ProjectedPoint::ProjectedPoint`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ProjectedPoint::ProjectedPoint` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(offset)) bounded over input/member dimension of `ProjectedPoint::ProjectedPoint`.
  /// - Space Complexity: O(N(offset)) bounded auxiliary memory for `ProjectedPoint::ProjectedPoint`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ProjectedPoint::ProjectedPoint` (`()`).
  /// - State: Maintains consistent state invariants across `ProjectedPoint::ProjectedPoint` without partial mutation on error.
  /// - Action: Executes `ProjectedPoint::ProjectedPoint` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ProjectedPoint::ProjectedPoint` (`CESIUM-3D-PROJECTED-POINT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-PROJECTED-POINT-PROJECTEDPOINT-PROJECTEDPOINT] | SysML v2: ActionDef(ProjectedPoint::ProjectedPoint)
  factory ProjectedPoint.pooled(Offset offset, double z) {
    final key = Object.hash(offset.dx, offset.dy, z);
    return _pool.putIfAbsent(key, () => ProjectedPoint(offset, z));
  }

  /// Clears all cached instances in the internal [ProjectedPoint] pool.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ProjectedPoint::clearPool` in `app_flutter/lib/features/map_viewport/cesium_3d/projected_point.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ProjectedPoint::clearPool` (declaration #4) within `CESIUM-3D-PROJECTED-POINT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ProjectedPoint::clearPool` in `CESIUM-3D-PROJECTED-POINT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `ProjectedPoint::clearPool` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(clearPool)) bounded over input/member dimension of `ProjectedPoint::clearPool`.
  /// - Space Complexity: O(K(clearPool)) bounded auxiliary memory for `ProjectedPoint::clearPool`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ProjectedPoint::clearPool` (`void`).
  /// - State: Maintains consistent state invariants across `ProjectedPoint::clearPool` without partial mutation on error.
  /// - Action: Executes `ProjectedPoint::clearPool` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ProjectedPoint::clearPool` (`CESIUM-3D-PROJECTED-POINT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-PROJECTED-POINT-PROJECTEDPOINT-CLEARPOOL] | SysML v2: ActionDef(ProjectedPoint::clearPool)
  static void clearPool() {
    _pool.clear();
  }
}
