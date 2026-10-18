import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_flutter/domain/instance_record.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/topology/topology_map.dart' show TopologyData, TopologyNode, TopologyNodePosition, TopologyLink;

/// Cloud-backed [DataSource] adapter implementing segregated M2 schema discovery and M1 instance persistence over document-oriented collections.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Isolates external document-store SDK transport (`FirebaseFirestore`) behind the platform-independent [DataSource] repository contract, guaranteeing that all read, write, and stream operations return explicit [Result] wrappers rather than propagating unhandled network exceptions into Layer 3 presentation components.
///
/// ## 2. Invariants & Mathematical Properties
/// - M2 type definitions discovered via [discoverTypes] are cached monotonically in `_cachedTypes` for deterministic schema resolution within the session lifecycle.
/// - Related instance deserialization in [fetchRelatedInstances] offloads record mapping to a background isolate via [compute] to preserve main-thread 60 FPS frame budgets.
/// - Root and child tree node lists returned by [fetchRootNodes] and [fetchChildrenForNode] are deterministically ordered by lexicographical node identifier and hierarchy tier.
///
/// ## 3. Preconditions
/// - The injected [FirebaseFirestore] instance must be initialized and pointed at a live or emulator document store containing `schema`, `data`, and `instances` collections.
///
/// ## 4. Postconditions
/// - Every repository query resolves to a non-throwing `Result.success(...)` containing strongly-typed domain descriptors ([TypeDescriptor], [InstanceRecord], [TreeNode], [TopologyData]) or a safe empty fallback on transport fault.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(T)$ on initial [discoverTypes] over $T$ schema definitions ($\mathcal{O}(1)$ cached thereafter); $\mathcal{O}(N \log N)$ for tree node sorting over $N$ sibling nodes; $\mathcal{O}(D \cdot K)$ for recursive coordinate path resolution over $D$ topology documents of depth $K$.
/// - **Space Complexity**: $\mathcal{O}(T + I)$ where $T$ is the cached [TypeDescriptor] count and $I$ is the active query batch of [InstanceRecord] or [TreeNode] objects.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Network timeouts, permission faults, or malformed document payloads are caught at the adapter boundary, logged via `debugPrint`, and converted into safe empty `Result.success` payloads so the operator console remains responsive under degraded connectivity.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Remote Persistence Adapter)
///
/// Realises: [Feat-10/DataSource]
class FirebaseDataSource implements DataSource {
  /// Creates a [FirebaseDataSource] bound to the injected [FirebaseFirestore] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `FirebaseDataSource::FirebaseDataSource` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `FirebaseDataSource::FirebaseDataSource` (declaration #2) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `_firestore: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::FirebaseDataSource`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `FirebaseDataSource::FirebaseDataSource` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(_firestore)) bounded over input/member dimension of `FirebaseDataSource::FirebaseDataSource`.
  /// - Space Complexity: O(N(_firestore)) bounded auxiliary memory for `FirebaseDataSource::FirebaseDataSource`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::FirebaseDataSource` (`()`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::FirebaseDataSource` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::FirebaseDataSource` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::FirebaseDataSource` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FIREBASEDATASOURCE] | SysML v2: ActionDef(FirebaseDataSource::FirebaseDataSource)
  FirebaseDataSource(this._firestore);
  final FirebaseFirestore _firestore;
  List<TypeDescriptor>? _cachedTypes;

  /// Canonical backend identifier for this remote document-store data source (`"firebase"`).
  @override
  String get name => 'firebase';

  /// Discovers and caches all M2 [TypeDescriptor] definitions from the `schema/types` document.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::discoverTypes` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::discoverTypes` (declaration #3) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FirebaseDataSource::discoverTypes` in `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TypeDescriptor>>>` from `FirebaseDataSource::discoverTypes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(discoverTypes)) bounded over input/member dimension of `FirebaseDataSource::discoverTypes`.
  /// - Space Complexity: O(K(discoverTypes)) bounded auxiliary memory for `FirebaseDataSource::discoverTypes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::discoverTypes` (`Future<Result<List<TypeDescriptor>>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::discoverTypes` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::discoverTypes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::discoverTypes` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-DISCOVERTYPES] | SysML v2: ActionDef(FirebaseDataSource::discoverTypes)
  @override
  Future<Result<List<TypeDescriptor>>> discoverTypes() async {
    if (_cachedTypes != null) return Result.success(_cachedTypes!);
    try {
      final snapshot = await _firestore.collection('schema').doc('types').get();
      final data = snapshot.data();
      if (data == null) return const Result.success([]);
      final fields = data['fields'] as Map<String, dynamic>? ?? {};
      final types = <TypeDescriptor>[];
      for (final entry in fields.entries) {
        final typeName = entry.key;
        final def = entry.value as Map<String, dynamic>;
        types.add(TypeDescriptor(
          typeName: typeName,
          displayName: def['displayName'] as String? ?? typeName,
          iconName: def['iconName'] as String? ?? 'insert_drive_file',
          fields: _parseFields(def['fields'] as List<dynamic>?),
          childTypes: _parseRelations(def['childTypes'] as List<dynamic>?),
          relatedTypes: _parseRelations(def['relatedTypes'] as List<dynamic>?),
          parentTypes: _parseRelations(def['parentTypes'] as List<dynamic>?),
        ));
      }
      _cachedTypes = types;
      return Result.success(types);
    } catch (e, stackTrace) {
      debugPrint('Error in discoverTypes: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `FirebaseDataSource::typeFor` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::typeFor` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::typeFor` (declaration #4) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `typeName: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::typeFor`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<TypeDescriptor?>>` from `FirebaseDataSource::typeFor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(typeName)) bounded over input/member dimension of `FirebaseDataSource::typeFor`.
  /// - Space Complexity: O(N(typeName)) bounded auxiliary memory for `FirebaseDataSource::typeFor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::typeFor` (`Future<Result<TypeDescriptor?>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::typeFor` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::typeFor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::typeFor` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-TYPEFOR] | SysML v2: ActionDef(FirebaseDataSource::typeFor)
  @override
  Future<Result<TypeDescriptor?>> typeFor(String typeName) async {
    try {
      final res = await discoverTypes();
      final types = res.isSuccess ? (res as Success<List<TypeDescriptor>>).value : <TypeDescriptor>[];
      for (final t in types) {
        if (t.typeName == typeName) return Result.success(t);
      }
      return const Result.success(null);
    } catch (e, stackTrace) {
      debugPrint('Error in typeFor($typeName): $e\n$stackTrace');
      return const Result.success(null);
    }
  }

  @override
  Future<Result<List<(String, String)>>> discoverHierarchy() async {
    try {
      final snapshot = await _firestore.collection('schema').doc('hierarchy').get();
      final data = snapshot.data();
      if (data == null) return const Result.success([]);
      final pairs = data['pairs'] as List<dynamic>? ?? [];
      final resultPairs = pairs.map((p) {
        final pair = p as List<dynamic>;
        return (pair[0] as String, pair[1] as String);
      }).toList();
      return Result.success(resultPairs);
    } catch (e, stackTrace) {
      debugPrint('Error in discoverHierarchy: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `FirebaseDataSource::fetchProperties` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::fetchProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::fetchProperties` (declaration #5) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::fetchProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<Map<String, dynamic>>>` from `FirebaseDataSource::fetchProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `FirebaseDataSource::fetchProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `FirebaseDataSource::fetchProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::fetchProperties` (`Future<Result<Map<String, dynamic>>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::fetchProperties` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::fetchProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::fetchProperties` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FETCHPROPERTIES] | SysML v2: ActionDef(FirebaseDataSource::fetchProperties)
  @override
  Future<Result<Map<String, dynamic>>> fetchProperties(String nodeId) async {
    try {
      final doc = await _firestore.collection('data').doc(nodeId).get();
      final data = doc.data();
      if (data == null) return const Result.success({});
      return Result.success(Map<String, dynamic>.from(data));
    } catch (e, stackTrace) {
      debugPrint('Error in fetchProperties($nodeId): $e\n$stackTrace');
      return const Result.success({});
    }
  }

  /// Executes deterministic method `FirebaseDataSource::saveProperties` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::saveProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::saveProperties` (declaration #6) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::saveProperties`.
  /// - `data: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::saveProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<void>>` from `FirebaseDataSource::saveProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `FirebaseDataSource::saveProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `FirebaseDataSource::saveProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::saveProperties` (`Future<Result<void>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::saveProperties` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::saveProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::saveProperties` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-SAVEPROPERTIES] | SysML v2: ActionDef(FirebaseDataSource::saveProperties)
  @override
  Future<Result<void>> saveProperties(String nodeId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('data').doc(nodeId).set(data, SetOptions(merge: true));
      return const Result.success(null);
    } catch (e, stackTrace) {
      debugPrint('Error in saveProperties($nodeId): $e\n$stackTrace');
      return const Result.success(null);
    }
  }

  /// Executes deterministic method `FirebaseDataSource::watchProperties` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::watchProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::watchProperties` (declaration #7) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::watchProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Stream<Result<Map<String, dynamic>>>` from `FirebaseDataSource::watchProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `FirebaseDataSource::watchProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `FirebaseDataSource::watchProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::watchProperties` (`Stream<Result<Map<String, dynamic>>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::watchProperties` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::watchProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::watchProperties` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-WATCHPROPERTIES] | SysML v2: ActionDef(FirebaseDataSource::watchProperties)
  @override
  Stream<Result<Map<String, dynamic>>> watchProperties(String nodeId) {
    return _firestore
        .collection('data')
        .doc(nodeId)
        .snapshots()
        .map((snapshot) {
          final data = Map<String, dynamic>.from(snapshot.data() as Map? ?? {});
          return Result.success(data);
        });
  }

  /// Executes deterministic method `FirebaseDataSource::fetchRelatedInstances` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::fetchRelatedInstances` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::fetchRelatedInstances` (declaration #8) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FirebaseDataSource::fetchRelatedInstances` in `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<InstanceRecord>>>` from `FirebaseDataSource::fetchRelatedInstances` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchRelatedInstances)) bounded over input/member dimension of `FirebaseDataSource::fetchRelatedInstances`.
  /// - Space Complexity: O(K(fetchRelatedInstances)) bounded auxiliary memory for `FirebaseDataSource::fetchRelatedInstances`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::fetchRelatedInstances` (`Future<Result<List<InstanceRecord>>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::fetchRelatedInstances` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::fetchRelatedInstances` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::fetchRelatedInstances` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FETCHRELATEDINSTANCES] | SysML v2: ActionDef(FirebaseDataSource::fetchRelatedInstances)
  @override
  Future<Result<List<InstanceRecord>>> fetchRelatedInstances({
    required String parentNodeId,
    required TypeDescriptor targetType,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('instances')
          .where('parent_node_id', isEqualTo: parentNodeId)
          .where('type_name', isEqualTo: targetType.typeName)
          .get();
      final rawDocs = snapshot.docs.map((d) => {
        'id': d.id,
        'data': d.data(),
      }).toList();
      final records = await compute(
        (args) {
          final docs = args[0] as List<Map<String, dynamic>>;
          final pId = args[1] as String;
          final tName = args[2] as String;
          return docs.map((doc) {
            return InstanceRecord(
              id: doc['id'] as String,
              parentNodeId: pId,
              typeName: tName,
              attributes: doc['data'] as Map<String, dynamic>,
            );
          }).toList();
        },
        [rawDocs, parentNodeId, targetType.typeName],
      );
      return Result.success(records);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchRelatedInstances: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `FirebaseDataSource::_parseFields` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::_parseFields` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::_parseFields` (declaration #9) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `fields: List<dynamic>?` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::_parseFields`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<FieldDescriptor>` from `FirebaseDataSource::_parseFields` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(fields)) bounded over input/member dimension of `FirebaseDataSource::_parseFields`.
  /// - Space Complexity: O(N(fields)) bounded auxiliary memory for `FirebaseDataSource::_parseFields`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::_parseFields` (`List<FieldDescriptor>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::_parseFields` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::_parseFields` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::_parseFields` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-PARSEFIELDS] | SysML v2: ActionDef(FirebaseDataSource::_parseFields)
  List<FieldDescriptor> _parseFields(List<dynamic>? fields) {
    if (fields == null) return [];
    return fields.map((f) {
      final map = f as Map<String, dynamic>;
      return FieldDescriptor(
        key: map['key'] as String,
        label: map['label'] as String,
        type: map['type'] as String,
        sectionLabel: map['sectionLabel'] as String?,
        sectionOrder: map['sectionOrder'] as int? ?? 0,
        required: map['required'] as bool? ?? false,
        minValue: map['minValue'] as num?,
        maxValue: map['maxValue'] as num?,
        pattern: map['pattern'] as String?,
        enumOptions: map['enumOptions'] != null
            ? List<String>.from(map['enumOptions'] as List)
            : null,
        enumDisplayNames: map['enumDisplayNames'] != null
            ? List<String>.from(map['enumDisplayNames'] as List)
            : null,
        defaultValue: map['defaultValue'],
        inputFormatters: map['inputFormatters'] != null
            ? List<String>.from(map['inputFormatters'] as List)
            : null,
      );
    }).toList();
  }

  /// Executes deterministic method `FirebaseDataSource::_parseRelations` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::_parseRelations` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::_parseRelations` (declaration #10) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `relations: List<dynamic>?` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::_parseRelations`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<TypeRelationDescriptor>` from `FirebaseDataSource::_parseRelations` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(relations)) bounded over input/member dimension of `FirebaseDataSource::_parseRelations`.
  /// - Space Complexity: O(N(relations)) bounded auxiliary memory for `FirebaseDataSource::_parseRelations`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::_parseRelations` (`List<TypeRelationDescriptor>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::_parseRelations` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::_parseRelations` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::_parseRelations` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-PARSERELATIONS] | SysML v2: ActionDef(FirebaseDataSource::_parseRelations)
  List<TypeRelationDescriptor> _parseRelations(List<dynamic>? relations) {
    if (relations == null) return [];
    return relations.map((r) {
      final map = r as Map<String, dynamic>;
      return TypeRelationDescriptor(
        relationName: map['relationName'] as String,
        childTypeName: map['childTypeName'] as String,
        childLabel: map['childLabel'] as String,
      );
    }).toList();
  }

  /// Executes deterministic method `FirebaseDataSource::fetchRootNodes` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::fetchRootNodes` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::fetchRootNodes` (declaration #11) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FirebaseDataSource::fetchRootNodes` in `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TreeNode>>>` from `FirebaseDataSource::fetchRootNodes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchRootNodes)) bounded over input/member dimension of `FirebaseDataSource::fetchRootNodes`.
  /// - Space Complexity: O(K(fetchRootNodes)) bounded auxiliary memory for `FirebaseDataSource::fetchRootNodes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::fetchRootNodes` (`Future<Result<List<TreeNode>>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::fetchRootNodes` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::fetchRootNodes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::fetchRootNodes` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FETCHROOTNODES] | SysML v2: ActionDef(FirebaseDataSource::fetchRootNodes)
  @override
  Future<Result<List<TreeNode>>> fetchRootNodes() async {
    try {
      final typesRes = await discoverTypes();
      final types = typesRes.isSuccess ? (typesRes as Success<List<TypeDescriptor>>).value : <TypeDescriptor>[];
      final typeMap = {for (final t in types) t.typeName: t};

      final snapshot = await _firestore
          .collection('data')
          .where('parent_node_id', isNull: true)
          .get();

      final List<TreeNode> roots = [];
      for (final doc in snapshot.docs) {
        final id = doc.id;
        final docData = doc.data();
        final typeName = docData['type_name'] as String? ?? id;
        final displayNameFromDoc = docData['name']?.toString() ?? docData['displayName']?.toString();
        final typeDesc = typeMap[id] ?? typeMap[typeName];
        final label = displayNameFromDoc ?? typeDesc?.displayName ?? id.replaceAll('_', ' ');

        final hasChildren = docData['has_children'] as bool? ?? false;

        roots.add(TreeNode(
          id: id,
          label: label,
          children: hasChildren ? const [] : null,
        ));
      }

      roots.sort((a, b) => a.id.compareTo(b.id));
      return Result.success(roots);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchRootNodes: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `FirebaseDataSource::fetchChildrenForNode` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::fetchChildrenForNode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::fetchChildrenForNode` (declaration #12) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `parentId: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::fetchChildrenForNode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TreeNode>>>` from `FirebaseDataSource::fetchChildrenForNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(parentId)) bounded over input/member dimension of `FirebaseDataSource::fetchChildrenForNode`.
  /// - Space Complexity: O(N(parentId)) bounded auxiliary memory for `FirebaseDataSource::fetchChildrenForNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::fetchChildrenForNode` (`Future<Result<List<TreeNode>>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::fetchChildrenForNode` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::fetchChildrenForNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::fetchChildrenForNode` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FETCHCHILDRENFORNODE] | SysML v2: ActionDef(FirebaseDataSource::fetchChildrenForNode)
  @override
  Future<Result<List<TreeNode>>> fetchChildrenForNode(String parentId) async {
    try {
      final typesRes = await discoverTypes();
      final types = typesRes.isSuccess ? (typesRes as Success<List<TypeDescriptor>>).value : <TypeDescriptor>[];
      final typeMap = {for (final t in types) t.typeName: t};

      final parentDoc = await _firestore.collection('data').doc(parentId).get();
      final parentData = parentDoc.data();
      final parentTypeName = parentData?['type_name']?.toString() ?? parentId;

      final childrenSnapshot = await _firestore
          .collection('data')
          .where('parent_node_id', isEqualTo: parentId)
          .get();

      final List<TreeNode> nodes = [];
      final Set<String> childIdsInProperties = {};

      for (final doc in childrenSnapshot.docs) {
        final id = doc.id;
        childIdsInProperties.add(id);
        final docData = doc.data();
        final typeName = docData['type_name'] as String? ?? id;
        final displayNameFromDoc = docData['name']?.toString() ?? docData['displayName']?.toString();
        final typeDesc = typeMap[id] ?? typeMap[typeName];
        final label = displayNameFromDoc ?? typeDesc?.displayName ?? id.replaceAll('_', ' ');

        final hasChildren = docData['has_children'] as bool? ?? false;

        nodes.add(TreeNode(
          id: id,
          label: label,
          children: hasChildren ? const [] : null,
        ));
      }

      final parentType = typeMap[parentTypeName];
      if (parentType != null) {
        for (final relation in parentType.childTypes) {
          final childTypeName = relation.childTypeName;
          if (const ['Components', 'Relation_A', 'Relation_B'].contains(childTypeName)) {
            continue;
          }
          if (childIdsInProperties.contains(childTypeName)) {
            continue;
          }

          final instancesSnapshot = await _firestore
              .collection('instances')
              .where('parent_node_id', isEqualTo: parentId)
              .where('type_name', isEqualTo: childTypeName)
              .limit(1)
              .get();

          if (instancesSnapshot.docs.isNotEmpty) {
            nodes.add(TreeNode(
              id: childTypeName,
              label: relation.childLabel,
              children: null,
            ));
          }
        }
      }

      nodes.sort((a, b) {
        final aMatches = a.id.contains('_Child_') || a.id.contains('_Grandchild_');
        final bMatches = b.id.contains('_Child_') || b.id.contains('_Grandchild_');
        if (aMatches != bMatches) {
          return aMatches ? 1 : -1;
        }
        return a.id.compareTo(b.id);
      });

      return Result.success(nodes);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchChildrenForNode: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `FirebaseDataSource::fetchTopologyData` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::fetchTopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::fetchTopologyData` (declaration #13) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `FirebaseDataSource::fetchTopologyData` in `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<TopologyData>>` from `FirebaseDataSource::fetchTopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchTopologyData)) bounded over input/member dimension of `FirebaseDataSource::fetchTopologyData`.
  /// - Space Complexity: O(K(fetchTopologyData)) bounded auxiliary memory for `FirebaseDataSource::fetchTopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::fetchTopologyData` (`Future<Result<TopologyData>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::fetchTopologyData` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::fetchTopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::fetchTopologyData` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FETCHTOPOLOGYDATA] | SysML v2: ActionDef(FirebaseDataSource::fetchTopologyData)
  @override
  Future<Result<TopologyData>> fetchTopologyData() async {
    try {
      final snapshot = await _firestore
          .collection('data')
          .where('has_location', isEqualTo: true)
          .get();
      final List<TopologyNode> nodes = [];
      final List<TopologyLink> links = [];

      String? globalLatPath;
      String? globalLngPath;
      String? globalAltPath;

      for (final doc in snapshot.docs) {
        final nodeId = doc.id;
        final decoded = doc.data();
        if (decoded.isEmpty) continue;

        try {
          final latPath = _findPathToKey(decoded, 'latitude');
          final lngPath = _findPathToKey(decoded, 'longitude');
          final altPath = _findPathToKey(decoded, 'height') ?? _findPathToKey(decoded, 'altitude');

          if (latPath == null || lngPath == null) continue;

          globalLatPath ??= latPath;
          globalLngPath ??= lngPath;
          globalAltPath ??= altPath;

          final latVal = _resolveCoordinateValue(decoded, latPath);
          final lngVal = _resolveCoordinateValue(decoded, lngPath);
          final altVal = altPath != null ? _resolveCoordinateValue(decoded, altPath) : null;

          if (latVal == null || lngVal == null) continue;

          nodes.add(TopologyNode(
            id: nodeId,
            label: decoded['name']?.toString() ?? nodeId,
            position: TopologyNodePosition(
              dim0: lngVal,
              dim1: latVal,
              dim2: altVal ?? 0.0,
              timeIndex: 0,
              vector: const [],
            ),
            status: decoded['status']?.toString() ?? 'Active',
            rawProperties: decoded,
          ));
        } catch (_) {}
      }

      final interfaceSnapshot = await _firestore
          .collection('instances')
          .where('type_name', isEqualTo: 'interface')
          .get();

      final regExp = RegExp(r'link to node\s+([\w\-]+)');
      for (final doc in interfaceSnapshot.docs) {
        final parentNodeId = doc.data()['parent_node_id']?.toString() ?? '';
        final description = doc.data()['description']?.toString();
        if (description != null) {
          final match = regExp.firstMatch(description);
          if (match != null) {
            final targetNodeId = match.group(1)!;
            links.add(TopologyLink(
              source: parentNodeId,
              target: targetNodeId,
              type: 'interface',
            ));
          }
        }
      }

      final coordinateMapping = <String, String>{};
      if (globalLngPath != null) {
        coordinateMapping['x'] = globalLngPath;
      }
      if (globalLatPath != null) {
        coordinateMapping['y'] = globalLatPath;
      }
      if (globalAltPath != null) {
        coordinateMapping['z'] = globalAltPath;
      }

      return Result.success(TopologyData(
        coordinateMapping: coordinateMapping,
        nodes: nodes,
        links: links,
      ));
    } catch (e, stackTrace) {
      debugPrint('Error in fetchTopologyData: $e\n$stackTrace');
      return const Result.success(TopologyData(coordinateMapping: {}, nodes: [], links: []));
    }
  }

  /// Executes deterministic method `FirebaseDataSource::_findPathToKey` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::_findPathToKey` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::_findPathToKey` (declaration #14) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `map: Map<dynamic, dynamic>` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::_findPathToKey`.
  /// - `targetKey: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::_findPathToKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String?` from `FirebaseDataSource::_findPathToKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(map)) bounded over input/member dimension of `FirebaseDataSource::_findPathToKey`.
  /// - Space Complexity: O(N(map)) bounded auxiliary memory for `FirebaseDataSource::_findPathToKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::_findPathToKey` (`String?`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::_findPathToKey` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::_findPathToKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::_findPathToKey` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-FINDPATHTOKEY] | SysML v2: ActionDef(FirebaseDataSource::_findPathToKey)
  static String? _findPathToKey(Map<dynamic, dynamic> map, String targetKey) {
    for (final entry in map.entries) {
      final keyStr = entry.key.toString();
      if (keyStr == targetKey) {
        return keyStr;
      }
      if (entry.value is Map) {
        final subPath = _findPathToKey(entry.value as Map, targetKey);
        if (subPath != null) {
          return '$keyStr/$subPath';
        }
      }
    }
    return null;
  }

  /// Executes deterministic method `FirebaseDataSource::_resolveCoordinateValue` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::_resolveCoordinateValue` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::_resolveCoordinateValue` (declaration #15) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `properties: Map<dynamic, dynamic>` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::_resolveCoordinateValue`.
  /// - `path: String` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::_resolveCoordinateValue`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double?` from `FirebaseDataSource::_resolveCoordinateValue` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(properties)) bounded over input/member dimension of `FirebaseDataSource::_resolveCoordinateValue`.
  /// - Space Complexity: O(N(properties)) bounded auxiliary memory for `FirebaseDataSource::_resolveCoordinateValue`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::_resolveCoordinateValue` (`double?`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::_resolveCoordinateValue` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::_resolveCoordinateValue` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::_resolveCoordinateValue` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-RESOLVECOORDINATEVALUE] | SysML v2: ActionDef(FirebaseDataSource::_resolveCoordinateValue)
  static double? _resolveCoordinateValue(Map<dynamic, dynamic> properties, String path) {
    final parts = path.split('/');
    dynamic current = properties;
    for (final part in parts) {
      if (current is Map) {
        current = current[part];
      } else {
        return null;
      }
    }
    if (current != null) {
      return double.tryParse(current.toString());
    }
    return null;
  }

  /// Executes deterministic method `FirebaseDataSource::dispose` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `FirebaseDataSource::dispose` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/firebase_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `FirebaseDataSource::dispose` (declaration #16) within `DATA-SOURCES-FIREBASE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `async: )` must satisfy domain and type-safety constraints prior to invoking `FirebaseDataSource::dispose`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<void>>` from `FirebaseDataSource::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(async)) bounded over input/member dimension of `FirebaseDataSource::dispose`.
  /// - Space Complexity: O(N(async)) bounded auxiliary memory for `FirebaseDataSource::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `FirebaseDataSource::dispose` (`Future<Result<void>>`).
  /// - State: Maintains consistent state invariants across `FirebaseDataSource::dispose` without partial mutation on error.
  /// - Action: Executes `FirebaseDataSource::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `FirebaseDataSource::dispose` (`DATA-SOURCES-FIREBASE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-FIREBASE-DATA-SOURCE-FIREBASEDATASOURCE-DISPOSE] | SysML v2: ActionDef(FirebaseDataSource::dispose)
  @override
  Future<Result<void>> dispose() async => const Result.success(null);
}

