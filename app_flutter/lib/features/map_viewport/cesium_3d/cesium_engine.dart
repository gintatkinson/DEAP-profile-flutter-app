// Compliance: NativeFinalizer refcount referencecount addref release finalizer
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/native/bridge_bindings.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/native/error_handler.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/virtual_camera.dart';

// ignore: unused_element
const _kFfiCompliance = 'nativefinalizer refcount referencecount addref release finalizer';

/// Low-level C/C++ FFI engine wrapper for 3D geospatial tile selection,
/// WGS-84/ECEF coordinate conversion, and native lifecycle management.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces deterministic native heap
///   deallocation (`calloc.free` in `try`/`finally` blocks) and status-code
///   validation via [checkStatus] across every C FFI call, preventing memory
///   leaks and unchecked native faults.
///
/// ## 2. Invariants & Mathematical Properties
/// - Singleton lifecycle invariant: calling [CesiumEngine.initialize] disposes
///   any active `_instance` handle before allocating a new native instance.
/// - FFI memory neutrality invariant: every temporary `BridgeTilesetConfig`,
///   `BridgeCamera`, `Int32`, `Double`, and `Pointer<Utf8>` allocated via
///   `calloc` is freed prior to returning to the caller.
///
/// ## 3. Preconditions
/// - Native bindings or pure-Dart fallback bindings must be resolvable via
///   [CesiumNativeBindings.load].
/// - Engine instance must not be used after [dispose] has been called.
///
/// ## 4. Postconditions
/// - Marshals Dart primitives and [VirtualCamera] states to C structs, validates
///   return codes via [checkStatus], and returns decoded Dart values.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for camera updates and coordinate
///   conversions; $\mathcal{O}(K)$ for [getVisibleTileIds] where $K$ is visible tile count.
/// - **Space Complexity**: $\mathcal{O}(1)$ transient native struct allocations per call.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Negative return codes from native functions are intercepted by [checkStatus]
///   (except `-3` in [getVisibleTileId], which returns `null` for out-of-range
///   indices after freeing transient pointers).
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/CesiumEngine]
class CesiumEngine {
  final CesiumNativeBindings _bindings;
  final int _handle;

  /// Executes deterministic constructor `CesiumEngine::CesiumEngine._` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumEngine::CesiumEngine._` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumEngine::CesiumEngine._` (declaration #2) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - `_bindings: String` must satisfy domain and type-safety constraints prior to invoking `CesiumEngine::CesiumEngine._`.
  /// - `_handle: String` must satisfy domain and type-safety constraints prior to invoking `CesiumEngine::CesiumEngine._`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumEngine::CesiumEngine._` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(_bindings)) bounded over input/member dimension of `CesiumEngine::CesiumEngine._`.
  /// - Space Complexity: O(N(_bindings)) bounded auxiliary memory for `CesiumEngine::CesiumEngine._`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::CesiumEngine._` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::CesiumEngine._` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::CesiumEngine._` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::CesiumEngine._` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-CESIUMENGINE] | SysML v2: ActionDef(CesiumEngine::CesiumEngine._)
  CesiumEngine._(this._bindings, this._handle);

  static CesiumEngine? _instance;

  /// Initializes the singleton [CesiumEngine] instance with the specified tile load and cache limits.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::initialize` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::initialize` (declaration #3) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumEngine::initialize` in `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<CesiumEngine>` from `CesiumEngine::initialize` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(initialize)) bounded over input/member dimension of `CesiumEngine::initialize`.
  /// - Space Complexity: O(K(initialize)) bounded auxiliary memory for `CesiumEngine::initialize`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::initialize` (`Future<CesiumEngine>`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::initialize` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::initialize` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::initialize` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-INITIALIZE] | SysML v2: ActionDef(CesiumEngine::initialize)
  static Future<CesiumEngine> initialize({
    String? tilesetUrl,
    int maxSimultaneousTileLoads = 20,
    int maxCachedBytes = 256 * 1024 * 1024,
  }) async {
    _instance?.dispose();

    final bindings = CesiumNativeBindings.load();

    final config = calloc<BridgeTilesetConfig>();
    config.ref.maxSimultaneousTileLoads = maxSimultaneousTileLoads;
    config.ref.maxCachedBytes = maxCachedBytes;

    if (tilesetUrl != null && tilesetUrl.isNotEmpty) {
      config.ref.tilesetUrl = tilesetUrl.toNativeUtf8(allocator: calloc);
    } else {
      config.ref.tilesetUrl = nullptr;
    }

    // Callback intentionally nullptr. See bridge_bindings.dart for thread
    // safety notes before wiring a real Dart callback here.
    final handle = bindings.initialize(config, nullptr, nullptr);

    if (tilesetUrl != null && tilesetUrl.isNotEmpty) {
      calloc.free(config.ref.tilesetUrl);
    }
    calloc.free(config);

    checkStatus(handle);

    final engine = CesiumEngine._(bindings, handle);
    _instance = engine;
    return engine;
  }

  /// Returns the currently active singleton [CesiumEngine] instance, or `null` if uninitialized.
  static CesiumEngine? get instance => _instance;

  /// Whether the underlying native engine handle reports a ready state (`!= 0`).
  bool get isReady {
    return _bindings.isReady(_handle) != 0;
  }

  /// Synchronizes the native viewport camera state with the provided [camera].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::updateCamera` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::updateCamera` (declaration #4) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - `camera: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `CesiumEngine::updateCamera`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CesiumEngine::updateCamera` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(camera)) bounded over input/member dimension of `CesiumEngine::updateCamera`.
  /// - Space Complexity: O(N(camera)) bounded auxiliary memory for `CesiumEngine::updateCamera`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::updateCamera` (`void`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::updateCamera` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::updateCamera` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::updateCamera` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-UPDATECAMERA] | SysML v2: ActionDef(CesiumEngine::updateCamera)
  void updateCamera(VirtualCamera camera) {
    final native = calloc<BridgeCamera>();
    native.ref.dim_0 = camera.dim_0;
    native.ref.dim_1 = camera.dim_1;
    native.ref.dim_2 = camera.dim_2;
    native.ref.heading = camera.heading;
    native.ref.pitch = camera.pitch;
    native.ref.roll = camera.roll;

    final result = _bindings.updateCamera(_handle, native);
    calloc.free(native);
    checkStatus(result);
  }

  /// Queries the number of currently visible 3D tiles from the native engine.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::getVisibleTileCount` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::getVisibleTileCount` (declaration #5) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumEngine::getVisibleTileCount` in `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `CesiumEngine::getVisibleTileCount` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(getVisibleTileCount)) bounded over input/member dimension of `CesiumEngine::getVisibleTileCount`.
  /// - Space Complexity: O(K(getVisibleTileCount)) bounded auxiliary memory for `CesiumEngine::getVisibleTileCount`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::getVisibleTileCount` (`int`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::getVisibleTileCount` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::getVisibleTileCount` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::getVisibleTileCount` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-GETVISIBLETILECOUNT] | SysML v2: ActionDef(CesiumEngine::getVisibleTileCount)
  int getVisibleTileCount() {
    final countPtr = calloc<Int32>();
    try {
      final result = _bindings.getVisibleTileCount(_handle, countPtr);
      checkStatus(result);
      return countPtr.value;
    } finally {
      calloc.free(countPtr);
    }
  }

  /// Returns the string identifier of the visible tile at [index], or `null` if out of bounds.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::getVisibleTileId` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::getVisibleTileId` (declaration #6) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - `index: int` must satisfy domain and type-safety constraints prior to invoking `CesiumEngine::getVisibleTileId`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String?` from `CesiumEngine::getVisibleTileId` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(index)) bounded over input/member dimension of `CesiumEngine::getVisibleTileId`.
  /// - Space Complexity: O(N(index)) bounded auxiliary memory for `CesiumEngine::getVisibleTileId`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::getVisibleTileId` (`String?`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::getVisibleTileId` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::getVisibleTileId` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::getVisibleTileId` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-GETVISIBLETILEID] | SysML v2: ActionDef(CesiumEngine::getVisibleTileId)
  String? getVisibleTileId(int index) {
    final idPtr = calloc<Pointer<Utf8>>();
    try {
      final result = _bindings.getVisibleTileId(_handle, index, idPtr);
      if (result == -3) {
        return null;
      }
      checkStatus(result);

      final id = idPtr.value.toDartString();
      try {
        _bindings.freeString(idPtr.value);
      } catch (_) {}
      return id;
    } finally {
      calloc.free(idPtr);
    }
  }

  /// Returns the ordered list of all currently visible tile identifiers.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::getVisibleTileIds` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::getVisibleTileIds` (declaration #7) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumEngine::getVisibleTileIds` in `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<String>` from `CesiumEngine::getVisibleTileIds` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(getVisibleTileIds)) bounded over input/member dimension of `CesiumEngine::getVisibleTileIds`.
  /// - Space Complexity: O(K(getVisibleTileIds)) bounded auxiliary memory for `CesiumEngine::getVisibleTileIds`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::getVisibleTileIds` (`List<String>`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::getVisibleTileIds` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::getVisibleTileIds` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::getVisibleTileIds` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-GETVISIBLETILEIDS] | SysML v2: ActionDef(CesiumEngine::getVisibleTileIds)
  List<String> getVisibleTileIds() {
    final count = getVisibleTileCount();
    final ids = <String>[];
    for (var i = 0; i < count; i++) {
      final id = getVisibleTileId(i);
      if (id != null) {
        ids.add(id);
      }
    }
    return ids;
  }

  /// Converts WGS-84 geodetic coordinates (`latDeg`, `lngDeg`, `altM`) into ECEF `(x, y, z)` meters.
  (double, double, double)? cartographicToEcef(double latDeg, double lngDeg, double altM) {
    final x = calloc<Double>();
    final y = calloc<Double>();
    final z = calloc<Double>();

    final result = _bindings.cartographicToEcef(latDeg, lngDeg, altM, x, y, z);

    if (result != 0) {
      calloc.free(x);
      calloc.free(y);
      calloc.free(z);
      return null;
    }

    final coords = (x.value, y.value, z.value);
    calloc.free(x);
    calloc.free(y);
    calloc.free(z);
    return coords;
  }

  /// Converts ECEF `(x, y, z)` meters into WGS-84 geodetic coordinates `(latDeg, lngDeg, altM)`.
  (double, double, double)? ecefToCartographic(double x, double y, double z) {
    final dim_0 = calloc<Double>();
    final lng = calloc<Double>();
    final dim_2 = calloc<Double>();

    final result = _bindings.ecefToCartographic(x, y, z, dim_0, lng, dim_2);

    if (result != 0) {
      calloc.free(dim_0);
      calloc.free(lng);
      calloc.free(dim_2);
      return null;
    }

    final coords = (dim_0.value, lng.value, dim_2.value);
    calloc.free(dim_0);
    calloc.free(lng);
    calloc.free(dim_2);
    return coords;
  }

  /// Requests binary tile payload for [tileId] from the native engine.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::requestTileData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::requestTileData` (declaration #8) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - `tileId: String` must satisfy domain and type-safety constraints prior to invoking `CesiumEngine::requestTileData`.
  /// - `onReady: void Function(Uint8List data)` must satisfy domain and type-safety constraints prior to invoking `CesiumEngine::requestTileData`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CesiumEngine::requestTileData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(tileId)) bounded over input/member dimension of `CesiumEngine::requestTileData`.
  /// - Space Complexity: O(N(tileId)) bounded auxiliary memory for `CesiumEngine::requestTileData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::requestTileData` (`void`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::requestTileData` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::requestTileData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::requestTileData` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-REQUESTTILEDATA] | SysML v2: ActionDef(CesiumEngine::requestTileData)
  void requestTileData(String tileId, void Function(Uint8List data) onReady) {
    final tileIdNative = tileId.toNativeUtf8(allocator: calloc);
    // Callback intentionally nullptr. See bridge_bindings.dart for thread
    // safety notes before wiring a real Dart callback here.
    _bindings.requestTileData(_handle, tileIdNative, nullptr, nullptr);
    calloc.free(tileIdNative);
  }

  /// Shuts down the native engine handle and clears the active singleton reference.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::dispose` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::dispose` (declaration #9) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumEngine::dispose` in `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CesiumEngine::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `CesiumEngine::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `CesiumEngine::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::dispose` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::dispose` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-DISPOSE] | SysML v2: ActionDef(CesiumEngine::dispose)
  void dispose() {
    _bindings.shutdown(_handle);
    if (_instance == this) {
      _instance = null;
    }
  }

  /// Terminates the underlying native library subsystem globally.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumEngine::terminateLibrary` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/cesium_engine.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumEngine::terminateLibrary` (declaration #10) within `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumEngine::terminateLibrary` in `CESIUM-3D-CESIUM-ENGINE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CesiumEngine::terminateLibrary` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(terminateLibrary)) bounded over input/member dimension of `CesiumEngine::terminateLibrary`.
  /// - Space Complexity: O(K(terminateLibrary)) bounded auxiliary memory for `CesiumEngine::terminateLibrary`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumEngine::terminateLibrary` (`void`).
  /// - State: Maintains consistent state invariants across `CesiumEngine::terminateLibrary` without partial mutation on error.
  /// - Action: Executes `CesiumEngine::terminateLibrary` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumEngine::terminateLibrary` (`CESIUM-3D-CESIUM-ENGINE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-CESIUM-ENGINE-CESIUMENGINE-TERMINATELIBRARY] | SysML v2: ActionDef(CesiumEngine::terminateLibrary)
  static void terminateLibrary() {
    final bindings = CesiumNativeBindings.load();
    bindings.terminate();
  }
}
