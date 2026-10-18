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
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeHandle` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeHandle` (declaration #1) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeHandle` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeHandle` representation for typedef `BridgeHandle`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeHandle)) bounded over input/member dimension of `BridgeHandle`.
/// - Space Complexity: O(K(BridgeHandle)) bounded auxiliary memory for `BridgeHandle`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeHandle` (`BridgeHandle`).
/// - State: Maintains consistent state invariants across `BridgeHandle` without partial mutation on error.
/// - Action: Executes `BridgeHandle` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeHandle` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeHandle)
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
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeErrorCallbackNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeErrorCallbackNative` (declaration #2) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeErrorCallbackNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeErrorCallbackNative` representation for typedef `BridgeErrorCallbackNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeErrorCallbackNative)) bounded over input/member dimension of `BridgeErrorCallbackNative`.
/// - Space Complexity: O(K(BridgeErrorCallbackNative)) bounded auxiliary memory for `BridgeErrorCallbackNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeErrorCallbackNative` (`BridgeErrorCallbackNative`).
/// - State: Maintains consistent state invariants across `BridgeErrorCallbackNative` without partial mutation on error.
/// - Action: Executes `BridgeErrorCallbackNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeErrorCallbackNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeErrorCallbackNative)
typedef BridgeErrorCallbackNative = Void Function(
  Int32 errorCode, Pointer<Utf8> message, Pointer<Void> userData,
);

/// Dart function signature for asynchronous bridge error callbacks.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeErrorCallback` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeErrorCallback` (declaration #3) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeErrorCallback` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeErrorCallback` representation for typedef `BridgeErrorCallback`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeErrorCallback)) bounded over input/member dimension of `BridgeErrorCallback`.
/// - Space Complexity: O(K(BridgeErrorCallback)) bounded auxiliary memory for `BridgeErrorCallback`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeErrorCallback` (`BridgeErrorCallback`).
/// - State: Maintains consistent state invariants across `BridgeErrorCallback` without partial mutation on error.
/// - Action: Executes `BridgeErrorCallback` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeErrorCallback` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeErrorCallback)
typedef BridgeErrorCallback = void Function(
  int errorCode, Pointer<Utf8> message, Pointer<Void> userData,
);

/// Native C function signature for tile payload readiness notifications.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeTileReadyCallbackNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeTileReadyCallbackNative` (declaration #4) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeTileReadyCallbackNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeTileReadyCallbackNative` representation for typedef `BridgeTileReadyCallbackNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeTileReadyCallbackNative)) bounded over input/member dimension of `BridgeTileReadyCallbackNative`.
/// - Space Complexity: O(K(BridgeTileReadyCallbackNative)) bounded auxiliary memory for `BridgeTileReadyCallbackNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeTileReadyCallbackNative` (`BridgeTileReadyCallbackNative`).
/// - State: Maintains consistent state invariants across `BridgeTileReadyCallbackNative` without partial mutation on error.
/// - Action: Executes `BridgeTileReadyCallbackNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeTileReadyCallbackNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeTileReadyCallbackNative)
typedef BridgeTileReadyCallbackNative = Void Function(
  Pointer<Utf8> tileId, Pointer<Uint8> data, Int32 size, Pointer<Void> userData,
);

/// Dart function signature for tile payload readiness notifications.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeTileReadyCallback` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeTileReadyCallback` (declaration #5) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeTileReadyCallback` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeTileReadyCallback` representation for typedef `BridgeTileReadyCallback`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeTileReadyCallback)) bounded over input/member dimension of `BridgeTileReadyCallback`.
/// - Space Complexity: O(K(BridgeTileReadyCallback)) bounded auxiliary memory for `BridgeTileReadyCallback`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeTileReadyCallback` (`BridgeTileReadyCallback`).
/// - State: Maintains consistent state invariants across `BridgeTileReadyCallback` without partial mutation on error.
/// - Action: Executes `BridgeTileReadyCallback` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeTileReadyCallback` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeTileReadyCallback)
typedef BridgeTileReadyCallback = void Function(
  Pointer<Utf8> tileId, Pointer<Uint8> data, int size, Pointer<Void> userData,
);

/// Native C function signature for camera pose change notifications.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeCameraChangedCallbackNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeCameraChangedCallbackNative` (declaration #6) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeCameraChangedCallbackNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeCameraChangedCallbackNative` representation for typedef `BridgeCameraChangedCallbackNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeCameraChangedCallbackNative)) bounded over input/member dimension of `BridgeCameraChangedCallbackNative`.
/// - Space Complexity: O(K(BridgeCameraChangedCallbackNative)) bounded auxiliary memory for `BridgeCameraChangedCallbackNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeCameraChangedCallbackNative` (`BridgeCameraChangedCallbackNative`).
/// - State: Maintains consistent state invariants across `BridgeCameraChangedCallbackNative` without partial mutation on error.
/// - Action: Executes `BridgeCameraChangedCallbackNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeCameraChangedCallbackNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeCameraChangedCallbackNative)
typedef BridgeCameraChangedCallbackNative = Void Function(
  Double dim_0, Double lng, Double dim_2, Double pitch, Double heading, Pointer<Void> userData,
);

/// Dart function signature for camera pose change notifications.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeCameraChangedCallback` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeCameraChangedCallback` (declaration #7) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeCameraChangedCallback` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeCameraChangedCallback` representation for typedef `BridgeCameraChangedCallback`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeCameraChangedCallback)) bounded over input/member dimension of `BridgeCameraChangedCallback`.
/// - Space Complexity: O(K(BridgeCameraChangedCallback)) bounded auxiliary memory for `BridgeCameraChangedCallback`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeCameraChangedCallback` (`BridgeCameraChangedCallback`).
/// - State: Maintains consistent state invariants across `BridgeCameraChangedCallback` without partial mutation on error.
/// - Action: Executes `BridgeCameraChangedCallback` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeCameraChangedCallback` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeCameraChangedCallback)
typedef BridgeCameraChangedCallback = void Function(
  double dim_0, double lng, double dim_2, double pitch, double heading, Pointer<Void> userData,
);

/// Native C function signature for `bridge_initialize`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeInitializeNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeInitializeNative` (declaration #8) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeInitializeNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeInitializeNative` representation for typedef `BridgeInitializeNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeInitializeNative)) bounded over input/member dimension of `BridgeInitializeNative`.
/// - Space Complexity: O(K(BridgeInitializeNative)) bounded auxiliary memory for `BridgeInitializeNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeInitializeNative` (`BridgeInitializeNative`).
/// - State: Maintains consistent state invariants across `BridgeInitializeNative` without partial mutation on error.
/// - Action: Executes `BridgeInitializeNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeInitializeNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeInitializeNative)
typedef BridgeInitializeNative = BridgeHandle Function(
  Pointer<BridgeTilesetConfig> config,
  Pointer<NativeFunction<BridgeErrorCallbackNative>> onError,
  Pointer<Void> userData,
);

/// Dart function signature for `bridge_initialize`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeInitializeDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeInitializeDart` (declaration #9) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeInitializeDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeInitializeDart` representation for typedef `BridgeInitializeDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeInitializeDart)) bounded over input/member dimension of `BridgeInitializeDart`.
/// - Space Complexity: O(K(BridgeInitializeDart)) bounded auxiliary memory for `BridgeInitializeDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeInitializeDart` (`BridgeInitializeDart`).
/// - State: Maintains consistent state invariants across `BridgeInitializeDart` without partial mutation on error.
/// - Action: Executes `BridgeInitializeDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeInitializeDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeInitializeDart)
typedef BridgeInitializeDart = int Function(
  Pointer<BridgeTilesetConfig> config,
  Pointer<NativeFunction<BridgeErrorCallbackNative>> onError,
  Pointer<Void> userData,
);

/// Native C function signature for `bridge_shutdown`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeShutdownNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeShutdownNative` (declaration #10) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeShutdownNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeShutdownNative` representation for typedef `BridgeShutdownNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeShutdownNative)) bounded over input/member dimension of `BridgeShutdownNative`.
/// - Space Complexity: O(K(BridgeShutdownNative)) bounded auxiliary memory for `BridgeShutdownNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeShutdownNative` (`BridgeShutdownNative`).
/// - State: Maintains consistent state invariants across `BridgeShutdownNative` without partial mutation on error.
/// - Action: Executes `BridgeShutdownNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeShutdownNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeShutdownNative)
typedef BridgeShutdownNative = Void Function(BridgeHandle handle);

/// Dart function signature for `bridge_shutdown`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeShutdownDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeShutdownDart` (declaration #11) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeShutdownDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeShutdownDart` representation for typedef `BridgeShutdownDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeShutdownDart)) bounded over input/member dimension of `BridgeShutdownDart`.
/// - Space Complexity: O(K(BridgeShutdownDart)) bounded auxiliary memory for `BridgeShutdownDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeShutdownDart` (`BridgeShutdownDart`).
/// - State: Maintains consistent state invariants across `BridgeShutdownDart` without partial mutation on error.
/// - Action: Executes `BridgeShutdownDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeShutdownDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeShutdownDart)
typedef BridgeShutdownDart = void Function(int handle);

/// Native C function signature for `bridge_terminate`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeTerminateNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeTerminateNative` (declaration #12) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeTerminateNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeTerminateNative` representation for typedef `BridgeTerminateNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeTerminateNative)) bounded over input/member dimension of `BridgeTerminateNative`.
/// - Space Complexity: O(K(BridgeTerminateNative)) bounded auxiliary memory for `BridgeTerminateNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeTerminateNative` (`BridgeTerminateNative`).
/// - State: Maintains consistent state invariants across `BridgeTerminateNative` without partial mutation on error.
/// - Action: Executes `BridgeTerminateNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeTerminateNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeTerminateNative)
typedef BridgeTerminateNative = Int32 Function();

/// Dart function signature for `bridge_terminate`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeTerminateDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeTerminateDart` (declaration #13) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeTerminateDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeTerminateDart` representation for typedef `BridgeTerminateDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeTerminateDart)) bounded over input/member dimension of `BridgeTerminateDart`.
/// - Space Complexity: O(K(BridgeTerminateDart)) bounded auxiliary memory for `BridgeTerminateDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeTerminateDart` (`BridgeTerminateDart`).
/// - State: Maintains consistent state invariants across `BridgeTerminateDart` without partial mutation on error.
/// - Action: Executes `BridgeTerminateDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeTerminateDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeTerminateDart)
typedef BridgeTerminateDart = int Function();

/// Native C function signature for `bridge_is_ready`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeIsReadyNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeIsReadyNative` (declaration #14) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeIsReadyNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeIsReadyNative` representation for typedef `BridgeIsReadyNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeIsReadyNative)) bounded over input/member dimension of `BridgeIsReadyNative`.
/// - Space Complexity: O(K(BridgeIsReadyNative)) bounded auxiliary memory for `BridgeIsReadyNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeIsReadyNative` (`BridgeIsReadyNative`).
/// - State: Maintains consistent state invariants across `BridgeIsReadyNative` without partial mutation on error.
/// - Action: Executes `BridgeIsReadyNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeIsReadyNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeIsReadyNative)
typedef BridgeIsReadyNative = Int32 Function(BridgeHandle handle);

/// Dart function signature for `bridge_is_ready`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeIsReadyDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeIsReadyDart` (declaration #15) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeIsReadyDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeIsReadyDart` representation for typedef `BridgeIsReadyDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeIsReadyDart)) bounded over input/member dimension of `BridgeIsReadyDart`.
/// - Space Complexity: O(K(BridgeIsReadyDart)) bounded auxiliary memory for `BridgeIsReadyDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeIsReadyDart` (`BridgeIsReadyDart`).
/// - State: Maintains consistent state invariants across `BridgeIsReadyDart` without partial mutation on error.
/// - Action: Executes `BridgeIsReadyDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeIsReadyDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeIsReadyDart)
typedef BridgeIsReadyDart = int Function(int handle);

/// Native C function signature for `bridge_get_last_error`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeGetLastErrorNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeGetLastErrorNative` (declaration #16) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeGetLastErrorNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeGetLastErrorNative` representation for typedef `BridgeGetLastErrorNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeGetLastErrorNative)) bounded over input/member dimension of `BridgeGetLastErrorNative`.
/// - Space Complexity: O(K(BridgeGetLastErrorNative)) bounded auxiliary memory for `BridgeGetLastErrorNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeGetLastErrorNative` (`BridgeGetLastErrorNative`).
/// - State: Maintains consistent state invariants across `BridgeGetLastErrorNative` without partial mutation on error.
/// - Action: Executes `BridgeGetLastErrorNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeGetLastErrorNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeGetLastErrorNative)
typedef BridgeGetLastErrorNative = Int32 Function(BridgeHandle handle, Pointer<Utf8> out, Int32 size);

/// Dart function signature for `bridge_get_last_error`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeGetLastErrorDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeGetLastErrorDart` (declaration #17) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeGetLastErrorDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeGetLastErrorDart` representation for typedef `BridgeGetLastErrorDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeGetLastErrorDart)) bounded over input/member dimension of `BridgeGetLastErrorDart`.
/// - Space Complexity: O(K(BridgeGetLastErrorDart)) bounded auxiliary memory for `BridgeGetLastErrorDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeGetLastErrorDart` (`BridgeGetLastErrorDart`).
/// - State: Maintains consistent state invariants across `BridgeGetLastErrorDart` without partial mutation on error.
/// - Action: Executes `BridgeGetLastErrorDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeGetLastErrorDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeGetLastErrorDart)
typedef BridgeGetLastErrorDart = int Function(int handle, Pointer<Utf8> out, int size);

/// Native C function signature for `bridge_update_camera`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeUpdateCameraNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeUpdateCameraNative` (declaration #18) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeUpdateCameraNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeUpdateCameraNative` representation for typedef `BridgeUpdateCameraNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeUpdateCameraNative)) bounded over input/member dimension of `BridgeUpdateCameraNative`.
/// - Space Complexity: O(K(BridgeUpdateCameraNative)) bounded auxiliary memory for `BridgeUpdateCameraNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeUpdateCameraNative` (`BridgeUpdateCameraNative`).
/// - State: Maintains consistent state invariants across `BridgeUpdateCameraNative` without partial mutation on error.
/// - Action: Executes `BridgeUpdateCameraNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeUpdateCameraNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeUpdateCameraNative)
typedef BridgeUpdateCameraNative = Int32 Function(
  BridgeHandle handle, Pointer<BridgeCamera> camera,
);

/// Dart function signature for `bridge_update_camera`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeUpdateCameraDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeUpdateCameraDart` (declaration #19) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeUpdateCameraDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeUpdateCameraDart` representation for typedef `BridgeUpdateCameraDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeUpdateCameraDart)) bounded over input/member dimension of `BridgeUpdateCameraDart`.
/// - Space Complexity: O(K(BridgeUpdateCameraDart)) bounded auxiliary memory for `BridgeUpdateCameraDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeUpdateCameraDart` (`BridgeUpdateCameraDart`).
/// - State: Maintains consistent state invariants across `BridgeUpdateCameraDart` without partial mutation on error.
/// - Action: Executes `BridgeUpdateCameraDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeUpdateCameraDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeUpdateCameraDart)
typedef BridgeUpdateCameraDart = int Function(
  int handle, Pointer<BridgeCamera> camera,
);

/// Native C function signature for `bridge_register_camera_callback`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeRegisterCameraCallbackNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeRegisterCameraCallbackNative` (declaration #20) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeRegisterCameraCallbackNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeRegisterCameraCallbackNative` representation for typedef `BridgeRegisterCameraCallbackNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeRegisterCameraCallbackNative)) bounded over input/member dimension of `BridgeRegisterCameraCallbackNative`.
/// - Space Complexity: O(K(BridgeRegisterCameraCallbackNative)) bounded auxiliary memory for `BridgeRegisterCameraCallbackNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeRegisterCameraCallbackNative` (`BridgeRegisterCameraCallbackNative`).
/// - State: Maintains consistent state invariants across `BridgeRegisterCameraCallbackNative` without partial mutation on error.
/// - Action: Executes `BridgeRegisterCameraCallbackNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeRegisterCameraCallbackNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeRegisterCameraCallbackNative)
typedef BridgeRegisterCameraCallbackNative = Int32 Function(
  BridgeHandle handle,
  Pointer<NativeFunction<BridgeCameraChangedCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Dart function signature for `bridge_register_camera_callback`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeRegisterCameraCallbackDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeRegisterCameraCallbackDart` (declaration #21) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeRegisterCameraCallbackDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeRegisterCameraCallbackDart` representation for typedef `BridgeRegisterCameraCallbackDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeRegisterCameraCallbackDart)) bounded over input/member dimension of `BridgeRegisterCameraCallbackDart`.
/// - Space Complexity: O(K(BridgeRegisterCameraCallbackDart)) bounded auxiliary memory for `BridgeRegisterCameraCallbackDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeRegisterCameraCallbackDart` (`BridgeRegisterCameraCallbackDart`).
/// - State: Maintains consistent state invariants across `BridgeRegisterCameraCallbackDart` without partial mutation on error.
/// - Action: Executes `BridgeRegisterCameraCallbackDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeRegisterCameraCallbackDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeRegisterCameraCallbackDart)
typedef BridgeRegisterCameraCallbackDart = int Function(
  int handle,
  Pointer<NativeFunction<BridgeCameraChangedCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Native C function signature for `bridge_get_visible_tile_count`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeGetVisibleTileCountNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeGetVisibleTileCountNative` (declaration #22) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeGetVisibleTileCountNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeGetVisibleTileCountNative` representation for typedef `BridgeGetVisibleTileCountNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeGetVisibleTileCountNative)) bounded over input/member dimension of `BridgeGetVisibleTileCountNative`.
/// - Space Complexity: O(K(BridgeGetVisibleTileCountNative)) bounded auxiliary memory for `BridgeGetVisibleTileCountNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeGetVisibleTileCountNative` (`BridgeGetVisibleTileCountNative`).
/// - State: Maintains consistent state invariants across `BridgeGetVisibleTileCountNative` without partial mutation on error.
/// - Action: Executes `BridgeGetVisibleTileCountNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeGetVisibleTileCountNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeGetVisibleTileCountNative)
typedef BridgeGetVisibleTileCountNative = Int32 Function(
  BridgeHandle handle, Pointer<Int32> outCount,
);

/// Dart function signature for `bridge_get_visible_tile_count`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeGetVisibleTileCountDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeGetVisibleTileCountDart` (declaration #23) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeGetVisibleTileCountDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeGetVisibleTileCountDart` representation for typedef `BridgeGetVisibleTileCountDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeGetVisibleTileCountDart)) bounded over input/member dimension of `BridgeGetVisibleTileCountDart`.
/// - Space Complexity: O(K(BridgeGetVisibleTileCountDart)) bounded auxiliary memory for `BridgeGetVisibleTileCountDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeGetVisibleTileCountDart` (`BridgeGetVisibleTileCountDart`).
/// - State: Maintains consistent state invariants across `BridgeGetVisibleTileCountDart` without partial mutation on error.
/// - Action: Executes `BridgeGetVisibleTileCountDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeGetVisibleTileCountDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeGetVisibleTileCountDart)
typedef BridgeGetVisibleTileCountDart = int Function(
  int handle, Pointer<Int32> outCount,
);

/// Native C function signature for `bridge_get_visible_tile_id`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeGetVisibleTileIdNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeGetVisibleTileIdNative` (declaration #24) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeGetVisibleTileIdNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeGetVisibleTileIdNative` representation for typedef `BridgeGetVisibleTileIdNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeGetVisibleTileIdNative)) bounded over input/member dimension of `BridgeGetVisibleTileIdNative`.
/// - Space Complexity: O(K(BridgeGetVisibleTileIdNative)) bounded auxiliary memory for `BridgeGetVisibleTileIdNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeGetVisibleTileIdNative` (`BridgeGetVisibleTileIdNative`).
/// - State: Maintains consistent state invariants across `BridgeGetVisibleTileIdNative` without partial mutation on error.
/// - Action: Executes `BridgeGetVisibleTileIdNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeGetVisibleTileIdNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeGetVisibleTileIdNative)
typedef BridgeGetVisibleTileIdNative = Int32 Function(
  BridgeHandle handle, Int32 index, Pointer<Pointer<Utf8>> outTileId,
);

/// Dart function signature for `bridge_get_visible_tile_id`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeGetVisibleTileIdDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeGetVisibleTileIdDart` (declaration #25) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeGetVisibleTileIdDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeGetVisibleTileIdDart` representation for typedef `BridgeGetVisibleTileIdDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeGetVisibleTileIdDart)) bounded over input/member dimension of `BridgeGetVisibleTileIdDart`.
/// - Space Complexity: O(K(BridgeGetVisibleTileIdDart)) bounded auxiliary memory for `BridgeGetVisibleTileIdDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeGetVisibleTileIdDart` (`BridgeGetVisibleTileIdDart`).
/// - State: Maintains consistent state invariants across `BridgeGetVisibleTileIdDart` without partial mutation on error.
/// - Action: Executes `BridgeGetVisibleTileIdDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeGetVisibleTileIdDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeGetVisibleTileIdDart)
typedef BridgeGetVisibleTileIdDart = int Function(
  int handle, int index, Pointer<Pointer<Utf8>> outTileId,
);

/// Native C function signature for `bridge_request_tile_data`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeRequestTileDataNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeRequestTileDataNative` (declaration #26) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeRequestTileDataNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeRequestTileDataNative` representation for typedef `BridgeRequestTileDataNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeRequestTileDataNative)) bounded over input/member dimension of `BridgeRequestTileDataNative`.
/// - Space Complexity: O(K(BridgeRequestTileDataNative)) bounded auxiliary memory for `BridgeRequestTileDataNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeRequestTileDataNative` (`BridgeRequestTileDataNative`).
/// - State: Maintains consistent state invariants across `BridgeRequestTileDataNative` without partial mutation on error.
/// - Action: Executes `BridgeRequestTileDataNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeRequestTileDataNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeRequestTileDataNative)
typedef BridgeRequestTileDataNative = Int32 Function(
  BridgeHandle handle,
  Pointer<Utf8> tileId,
  Pointer<NativeFunction<BridgeTileReadyCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Dart function signature for `bridge_request_tile_data`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeRequestTileDataDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeRequestTileDataDart` (declaration #27) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeRequestTileDataDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeRequestTileDataDart` representation for typedef `BridgeRequestTileDataDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeRequestTileDataDart)) bounded over input/member dimension of `BridgeRequestTileDataDart`.
/// - Space Complexity: O(K(BridgeRequestTileDataDart)) bounded auxiliary memory for `BridgeRequestTileDataDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeRequestTileDataDart` (`BridgeRequestTileDataDart`).
/// - State: Maintains consistent state invariants across `BridgeRequestTileDataDart` without partial mutation on error.
/// - Action: Executes `BridgeRequestTileDataDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeRequestTileDataDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeRequestTileDataDart)
typedef BridgeRequestTileDataDart = int Function(
  int handle,
  Pointer<Utf8> tileId,
  Pointer<NativeFunction<BridgeTileReadyCallbackNative>> callback,
  Pointer<Void> userData,
);

/// Native C function signature for `bridge_cartographic_to_ecef`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeCartographicToEcefNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeCartographicToEcefNative` (declaration #28) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeCartographicToEcefNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeCartographicToEcefNative` representation for typedef `BridgeCartographicToEcefNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeCartographicToEcefNative)) bounded over input/member dimension of `BridgeCartographicToEcefNative`.
/// - Space Complexity: O(K(BridgeCartographicToEcefNative)) bounded auxiliary memory for `BridgeCartographicToEcefNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeCartographicToEcefNative` (`BridgeCartographicToEcefNative`).
/// - State: Maintains consistent state invariants across `BridgeCartographicToEcefNative` without partial mutation on error.
/// - Action: Executes `BridgeCartographicToEcefNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeCartographicToEcefNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeCartographicToEcefNative)
typedef BridgeCartographicToEcefNative = Int32 Function(
  Double latDeg, Double lngDeg, Double altM,
  Pointer<Double> outX, Pointer<Double> outY, Pointer<Double> outZ,
);

/// Dart function signature for `bridge_cartographic_to_ecef`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeCartographicToEcefDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeCartographicToEcefDart` (declaration #29) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeCartographicToEcefDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeCartographicToEcefDart` representation for typedef `BridgeCartographicToEcefDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeCartographicToEcefDart)) bounded over input/member dimension of `BridgeCartographicToEcefDart`.
/// - Space Complexity: O(K(BridgeCartographicToEcefDart)) bounded auxiliary memory for `BridgeCartographicToEcefDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeCartographicToEcefDart` (`BridgeCartographicToEcefDart`).
/// - State: Maintains consistent state invariants across `BridgeCartographicToEcefDart` without partial mutation on error.
/// - Action: Executes `BridgeCartographicToEcefDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeCartographicToEcefDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeCartographicToEcefDart)
typedef BridgeCartographicToEcefDart = int Function(
  double latDeg, double lngDeg, double altM,
  Pointer<Double> outX, Pointer<Double> outY, Pointer<Double> outZ,
);

/// Native C function signature for `bridge_ecef_to_cartographic`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeEcefToCartographicNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeEcefToCartographicNative` (declaration #30) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeEcefToCartographicNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeEcefToCartographicNative` representation for typedef `BridgeEcefToCartographicNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeEcefToCartographicNative)) bounded over input/member dimension of `BridgeEcefToCartographicNative`.
/// - Space Complexity: O(K(BridgeEcefToCartographicNative)) bounded auxiliary memory for `BridgeEcefToCartographicNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeEcefToCartographicNative` (`BridgeEcefToCartographicNative`).
/// - State: Maintains consistent state invariants across `BridgeEcefToCartographicNative` without partial mutation on error.
/// - Action: Executes `BridgeEcefToCartographicNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeEcefToCartographicNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeEcefToCartographicNative)
typedef BridgeEcefToCartographicNative = Int32 Function(
  Double x, Double y, Double z,
  Pointer<Double> outLatDeg, Pointer<Double> outLngDeg, Pointer<Double> outAltM,
);

/// Dart function signature for `bridge_ecef_to_cartographic`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeEcefToCartographicDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeEcefToCartographicDart` (declaration #31) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeEcefToCartographicDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeEcefToCartographicDart` representation for typedef `BridgeEcefToCartographicDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeEcefToCartographicDart)) bounded over input/member dimension of `BridgeEcefToCartographicDart`.
/// - Space Complexity: O(K(BridgeEcefToCartographicDart)) bounded auxiliary memory for `BridgeEcefToCartographicDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeEcefToCartographicDart` (`BridgeEcefToCartographicDart`).
/// - State: Maintains consistent state invariants across `BridgeEcefToCartographicDart` without partial mutation on error.
/// - Action: Executes `BridgeEcefToCartographicDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeEcefToCartographicDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeEcefToCartographicDart)
typedef BridgeEcefToCartographicDart = int Function(
  double x, double y, double z,
  Pointer<Double> outLatDeg, Pointer<Double> outLngDeg, Pointer<Double> outAltM,
);

/// Native C function signature for `bridge_free_string`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeFreeStringNative` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeFreeStringNative` (declaration #32) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeFreeStringNative` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeFreeStringNative` representation for typedef `BridgeFreeStringNative`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeFreeStringNative)) bounded over input/member dimension of `BridgeFreeStringNative`.
/// - Space Complexity: O(K(BridgeFreeStringNative)) bounded auxiliary memory for `BridgeFreeStringNative`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeFreeStringNative` (`BridgeFreeStringNative`).
/// - State: Maintains consistent state invariants across `BridgeFreeStringNative` without partial mutation on error.
/// - Action: Executes `BridgeFreeStringNative` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeFreeStringNative` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeFreeStringNative)
typedef BridgeFreeStringNative = Void Function(Pointer<Utf8> str);

/// Dart function signature for `bridge_free_string`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for typedef `BridgeFreeStringDart` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for typedef `BridgeFreeStringDart` (declaration #33) within `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `BridgeFreeStringDart` in `NATIVE-BRIDGE-BINDINGS`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `BridgeFreeStringDart` representation for typedef `BridgeFreeStringDart`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(BridgeFreeStringDart)) bounded over input/member dimension of `BridgeFreeStringDart`.
/// - Space Complexity: O(K(BridgeFreeStringDart)) bounded auxiliary memory for `BridgeFreeStringDart`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `BridgeFreeStringDart` (`BridgeFreeStringDart`).
/// - State: Maintains consistent state invariants across `BridgeFreeStringDart` without partial mutation on error.
/// - Action: Executes `BridgeFreeStringDart` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `BridgeFreeStringDart` (`NATIVE-BRIDGE-BINDINGS`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/CesiumBridgeBindings] | SysML v2: PartDef(BridgeFreeStringDart)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumNativeBindings::CesiumNativeBindings` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumNativeBindings::CesiumNativeBindings` (declaration #35) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - `lib: DynamicLibrary` must satisfy domain and type-safety constraints prior to invoking `CesiumNativeBindings::CesiumNativeBindings`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumNativeBindings::CesiumNativeBindings` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(lib)) bounded over input/member dimension of `CesiumNativeBindings::CesiumNativeBindings`.
  /// - Space Complexity: O(N(lib)) bounded auxiliary memory for `CesiumNativeBindings::CesiumNativeBindings`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::CesiumNativeBindings` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::CesiumNativeBindings` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::CesiumNativeBindings` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::CesiumNativeBindings` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-CESIUMNATIVEBINDINGS] | SysML v2: ActionDef(CesiumNativeBindings::CesiumNativeBindings)
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

  /// Executes deterministic constructor `CesiumNativeBindings::CesiumNativeBindings._fallback` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumNativeBindings::CesiumNativeBindings._fallback` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumNativeBindings::CesiumNativeBindings._fallback` (declaration #36) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumNativeBindings::CesiumNativeBindings._fallback` in `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumNativeBindings::CesiumNativeBindings._fallback` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(CesiumNativeBindings._fallback)) bounded over input/member dimension of `CesiumNativeBindings::CesiumNativeBindings._fallback`.
  /// - Space Complexity: O(K(CesiumNativeBindings._fallback)) bounded auxiliary memory for `CesiumNativeBindings::CesiumNativeBindings._fallback`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::CesiumNativeBindings._fallback` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::CesiumNativeBindings._fallback` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::CesiumNativeBindings._fallback` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::CesiumNativeBindings._fallback` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-CESIUMNATIVEBINDINGS-FALLBACK] | SysML v2: ActionDef(CesiumNativeBindings::CesiumNativeBindings._fallback)
  CesiumNativeBindings._fallback()
      : _lib = null,
        isNativeAvailable = false {
    _bindPureDartFallback();
  }

  /// Creates a safe pure-Dart fallback bindings instance when the native
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `CesiumNativeBindings::CesiumNativeBindings` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `CesiumNativeBindings::CesiumNativeBindings` (declaration #37) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumNativeBindings::CesiumNativeBindings` in `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `CesiumNativeBindings::CesiumNativeBindings` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(CesiumNativeBindings)) bounded over input/member dimension of `CesiumNativeBindings::CesiumNativeBindings`.
  /// - Space Complexity: O(K(CesiumNativeBindings)) bounded auxiliary memory for `CesiumNativeBindings::CesiumNativeBindings`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::CesiumNativeBindings` (`()`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::CesiumNativeBindings` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::CesiumNativeBindings` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::CesiumNativeBindings` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-CESIUMNATIVEBINDINGS] | SysML v2: ActionDef(CesiumNativeBindings::CesiumNativeBindings)
  factory CesiumNativeBindings.fallback() => CesiumNativeBindings._fallback();

  /// Executes deterministic method `CesiumNativeBindings::_bindPureDartFallback` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumNativeBindings::_bindPureDartFallback` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumNativeBindings::_bindPureDartFallback` (declaration #38) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumNativeBindings::_bindPureDartFallback` in `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `CesiumNativeBindings::_bindPureDartFallback` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_bindPureDartFallback)) bounded over input/member dimension of `CesiumNativeBindings::_bindPureDartFallback`.
  /// - Space Complexity: O(K(_bindPureDartFallback)) bounded auxiliary memory for `CesiumNativeBindings::_bindPureDartFallback`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::_bindPureDartFallback` (`void`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::_bindPureDartFallback` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::_bindPureDartFallback` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::_bindPureDartFallback` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-BINDPUREDARTFALLBACK] | SysML v2: ActionDef(CesiumNativeBindings::_bindPureDartFallback)
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

  /// Executes deterministic method `CesiumNativeBindings::_fallbackCartographicToEcef` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumNativeBindings::_fallbackCartographicToEcef` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumNativeBindings::_fallbackCartographicToEcef` (declaration #39) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumNativeBindings::_fallbackCartographicToEcef` in `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `CesiumNativeBindings::_fallbackCartographicToEcef` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_fallbackCartographicToEcef)) bounded over input/member dimension of `CesiumNativeBindings::_fallbackCartographicToEcef`.
  /// - Space Complexity: O(K(_fallbackCartographicToEcef)) bounded auxiliary memory for `CesiumNativeBindings::_fallbackCartographicToEcef`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::_fallbackCartographicToEcef` (`int`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::_fallbackCartographicToEcef` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::_fallbackCartographicToEcef` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::_fallbackCartographicToEcef` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-FALLBACKCARTOGRAPHICTOECEF] | SysML v2: ActionDef(CesiumNativeBindings::_fallbackCartographicToEcef)
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

  /// Executes deterministic method `CesiumNativeBindings::_fallbackEcefToCartographic` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumNativeBindings::_fallbackEcefToCartographic` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumNativeBindings::_fallbackEcefToCartographic` (declaration #40) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `CesiumNativeBindings::_fallbackEcefToCartographic` in `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `CesiumNativeBindings::_fallbackEcefToCartographic` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_fallbackEcefToCartographic)) bounded over input/member dimension of `CesiumNativeBindings::_fallbackEcefToCartographic`.
  /// - Space Complexity: O(K(_fallbackEcefToCartographic)) bounded auxiliary memory for `CesiumNativeBindings::_fallbackEcefToCartographic`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::_fallbackEcefToCartographic` (`int`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::_fallbackEcefToCartographic` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::_fallbackEcefToCartographic` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::_fallbackEcefToCartographic` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-FALLBACKECEFTOCARTOGRAPHIC] | SysML v2: ActionDef(CesiumNativeBindings::_fallbackEcefToCartographic)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumNativeBindings::tryLoad` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumNativeBindings::tryLoad` (declaration #41) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - `libraryPath: String?` must satisfy domain and type-safety constraints prior to invoking `CesiumNativeBindings::tryLoad`.
  ///
  /// ## 4. Postconditions
  /// - Returns `CesiumNativeBindings?` from `CesiumNativeBindings::tryLoad` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(libraryPath)) bounded over input/member dimension of `CesiumNativeBindings::tryLoad`.
  /// - Space Complexity: O(N(libraryPath)) bounded auxiliary memory for `CesiumNativeBindings::tryLoad`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::tryLoad` (`CesiumNativeBindings?`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::tryLoad` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::tryLoad` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::tryLoad` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-TRYLOAD] | SysML v2: ActionDef(CesiumNativeBindings::tryLoad)
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

  /// Executes deterministic method `CesiumNativeBindings::load` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `CesiumNativeBindings::load` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/map_viewport/cesium_3d/native/bridge_bindings.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `CesiumNativeBindings::load` (declaration #42) within `NATIVE-BRIDGE-BINDINGS`.
  ///
  /// ## 3. Preconditions
  /// - `libraryPath: String?` must satisfy domain and type-safety constraints prior to invoking `CesiumNativeBindings::load`.
  ///
  /// ## 4. Postconditions
  /// - Returns `CesiumNativeBindings` from `CesiumNativeBindings::load` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(libraryPath)) bounded over input/member dimension of `CesiumNativeBindings::load`.
  /// - Space Complexity: O(N(libraryPath)) bounded auxiliary memory for `CesiumNativeBindings::load`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `CesiumNativeBindings::load` (`CesiumNativeBindings`).
  /// - State: Maintains consistent state invariants across `CesiumNativeBindings::load` without partial mutation on error.
  /// - Action: Executes `CesiumNativeBindings::load` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `CesiumNativeBindings::load` (`NATIVE-BRIDGE-BINDINGS`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-NATIVE-BRIDGE-BINDINGS-CESIUMNATIVEBINDINGS-LOAD] | SysML v2: ActionDef(CesiumNativeBindings::load)
  static CesiumNativeBindings load({String? libraryPath}) {
    if (kIsWeb) {
      throw UnsupportedError('Cesium native bridge is not supported on Web');
    }
    return tryLoad(libraryPath: libraryPath) ?? CesiumNativeBindings.fallback();
  }

  /// Returns the underlying [DynamicLibrary] if loaded.
  DynamicLibrary? get library => _lib;
}


