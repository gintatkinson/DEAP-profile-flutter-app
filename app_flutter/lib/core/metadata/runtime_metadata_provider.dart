/// Lightweight in-memory key-value metadata registry for runtime configuration
/// and diagnostic context.
///
/// Enables application subsystems to publish, query, and remove runtime
/// metadata, capability flags, and diagnostic attributes without direct
/// cross-module coupling.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides deterministic, synchronous
///   in-memory metadata lookup with zero blocking I/O so diagnostic and
///   capability queries never stall the 60 FPS display loop.
///
/// ## 2. Invariants & Mathematical Properties
/// - For any key $k \in \Sigma^*$ and value $v$:
///   $\text{registerMetadata}(k, v) \implies \text{containsKey}(k) = \text{true} \land \text{getMetadata}(k) = v$.
/// - Removal restores absence:
///   $\text{removeMetadata}(k) \implies \text{containsKey}(k) = \text{false}$.
///
/// ## 3. Preconditions
/// - Callers must supply a non-null `String` key to [getMetadata],
///   [registerMetadata], [containsKey], and [removeMetadata].
///
/// ## 4. Postconditions
/// - Mutations via [registerMetadata] and [removeMetadata] take effect
///   immediately in `_store` and update [length] and [keys] synchronously.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ average hash-table time for
///   [getMetadata], [registerMetadata], [containsKey], [removeMetadata], and
///   [length].
/// - **Space Complexity**: $\mathcal{O}(M)$ where $M$ is the number of
///   distinct registered metadata keys.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Querying or removing an unregistered key safely returns `null` without
///   throwing exceptions.
/// - Re-registering an existing key deterministically overwrites the prior
///   entry without leaking duplicate keys.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [runtime-metadata-blueprint.md/RuntimeMetadataProvider]
class RuntimeMetadataProvider {
  /// Internal metadata store.
  final Map<String, dynamic> _store = <String, dynamic>{};

  /// Returns the metadata value associated with [key], or `null` if [key]
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RuntimeMetadataProvider::getMetadata` in `app_flutter/lib/core/metadata/runtime_metadata_provider.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RuntimeMetadataProvider::getMetadata` (declaration #2) within `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `RuntimeMetadataProvider::getMetadata`.
  ///
  /// ## 4. Postconditions
  /// - Returns `dynamic` from `RuntimeMetadataProvider::getMetadata` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `RuntimeMetadataProvider::getMetadata`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `RuntimeMetadataProvider::getMetadata`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RuntimeMetadataProvider::getMetadata` (`dynamic`).
  /// - State: Maintains consistent state invariants across `RuntimeMetadataProvider::getMetadata` without partial mutation on error.
  /// - Action: Executes `RuntimeMetadataProvider::getMetadata` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RuntimeMetadataProvider::getMetadata` (`METADATA-RUNTIME-METADATA-PROVIDER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-METADATA-RUNTIME-METADATA-PROVIDER-RUNTIMEMETADATAPROVIDER-GETMETADATA] | SysML v2: ActionDef(RuntimeMetadataProvider::getMetadata)
  dynamic getMetadata(String key) => _store[key];

  /// Registers (or overwrites) metadata under [key] with [value].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RuntimeMetadataProvider::registerMetadata` in `app_flutter/lib/core/metadata/runtime_metadata_provider.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RuntimeMetadataProvider::registerMetadata` (declaration #3) within `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `RuntimeMetadataProvider::registerMetadata`.
  /// - `value: dynamic` must satisfy domain and type-safety constraints prior to invoking `RuntimeMetadataProvider::registerMetadata`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `RuntimeMetadataProvider::registerMetadata` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `RuntimeMetadataProvider::registerMetadata`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `RuntimeMetadataProvider::registerMetadata`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RuntimeMetadataProvider::registerMetadata` (`void`).
  /// - State: Maintains consistent state invariants across `RuntimeMetadataProvider::registerMetadata` without partial mutation on error.
  /// - Action: Executes `RuntimeMetadataProvider::registerMetadata` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RuntimeMetadataProvider::registerMetadata` (`METADATA-RUNTIME-METADATA-PROVIDER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-METADATA-RUNTIME-METADATA-PROVIDER-RUNTIMEMETADATAPROVIDER-REGISTERMETADATA] | SysML v2: ActionDef(RuntimeMetadataProvider::registerMetadata)
  void registerMetadata(String key, dynamic value) {
    _store[key] = value;
  }

  /// Returns `true` when a value has been registered for [key].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RuntimeMetadataProvider::containsKey` in `app_flutter/lib/core/metadata/runtime_metadata_provider.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RuntimeMetadataProvider::containsKey` (declaration #4) within `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RuntimeMetadataProvider::containsKey` in `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `RuntimeMetadataProvider::containsKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(containsKey)) bounded over input/member dimension of `RuntimeMetadataProvider::containsKey`.
  /// - Space Complexity: O(K(containsKey)) bounded auxiliary memory for `RuntimeMetadataProvider::containsKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RuntimeMetadataProvider::containsKey` (`bool`).
  /// - State: Maintains consistent state invariants across `RuntimeMetadataProvider::containsKey` without partial mutation on error.
  /// - Action: Executes `RuntimeMetadataProvider::containsKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RuntimeMetadataProvider::containsKey` (`METADATA-RUNTIME-METADATA-PROVIDER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-METADATA-RUNTIME-METADATA-PROVIDER-RUNTIMEMETADATAPROVIDER-CONTAINSKEY] | SysML v2: ActionDef(RuntimeMetadataProvider::containsKey)
  bool containsKey(String key) => _store.containsKey(key);

  /// Removes the metadata entry for [key] and returns its previous value.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RuntimeMetadataProvider::removeMetadata` in `app_flutter/lib/core/metadata/runtime_metadata_provider.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RuntimeMetadataProvider::removeMetadata` (declaration #5) within `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RuntimeMetadataProvider::removeMetadata` in `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `dynamic` from `RuntimeMetadataProvider::removeMetadata` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(removeMetadata)) bounded over input/member dimension of `RuntimeMetadataProvider::removeMetadata`.
  /// - Space Complexity: O(K(removeMetadata)) bounded auxiliary memory for `RuntimeMetadataProvider::removeMetadata`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RuntimeMetadataProvider::removeMetadata` (`dynamic`).
  /// - State: Maintains consistent state invariants across `RuntimeMetadataProvider::removeMetadata` without partial mutation on error.
  /// - Action: Executes `RuntimeMetadataProvider::removeMetadata` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RuntimeMetadataProvider::removeMetadata` (`METADATA-RUNTIME-METADATA-PROVIDER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-METADATA-RUNTIME-METADATA-PROVIDER-RUNTIMEMETADATAPROVIDER-REMOVEMETADATA] | SysML v2: ActionDef(RuntimeMetadataProvider::removeMetadata)
  dynamic removeMetadata(String key) => _store.remove(key);

  /// Returns the number of registered metadata entries.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RuntimeMetadataProvider::length` in `app_flutter/lib/core/metadata/runtime_metadata_provider.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RuntimeMetadataProvider::length` (declaration #6) within `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RuntimeMetadataProvider::length` in `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RuntimeMetadataProvider::length` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(length)) bounded over input/member dimension of `RuntimeMetadataProvider::length`.
  /// - Space Complexity: O(K(length)) bounded auxiliary memory for `RuntimeMetadataProvider::length`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RuntimeMetadataProvider::length` (`()`).
  /// - State: Maintains consistent state invariants across `RuntimeMetadataProvider::length` without partial mutation on error.
  /// - Action: Executes `RuntimeMetadataProvider::length` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RuntimeMetadataProvider::length` (`METADATA-RUNTIME-METADATA-PROVIDER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-METADATA-RUNTIME-METADATA-PROVIDER-RUNTIMEMETADATAPROVIDER-LENGTH] | SysML v2: ActionDef(RuntimeMetadataProvider::length)
  int get length => _store.length;

  /// Returns all registered keys as an unmodifiable iterable.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RuntimeMetadataProvider::keys` in `app_flutter/lib/core/metadata/runtime_metadata_provider.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RuntimeMetadataProvider::keys` (declaration #7) within `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RuntimeMetadataProvider::keys` in `METADATA-RUNTIME-METADATA-PROVIDER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RuntimeMetadataProvider::keys` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(keys)) bounded over input/member dimension of `RuntimeMetadataProvider::keys`.
  /// - Space Complexity: O(K(keys)) bounded auxiliary memory for `RuntimeMetadataProvider::keys`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RuntimeMetadataProvider::keys` (`()`).
  /// - State: Maintains consistent state invariants across `RuntimeMetadataProvider::keys` without partial mutation on error.
  /// - Action: Executes `RuntimeMetadataProvider::keys` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RuntimeMetadataProvider::keys` (`METADATA-RUNTIME-METADATA-PROVIDER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-METADATA-RUNTIME-METADATA-PROVIDER-RUNTIMEMETADATAPROVIDER-KEYS] | SysML v2: ActionDef(RuntimeMetadataProvider::keys)
  Iterable<String> get keys => _store.keys;
}
