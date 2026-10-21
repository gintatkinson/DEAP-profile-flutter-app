import 'package:flutter/foundation.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/topology/topology_map.dart' show TopologyData;
import 'instance_record.dart';
import 'result.dart';
import 'type_descriptor.dart';

/// Segregated repository interface for M2 schema type discovery and hierarchy
/// introspection.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces interface segregation
///   (Domain Engineering Standard 6) and total `Result<T>` error handling
///   (Domain Engineering Standard 1) for runtime M2 type discovery without
///   exposing underlying persistence SDKs to presentation layers.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Deterministic Catalog Resolution**: For any `typeName` present in the
///   list returned by [discoverTypes], invoking `typeFor(typeName)` resolves to
///   the corresponding [TypeDescriptor].
/// - **Zero Unchecked Exceptions**: All asynchronous operations return
///   `Future<Result<T>>`.
///
/// ## 3. Preconditions
/// - The underlying data source adapter must be initialized prior to invoking
///   discovery methods.
/// - `typeName` passed to [typeFor] must be a non-null string identifier.
///
/// ## 4. Postconditions
/// - [discoverTypes] yields a `Result` wrapping the list of all registered
///   [TypeDescriptor] schemas.
/// - [typeFor] yields `Success(null)` when `typeName` is unregistered rather
///   than throwing.
/// - [discoverHierarchy] yields directed `(parentType, childType)` pairs.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(T)$ for [discoverTypes] and
///   [discoverHierarchy] across $T$ registered M2 types; $\mathcal{O}(1)$
///   amortized lookup for [typeFor].
/// - **Space Complexity**: $\mathcal{O}(T)$ for the returned descriptor list.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Storage or transport failures are captured inside `Failure<T>` carrying a
///   typed `DomainError`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/TypeRepository, ARCH-M2-001, REQ-DOM-001]
abstract interface class TypeRepository {
  /// Discover all object types known to this data source.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TypeRepository::discoverTypes` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TypeRepository::discoverTypes` (declaration #2) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TypeRepository::discoverTypes` in `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TypeDescriptor>>>` from `TypeRepository::discoverTypes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(discoverTypes)) bounded over input/member dimension of `TypeRepository::discoverTypes`.
  /// - Space Complexity: O(K(discoverTypes)) bounded auxiliary memory for `TypeRepository::discoverTypes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeRepository::discoverTypes` (`Future<Result<List<TypeDescriptor>>>`).
  /// - State: Maintains consistent state invariants across `TypeRepository::discoverTypes` without partial mutation on error.
  /// - Action: Executes `TypeRepository::discoverTypes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeRepository::discoverTypes` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-TYPEREPOSITORY-DISCOVERTYPES] | SysML v2: ActionDef(TypeRepository::discoverTypes)
  Future<Result<List<TypeDescriptor>>> discoverTypes();

  /// Get the [TypeDescriptor] for a specific type by its [typeName].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TypeRepository::typeFor` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TypeRepository::typeFor` (declaration #3) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `typeName: String` must satisfy domain and type-safety constraints prior to invoking `TypeRepository::typeFor`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<TypeDescriptor?>>` from `TypeRepository::typeFor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(typeName)) bounded over input/member dimension of `TypeRepository::typeFor`.
  /// - Space Complexity: O(N(typeName)) bounded auxiliary memory for `TypeRepository::typeFor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TypeRepository::typeFor` (`Future<Result<TypeDescriptor?>>`).
  /// - State: Maintains consistent state invariants across `TypeRepository::typeFor` without partial mutation on error.
  /// - Action: Executes `TypeRepository::typeFor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TypeRepository::typeFor` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-TYPEREPOSITORY-TYPEFOR] | SysML v2: ActionDef(TypeRepository::typeFor)
  Future<Result<TypeDescriptor?>> typeFor(String typeName);

  /// Discover the tree hierarchy: parent-child relationships.
  Future<Result<List<(String, String)>>> discoverHierarchy();
}

/// Segregated repository interface for node property read, write, and reactive
/// observation operations.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Isolates M1 instance attribute
///   persistence and telemetry streaming behind a narrow, strongly-typed
///   contract returning `Result<T>` outcomes.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Read-After-Write Consistency**: Following a successful
///   `saveProperties(nodeId, data)` completion, subsequent `fetchProperties(nodeId)`
///   and `watchProperties(nodeId)` emissions reflect the committed `data` map.
///
/// ## 3. Preconditions
/// - `nodeId` must be a non-empty identifier referencing a target M1 node.
/// - `data` passed to [saveProperties] must satisfy the node's M2
///   [FieldDescriptor] constraints.
///
/// ## 4. Postconditions
/// - [fetchProperties] returns the current key-value attribute map wrapped in
///   [Result].
/// - [saveProperties] commits the attribute map and notifies active
///   [watchProperties] stream subscribers.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(A)$ serialization/deserialization per
///   operation for $A$ attributes on `nodeId`.
/// - **Space Complexity**: $\mathcal{O}(A)$ per property map snapshot.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing node identifiers or persistence write faults return
///   `Result.failure(DomainError)` without raising unhandled exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/PropertyRepository, ARCH-M2-001, REQ-DOM-002]
abstract interface class PropertyRepository {
  /// Fetches the property map for the node identified by [nodeId].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertyRepository::fetchProperties` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertyRepository::fetchProperties` (declaration #5) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertyRepository::fetchProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<Map<String, dynamic>>>` from `PropertyRepository::fetchProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `PropertyRepository::fetchProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `PropertyRepository::fetchProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertyRepository::fetchProperties` (`Future<Result<Map<String, dynamic>>>`).
  /// - State: Maintains consistent state invariants across `PropertyRepository::fetchProperties` without partial mutation on error.
  /// - Action: Executes `PropertyRepository::fetchProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertyRepository::fetchProperties` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-PROPERTYREPOSITORY-FETCHPROPERTIES] | SysML v2: ActionDef(PropertyRepository::fetchProperties)
  Future<Result<Map<String, dynamic>>> fetchProperties(String nodeId);

  /// Persists [data] as the properties for [nodeId].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertyRepository::saveProperties` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertyRepository::saveProperties` (declaration #6) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertyRepository::saveProperties`.
  /// - `data: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `PropertyRepository::saveProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<void>>` from `PropertyRepository::saveProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `PropertyRepository::saveProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `PropertyRepository::saveProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertyRepository::saveProperties` (`Future<Result<void>>`).
  /// - State: Maintains consistent state invariants across `PropertyRepository::saveProperties` without partial mutation on error.
  /// - Action: Executes `PropertyRepository::saveProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertyRepository::saveProperties` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-PROPERTYREPOSITORY-SAVEPROPERTIES] | SysML v2: ActionDef(PropertyRepository::saveProperties)
  Future<Result<void>> saveProperties(String nodeId, Map<String, dynamic> data);

  /// Returns a broadcast stream emitting property updates for [nodeId].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertyRepository::watchProperties` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertyRepository::watchProperties` (declaration #7) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertyRepository::watchProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Stream<Result<Map<String, dynamic>>>` from `PropertyRepository::watchProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `PropertyRepository::watchProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `PropertyRepository::watchProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertyRepository::watchProperties` (`Stream<Result<Map<String, dynamic>>>`).
  /// - State: Maintains consistent state invariants across `PropertyRepository::watchProperties` without partial mutation on error.
  /// - Action: Executes `PropertyRepository::watchProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertyRepository::watchProperties` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-PROPERTYREPOSITORY-WATCHPROPERTIES] | SysML v2: ActionDef(PropertyRepository::watchProperties)
  Stream<Result<Map<String, dynamic>>> watchProperties(String nodeId);
}

/// Segregated repository interface for hierarchical M1 tree node queries.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Decouples hierarchical navigation
///   tree queries from underlying storage engines while enforcing explicit
///   `Result<List<TreeNode>>` error containment.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Referential Hierarchy Integrity**: Every [TreeNode] returned by
///   `fetchChildrenForNode(parentId)` has `parentId` as its structural parent.
///
/// ## 3. Preconditions
/// - `parentId` passed to [fetchChildrenForNode] must be a non-null node
///   identifier.
///
/// ## 4. Postconditions
/// - [fetchRootNodes] returns all top-level [TreeNode] instances (`parentId == null`).
/// - [fetchChildrenForNode] returns the immediate child nodes of `parentId` (or
///   an empty list if `parentId` is a leaf node).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(N_{\text{root}})$ for [fetchRootNodes]
///   and $\mathcal{O}(N_{\text{children}})$ for [fetchChildrenForNode].
/// - **Space Complexity**: $\mathcal{O}(N)$ proportional to the number of
///   returned [TreeNode] records.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unknown `parentId` values resolve safely to `Success(<TreeNode>[])`;
///   backend query errors return `Failure`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/TreeRepository, ARCH-M2-001, REQ-DOM-003]
abstract interface class TreeRepository {
  /// Fetches root nodes for display in the tree view.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeRepository::fetchRootNodes` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeRepository::fetchRootNodes` (declaration #9) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TreeRepository::fetchRootNodes` in `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TreeNode>>>` from `TreeRepository::fetchRootNodes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchRootNodes)) bounded over input/member dimension of `TreeRepository::fetchRootNodes`.
  /// - Space Complexity: O(K(fetchRootNodes)) bounded auxiliary memory for `TreeRepository::fetchRootNodes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeRepository::fetchRootNodes` (`Future<Result<List<TreeNode>>>`).
  /// - State: Maintains consistent state invariants across `TreeRepository::fetchRootNodes` without partial mutation on error.
  /// - Action: Executes `TreeRepository::fetchRootNodes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeRepository::fetchRootNodes` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-TREEREPOSITORY-FETCHROOTNODES] | SysML v2: ActionDef(TreeRepository::fetchRootNodes)
  Future<Result<List<TreeNode>>> fetchRootNodes();

  /// Fetches child nodes for a given parent node.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TreeRepository::fetchChildrenForNode` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TreeRepository::fetchChildrenForNode` (declaration #10) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `parentId: String` must satisfy domain and type-safety constraints prior to invoking `TreeRepository::fetchChildrenForNode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TreeNode>>>` from `TreeRepository::fetchChildrenForNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(parentId)) bounded over input/member dimension of `TreeRepository::fetchChildrenForNode`.
  /// - Space Complexity: O(N(parentId)) bounded auxiliary memory for `TreeRepository::fetchChildrenForNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TreeRepository::fetchChildrenForNode` (`Future<Result<List<TreeNode>>>`).
  /// - State: Maintains consistent state invariants across `TreeRepository::fetchChildrenForNode` without partial mutation on error.
  /// - Action: Executes `TreeRepository::fetchChildrenForNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TreeRepository::fetchChildrenForNode` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-TREEREPOSITORY-FETCHCHILDRENFORNODE] | SysML v2: ActionDef(TreeRepository::fetchChildrenForNode)
  Future<Result<List<TreeNode>>> fetchChildrenForNode(String parentId);
}

/// Segregated repository interface for network/system topology graph queries.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides a dedicated read contract
///   for spatial and logical graph topology data (`TopologyData`) isolated from
///   mutating repository operations.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Graph Snapshot Consistency**: [fetchTopologyData] returns a coherent
///   point-in-time snapshot of active nodes and directed links wrapped in
///   [Result].
///
/// ## 3. Preconditions
/// - The data source backend must be initialized and connected.
///
/// ## 4. Postconditions
/// - Returns `Success<TopologyData>` containing the current node and link sets,
///   or `Failure<TopologyData>` if the query fails.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(|V| + |E|)$ where $|V|$ is the vertex
///   count and $|E|$ is the link count.
/// - **Space Complexity**: $\mathcal{O}(|V| + |E|)$ to hold the graph snapshot.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty databases return an empty `TopologyData` snapshot rather than
///   throwing; storage errors return `Failure`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/TopologyRepository, ARCH-M2-001, REQ-DOM-004]
abstract interface class TopologyRepository {
  /// Fetches all active nodes and links for topology mapping.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyRepository::fetchTopologyData` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyRepository::fetchTopologyData` (declaration #12) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyRepository::fetchTopologyData` in `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<TopologyData>>` from `TopologyRepository::fetchTopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchTopologyData)) bounded over input/member dimension of `TopologyRepository::fetchTopologyData`.
  /// - Space Complexity: O(K(fetchTopologyData)) bounded auxiliary memory for `TopologyRepository::fetchTopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyRepository::fetchTopologyData` (`Future<Result<TopologyData>>`).
  /// - State: Maintains consistent state invariants across `TopologyRepository::fetchTopologyData` without partial mutation on error.
  /// - Action: Executes `TopologyRepository::fetchTopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyRepository::fetchTopologyData` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-TOPOLOGYREPOSITORY-FETCHTOPOLOGYDATA] | SysML v2: ActionDef(TopologyRepository::fetchTopologyData)
  Future<Result<TopologyData>> fetchTopologyData();
}

/// Segregated repository interface for related M1 [InstanceRecord] queries.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Supplies tabular and detail views
///   with typed [InstanceRecord] collections scoped to a parent node and target
///   M2 [TypeDescriptor].
///
/// ## 2. Invariants & Mathematical Properties
/// - **Type & Parent Scoping**: Every [InstanceRecord] in a successful result
///   matches `parentNodeId` and `targetType.typeName`.
///
/// ## 3. Preconditions
/// - `parentNodeId` must be a non-null node identifier and `targetType` must be
///   a valid [TypeDescriptor].
///
/// ## 4. Postconditions
/// - Returns `Result<List<InstanceRecord>>` containing all matching related
///   instances (or an empty list when none exist).
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(K \cdot A)$ for $K$ matching records
///   with $A$ attributes each.
/// - **Space Complexity**: $\mathcal{O}(K \cdot A)$ for the materialized list.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Deserialization or query faults are returned as `Result.failure(DomainError)`
///   without unhandled exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/InstanceRepository, ARCH-M2-001, REQ-DOM-004]
abstract interface class InstanceRepository {
  /// Fetches related instances of [targetType] under [parentNodeId].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `InstanceRepository::fetchRelatedInstances` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `InstanceRepository::fetchRelatedInstances` (declaration #14) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `InstanceRepository::fetchRelatedInstances` in `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<InstanceRecord>>>` from `InstanceRepository::fetchRelatedInstances` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchRelatedInstances)) bounded over input/member dimension of `InstanceRepository::fetchRelatedInstances`.
  /// - Space Complexity: O(K(fetchRelatedInstances)) bounded auxiliary memory for `InstanceRepository::fetchRelatedInstances`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `InstanceRepository::fetchRelatedInstances` (`Future<Result<List<InstanceRecord>>>`).
  /// - State: Maintains consistent state invariants across `InstanceRepository::fetchRelatedInstances` without partial mutation on error.
  /// - Action: Executes `InstanceRepository::fetchRelatedInstances` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `InstanceRepository::fetchRelatedInstances` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-INSTANCEREPOSITORY-FETCHRELATEDINSTANCES] | SysML v2: ActionDef(InstanceRepository::fetchRelatedInstances)
  Future<Result<List<InstanceRecord>>> fetchRelatedInstances({
    required String parentNodeId,
    required TypeDescriptor targetType,
  });
}

/// Unified abstract contract for a swappable persistence backend composed of
/// the five segregated Layer 1 repository interfaces.
///
/// Concrete implementations (`SqliteDataSource`, `FirebaseDataSource`) are
/// resolved dynamically at application bootstrap via `RepositoryResolver`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Satisfies Constitution Section 1.9
///   (Zero-Mocking Live Persistence Mandate) by composing [TypeRepository],
///   [PropertyRepository], [TreeRepository], [TopologyRepository], and
///   [InstanceRepository] into a lifecycle-managed backend contract.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Interface Composition Completeness**: Any [DataSource] implementation
///   satisfies all five segregated repository contracts simultaneously.
/// - **Idempotent Resource Disposal**: Calling [dispose] releases underlying
///   database handles, streams, and network sockets safely.
///
/// ## 3. Preconditions
/// - Concrete instances must be constructed and initialized via
///   `RepositoryResolver` before injection into the widget tree.
///
/// ## 4. Postconditions
/// - Provides a live, non-empty backend identifier via [name] and clean
///   teardown via [dispose].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for [name]; $\mathcal{O}(S)$ for
///   [dispose] across $S$ active stream subscriptions.
/// - **Space Complexity**: $\mathcal{O}(1)$ interface overhead.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Teardown errors during [dispose] are encapsulated inside `Result<void>`
///   rather than propagating uncaught exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/DataSource, ARCH-M2-001, REQ-DOM-001]
abstract class DataSource
    implements
        TypeRepository,
        PropertyRepository,
        TreeRepository,
        TopologyRepository,
        InstanceRepository {
  /// Human-readable name, e.g. "sqlite", "firebase", "grpc".
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DataSource::name` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DataSource::name` (declaration #16) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DataSource::name` in `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `DataSource::name` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(name)) bounded over input/member dimension of `DataSource::name`.
  /// - Space Complexity: O(K(name)) bounded auxiliary memory for `DataSource::name`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DataSource::name` (`()`).
  /// - State: Maintains consistent state invariants across `DataSource::name` without partial mutation on error.
  /// - Action: Executes `DataSource::name` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DataSource::name` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-DATASOURCE-NAME] | SysML v2: ActionDef(DataSource::name)
  String get name;

  /// Releases all resources held by this data source.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DataSource::dispose` in `app_flutter/lib/domain/data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DataSource::dispose` (declaration #17) within `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DataSource::dispose` in `DOMAIN-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<void>>` from `DataSource::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `DataSource::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `DataSource::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DataSource::dispose` (`Future<Result<void>>`).
  /// - State: Maintains consistent state invariants across `DataSource::dispose` without partial mutation on error.
  /// - Action: Executes `DataSource::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DataSource::dispose` (`DOMAIN-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DOMAIN-DATA-SOURCE-DATASOURCE-DISPOSE] | SysML v2: ActionDef(DataSource::dispose)
  Future<Result<void>> dispose();
}


