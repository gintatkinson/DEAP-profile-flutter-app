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
  /// has not been registered.
  ///
  /// The returned type is `dynamic` because metadata values are
  /// intentionally heterogeneous (strings, numbers, booleans, maps, etc.).
  dynamic getMetadata(String key) => _store[key];

  /// Registers (or overwrites) metadata under [key] with [value].
  ///
  /// Any previous value for [key] is silently replaced.
  void registerMetadata(String key, dynamic value) {
    _store[key] = value;
  }

  /// Returns `true` when a value has been registered for [key].
  bool containsKey(String key) => _store.containsKey(key);

  /// Removes the metadata entry for [key] and returns its previous value.
  ///
  /// Returns `null` if [key] was not registered.
  dynamic removeMetadata(String key) => _store.remove(key);

  /// Returns the number of registered metadata entries.
  int get length => _store.length;

  /// Returns all registered keys as an unmodifiable iterable.
  Iterable<String> get keys => _store.keys;
}
