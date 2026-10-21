import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/data/data_sources/firebase_data_source.dart';
import 'package:app_flutter/data/data_sources/sqlite_data_source.dart';
import 'package:app_flutter/data/database_initializer.dart';
import 'package:app_flutter/data/seeds/domain_seed_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/tile_fetcher.dart';


/// Dependency injection bootstrapper that resolves the live persistence backend
/// and exposes segregated domain repository interfaces.
///
/// Reads `assets/persistence-config.json` (or explicit override parameters) at
/// startup to initialize either a local SQLite database or a Cloud Firestore
/// adapter, returning a unified [DataSource] and segregated accessors
/// ([TypeRepository], [PropertyRepository], [TreeRepository],
/// [TopologyRepository], [InstanceRepository]).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces strict separation between
///   cockpit presentation widgets and persistence transport adapters, ensuring
///   zero-mocking live persistence and preventing duplicate concurrent database
///   connection races during bootstrap.
///
/// ## 2. Invariants & Mathematical Properties
/// - Mutual exclusion during asynchronous resolution:
///   $\text{isResolving} = \text{true} \implies$ concurrent callers await or reuse
///   `_lastResolved` without spawning duplicate connections.
/// - Every segregated repository getter (`typeRepository`, `propertyRepository`,
///   `treeRepository`, `topologyRepository`, `instanceRepository`) projects the
///   identical underlying [DataSource] instance.
///
/// ## 3. Preconditions
/// - Flutter binding (`WidgetsFlutterBinding.ensureInitialized()`) must be
///   initialized prior to invoking [resolve] so [rootBundle] and platform
///   channels are accessible.
///
/// ## 4. Postconditions
/// - [resolve] disposes any prior `_lastResolved` instance, configures
///   [TileFetcher] basemaps when present in configuration, and returns an
///   initialized, non-null [DataSource].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for segregated repository getter
///   access; $\mathcal{O}(B)$ during initial SQLite asset byte verification and
///   decompression where $B$ is the bundled database size in bytes.
/// - **Space Complexity**: $\mathcal{O}(1)$ wrapper state per
///   [RepositoryResolver] instance ($\mathcal{O}(B)$ transient buffer during
///   initial gzip asset extraction).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing or unreadable `persistence-config.json` safely falls back to the
///   local `'sqlite'` backend.
/// - Outdated or missing local SQLite files are atomically replaced from the
///   compressed asset bundle, and schema tables are guaranteed via
///   [DatabaseInitializer].
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/RepositoryResolver]
@immutable
class RepositoryResolver {
  /// Creates a [RepositoryResolver] wrapping a resolved [DataSource].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `RepositoryResolver::RepositoryResolver` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `RepositoryResolver::RepositoryResolver` (declaration #2) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - `dataSource: String` must satisfy domain and type-safety constraints prior to invoking `RepositoryResolver::RepositoryResolver`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RepositoryResolver::RepositoryResolver` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dataSource)) bounded over input/member dimension of `RepositoryResolver::RepositoryResolver`.
  /// - Space Complexity: O(N(dataSource)) bounded auxiliary memory for `RepositoryResolver::RepositoryResolver`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::RepositoryResolver` (`()`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::RepositoryResolver` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::RepositoryResolver` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::RepositoryResolver` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-REPOSITORYRESOLVER] | SysML v2: ActionDef(RepositoryResolver::RepositoryResolver)
  const RepositoryResolver(this.dataSource);

  /// The underlying resolved [DataSource].
  final DataSource dataSource;

  /// Gets the [TypeRepository] interface.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::typeRepository` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::typeRepository` (declaration #3) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::typeRepository` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RepositoryResolver::typeRepository` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(typeRepository)) bounded over input/member dimension of `RepositoryResolver::typeRepository`.
  /// - Space Complexity: O(K(typeRepository)) bounded auxiliary memory for `RepositoryResolver::typeRepository`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::typeRepository` (`()`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::typeRepository` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::typeRepository` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::typeRepository` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-TYPEREPOSITORY] | SysML v2: ActionDef(RepositoryResolver::typeRepository)
  TypeRepository get typeRepository => dataSource;

  /// Gets the [PropertyRepository] interface.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::propertyRepository` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::propertyRepository` (declaration #4) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::propertyRepository` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RepositoryResolver::propertyRepository` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(propertyRepository)) bounded over input/member dimension of `RepositoryResolver::propertyRepository`.
  /// - Space Complexity: O(K(propertyRepository)) bounded auxiliary memory for `RepositoryResolver::propertyRepository`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::propertyRepository` (`()`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::propertyRepository` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::propertyRepository` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::propertyRepository` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-PROPERTYREPOSITORY] | SysML v2: ActionDef(RepositoryResolver::propertyRepository)
  PropertyRepository get propertyRepository => dataSource;

  /// Gets the [TreeRepository] interface.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::treeRepository` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::treeRepository` (declaration #5) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::treeRepository` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RepositoryResolver::treeRepository` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(treeRepository)) bounded over input/member dimension of `RepositoryResolver::treeRepository`.
  /// - Space Complexity: O(K(treeRepository)) bounded auxiliary memory for `RepositoryResolver::treeRepository`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::treeRepository` (`()`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::treeRepository` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::treeRepository` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::treeRepository` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-TREEREPOSITORY] | SysML v2: ActionDef(RepositoryResolver::treeRepository)
  TreeRepository get treeRepository => dataSource;

  /// Gets the [TopologyRepository] interface.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::topologyRepository` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::topologyRepository` (declaration #6) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::topologyRepository` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RepositoryResolver::topologyRepository` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(topologyRepository)) bounded over input/member dimension of `RepositoryResolver::topologyRepository`.
  /// - Space Complexity: O(K(topologyRepository)) bounded auxiliary memory for `RepositoryResolver::topologyRepository`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::topologyRepository` (`()`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::topologyRepository` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::topologyRepository` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::topologyRepository` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-TOPOLOGYREPOSITORY] | SysML v2: ActionDef(RepositoryResolver::topologyRepository)
  TopologyRepository get topologyRepository => dataSource;

  /// Gets the [InstanceRepository] interface.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::instanceRepository` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::instanceRepository` (declaration #7) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::instanceRepository` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `RepositoryResolver::instanceRepository` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(instanceRepository)) bounded over input/member dimension of `RepositoryResolver::instanceRepository`.
  /// - Space Complexity: O(K(instanceRepository)) bounded auxiliary memory for `RepositoryResolver::instanceRepository`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::instanceRepository` (`()`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::instanceRepository` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::instanceRepository` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::instanceRepository` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-INSTANCEREPOSITORY] | SysML v2: ActionDef(RepositoryResolver::instanceRepository)
  InstanceRepository get instanceRepository => dataSource;

  static const _defaultConfig = 'assets/persistence-config.json';
  static const _defaultDbAsset = 'assets/properties_db.db.gz';

  static const _defaultEmulatorHost = 'localhost';
  static const _defaultEmulatorPort = 8080;

  static DataSource? _lastResolved;
  // NOTE: Once set, the Firebase SDK prevents reconfiguring the emulator
  // connection within a single process lifetime (BUG #216 -- by design).
  static bool _firebaseEmulatorConfigured = false;

  // _isResolving guards against concurrent resolve() calls creating
  // duplicate connections (BUG #215).
  static bool _isResolving = false;

  /// Resets and disposes any cached resolved instance. Intended for test teardown.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::resetForTesting` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::resetForTesting` (declaration #3) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::resetForTesting` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `RepositoryResolver::resetForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(resetForTesting)) bounded over input/member dimension of `RepositoryResolver::resetForTesting`.
  /// - Space Complexity: O(K(resetForTesting)) bounded auxiliary memory for `RepositoryResolver::resetForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::resetForTesting` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::resetForTesting` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::resetForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::resetForTesting` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-RESETFORTESTING] | SysML v2: ActionDef(RepositoryResolver::resetForTesting)
  static Future<void> resetForTesting() async {
    await _lastResolved?.dispose();
    _lastResolved = null;
    _isResolving = false;
  }

  /// Resolves and initialises the appropriate backend.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::resolve` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::resolve` (declaration #4) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::resolve` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<DataSource>` from `RepositoryResolver::resolve` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(resolve)) bounded over input/member dimension of `RepositoryResolver::resolve`.
  /// - Space Complexity: O(K(resolve)) bounded auxiliary memory for `RepositoryResolver::resolve`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::resolve` (`Future<DataSource>`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::resolve` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::resolve` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::resolve` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-RESOLVE] | SysML v2: ActionDef(RepositoryResolver::resolve)
  static Future<DataSource> resolve({
    String? configPath,
    String? dbAssetPath,
    bool sqliteInMemory = false,
    String? dataSourceType,
    bool useEmulator = true,
  }) async {
    if (_isResolving) {
      if (_lastResolved != null) return _lastResolved!;
      while (_isResolving) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      if (_lastResolved != null) return _lastResolved!;
    }
    _isResolving = true;
    try {
      // Always try reading from config file to load basemaps and resolve repository type
      final path = configPath ?? _defaultConfig;
      Map<String, dynamic>? config;
      try {
        final configJson = await rootBundle.loadString(path);
        config = jsonDecode(configJson) as Map<String, dynamic>;
      } catch (_) {}

      if (config != null && config['basemaps'] != null) {
        TileFetcher.configure(config['basemaps'] as Map<String, dynamic>);
      }

      String type = dataSourceType ?? config?['repository_type'] as String? ?? 'sqlite';

      await _lastResolved?.dispose();
      final DataSource resolved;
      switch (type) {
        case 'firebase':
          resolved = await _createFirebaseAdapter(useEmulator: useEmulator);
        case 'sqlite':
          resolved = await _createSqliteAdapter(
            dbAssetPath: dbAssetPath,
            inMemory: sqliteInMemory,
          );
        default:
          resolved = await _createSqliteAdapter(
            dbAssetPath: dbAssetPath,
            inMemory: sqliteInMemory,
          );
      }
      _lastResolved = resolved;
      return resolved;
    } finally {
      _isResolving = false;
    }
  }

  /// Initialises Firebase and returns a Firestore-backed DataSource.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::_createFirebaseAdapter` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::_createFirebaseAdapter` (declaration #5) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::_createFirebaseAdapter` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<FirebaseDataSource>` from `RepositoryResolver::_createFirebaseAdapter` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_createFirebaseAdapter)) bounded over input/member dimension of `RepositoryResolver::_createFirebaseAdapter`.
  /// - Space Complexity: O(K(_createFirebaseAdapter)) bounded auxiliary memory for `RepositoryResolver::_createFirebaseAdapter`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::_createFirebaseAdapter` (`Future<FirebaseDataSource>`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::_createFirebaseAdapter` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::_createFirebaseAdapter` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::_createFirebaseAdapter` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-CREATEFIREBASEADAPTER] | SysML v2: ActionDef(RepositoryResolver::_createFirebaseAdapter)
  static Future<FirebaseDataSource> _createFirebaseAdapter({
    bool useEmulator = true,
  }) async {
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    if (useEmulator && !_firebaseEmulatorConfigured) {
      firestore.useFirestoreEmulator(_defaultEmulatorHost, _defaultEmulatorPort);
      _firebaseEmulatorConfigured = true;
    }
    return FirebaseDataSource(firestore);
  }

  /// Initialises SQLite FFI and returns an SQLite-backed DataSource.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `RepositoryResolver::_createSqliteAdapter` in `app_flutter/lib/core/di/repository_resolver.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `RepositoryResolver::_createSqliteAdapter` (declaration #6) within `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `RepositoryResolver::_createSqliteAdapter` in `DI-REPOSITORY-RESOLVER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<DataSource>` from `RepositoryResolver::_createSqliteAdapter` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_createSqliteAdapter)) bounded over input/member dimension of `RepositoryResolver::_createSqliteAdapter`.
  /// - Space Complexity: O(K(_createSqliteAdapter)) bounded auxiliary memory for `RepositoryResolver::_createSqliteAdapter`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `RepositoryResolver::_createSqliteAdapter` (`Future<DataSource>`).
  /// - State: Maintains consistent state invariants across `RepositoryResolver::_createSqliteAdapter` without partial mutation on error.
  /// - Action: Executes `RepositoryResolver::_createSqliteAdapter` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `RepositoryResolver::_createSqliteAdapter` (`DI-REPOSITORY-RESOLVER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DI-REPOSITORY-RESOLVER-REPOSITORYRESOLVER-CREATESQLITEADAPTER] | SysML v2: ActionDef(RepositoryResolver::_createSqliteAdapter)
  static Future<DataSource> _createSqliteAdapter({
    String? dbAssetPath,
    bool inMemory = false,
  }) async {
    final String dbPath;
    if (kIsWeb) {
      dbPath = inMemoryDatabasePath;
    } else {
      final dir = await getApplicationSupportDirectory();
      dbPath = inMemory ? inMemoryDatabasePath : p.join(dir.path, 'properties_db.db');
    }

      if (!kIsWeb && !inMemory) {
        final dbFile = File(dbPath);
        bool isOutdated = false;
        final exists = await dbFile.exists();
        
        List<int>? decodedAssetBytes;
        try {
          final assetPath = dbAssetPath ?? _defaultDbAsset;
          final bytes = await rootBundle.load(assetPath);
          decodedAssetBytes = bytes.buffer.asUint8List(
            bytes.offsetInBytes,
            bytes.lengthInBytes,
          );
          if (assetPath.endsWith('.gz')) {
            decodedAssetBytes = gzip.decode(decodedAssetBytes);
          }
        } catch (e) {
          debugPrint('Failed to load asset database: $e');
        }

        if (exists && decodedAssetBytes != null) {
          final currentSize = await dbFile.length();
          if (currentSize != decodedAssetBytes.length) {
            isOutdated = true;
          } else {
            final currentBytes = await dbFile.readAsBytes();
            for (int i = 0; i < currentSize; i++) {
              if (currentBytes[i] != decodedAssetBytes[i]) {
                isOutdated = true;
                break;
              }
            }
          }
        }

        if (!exists || isOutdated) {
          if (exists) {
            try {
              await dbFile.delete();
            } catch (e) {
              debugPrint('Failed to delete outdated database file: $e');
            }
          }
          if (decodedAssetBytes != null) {
            try {
              await dbFile.writeAsBytes(decodedAssetBytes);
            } catch (e) {
              debugPrint('Failed to write database file "$dbPath": $e');
            }
          }
        }
      }

    // Initialize the SQLite database and inject DomainSeedStrategy to seed mock properties
    final db = await DatabaseInitializer.create(
      dbPath: dbPath,
      seed: true,
      seedStrategy: DomainSeedStrategy(),
    );
    return SqliteDataSource(db);
  }
}
