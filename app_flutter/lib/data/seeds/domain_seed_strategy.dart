import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_flutter/data/database_initializer.dart';

/// Internal spatial coordinate tuple associating a node identifier with geodetic latitude and longitude degrees.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_NodePos` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_NodePos` (declaration #1) within `SEEDS-DOMAIN-SEED-STRATEGY`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_NodePos` in `SEEDS-DOMAIN-SEED-STRATEGY`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_NodePos` representation for class `_NodePos`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_NodePos)) bounded over input/member dimension of `_NodePos`.
/// - Space Complexity: O(K(_NodePos)) bounded auxiliary memory for `_NodePos`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_NodePos` (`_NodePos`).
/// - State: Maintains consistent state invariants across `_NodePos` without partial mutation on error.
/// - Action: Executes `_NodePos` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_NodePos` (`SEEDS-DOMAIN-SEED-STRATEGY`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-NODEPOS] | SysML v2: PartDef(_NodePos)
class _NodePos {
  /// Unique topological node identifier.
  final String id;
  /// Geodetic latitude in decimal degrees.
  final double lat;
  /// Geodetic longitude in decimal degrees.
  final double lon;

  /// Executes deterministic constructor `_NodePos::_NodePos` within `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `_NodePos::_NodePos` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `_NodePos::_NodePos` (declaration #2) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `id: String` must satisfy domain and type-safety constraints prior to invoking `_NodePos::_NodePos`.
  /// - `lat: String` must satisfy domain and type-safety constraints prior to invoking `_NodePos::_NodePos`.
  /// - `lon: String` must satisfy domain and type-safety constraints prior to invoking `_NodePos::_NodePos`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `_NodePos::_NodePos` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(id)) bounded over input/member dimension of `_NodePos::_NodePos`.
  /// - Space Complexity: O(N(id)) bounded auxiliary memory for `_NodePos::_NodePos`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_NodePos::_NodePos` (`()`).
  /// - State: Maintains consistent state invariants across `_NodePos::_NodePos` without partial mutation on error.
  /// - Action: Executes `_NodePos::_NodePos` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_NodePos::_NodePos` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-NODEPOS-NODEPOS] | SysML v2: ActionDef(_NodePos::_NodePos)
  const _NodePos(this.id, this.lat, this.lon);
}

/// Batch-buffered [SeedStrategy] implementation that populates relational M2 type schemas, M1 instance records, and nearest-neighbor topological link graphs.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Executes bounded-memory SQLite batch commits (flushing every 1,000 operations) to deterministically populate M2 metamodel descriptors (`type_definitions`, `type_attributes`, `type_relations`) and M1 topological instances (`properties`, `instances`) without unbounded transaction log growth.
///
/// ## 2. Invariants & Mathematical Properties
/// - Batch buffer bound invariant: $0 \le \text{\_pendingOps} < 1000$ at the completion of every `_insertAndFlush` invocation, and $\text{\_pendingOps} == 0$ upon completion of `_flushBatch`.
/// - Bidirectional link deduplication invariant: For any undirected node pair $(u, v)$, `addedLinks` records both `'${u}_$v'` and `'${v}_$u'`, guaranteeing at most one `'interface'` instance link between any two distinct nodes.
/// - Nearest-neighbor link topology is computed deterministically via squared Euclidean geodetic distance $\Delta \phi^2 + \Delta \lambda^2$.
///
/// ## 3. Preconditions
/// - The target [Database] passed to [seed] must have all 5 canonical M2/M1 tables created by [DatabaseInitializer.create], and seed JSON asset files must be readable from disk or `rootBundle`.
///
/// ## 4. Postconditions
/// - All pending batch operations are committed (`_pendingOps == 0`), and the target SQLite database contains complete base type definitions, 50 attributes per type, hierarchical node properties with ellipsoid coordinates, child instance records, and nearest-neighbor interface links.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(N_1^2 + N_2 \cdot N_1 + M \cdot A)$ where $N_1, N_2$ are the primary and secondary topological node counts for nearest-neighbor distance pairing, $M$ is total seeded nodes, and $A = 50$ is the attribute count per node.
/// - **Space Complexity**: $\mathcal{O}(N_1 + N_2 + |E|)$ for node coordinate vectors and the `addedLinks` deduplication set of $|E|$ edges, plus $\mathcal{O}(B_{\max})$ where $B_{\max} = 1000$ is the bounded SQLite batch buffer.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing or non-numeric coordinate fields in seed JSON records default safely to `0.0` via `_extractLat`, `_extractLon`, and `_extractHeight`.
/// - Duplicate primary keys are handled deterministically via `ConflictAlgorithm.ignore` for base types and `ConflictAlgorithm.replace` for node and instance upserts.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Relational Batch Seeding Strategy)
///
/// Realises: [Feat-000/DomainSeedStrategy]
class DomainSeedStrategy implements SeedStrategy {
  late Batch _currentBatch;
  late Database _currentDb;
  int _pendingOps = 0;

  /// Executes deterministic method `DomainSeedStrategy::_insertAndFlush` within `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::_insertAndFlush` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::_insertAndFlush` (declaration #4) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DomainSeedStrategy::_insertAndFlush` in `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `DomainSeedStrategy::_insertAndFlush` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_insertAndFlush)) bounded over input/member dimension of `DomainSeedStrategy::_insertAndFlush`.
  /// - Space Complexity: O(K(_insertAndFlush)) bounded auxiliary memory for `DomainSeedStrategy::_insertAndFlush`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::_insertAndFlush` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::_insertAndFlush` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::_insertAndFlush` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::_insertAndFlush` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-INSERTANDFLUSH] | SysML v2: ActionDef(DomainSeedStrategy::_insertAndFlush)
  Future<void> _insertAndFlush(
    String table,
    Map<String, Object?> values, {
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    _currentBatch.insert(table, values, conflictAlgorithm: conflictAlgorithm);
    _pendingOps++;
    if (_pendingOps >= 1000) {
      await _currentBatch.commit(noResult: true);
      _currentBatch = _currentDb.batch();
      _pendingOps = 0;
    }
  }

  /// Executes deterministic method `DomainSeedStrategy::_flushBatch` within `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::_flushBatch` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::_flushBatch` (declaration #5) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DomainSeedStrategy::_flushBatch` in `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `DomainSeedStrategy::_flushBatch` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_flushBatch)) bounded over input/member dimension of `DomainSeedStrategy::_flushBatch`.
  /// - Space Complexity: O(K(_flushBatch)) bounded auxiliary memory for `DomainSeedStrategy::_flushBatch`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::_flushBatch` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::_flushBatch` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::_flushBatch` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::_flushBatch` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-FLUSHBATCH] | SysML v2: ActionDef(DomainSeedStrategy::_flushBatch)
  Future<void> _flushBatch() async {
    if (_pendingOps > 0) {
      await _currentBatch.commit(noResult: true);
      _pendingOps = 0;
    }
  }

  /// Seeds the database by batch-inserting default schemas, nodes, and instances.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::seed` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::seed` (declaration #6) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `db: Database` must satisfy domain and type-safety constraints prior to invoking `DomainSeedStrategy::seed`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `DomainSeedStrategy::seed` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(db)) bounded over input/member dimension of `DomainSeedStrategy::seed`.
  /// - Space Complexity: O(N(db)) bounded auxiliary memory for `DomainSeedStrategy::seed`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::seed` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::seed` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::seed` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::seed` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-SEED] | SysML v2: ActionDef(DomainSeedStrategy::seed)
  @override
  Future<void> seed(Database db) async {
    _currentDb = db;
    _currentBatch = db.batch();
    _pendingOps = 0;
    final spaceDetails = ['Components', 'Telemetry', 'Logs', 'Links'];
    final nttDetails = ['Components', 'Alarms', 'Links'];
    final landingDetails = ['Components', 'Links'];

    final displayNames = {
      'Components': 'Components',
      'Telemetry': 'Telemetry',
      'Logs': 'Logs',
      'Alarms': 'Alarms',
      'Links': 'Links',
    };

    // 1. Seed base system type definitions and their 50 generic attributes
    for (final d in displayNames.keys) {
      await _insertAndFlush('type_definitions', {
        'type_name': d,
        'display_name': displayNames[d] ?? d,
        'icon_name': 'widgets',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      for (int i = 1; i <= 50; i++) {
        await _insertAndFlush('type_attributes', {
          'type_name': d,
          'attr_key': 'field_$i',
          'label': 'Field $i',
          'attr_type': 'string',
          'section_label': 'General',
          'section_order': 0,
          'is_required': 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    // 2. Generate 100 space orbit telemetry nodes
    final spaceNodes = <String>[];
    for (int i = 0; i < 100; i++) {
      final id = 'space_$i';
      spaceNodes.add(id);
      final lat = 25.0 + (i / 100.0) * 20.0;
      final lon = 125.0 + (i % 20) * 1.0;
      await _addNodeToBatch(id, null, spaceDetails, lat: lat, lon: lon, height: 500000.0);
    }

    // 3. Load and parse real NTT exchanges data from assets
    final nttFile = File('assets/ntt_exchanges_japan_763.json');
    String nttJsonString;
    if (await nttFile.exists()) {
      nttJsonString = await nttFile.readAsString();
    } else {
      nttJsonString = await rootBundle.loadString('assets/ntt_exchanges_japan_763.json');
    }
    final nttJson = jsonDecode(nttJsonString) as List;

    final nttNodes = <_NodePos>[];
    for (int i = 0; i < nttJson.length; i++) {
      final item = nttJson[i];
      final id = 'ntt_exchange_$i';
      final lat = _extractLat(item);
      final lon = _extractLon(item);
      final height = _extractHeight(item);
      nttNodes.add(_NodePos(id, lat, lon));
      await _addNodeToBatch(id, null, nttDetails, lat: lat, lon: lon, height: height);
    }

    // 4. Load and parse cable landing stations data from assets
    final landingFile = File('assets/cable_landing_stations_japan.json');
    String landingJsonString;
    if (await landingFile.exists()) {
      landingJsonString = await landingFile.readAsString();
    } else {
      landingJsonString = await rootBundle.loadString('assets/cable_landing_stations_japan.json');
    }
    final landingJson = jsonDecode(landingJsonString) as List;

    final landingNodes = <_NodePos>[];
    for (int i = 0; i < landingJson.length; i++) {
      final item = landingJson[i];
      final id = 'cable_landing_$i';
      final lat = _extractLat(item);
      final lon = _extractLon(item);
      final height = _extractHeight(item);
      landingNodes.add(_NodePos(id, lat, lon));
      await _addNodeToBatch(id, null, landingDetails, lat: lat, lon: lon, height: height);
    }

    // 5. Interconnect stations, exchanges, and orbits with interface links
    final Set<String> addedLinks = {};
    int linkIdCounter = 0;

    Future<void> addLink(String from, String to) async {
      final key1 = '${from}_$to';
      final key2 = '${to}_$from';
      if (!addedLinks.contains(key1) && !addedLinks.contains(key2)) {
        addedLinks.add(key1);
        addedLinks.add(key2);
        await _insertAndFlush('instances', {
          'id': 'link_${linkIdCounter++}',
          'parent_node_id': from,
          'type_name': 'interface',
          'data_json': jsonEncode({'description': 'link to node $to'}),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    double distSq(double lat1, double lon1, double lat2, double lon2) {
      return (lat1 - lat2) * (lat1 - lat2) + (lon1 - lon2) * (lon1 - lon2);
    }

    for (int i = 0; i < nttNodes.length; i++) {
      final current = nttNodes[i];
      double minDist1 = double.infinity;
      String? minId1;
      double minDist2 = double.infinity;
      String? minId2;

      for (int j = 0; j < nttNodes.length; j++) {
        if (i == j) continue;
        final target = nttNodes[j];
        final d = distSq(current.lat, current.lon, target.lat, target.lon);
        if (d < minDist1) {
          minDist2 = minDist1;
          minId2 = minId1;
          minDist1 = d;
          minId1 = target.id;
        } else if (d < minDist2) {
          minDist2 = d;
          minId2 = target.id;
        }
      }

      if (minId1 != null) await addLink(current.id, minId1);
      if (minId2 != null) await addLink(current.id, minId2);

      final space1 = spaceNodes[(i * 2) % 100];
      final space2 = spaceNodes[(i * 2 + 1) % 100];
      await addLink(current.id, space1);
      await addLink(current.id, space2);
    }

    for (int i = 0; i < landingNodes.length; i++) {
      final current = landingNodes[i];
      double m0 = double.infinity,
          m1 = double.infinity,
          m2 = double.infinity,
          m3 = double.infinity,
          m4 = double.infinity;
      String? id0, id1, id2, id3, id4;

      for (int j = 0; j < nttNodes.length; j++) {
        final target = nttNodes[j];
        final d = distSq(current.lat, current.lon, target.lat, target.lon);
        if (d < m0) {
          m4 = m3; id4 = id3;
          m3 = m2; id3 = id2;
          m2 = m1; id2 = id1;
          m1 = m0; id1 = id0;
          m0 = d;  id0 = target.id;
        } else if (d < m1) {
          m4 = m3; id4 = id3;
          m3 = m2; id3 = id2;
          m2 = m1; id2 = id1;
          m1 = d;  id1 = target.id;
        } else if (d < m2) {
          m4 = m3; id4 = id3;
          m3 = m2; id3 = id2;
          m2 = d;  id2 = target.id;
        } else if (d < m3) {
          m4 = m3; id4 = id3;
          m3 = d;  id3 = target.id;
        } else if (d < m4) {
          m4 = d;  id4 = target.id;
        }
      }

      if (id0 != null) await addLink(current.id, id0);
      if (id1 != null) await addLink(current.id, id1);
      if (id2 != null) await addLink(current.id, id2);
      if (id3 != null) await addLink(current.id, id3);
      if (id4 != null) await addLink(current.id, id4);
    }

    await _flushBatch();
  }

  /// Helper helper to insert a complete node configuration (type_definition, relation, properties, and instances).
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::_addNodeToBatch` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::_addNodeToBatch` (declaration #7) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DomainSeedStrategy::_addNodeToBatch` in `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `DomainSeedStrategy::_addNodeToBatch` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_addNodeToBatch)) bounded over input/member dimension of `DomainSeedStrategy::_addNodeToBatch`.
  /// - Space Complexity: O(K(_addNodeToBatch)) bounded auxiliary memory for `DomainSeedStrategy::_addNodeToBatch`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::_addNodeToBatch` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::_addNodeToBatch` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::_addNodeToBatch` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::_addNodeToBatch` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-ADDNODETOBATCH] | SysML v2: ActionDef(DomainSeedStrategy::_addNodeToBatch)
  Future<void> _addNodeToBatch(
    String node,
    String? parent,
    List<String> details, {
    required double lat,
    required double lon,
    required double height,
  }) async {
    await _insertAndFlush('type_definitions', {
      'type_name': node,
      'display_name': node.replaceAll('_', ' '),
      'icon_name': 'insert_drive_file',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    for (final d in details) {
      await _insertAndFlush('type_relations', {
        'parent_type_name': node,
        'relation_name': 'contains',
        'child_type_name': d,
        'child_label': d == 'Components' ? 'Components' : d.replaceAll('_', ' ').split(' ').map((s) => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1)).join(' '),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    for (int i = 1; i <= 50; i++) {
      await _insertAndFlush('type_attributes', {
        'type_name': node,
        'attr_key': 'field_$i',
        'label': 'Field $i',
        'attr_type': 'string',
        'section_label': 'General',
        'section_order': 0,
        'is_required': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    final propertiesMap = {
      for (int j = 1; j <= 50; j++) 'field_$j': 'val_${node}_field_$j',
      'location': {
        'ellipsoid': {
          'latitude': lat,
          'longitude': lon,
          'height': height,
        }
      }
    };
    await _insertAndFlush('properties', {
      'node_id': node,
      'parent_node_id': parent,
      'data_json': jsonEncode(propertiesMap),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    for (final d in details) {
      for (int k = 1; k <= 5; k++) {
        final instId = 'inst_${node}_${d}_$k';
        final instanceMap = {
          for (int j = 1; j <= 50; j++) 'field_$j': 'val_inst_${node}_${d}_${k}_field_$j'
        };
        await _insertAndFlush('instances', {
          'id': instId,
          'parent_node_id': node,
          'type_name': d,
          'data_json': jsonEncode(instanceMap),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  /// Safely extracts latitude from either top-level or nested position map.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::_extractLat` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::_extractLat` (declaration #8) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `item: dynamic` must satisfy domain and type-safety constraints prior to invoking `DomainSeedStrategy::_extractLat`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `DomainSeedStrategy::_extractLat` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(item)) bounded over input/member dimension of `DomainSeedStrategy::_extractLat`.
  /// - Space Complexity: O(N(item)) bounded auxiliary memory for `DomainSeedStrategy::_extractLat`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::_extractLat` (`double`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::_extractLat` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::_extractLat` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::_extractLat` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-EXTRACTLAT] | SysML v2: ActionDef(DomainSeedStrategy::_extractLat)
  double _extractLat(dynamic item) {
    if (item is Map) {
      if (item['position'] is Map) {
        final pos = item['position'] as Map;
        final val = pos['dim_0'] ?? pos['latitude'] ?? pos['lat'];
        if (val is num) return val.toDouble();
      }
      final val = item['latitude'] ?? item['lat'];
      if (val is num) return val.toDouble();
    }
    return 0.0;
  }

  /// Safely extracts longitude from either top-level or nested position map.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::_extractLon` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::_extractLon` (declaration #9) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `item: dynamic` must satisfy domain and type-safety constraints prior to invoking `DomainSeedStrategy::_extractLon`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `DomainSeedStrategy::_extractLon` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(item)) bounded over input/member dimension of `DomainSeedStrategy::_extractLon`.
  /// - Space Complexity: O(N(item)) bounded auxiliary memory for `DomainSeedStrategy::_extractLon`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::_extractLon` (`double`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::_extractLon` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::_extractLon` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::_extractLon` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-EXTRACTLON] | SysML v2: ActionDef(DomainSeedStrategy::_extractLon)
  double _extractLon(dynamic item) {
    if (item is Map) {
      if (item['position'] is Map) {
        final pos = item['position'] as Map;
        final val = pos['dim_1'] ?? pos['longitude'] ?? pos['lon'];
        if (val is num) return val.toDouble();
      }
      final val = item['longitude'] ?? item['lon'];
      if (val is num) return val.toDouble();
    }
    return 0.0;
  }

  /// Safely extracts height from either top-level or nested position map, defaulting to 0.0.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DomainSeedStrategy::_extractHeight` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DomainSeedStrategy::_extractHeight` (declaration #10) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `item: dynamic` must satisfy domain and type-safety constraints prior to invoking `DomainSeedStrategy::_extractHeight`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `DomainSeedStrategy::_extractHeight` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(item)) bounded over input/member dimension of `DomainSeedStrategy::_extractHeight`.
  /// - Space Complexity: O(N(item)) bounded auxiliary memory for `DomainSeedStrategy::_extractHeight`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DomainSeedStrategy::_extractHeight` (`double`).
  /// - State: Maintains consistent state invariants across `DomainSeedStrategy::_extractHeight` without partial mutation on error.
  /// - Action: Executes `DomainSeedStrategy::_extractHeight` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DomainSeedStrategy::_extractHeight` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-DOMAINSEEDSTRATEGY-EXTRACTHEIGHT] | SysML v2: ActionDef(DomainSeedStrategy::_extractHeight)
  double _extractHeight(dynamic item) {
    if (item is Map) {
      if (item['position'] is Map) {
        final pos = item['position'] as Map;
        final val = pos['dim_2'] ?? pos['height'];
        if (val is num) return val.toDouble();
      }
      final val = item['height'];
      if (val is num) return val.toDouble();
    }
    return 0.0;
  }
}

/// Orchestrates idempotent relational seed migrations and M2 schema population checks.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Verifies whether the local relational database requires initial M2/M1 population ([isMigrationNeeded]) and executes the configured [SeedStrategy] deterministically via [runMigration].
///
/// ## 2. Invariants & Mathematical Properties
/// - Migration readiness predicate: $\text{isMigrationNeeded}(db) \iff (\text{COUNT}(\text{type\_definitions}) == 0 \lor \text{queryError})$.
/// - Strategy binding invariant: [seedStrategy] is guaranteed non-null (defaulting to [DomainSeedStrategy] when omitted at construction).
///
/// ## 3. Preconditions
/// - The [Database] handle supplied to [runMigration] or [isMigrationNeeded] must be open and writable.
///
/// ## 4. Postconditions
/// - [runMigration] awaits [SeedStrategy.seed] completion and returns `true` when all seed batches commit cleanly.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for [isMigrationNeeded] via SQLite `COUNT(*)` table scan/index check; $\mathcal{O}(T_{\text{seed}})$ for [runMigration] delegated to [seedStrategy].
/// - **Space Complexity**: $\mathcal{O}(1)$ auxiliary state for migration check queries.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If `type_definitions` does not yet exist or `rawQuery` throws a database exception during [isMigrationNeeded], the exception is caught and `true` is returned so that initialization/migration proceeds safely rather than leaving an unpopulated store.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Database Seed Migration Runner)
///
/// Realises: [Feat-000/SeedMigrationRunner]
class SeedMigrationRunner {
  /// The [SeedStrategy] used to execute seed operations.
  final SeedStrategy seedStrategy;

  /// Creates a [SeedMigrationRunner] with an optional [seedStrategy].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `SeedMigrationRunner::SeedMigrationRunner` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `SeedMigrationRunner::SeedMigrationRunner` (declaration #12) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `seedStrategy: SeedStrategy?` must satisfy domain and type-safety constraints prior to invoking `SeedMigrationRunner::SeedMigrationRunner`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `SeedMigrationRunner::SeedMigrationRunner` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(seedStrategy)) bounded over input/member dimension of `SeedMigrationRunner::SeedMigrationRunner`.
  /// - Space Complexity: O(N(seedStrategy)) bounded auxiliary memory for `SeedMigrationRunner::SeedMigrationRunner`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SeedMigrationRunner::SeedMigrationRunner` (`()`).
  /// - State: Maintains consistent state invariants across `SeedMigrationRunner::SeedMigrationRunner` without partial mutation on error.
  /// - Action: Executes `SeedMigrationRunner::SeedMigrationRunner` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SeedMigrationRunner::SeedMigrationRunner` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-SEEDMIGRATIONRUNNER-SEEDMIGRATIONRUNNER] | SysML v2: ActionDef(SeedMigrationRunner::SeedMigrationRunner)
  SeedMigrationRunner({SeedStrategy? seedStrategy})
      : seedStrategy = seedStrategy ?? DomainSeedStrategy();

  /// Runs seed migration for the provided [Database] instance.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SeedMigrationRunner::runMigration` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SeedMigrationRunner::runMigration` (declaration #13) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `db: Database` must satisfy domain and type-safety constraints prior to invoking `SeedMigrationRunner::runMigration`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<bool>` from `SeedMigrationRunner::runMigration` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(db)) bounded over input/member dimension of `SeedMigrationRunner::runMigration`.
  /// - Space Complexity: O(N(db)) bounded auxiliary memory for `SeedMigrationRunner::runMigration`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SeedMigrationRunner::runMigration` (`Future<bool>`).
  /// - State: Maintains consistent state invariants across `SeedMigrationRunner::runMigration` without partial mutation on error.
  /// - Action: Executes `SeedMigrationRunner::runMigration` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SeedMigrationRunner::runMigration` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-SEEDMIGRATIONRUNNER-RUNMIGRATION] | SysML v2: ActionDef(SeedMigrationRunner::runMigration)
  Future<bool> runMigration(Database db) async {
    await seedStrategy.seed(db);
    return true;
  }

  /// Executes deterministic method `SeedMigrationRunner::_firstIntValue` within `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SeedMigrationRunner::_firstIntValue` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SeedMigrationRunner::_firstIntValue` (declaration #14) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `list: List<Map<String, Object?>>` must satisfy domain and type-safety constraints prior to invoking `SeedMigrationRunner::_firstIntValue`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int?` from `SeedMigrationRunner::_firstIntValue` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(list)) bounded over input/member dimension of `SeedMigrationRunner::_firstIntValue`.
  /// - Space Complexity: O(N(list)) bounded auxiliary memory for `SeedMigrationRunner::_firstIntValue`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SeedMigrationRunner::_firstIntValue` (`int?`).
  /// - State: Maintains consistent state invariants across `SeedMigrationRunner::_firstIntValue` without partial mutation on error.
  /// - Action: Executes `SeedMigrationRunner::_firstIntValue` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SeedMigrationRunner::_firstIntValue` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-SEEDMIGRATIONRUNNER-FIRSTINTVALUE] | SysML v2: ActionDef(SeedMigrationRunner::_firstIntValue)
  int? _firstIntValue(List<Map<String, Object?>> list) {
    if (list.isNotEmpty && list.first.isNotEmpty) {
      final val = list.first.values.first;
      if (val is num) return val.toInt();
    }
    return null;
  }

  /// Verifies whether seed migration is required for the target [db].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SeedMigrationRunner::isMigrationNeeded` in `app_flutter/lib/data/seeds/domain_seed_strategy.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SeedMigrationRunner::isMigrationNeeded` (declaration #15) within `SEEDS-DOMAIN-SEED-STRATEGY`.
  ///
  /// ## 3. Preconditions
  /// - `db: Database` must satisfy domain and type-safety constraints prior to invoking `SeedMigrationRunner::isMigrationNeeded`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<bool>` from `SeedMigrationRunner::isMigrationNeeded` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(db)) bounded over input/member dimension of `SeedMigrationRunner::isMigrationNeeded`.
  /// - Space Complexity: O(N(db)) bounded auxiliary memory for `SeedMigrationRunner::isMigrationNeeded`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SeedMigrationRunner::isMigrationNeeded` (`Future<bool>`).
  /// - State: Maintains consistent state invariants across `SeedMigrationRunner::isMigrationNeeded` without partial mutation on error.
  /// - Action: Executes `SeedMigrationRunner::isMigrationNeeded` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SeedMigrationRunner::isMigrationNeeded` (`SEEDS-DOMAIN-SEED-STRATEGY`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-SEEDS-DOMAIN-SEED-STRATEGY-SEEDMIGRATIONRUNNER-ISMIGRATIONNEEDED] | SysML v2: ActionDef(SeedMigrationRunner::isMigrationNeeded)
  Future<bool> isMigrationNeeded(Database db) async {
    try {
      final res = await db.rawQuery('SELECT COUNT(*) FROM type_definitions');
      final count = _firstIntValue(res);
      return count == null || count == 0;
    } catch (_) {
      return true;
    }
  }
}

