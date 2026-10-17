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
  ProjectedPoint(this.offset, this.z);

  static final Map<int, ProjectedPoint> _pool = {};

  /// Returns a pooled [ProjectedPoint] instance keyed by `(offset.dx, offset.dy, z)`.
  factory ProjectedPoint.pooled(Offset offset, double z) {
    final key = Object.hash(offset.dx, offset.dy, z);
    return _pool.putIfAbsent(key, () => ProjectedPoint(offset, z));
  }

  /// Clears all cached instances in the internal [ProjectedPoint] pool.
  static void clearPool() {
    _pool.clear();
  }
}
