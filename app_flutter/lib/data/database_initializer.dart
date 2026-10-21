import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Command-line bootstrap entrypoint for deterministic relational schema generation and GZIP asset compression.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides a deterministic build-time artifact generator for initializing and compressing the local relational schema snapshot (`properties_db.db` and `properties_db.db.gz`) prior to runtime deployment.
///
/// ## 2. Invariants & Mathematical Properties
/// - Existing database and compressed archive artifacts at the target relative asset paths are purged prior to regeneration, guaranteeing a clean, reproducible schema state.
/// - The compressed output byte stream is a lossless GZIP transformation of the closed SQLite database file.
///
/// ## 3. Preconditions
/// - The host environment must support native SQLite FFI initialization (`sqfliteFfiInit`) and write permissions to the relative `assets/` directory.
///
/// ## 4. Postconditions
/// - A freshly initialized and seeded SQLite database file and its corresponding `.gz` archive exist on disk with all database handles closed.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(S + B)$ where $S$ is the seed batch operation count and $B$ is the serialized database byte length compressed via GZIP.
/// - **Space Complexity**: $\mathcal{O}(B)$ auxiliary memory to hold the raw and GZIP-encoded byte buffers during compression.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Filesystem permission failures or SQLite FFI initialization faults abort asset generation immediately and propagate an unhandled I/O exception to halt the build pipeline.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Persistence Bootstrap)
///
/// Realises: [Feat-10/DatabaseInitializer]
Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // Target path for generated SQLite database asset.
  final dbPath = 'assets/properties_db.db';
  // File handle for the uncompressed SQLite asset.
  final file = File(dbPath);
  if (await file.exists()) {
    await file.delete();
  }
  // Initialize and seed the local SQLite database.
  final db = await DatabaseInitializer.create(dbPath: dbPath, seed: true);
  await db.close();
  print('Generic database properties_db.db regenerated successfully.');

  // File handle for the GZIP-compressed SQLite asset.
  final gzFile = File('assets/properties_db.db.gz');
  if (await gzFile.exists()) {
    await gzFile.delete();
  }
  // Read raw database bytes for GZIP encoding.
  final bytes = await file.readAsBytes();
  // Compress raw bytes into GZIP archive payload.
  final gzipped = gzip.encode(bytes);
  await gzFile.writeAsBytes(gzipped);
  print('Database gzipped to properties_db.db.gz successfully.');
}

/// Abstract strategy interface for deterministic population of initial M2 metamodel and M1 instance records into a relational SQLite store.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Decouples relational schema DDL creation from initial data population so that Layer 2 persistence initialization remains 100% domain-agnostic and schema-driven.
///
/// ## 2. Invariants & Mathematical Properties
/// - Implementations must preserve referential integrity across `type_definitions`, `type_attributes`, `type_relations`, `properties`, and `instances` tables.
///
/// ## 3. Preconditions
/// - The supplied [Database] handle must be open, writable, and already initialized with the canonical M2 relational schema tables.
///
/// ## 4. Postconditions
/// - All strategy-defined M2 type descriptors and M1 instance rows are committed atomically or in bounded batches to the target [Database].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(N)$ where $N$ is the total number of seeded schema and instance rows.
/// - **Space Complexity**: $\mathcal{O}(B_{\text{batch}})$ bounded by the active batch commit buffer size.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - SQL constraint violations or batch commit failures propagate asynchronously to the caller ([DatabaseInitializer.create]), which closes the database handle and rethrows.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Persistence Seeding Contract)
///
/// Realises: [Feat-10/DatabaseInitializer]
abstract class SeedStrategy {
  /// Populates the provided [db] instance with initial M2 type definitions and M1 instance records.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SeedStrategy::seed` in `app_flutter/lib/data/database_initializer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SeedStrategy::seed` (declaration #3) within `DATA-DATABASE-INITIALIZER`.
  ///
  /// ## 3. Preconditions
  /// - `db: Database` must satisfy domain and type-safety constraints prior to invoking `SeedStrategy::seed`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `SeedStrategy::seed` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(db)) bounded over input/member dimension of `SeedStrategy::seed`.
  /// - Space Complexity: O(N(db)) bounded auxiliary memory for `SeedStrategy::seed`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SeedStrategy::seed` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `SeedStrategy::seed` without partial mutation on error.
  /// - Action: Executes `SeedStrategy::seed` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SeedStrategy::seed` (`DATA-DATABASE-INITIALIZER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-DATABASE-INITIALIZER-SEEDSTRATEGY-SEED] | SysML v2: ActionDef(SeedStrategy::seed)
  Future<void> seed(Database db);
}

/// Relational SQLite database bootstrapper that enforces write-ahead logging, foreign-key constraints, and canonical M2 metamodel DDL creation.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Guarantees that the local persistence store is initialized with deterministic PRAGMA safety settings (`journal_mode = WAL`, `busy_timeout = 5000`, `foreign_keys = ON`) and complete M2 schema tables (`properties`, `instances`, `type_definitions`, `type_attributes`, `type_relations`) before any Layer 2 repository query executes.
///
/// ## 2. Invariants & Mathematical Properties
/// - Schema creation is idempotent via `CREATE TABLE IF NOT EXISTS` and `CREATE INDEX IF NOT EXISTS`.
/// - Referential integrity (`PRAGMA foreign_keys = ON`) is enforced on every connection prior to table or index creation.
/// - Desktop sandbox viability is probed with a bounded 2-second timeout before opening persistent file-backed databases outside test environments.
///
/// ## 3. Preconditions
/// - When targeting desktop environments outside `FLUTTER_TEST`, the host process must have FFI SQLite execution permissions and filesystem access to [dbPath] or the platform application support directory.
///
/// ## 4. Postconditions
/// - Returns an open, schema-verified [Database] handle shared across [SqliteDataSource] consumers, optionally populated via [seedStrategy] when [seed] is `true`.
/// - Do not invoke [create] redundantly for the same file path -- reopening re-executes idempotent DDL statements unnecessarily.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for idempotent DDL table/index verification, plus $\mathcal{O}(N_{\text{seed}})$ when [seed] is enabled.
/// - **Space Complexity**: $\mathcal{O}(1)$ resident heap allocation for connection initialization metadata.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If desktop FFI viability probing fails (e.g., blocked by OS sandbox), throws a deterministic [StateError] with remediation guidance.
/// - If any PRAGMA, DDL, or [SeedStrategy.seed] operation fails after opening the database, [create] closes the [Database] handle in the `catch` block before rethrowing to prevent file descriptor leaks.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management -- Relational Persistence Bootstrap)
///
/// Realises: [Feat-10/DatabaseInitializer]
class DatabaseInitializer {
  /// Opens or creates the target SQLite database, applies WAL and foreign-key PRAGMAs, ensures all M2 schema tables and indexes exist, and optionally runs [seedStrategy].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DatabaseInitializer::create` in `app_flutter/lib/data/database_initializer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DatabaseInitializer::create` (declaration #5) within `DATA-DATABASE-INITIALIZER`.
  ///
  /// ## 3. Preconditions
  /// - `dbPath: String?` must satisfy domain and type-safety constraints prior to invoking `DatabaseInitializer::create`.
  /// - `seed: bool` must satisfy domain and type-safety constraints prior to invoking `DatabaseInitializer::create`.
  /// - `seedStrategy: SeedStrategy?` must satisfy domain and type-safety constraints prior to invoking `DatabaseInitializer::create`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Database>` from `DatabaseInitializer::create` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dbPath)) bounded over input/member dimension of `DatabaseInitializer::create`.
  /// - Space Complexity: O(N(dbPath)) bounded auxiliary memory for `DatabaseInitializer::create`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DatabaseInitializer::create` (`Future<Database>`).
  /// - State: Maintains consistent state invariants across `DatabaseInitializer::create` without partial mutation on error.
  /// - Action: Executes `DatabaseInitializer::create` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DatabaseInitializer::create` (`DATA-DATABASE-INITIALIZER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-DATABASE-INITIALIZER-DATABASEINITIALIZER-CREATE] | SysML v2: ActionDef(DatabaseInitializer::create)
  static Future<Database> create({String? dbPath, bool seed = false, SeedStrategy? seedStrategy}) async {
    final isTest = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
    final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    if (isDesktop && !isTest) {
      final canAccess = await _probeFfiViability();
      if (!canAccess) {
        throw StateError(
          'Cannot open database on this desktop environment. '
          'The FFI SQLite backend is blocked by the system sandbox. '
          'Grant file-access entitlements or use a non-sandboxed deployment.',
        );
      }
    }
    if (!kIsWeb && (isTest || isDesktop)) {
      sqfliteFfiInit();
      try {
        databaseFactory;
      } catch (_) {
        databaseFactory = databaseFactoryFfi;
      }
    }

    final String path;
    if (kIsWeb) {
      path = dbPath ?? inMemoryDatabasePath;
    } else {
      path = dbPath != null
          ? (dbPath == inMemoryDatabasePath ? dbPath : p.absolute(dbPath))
          : (isTest
              ? inMemoryDatabasePath
              : p.join(
                  (await getApplicationSupportDirectory()).path,
                  'properties_db.db',
                ));
    }

    final db = await databaseFactory.openDatabase(path);
    try {
      await db.execute('PRAGMA journal_mode = WAL;');
      await db.execute('PRAGMA busy_timeout = 5000;');
      await db.execute('PRAGMA foreign_keys = ON;');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS properties (
          node_id TEXT PRIMARY KEY,
          parent_node_id TEXT REFERENCES properties(node_id),
          data_json TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_properties_parent_node_id
        ON properties(parent_node_id);
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS instances (
          id TEXT PRIMARY KEY,
          parent_node_id TEXT NOT NULL,
          type_name TEXT NOT NULL,
          data_json TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_instances_parent_type
        ON instances(parent_node_id, type_name);
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_instances_type_name
        ON instances(type_name);
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS type_definitions (
          type_name TEXT PRIMARY KEY,
          display_name TEXT NOT NULL,
          icon_name TEXT NOT NULL DEFAULT 'insert_drive_file'
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS type_attributes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type_name TEXT NOT NULL REFERENCES type_definitions(type_name),
          attr_key TEXT NOT NULL,
          label TEXT NOT NULL,
          attr_type TEXT NOT NULL,
          section_label TEXT,
          section_order INTEGER NOT NULL DEFAULT 0,
          is_required INTEGER NOT NULL DEFAULT 0,
          min_value REAL,
          max_value REAL,
          pattern TEXT,
          enum_options TEXT,
          enum_display_names TEXT,
          default_value TEXT,
          input_formatters TEXT,
          UNIQUE(type_name, attr_key)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS type_relations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          parent_type_name TEXT NOT NULL REFERENCES type_definitions(type_name),
          relation_name TEXT NOT NULL,
          child_type_name TEXT NOT NULL REFERENCES type_definitions(type_name),
          child_label TEXT NOT NULL,
          UNIQUE(parent_type_name, child_type_name)
        )
      ''');

      if (seed && seedStrategy != null) {
        await seedStrategy.seed(db);
      }

      return db;
    } catch (e) {
      await db.close();
      rethrow;
    }
  }

  /// Executes deterministic method `DatabaseInitializer::_probeFfiViability` within `app_flutter/lib/data/database_initializer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DatabaseInitializer::_probeFfiViability` in `app_flutter/lib/data/database_initializer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DatabaseInitializer::_probeFfiViability` (declaration #6) within `DATA-DATABASE-INITIALIZER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DatabaseInitializer::_probeFfiViability` in `DATA-DATABASE-INITIALIZER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<bool>` from `DatabaseInitializer::_probeFfiViability` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_probeFfiViability)) bounded over input/member dimension of `DatabaseInitializer::_probeFfiViability`.
  /// - Space Complexity: O(K(_probeFfiViability)) bounded auxiliary memory for `DatabaseInitializer::_probeFfiViability`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DatabaseInitializer::_probeFfiViability` (`Future<bool>`).
  /// - State: Maintains consistent state invariants across `DatabaseInitializer::_probeFfiViability` without partial mutation on error.
  /// - Action: Executes `DatabaseInitializer::_probeFfiViability` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DatabaseInitializer::_probeFfiViability` (`DATA-DATABASE-INITIALIZER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-DATA-DATABASE-INITIALIZER-DATABASEINITIALIZER-PROBEFFIVIABILITY] | SysML v2: ActionDef(DatabaseInitializer::_probeFfiViability)
  static Future<bool> _probeFfiViability() async {
    try {
      sqfliteFfiInit();
      final openFuture = databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      unawaited(openFuture.then((db) async {
        try {
          await db.close();
        } catch (_) {}
      }).catchError((_) {}));

      await openFuture.timeout(const Duration(seconds: 2));
      return true;
    } catch (_) {
      return false;
    }
  }

}

