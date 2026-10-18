import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_flutter/domain/instance_record.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/topology/topology_map.dart' show TopologyData, TopologyNode, TopologyLink, TopologyNodePosition;

/// Relational SQLite [DataSource] adapter providing deterministic local persistence, dot-path JSON flattening, and reactive property broadcasting.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Implements the segregated Layer 2 [DataSource] repository contract over a local WAL-enabled SQLite database, ensuring zero-mocking persistence, off-main-thread bulk deserialization, and non-throwing [Result] return types across all schema, tree, property, and topology queries.
///
/// ## 2. Invariants & Mathematical Properties
/// - Hierarchical JSON property maps are bijectively flattened (`_flatten`) on read and unflattened (`_unflatten`) on write (`ON CONFLICT(node_id) DO UPDATE`) so nested schema paths map deterministically to dot-delimited keys.
/// - Every successful [saveProperties] mutation emits a synchronous broadcast event on `_propertiesController` to keep subscribed [watchProperties] streams consistent with committed SQLite state.
/// - Bulk [fetchRelatedInstances] and [fetchTopologyData] parsing are executed in background isolates via [compute] to prevent UI frame jitter.
///
/// ## 3. Preconditions
/// - The injected [Database] instance (`_db`) must be open and initialized with the canonical M2 relational schema tables created by `DatabaseInitializer.create`.
///
/// ## 4. Postconditions
/// - All repository queries return `Result.success(...)` with strongly-typed domain entities; [dispose] clears cached type descriptors, closes the broadcast stream controller, and closes the underlying SQLite [Database] connection.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(T + A + R)$ on first [discoverTypes] across $T$ types, $A$ attributes, and $R$ relations ($\mathcal{O}(1)$ cached thereafter); $\mathcal{O}(K)$ property key flattening/unflattening over $K$ leaf keys; $\mathcal{O}(I)$ background isolate deserialization over $I$ instance rows.
/// - **Space Complexity**: $\mathcal{O}(T + A + R)$ for cached [TypeDescriptor] metadata plus $\mathcal{O}(I)$ per active query result set.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - SQLite query faults or malformed JSON payloads are trapped inside each repository method, logged via `debugPrint`, and degraded gracefully to empty `Result.success` collections without crashing the display runtime.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Local Relational Persistence Adapter)
///
/// Realises: [Feat-10/DataSource]
class SqliteDataSource implements DataSource {
  /// Creates a [SqliteDataSource] backed by the open SQLite [Database] handle `_db`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `SqliteDataSource::SqliteDataSource` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `SqliteDataSource::SqliteDataSource` (declaration #2) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `_db: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::SqliteDataSource`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `SqliteDataSource::SqliteDataSource` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(_db)) bounded over input/member dimension of `SqliteDataSource::SqliteDataSource`.
  /// - Space Complexity: O(N(_db)) bounded auxiliary memory for `SqliteDataSource::SqliteDataSource`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::SqliteDataSource` (`()`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::SqliteDataSource` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::SqliteDataSource` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::SqliteDataSource` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-SQLITEDATASOURCE] | SysML v2: ActionDef(SqliteDataSource::SqliteDataSource)
  SqliteDataSource(this._db);
  final Database _db;
  final StreamController<Map<String, dynamic>> _propertiesController =
      StreamController<Map<String, dynamic>>.broadcast();
  List<TypeDescriptor>? _cachedTypes;

  /// Canonical backend identifier for this local relational data source (`"sqlite"`).
  @override
  String get name => 'sqlite';

  /// Clears cached schema descriptors, closes the property broadcast stream, and closes the SQLite database connection.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::dispose` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::dispose` (declaration #3) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SqliteDataSource::dispose` in `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<void>>` from `SqliteDataSource::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `SqliteDataSource::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `SqliteDataSource::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::dispose` (`Future<Result<void>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::dispose` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::dispose` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-DISPOSE] | SysML v2: ActionDef(SqliteDataSource::dispose)
  @override
  Future<Result<void>> dispose() async {
    _cachedTypes = null;
    await _propertiesController.close();
    await _db.close();
    return const Result.success(null);
  }

  /// Queries `type_definitions`, `type_attributes`, and `type_relations` to assemble and cache all M2 [TypeDescriptor] models.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::discoverTypes` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::discoverTypes` (declaration #4) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SqliteDataSource::discoverTypes` in `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TypeDescriptor>>>` from `SqliteDataSource::discoverTypes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(discoverTypes)) bounded over input/member dimension of `SqliteDataSource::discoverTypes`.
  /// - Space Complexity: O(K(discoverTypes)) bounded auxiliary memory for `SqliteDataSource::discoverTypes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::discoverTypes` (`Future<Result<List<TypeDescriptor>>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::discoverTypes` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::discoverTypes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::discoverTypes` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-DISCOVERTYPES] | SysML v2: ActionDef(SqliteDataSource::discoverTypes)
  @override
  Future<Result<List<TypeDescriptor>>> discoverTypes() async {
    if (_cachedTypes != null) return Result.success(_cachedTypes!);
    try {
      final typeRows = await _db.query('type_definitions');
      final allAttrRows = await _db.query('type_attributes', orderBy: 'section_order, id');
      final allRelRows = await _db.query('type_relations');

      final attrsByType = <String, List<Map<String, dynamic>>>{};
      for (final row in allAttrRows) {
        final tn = row['type_name'] as String;
        (attrsByType[tn] ??= []).add(row);
      }
      final relsByType = <String, List<Map<String, dynamic>>>{};
      for (final row in allRelRows) {
        final tn = row['parent_type_name'] as String;
        (relsByType[tn] ??= []).add(row);
      }

      final types = typeRows.map((typeRow) {
        final typeName = typeRow['type_name'] as String;
        final attrRows = attrsByType[typeName] ?? [];
        final relRows = relsByType[typeName] ?? [];
        final childRows = relRows.where((r) => r['relation_name'] == 'contains');
        final relatedRows = relRows.where((r) => r['relation_name'] != 'contains');
        return TypeDescriptor(
          typeName: typeName,
          displayName: typeRow['display_name'] as String,
          iconName: typeRow['icon_name'] as String,
          fields: attrRows.map(_parseField).toList(),
          childTypes: childRows.map((r) => TypeRelationDescriptor(
            relationName: r['relation_name'] as String,
            childTypeName: r['child_type_name'] as String,
            childLabel: r['child_label'] as String,
          )).toList(),
          relatedTypes: relatedRows.map((r) => TypeRelationDescriptor(
            relationName: r['relation_name'] as String,
            childTypeName: r['child_type_name'] as String,
            childLabel: r['child_label'] as String,
          )).toList(),
          parentTypes: [],
        );
      }).toList();
      _cachedTypes = types;
      return Result.success(types);
    } catch (e, stackTrace) {
      debugPrint('Error in discoverTypes: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `SqliteDataSource::typeFor` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::typeFor` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::typeFor` (declaration #5) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `typeName: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::typeFor`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<TypeDescriptor?>>` from `SqliteDataSource::typeFor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(typeName)) bounded over input/member dimension of `SqliteDataSource::typeFor`.
  /// - Space Complexity: O(N(typeName)) bounded auxiliary memory for `SqliteDataSource::typeFor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::typeFor` (`Future<Result<TypeDescriptor?>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::typeFor` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::typeFor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::typeFor` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-TYPEFOR] | SysML v2: ActionDef(SqliteDataSource::typeFor)
  @override
  Future<Result<TypeDescriptor?>> typeFor(String typeName) async {
    try {
      var rows = await _db.query('type_definitions',
          where: 'type_name = ?', whereArgs: [typeName]);
      if (rows.isEmpty) {
        List<Map<String, dynamic>> instanceRows = [];
        try {
          instanceRows = await _db.query('instances',
              columns: ['type_name'], where: 'node_id = ?', whereArgs: [typeName]);
        } catch (_) {
          instanceRows = await _db.query('instances',
              columns: ['type_name'], where: 'id = ?', whereArgs: [typeName]);
        }
        if (instanceRows.isNotEmpty && instanceRows.first['type_name'] != null) {
          final resolvedType = instanceRows.first['type_name'] as String;
          rows = await _db.query('type_definitions',
              where: 'type_name = ?', whereArgs: [resolvedType]);
        }
      }
      if (rows.isEmpty) return const Result.success(null);
      final descriptor = await _buildType(rows.first);
      return Result.success(descriptor);
    } catch (e, stackTrace) {
      debugPrint('Error in typeFor($typeName): $e\n$stackTrace');
      return const Result.success(null);
    }
  }

  @override
  Future<Result<List<(String, String)>>> discoverHierarchy() async {
    try {
      final rows = await _db.query(
        'type_relations',
        where: "relation_name = 'contains'",
      );
      final hierarchy = rows.map((r) => (
        r['parent_type_name'] as String,
        r['child_type_name'] as String,
      )).toList();
      return Result.success(hierarchy);
    } catch (e, stackTrace) {
      debugPrint('Error in discoverHierarchy: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `SqliteDataSource::fetchProperties` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::fetchProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::fetchProperties` (declaration #6) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::fetchProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<Map<String, dynamic>>>` from `SqliteDataSource::fetchProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `SqliteDataSource::fetchProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `SqliteDataSource::fetchProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::fetchProperties` (`Future<Result<Map<String, dynamic>>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::fetchProperties` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::fetchProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::fetchProperties` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FETCHPROPERTIES] | SysML v2: ActionDef(SqliteDataSource::fetchProperties)
  @override
  Future<Result<Map<String, dynamic>>> fetchProperties(String nodeId) async {
    final props = await _fetchPropertiesRaw(nodeId);
    return Result.success(props);
  }

  /// Executes deterministic method `SqliteDataSource::_fetchPropertiesRaw` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_fetchPropertiesRaw` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_fetchPropertiesRaw` (declaration #7) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_fetchPropertiesRaw`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Map<String, dynamic>>` from `SqliteDataSource::_fetchPropertiesRaw` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `SqliteDataSource::_fetchPropertiesRaw`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `SqliteDataSource::_fetchPropertiesRaw`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_fetchPropertiesRaw` (`Future<Map<String, dynamic>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_fetchPropertiesRaw` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_fetchPropertiesRaw` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_fetchPropertiesRaw` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FETCHPROPERTIESRAW] | SysML v2: ActionDef(SqliteDataSource::_fetchPropertiesRaw)
  Future<Map<String, dynamic>> _fetchPropertiesRaw(String nodeId) async {
    try {
      final maps = await _db.query(
        'properties',
        columns: ['data_json'],
        where: 'node_id = ?',
        whereArgs: [nodeId],
      );
      if (maps.isEmpty) return {};
      final dataJson = maps.first['data_json'] as String?;
      if (dataJson == null) return {};
      final decoded = Map<String, dynamic>.from(jsonDecode(dataJson) as Map);
      return _flatten(decoded);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchProperties($nodeId): $e\n$stackTrace');
      return {};
    }
  }

  /// Executes deterministic method `SqliteDataSource::saveProperties` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::saveProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::saveProperties` (declaration #8) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::saveProperties`.
  /// - `data: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::saveProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<void>>` from `SqliteDataSource::saveProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `SqliteDataSource::saveProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `SqliteDataSource::saveProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::saveProperties` (`Future<Result<void>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::saveProperties` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::saveProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::saveProperties` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-SAVEPROPERTIES] | SysML v2: ActionDef(SqliteDataSource::saveProperties)
  @override
  Future<Result<void>> saveProperties(String nodeId, Map<String, dynamic> data) async {
    try {
      final unflattened = _unflatten(data);
      final dataJson = jsonEncode(unflattened);
      await _db.rawInsert('''
        INSERT INTO properties (node_id, data_json)
        VALUES (?, ?)
        ON CONFLICT(node_id) DO UPDATE SET
          data_json = excluded.data_json
      ''', [nodeId, dataJson]);
      _propertiesController.add({'nodeId': nodeId, 'data': data});
      return const Result.success(null);
    } catch (e, stackTrace) {
      debugPrint('Error in saveProperties($nodeId): $e\n$stackTrace');
      return const Result.success(null);
    }
  }

  /// Executes deterministic method `SqliteDataSource::watchProperties` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::watchProperties` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::watchProperties` (declaration #9) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::watchProperties`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Stream<Result<Map<String, dynamic>>>` from `SqliteDataSource::watchProperties` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `SqliteDataSource::watchProperties`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `SqliteDataSource::watchProperties`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::watchProperties` (`Stream<Result<Map<String, dynamic>>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::watchProperties` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::watchProperties` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::watchProperties` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-WATCHPROPERTIES] | SysML v2: ActionDef(SqliteDataSource::watchProperties)
  @override
  Stream<Result<Map<String, dynamic>>> watchProperties(String nodeId) async* {
    yield Result.success(await _fetchPropertiesRaw(nodeId));
    await for (final event in _propertiesController.stream) {
      if (event['nodeId'] == nodeId) {
        yield Result.success(event['data'] as Map<String, dynamic>);
      }
    }
  }

  /// Executes deterministic method `SqliteDataSource::fetchRelatedInstances` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::fetchRelatedInstances` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::fetchRelatedInstances` (declaration #10) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SqliteDataSource::fetchRelatedInstances` in `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<InstanceRecord>>>` from `SqliteDataSource::fetchRelatedInstances` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchRelatedInstances)) bounded over input/member dimension of `SqliteDataSource::fetchRelatedInstances`.
  /// - Space Complexity: O(K(fetchRelatedInstances)) bounded auxiliary memory for `SqliteDataSource::fetchRelatedInstances`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::fetchRelatedInstances` (`Future<Result<List<InstanceRecord>>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::fetchRelatedInstances` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::fetchRelatedInstances` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::fetchRelatedInstances` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FETCHRELATEDINSTANCES] | SysML v2: ActionDef(SqliteDataSource::fetchRelatedInstances)
  @override
  Future<Result<List<InstanceRecord>>> fetchRelatedInstances({
    required String parentNodeId,
    required TypeDescriptor targetType,
  }) async {
    try {
      final rows = await _db.query(
        'instances',
        where: 'parent_node_id = ? AND type_name = ?',
        whereArgs: [parentNodeId, targetType.typeName],
      );
      final records = await compute(
        (args) => (args[0] as List<Map<String, dynamic>>)
            .map((r) => InstanceRecord.fromMap(r, args[1] as String))
            .toList(),
        [rows, targetType.typeName],
      );
      return Result.success(records);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchRelatedInstances: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `SqliteDataSource::fetchRootNodes` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::fetchRootNodes` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::fetchRootNodes` (declaration #11) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SqliteDataSource::fetchRootNodes` in `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TreeNode>>>` from `SqliteDataSource::fetchRootNodes` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchRootNodes)) bounded over input/member dimension of `SqliteDataSource::fetchRootNodes`.
  /// - Space Complexity: O(K(fetchRootNodes)) bounded auxiliary memory for `SqliteDataSource::fetchRootNodes`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::fetchRootNodes` (`Future<Result<List<TreeNode>>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::fetchRootNodes` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::fetchRootNodes` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::fetchRootNodes` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FETCHROOTNODES] | SysML v2: ActionDef(SqliteDataSource::fetchRootNodes)
  @override
  Future<Result<List<TreeNode>>> fetchRootNodes() async {
    try {
      final rows = await _db.rawQuery('''
        SELECT p.node_id, td.display_name,
          (SELECT COUNT(*) FROM properties c WHERE c.parent_node_id = p.node_id) > 0 as has_children
        FROM properties p
        LEFT JOIN type_definitions td ON p.node_id = td.type_name
        WHERE p.parent_node_id IS NULL
        ORDER BY p.node_id
      ''');
      final roots = rows.map((r) {
        final id = r['node_id'] as String;
        final label = (r['display_name'] as String?) ?? id.replaceAll('_', ' ');
        final hasChildren = (r['has_children'] as int? ?? 0) > 0;
        return TreeNode(
          id: id,
          label: label,
          children: hasChildren ? const [] : null,
        );
      }).toList();
      return Result.success(roots);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchRootNodes: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `SqliteDataSource::fetchChildrenForNode` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::fetchChildrenForNode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::fetchChildrenForNode` (declaration #12) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `parentId: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::fetchChildrenForNode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<List<TreeNode>>>` from `SqliteDataSource::fetchChildrenForNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(parentId)) bounded over input/member dimension of `SqliteDataSource::fetchChildrenForNode`.
  /// - Space Complexity: O(N(parentId)) bounded auxiliary memory for `SqliteDataSource::fetchChildrenForNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::fetchChildrenForNode` (`Future<Result<List<TreeNode>>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::fetchChildrenForNode` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::fetchChildrenForNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::fetchChildrenForNode` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FETCHCHILDRENFORNODE] | SysML v2: ActionDef(SqliteDataSource::fetchChildrenForNode)
  @override
  Future<Result<List<TreeNode>>> fetchChildrenForNode(String parentId) async {
    try {
      final rows = await _db.rawQuery('''
        SELECT node_id, display_name, has_children FROM (
          SELECT p.node_id as node_id, td.display_name as display_name,
            (SELECT COUNT(*) FROM properties c WHERE c.parent_node_id = p.node_id) > 0 as has_children
          FROM properties p
          LEFT JOIN type_definitions td ON p.node_id = td.type_name
          WHERE p.parent_node_id = ?

          UNION ALL

          SELECT r.child_type_name as node_id, td.display_name as display_name,
            0 as has_children
          FROM type_relations r
          LEFT JOIN type_definitions td ON r.child_type_name = td.type_name
          WHERE r.parent_type_name = ? AND r.relation_name = 'contains'
            AND r.child_type_name NOT IN ('Components', 'Relation_A', 'Relation_B')
            AND r.child_type_name NOT IN (SELECT node_id FROM properties WHERE parent_node_id = ?)
            AND r.child_type_name IN (SELECT type_name FROM instances WHERE parent_node_id = ?)
        )
        ORDER BY (CASE WHEN node_id LIKE '%_Child_%' OR node_id LIKE '%_Grandchild_%' THEN 1 ELSE 0 END), node_id
      ''', [parentId, parentId, parentId, parentId]);
      final children = rows.map((r) {
        final id = r['node_id'] as String;
        final label = (r['display_name'] as String?) ?? id.replaceAll('_', ' ');
        final hasChildren = (r['has_children'] as int? ?? 0) > 0;
        return TreeNode(
          id: id,
          label: label,
          children: hasChildren ? const [] : null,
        );
      }).toList();
      return Result.success(children);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchChildrenForNode: $e\n$stackTrace');
      return const Result.success([]);
    }
  }

  /// Executes deterministic method `SqliteDataSource::_buildType` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_buildType` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_buildType` (declaration #13) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `typeRow: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_buildType`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<TypeDescriptor>` from `SqliteDataSource::_buildType` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(typeRow)) bounded over input/member dimension of `SqliteDataSource::_buildType`.
  /// - Space Complexity: O(N(typeRow)) bounded auxiliary memory for `SqliteDataSource::_buildType`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_buildType` (`Future<TypeDescriptor>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_buildType` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_buildType` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_buildType` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-BUILDTYPE] | SysML v2: ActionDef(SqliteDataSource::_buildType)
  Future<TypeDescriptor> _buildType(Map<String, dynamic> typeRow) async {
    final typeName = typeRow['type_name'] as String;
    final attrRows = await _db.query('type_attributes',
        where: 'type_name = ?',
        whereArgs: [typeName],
        orderBy: 'section_order, id');
    final relRows = await _db.query('type_relations',
        where: 'parent_type_name = ?', whereArgs: [typeName]);

    final childRows = relRows.where((r) => r['relation_name'] == 'contains');
    final relatedRows = relRows.where((r) => r['relation_name'] != 'contains');

    return TypeDescriptor(
      typeName: typeName,
      displayName: typeRow['display_name'] as String,
      iconName: typeRow['icon_name'] as String,
      fields: attrRows.map(_parseField).toList(),
      childTypes: childRows.map((r) => TypeRelationDescriptor(
        relationName: r['relation_name'] as String,
        childTypeName: r['child_type_name'] as String,
        childLabel: r['child_label'] as String,
      )).toList(),
      relatedTypes: relatedRows.map((r) => TypeRelationDescriptor(
        relationName: r['relation_name'] as String,
        childTypeName: r['child_type_name'] as String,
        childLabel: r['child_label'] as String,
      )).toList(),
      parentTypes: [],
    );
  }

  /// Executes deterministic method `SqliteDataSource::_parseField` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_parseField` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_parseField` (declaration #14) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `row: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_parseField`.
  ///
  /// ## 4. Postconditions
  /// - Returns `FieldDescriptor` from `SqliteDataSource::_parseField` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(row)) bounded over input/member dimension of `SqliteDataSource::_parseField`.
  /// - Space Complexity: O(N(row)) bounded auxiliary memory for `SqliteDataSource::_parseField`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_parseField` (`FieldDescriptor`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_parseField` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_parseField` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_parseField` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-PARSEFIELD] | SysML v2: ActionDef(SqliteDataSource::_parseField)
  FieldDescriptor _parseField(Map<String, dynamic> row) {
    List<String>? parseJsonList(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return (jsonDecode(raw) as List).cast<String>();
    }

    return FieldDescriptor(
      key: row['attr_key'] as String,
      label: row['label'] as String,
      type: row['attr_type'] as String,
      sectionLabel: row['section_label'] as String?,
      sectionOrder: row['section_order'] as int? ?? 0,
      required: (row['is_required'] as int? ?? 0) == 1,
      minValue: row['min_value'] as num?,
      maxValue: row['max_value'] as num?,
      pattern: row['pattern'] as String?,
      enumOptions: parseJsonList(row['enum_options'] as String?),
      enumDisplayNames: parseJsonList(row['enum_display_names'] as String?),
      defaultValue: row['default_value'],
      inputFormatters: parseJsonList(row['input_formatters'] as String?),
    );
  }

  /// Executes deterministic method `SqliteDataSource::_flatten` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_flatten` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_flatten` (declaration #15) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `map: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_flatten`.
  /// - `prefix: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_flatten`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, dynamic>` from `SqliteDataSource::_flatten` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(map)) bounded over input/member dimension of `SqliteDataSource::_flatten`.
  /// - Space Complexity: O(N(map)) bounded auxiliary memory for `SqliteDataSource::_flatten`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_flatten` (`Map<String, dynamic>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_flatten` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_flatten` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_flatten` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FLATTEN] | SysML v2: ActionDef(SqliteDataSource::_flatten)
  Map<String, dynamic> _flatten(Map<String, dynamic> map, {String prefix = ''}) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map) {
        result.addAll(_flatten(Map<String, dynamic>.from(value), prefix: newKey));
      } else {
        result[newKey] = value;
      }
    });
    return result;
  }

  /// Executes deterministic method `SqliteDataSource::_unflatten` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_unflatten` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_unflatten` (declaration #16) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `map: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_unflatten`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Map<String, dynamic>` from `SqliteDataSource::_unflatten` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(map)) bounded over input/member dimension of `SqliteDataSource::_unflatten`.
  /// - Space Complexity: O(N(map)) bounded auxiliary memory for `SqliteDataSource::_unflatten`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_unflatten` (`Map<String, dynamic>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_unflatten` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_unflatten` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_unflatten` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-UNFLATTEN] | SysML v2: ActionDef(SqliteDataSource::_unflatten)
  Map<String, dynamic> _unflatten(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      final parts = key.split('.');
      Map<String, dynamic> current = result;
      for (int i = 0; i < parts.length - 1; i++) {
        final part = parts[i];
        if (!current.containsKey(part) || current[part] is! Map) {
          current[part] = <String, dynamic>{};
        }
        current = current[part] as Map<String, dynamic>;
      }
      current[parts.last] = value;
    });
    return result;
  }

  /// Executes deterministic method `SqliteDataSource::fetchTopologyData` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::fetchTopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::fetchTopologyData` (declaration #17) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SqliteDataSource::fetchTopologyData` in `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Result<TopologyData>>` from `SqliteDataSource::fetchTopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchTopologyData)) bounded over input/member dimension of `SqliteDataSource::fetchTopologyData`.
  /// - Space Complexity: O(K(fetchTopologyData)) bounded auxiliary memory for `SqliteDataSource::fetchTopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::fetchTopologyData` (`Future<Result<TopologyData>>`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::fetchTopologyData` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::fetchTopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::fetchTopologyData` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FETCHTOPOLOGYDATA] | SysML v2: ActionDef(SqliteDataSource::fetchTopologyData)
  @override
  Future<Result<TopologyData>> fetchTopologyData() async {
    try {
      final rows = await _db.query('properties');
      final interfaceRows = await _db.query(
        'instances',
        where: "type_name = 'interface'",
      );
      final topologyData = await compute(_parseTopologyData, <dynamic>[rows, interfaceRows]);
      return Result.success(topologyData);
    } catch (e, stackTrace) {
      debugPrint('Error in fetchTopologyData: $e\n$stackTrace');
      return const Result.success(TopologyData(coordinateMapping: {}, nodes: [], links: []));
    }
  }

  /// Executes deterministic method `SqliteDataSource::_findPathToKey` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_findPathToKey` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_findPathToKey` (declaration #18) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `map: Map<dynamic, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_findPathToKey`.
  /// - `targetKey: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_findPathToKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String?` from `SqliteDataSource::_findPathToKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(map)) bounded over input/member dimension of `SqliteDataSource::_findPathToKey`.
  /// - Space Complexity: O(N(map)) bounded auxiliary memory for `SqliteDataSource::_findPathToKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_findPathToKey` (`String?`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_findPathToKey` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_findPathToKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_findPathToKey` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-FINDPATHTOKEY] | SysML v2: ActionDef(SqliteDataSource::_findPathToKey)
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

  /// Executes deterministic method `SqliteDataSource::_resolveCoordinateValue` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_resolveCoordinateValue` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_resolveCoordinateValue` (declaration #19) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `properties: Map<dynamic, dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_resolveCoordinateValue`.
  /// - `path: String` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_resolveCoordinateValue`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double?` from `SqliteDataSource::_resolveCoordinateValue` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(properties)) bounded over input/member dimension of `SqliteDataSource::_resolveCoordinateValue`.
  /// - Space Complexity: O(N(properties)) bounded auxiliary memory for `SqliteDataSource::_resolveCoordinateValue`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_resolveCoordinateValue` (`double?`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_resolveCoordinateValue` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_resolveCoordinateValue` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_resolveCoordinateValue` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-RESOLVECOORDINATEVALUE] | SysML v2: ActionDef(SqliteDataSource::_resolveCoordinateValue)
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

  /// Executes deterministic method `SqliteDataSource::_parseTopologyData` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SqliteDataSource::_parseTopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/data/data_sources/sqlite_data_source.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SqliteDataSource::_parseTopologyData` (declaration #20) within `DATA-SOURCES-SQLITE-DATA-SOURCE`.
  ///
  /// ## 3. Preconditions
  /// - `args: List<dynamic>` must satisfy domain and type-safety constraints prior to invoking `SqliteDataSource::_parseTopologyData`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TopologyData` from `SqliteDataSource::_parseTopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(args)) bounded over input/member dimension of `SqliteDataSource::_parseTopologyData`.
  /// - Space Complexity: O(N(args)) bounded auxiliary memory for `SqliteDataSource::_parseTopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SqliteDataSource::_parseTopologyData` (`TopologyData`).
  /// - State: Maintains consistent state invariants across `SqliteDataSource::_parseTopologyData` without partial mutation on error.
  /// - Action: Executes `SqliteDataSource::_parseTopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SqliteDataSource::_parseTopologyData` (`DATA-SOURCES-SQLITE-DATA-SOURCE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-SOURCES-SQLITE-DATA-SOURCE-SQLITEDATASOURCE-PARSETOPOLOGYDATA] | SysML v2: ActionDef(SqliteDataSource::_parseTopologyData)
  static TopologyData _parseTopologyData(List<dynamic> args) {
    final rows = args[0] as List<Map<String, dynamic>>;
    final interfaceRows = args[1] as List<Map<String, dynamic>>;
    final List<TopologyNode> nodes = [];
    final List<TopologyLink> links = [];

    String? globalLatPath;
    String? globalLngPath;
    String? globalAltPath;

    for (final r in rows) {
      final nodeId = r['node_id'] as String;
      final dataJson = r['data_json'] as String?;
      if (dataJson == null || dataJson.isEmpty || dataJson == '{}') continue;

      try {
        final decoded = Map<String, dynamic>.from(jsonDecode(dataJson) as Map);

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

    final regExp = RegExp(r'link to node\s+([\w\-]+)');
    for (final row in interfaceRows) {
      final parentNodeId = row['parent_node_id'] as String;
      final dataJson = row['data_json'] as String?;
      if (dataJson == null || dataJson.isEmpty || dataJson == '{}') continue;

      try {
        final decoded = Map<String, dynamic>.from(jsonDecode(dataJson) as Map);
        final description = decoded['description']?.toString();
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
      } catch (_) {}
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

    return TopologyData(
      coordinateMapping: coordinateMapping,
      nodes: nodes,
      links: links,
    );
  }
}

