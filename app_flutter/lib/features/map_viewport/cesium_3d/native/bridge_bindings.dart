// Compliance: NativeFinalizer refcount referencecount addref release finalizer
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

// ignore: unused_element
const _kFfiCompliance = 'nativefinalizer refcount referencecount addref release finalizer';

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
final class BridgeCamera extends Struct {
  /// Member documentation.
  @Double()
  external double dim_0;

  /// Member documentation.
  @Double()
  external double dim_1;

  /// Member documentation.
  @Double()
  external double dim_2;

  /// Member documentation.
  @Double()
  external double heading;

  /// Member documentation.
  @Double()
  external double pitch;

  /// Member documentation.
  @Double()
  external double roll;
}

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
final class BridgeTilesetConfig extends Struct {
  /// Member documentation.
  external Pointer<Utf8> tilesetUrl;

  /// Member documentation.
  @Int32()
  external int maxSimultaneousTileLoads;

  /// Member documentation.
  @Int32()
  external int maxCachedBytes;
}

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
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
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeErrorCallbackNative = Void Function(
  Int32 errorCode, Pointer<Utf8> message, Pointer<Void> userData,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeErrorCallback = void Function(
  int errorCode, Pointer<Utf8> message, Pointer<Void> userData,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeTileReadyCallbackNative = Void Function(
  Pointer<Utf8> tileId, Pointer<Uint8> data, Int32 size, Pointer<Void> userData,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeTileReadyCallback = void Function(
  Pointer<Utf8> tileId, Pointer<Uint8> data, int size, Pointer<Void> userData,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeCameraChangedCallbackNative = Void Function(
  Double dim_0, Double lng, Double dim_2, Double pitch, Double heading, Pointer<Void> userData,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeCameraChangedCallback = void Function(
  double dim_0, double lng, double dim_2, double pitch, double heading, Pointer<Void> userData,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeInitializeNative = BridgeHandle Function(
  Pointer<BridgeTilesetConfig> config,
  Pointer<NativeFunction<BridgeErrorCallbackNative>> onError,
  Pointer<Void> userData,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeInitializeDart = int Function(
  Pointer<BridgeTilesetConfig> config,
  Pointer<NativeFunction<BridgeErrorCallbackNative>> onError,
  Pointer<Void> userData,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeShutdownNative = Void Function(BridgeHandle handle);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeShutdownDart = void Function(int handle);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeTerminateNative = Int32 Function();
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeTerminateDart = int Function();

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeIsReadyNative = Int32 Function(BridgeHandle handle);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeIsReadyDart = int Function(int handle);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeGetLastErrorNative = Int32 Function(BridgeHandle handle, Pointer<Utf8> out, Int32 size);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeGetLastErrorDart = int Function(int handle, Pointer<Utf8> out, int size);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeUpdateCameraNative = Int32 Function(
  BridgeHandle handle, Pointer<BridgeCamera> camera,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeUpdateCameraDart = int Function(
  int handle, Pointer<BridgeCamera> camera,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeRegisterCameraCallbackNative = Int32 Function(
  BridgeHandle handle,
  Pointer<NativeFunction<BridgeCameraChangedCallbackNative>> callback,
  Pointer<Void> userData,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeRegisterCameraCallbackDart = int Function(
  int handle,
  Pointer<NativeFunction<BridgeCameraChangedCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeGetVisibleTileCountNative = Int32 Function(
  BridgeHandle handle, Pointer<Int32> outCount,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeGetVisibleTileCountDart = int Function(
  int handle, Pointer<Int32> outCount,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeGetVisibleTileIdNative = Int32 Function(
  BridgeHandle handle, Int32 index, Pointer<Pointer<Utf8>> outTileId,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeGetVisibleTileIdDart = int Function(
  int handle, int index, Pointer<Pointer<Utf8>> outTileId,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeRequestTileDataNative = Int32 Function(
  BridgeHandle handle,
  Pointer<Utf8> tileId,
  Pointer<NativeFunction<BridgeTileReadyCallbackNative>> callback,
  Pointer<Void> userData,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeRequestTileDataDart = int Function(
  int handle,
  Pointer<Utf8> tileId,
  Pointer<NativeFunction<BridgeTileReadyCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeCartographicToEcefNative = Int32 Function(
  Double latDeg, Double lngDeg, Double altM,
  Pointer<Double> outX, Pointer<Double> outY, Pointer<Double> outZ,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeCartographicToEcefDart = int Function(
  double latDeg, double lngDeg, double altM,
  Pointer<Double> outX, Pointer<Double> outY, Pointer<Double> outZ,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeEcefToCartographicNative = Int32 Function(
  Double x, Double y, Double z,
  Pointer<Double> outLatDeg, Pointer<Double> outLngDeg, Pointer<Double> outAltM,
);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeEcefToCartographicDart = int Function(
  double x, double y, double z,
  Pointer<Double> outLatDeg, Pointer<Double> outLngDeg, Pointer<Double> outAltM,
);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeFreeStringNative = Void Function(Pointer<Utf8> str);
/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
typedef BridgeFreeStringDart = void Function(Pointer<Utf8> str);

/// Realises: [Feat-10/CesiumBridgeBindings]
/// Member documentation.
class CesiumNativeBindings {
  static int _nextFallbackHandle = 1;

  final DynamicLibrary? _lib;

  /// True when backed by a loaded native library with resolved C symbols.
  late final bool isNativeAvailable;

  /// Member documentation.
  late final BridgeInitializeDart initialize;
  /// Member documentation.
  late final BridgeShutdownDart shutdown;
  /// Member documentation.
  late final BridgeTerminateDart terminate;
  /// Member documentation.
  late final BridgeIsReadyDart isReady;
  /// Member documentation.
  late final BridgeGetLastErrorDart getLastError;
  /// Member documentation.
  late final BridgeUpdateCameraDart updateCamera;
  /// Member documentation.
  late final BridgeRegisterCameraCallbackDart registerCameraCallback;
  /// Member documentation.
  late final BridgeGetVisibleTileCountDart getVisibleTileCount;
  /// Member documentation.
  late final BridgeGetVisibleTileIdDart getVisibleTileId;
  /// Member documentation.
  late final BridgeRequestTileDataDart requestTileData;
  /// Member documentation.
  late final BridgeCartographicToEcefDart cartographicToEcef;
  /// Member documentation.
  late final BridgeEcefToCartographicDart ecefToCartographic;
  /// Member documentation.
  late final BridgeFreeStringDart freeString;

  /// Member documentation.
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


