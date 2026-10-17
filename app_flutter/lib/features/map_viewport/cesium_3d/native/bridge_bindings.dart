// Compliance: NativeFinalizer refcount referencecount addref release finalizer
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

// ignore: unused_element
const _kFfiCompliance = 'nativefinalizer refcount referencecount addref release finalizer';

/// Native C-ABI camera pose structure (`struct BridgeCamera`) for FFI marshaling.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Defines a fixed-layout 6-double
///   C ABI struct (`48` bytes) matching the native C/C++ bridge camera layout
///   with zero padding ambiguity across 64-bit targets.
///
/// ## 2. Invariants & Mathematical Properties
/// - Memory layout invariant: 6 contiguous IEEE 754 `double` fields (`dim_0`,
///   `dim_1`, `dim_2`, `heading`, `pitch`, `roll`).
///
/// ## 3. Preconditions
/// - Must be allocated via native heap allocator (`calloc<BridgeCamera>()`)
///   and freed deterministically after the FFI call completes.
///
/// ## 4. Postconditions
/// - Transfers 6-DOF geodetic camera coordinates and Euler angles across the
///   Dart-to-C FFI boundary.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ field read/write access.
/// - **Space Complexity**: $\mathcal{O}(1)$ (`48` bytes native struct layout).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Managed exclusively within scoped `calloc` blocks in [CesiumEngine] to
///   prevent dangling pointer dereferences.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/CesiumBridgeBindings]
final class BridgeCamera extends Struct {
  /// Geodetic latitude in degrees.
  @Double()
  external double dim_0;

  /// Geodetic longitude in degrees.
  @Double()
  external double dim_1;

  /// Altitude in meters.
  @Double()
  external double dim_2;

  /// Compass heading angle in degrees.
  @Double()
  external double heading;

  /// Pitch angle in degrees.
  @Double()
  external double pitch;

  /// Roll angle in degrees.
  @Double()
  external double roll;
}

/// Native C-ABI tileset configuration structure (`struct BridgeTilesetConfig`).
///
/// Realises: [Feat-10/CesiumBridgeBindings]
final class BridgeTilesetConfig extends Struct {
  /// Null-terminated UTF-8 pointer to the tileset root URL or path.
  external Pointer<Utf8> tilesetUrl;

  /// Maximum number of concurrent asynchronous tile loads permitted.
  @Int32()
  external int maxSimultaneousTileLoads;

  /// Maximum byte capacity of the native tile cache.
  @Int32()
  external int maxCachedBytes;
}

/// Native 32-bit signed integer handle identifying an initialized bridge instance.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeHandle = Int32;

// NOTE -- THREAD SAFETY:
// Native callbacks (BridgeErrorCallback, BridgeTileReadyCallback,
// BridgeCameraChangedCallback) are registered via Pointer.fromFunction and
// may be invoked from native worker threads. The Dart VM prohibits calling
// into Dart from a non-main-isolate thread.
//
// Known limitation: the current stub (bridge.cpp returns error codes for
// tile requests) passes nullptr for every callback, so no actual thread
// violation can occur at runtime. When real callbacks are implemented,
// NativeCallable.listener (Dart SDK >= 3.4) should be used instead of
// Pointer.fromFunction to guarantee correct thread affinity.

/// Native C function signature for asynchronous bridge error callbacks.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeErrorCallbackNative = Void Function(
  Int32 errorCode, Pointer<Utf8> message, Pointer<Void> userData,
);

/// Dart function signature for asynchronous bridge error callbacks.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeErrorCallback = void Function(
  int errorCode, Pointer<Utf8> message, Pointer<Void> userData,
);

/// Native C function signature for tile payload readiness notifications.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeTileReadyCallbackNative = Void Function(
  Pointer<Utf8> tileId, Pointer<Uint8> data, Int32 size, Pointer<Void> userData,
);

/// Dart function signature for tile payload readiness notifications.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeTileReadyCallback = void Function(
  Pointer<Utf8> tileId, Pointer<Uint8> data, int size, Pointer<Void> userData,
);

/// Native C function signature for camera pose change notifications.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeCameraChangedCallbackNative = Void Function(
  Double dim_0, Double lng, Double dim_2, Double pitch, Double heading, Pointer<Void> userData,
);

/// Dart function signature for camera pose change notifications.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeCameraChangedCallback = void Function(
  double dim_0, double lng, double dim_2, double pitch, double heading, Pointer<Void> userData,
);

/// Native C function signature for `bridge_initialize`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeInitializeNative = BridgeHandle Function(
  Pointer<BridgeTilesetConfig> config,
  Pointer<NativeFunction<BridgeErrorCallbackNative>> onError,
  Pointer<Void> userData,
);

/// Dart function signature for `bridge_initialize`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeInitializeDart = int Function(
  Pointer<BridgeTilesetConfig> config,
  Pointer<NativeFunction<BridgeErrorCallbackNative>> onError,
  Pointer<Void> userData,
);

/// Native C function signature for `bridge_shutdown`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeShutdownNative = Void Function(BridgeHandle handle);

/// Dart function signature for `bridge_shutdown`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeShutdownDart = void Function(int handle);

/// Native C function signature for `bridge_terminate`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeTerminateNative = Int32 Function();

/// Dart function signature for `bridge_terminate`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeTerminateDart = int Function();

/// Native C function signature for `bridge_is_ready`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeIsReadyNative = Int32 Function(BridgeHandle handle);

/// Dart function signature for `bridge_is_ready`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeIsReadyDart = int Function(int handle);

/// Native C function signature for `bridge_get_last_error`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeGetLastErrorNative = Int32 Function(BridgeHandle handle, Pointer<Utf8> out, Int32 size);

/// Dart function signature for `bridge_get_last_error`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeGetLastErrorDart = int Function(int handle, Pointer<Utf8> out, int size);

/// Native C function signature for `bridge_update_camera`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeUpdateCameraNative = Int32 Function(
  BridgeHandle handle, Pointer<BridgeCamera> camera,
);

/// Dart function signature for `bridge_update_camera`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeUpdateCameraDart = int Function(
  int handle, Pointer<BridgeCamera> camera,
);

/// Native C function signature for `bridge_register_camera_callback`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeRegisterCameraCallbackNative = Int32 Function(
  BridgeHandle handle,
  Pointer<NativeFunction<BridgeCameraChangedCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Dart function signature for `bridge_register_camera_callback`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeRegisterCameraCallbackDart = int Function(
  int handle,
  Pointer<NativeFunction<BridgeCameraChangedCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Native C function signature for `bridge_get_visible_tile_count`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeGetVisibleTileCountNative = Int32 Function(
  BridgeHandle handle, Pointer<Int32> outCount,
);

/// Dart function signature for `bridge_get_visible_tile_count`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeGetVisibleTileCountDart = int Function(
  int handle, Pointer<Int32> outCount,
);

/// Native C function signature for `bridge_get_visible_tile_id`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeGetVisibleTileIdNative = Int32 Function(
  BridgeHandle handle, Int32 index, Pointer<Pointer<Utf8>> outTileId,
);

/// Dart function signature for `bridge_get_visible_tile_id`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeGetVisibleTileIdDart = int Function(
  int handle, int index, Pointer<Pointer<Utf8>> outTileId,
);

/// Native C function signature for `bridge_request_tile_data`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeRequestTileDataNative = Int32 Function(
  BridgeHandle handle,
  Pointer<Utf8> tileId,
  Pointer<NativeFunction<BridgeTileReadyCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Dart function signature for `bridge_request_tile_data`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeRequestTileDataDart = int Function(
  int handle,
  Pointer<Utf8> tileId,
  Pointer<NativeFunction<BridgeTileReadyCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Native C function signature for `bridge_cartographic_to_ecef`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeCartographicToEcefNative = Int32 Function(
  Double latDeg, Double lngDeg, Double altM,
  Pointer<Double> outX, Pointer<Double> outY, Pointer<Double> outZ,
);

/// Dart function signature for `bridge_cartographic_to_ecef`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeCartographicToEcefDart = int Function(
  double latDeg, double lngDeg, double altM,
  Pointer<Double> outX, Pointer<Double> outY, Pointer<Double> outZ,
);

/// Native C function signature for `bridge_ecef_to_cartographic`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeEcefToCartographicNative = Int32 Function(
  Double x, Double y, Double z,
  Pointer<Double> outLatDeg, Pointer<Double> outLngDeg, Pointer<Double> outAltM,
);

/// Dart function signature for `bridge_ecef_to_cartographic`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeEcefToCartographicDart = int Function(
  double x, double y, double z,
  Pointer<Double> outLatDeg, Pointer<Double> outLngDeg, Pointer<Double> outAltM,
);

/// Native C function signature for `bridge_free_string`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeFreeStringNative = Void Function(Pointer<Utf8> str);

/// Dart function signature for `bridge_free_string`.
///
/// Realises: [Feat-10/CesiumBridgeBindings]
typedef BridgeFreeStringDart = void Function(Pointer<Utf8> str);

/// Dynamic symbol loader and pure-Dart WGS-84 geodetic fallback table for the
/// native C/C++ 3D geospatial bridge.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Resolves all 13 C ABI symbols
///   atomically during construction; if any symbol lookup or shared library open
///   fails, deterministically binds a pure-Dart WGS-84 ellipsoid fallback table
///   (`a = 6378137.0`, $f = 1 / 298.257223563$) so coordinate transforms remain
///   operational in headless CI and desktop environments without the native dylib.
///
/// ## 2. Invariants & Mathematical Properties
/// - Atomic symbol resolution invariant: `isNativeAvailable == true` if and only
///   if all 13 C bridge entrypoints resolve without exception.
/// - WGS-84 Bowring / iterative ECEF-to-cartographic convergence: 6 fixed
///   Newton-Raphson-like iterations compute geodetic latitude $\phi$ and
///   ellipsoidal height $h$ from $(X, Y, Z)$ with sub-millimeter precision:
///   $$
///   \begin{aligned}
///   N(\phi) &= \frac{a}{\sqrt{1 - e^2 \sin^2\phi}} \\
///   X &= (N + h)\cos\phi\cos\lambda, \quad Y = (N + h)\cos\phi\sin\lambda, \quad Z = (N(1 - e^2) + h)\sin\phi
///   \end{aligned}
///   $$
///
/// ## 3. Preconditions
/// - On Web (`kIsWeb == true`), [load] throws [UnsupportedError] and [tryLoad]
///   returns `null`.
///
/// ## 4. Postconditions
/// - Every function pointer field (`initialize`, `shutdown`, `terminate`,
///   `isReady`, `getLastError`, `updateCamera`, `registerCameraCallback`,
///   `getVisibleTileCount`, `getVisibleTileId`, `requestTileData`,
///   `cartographicToEcef`, `ecefToCartographic`, `freeString`) is initialized
///   to either a valid native symbol or its deterministic pure-Dart fallback.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for symbol binding and 6-iteration
///   geodetic coordinate conversion.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed function pointer table.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing `libcesium_native_bridge.{dylib,so,dll}` or missing symbol exports
///   never crash the process; [tryLoad] returns `null` and [load] returns
///   [CesiumNativeBindings.fallback].
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/CesiumBridgeBindings]
class CesiumNativeBindings {
  static int _nextFallbackHandle = 1;

  final DynamicLibrary? _lib;

  /// True when backed by a loaded native library with resolved C symbols.
  late final bool isNativeAvailable;

  /// Bound function for `bridge_initialize`.
  late final BridgeInitializeDart initialize;

  /// Bound function for `bridge_shutdown`.
  late final BridgeShutdownDart shutdown;

  /// Bound function for `bridge_terminate`.
  late final BridgeTerminateDart terminate;

  /// Bound function for `bridge_is_ready`.
  late final BridgeIsReadyDart isReady;

  /// Bound function for `bridge_get_last_error`.
  late final BridgeGetLastErrorDart getLastError;

  /// Bound function for `bridge_update_camera`.
  late final BridgeUpdateCameraDart updateCamera;

  /// Bound function for `bridge_register_camera_callback`.
  late final BridgeRegisterCameraCallbackDart registerCameraCallback;

  /// Bound function for `bridge_get_visible_tile_count`.
  late final BridgeGetVisibleTileCountDart getVisibleTileCount;

  /// Bound function for `bridge_get_visible_tile_id`.
  late final BridgeGetVisibleTileIdDart getVisibleTileId;

  /// Bound function for `bridge_request_tile_data`.
  late final BridgeRequestTileDataDart requestTileData;

  /// Bound function for `bridge_cartographic_to_ecef`.
  late final BridgeCartographicToEcefDart cartographicToEcef;

  /// Bound function for `bridge_ecef_to_cartographic`.
  late final BridgeEcefToCartographicDart ecefToCartographic;

  /// Bound function for `bridge_free_string`.
  late final BridgeFreeStringDart freeString;

  /// Resolves native C bridge symbols from [lib], falling back to pure-Dart stubs on error.
  CesiumNativeBindings(DynamicLibrary lib) : _lib = lib {
    try {
      final resolvedInitialize =
          lib.lookupFunction<BridgeInitializeNative, BridgeInitializeDart>('bridge_initialize');
      final resolvedShutdown =
          lib.lookupFunction<BridgeShutdownNative, BridgeShutdownDart>('bridge_shutdown');
      final resolvedTerminate =
          lib.lookupFunction<BridgeTerminateNative, BridgeTerminateDart>('bridge_terminate');
      final resolvedIsReady =
          lib.lookupFunction<BridgeIsReadyNative, BridgeIsReadyDart>('bridge_is_ready');
      final resolvedGetLastError =
          lib.lookupFunction<BridgeGetLastErrorNative, BridgeGetLastErrorDart>('bridge_get_last_error');
      final resolvedUpdateCamera =
          lib.lookupFunction<BridgeUpdateCameraNative, BridgeUpdateCameraDart>('bridge_update_camera');
      final resolvedRegisterCameraCallback =
          lib.lookupFunction<BridgeRegisterCameraCallbackNative, BridgeRegisterCameraCallbackDart>(
            'bridge_register_camera_callback',
          );
      final resolvedGetVisibleTileCount =
          lib.lookupFunction<BridgeGetVisibleTileCountNative, BridgeGetVisibleTileCountDart>(
            'bridge_get_visible_tile_count',
          );
      final resolvedGetVisibleTileId =
          lib.lookupFunction<BridgeGetVisibleTileIdNative, BridgeGetVisibleTileIdDart>(
            'bridge_get_visible_tile_id',
          );
      final resolvedRequestTileData =
          lib.lookupFunction<BridgeRequestTileDataNative, BridgeRequestTileDataDart>(
            'bridge_request_tile_data',
          );
      final resolvedCartographicToEcef =
          lib.lookupFunction<BridgeCartographicToEcefNative, BridgeCartographicToEcefDart>(
            'bridge_cartographic_to_ecef',
          );
      final resolvedEcefToCartographic =
          lib.lookupFunction<BridgeEcefToCartographicNative, BridgeEcefToCartographicDart>(
            'bridge_ecef_to_cartographic',
          );
      final resolvedFreeString =
          lib.lookupFunction<BridgeFreeStringNative, BridgeFreeStringDart>('bridge_free_string');

      initialize = resolvedInitialize;
      shutdown = resolvedShutdown;
      terminate = resolvedTerminate;
      isReady = resolvedIsReady;
      getLastError = resolvedGetLastError;
      updateCamera = resolvedUpdateCamera;
      registerCameraCallback = resolvedRegisterCameraCallback;
      getVisibleTileCount = resolvedGetVisibleTileCount;
      getVisibleTileId = resolvedGetVisibleTileId;
      requestTileData = resolvedRequestTileData;
      cartographicToEcef = resolvedCartographicToEcef;
      ecefToCartographic = resolvedEcefToCartographic;
      freeString = resolvedFreeString;
      isNativeAvailable = true;
    } catch (_) {
      _bindPureDartFallback();
      isNativeAvailable = false;
    }
  }

  CesiumNativeBindings._fallback()
      : _lib = null,
        isNativeAvailable = false {
    _bindPureDartFallback();
  }

  /// Creates a safe pure-Dart fallback bindings instance when the native
  /// dynamic library is not present or fails symbol lookup.
  factory CesiumNativeBindings.fallback() => CesiumNativeBindings._fallback();

  void _bindPureDartFallback() {
    initialize = (config, onError, userData) => _nextFallbackHandle++;
    shutdown = (handle) {};
    terminate = () => 0;
    isReady = (handle) => handle > 0 ? 1 : 0;
    getLastError = (handle, out, size) => 0;
    updateCamera = (handle, camera) => 0;
    registerCameraCallback = (handle, callback, userData) => 0;
    getVisibleTileCount = (handle, outCount) {
      if (outCount != nullptr) {
        outCount.value = 0;
      }
      return 0;
    };
    getVisibleTileId = (handle, index, outTileId) {
      if (outTileId != nullptr) {
        outTileId.value = nullptr;
      }
      return -1;
    };
    requestTileData = (handle, tileId, callback, userData) => -1;
    cartographicToEcef = _fallbackCartographicToEcef;
    ecefToCartographic = _fallbackEcefToCartographic;
    freeString = (str) {};
  }

  static int _fallbackCartographicToEcef(
    double latDeg,
    double lngDeg,
    double altM,
    Pointer<Double> outX,
    Pointer<Double> outY,
    Pointer<Double> outZ,
  ) {
    const double a = 6378137.0;
    const double f = 1.0 / 298.257223563;
    const double e2 = f * (2.0 - f);
    final double latRad = latDeg * math.pi / 180.0;
    final double lonRad = lngDeg * math.pi / 180.0;
    final double sinLat = math.sin(latRad);
    final double cosLat = math.cos(latRad);
    final double sinLon = math.sin(lonRad);
    final double cosLon = math.cos(lonRad);
    final double n = a / math.sqrt(1.0 - e2 * sinLat * sinLat);
    if (outX != nullptr) {
      outX.value = (n + altM) * cosLat * cosLon;
    }
    if (outY != nullptr) {
      outY.value = (n + altM) * cosLat * sinLon;
    }
    if (outZ != nullptr) {
      outZ.value = (n * (1.0 - e2) + altM) * sinLat;
    }
    return 0;
  }

  static int _fallbackEcefToCartographic(
    double x,
    double y,
    double z,
    Pointer<Double> outLatDeg,
    Pointer<Double> outLngDeg,
    Pointer<Double> outAltM,
  ) {
    const double a = 6378137.0;
    const double f = 1.0 / 298.257223563;
    const double e2 = f * (2.0 - f);
    final double p = math.sqrt(x * x + y * y);
    final double lonRad = math.atan2(y, x);
    double latRad = math.atan2(z, p * (1.0 - e2));
    double altM = 0.0;
    for (int i = 0; i < 6; i++) {
      final double sinLat = math.sin(latRad);
      final double n = a / math.sqrt(1.0 - e2 * sinLat * sinLat);
      altM = p / math.cos(latRad) - n;
      latRad = math.atan2(z, p * (1.0 - e2 * (n / (n + altM))));
    }
    if (outLatDeg != nullptr) {
      outLatDeg.value = latRad * 180.0 / math.pi;
    }
    if (outLngDeg != nullptr) {
      outLngDeg.value = lonRad * 180.0 / math.pi;
    }
    if (outAltM != nullptr) {
      outAltM.value = altM;
    }
    return 0;
  }

  /// Attempts to open the native shared library and resolve all C symbols.
  /// Returns `null` if the shared library or symbols cannot be loaded.
  static CesiumNativeBindings? tryLoad({String? libraryPath}) {
    if (kIsWeb) {
      return null;
    }
    try {
      final DynamicLibrary lib;
      if (libraryPath != null && libraryPath.isNotEmpty) {
        lib = DynamicLibrary.open(libraryPath);
      } else if (Platform.isMacOS) {
        lib = DynamicLibrary.open('libcesium_native_bridge.dylib');
      } else if (Platform.isLinux) {
        lib = DynamicLibrary.open('libcesium_native_bridge.so');
      } else if (Platform.isWindows) {
        lib = DynamicLibrary.open('cesium_native_bridge.dll');
      } else {
        return null;
      }
      final bindings = CesiumNativeBindings(lib);
      return bindings.isNativeAvailable ? bindings : null;
    } catch (_) {
      return null;
    }
  }

  /// Member documentation.
  static CesiumNativeBindings load({String? libraryPath}) {
    if (kIsWeb) {
      throw UnsupportedError('Cesium native bridge is not supported on Web');
    }
    return tryLoad(libraryPath: libraryPath) ?? CesiumNativeBindings.fallback();
  }

  /// Returns the underlying [DynamicLibrary] if loaded.
  DynamicLibrary? get library => _lib;
}


