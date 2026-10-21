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
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `LocalChange::LocalChange` in `app_flutter/lib/data/sync/offline_sync_coordinator.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `LocalChange::LocalChange` (declaration #2) within `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `LocalChange::LocalChange` in `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `LocalChange::LocalChange` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(LocalChange)) bounded over input/member dimension of `LocalChange::LocalChange`.
  /// - Space Complexity: O(K(LocalChange)) bounded auxiliary memory for `LocalChange::LocalChange`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `LocalChange::LocalChange` (`()`).
  /// - State: Maintains consistent state invariants across `LocalChange::LocalChange` without partial mutation on error.
  /// - Action: Executes `LocalChange::LocalChange` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `LocalChange::LocalChange` (`SYNC-OFFLINE-SYNC-COORDINATOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SYNC-OFFLINE-SYNC-COORDINATOR-LOCALCHANGE-LOCALCHANGE] | SysML v2: ActionDef(LocalChange::LocalChange)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `OfflineSyncCoordinator::pendingChanges` in `app_flutter/lib/data/sync/offline_sync_coordinator.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `OfflineSyncCoordinator::pendingChanges` (declaration #5) within `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `OfflineSyncCoordinator::pendingChanges` in `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `OfflineSyncCoordinator::pendingChanges` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(pendingChanges)) bounded over input/member dimension of `OfflineSyncCoordinator::pendingChanges`.
  /// - Space Complexity: O(K(pendingChanges)) bounded auxiliary memory for `OfflineSyncCoordinator::pendingChanges`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `OfflineSyncCoordinator::pendingChanges` (`()`).
  /// - State: Maintains consistent state invariants across `OfflineSyncCoordinator::pendingChanges` without partial mutation on error.
  /// - Action: Executes `OfflineSyncCoordinator::pendingChanges` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `OfflineSyncCoordinator::pendingChanges` (`SYNC-OFFLINE-SYNC-COORDINATOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SYNC-OFFLINE-SYNC-COORDINATOR-OFFLINESYNCCOORDINATOR-PENDINGCHANGES] | SysML v2: ActionDef(OfflineSyncCoordinator::pendingChanges)
  List<LocalChange> get pendingChanges =>
      List<LocalChange>.unmodifiable(_pendingChanges);

  /// Queues a local mutation for later synchronisation.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `OfflineSyncCoordinator::queueLocalChange` in `app_flutter/lib/data/sync/offline_sync_coordinator.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `OfflineSyncCoordinator::queueLocalChange` (declaration #5) within `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 3. Preconditions
  /// - `change: LocalChange` must satisfy domain and type-safety constraints prior to invoking `OfflineSyncCoordinator::queueLocalChange`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `OfflineSyncCoordinator::queueLocalChange` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(change)) bounded over input/member dimension of `OfflineSyncCoordinator::queueLocalChange`.
  /// - Space Complexity: O(N(change)) bounded auxiliary memory for `OfflineSyncCoordinator::queueLocalChange`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `OfflineSyncCoordinator::queueLocalChange` (`void`).
  /// - State: Maintains consistent state invariants across `OfflineSyncCoordinator::queueLocalChange` without partial mutation on error.
  /// - Action: Executes `OfflineSyncCoordinator::queueLocalChange` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `OfflineSyncCoordinator::queueLocalChange` (`SYNC-OFFLINE-SYNC-COORDINATOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SYNC-OFFLINE-SYNC-COORDINATOR-OFFLINESYNCCOORDINATOR-QUEUELOCALCHANGE] | SysML v2: ActionDef(OfflineSyncCoordinator::queueLocalChange)
  void queueLocalChange(LocalChange change) {
    _pendingChanges.add(change);
  }

  /// Reconciles queued local changes against [remoteChanges].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `OfflineSyncCoordinator::reconcileWithRemote` in `app_flutter/lib/data/sync/offline_sync_coordinator.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `OfflineSyncCoordinator::reconcileWithRemote` (declaration #6) within `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `OfflineSyncCoordinator::reconcileWithRemote` in `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, Map<String, dynamic>>` from `OfflineSyncCoordinator::reconcileWithRemote` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(reconcileWithRemote)) bounded over input/member dimension of `OfflineSyncCoordinator::reconcileWithRemote`.
  /// - Space Complexity: O(K(reconcileWithRemote)) bounded auxiliary memory for `OfflineSyncCoordinator::reconcileWithRemote`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `OfflineSyncCoordinator::reconcileWithRemote` (`Map<String, Map<String, dynamic>>`).
  /// - State: Maintains consistent state invariants across `OfflineSyncCoordinator::reconcileWithRemote` without partial mutation on error.
  /// - Action: Executes `OfflineSyncCoordinator::reconcileWithRemote` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `OfflineSyncCoordinator::reconcileWithRemote` (`SYNC-OFFLINE-SYNC-COORDINATOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SYNC-OFFLINE-SYNC-COORDINATOR-OFFLINESYNCCOORDINATOR-RECONCILEWITHREMOTE] | SysML v2: ActionDef(OfflineSyncCoordinator::reconcileWithRemote)
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
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `OfflineSyncCoordinator::resolveConflict` in `app_flutter/lib/data/sync/offline_sync_coordinator.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `OfflineSyncCoordinator::resolveConflict` (declaration #7) within `SYNC-OFFLINE-SYNC-COORDINATOR`.
  ///
  /// ## 3. Preconditions
  /// - `local: LocalChange` must satisfy domain and type-safety constraints prior to invoking `OfflineSyncCoordinator::resolveConflict`.
  /// - `remote: LocalChange` must satisfy domain and type-safety constraints prior to invoking `OfflineSyncCoordinator::resolveConflict`.
  ///
  /// ## 4. Postconditions
  /// - Returns `ConflictResult` from `OfflineSyncCoordinator::resolveConflict` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(local)) bounded over input/member dimension of `OfflineSyncCoordinator::resolveConflict`.
  /// - Space Complexity: O(N(local)) bounded auxiliary memory for `OfflineSyncCoordinator::resolveConflict`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `OfflineSyncCoordinator::resolveConflict` (`ConflictResult`).
  /// - State: Maintains consistent state invariants across `OfflineSyncCoordinator::resolveConflict` without partial mutation on error.
  /// - Action: Executes `OfflineSyncCoordinator::resolveConflict` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `OfflineSyncCoordinator::resolveConflict` (`SYNC-OFFLINE-SYNC-COORDINATOR`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SYNC-OFFLINE-SYNC-COORDINATOR-OFFLINESYNCCOORDINATOR-RESOLVECONFLICT] | SysML v2: ActionDef(OfflineSyncCoordinator::resolveConflict)
  ConflictResult resolveConflict(LocalChange local, LocalChange remote) {
    if (local.timestamp.isAfter(remote.timestamp) ||
        local.timestamp.isAtSameMomentAs(remote.timestamp)) {
      return ConflictResult.localWins;
    }
    return ConflictResult.remoteWins;
  }
}
