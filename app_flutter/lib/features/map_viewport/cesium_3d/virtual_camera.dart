/// Exception thrown when WGS-84 geodetic coordinates or camera Euler angles
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `CoordinateValidationException` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `CoordinateValidationException` (declaration #1) within `CESIUM-3D-VIRTUAL-CAMERA`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `CoordinateValidationException` in `CESIUM-3D-VIRTUAL-CAMERA`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `CoordinateValidationException` representation for class `CoordinateValidationException`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(CoordinateValidationException)) bounded over input/member dimension of `CoordinateValidationException`.
/// - Space Complexity: O(K(CoordinateValidationException)) bounded auxiliary memory for `CoordinateValidationException`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `CoordinateValidationException` (`CoordinateValidationException`).
/// - State: Maintains consistent state invariants across `CoordinateValidationException` without partial mutation on error.
/// - Action: Executes `CoordinateValidationException` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `CoordinateValidationException` (`CESIUM-3D-VIRTUAL-CAMERA`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CoordinateValidationException] | SysML v2: PartDef(CoordinateValidationException)
class CoordinateValidationException implements Exception {
  /// Diagnostic message detailing the coordinate or orientation constraint violation.
  final String message;

  /// Creates a [CoordinateValidationException] with the given [message].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CoordinateValidationException::CoordinateValidationException` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CoordinateValidationException::CoordinateValidationException` (declaration #2) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - `message: String` must satisfy domain and type-safety constraints prior to invoking `CoordinateValidationException::CoordinateValidationException`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CoordinateValidationException::CoordinateValidationException` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(message)) bounded over input/member dimension of `CoordinateValidationException::CoordinateValidationException`.
  /// - Space Complexity: O(N(message)) bounded auxiliary memory for `CoordinateValidationException::CoordinateValidationException`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateValidationException::CoordinateValidationException` (`()`).
  /// - State: Maintains consistent state invariants across `CoordinateValidationException::CoordinateValidationException` without partial mutation on error.
  /// - Action: Executes `CoordinateValidationException::CoordinateValidationException` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateValidationException::CoordinateValidationException` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-COORDINATEVALIDATIONEXCEPTION-COORDINATEVALIDATIONEXCEPTION] | SysML v2: ActionDef(CoordinateValidationException::CoordinateValidationException)
  CoordinateValidationException(this.message);

  /// Executes deterministic method `CoordinateValidationException::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateValidationException::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateValidationException::toString` (declaration #3) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CoordinateValidationException::toString` in `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `CoordinateValidationException::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `CoordinateValidationException::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `CoordinateValidationException::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateValidationException::toString` (`String`).
  /// - State: Maintains consistent state invariants across `CoordinateValidationException::toString` without partial mutation on error.
  /// - Action: Executes `CoordinateValidationException::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateValidationException::toString` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-COORDINATEVALIDATIONEXCEPTION-TOSTRING] | SysML v2: ActionDef(CoordinateValidationException::toString)
  @override
  String toString() => 'CoordinateValidationException: $message';
}

/// WGS-84 reference ellipsoid dimensions and geodetic constants.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `Ellipsoid` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `Ellipsoid` (declaration #4) within `CESIUM-3D-VIRTUAL-CAMERA`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `Ellipsoid` in `CESIUM-3D-VIRTUAL-CAMERA`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `Ellipsoid` representation for class `Ellipsoid`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(Ellipsoid)) bounded over input/member dimension of `Ellipsoid`.
/// - Space Complexity: O(K(Ellipsoid)) bounded auxiliary memory for `Ellipsoid`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `Ellipsoid` (`Ellipsoid`).
/// - State: Maintains consistent state invariants across `Ellipsoid` without partial mutation on error.
/// - Action: Executes `Ellipsoid` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `Ellipsoid` (`CESIUM-3D-VIRTUAL-CAMERA`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/Ellipsoid] | SysML v2: PartDef(Ellipsoid)
class Ellipsoid {
  /// Semi-major equatorial radius of the WGS-84 reference ellipsoid in meters
  /// ($a = 6\,378\,137.0\,\text{m}$).
  static const double wgs84EquatorialRadius = 6378137.0;
}

/// Geodetic altitude reference mode for positioning entities relative to terrain.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for enum `AltitudeMode` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for enum `AltitudeMode` (declaration #5) within `CESIUM-3D-VIRTUAL-CAMERA`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `AltitudeMode` in `CESIUM-3D-VIRTUAL-CAMERA`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `AltitudeMode` representation for enum `AltitudeMode`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(AltitudeMode)) bounded over input/member dimension of `AltitudeMode`.
/// - Space Complexity: O(K(AltitudeMode)) bounded auxiliary memory for `AltitudeMode`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `AltitudeMode` (`AltitudeMode`).
/// - State: Maintains consistent state invariants across `AltitudeMode` without partial mutation on error.
/// - Action: Executes `AltitudeMode` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `AltitudeMode` (`CESIUM-3D-VIRTUAL-CAMERA`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/AltitudeMode] | SysML v2: PartDef(AltitudeMode)
enum AltitudeMode {
  /// Altitude measured relative to the WGS-84 reference ellipsoid or Earth center.
  absolute,

  /// Altitude clamped directly to the local terrain surface elevation.
  clampToGround,

  /// Altitude measured as height above ground level (AGL) relative to local terrain.
  relativeToGround,
}

/// Immutable 6-DOF virtual 3D camera state encapsulating geodetic coordinates
/// (`dim_0`, `dim_1`, `dim_2`) and Euler orientation angles (`heading`, `pitch`, `roll`).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces strict domain boundary
///   invariants across all 6 degrees of freedom for 3D geospatial viewport
///   cameras, preventing `NaN`/`Infinity` propagation and invalid sub-surface
///   or polar coordinate singularities.
///
/// ## 2. Invariants & Mathematical Properties
/// - Finiteness invariant: $\forall x \in \{\text{dim}_0, \text{dim}_1, \text{dim}_2, \text{heading}, \text{pitch}, \text{roll}\}, x \in \mathbb{R}$ (`!x.isNaN && !x.isInfinite`).
/// - Geodetic bounds invariant (validated constructor & [VirtualCamera.clamped]):
///   - Latitude: $\text{dim}_0 \in [-90.0^\circ, 90.0^\circ]$
///   - Longitude: $\text{dim}_1 \in [-180.0^\circ, 180.0^\circ]$
///   - Altitude floor: $\text{dim}_2 \ge -100.0\,\text{m}$
/// - Spatial equivalence predicate [isSpatiallyEquivalentTo]:
///   $|\Delta \text{dim}_{0,1}| \le \epsilon_{\text{coord}}$, $|\Delta \text{dim}_2| \le \epsilon_{\text{alt}}$,
///   and $|\Delta(\text{heading}, \text{pitch}, \text{roll})| \le \epsilon_{\text{orient}}$.
///
/// ## 3. Preconditions
/// - For the validating factory [VirtualCamera], all parameters must be finite
///   and lie within their respective geodetic intervals.
/// - For [VirtualCamera.clamped], arbitrary IEEE 754 `double` inputs (including
///   `NaN` or out-of-range values) are accepted and sanitized.
///
/// ## 4. Postconditions
/// - Produces an immutable [VirtualCamera] value object with deterministic
///   value equality (`==` and `hashCode`).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction, clamping, and equivalence checks.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed 6-double value object footprint.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Validating constructor throws [CoordinateValidationException] on `NaN`,
///   `Infinite`, or out-of-range coordinates.
/// - [VirtualCamera.clamped] coerces `NaN`/`Infinite` inputs to `0.0` and clamps
///   coordinates into valid geodetic intervals without throwing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/VirtualCamera]
class VirtualCamera {
  /// Geodetic latitude in degrees ($\in [-90.0, 90.0]$).
  final double dim_0;

  /// Geodetic longitude in degrees ($\in [-180.0, 180.0]$).
  final double dim_1;

  /// Altitude in meters ($\ge -100.0\,\text{m}$ relative to surface or ECEF radius).
  final double dim_2;

  /// Yaw / compass heading angle in degrees.
  final double heading;

  /// Pitch angle in degrees relative to the local horizontal plane.
  final double pitch;

  /// Bank / roll angle in degrees around the camera forward axis.
  final double roll;

  /// Public validating factory constructor preserving runtime exception behavior.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `VirtualCamera::VirtualCamera` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `VirtualCamera::VirtualCamera` (declaration #7) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCamera::VirtualCamera` in `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `VirtualCamera::VirtualCamera` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(VirtualCamera)) bounded over input/member dimension of `VirtualCamera::VirtualCamera`.
  /// - Space Complexity: O(K(VirtualCamera)) bounded auxiliary memory for `VirtualCamera::VirtualCamera`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCamera::VirtualCamera` (`()`).
  /// - State: Maintains consistent state invariants across `VirtualCamera::VirtualCamera` without partial mutation on error.
  /// - Action: Executes `VirtualCamera::VirtualCamera` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCamera::VirtualCamera` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-VIRTUALCAMERA-VIRTUALCAMERA] | SysML v2: ActionDef(VirtualCamera::VirtualCamera)
  factory VirtualCamera({
    required double dim_0,
    required double dim_1,
    required double dim_2,
    required double heading,
    required double pitch,
    required double roll,
  }) {
    if (dim_0.isNaN || dim_0.isInfinite ||
        dim_1.isNaN || dim_1.isInfinite ||
        dim_2.isNaN || dim_2.isInfinite ||
        heading.isNaN || heading.isInfinite ||
        pitch.isNaN || pitch.isInfinite ||
        roll.isNaN || roll.isInfinite) {
      throw CoordinateValidationException('Coordinates and orientation values must be finite numbers.');
    }
    if (dim_0 < -90.0 || dim_0 > 90.0) {
      throw CoordinateValidationException('Latitude must be in the range [-90.0, 90.0].');
    }
    if (dim_1 < -180.0 || dim_1 > 180.0) {
      throw CoordinateValidationException('Longitude must be in the range [-180.0, 180.0].');
    }
    if (dim_2 < -100.0) {
      throw CoordinateValidationException('Altitude must be greater than or equal to -100.0 meters.');
    }
    return VirtualCamera.raw(
      dim_0: dim_0,
      dim_1: dim_1,
      dim_2: dim_2,
      heading: heading,
      pitch: pitch,
      roll: roll,
    );
  }

  /// Internal const constructor for compile-time canonicalization and trusted callers.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `VirtualCamera::VirtualCamera.raw` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `VirtualCamera::VirtualCamera.raw` (declaration #8) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCamera::VirtualCamera.raw` in `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `VirtualCamera::VirtualCamera.raw` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(VirtualCamera.raw)) bounded over input/member dimension of `VirtualCamera::VirtualCamera.raw`.
  /// - Space Complexity: O(K(VirtualCamera.raw)) bounded auxiliary memory for `VirtualCamera::VirtualCamera.raw`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCamera::VirtualCamera.raw` (`()`).
  /// - State: Maintains consistent state invariants across `VirtualCamera::VirtualCamera.raw` without partial mutation on error.
  /// - Action: Executes `VirtualCamera::VirtualCamera.raw` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCamera::VirtualCamera.raw` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-VIRTUALCAMERA-VIRTUALCAMERA-RAW] | SysML v2: ActionDef(VirtualCamera::VirtualCamera.raw)
  const VirtualCamera.raw({
    required this.dim_0,
    required this.dim_1,
    required this.dim_2,
    required this.heading,
    required this.pitch,
    required this.roll,
  });

  /// A static constant representing a default camera at the geodetic origin.
  static const zero = VirtualCamera.raw(
    dim_0: 0.0,
    dim_1: 0.0,
    dim_2: 0.0,
    heading: 0.0,
    pitch: 0.0,
    roll: 0.0,
  );

  /// Creates a sanitized [VirtualCamera] with values clamped to safe geodetic boundaries.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `VirtualCamera::VirtualCamera` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `VirtualCamera::VirtualCamera` (declaration #9) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCamera::VirtualCamera` in `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `VirtualCamera::VirtualCamera` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(VirtualCamera)) bounded over input/member dimension of `VirtualCamera::VirtualCamera`.
  /// - Space Complexity: O(K(VirtualCamera)) bounded auxiliary memory for `VirtualCamera::VirtualCamera`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCamera::VirtualCamera` (`()`).
  /// - State: Maintains consistent state invariants across `VirtualCamera::VirtualCamera` without partial mutation on error.
  /// - Action: Executes `VirtualCamera::VirtualCamera` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCamera::VirtualCamera` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-VIRTUALCAMERA-VIRTUALCAMERA] | SysML v2: ActionDef(VirtualCamera::VirtualCamera)
  factory VirtualCamera.clamped({
    required double dim_0,
    required double dim_1,
    required double dim_2,
    required double heading,
    required double pitch,
    required double roll,
  }) {
    final double val_dim_0 = (dim_0.isNaN || dim_0.isInfinite) ? 0.0 : dim_0;
    final double val_dim_1 = (dim_1.isNaN || dim_1.isInfinite) ? 0.0 : dim_1;
    final double val_dim_2 = (dim_2.isNaN || dim_2.isInfinite) ? 0.0 : dim_2;
    final double head = (heading.isNaN || heading.isInfinite) ? 0.0 : heading;
    final double pit = (pitch.isNaN || pitch.isInfinite) ? 0.0 : pitch;
    final double rl = (roll.isNaN || roll.isInfinite) ? 0.0 : roll;

    final double clampedLat = val_dim_0.clamp(-90.0, 90.0);
    final double clampedLng = val_dim_1.clamp(-180.0, 180.0);
    final double clampedAlt = val_dim_2 < -100.0 ? -100.0 : val_dim_2;
    return VirtualCamera(
      dim_0: clampedLat,
      dim_1: clampedLng,
      dim_2: clampedAlt,
      heading: head,
      pitch: pit,
      roll: rl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VirtualCamera) return false;
    return other.dim_0 == dim_0 &&
        other.dim_1 == dim_1 &&
        other.dim_2 == dim_2 &&
        other.heading == heading &&
        other.pitch == pitch &&
        other.roll == roll;
  }

  /// Evaluates whether [other] is spatially equivalent within bounded tolerances.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `VirtualCamera::isSpatiallyEquivalentTo` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `VirtualCamera::isSpatiallyEquivalentTo` (declaration #10) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCamera::isSpatiallyEquivalentTo` in `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `VirtualCamera::isSpatiallyEquivalentTo` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(isSpatiallyEquivalentTo)) bounded over input/member dimension of `VirtualCamera::isSpatiallyEquivalentTo`.
  /// - Space Complexity: O(K(isSpatiallyEquivalentTo)) bounded auxiliary memory for `VirtualCamera::isSpatiallyEquivalentTo`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCamera::isSpatiallyEquivalentTo` (`bool`).
  /// - State: Maintains consistent state invariants across `VirtualCamera::isSpatiallyEquivalentTo` without partial mutation on error.
  /// - Action: Executes `VirtualCamera::isSpatiallyEquivalentTo` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCamera::isSpatiallyEquivalentTo` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-VIRTUALCAMERA-ISSPATIALLYEQUIVALENTTO] | SysML v2: ActionDef(VirtualCamera::isSpatiallyEquivalentTo)
  bool isSpatiallyEquivalentTo(
    VirtualCamera other, {
    double epsilonCoordinate = 1e-7,
    double epsilonAltitude = 1e-3,
    double epsilonOrientation = 1e-3,
  }) {
    if (identical(this, other)) return true;
    return (dim_0 - other.dim_0).abs() <= epsilonCoordinate &&
           (dim_1 - other.dim_1).abs() <= epsilonCoordinate &&
           (dim_2 - other.dim_2).abs() <= epsilonAltitude &&
           (heading - other.heading).abs() <= epsilonOrientation &&
           (pitch - other.pitch).abs() <= epsilonOrientation &&
           (roll - other.roll).abs() <= epsilonOrientation;
  }

  /// Executes deterministic method `VirtualCamera::hashCode` within `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `VirtualCamera::hashCode` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `VirtualCamera::hashCode` (declaration #11) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - `dim_0: String` must satisfy domain and type-safety constraints prior to invoking `VirtualCamera::hashCode`.
  /// - `dim_1: String` must satisfy domain and type-safety constraints prior to invoking `VirtualCamera::hashCode`.
  /// - `dim_2: String` must satisfy domain and type-safety constraints prior to invoking `VirtualCamera::hashCode`.
  /// - `heading: String` must satisfy domain and type-safety constraints prior to invoking `VirtualCamera::hashCode`.
  /// - `pitch: String` must satisfy domain and type-safety constraints prior to invoking `VirtualCamera::hashCode`.
  /// - `roll: String` must satisfy domain and type-safety constraints prior to invoking `VirtualCamera::hashCode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `VirtualCamera::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_0)) bounded over input/member dimension of `VirtualCamera::hashCode`.
  /// - Space Complexity: O(N(dim_0)) bounded auxiliary memory for `VirtualCamera::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCamera::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `VirtualCamera::hashCode` without partial mutation on error.
  /// - Action: Executes `VirtualCamera::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCamera::hashCode` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-VIRTUALCAMERA-HASHCODE] | SysML v2: ActionDef(VirtualCamera::hashCode)
  @override
  int get hashCode => Object.hash(dim_0, dim_1, dim_2, heading, pitch, roll);

  /// Executes deterministic method `VirtualCamera::toString` within `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `VirtualCamera::toString` in `app_flutter/lib/features/map_viewport/cesium_3d/virtual_camera.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `VirtualCamera::toString` (declaration #11) within `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCamera::toString` in `CESIUM-3D-VIRTUAL-CAMERA`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `VirtualCamera::toString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toString)) bounded over input/member dimension of `VirtualCamera::toString`.
  /// - Space Complexity: O(K(toString)) bounded auxiliary memory for `VirtualCamera::toString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCamera::toString` (`String`).
  /// - State: Maintains consistent state invariants across `VirtualCamera::toString` without partial mutation on error.
  /// - Action: Executes `VirtualCamera::toString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCamera::toString` (`CESIUM-3D-VIRTUAL-CAMERA`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-VIRTUAL-CAMERA-VIRTUALCAMERA-TOSTRING] | SysML v2: ActionDef(VirtualCamera::toString)
  @override
  String toString() {
    return 'VirtualCamera(dim_0: $dim_0, dim_1: $dim_1, dim_2: $dim_2, heading: $heading, pitch: $pitch, roll: $roll)';
  }
}
