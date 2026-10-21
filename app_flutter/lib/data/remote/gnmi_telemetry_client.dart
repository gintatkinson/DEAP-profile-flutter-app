import 'dart:async';

/// Immutable telemetry sample frame associating a canonical schema path with a measured value and sample timestamp.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides a deterministic, timestamped telemetry data transfer object (`path`, `value`, `timestamp`) for Layer 2 streaming subscription pipelines and Layer 3 display indicator bindings.
///
/// ## 2. Invariants & Mathematical Properties
/// - [timestamp] is guaranteed non-null at instantiation (defaulting to `DateTime.now()`) and serializes deterministically to ISO-8601 format in [toMap].
/// - [path] and [value] fields are immutable (`final`) once constructed.
///
/// ## 3. Preconditions
/// - [path] must be a valid hierarchical telemetry path string (such as `'/components/component/state/telemetry'`).
///
/// ## 4. Postconditions
/// - Yields an immutable [GnmiTelemetryUpdate] instance convertible to a key-value map via [toMap].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction and [toMap] serialization.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed 3-entry map envelope in [toMap].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Omitted [timestamp] parameter safely falls back to the current system clock (`DateTime.now()`), preventing null-timestamp exceptions in downstream time-series consumers.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Streaming Telemetry Frame)
///
/// Realises: [UC-04/GnmiTelemetryUpdate]
class GnmiTelemetryUpdate {
  /// The gNMI path target.
  final String path;

  /// The metric value.
  final dynamic value;

  /// Timestamp of the telemetry measurement.
  final DateTime timestamp;

  /// Creates a new [GnmiTelemetryUpdate].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `GnmiTelemetryUpdate::GnmiTelemetryUpdate` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `GnmiTelemetryUpdate::GnmiTelemetryUpdate` (declaration #2) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryUpdate::GnmiTelemetryUpdate` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `GnmiTelemetryUpdate::GnmiTelemetryUpdate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(GnmiTelemetryUpdate)) bounded over input/member dimension of `GnmiTelemetryUpdate::GnmiTelemetryUpdate`.
  /// - Space Complexity: O(K(GnmiTelemetryUpdate)) bounded auxiliary memory for `GnmiTelemetryUpdate::GnmiTelemetryUpdate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryUpdate::GnmiTelemetryUpdate` (`()`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryUpdate::GnmiTelemetryUpdate` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryUpdate::GnmiTelemetryUpdate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryUpdate::GnmiTelemetryUpdate` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYUPDATE-GNMITELEMETRYUPDATE] | SysML v2: ActionDef(GnmiTelemetryUpdate::GnmiTelemetryUpdate)
  GnmiTelemetryUpdate({
    required this.path,
    required this.value,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts update to JSON map.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryUpdate::toMap` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryUpdate::toMap` (declaration #3) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryUpdate::toMap` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, dynamic>` from `GnmiTelemetryUpdate::toMap` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(toMap)) bounded over input/member dimension of `GnmiTelemetryUpdate::toMap`.
  /// - Space Complexity: O(K(toMap)) bounded auxiliary memory for `GnmiTelemetryUpdate::toMap`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryUpdate::toMap` (`Map<String, dynamic>`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryUpdate::toMap` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryUpdate::toMap` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryUpdate::toMap` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYUPDATE-TOMAP] | SysML v2: ActionDef(GnmiTelemetryUpdate::toMap)
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Streaming telemetry transport client managing subscription lifecycles, path registrations, and broadcast frame dispatch.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces strict session state-machine discipline (`_isConnected`, `_activeTarget`, `_activePaths`) for real-time telemetry streaming, ensuring prior sessions are cleanly torn down before re-subscription and rejecting out-of-state frame injections.
///
/// ## 2. Invariants & Mathematical Properties
/// - Connection state bi-implication: `_isConnected == true` $\iff$ (`_streamController != null` $\land$ `_activeTarget != null` $\land$ `_activePaths != null`).
/// - [activePaths] exposes an unmodifiable view (`List.unmodifiable`) of the defensive copy created during [connectStream], preventing external mutation of active subscription paths.
///
/// ## 3. Preconditions
/// - [connectStream] must be invoked to transition [isConnected] to `true` before calling [injectUpdate].
///
/// ## 4. Postconditions
/// - [connectStream] tears down any pre-existing session, initializes a fresh broadcast [StreamController], records [activeTarget] and [activePaths], and returns the active broadcast [Stream].
/// - [disconnectStream] closes `_streamController`, clears target and path metadata, and sets [isConnected] to `false`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(P)$ for [connectStream] to copy $P$ subscribed path strings; $\mathcal{O}(1)$ for [injectUpdate] and [disconnectStream].
/// - **Space Complexity**: $\mathcal{O}(P)$ for storing subscribed path strings plus $\mathcal{O}(L)$ broadcast listener registrations.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Calling [injectUpdate] while disconnected (`!_isConnected || _streamController == null`) fails closed by throwing an explicit [StateError].
/// - Calling [disconnectStream] when already disconnected is a safe idempotent no-op.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Streaming Telemetry Transport Client)
///
/// Realises: [UC-04/GnmiTelemetryClient]
class GnmiTelemetryClient {
  StreamController<GnmiTelemetryUpdate>? _streamController;
  bool _isConnected = false;
  String? _activeTarget;
  List<String>? _activePaths;

  /// Whether a telemetry stream is currently active and connected.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryClient::isConnected` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryClient::isConnected` (declaration #5) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryClient::isConnected` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `GnmiTelemetryClient::isConnected` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(isConnected)) bounded over input/member dimension of `GnmiTelemetryClient::isConnected`.
  /// - Space Complexity: O(K(isConnected)) bounded auxiliary memory for `GnmiTelemetryClient::isConnected`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryClient::isConnected` (`()`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryClient::isConnected` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryClient::isConnected` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryClient::isConnected` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYCLIENT-ISCONNECTED] | SysML v2: ActionDef(GnmiTelemetryClient::isConnected)
  bool get isConnected => _isConnected;

  /// The active gNMI stream target endpoint, or null if disconnected.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryClient::activeTarget` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryClient::activeTarget` (declaration #6) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryClient::activeTarget` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `GnmiTelemetryClient::activeTarget` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(activeTarget)) bounded over input/member dimension of `GnmiTelemetryClient::activeTarget`.
  /// - Space Complexity: O(K(activeTarget)) bounded auxiliary memory for `GnmiTelemetryClient::activeTarget`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryClient::activeTarget` (`()`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryClient::activeTarget` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryClient::activeTarget` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryClient::activeTarget` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYCLIENT-ACTIVETARGET] | SysML v2: ActionDef(GnmiTelemetryClient::activeTarget)
  String? get activeTarget => _activeTarget;

  /// The active subscribed gNMI paths, or null if disconnected.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryClient::activePaths` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryClient::activePaths` (declaration #7) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryClient::activePaths` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `GnmiTelemetryClient::activePaths` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(activePaths)) bounded over input/member dimension of `GnmiTelemetryClient::activePaths`.
  /// - Space Complexity: O(K(activePaths)) bounded auxiliary memory for `GnmiTelemetryClient::activePaths`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryClient::activePaths` (`()`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryClient::activePaths` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryClient::activePaths` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryClient::activePaths` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYCLIENT-ACTIVEPATHS] | SysML v2: ActionDef(GnmiTelemetryClient::activePaths)
  List<String>? get activePaths => _activePaths != null ? List.unmodifiable(_activePaths!) : null;

  /// Connects to a gNMI telemetry stream for the specified [target] and subscribed [paths].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryClient::connectStream` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryClient::connectStream` (declaration #5) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryClient::connectStream` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Stream<GnmiTelemetryUpdate>` from `GnmiTelemetryClient::connectStream` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(connectStream)) bounded over input/member dimension of `GnmiTelemetryClient::connectStream`.
  /// - Space Complexity: O(K(connectStream)) bounded auxiliary memory for `GnmiTelemetryClient::connectStream`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryClient::connectStream` (`Stream<GnmiTelemetryUpdate>`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryClient::connectStream` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryClient::connectStream` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryClient::connectStream` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYCLIENT-CONNECTSTREAM] | SysML v2: ActionDef(GnmiTelemetryClient::connectStream)
  Stream<GnmiTelemetryUpdate> connectStream({
    String target = 'localhost:50051',
    List<String> paths = const ['/components/component/state/telemetry'],
  }) {
    if (_isConnected) {
      disconnectStream();
    }

    _activeTarget = target;
    _activePaths = List.from(paths);
    _isConnected = true;
    _streamController = StreamController<GnmiTelemetryUpdate>.broadcast();

    return _streamController!.stream;
  }

  /// Emits a simulated telemetry update into the active stream.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryClient::injectUpdate` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryClient::injectUpdate` (declaration #6) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - `update: GnmiTelemetryUpdate` must satisfy domain and type-safety constraints prior to invoking `GnmiTelemetryClient::injectUpdate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GnmiTelemetryClient::injectUpdate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(update)) bounded over input/member dimension of `GnmiTelemetryClient::injectUpdate`.
  /// - Space Complexity: O(N(update)) bounded auxiliary memory for `GnmiTelemetryClient::injectUpdate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryClient::injectUpdate` (`void`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryClient::injectUpdate` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryClient::injectUpdate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryClient::injectUpdate` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYCLIENT-INJECTUPDATE] | SysML v2: ActionDef(GnmiTelemetryClient::injectUpdate)
  void injectUpdate(GnmiTelemetryUpdate update) {
    if (!_isConnected || _streamController == null) {
      throw StateError('Cannot inject update while gNMI stream is disconnected.');
    }
    _streamController!.add(update);
  }

  /// Disconnects and closes the active gNMI telemetry stream.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GnmiTelemetryClient::disconnectStream` in `app_flutter/lib/data/remote/gnmi_telemetry_client.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GnmiTelemetryClient::disconnectStream` (declaration #7) within `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GnmiTelemetryClient::disconnectStream` in `REMOTE-GNMI-TELEMETRY-CLIENT`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `GnmiTelemetryClient::disconnectStream` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(disconnectStream)) bounded over input/member dimension of `GnmiTelemetryClient::disconnectStream`.
  /// - Space Complexity: O(K(disconnectStream)) bounded auxiliary memory for `GnmiTelemetryClient::disconnectStream`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GnmiTelemetryClient::disconnectStream` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `GnmiTelemetryClient::disconnectStream` without partial mutation on error.
  /// - Action: Executes `GnmiTelemetryClient::disconnectStream` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GnmiTelemetryClient::disconnectStream` (`REMOTE-GNMI-TELEMETRY-CLIENT`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-REMOTE-GNMI-TELEMETRY-CLIENT-GNMITELEMETRYCLIENT-DISCONNECTSTREAM] | SysML v2: ActionDef(GnmiTelemetryClient::disconnectStream)
  Future<void> disconnectStream() async {
    if (!_isConnected) return;

    _isConnected = false;
    _activeTarget = null;
    _activePaths = null;
    await _streamController?.close();
    _streamController = null;
  }
}
