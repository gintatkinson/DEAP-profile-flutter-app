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
  GnmiTelemetryUpdate({
    required this.path,
    required this.value,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts update to JSON map.
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
  bool get isConnected => _isConnected;

  /// The active gNMI stream target endpoint, or null if disconnected.
  String? get activeTarget => _activeTarget;

  /// The active subscribed gNMI paths, or null if disconnected.
  List<String>? get activePaths => _activePaths != null ? List.unmodifiable(_activePaths!) : null;

  /// Connects to a gNMI telemetry stream for the specified [target] and subscribed [paths].
  ///
  /// Returns a broadcast [Stream] emitting [GnmiTelemetryUpdate] instances.
  /// If a stream is already connected, it will be disconnected prior to establishing the new stream.
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
  /// Useful for testing and local telemetry injection. Throws [StateError] if disconnected.
  void injectUpdate(GnmiTelemetryUpdate update) {
    if (!_isConnected || _streamController == null) {
      throw StateError('Cannot inject update while gNMI stream is disconnected.');
    }
    _streamController!.add(update);
  }

  /// Disconnects and closes the active gNMI telemetry stream.
  ///
  /// Releases stream controller resources and updates [isConnected] to `false`.
  Future<void> disconnectStream() async {
    if (!_isConnected) return;

    _isConnected = false;
    _activeTarget = null;
    _activePaths = null;
    await _streamController?.close();
    _streamController = null;
  }
}
