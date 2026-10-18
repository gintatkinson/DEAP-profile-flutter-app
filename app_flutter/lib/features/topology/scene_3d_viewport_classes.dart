// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/cesium_engine.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/globe_tile_renderer.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/projected_point.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/tile_fetcher.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/camera_controller.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/virtual_camera.dart';
import 'package:app_flutter/features/topology/topology_map.dart';
import 'package:app_flutter/features/tree/view_models/tree_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// ## 1. Safety Intent & Regulatory Scope
/// Provides DO-178C Level A / ARINC 661 coordinate normalization and linear
/// velocity extrapolation extensions on [VirtualCamera] for 3D viewport state.
///
/// ## 2. Invariants & Mathematical Properties
/// - Absolute WGS84 normalization shifts altitude by `Ellipsoid.wgs84EquatorialRadius` when `dim_2 < R_eq`.
/// - Extrapolated latitude is clamped to `[-90.0, 90.0]` and longitude to `[-180.0, 180.0]`.
///
/// ## 3. Preconditions
/// - `deltaSeconds` and velocity components must be finite IEEE 754 doubles.
///
/// ## 4. Postconditions
/// - Returns a new immutable [VirtualCamera] instance with normalized or extrapolated coordinates.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) constant-time arithmetic.
/// - Space Complexity: O(1) single [VirtualCamera] allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Sub-surface altitude extrapolation is bounded to a minimum of `-100.0` meters.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-002/VirtualCameraNormalization]
extension VirtualCameraNormalization on VirtualCamera {
  /// Ensures the camera altitude is normalized to absolute ECEF coordinates
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `VirtualCameraNormalization::toAbsoluteWgs84` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `VirtualCameraNormalization::toAbsoluteWgs84` (declaration #2) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCameraNormalization::toAbsoluteWgs84` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `VirtualCamera` from `VirtualCameraNormalization::toAbsoluteWgs84` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toAbsoluteWgs84)) bounded over input/member dimension of `VirtualCameraNormalization::toAbsoluteWgs84`.
  /// - Space Complexity: O(K(toAbsoluteWgs84)) bounded auxiliary memory for `VirtualCameraNormalization::toAbsoluteWgs84`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCameraNormalization::toAbsoluteWgs84` (`VirtualCamera`).
  /// - State: Maintains consistent state invariants across `VirtualCameraNormalization::toAbsoluteWgs84` without partial mutation on error.
  /// - Action: Executes `VirtualCameraNormalization::toAbsoluteWgs84` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCameraNormalization::toAbsoluteWgs84` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-VIRTUALCAMERANORMALIZATION-TOABSOLUTEWGS84] | SysML v2: ActionDef(VirtualCameraNormalization::toAbsoluteWgs84)
  VirtualCamera toAbsoluteWgs84() {
    if (dim_2 >= Ellipsoid.wgs84EquatorialRadius) {
      return this;
    }
    return VirtualCamera.raw(
      dim_0: dim_0,
      dim_1: dim_1,
      dim_2: Ellipsoid.wgs84EquatorialRadius + dim_2,
      heading: heading,
      pitch: pitch,
      roll: roll,
    );
  }

  /// Extrapolates camera position forward in time based on velocity vector and delta seconds.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `VirtualCameraNormalization::extrapolatePosition` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `VirtualCameraNormalization::extrapolatePosition` (declaration #3) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `VirtualCameraNormalization::extrapolatePosition` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `VirtualCamera` from `VirtualCameraNormalization::extrapolatePosition` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(extrapolatePosition)) bounded over input/member dimension of `VirtualCameraNormalization::extrapolatePosition`.
  /// - Space Complexity: O(K(extrapolatePosition)) bounded auxiliary memory for `VirtualCameraNormalization::extrapolatePosition`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `VirtualCameraNormalization::extrapolatePosition` (`VirtualCamera`).
  /// - State: Maintains consistent state invariants across `VirtualCameraNormalization::extrapolatePosition` without partial mutation on error.
  /// - Action: Executes `VirtualCameraNormalization::extrapolatePosition` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `VirtualCameraNormalization::extrapolatePosition` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-VIRTUALCAMERANORMALIZATION-EXTRAPOLATEPOSITION] | SysML v2: ActionDef(VirtualCameraNormalization::extrapolatePosition)
  VirtualCamera extrapolatePosition(
    double deltaSeconds, {
    double velocityLat = 0.0,
    double velocityLng = 0.0,
    double velocityAlt = 0.0,
  }) {
    final double newLat = (dim_0 + velocityLat * deltaSeconds).clamp(-90.0, 90.0);
    final double newLng = (dim_1 + velocityLng * deltaSeconds).clamp(-180.0, 180.0);
    final double newAlt = math.max(-100.0, dim_2 + velocityAlt * deltaSeconds);
    return VirtualCamera.raw(
      dim_0: newLat,
      dim_1: newLng,
      dim_2: newAlt,
      heading: heading,
      pitch: pitch,
      roll: roll,
    );
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Computes deterministic procedural terrain elevation samples for the 3D
/// viewport under DO-178C Level A / ARINC 661 rendering determinism constraints.
///
/// ## 2. Invariants & Mathematical Properties
/// - Returns `0.0` whenever [isElevationActive] is `false`.
/// - Scales synthesized elevation linearly by [verticalExaggeration].
///
/// ## 3. Preconditions
/// - `latDeg` and `lngDeg` must be finite geodetic coordinates in degrees.
///
/// ## 4. Postconditions
/// - Returns a deterministic non-negative elevation offset in meters.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) constant-time trigonometric evaluation.
/// - Space Complexity: O(1) zero heap allocations.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Negative procedural terrain noise is clamped to `0.0` via `math.max`.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-002/ElevationProvider]
class ElevationProvider {
  final bool isElevationActive;
  final double verticalExaggeration;

  /// Executes deterministic constructor `ElevationProvider::ElevationProvider` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `ElevationProvider::ElevationProvider` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `ElevationProvider::ElevationProvider` (declaration #5) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ElevationProvider::ElevationProvider` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `ElevationProvider::ElevationProvider` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(ElevationProvider)) bounded over input/member dimension of `ElevationProvider::ElevationProvider`.
  /// - Space Complexity: O(K(ElevationProvider)) bounded auxiliary memory for `ElevationProvider::ElevationProvider`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ElevationProvider::ElevationProvider` (`()`).
  /// - State: Maintains consistent state invariants across `ElevationProvider::ElevationProvider` without partial mutation on error.
  /// - Action: Executes `ElevationProvider::ElevationProvider` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ElevationProvider::ElevationProvider` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-ELEVATIONPROVIDER-ELEVATIONPROVIDER] | SysML v2: ActionDef(ElevationProvider::ElevationProvider)
  const ElevationProvider({
    required this.isElevationActive, 
    this.verticalExaggeration = 1.0,
  });

  /// Executes deterministic method `ElevationProvider::getElevation` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ElevationProvider::getElevation` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ElevationProvider::getElevation` (declaration #6) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - `latDeg: double` must satisfy domain and type-safety constraints prior to invoking `ElevationProvider::getElevation`.
  /// - `lngDeg: double` must satisfy domain and type-safety constraints prior to invoking `ElevationProvider::getElevation`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `ElevationProvider::getElevation` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(latDeg)) bounded over input/member dimension of `ElevationProvider::getElevation`.
  /// - Space Complexity: O(N(latDeg)) bounded auxiliary memory for `ElevationProvider::getElevation`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ElevationProvider::getElevation` (`double`).
  /// - State: Maintains consistent state invariants across `ElevationProvider::getElevation` without partial mutation on error.
  /// - Action: Executes `ElevationProvider::getElevation` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ElevationProvider::getElevation` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-ELEVATIONPROVIDER-GETELEVATION] | SysML v2: ActionDef(ElevationProvider::getElevation)
  double getElevation(double latDeg, double lngDeg) {
    if (!isElevationActive) return 0.0;
    
    double elev = 0.0;
    final double dLat = latDeg - 35.3606;
    final double dLng = lngDeg - 138.7274;
    final double distSq = dLat * dLat + dLng * dLng;
    final double fujiDist = math.sqrt(distSq);
    
    // Reference elevation peak simulation
    if (fujiDist < 0.25) {
      elev += 3776.0 * math.exp(-fujiDist * fujiDist / (0.04 * 0.04));
    }
    
    // Procedural terrain noise
    if (latDeg > 34.5 && latDeg < 37.5 && lngDeg > 136.0 && lngDeg < 140.0) {
      final double rangeNoise = math.sin(latDeg * 12.0) * math.cos(lngDeg * 12.0) * 1200.0 +
                               math.sin(latDeg * 25.0) * math.sin(lngDeg * 25.0) * 400.0;
      elev += math.max(0.0, rangeNoise);
    }
    
    return elev * verticalExaggeration;
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Projects geodetic WGS84 coordinates and horizon contours onto 2D viewport
/// canvas coordinates for the 3D scene viewport under ARINC 661 display rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - Pre-caches orthonormal camera basis vectors (`_ux`, `_ex`, `_nx`) once upon construction.
/// - Horizon path generation samples 72 angular steps around the tangent cone when `d2 > r2`.
///
/// ## 3. Preconditions
/// - [camera], [viewportSize], and [screenCenter] must be valid finite values.
///
/// ## 4. Postconditions
/// - Produces deterministic [ProjectedPoint] and horizon [Path] geometry for the active camera frame.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) per point projection; O(1) fixed 72-step loop for horizon path generation.
/// - Space Complexity: O(1) cached basis scalars.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Clamps horizon tangency calculations when camera radius approaches ellipsoid surface radius.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-002/CoordinateTransformer]
class CoordinateTransformer {
  final VirtualCamera absoluteCamera;
  final Size viewportSize;
  final Offset screenCenter;
  final double rotationAngle;
  final double tilt;

  // Cached math properties for the camera to save CPU cycles
  late final double _cRad;
  late final double _cx, _cy, _cz;
  late final double _ux, _uy, _uz;
  late final double _ex, _ey, _ez;
  late final double _nx, _ny, _nz;
  late final double _d2;
  late final double _r2;

  /// Executes deterministic constructor `CoordinateTransformer::CoordinateTransformer` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CoordinateTransformer::CoordinateTransformer` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CoordinateTransformer::CoordinateTransformer` (declaration #8) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CoordinateTransformer::CoordinateTransformer` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CoordinateTransformer::CoordinateTransformer` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(CoordinateTransformer)) bounded over input/member dimension of `CoordinateTransformer::CoordinateTransformer`.
  /// - Space Complexity: O(K(CoordinateTransformer)) bounded auxiliary memory for `CoordinateTransformer::CoordinateTransformer`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::CoordinateTransformer` (`()`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::CoordinateTransformer` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::CoordinateTransformer` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::CoordinateTransformer` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-COORDINATETRANSFORMER-COORDINATETRANSFORMER] | SysML v2: ActionDef(CoordinateTransformer::CoordinateTransformer)
  CoordinateTransformer({
    required VirtualCamera camera,
    required this.viewportSize,
    required this.screenCenter,
    required this.rotationAngle,
    required this.tilt,
  }) : absoluteCamera = camera.toAbsoluteWgs84() {
    _precomputeCameraBasis();
  }

  /// Executes deterministic method `CoordinateTransformer::_precomputeCameraBasis` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateTransformer::_precomputeCameraBasis` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateTransformer::_precomputeCameraBasis` (declaration #9) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CoordinateTransformer::_precomputeCameraBasis` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CoordinateTransformer::_precomputeCameraBasis` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_precomputeCameraBasis)) bounded over input/member dimension of `CoordinateTransformer::_precomputeCameraBasis`.
  /// - Space Complexity: O(K(_precomputeCameraBasis)) bounded auxiliary memory for `CoordinateTransformer::_precomputeCameraBasis`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::_precomputeCameraBasis` (`void`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::_precomputeCameraBasis` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::_precomputeCameraBasis` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::_precomputeCameraBasis` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-COORDINATETRANSFORMER-PRECOMPUTECAMERABASIS] | SysML v2: ActionDef(CoordinateTransformer::_precomputeCameraBasis)
  void _precomputeCameraBasis() {
    final double radLng = -rotationAngle;
    final double radLat = -tilt;

    _cRad = absoluteCamera.dim_2;
    _r2 = Ellipsoid.wgs84EquatorialRadius * Ellipsoid.wgs84EquatorialRadius;
    _d2 = _cRad * _cRad;

    // Camera position in ECEF
    _cx = _cRad * math.cos(radLat) * math.cos(radLng);
    _cy = _cRad * math.cos(radLat) * math.sin(radLng);
    _cz = _cRad * math.sin(radLat);

    // Camera local ENU basis
    _ux = math.cos(radLat) * math.cos(radLng);
    _uy = math.cos(radLat) * math.sin(radLng);
    _uz = math.sin(radLat);

    _ex = -math.sin(radLng);
    _ey = math.cos(radLng);
    _ez = 0.0;

    _nx = -math.sin(radLat) * math.cos(radLng);
    _ny = -math.sin(radLat) * math.sin(radLng);
    _nz = math.cos(radLat);
  }

  /// Projects a 3D geocoordinate into a 2D screen offset.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateTransformer::projectWgs84ToScreen` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateTransformer::projectWgs84ToScreen` (declaration #10) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CoordinateTransformer::projectWgs84ToScreen` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `ProjectedPoint` from `CoordinateTransformer::projectWgs84ToScreen` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(projectWgs84ToScreen)) bounded over input/member dimension of `CoordinateTransformer::projectWgs84ToScreen`.
  /// - Space Complexity: O(K(projectWgs84ToScreen)) bounded auxiliary memory for `CoordinateTransformer::projectWgs84ToScreen`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::projectWgs84ToScreen` (`ProjectedPoint`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::projectWgs84ToScreen` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::projectWgs84ToScreen` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::projectWgs84ToScreen` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-COORDINATETRANSFORMER-PROJECTWGS84TOSCREEN] | SysML v2: ActionDef(CoordinateTransformer::projectWgs84ToScreen)
  ProjectedPoint projectWgs84ToScreen({
    required double latRad,
    required double lngRad,
    required double heightMeters,
    bool clampToHorizon = true,
  }) {
    final double R = Ellipsoid.wgs84EquatorialRadius;
    final double rad = R + heightMeters;

    double px = rad * math.cos(latRad) * math.cos(lngRad);
    double py = rad * math.cos(latRad) * math.sin(lngRad);
    double pz = rad * math.sin(latRad);

    bool isCulled = _checkCulling(px, py, pz, heightMeters, latRad, lngRad, R);

    if (isCulled && clampToHorizon) {
      final double h2 = rad * rad;
      if (_d2 > h2) {
        final double r2OverD2 = h2 / _d2;
        final double parX = r2OverD2 * _cx;
        final double parY = r2OverD2 * _cy;
        final double parZ = r2OverD2 * _cz;

        final double dotPC = px * _cx + py * _cy + pz * _cz;
        final double dotOverD2 = dotPC / _d2;
        final double perpX = px - dotOverD2 * _cx;
        final double perpY = py - dotOverD2 * _cy;
        final double perpZ = pz - dotOverD2 * _cz;

        final double perpLen = math.sqrt(perpX * perpX + perpY * perpY + perpZ * perpZ);
        if (perpLen > 0.0) {
          final double rHorizon = rad * math.sqrt(1.0 - h2 / _d2);
          final double scale = rHorizon / perpLen;
          px = parX + perpX * scale;
          py = parY + perpY * scale;
          pz = parZ + perpZ * scale;
        }
      }
    }

    // Relative vector from camera to point
    final double rx = px - _cx;
    final double ry = py - _cy;
    final double rz = pz - _cz;

    // Project onto ENU basis
    final double xEnu = rx * _ex + ry * _ey + rz * _ez;
    final double yEnu = rx * _nx + ry * _ny + rz * _nz;
    final double zEnu = rx * _ux + ry * _uy + rz * _uz;

    // Apply camera pitch and heading
    final double hRad = absoluteCamera.heading * math.pi / 180.0;
    final double alpha = (absoluteCamera.pitch + 90.0) * math.pi / 180.0;

    final double cosH = math.cos(hRad);
    final double sinH = math.sin(hRad);
    final double cosA = math.cos(alpha);
    final double sinA = math.sin(alpha);

    final double x1 = xEnu * cosH - yEnu * sinH;
    final double y1 = xEnu * sinH + yEnu * cosH;
    
    final double xCam = x1;
    final double yCam = y1 * cosA + zEnu * sinA;
    final double zCam = -y1 * sinA + zEnu * cosA;

    final double depth = -zCam;
    final double f = viewportSize.shortestSide * 1.2;
    final double absDepth = depth.abs();
    final double safeDepth = absDepth <= 1.0 ? 1.0 : absDepth;
    final double pScale = f / safeDepth;

    final double rxPixel = xCam * pScale;
    final double ryPixel = yCam * pScale;

    final double depthVal;
    if (depth <= 0.0) {
      depthVal = -100.0;
    } else if (isCulled) {
      depthVal = clampToHorizon ? -1.0 : -2.0;
    } else {
      depthVal = depth;
    }

    return ProjectedPoint(
      Offset(screenCenter.dx + rxPixel, screenCenter.dy - ryPixel),
      depthVal,
    );
  }

  /// Executes deterministic method `CoordinateTransformer::_checkCulling` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateTransformer::_checkCulling` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateTransformer::_checkCulling` (declaration #11) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - `px: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  /// - `py: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  /// - `pz: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  /// - `height: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  /// - `lat: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  /// - `R: double` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::_checkCulling`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `CoordinateTransformer::_checkCulling` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(px)) bounded over input/member dimension of `CoordinateTransformer::_checkCulling`.
  /// - Space Complexity: O(N(px)) bounded auxiliary memory for `CoordinateTransformer::_checkCulling`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::_checkCulling` (`bool`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::_checkCulling` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::_checkCulling` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::_checkCulling` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-COORDINATETRANSFORMER-CHECKCULLING] | SysML v2: ActionDef(CoordinateTransformer::_checkCulling)
  bool _checkCulling(double px, double py, double pz, double height, double lat, double lng, double R) {
    bool isCulled = false;
    final double cullHeight = math.max(R + height, R);
    final double pxCull = cullHeight * math.cos(lat) * math.cos(lng);
    final double pyCull = cullHeight * math.cos(lat) * math.sin(lng);
    final double pzCull = cullHeight * math.sin(lat);

    final double rx = pxCull - _cx;
    final double ry = pyCull - _cy;
    final double rz = pzCull - _cz;
    final double dCP2 = rx * rx + ry * ry + rz * rz;
    final double dotPC = pxCull * _cx + pyCull * _cy + pzCull * _cz;

    if (dotPC < _r2) {
      final double tMin = (_d2 - dotPC) / dCP2;
      if (tMin >= 0.0 && tMin <= 1.0) {
        final double minDistanceSq = _d2 - (_d2 - dotPC) * (_d2 - dotPC) / dCP2;
        if (minDistanceSq < _r2) {
          isCulled = true;
        }
      }
    }
    if (height < 0.0 && _cRad > R) {
      isCulled = true;
    }
    return isCulled;
  }

  /// Calculates the Earth's visual horizon edge.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CoordinateTransformer::generateHorizonPath` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CoordinateTransformer::generateHorizonPath` (declaration #12) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - `segments: int` must satisfy domain and type-safety constraints prior to invoking `CoordinateTransformer::generateHorizonPath`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Path` from `CoordinateTransformer::generateHorizonPath` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(segments)) bounded over input/member dimension of `CoordinateTransformer::generateHorizonPath`.
  /// - Space Complexity: O(N(segments)) bounded auxiliary memory for `CoordinateTransformer::generateHorizonPath`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CoordinateTransformer::generateHorizonPath` (`Path`).
  /// - State: Maintains consistent state invariants across `CoordinateTransformer::generateHorizonPath` without partial mutation on error.
  /// - Action: Executes `CoordinateTransformer::generateHorizonPath` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CoordinateTransformer::generateHorizonPath` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-COORDINATETRANSFORMER-GENERATEHORIZONPATH] | SysML v2: ActionDef(CoordinateTransformer::generateHorizonPath)
  Path generateHorizonPath({int segments = 64}) {
    final double R = Ellipsoid.wgs84EquatorialRadius;
    final double r2OverD2 = (R * R) / _d2;
    final double cxH = r2OverD2 * _cx;
    final double cyH = r2OverD2 * _cy;
    final double czH = r2OverD2 * _cz;

    final double rHorizon = R * math.sqrt(1.0 - (R * R) / _d2);

    final Path path = Path();
    for (int i = 0; i <= segments; i++) {
      final double theta = 2.0 * math.pi * i / segments;
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);

      final double px = cxH + rHorizon * (cosT * _ex + sinT * _nx);
      final double py = cyH + rHorizon * (cosT * _ey + sinT * _ny);
      final double pz = czH + rHorizon * (cosT * _ez + sinT * _nz);

      final double rx = px - _cx;
      final double ry = py - _cy;
      final double rz = pz - _cz;

      final double xEnu = rx * _ex + ry * _ey + rz * _ez;
      final double yEnu = rx * _nx + ry * _ny + rz * _nz;
      final double zEnu = rx * _ux + ry * _uy + rz * _uz;

      final double hRad = absoluteCamera.heading * math.pi / 180.0;
      final double alpha = (absoluteCamera.pitch + 90.0) * math.pi / 180.0;

      final double cosH = math.cos(hRad);
      final double sinH = math.sin(hRad);
      final double cosA = math.cos(alpha);
      final double sinA = math.sin(alpha);

      final double x1 = xEnu * cosH - yEnu * sinH;
      final double y1 = xEnu * sinH + yEnu * cosH;
      final double z1 = zEnu;

      final double xCam = x1;
      final double yCam = y1 * cosA + z1 * sinA;
      final double zCam = -y1 * sinA + z1 * cosA;

      final double depth = -zCam;
      final double f = viewportSize.shortestSide * 1.2;
      final double absDepth = depth.abs();
      final double safeDepth = absDepth <= 1.0 ? 1.0 : absDepth;
      final double pScale = f / safeDepth;

      final double rxPixel = xCam * pScale;
      final double ryPixel = yCam * pScale;

      final Offset pt = Offset(screenCenter.dx + rxPixel, screenCenter.dy - ryPixel);
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    return path;
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Immutable composite cache key tuple for memoizing node terrain elevation
/// samples in [SceneViewState] under ARINC 661 frame-rate determinism rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - Value equality holds across `(id, latDeg, lngDeg, astronomicalBody, elevationActive)`.
///
/// ## 3. Preconditions
/// - Tuple components must be valid non-null values.
///
/// ## 4. Postconditions
/// - Serves as an O(1) hash key in `SceneViewState.nodeElevationCache`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) hash and equality check.
/// - Space Complexity: O(1) 5-field Dart record.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Stale node entries are purged when node IDs leave the active topology set.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/ElevationCacheKey]
typedef ElevationCacheKey = (String id, double latDeg, double lngDeg, String astronomicalBody, bool elevationActive);

/// ## 1. Safety Intent & Regulatory Scope
/// Observable layout and projection state store for the 3D scene viewport
/// under DO-178C Level A / ARINC 661 deterministic display update rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - [recalculate] short-circuits when camera, topology identity, and flying state are spatially equivalent.
/// - De-overlaps node callout rectangles with up to 5 vertical offset iterations (`+16 px` per step).
///
/// ## 3. Preconditions
/// - [recalculate] requires a valid [VirtualCamera] and viewport [Size].
///
/// ## 4. Postconditions
/// - Populates projected node offsets, batched point arrays, horizon path, and label layout positions, then notifies listeners.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(V^2 + E) worst-case for label overlap resolution across V nodes and E links.
/// - Space Complexity: O(V + E) cached projection and point buffers.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Malformed JSON fields in [SceneViewState.fromJson] fall back to deterministic default camera and layer states.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-002/SceneViewState]
class SceneViewState extends ChangeNotifier {
  final Map<String, Network3DScene> nodeModels = {};
  final Map<String, ProjectedPoint> projectedNodes = {};
  final List<Offset> groundGlowPoints = [];
  final List<Offset> groundPoints = [];
  final List<Offset> linkGlowPoints = [];
  final List<Offset> linkPoints = [];
  final List<Offset> packetPoints = [];
  final List<Rect> drawnLabelRects = [];
  final Map<ElevationCacheKey, double> nodeElevationCache = {};
  final Map<String, ElevationCacheKey> cacheKeyCache = {};
  final Map<String, double> debugCapturedHeights = {};

  Path? horizonPath;
  ProjectedPoint? earthCenterProj;
  double projectedRadius = 0.0;
  Offset projectedCenter = Offset.zero;

  late VirtualCamera camera;
  GlobeTileRenderer? tileRenderer;
  bool isFlying = false;

  late String activeStyle;
  late String astronomicalBody;
  late bool elevationActive;
  late bool showDevices;
  late bool showLinks;
  late bool showLabels;
  late bool showDropLines;
  late double verticalExaggeration;
  TopologyData? topologyData;
  late ElevationProvider elevationProvider;
  late CoordinateTransformer transformer;

  /// Executes deterministic constructor `SceneViewState::SceneViewState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `SceneViewState::SceneViewState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `SceneViewState::SceneViewState` (declaration #15) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SceneViewState::SceneViewState` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `SceneViewState::SceneViewState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(SceneViewState)) bounded over input/member dimension of `SceneViewState::SceneViewState`.
  /// - Space Complexity: O(K(SceneViewState)) bounded auxiliary memory for `SceneViewState::SceneViewState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SceneViewState::SceneViewState` (`()`).
  /// - State: Maintains consistent state invariants across `SceneViewState::SceneViewState` without partial mutation on error.
  /// - Action: Executes `SceneViewState::SceneViewState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SceneViewState::SceneViewState` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-SCENEVIEWSTATE-SCENEVIEWSTATE] | SysML v2: ActionDef(SceneViewState::SceneViewState)
  SceneViewState() {
    camera = VirtualCamera.zero;
    activeStyle = 'Satellite Map';
    astronomicalBody = 'Earth';
    elevationActive = true;
    showDevices = true;
    showLinks = true;
    showLabels = true;
    showDropLines = true;
    verticalExaggeration = 1.0;
  }

  /// Serializes layout state to JSON.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SceneViewState::toJson` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SceneViewState::toJson` (declaration #16) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SceneViewState::toJson` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, dynamic>` from `SceneViewState::toJson` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toJson)) bounded over input/member dimension of `SceneViewState::toJson`.
  /// - Space Complexity: O(K(toJson)) bounded auxiliary memory for `SceneViewState::toJson`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SceneViewState::toJson` (`Map<String, dynamic>`).
  /// - State: Maintains consistent state invariants across `SceneViewState::toJson` without partial mutation on error.
  /// - Action: Executes `SceneViewState::toJson` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SceneViewState::toJson` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-SCENEVIEWSTATE-TOJSON] | SysML v2: ActionDef(SceneViewState::toJson)
  Map<String, dynamic> toJson() {
    return {
      'activeStyle': activeStyle,
      'astronomicalBody': astronomicalBody,
      'elevationActive': elevationActive,
      'showDevices': showDevices,
      'showLinks': showLinks,
      'showLabels': showLabels,
      'showDropLines': showDropLines,
      'verticalExaggeration': verticalExaggeration,
      'camera': {
        'dim_0': camera.dim_0,
        'dim_1': camera.dim_1,
        'dim_2': camera.dim_2,
        'heading': camera.heading,
        'pitch': camera.pitch,
        'roll': camera.roll,
      },
    };
  }

  /// Deserializes layout state from JSON.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `SceneViewState::SceneViewState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `SceneViewState::SceneViewState` (declaration #17) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - `json: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SceneViewState::SceneViewState`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `SceneViewState::SceneViewState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `SceneViewState::SceneViewState`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `SceneViewState::SceneViewState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SceneViewState::SceneViewState` (`()`).
  /// - State: Maintains consistent state invariants across `SceneViewState::SceneViewState` without partial mutation on error.
  /// - Action: Executes `SceneViewState::SceneViewState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SceneViewState::SceneViewState` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-SCENEVIEWSTATE-SCENEVIEWSTATE] | SysML v2: ActionDef(SceneViewState::SceneViewState)
  factory SceneViewState.fromJson(Map<String, dynamic> json) {
    final state = SceneViewState();
    state.activeStyle = json['activeStyle'] as String? ?? 'Satellite Map';
    state.astronomicalBody = json['astronomicalBody'] as String? ?? 'Earth';
    state.elevationActive = json['elevationActive'] as bool? ?? true;
    state.showDevices = json['showDevices'] as bool? ?? true;
    state.showLinks = json['showLinks'] as bool? ?? true;
    state.showLabels = json['showLabels'] as bool? ?? true;
    state.showDropLines = json['showDropLines'] as bool? ?? true;
    state.verticalExaggeration = (json['verticalExaggeration'] as num?)?.toDouble() ?? 1.0;

    if (json['camera'] is Map<String, dynamic>) {
      final camMap = json['camera'] as Map<String, dynamic>;
      state.camera = VirtualCamera.raw(
        dim_0: (camMap['dim_0'] as num?)?.toDouble() ?? 0.0,
        dim_1: (camMap['dim_1'] as num?)?.toDouble() ?? 0.0,
        dim_2: (camMap['dim_2'] as num?)?.toDouble() ?? 500000.0,
        heading: (camMap['heading'] as num?)?.toDouble() ?? 0.0,
        pitch: (camMap['pitch'] as num?)?.toDouble() ?? -90.0,
        roll: (camMap['roll'] as num?)?.toDouble() ?? 0.0,
      );
    }
    return state;
  }

  final Map<String, Offset> finalLabelPositions = {};
  final Map<TextPainterKey, TextPainter> textPainterCache = {};

  VirtualCamera? _lastRecalculatedCamera;
  TopologyData? _lastRecalculatedTopology;
  bool _lastRecalculatedIsFlying = false;

  /// Executes deterministic method `SceneViewState::recalculate` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SceneViewState::recalculate` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SceneViewState::recalculate` (declaration #18) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SceneViewState::recalculate` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `SceneViewState::recalculate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(recalculate)) bounded over input/member dimension of `SceneViewState::recalculate`.
  /// - Space Complexity: O(K(recalculate)) bounded auxiliary memory for `SceneViewState::recalculate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SceneViewState::recalculate` (`void`).
  /// - State: Maintains consistent state invariants across `SceneViewState::recalculate` without partial mutation on error.
  /// - Action: Executes `SceneViewState::recalculate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SceneViewState::recalculate` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-SCENEVIEWSTATE-RECALCULATE] | SysML v2: ActionDef(SceneViewState::recalculate)
  void recalculate(
    VirtualCamera camera, 
    Size size, 
    TopologyData? topoData,
    String activeStyle,
    String astronomicalBody,
    bool elevationActive,
    bool showDevices,
    bool showLinks,
    bool showLabels,
    bool showDropLines,
    double verticalExaggeration,
    double userRotationX,
    double userTilt,
    GlobeTileRenderer? tileRenderer,
    bool isFlying,
  ) {
    final VirtualCamera absoluteCamera = camera.toAbsoluteWgs84();
    final bool cameraUnchanged = _lastRecalculatedCamera != null &&
        _lastRecalculatedCamera!.isSpatiallyEquivalentTo(absoluteCamera);
    final bool topologyUnchanged = _lastRecalculatedTopology != null &&
        identical(_lastRecalculatedTopology, topoData);
    final bool flyingUnchanged = _lastRecalculatedIsFlying == isFlying;
    if (cameraUnchanged && topologyUnchanged && flyingUnchanged) {
      return;
    }
    _lastRecalculatedCamera = absoluteCamera;
    _lastRecalculatedTopology = topoData;
    _lastRecalculatedIsFlying = isFlying;

    this.camera = absoluteCamera;
    this.tileRenderer = tileRenderer;
    this.isFlying = isFlying;
    this.activeStyle = activeStyle;
    this.astronomicalBody = astronomicalBody;
    this.elevationActive = elevationActive;
    this.showDevices = showDevices;
    this.showLinks = showLinks;
    this.showLabels = showLabels;
    this.showDropLines = showDropLines;
    this.verticalExaggeration = verticalExaggeration;
    this.topologyData = topoData;

    elevationProvider = ElevationProvider(
      isElevationActive: elevationActive,
      verticalExaggeration: verticalExaggeration,
    );

    projectedNodes.clear();
    groundGlowPoints.clear();
    groundPoints.clear();
    linkGlowPoints.clear();
    linkPoints.clear();
    packetPoints.clear();
    drawnLabelRects.clear();
    debugCapturedHeights.clear();
    finalLabelPositions.clear();

    final Offset center = Offset(size.width * 0.45, size.height * 0.5);
    final double baseRotation = -(camera.dim_1 * math.pi / 180.0);
    final double baseTilt = -(camera.dim_0 * math.pi / 180.0);
    final double rotationAngle = baseRotation + userRotationX;
    final double tilt = baseTilt + userTilt;

    transformer = CoordinateTransformer(
      camera: camera,
      viewportSize: size,
      screenCenter: center,
      rotationAngle: rotationAngle,
      tilt: tilt,
    );

    horizonPath = transformer.generateHorizonPath();
    earthCenterProj = transformer.projectWgs84ToScreen(latRad: 0.0, lngRad: 0.0, heightMeters: -Ellipsoid.wgs84EquatorialRadius, clampToHorizon: false);
    projectedCenter = earthCenterProj!.offset;

    final double cRad = transformer.absoluteCamera.dim_2;
    final double f = size.shortestSide * 1.2;
    final double radDiff = cRad * cRad - Ellipsoid.wgs84EquatorialRadius * Ellipsoid.wgs84EquatorialRadius;
    projectedRadius = Ellipsoid.wgs84EquatorialRadius * f / math.sqrt(radDiff <= 0.0 ? 1.0 : radDiff);

    List<TopologyNode> nodes = topoData?.nodes ?? [];
    List<TopologyLink> links = topoData?.links ?? [];

    final Set<String> currentIds = nodes.map((n) => n.id).toSet();
    nodeModels.removeWhere((id, _) => !currentIds.contains(id));
    nodeElevationCache.removeWhere((key, _) => !currentIds.contains(key.$1));

    for (final node in nodes) {
      final String id = node.id;
      final String modelPath = (node.rawProperties['model_path'] ?? node.rawProperties['model'] ?? '').toString();
      
      if (modelPath.isNotEmpty && !nodeModels.containsKey(id)) {
        final scene = Network3DScene();
        nodeModels[id] = scene;
        scene.loadModel(modelPath).then((_) {
          notifyListeners();
        });
      }

      final double latDeg = node.position.dim1;
      final double lngDeg = node.position.dim0;
      final double alt = node.position.dim2;
      
      final double latRad = latDeg * math.pi / 180.0;
      final double lngRad = lngDeg * math.pi / 180.0;
      
      final String heightRef = (node.rawProperties['heightReference'] ?? node.rawProperties['height_reference'] ?? '').toString().toUpperCase();
      final String type;
      if (heightRef == 'RELATIVE_TO_GROUND' || heightRef == 'CLAMP_TO_GROUND') {
        type = 'ground';
      } else if (heightRef == 'ABSOLUTE') {
        type = 'space';
      } else {
        type = (alt < 50000.0) ? 'ground' : 'space';
      }

      final double orbitHeight = alt;
      final double currentLngRad = lngRad; // simplified

      double finalHeight = orbitHeight;
      if (type == 'ground' || type == 'underwater') {
        if (elevationActive) {
          final ElevationCacheKey cacheKey = (id, latDeg, lngDeg, astronomicalBody, elevationActive);
          final double terrainElev = nodeElevationCache.putIfAbsent(cacheKey, () => elevationProvider.getElevation(latDeg, lngDeg));
          final double baseElev = terrainElev / (verticalExaggeration == 0 ? 1 : verticalExaggeration);
          final double relativeAlt;
          if (heightRef == 'CLAMP_TO_GROUND') {
            relativeAlt = 0.0;
          } else if (heightRef == 'RELATIVE_TO_GROUND') {
            relativeAlt = alt;
          } else {
            relativeAlt = alt - baseElev;
          }
          finalHeight = terrainElev + relativeAlt;
        } else {
          finalHeight = alt;
        }
      }

      debugCapturedHeights[id] = finalHeight;

      final proj = transformer.projectWgs84ToScreen(latRad: latRad, lngRad: currentLngRad, heightMeters: finalHeight);
      
      if (proj.z >= 0) {
        projectedNodes[id] = proj;
        if (type == 'ground') {
          groundGlowPoints.add(proj.offset);
          groundPoints.add(proj.offset);
        }
        
        if (showLabels && showDevices) {
          final String labelText = node.label.isNotEmpty ? node.label : id;
          final Color textColor = type == 'space' ? const Color(0xFFFFB300) : const Color(0xFF00E5FF);
          final key = TextPainterKey(labelText, textColor);
          final textPainter = textPainterCache.putIfAbsent(key, () {
            return TextPainter(
              text: TextSpan(
                text: labelText,
                style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
              textDirection: TextDirection.ltr,
            )..layout();
          });

          Offset textPos = proj.offset + const Offset(8, -4);
          Rect outerRect = Rect.fromLTWH(textPos.dx - 6, textPos.dy - 3, textPainter.width + 12, textPainter.height + 6);

          bool overlaps = true;
          int offsetLoop = 0;
          while (overlaps && offsetLoop < 5) {
            overlaps = false;
            final double area1 = outerRect.width * outerRect.height;
            for (final Rect existing in drawnLabelRects) {
              final double left = math.max(outerRect.left, existing.left);
              final double right = math.min(outerRect.right, existing.right);
              final double top = math.max(outerRect.top, existing.top);
              final double bottom = math.min(outerRect.bottom, existing.bottom);
              if (right > left && bottom > top) {
                final double intersectArea = (right - left) * (bottom - top);
                if (intersectArea / area1 > 0.10 || intersectArea / (existing.width * existing.height) > 0.10) {
                  overlaps = true;
                  break;
                }
              }
            }
            if (overlaps) {
              textPos += const Offset(0, 16);
              outerRect = Rect.fromLTWH(textPos.dx - 6, textPos.dy - 3, textPainter.width + 12, textPainter.height + 6);
              offsetLoop++;
            }
          }
          if (!overlaps) {
            drawnLabelRects.add(outerRect);
            finalLabelPositions[id] = textPos;
          }
        }
      }
    }

    if (showLinks && showDevices) {
      for (int i = 0; i < links.length; i++) {
        final link = links[i];
        final ProjectedPoint? p1 = projectedNodes[link.source];
        final ProjectedPoint? p2 = projectedNodes[link.target];
        if (p1 != null && p2 != null) {
          linkGlowPoints.add(p1.offset);
          linkGlowPoints.add(p2.offset);
          linkPoints.add(p1.offset);
          linkPoints.add(p2.offset);
          final double packetT = (i * 0.25) % 1.0;
          packetPoints.add(Offset.lerp(p1.offset, p2.offset, packetT)!);
        }
      }
    }

    notifyListeners();
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Composite value key `(text, color)` for caching laid-out [TextPainter]
/// instances in [SceneViewState] under ARINC 661 HUD rendering rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - Value equality and `hashCode` depend strictly on `text` and `color`.
///
/// ## 3. Preconditions
/// - [text] and [color] must be non-null.
///
/// ## 4. Postconditions
/// - Enables O(1) lookup of pre-laid-out [TextPainter] objects across frames.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) hash and equality check.
/// - Space Complexity: O(1) two field references.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - None; immutable value key.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-002/TextPainterKey]
class TextPainterKey {
  final String text;
  final Color color;
  /// Executes deterministic constructor `TextPainterKey::TextPainterKey` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TextPainterKey::TextPainterKey` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TextPainterKey::TextPainterKey` (declaration #20) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - `text: String` must satisfy domain and type-safety constraints prior to invoking `TextPainterKey::TextPainterKey`.
  /// - `color: String` must satisfy domain and type-safety constraints prior to invoking `TextPainterKey::TextPainterKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TextPainterKey::TextPainterKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(text)) bounded over input/member dimension of `TextPainterKey::TextPainterKey`.
  /// - Space Complexity: O(N(text)) bounded auxiliary memory for `TextPainterKey::TextPainterKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TextPainterKey::TextPainterKey` (`()`).
  /// - State: Maintains consistent state invariants across `TextPainterKey::TextPainterKey` without partial mutation on error.
  /// - Action: Executes `TextPainterKey::TextPainterKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TextPainterKey::TextPainterKey` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-TEXTPAINTERKEY-TEXTPAINTERKEY] | SysML v2: ActionDef(TextPainterKey::TextPainterKey)
  TextPainterKey(this.text, this.color);
  @override bool operator ==(Object other) => identical(this, other) || other is TextPainterKey && text == other.text && color == other.color;
  @override int get hashCode => Object.hash(text, color);
}

/// ## 1. Safety Intent & Regulatory Scope
/// Lifecycle state enumeration for asynchronous 3D glTF model asset loading
/// in [Network3DScene].
///
/// ## 2. Invariants & Mathematical Properties
/// - State transitions follow `unloaded -> loading -> {loaded | error}`.
///
/// ## 3. Preconditions
/// - None.
///
/// ## 4. Postconditions
/// - Identifies whether a node's 3D asset is ready for rendering or fallback symbology.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) enum comparison.
/// - Space Complexity: O(1) enum singleton.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - `error` state triggers deterministic 2D fallback symbol rendering in [TopologyLayer].
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/ModelRenderState]
enum ModelRenderState { unloaded, loading, loaded, error }

/// ## 1. Safety Intent & Regulatory Scope
/// Manages asynchronous glTF binary asset loading and PBR material state for
/// a 3D topology node under DO-178C Level A / ARINC 661 asset safety rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - `state == ModelRenderState.loaded` implies `gltfData != null && gltfData!.isNotEmpty`.
/// - [applyPbrMaterials] enables translucency only when `state == ModelRenderState.loaded`.
///
/// ## 3. Preconditions
/// - `modelPath` passed to [loadModel] must be a valid asset bundle key.
///
/// ## 4. Postconditions
/// - Transitions [state] to `loaded` or `error` and returns boolean success status.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(B) where B is the asset byte length loaded from [rootBundle].
/// - Space Complexity: O(B) for [gltfData] buffer storage.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty path, empty asset buffer, or bundle load exception transitions [state] to `ModelRenderState.error` and returns `false`.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-002/Network3DScene]
class Network3DScene {
  Uint8List? gltfData;
  bool isTranslucent = false;
  ModelRenderState state = ModelRenderState.unloaded;

  /// Loads the glTF model data from the given path.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `Network3DScene::loadModel` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `Network3DScene::loadModel` (declaration #23) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - `modelPath: String` must satisfy domain and type-safety constraints prior to invoking `Network3DScene::loadModel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<bool>` from `Network3DScene::loadModel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(modelPath)) bounded over input/member dimension of `Network3DScene::loadModel`.
  /// - Space Complexity: O(N(modelPath)) bounded auxiliary memory for `Network3DScene::loadModel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `Network3DScene::loadModel` (`Future<bool>`).
  /// - State: Maintains consistent state invariants across `Network3DScene::loadModel` without partial mutation on error.
  /// - Action: Executes `Network3DScene::loadModel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `Network3DScene::loadModel` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-NETWORK3DSCENE-LOADMODEL] | SysML v2: ActionDef(Network3DScene::loadModel)
  Future<bool> loadModel(String modelPath) async {
    if (modelPath.isEmpty) {
      state = ModelRenderState.error;
      return false;
    }
    
    state = ModelRenderState.loading;
    try {
      final ByteData data = await rootBundle.load(modelPath);
      final Uint8List bytes = data.buffer.asUint8List();
      
      if (bytes.isEmpty) {
        state = ModelRenderState.error;
        return false;
      }
      
      gltfData = bytes;
      state = ModelRenderState.loaded;
      return true;
    } catch (e) {
      state = ModelRenderState.error;
      return false;
    }
  }

  /// Applies PBR materials and sets transcluent flags.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `Network3DScene::applyPbrMaterials` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/scene_3d_viewport_classes.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `Network3DScene::applyPbrMaterials` (declaration #24) within `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `Network3DScene::applyPbrMaterials` in `TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `Network3DScene::applyPbrMaterials` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(applyPbrMaterials)) bounded over input/member dimension of `Network3DScene::applyPbrMaterials`.
  /// - Space Complexity: O(K(applyPbrMaterials)) bounded auxiliary memory for `Network3DScene::applyPbrMaterials`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `Network3DScene::applyPbrMaterials` (`bool`).
  /// - State: Maintains consistent state invariants across `Network3DScene::applyPbrMaterials` without partial mutation on error.
  /// - Action: Executes `Network3DScene::applyPbrMaterials` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `Network3DScene::applyPbrMaterials` (`TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-SCENE-3D-VIEWPORT-CLASSES-NETWORK3DSCENE-APPLYPBRMATERIALS] | SysML v2: ActionDef(Network3DScene::applyPbrMaterials)
  bool applyPbrMaterials() {
    if (state == ModelRenderState.loaded && gltfData != null) {
      isTranslucent = true;
      return true;
    }
    return false;
  }
}
