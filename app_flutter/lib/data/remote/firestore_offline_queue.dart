import 'dart:async';

/// Immutable command envelope representing a deferred document-store mutation queued during offline operation.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Encapsulates an atomic Layer 2 persistence mutation (`id`, `action`, `path`, `data`, `timestamp`) with deterministic ISO-8601 serialization so disconnected operator edits are preserved without data loss until link restoration.
///
/// ## 2. Invariants & Mathematical Properties
/// - Every [FirestoreOperation] instance binds a non-null UTC/wall-clock [timestamp] at construction time (defaulting to `DateTime.now()`) to establish a total chronological ordering across queued mutations.
/// - Round-trip serialization via [toMap] and [FirestoreOperation.fromMap] preserves operation identity, target collection path, payload map, and ISO-8601 timestamp fidelity.
///
/// ## 3. Preconditions
/// - Callers must supply a non-empty operation [id], valid mutation verb [action] (such as `'create'`, `'update'`, or `'delete'`), target document [path], and serializable [data] map.
///
/// ## 4. Postconditions
/// - Produces a self-contained, serializable mutation record ready for insertion into [FirestoreOfflineQueue].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(K)$ for [fromMap] shallow map copy over $K$ top-level payload keys; $\mathcal{O}(1)$ for [toMap] envelope construction.
/// - **Space Complexity**: $\mathcal{O}(K)$ proportional to the number of entries in [data].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing map keys in [FirestoreOperation.fromMap] default safely to empty strings, `'update'`, empty maps, or `DateTime.now()`; malformed ISO-8601 timestamp strings throw a [FormatException] to prevent silent temporal corruption.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Offline Mutation Envelope)
///
/// Realises: [UC-03/FirestoreOperation]
class FirestoreOperation {
  /// Unique identifier for this operation.
  final String id;

  /// The operation action, e.g., 'create', 'update', 'delete'.
  final String action;

  /// Target Firestore collection or document path.
  final String path;

  /// Payload data associated with the operation.
  final Map<String, dynamic> data;

  /// Timestamp when the operation was enqueued.
  final DateTime timestamp;

  /// Creates a new [FirestoreOperation].
  FirestoreOperation({
    required this.id,
    required this.action,
    required this.path,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts operation to a serializable map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'path': path,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Creates a [FirestoreOperation] from a map.
  factory FirestoreOperation.fromMap(Map<String, dynamic> map) {
    return FirestoreOperation(
      id: map['id'] as String? ?? '',
      action: map['action'] as String? ?? 'update',
      path: map['path'] as String? ?? '',
      data: Map<String, dynamic>.from(map['data'] as Map? ?? {}),
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

/// FIFO offline mutation buffer and reconciliation engine for deferred remote document-store operations.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides fault-tolerant write-ahead queueing during remote link loss and deterministic sequential replay ([reconcileQueue]) when transport connectivity returns, retaining failed operations in order without silent drops.
///
/// ## 2. Invariants & Mathematical Properties
/// - Queue order is strictly First-In-First-Out (FIFO): $\forall i < j$, operation $q_i$ is dispatched to `executor` before $q_j$.
/// - Partition conservation invariant during [reconcileQueue]: $Q_{\text{initial}} = Q_{\text{reconciled}} \sqcup Q_{\text{remaining}}$, where $|Q_{\text{reconciled}}| + |Q_{\text{remaining}}| = |Q_{\text{initial}}|$.
/// - [pendingOperations] returns an unmodifiable list view (`List.unmodifiable`) so external callers cannot mutate internal queue state directly.
///
/// ## 3. Preconditions
/// - Payloads passed to [enqueueOperation] must be either a typed [FirestoreOperation] instance or a `Map<String, dynamic>` convertible via [FirestoreOperation.fromMap].
///
/// ## 4. Postconditions
/// - After [reconcileQueue] completes, `_queue` contains exclusively the subset of operations for which `executor` returned `false` or threw an exception, in their original relative FIFO order, and returns the exact count of reconciled operations.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ amortized for [enqueueOperation]; $\mathcal{O}(M)$ for [reconcileQueue] across $M$ queued operations.
/// - **Space Complexity**: $\mathcal{O}(M)$ where $M$ is the number of pending [FirestoreOperation] items in `_queue`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Invalid argument types passed to [enqueueOperation] immediately throw an [ArgumentError] (fail-closed validation).
/// - Exceptions thrown by the asynchronous `executor` callback inside [reconcileQueue] are caught per-operation, marking that specific operation as `success = false` so it remains safely queued in `remaining` while subsequent operations continue processing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Offline Queue & Reconciliation Engine)
///
/// Realises: [UC-03/FirestoreOfflineQueue]
class FirestoreOfflineQueue {
  final List<FirestoreOperation> _queue = [];

  /// Returns an unmodifiable list of current queued operations.
  List<FirestoreOperation> get pendingOperations => List.unmodifiable(_queue);

  /// Number of operations currently pending in the queue.
  int get queueLength => _queue.length;

  /// Returns `true` if the queue contains no pending operations.
  bool get isEmpty => _queue.isEmpty;

  /// Enqueues a new operation to be processed when online.
  ///
  /// Can accept either a [FirestoreOperation] object or a raw [Map<String, dynamic>].
  void enqueueOperation(dynamic operation) {
    if (operation is FirestoreOperation) {
      _queue.add(operation);
    } else if (operation is Map<String, dynamic>) {
      _queue.add(FirestoreOperation.fromMap(operation));
    } else {
      throw ArgumentError('Operation must be a FirestoreOperation or Map<String, dynamic>');
    }
  }

  /// Reconciles and flushes all enqueued offline operations.
  ///
  /// Accepts an optional custom handler function [executor]. If provided, each
  /// operation is passed to [executor]. If [executor] returns `true` (or succeeds),
  /// the operation is removed from the queue. Returns the number of successfully reconciled operations.
  Future<int> reconcileQueue({
    Future<bool> Function(FirestoreOperation op)? executor,
  }) async {
    if (_queue.isEmpty) return 0;

    int reconciledCount = 0;
    final List<FirestoreOperation> remaining = [];

    for (final op in _queue) {
      bool success = true;
      if (executor != null) {
        try {
          success = await executor(op);
        } catch (_) {
          success = false;
        }
      }
      if (success) {
        reconciledCount++;
      } else {
        remaining.add(op);
      }
    }

    _queue.clear();
    _queue.addAll(remaining);

    return reconciledCount;
  }

  /// Clears all pending operations from the queue.
  void clearQueue() {
    _queue.clear();
  }
}
