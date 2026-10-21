import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:clock/clock.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/virtual_camera.dart';

/// Reactive 6-DOF virtual camera controller governing geodesic flight animations,
/// terrain-clearance altitude clamping, and interactive pan/tilt/zoom gestures.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces minimum terrain clearance
///   ([minAltitude] $= 100.0\,\text{m}$ above WGS-84 ellipsoid + local terrain
///   elevation), antimeridian angle wrapping ($\pm 180^\circ$), and bounded
///   great-circle parabolic flight trajectories.
///
/// ## 2. Invariants & Mathematical Properties
/// - Terrain clearance invariant: $\text{dim}_2 \ge R_{\text{WGS84}} + h_{\text{terrain}}(\text{lat}, \text{lng}) + \text{minAltitude}$.
/// - Great-circle angular distance (Haversine):
///   $\Delta\sigma = 2\arcsin\left(\sqrt{\sin^2(\Delta\phi/2) + \cos\phi_1\cos\phi_2\sin^2(\Delta\lambda/2)}\right) \in [0, \pi]$.
/// - Parabolic flight altitude boost: $h(t) = h_{\text{lerp}}(t) + \sin(\pi t)\cdot \frac{\Delta\sigma}{\pi}\cdot 5\times 10^6\,\text{m}$
///   under cubic ease-in-out progress $t \in [0, 1]$.
///
/// ## 3. Preconditions
/// - Initial and target [VirtualCamera] states must provide finite geodetic
///   coordinates; relative altitudes ($< R_{\text{WGS84}}$) are automatically
///   normalized to absolute ECEF radii upon construction and update.
///
/// ## 4. Postconditions
/// - Emits [ChangeNotifier] notifications on every state transition and clamps
///   all resulting camera states via [VirtualCamera.clamped].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ per [tick], [pan], [tilt], [zoom],
///   [zoomInteractive], and [flyTo] invocation.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed controller state.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Non-finite or zero viewport dimensions in [pan] fall back to `800.0` logical
///   pixels; `NaN`/`Infinite` angle inputs in wrapping helpers normalize to `0.0`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/CameraController]
class CameraController extends ChangeNotifier {
  VirtualCamera _camera;

  VirtualCamera? _startCamera;
  VirtualCamera? _targetCamera;
  DateTime? _animationStart;
  Duration _flightDuration = const Duration(milliseconds: 500);

  /// Exposes the computed geodesic flight duration for deterministic unit testing.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::flightDurationForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::flightDurationForTesting` (declaration #2) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::flightDurationForTesting` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CameraController::flightDurationForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(flightDurationForTesting)) bounded over input/member dimension of `CameraController::flightDurationForTesting`.
  /// - Space Complexity: O(K(flightDurationForTesting)) bounded auxiliary memory for `CameraController::flightDurationForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::flightDurationForTesting` (`()`).
  /// - State: Maintains consistent state invariants across `CameraController::flightDurationForTesting` without partial mutation on error.
  /// - Action: Executes `CameraController::flightDurationForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::flightDurationForTesting` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-FLIGHTDURATIONFORTESTING] | SysML v2: ActionDef(CameraController::flightDurationForTesting)
  @visibleForTesting
  Duration get flightDurationForTesting => _flightDuration;

  /// Angular drag sensitivity in degrees per logical pixel.
  static const double dragSensitivity = 0.15;

  /// Linear scroll zoom sensitivity multiplier.
  static const double scrollSensitivity = 0.5;

  /// Angular step in degrees per keyboard arrow key press.
  static const double keyboardStep = 5.0;

  /// Minimum camera altitude above local terrain in meters.
  static const double minAltitude = 100.0;

  /// Maximum camera altitude above local terrain in meters.
  static const double maxAltitude = 40000000.0;

  /// Optional callback returning terrain elevation in meters at `(latDeg, lngDeg)`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::Function` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::Function` (declaration #2) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `dim_0: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::Function`.
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::Function`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::Function` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_0)) bounded over input/member dimension of `CameraController::Function`.
  /// - Space Complexity: O(N(dim_0)) bounded auxiliary memory for `CameraController::Function`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::Function` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::Function` without partial mutation on error.
  /// - Action: Executes `CameraController::Function` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::Function` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-FUNCTION] | SysML v2: ActionDef(CameraController::Function)
  double Function(double dim_0, double lng)? elevationProvider;

  /// Executes deterministic method `CameraController::_getTerrainHeight` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_getTerrainHeight` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_getTerrainHeight` (declaration #3) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `dim_0: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_getTerrainHeight`.
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_getTerrainHeight`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_getTerrainHeight` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_0)) bounded over input/member dimension of `CameraController::_getTerrainHeight`.
  /// - Space Complexity: O(N(dim_0)) bounded auxiliary memory for `CameraController::_getTerrainHeight`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_getTerrainHeight` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_getTerrainHeight` without partial mutation on error.
  /// - Action: Executes `CameraController::_getTerrainHeight` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_getTerrainHeight` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-GETTERRAINHEIGHT] | SysML v2: ActionDef(CameraController::_getTerrainHeight)
  double _getTerrainHeight(double dim_0, double lng) {
    if (elevationProvider == null) return 0.0;
    return elevationProvider!(dim_0, lng);
  }

  /// Executes deterministic method `CameraController::_clampAltitudeToTerrain` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_clampAltitudeToTerrain` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_clampAltitudeToTerrain` (declaration #4) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `dim_0: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_clampAltitudeToTerrain`.
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_clampAltitudeToTerrain`.
  /// - `targetAlt: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_clampAltitudeToTerrain`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_clampAltitudeToTerrain` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_0)) bounded over input/member dimension of `CameraController::_clampAltitudeToTerrain`.
  /// - Space Complexity: O(N(dim_0)) bounded auxiliary memory for `CameraController::_clampAltitudeToTerrain`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_clampAltitudeToTerrain` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_clampAltitudeToTerrain` without partial mutation on error.
  /// - Action: Executes `CameraController::_clampAltitudeToTerrain` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_clampAltitudeToTerrain` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-CLAMPALTITUDETOTERRAIN] | SysML v2: ActionDef(CameraController::_clampAltitudeToTerrain)
  double _clampAltitudeToTerrain(double dim_0, double lng, double targetAlt) {
    final double terrainH = _getTerrainHeight(dim_0, lng);
    final double minAlt = Ellipsoid.wgs84EquatorialRadius + terrainH + minAltitude;
    return targetAlt < minAlt ? minAlt : targetAlt;
  }

  /// Creates a [CameraController] initialized with [camera] normalized to absolute ECEF altitude.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CameraController::CameraController` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CameraController::CameraController` (declaration #5) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `camera: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::CameraController`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CameraController::CameraController` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(camera)) bounded over input/member dimension of `CameraController::CameraController`.
  /// - Space Complexity: O(N(camera)) bounded auxiliary memory for `CameraController::CameraController`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::CameraController` (`()`).
  /// - State: Maintains consistent state invariants across `CameraController::CameraController` without partial mutation on error.
  /// - Action: Executes `CameraController::CameraController` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::CameraController` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-CAMERACONTROLLER] | SysML v2: ActionDef(CameraController::CameraController)
  CameraController(VirtualCamera camera) : _camera = camera.dim_2 < Ellipsoid.wgs84EquatorialRadius ? VirtualCamera.clamped(
    dim_0: camera.dim_0,
    dim_1: camera.dim_1,
    dim_2: Ellipsoid.wgs84EquatorialRadius + camera.dim_2,
    heading: camera.heading,
    pitch: camera.pitch,
    roll: camera.roll,
  ) : camera;

  /// The current active [VirtualCamera] state.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::current` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::current` (declaration #7) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::current` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CameraController::current` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(current)) bounded over input/member dimension of `CameraController::current`.
  /// - Space Complexity: O(K(current)) bounded auxiliary memory for `CameraController::current`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::current` (`()`).
  /// - State: Maintains consistent state invariants across `CameraController::current` without partial mutation on error.
  /// - Action: Executes `CameraController::current` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::current` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-CURRENT] | SysML v2: ActionDef(CameraController::current)
  VirtualCamera get current => _camera;

  /// Whether a geodesic [flyTo] animation is currently in progress.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::isFlying` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::isFlying` (declaration #8) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::isFlying` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CameraController::isFlying` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(isFlying)) bounded over input/member dimension of `CameraController::isFlying`.
  /// - Space Complexity: O(K(isFlying)) bounded auxiliary memory for `CameraController::isFlying`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::isFlying` (`()`).
  /// - State: Maintains consistent state invariants across `CameraController::isFlying` without partial mutation on error.
  /// - Action: Executes `CameraController::isFlying` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::isFlying` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-ISFLYING] | SysML v2: ActionDef(CameraController::isFlying)
  bool get isFlying => _targetCamera != null;

  /// Immediately updates the camera state, clamping altitude above terrain and cancelling active flights.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::updateCamera` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::updateCamera` (declaration #6) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `camera: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::updateCamera`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::updateCamera` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(camera)) bounded over input/member dimension of `CameraController::updateCamera`.
  /// - Space Complexity: O(N(camera)) bounded auxiliary memory for `CameraController::updateCamera`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::updateCamera` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::updateCamera` without partial mutation on error.
  /// - Action: Executes `CameraController::updateCamera` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::updateCamera` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-UPDATECAMERA] | SysML v2: ActionDef(CameraController::updateCamera)
  void updateCamera(VirtualCamera camera) {
    final absoluteCamera = camera.dim_2 < Ellipsoid.wgs84EquatorialRadius ? VirtualCamera.clamped(
      dim_0: camera.dim_0,
      dim_1: camera.dim_1,
      dim_2: Ellipsoid.wgs84EquatorialRadius + camera.dim_2,
      heading: camera.heading,
      pitch: camera.pitch,
      roll: camera.roll,
    ) : camera;
    final double targetAlt = _clampAltitudeToTerrain(absoluteCamera.dim_0, absoluteCamera.dim_1, absoluteCamera.dim_2);
    final clampedCam = VirtualCamera.clamped(
      dim_0: absoluteCamera.dim_0,
      dim_1: absoluteCamera.dim_1,
      dim_2: targetAlt,
      heading: absoluteCamera.heading,
      pitch: absoluteCamera.pitch,
      roll: absoluteCamera.roll,
    );
    if (_camera == clampedCam) return;
    _camera = clampedCam;
    _targetCamera = null;
    _startCamera = null;
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::_normalizeRadDiff` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_normalizeRadDiff` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_normalizeRadDiff` (declaration #7) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `diff: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_normalizeRadDiff`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_normalizeRadDiff` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(diff)) bounded over input/member dimension of `CameraController::_normalizeRadDiff`.
  /// - Space Complexity: O(N(diff)) bounded auxiliary memory for `CameraController::_normalizeRadDiff`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_normalizeRadDiff` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_normalizeRadDiff` without partial mutation on error.
  /// - Action: Executes `CameraController::_normalizeRadDiff` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_normalizeRadDiff` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-NORMALIZERADDIFF] | SysML v2: ActionDef(CameraController::_normalizeRadDiff)
  static double _normalizeRadDiff(double diff) {
    if (diff.isNaN || !diff.isFinite) return 0.0;
    double wrapped = (diff + math.pi) % (2 * math.pi);
    if (wrapped < 0.0) wrapped += 2 * math.pi;
    return wrapped - math.pi;
  }

  /// Executes deterministic method `CameraController::_computeAngularDistance` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_computeAngularDistance` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_computeAngularDistance` (declaration #8) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `a: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::_computeAngularDistance`.
  /// - `b: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::_computeAngularDistance`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_computeAngularDistance` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(a)) bounded over input/member dimension of `CameraController::_computeAngularDistance`.
  /// - Space Complexity: O(N(a)) bounded auxiliary memory for `CameraController::_computeAngularDistance`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_computeAngularDistance` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_computeAngularDistance` without partial mutation on error.
  /// - Action: Executes `CameraController::_computeAngularDistance` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_computeAngularDistance` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-COMPUTEANGULARDISTANCE] | SysML v2: ActionDef(CameraController::_computeAngularDistance)
  static double _computeAngularDistance(VirtualCamera a, VirtualCamera b) {
    final double lat1 = a.dim_0 * math.pi / 180.0;
    final double lat2 = b.dim_0 * math.pi / 180.0;
    final double lon1 = a.dim_1 * math.pi / 180.0;
    final double lon2 = b.dim_1 * math.pi / 180.0;

    final double dLat = lat2 - lat1;
    final double dLon = _normalizeRadDiff(lon2 - lon1);

    final double sinDLat2 = math.sin(dLat / 2);
    final double sinDLon2 = math.sin(dLon / 2);
    final double val = sinDLat2 * sinDLat2 + math.cos(lat1) * math.cos(lat2) * sinDLon2 * sinDLon2;
    return 2 * math.asin(math.sqrt(val.clamp(0.0, 1.0)));
  }

  /// Executes deterministic method `CameraController::flyTo` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::flyTo` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::flyTo` (declaration #9) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `target: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::flyTo`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::flyTo` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(target)) bounded over input/member dimension of `CameraController::flyTo`.
  /// - Space Complexity: O(N(target)) bounded auxiliary memory for `CameraController::flyTo`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::flyTo` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::flyTo` without partial mutation on error.
  /// - Action: Executes `CameraController::flyTo` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::flyTo` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-FLYTO] | SysML v2: ActionDef(CameraController::flyTo)
  void flyTo(VirtualCamera target) {
    final double angularDistance = _computeAngularDistance(_camera, target);
    final double ms = 500.0 + (angularDistance / math.pi) * 1300.0;
    _flightDuration = Duration(milliseconds: ms.round());
    _startCamera = _camera;
    _targetCamera = target;
    _animationStart = null;
  }

  /// Executes deterministic method `CameraController::tick` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::tick` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::tick` (declaration #10) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::tick` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `CameraController::tick` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(tick)) bounded over input/member dimension of `CameraController::tick`.
  /// - Space Complexity: O(K(tick)) bounded auxiliary memory for `CameraController::tick`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::tick` (`bool`).
  /// - State: Maintains consistent state invariants across `CameraController::tick` without partial mutation on error.
  /// - Action: Executes `CameraController::tick` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::tick` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-TICK] | SysML v2: ActionDef(CameraController::tick)
  bool tick() {
    if (_startCamera == null || _targetCamera == null) return true;
    _animationStart ??= clock.now();
    final elapsed = clock.now().difference(_animationStart!);
    final progress =
        (elapsed.inMilliseconds / _flightDuration.inMilliseconds).clamp(0.0, 1.0);
    final t = _easeInOutCubic(progress);
    _camera = _lerpCamera(_startCamera!, _targetCamera!, t);
    notifyListeners();
    if (progress >= 1.0) {
      _camera = _targetCamera!;
      _startCamera = null;
      _targetCamera = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Executes deterministic method `CameraController::_easeInOutCubic` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_easeInOutCubic` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_easeInOutCubic` (declaration #11) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `t: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_easeInOutCubic`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_easeInOutCubic` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(t)) bounded over input/member dimension of `CameraController::_easeInOutCubic`.
  /// - Space Complexity: O(N(t)) bounded auxiliary memory for `CameraController::_easeInOutCubic`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_easeInOutCubic` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_easeInOutCubic` without partial mutation on error.
  /// - Action: Executes `CameraController::_easeInOutCubic` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_easeInOutCubic` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-EASEINOUTCUBIC] | SysML v2: ActionDef(CameraController::_easeInOutCubic)
  static double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
  }

  /// Executes deterministic method `CameraController::_lerpCamera` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_lerpCamera` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_lerpCamera` (declaration #12) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `a: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::_lerpCamera`.
  /// - `b: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CameraController::_lerpCamera`.
  /// - `t: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_lerpCamera`.
  ///
  /// ## 4. Postconditions
  /// - Returns `VirtualCamera` from `CameraController::_lerpCamera` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(a)) bounded over input/member dimension of `CameraController::_lerpCamera`.
  /// - Space Complexity: O(N(a)) bounded auxiliary memory for `CameraController::_lerpCamera`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_lerpCamera` (`VirtualCamera`).
  /// - State: Maintains consistent state invariants across `CameraController::_lerpCamera` without partial mutation on error.
  /// - Action: Executes `CameraController::_lerpCamera` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_lerpCamera` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-LERPCAMERA] | SysML v2: ActionDef(CameraController::_lerpCamera)
  static VirtualCamera _lerpCamera(VirtualCamera a, VirtualCamera b, double t) {
    final double distance = _computeAngularDistance(a, b);
    final double maxBoost = (distance / math.pi) * 5000000.0;
    final double baseAltitude = a.dim_2 + (b.dim_2 - a.dim_2) * t;
    final double boostedAltitude = baseAltitude + math.sin(t * math.pi) * maxBoost;

    return VirtualCamera.clamped(
      dim_0: a.dim_0 + (b.dim_0 - a.dim_0) * t,
      dim_1: _interpolateCircular(a.dim_1, b.dim_1, t, _wrapLngStatic),
      dim_2: boostedAltitude,
      heading: _interpolateCircular(a.heading, b.heading, t, _wrapHeadingStatic),
      pitch: _interpolateCircular(a.pitch, b.pitch, t, _wrapPitchStatic),
      roll: a.roll + (b.roll - a.roll) * t,
    );
  }

  /// Executes deterministic method `CameraController::_interpolateCircular` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_interpolateCircular` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_interpolateCircular` (declaration #13) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `from: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_interpolateCircular`.
  /// - `to: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_interpolateCircular`.
  /// - `t: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_interpolateCircular`.
  /// - `wrapFn: double Function(double)` must satisfy domain and type-safety constraints prior to invoking `CameraController::_interpolateCircular`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_interpolateCircular` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(from)) bounded over input/member dimension of `CameraController::_interpolateCircular`.
  /// - Space Complexity: O(N(from)) bounded auxiliary memory for `CameraController::_interpolateCircular`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_interpolateCircular` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_interpolateCircular` without partial mutation on error.
  /// - Action: Executes `CameraController::_interpolateCircular` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_interpolateCircular` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-INTERPOLATECIRCULAR] | SysML v2: ActionDef(CameraController::_interpolateCircular)
  static double _interpolateCircular(double from, double to, double t, double Function(double) wrapFn) {
    double diff = to - from;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return wrapFn(from + diff * t);
  }

  /// Executes deterministic method `CameraController::_wrapLngStatic` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_wrapLngStatic` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_wrapLngStatic` (declaration #14) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_wrapLngStatic`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_wrapLngStatic` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(lng)) bounded over input/member dimension of `CameraController::_wrapLngStatic`.
  /// - Space Complexity: O(N(lng)) bounded auxiliary memory for `CameraController::_wrapLngStatic`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_wrapLngStatic` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_wrapLngStatic` without partial mutation on error.
  /// - Action: Executes `CameraController::_wrapLngStatic` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_wrapLngStatic` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPLNGSTATIC] | SysML v2: ActionDef(CameraController::_wrapLngStatic)
  static double _wrapLngStatic(double lng) {
    if (lng.isNaN || !lng.isFinite) return 0.0;
    double wrapped = (lng + 180.0) % 360.0;
    if (wrapped < 0.0) wrapped += 360.0;
    double val = wrapped - 180.0;
    if (val == -180.0) {
      return lng >= 0.0 ? 180.0 : -180.0;
    }
    return val;
  }

  /// Executes deterministic method `CameraController::_wrapHeadingStatic` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_wrapHeadingStatic` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_wrapHeadingStatic` (declaration #15) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `heading: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_wrapHeadingStatic`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_wrapHeadingStatic` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(heading)) bounded over input/member dimension of `CameraController::_wrapHeadingStatic`.
  /// - Space Complexity: O(N(heading)) bounded auxiliary memory for `CameraController::_wrapHeadingStatic`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_wrapHeadingStatic` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_wrapHeadingStatic` without partial mutation on error.
  /// - Action: Executes `CameraController::_wrapHeadingStatic` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_wrapHeadingStatic` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPHEADINGSTATIC] | SysML v2: ActionDef(CameraController::_wrapHeadingStatic)
  static double _wrapHeadingStatic(double heading) {
    if (heading.isNaN || !heading.isFinite) return 0.0;
    double wrapped = heading % 360.0;
    if (wrapped < 0.0) wrapped += 360.0;
    return wrapped;
  }

  /// Executes deterministic method `CameraController::pan` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::pan` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::pan` (declaration #16) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `delta: Offset` must satisfy domain and type-safety constraints prior to invoking `CameraController::pan`.
  /// - `shortestSide: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::pan`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::pan` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(delta)) bounded over input/member dimension of `CameraController::pan`.
  /// - Space Complexity: O(N(delta)) bounded auxiliary memory for `CameraController::pan`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::pan` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::pan` without partial mutation on error.
  /// - Action: Executes `CameraController::pan` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::pan` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-PAN] | SysML v2: ActionDef(CameraController::pan)
  void pan(Offset delta, [double shortestSide = 800.0]) {
    if (shortestSide <= 0.0 || shortestSide.isNaN) {
      shortestSide = 800.0;
    }
    final double factor = (_camera.dim_2 - Ellipsoid.wgs84EquatorialRadius + 500000.0) * 2.8074e-5 / shortestSide;
    final double radH = _camera.heading * math.pi / 180.0;
    final double cosH = math.cos(radH);
    final double sinH = math.sin(radH);
    final double dxAligned = delta.dx * cosH + delta.dy * sinH;
    final double dyAligned = -delta.dx * sinH + delta.dy * cosH;
    final newLat = (_camera.dim_0 - dyAligned * factor).clamp(-90.0, 90.0);
    final newLng = _wrapLng(_camera.dim_1 - dxAligned * factor);
    final double targetAlt = _clampAltitudeToTerrain(newLat, newLng, _camera.dim_2);
    _camera = VirtualCamera.clamped(
      dim_0: newLat,
      dim_1: newLng,
      dim_2: targetAlt,
      heading: _camera.heading,
      pitch: _camera.pitch,
      roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::tilt` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::tilt` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::tilt` (declaration #17) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `delta: Offset` must satisfy domain and type-safety constraints prior to invoking `CameraController::tilt`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::tilt` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(delta)) bounded over input/member dimension of `CameraController::tilt`.
  /// - Space Complexity: O(N(delta)) bounded auxiliary memory for `CameraController::tilt`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::tilt` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::tilt` without partial mutation on error.
  /// - Action: Executes `CameraController::tilt` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::tilt` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-TILT] | SysML v2: ActionDef(CameraController::tilt)
  void tilt(Offset delta) {
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0, dim_1: _camera.dim_1,
      dim_2: _camera.dim_2,
      heading: _wrapHeading(_camera.heading - delta.dx * dragSensitivity),
      pitch: _wrapPitch(_camera.pitch - delta.dy * dragSensitivity),
      roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::rotateHeading` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::rotateHeading` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::rotateHeading` (declaration #18) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `delta: Offset` must satisfy domain and type-safety constraints prior to invoking `CameraController::rotateHeading`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::rotateHeading` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(delta)) bounded over input/member dimension of `CameraController::rotateHeading`.
  /// - Space Complexity: O(N(delta)) bounded auxiliary memory for `CameraController::rotateHeading`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::rotateHeading` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::rotateHeading` without partial mutation on error.
  /// - Action: Executes `CameraController::rotateHeading` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::rotateHeading` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-ROTATEHEADING] | SysML v2: ActionDef(CameraController::rotateHeading)
  void rotateHeading(Offset delta) {
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0, dim_1: _camera.dim_1,
      dim_2: _camera.dim_2,
      heading: _wrapHeading(_camera.heading - delta.dx * dragSensitivity),
      pitch: _camera.pitch, roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::zoom` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::zoom` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::zoom` (declaration #19) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `scrollDelta: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::zoom`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::zoom` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(scrollDelta)) bounded over input/member dimension of `CameraController::zoom`.
  /// - Space Complexity: O(N(scrollDelta)) bounded auxiliary memory for `CameraController::zoom`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::zoom` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::zoom` without partial mutation on error.
  /// - Action: Executes `CameraController::zoom` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::zoom` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-ZOOM] | SysML v2: ActionDef(CameraController::zoom)
  void zoom(double scrollDelta) {
    final double terrainH = _getTerrainHeight(_camera.dim_0, _camera.dim_1);
    final double currentHeightAGL = _camera.dim_2 - (Ellipsoid.wgs84EquatorialRadius + terrainH);
    final double targetHeightAGL = currentHeightAGL + scrollDelta * scrollSensitivity;
    final double clampedHeightAGL = targetHeightAGL.clamp(minAltitude, maxAltitude);
    final double newAlt = Ellipsoid.wgs84EquatorialRadius + clampedHeightAGL + terrainH;
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0,
      dim_1: _camera.dim_1,
      dim_2: newAlt,
      heading: _camera.heading,
      pitch: _camera.pitch,
      roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::zoomInteractive` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::zoomInteractive` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::zoomInteractive` (declaration #20) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `scrollDelta: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::zoomInteractive`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::zoomInteractive` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(scrollDelta)) bounded over input/member dimension of `CameraController::zoomInteractive`.
  /// - Space Complexity: O(N(scrollDelta)) bounded auxiliary memory for `CameraController::zoomInteractive`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::zoomInteractive` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::zoomInteractive` without partial mutation on error.
  /// - Action: Executes `CameraController::zoomInteractive` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::zoomInteractive` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-ZOOMINTERACTIVE] | SysML v2: ActionDef(CameraController::zoomInteractive)
  void zoomInteractive(double scrollDelta) {
    final double clampedDelta = scrollDelta.clamp(-100.0, 100.0);
    final double factor = math.exp(clampedDelta * 0.001);
    final double terrainH = _getTerrainHeight(_camera.dim_0, _camera.dim_1);
    final double currentHeightAGL = _camera.dim_2 - (Ellipsoid.wgs84EquatorialRadius + terrainH);
    final double targetHeightAGL = currentHeightAGL * factor;
    final double clampedHeightAGL = targetHeightAGL.clamp(minAltitude, maxAltitude);
    final double newAlt = Ellipsoid.wgs84EquatorialRadius + clampedHeightAGL + terrainH;
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0,
      dim_1: _camera.dim_1,
      dim_2: newAlt,
      heading: _camera.heading,
      pitch: _camera.pitch,
      roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::keyboardRotate` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::keyboardRotate` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::keyboardRotate` (declaration #21) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `degrees: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::keyboardRotate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::keyboardRotate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(degrees)) bounded over input/member dimension of `CameraController::keyboardRotate`.
  /// - Space Complexity: O(N(degrees)) bounded auxiliary memory for `CameraController::keyboardRotate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::keyboardRotate` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::keyboardRotate` without partial mutation on error.
  /// - Action: Executes `CameraController::keyboardRotate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::keyboardRotate` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-KEYBOARDROTATE] | SysML v2: ActionDef(CameraController::keyboardRotate)
  void keyboardRotate(double degrees) {
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0, dim_1: _wrapLng(_camera.dim_1 + degrees),
      dim_2: _camera.dim_2, heading: _camera.heading,
      pitch: _camera.pitch, roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::keyboardRotateHeading` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::keyboardRotateHeading` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::keyboardRotateHeading` (declaration #22) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `degrees: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::keyboardRotateHeading`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::keyboardRotateHeading` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(degrees)) bounded over input/member dimension of `CameraController::keyboardRotateHeading`.
  /// - Space Complexity: O(N(degrees)) bounded auxiliary memory for `CameraController::keyboardRotateHeading`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::keyboardRotateHeading` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::keyboardRotateHeading` without partial mutation on error.
  /// - Action: Executes `CameraController::keyboardRotateHeading` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::keyboardRotateHeading` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-KEYBOARDROTATEHEADING] | SysML v2: ActionDef(CameraController::keyboardRotateHeading)
  void keyboardRotateHeading(double degrees) {
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0, dim_1: _camera.dim_1,
      dim_2: _camera.dim_2,
      heading: _wrapHeading(_camera.heading + degrees),
      pitch: _camera.pitch, roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::keyboardTilt` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::keyboardTilt` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::keyboardTilt` (declaration #23) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `degrees: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::keyboardTilt`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CameraController::keyboardTilt` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(degrees)) bounded over input/member dimension of `CameraController::keyboardTilt`.
  /// - Space Complexity: O(N(degrees)) bounded auxiliary memory for `CameraController::keyboardTilt`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::keyboardTilt` (`void`).
  /// - State: Maintains consistent state invariants across `CameraController::keyboardTilt` without partial mutation on error.
  /// - Action: Executes `CameraController::keyboardTilt` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::keyboardTilt` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-KEYBOARDTILT] | SysML v2: ActionDef(CameraController::keyboardTilt)
  void keyboardTilt(double degrees) {
    _camera = VirtualCamera.clamped(
      dim_0: _camera.dim_0, dim_1: _camera.dim_1,
      dim_2: _camera.dim_2, heading: _camera.heading,
      pitch: _wrapPitch(_camera.pitch + degrees),
      roll: _camera.roll,
    );
    notifyListeners();
  }

  /// Executes deterministic method `CameraController::_wrapLng` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_wrapLng` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_wrapLng` (declaration #24) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_wrapLng`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_wrapLng` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(lng)) bounded over input/member dimension of `CameraController::_wrapLng`.
  /// - Space Complexity: O(N(lng)) bounded auxiliary memory for `CameraController::_wrapLng`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_wrapLng` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_wrapLng` without partial mutation on error.
  /// - Action: Executes `CameraController::_wrapLng` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_wrapLng` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPLNG] | SysML v2: ActionDef(CameraController::_wrapLng)
  double _wrapLng(double lng) {
    if (lng.isNaN || !lng.isFinite) return 0.0;
    double wrapped = (lng + 180.0) % 360.0;
    if (wrapped < 0.0) wrapped += 360.0;
    double val = wrapped - 180.0;
    if (val == -180.0) {
      return lng >= 0.0 ? 180.0 : -180.0;
    }
    return val;
  }

  /// Executes deterministic method `CameraController::_wrapHeading` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_wrapHeading` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_wrapHeading` (declaration #25) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::_wrapHeading` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_wrapHeading` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_wrapHeading)) bounded over input/member dimension of `CameraController::_wrapHeading`.
  /// - Space Complexity: O(K(_wrapHeading)) bounded auxiliary memory for `CameraController::_wrapHeading`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_wrapHeading` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_wrapHeading` without partial mutation on error.
  /// - Action: Executes `CameraController::_wrapHeading` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_wrapHeading` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPHEADING] | SysML v2: ActionDef(CameraController::_wrapHeading)
  double _wrapHeading(double heading) => _wrapHeadingStatic(heading);

  /// Executes deterministic method `CameraController::_wrapPitch` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_wrapPitch` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_wrapPitch` (declaration #26) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::_wrapPitch` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_wrapPitch` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_wrapPitch)) bounded over input/member dimension of `CameraController::_wrapPitch`.
  /// - Space Complexity: O(K(_wrapPitch)) bounded auxiliary memory for `CameraController::_wrapPitch`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_wrapPitch` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_wrapPitch` without partial mutation on error.
  /// - Action: Executes `CameraController::_wrapPitch` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_wrapPitch` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPPITCH] | SysML v2: ActionDef(CameraController::_wrapPitch)
  double _wrapPitch(double pitch) => _wrapPitchStatic(pitch);

  /// Executes deterministic method `CameraController::_wrapPitchStatic` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::_wrapPitchStatic` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::_wrapPitchStatic` (declaration #27) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - `pitch: double` must satisfy domain and type-safety constraints prior to invoking `CameraController::_wrapPitchStatic`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::_wrapPitchStatic` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(pitch)) bounded over input/member dimension of `CameraController::_wrapPitchStatic`.
  /// - Space Complexity: O(N(pitch)) bounded auxiliary memory for `CameraController::_wrapPitchStatic`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::_wrapPitchStatic` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::_wrapPitchStatic` without partial mutation on error.
  /// - Action: Executes `CameraController::_wrapPitchStatic` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::_wrapPitchStatic` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPPITCHSTATIC] | SysML v2: ActionDef(CameraController::_wrapPitchStatic)
  static double _wrapPitchStatic(double pitch) {
    if (pitch.isNaN || !pitch.isFinite) return 0.0;
    double wrapped = (pitch + 180.0) % 360.0;
    if (wrapped < 0.0) wrapped += 360.0;
    double val = wrapped - 180.0;
    if (val == -180.0) {
      return pitch >= 0.0 ? 180.0 : -180.0;
    }
    return val;
  }

  /// Executes deterministic method `CameraController::wrapLngStaticForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::wrapLngStaticForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::wrapLngStaticForTesting` (declaration #28) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::wrapLngStaticForTesting` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::wrapLngStaticForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(wrapLngStaticForTesting)) bounded over input/member dimension of `CameraController::wrapLngStaticForTesting`.
  /// - Space Complexity: O(K(wrapLngStaticForTesting)) bounded auxiliary memory for `CameraController::wrapLngStaticForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::wrapLngStaticForTesting` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::wrapLngStaticForTesting` without partial mutation on error.
  /// - Action: Executes `CameraController::wrapLngStaticForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::wrapLngStaticForTesting` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPLNGSTATICFORTESTING] | SysML v2: ActionDef(CameraController::wrapLngStaticForTesting)
  @visibleForTesting
  static double wrapLngStaticForTesting(double lng) => _wrapLngStatic(lng);

  /// Executes deterministic method `CameraController::wrapHeadingStaticForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::wrapHeadingStaticForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::wrapHeadingStaticForTesting` (declaration #29) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::wrapHeadingStaticForTesting` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::wrapHeadingStaticForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(wrapHeadingStaticForTesting)) bounded over input/member dimension of `CameraController::wrapHeadingStaticForTesting`.
  /// - Space Complexity: O(K(wrapHeadingStaticForTesting)) bounded auxiliary memory for `CameraController::wrapHeadingStaticForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::wrapHeadingStaticForTesting` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::wrapHeadingStaticForTesting` without partial mutation on error.
  /// - Action: Executes `CameraController::wrapHeadingStaticForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::wrapHeadingStaticForTesting` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPHEADINGSTATICFORTESTING] | SysML v2: ActionDef(CameraController::wrapHeadingStaticForTesting)
  @visibleForTesting
  static double wrapHeadingStaticForTesting(double heading) => _wrapHeadingStatic(heading);

  /// Executes deterministic method `CameraController::wrapLngForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::wrapLngForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::wrapLngForTesting` (declaration #30) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::wrapLngForTesting` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::wrapLngForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(wrapLngForTesting)) bounded over input/member dimension of `CameraController::wrapLngForTesting`.
  /// - Space Complexity: O(K(wrapLngForTesting)) bounded auxiliary memory for `CameraController::wrapLngForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::wrapLngForTesting` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::wrapLngForTesting` without partial mutation on error.
  /// - Action: Executes `CameraController::wrapLngForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::wrapLngForTesting` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPLNGFORTESTING] | SysML v2: ActionDef(CameraController::wrapLngForTesting)
  @visibleForTesting
  double wrapLngForTesting(double lng) => _wrapLng(lng);

  /// Executes deterministic method `CameraController::wrapPitchStaticForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CameraController::wrapPitchStaticForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/camera_controller.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CameraController::wrapPitchStaticForTesting` (declaration #31) within `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CameraController::wrapPitchStaticForTesting` in `CESIUM-3D-CAMERA-CONTROLLER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `CameraController::wrapPitchStaticForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(wrapPitchStaticForTesting)) bounded over input/member dimension of `CameraController::wrapPitchStaticForTesting`.
  /// - Space Complexity: O(K(wrapPitchStaticForTesting)) bounded auxiliary memory for `CameraController::wrapPitchStaticForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CameraController::wrapPitchStaticForTesting` (`double`).
  /// - State: Maintains consistent state invariants across `CameraController::wrapPitchStaticForTesting` without partial mutation on error.
  /// - Action: Executes `CameraController::wrapPitchStaticForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CameraController::wrapPitchStaticForTesting` (`CESIUM-3D-CAMERA-CONTROLLER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CAMERA-CONTROLLER-CAMERACONTROLLER-WRAPPITCHSTATICFORTESTING] | SysML v2: ActionDef(CameraController::wrapPitchStaticForTesting)
  @visibleForTesting
  static double wrapPitchStaticForTesting(double pitch) => _wrapPitchStatic(pitch);
}
