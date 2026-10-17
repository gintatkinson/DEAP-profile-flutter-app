/// Immutable entity mutation record queued for offline-first state synchronization.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Captures an atomic entity mutation (`entityId`, `payload`, `timestamp`) with a deterministic wall-clock timestamp so Layer 2 conflict resolution ([OfflineSyncCoordinator.resolveConflict]) can establish a total causal ordering between local and remote updates.
///
/// ## 2. Invariants & Mathematical Properties
/// - [entityId], [payload], and [timestamp] are immutable (`final`) references assigned at construction.
/// - [timestamp] is guaranteed non-null, defaulting to `DateTime.now()` when omitted.
///
/// ## 3. Preconditions
/// - [entityId] must uniquely identify the target domain instance, and [payload] must contain the serialized attribute state map.
///
/// ## 4. Postconditions
/// - Constructs a timestamped [LocalChange] envelope ready for queueing in [OfflineSyncCoordinator.queueLocalChange].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ reference assignment at construction.
/// - **Space Complexity**: $\mathcal{O}(K)$ where $K$ is the number of entries in [payload].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Omitted [timestamp] defaults safely to `DateTime.now()`, preventing null temporal comparison faults during conflict resolution.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Offline Synchronization Record)
///
/// Realises: [persistence-architecture-blueprint.md/LocalChange]
class LocalChange {
  /// Creates a [LocalChange].
  ///
  /// [entityId] uniquely identifies the domain entity being changed.
  /// [payload] carries the serialised change data.
  /// [timestamp] defaults to [DateTime.now] when omitted.
  LocalChange({
    required this.entityId,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Unique identifier of the entity that was changed.
  final String entityId;

  /// Serialised change payload (e.g. JSON map).
  final Map<String, dynamic> payload;

  /// Wall-clock time at which this change was recorded.
  final DateTime timestamp;
}

/// Deterministic decision outcome for pairwise conflict resolution between a local and remote entity mutation.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Encodes a finite, two-state algebraic outcome (`localWins`, `remoteWins`) for [OfflineSyncCoordinator.resolveConflict], ensuring exhaustive branch handling without ambiguous tie states.
///
/// ## 2. Invariants & Mathematical Properties
/// - Dichotomy invariant: Every conflict evaluation between `local` and `remote` maps to exactly one element of $\{\text{ConflictResult.localWins}, \text{ConflictResult.remoteWins}\}$.
///
/// ## 3. Preconditions
/// - Evaluated only when both a local queued mutation and a remote mutation target the same `entityId`.
///
/// ## 4. Postconditions
/// - Directs [OfflineSyncCoordinator.reconcileWithRemote] to select either `local.payload` ([localWins]) or `remote.payload` ([remoteWins]).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ enum constant evaluation.
/// - **Space Complexity**: $\mathcal{O}(1)$ static enum allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Exhaustive enum representation eliminates unrepresented conflict states.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Conflict Resolution Outcome)
///
/// Realises: [persistence-architecture-blueprint.md/ConflictResult]
enum ConflictResult {
  /// The local change was accepted over the remote.
  localWins,

  /// The remote change was accepted over the local.
  remoteWins,
}

/// Offline-first state synchronization coordinator implementing deterministic Last-Writer-Wins (LWW) conflict resolution.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Coordinates local mutation queueing while disconnected and deterministic reconciliation against remote state changes upon reconnection, guaranteeing total state convergence across local and remote stores.
///
/// ## 2. Invariants & Mathematical Properties
/// - Last-Writer-Wins (LWW) total order with local tie-breaking:
///   $$\text{resolveConflict}(L, R) = \begin{cases} \text{localWins} & \text{if } t_L \ge t_R \\ \text{remoteWins} & \text{if } t_L < t_R \end{cases}$$
/// - Domain coverage invariant: The map returned by [reconcileWithRemote] contains keys equal to the set union $E_{\text{local}} \cup E_{\text{remote}}$.
/// - Post-reconciliation queue emptiness invariant: `_pendingChanges.isEmpty == true` immediately after [reconcileWithRemote] returns.
///
/// ## 3. Preconditions
/// - [remoteChanges] passed to [reconcileWithRemote] must be a valid list of [LocalChange] records representing remote entity mutations.
///
/// ## 4. Postconditions
/// - [reconcileWithRemote] returns a map from each affected `entityId` to its winning attribute payload map and clears `_pendingChanges`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|L| + |R|)$ where $|L|$ is the number of pending local changes and $|R|$ is the number of remote changes indexed in a hash map.
/// - **Space Complexity**: $\mathcal{O}(|L| + |R|)$ for the `_pendingChanges` queue, `remoteIndex` lookup table, and `reconciled` output map.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Duplicate entity entries in [remoteChanges] or `_pendingChanges` are handled deterministically in sequence without throwing key collision exceptions.
/// - [pendingChanges] returns `List.unmodifiable` to prevent external callers from corrupting internal queue state.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Offline Sync Coordinator)
///
/// Realises: [persistence-architecture-blueprint.md/OfflineSyncCoordinator]
class OfflineSyncCoordinator {
  /// Internal queue of pending local changes awaiting sync.
  final List<LocalChange> _pendingChanges = <LocalChange>[];

  /// Returns an unmodifiable view of the pending local changes.
  List<LocalChange> get pendingChanges =>
      List<LocalChange>.unmodifiable(_pendingChanges);

  /// Queues a local mutation for later synchronisation.
  ///
  /// The [change] is appended to the internal queue.  It will be processed
  /// during the next call to [reconcileWithRemote].
  void queueLocalChange(LocalChange change) {
    _pendingChanges.add(change);
  }

  /// Reconciles queued local changes against [remoteChanges].
  ///
  /// For each entity that has both a local and a remote change, calls
  /// [resolveConflict] to determine the winner.  Returns a map of
  /// entity-ID -> winning payload.
  ///
  /// After reconciliation the internal queue is cleared.
  Map<String, Map<String, dynamic>> reconcileWithRemote(
    List<LocalChange> remoteChanges,
  ) {
    final Map<String, Map<String, dynamic>> reconciled =
        <String, Map<String, dynamic>>{};

    // Index remote changes by entity ID (last entry wins if duplicates).
    final Map<String, LocalChange> remoteIndex = <String, LocalChange>{};
    for (final LocalChange remote in remoteChanges) {
      remoteIndex[remote.entityId] = remote;
    }

    // Walk local queue.
    for (final LocalChange local in _pendingChanges) {
      final LocalChange? remote = remoteIndex.remove(local.entityId);
      if (remote == null) {
        // No conflict -- local change is new.
        reconciled[local.entityId] = local.payload;
      } else {
        final ConflictResult result = resolveConflict(local, remote);
        reconciled[local.entityId] =
            result == ConflictResult.localWins ? local.payload : remote.payload;
      }
    }

    // Remaining remote-only changes.
    for (final MapEntry<String, LocalChange> entry in remoteIndex.entries) {
      reconciled[entry.key] = entry.value.payload;
    }

    _pendingChanges.clear();
    return reconciled;
  }

  /// Resolves a conflict between a [local] and [remote] change.
  ///
  /// Uses a **last-writer-wins** strategy: the change with the later
  /// [LocalChange.timestamp] prevails.  When timestamps are equal the
  /// local change wins.
  ConflictResult resolveConflict(LocalChange local, LocalChange remote) {
    if (local.timestamp.isAfter(remote.timestamp) ||
        local.timestamp.isAtSameMomentAs(remote.timestamp)) {
      return ConflictResult.localWins;
    }
    return ConflictResult.remoteWins;
  }
}
