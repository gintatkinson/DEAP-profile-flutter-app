/// Exception thrown when WGS-84 geodetic coordinates or camera Euler angles
/// violate numeric finiteness or spatial range constraints.
///
/// Realises: [Feat-10/CoordinateValidationException]
class CoordinateValidationException implements Exception {
  /// Diagnostic message detailing the coordinate or orientation constraint violation.
  final String message;

  /// Creates a [CoordinateValidationException] with the given [message].
  CoordinateValidationException(this.message);

  @override
  String toString() => 'CoordinateValidationException: $message';
}

/// WGS-84 reference ellipsoid dimensions and geodetic constants.
///
/// Realises: [Feat-10/Ellipsoid]
class Ellipsoid {
  /// Semi-major equatorial radius of the WGS-84 reference ellipsoid in meters
  /// ($a = 6\,378\,137.0\,\text{m}$).
  static const double wgs84EquatorialRadius = 6378137.0;
}

/// Geodetic altitude reference mode for positioning entities relative to terrain.
///
/// Realises: [Feat-10/AltitudeMode]
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
  /// Clamps `dim_2` to at least `-100.0`, `dim_0` to `[-90, 90]`, and `dim_1` to `[-180, 180]`.
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

  @override
  int get hashCode => Object.hash(dim_0, dim_1, dim_2, heading, pitch, roll);

  @override
  String toString() {
    return 'VirtualCamera(dim_0: $dim_0, dim_1: $dim_1, dim_2: $dim_2, heading: $heading, pitch: $pitch, roll: $roll)';
  }
}
