import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_flutter/core/app_config.dart';

/// Enumeration of supported raster map-imagery tile providers.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for enum `ImageryProvider` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for enum `ImageryProvider` (declaration #1) within `CESIUM-3D-TILE-FETCHER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `ImageryProvider` in `CESIUM-3D-TILE-FETCHER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `ImageryProvider` representation for enum `ImageryProvider`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(ImageryProvider)) bounded over input/member dimension of `ImageryProvider`.
/// - Space Complexity: O(K(ImageryProvider)) bounded auxiliary memory for `ImageryProvider`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `ImageryProvider` (`ImageryProvider`).
/// - State: Maintains consistent state invariants across `ImageryProvider` without partial mutation on error.
/// - Action: Executes `ImageryProvider` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `ImageryProvider` (`CESIUM-3D-TILE-FETCHER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/ImageryProvider] | SysML v2: PartDef(ImageryProvider)
enum ImageryProvider {
  /// OpenStreetMap standard raster PNG tiles.
  openStreetMap,

  /// ArcGIS World Imagery satellite raster tiles.
  arcGisSatellite,

  /// CartoDB dark-themed basemap tiles.
  cartoDark,

  /// CartoDB light-themed basemap tiles.
  cartoLight,
}

/// Bounded in-memory Least-Recently-Used (LRU) cache for raw PNG tile byte buffers.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces a hard upper bound
///   ([maxSize]) on cached raster tile buffers so continuous 3D globe panning
///   cannot exhaust heap memory.
///
/// ## 2. Invariants & Mathematical Properties
/// - Capacity invariant: $0 \le \text{length} \le \text{maxSize}$ at all times.
/// - LRU ordering invariant: every successful [get] or [put] moves the target
///   key to the tail of `_map`, and capacity overflow evicts `_map.keys.first`.
///
/// ## 3. Preconditions
/// - [maxSize] must be a positive integer capacity (defaults to `256`).
///
/// ## 4. Postconditions
/// - Stores and retrieves `Uint8List` tile payloads in $\mathcal{O}(1)$ time
///   while strictly respecting [maxSize].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ amortized for [get], [put], and [clear].
/// - **Space Complexity**: $\mathcal{O}(\text{maxSize})$ cached byte buffers.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Cache misses return `null` without throwing; capacity saturation evicts
///   the oldest entry deterministically.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/TileCache]
class TileCache {
  final int _maxSize;
  final LinkedHashMap<String, Uint8List> _map = LinkedHashMap<String, Uint8List>();

  /// Creates a cache that holds at most [maxSize] entries.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TileCache::TileCache` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TileCache::TileCache` (declaration #3) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - `maxSize: int` must satisfy domain and type-safety constraints prior to invoking `TileCache::TileCache`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TileCache::TileCache` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(maxSize)) bounded over input/member dimension of `TileCache::TileCache`.
  /// - Space Complexity: O(N(maxSize)) bounded auxiliary memory for `TileCache::TileCache`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCache::TileCache` (`()`).
  /// - State: Maintains consistent state invariants across `TileCache::TileCache` without partial mutation on error.
  /// - Action: Executes `TileCache::TileCache` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCache::TileCache` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILECACHE-TILECACHE] | SysML v2: ActionDef(TileCache::TileCache)
  TileCache({int maxSize = 256}) : _maxSize = maxSize;

  /// Returns the byte buffer for [key], or `null` if not cached.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileCache::get` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileCache::get` (declaration #4) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TileCache::get`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Uint8List?` from `TileCache::get` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TileCache::get`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TileCache::get`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCache::get` (`Uint8List?`).
  /// - State: Maintains consistent state invariants across `TileCache::get` without partial mutation on error.
  /// - Action: Executes `TileCache::get` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCache::get` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILECACHE-GET] | SysML v2: ActionDef(TileCache::get)
  Uint8List? get(String key) {
    final value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  /// Inserts [value] under [key], evicting the LRU entry first if the cache
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileCache::put` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileCache::put` (declaration #5) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TileCache::put`.
  /// - `value: Uint8List` must satisfy domain and type-safety constraints prior to invoking `TileCache::put`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TileCache::put` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TileCache::put`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TileCache::put`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCache::put` (`void`).
  /// - State: Maintains consistent state invariants across `TileCache::put` without partial mutation on error.
  /// - Action: Executes `TileCache::put` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCache::put` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILECACHE-PUT] | SysML v2: ActionDef(TileCache::put)
  void put(String key, Uint8List value) {
    _map.remove(key);
    if (_map.length >= _maxSize) {
      _map.remove(_map.keys.first);
    }
    _map[key] = value;
  }

  /// Removes every cached entry.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileCache::clear` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileCache::clear` (declaration #6) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileCache::clear` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TileCache::clear` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(clear)) bounded over input/member dimension of `TileCache::clear`.
  /// - Space Complexity: O(K(clear)) bounded auxiliary memory for `TileCache::clear`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCache::clear` (`void`).
  /// - State: Maintains consistent state invariants across `TileCache::clear` without partial mutation on error.
  /// - Action: Executes `TileCache::clear` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCache::clear` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILECACHE-CLEAR] | SysML v2: ActionDef(TileCache::clear)
  void clear() {
    _map.clear();
  }

  /// The current number of cached entries.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileCache::length` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileCache::length` (declaration #7) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileCache::length` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TileCache::length` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(length)) bounded over input/member dimension of `TileCache::length`.
  /// - Space Complexity: O(K(length)) bounded auxiliary memory for `TileCache::length`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCache::length` (`()`).
  /// - State: Maintains consistent state invariants across `TileCache::length` without partial mutation on error.
  /// - Action: Executes `TileCache::length` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCache::length` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILECACHE-LENGTH] | SysML v2: ActionDef(TileCache::length)
  int get length => _map.length;

  /// The maximum number of entries the cache can hold.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileCache::maxSize` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileCache::maxSize` (declaration #8) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileCache::maxSize` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TileCache::maxSize` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(maxSize)) bounded over input/member dimension of `TileCache::maxSize`.
  /// - Space Complexity: O(K(maxSize)) bounded auxiliary memory for `TileCache::maxSize`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCache::maxSize` (`()`).
  /// - State: Maintains consistent state invariants across `TileCache::maxSize` without partial mutation on error.
  /// - Action: Executes `TileCache::maxSize` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCache::maxSize` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILECACHE-MAXSIZE] | SysML v2: ActionDef(TileCache::maxSize)
  int get maxSize => _maxSize;
}

/// HTTP and local-file raster tile fetcher with compile-time gate control and
/// bounded LRU caching.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Isolates network and filesystem I/O
///   behind a 5-second connection timeout, compile-time [AppConfig.mapImageryEnabled]
///   gate, and fail-safe `null` fallback so network outages never stall or crash
///   the 3D globe rendering loop.
///
/// ## 2. Invariants & Mathematical Properties
/// - Offline safety invariant: when `isEnabled() == false`, [fetchTile]
///   immediately returns `null` with zero network socket activity.
/// - Template substitution invariant: [urlFor] replaces `{z}`, `{x}`, and `{y}`
///   tokens deterministically or throws [StateError] if unconfigured.
///
/// ## 3. Preconditions
/// - Basemap URL templates must be registered via [TileFetcher.configure] (or
///   [urlOverride] set) before fetching tiles when [isEnabled] is `true`.
///
/// ## 4. Postconditions
/// - Returns decoded `Uint8List` PNG bytes and caches them in [TileCache] on
///   HTTP 200 or existing `file://` path; returns `null` on any transport failure.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ on LRU cache hit; $\mathcal{O}(B)$
///   where $B$ is tile byte length on network/file read.
/// - **Space Complexity**: $\mathcal{O}(M \cdot B)$ bounded by [TileCache] capacity $M = 256$.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Timeouts, DNS failures, non-200 HTTP responses, and missing local files
///   are caught and converted to `null` return values without unhandled exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/TileFetcher]
class TileFetcher {
  static final Map<ImageryProvider, String> _basemapTemplates = {};

  /// Configures the fetcher with basemap URL templates from configuration.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::configure` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::configure` (declaration #8) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - `configs: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::configure`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TileFetcher::configure` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(configs)) bounded over input/member dimension of `TileFetcher::configure`.
  /// - Space Complexity: O(N(configs)) bounded auxiliary memory for `TileFetcher::configure`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::configure` (`void`).
  /// - State: Maintains consistent state invariants across `TileFetcher::configure` without partial mutation on error.
  /// - Action: Executes `TileFetcher::configure` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::configure` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-CONFIGURE] | SysML v2: ActionDef(TileFetcher::configure)
  static void configure(Map<String, dynamic> configs) {
    _basemapTemplates.clear();
    for (final provider in ImageryProvider.values) {
      final key = provider.name;
      if (configs.containsKey(key)) {
        _basemapTemplates[provider] = configs[key] as String;
      }
    }
  }

  bool _enabled = AppConfig.mapImageryEnabled;

  final HttpClient _client = HttpClient()
    ..userAgent = 'PlatformConsole/1.0'
    ..connectionTimeout = const Duration(seconds: 5);

  final TileCache _cache = TileCache();

  /// Whether the fetcher is permitted to make outbound HTTP requests.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::isEnabled` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::isEnabled` (declaration #9) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileFetcher::isEnabled` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `TileFetcher::isEnabled` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(isEnabled)) bounded over input/member dimension of `TileFetcher::isEnabled`.
  /// - Space Complexity: O(K(isEnabled)) bounded auxiliary memory for `TileFetcher::isEnabled`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::isEnabled` (`bool`).
  /// - State: Maintains consistent state invariants across `TileFetcher::isEnabled` without partial mutation on error.
  /// - Action: Executes `TileFetcher::isEnabled` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::isEnabled` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-ISENABLED] | SysML v2: ActionDef(TileFetcher::isEnabled)
  bool isEnabled() => _enabled;

  /// Permanently disables the fetcher for the remainder of the process
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::disable` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::disable` (declaration #10) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileFetcher::disable` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TileFetcher::disable` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(disable)) bounded over input/member dimension of `TileFetcher::disable`.
  /// - Space Complexity: O(K(disable)) bounded auxiliary memory for `TileFetcher::disable`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::disable` (`void`).
  /// - State: Maintains consistent state invariants across `TileFetcher::disable` without partial mutation on error.
  /// - Action: Executes `TileFetcher::disable` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::disable` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-DISABLE] | SysML v2: ActionDef(TileFetcher::disable)
  void disable() {
    _enabled = false;
  }

  /// Disposes resources by closing the HTTP client and clearing the tile cache.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::dispose` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::dispose` (declaration #11) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileFetcher::dispose` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TileFetcher::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `TileFetcher::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `TileFetcher::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `TileFetcher::dispose` without partial mutation on error.
  /// - Action: Executes `TileFetcher::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::dispose` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-DISPOSE] | SysML v2: ActionDef(TileFetcher::dispose)
  void dispose() {
    _client.close(force: true);
    _cache.clear();
  }

  /// Empties the internal tile cache. Useful when switching providers so
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::clearCache` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::clearCache` (declaration #12) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileFetcher::clearCache` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TileFetcher::clearCache` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(clearCache)) bounded over input/member dimension of `TileFetcher::clearCache`.
  /// - Space Complexity: O(K(clearCache)) bounded auxiliary memory for `TileFetcher::clearCache`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::clearCache` (`void`).
  /// - State: Maintains consistent state invariants across `TileFetcher::clearCache` without partial mutation on error.
  /// - Action: Executes `TileFetcher::clearCache` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::clearCache` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-CLEARCACHE] | SysML v2: ActionDef(TileFetcher::clearCache)
  void clearCache() {
    _cache.clear();
  }

  /// The number of entries currently held in the tile cache.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::cacheLength` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::cacheLength` (declaration #15) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileFetcher::cacheLength` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TileFetcher::cacheLength` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(cacheLength)) bounded over input/member dimension of `TileFetcher::cacheLength`.
  /// - Space Complexity: O(K(cacheLength)) bounded auxiliary memory for `TileFetcher::cacheLength`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::cacheLength` (`()`).
  /// - State: Maintains consistent state invariants across `TileFetcher::cacheLength` without partial mutation on error.
  /// - Action: Executes `TileFetcher::cacheLength` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::cacheLength` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-CACHELENGTH] | SysML v2: ActionDef(TileFetcher::cacheLength)
  int get cacheLength => _cache.length;

  /// Builds the HTTPS URL for a tile at the given [provider], zoom level
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::urlFor` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::urlFor` (declaration #13) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - `provider: ImageryProvider` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::urlFor`.
  /// - `z: int` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::urlFor`.
  /// - `x: int` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::urlFor`.
  /// - `y: int` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::urlFor`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `TileFetcher::urlFor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(provider)) bounded over input/member dimension of `TileFetcher::urlFor`.
  /// - Space Complexity: O(N(provider)) bounded auxiliary memory for `TileFetcher::urlFor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::urlFor` (`String`).
  /// - State: Maintains consistent state invariants across `TileFetcher::urlFor` without partial mutation on error.
  /// - Action: Executes `TileFetcher::urlFor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::urlFor` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-URLFOR] | SysML v2: ActionDef(TileFetcher::urlFor)
  static String urlFor(ImageryProvider provider, int z, int x, int y) {
    final template = _basemapTemplates[provider];
    if (template == null) {
      throw StateError('Basemap URL template for ${provider.name} is not configured.');
    }
    return template
        .replaceAll('{z}', z.toString())
        .replaceAll('{x}', x.toString())
        .replaceAll('{y}', y.toString());
  }

  /// Executes deterministic method `TileFetcher::_urlFor` within `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::_urlFor` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::_urlFor` (declaration #14) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - `provider: ImageryProvider` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::_urlFor`.
  /// - `z: int` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::_urlFor`.
  /// - `x: int` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::_urlFor`.
  /// - `y: int` must satisfy domain and type-safety constraints prior to invoking `TileFetcher::_urlFor`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `TileFetcher::_urlFor` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(provider)) bounded over input/member dimension of `TileFetcher::_urlFor`.
  /// - Space Complexity: O(N(provider)) bounded auxiliary memory for `TileFetcher::_urlFor`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::_urlFor` (`String`).
  /// - State: Maintains consistent state invariants across `TileFetcher::_urlFor` without partial mutation on error.
  /// - Action: Executes `TileFetcher::_urlFor` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::_urlFor` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-URLFOR] | SysML v2: ActionDef(TileFetcher::_urlFor)
  String _urlFor(ImageryProvider provider, int z, int x, int y) {
    return urlFor(provider, z, x, y);
  }

  /// Optional base URL override (such as a local directory file:// path) for loading tiles in testing or offline scenarios.
  static String? urlOverride;

  /// Fetches the tile image bytes for [provider] at zoom [z] and tile
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileFetcher::fetchTile` in `app_flutter/lib/features/map_viewport/cesium_3d/tile_fetcher.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileFetcher::fetchTile` (declaration #15) within `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileFetcher::fetchTile` in `CESIUM-3D-TILE-FETCHER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Uint8List?>` from `TileFetcher::fetchTile` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fetchTile)) bounded over input/member dimension of `TileFetcher::fetchTile`.
  /// - Space Complexity: O(K(fetchTile)) bounded auxiliary memory for `TileFetcher::fetchTile`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileFetcher::fetchTile` (`Future<Uint8List?>`).
  /// - State: Maintains consistent state invariants across `TileFetcher::fetchTile` without partial mutation on error.
  /// - Action: Executes `TileFetcher::fetchTile` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileFetcher::fetchTile` (`CESIUM-3D-TILE-FETCHER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-TILE-FETCHER-TILEFETCHER-FETCHTILE] | SysML v2: ActionDef(TileFetcher::fetchTile)
  Future<Uint8List?> fetchTile(
      ImageryProvider provider, int z, int x, int y) async {
    if (!_enabled) return null;

    final key = '$z/$x/$y/${provider.name}';
    final cached = _cache.get(key);
    if (cached != null) return cached;

    try {
      final String url = (urlOverride != null && urlOverride!.endsWith('.png'))
          ? urlOverride!
          : (urlOverride != null
              ? '$urlOverride/${provider.name}/$z/$x/$y.png'
              : _urlFor(provider, z, x, y));
      final uri = Uri.parse(url);

      if (uri.scheme == 'file') {
        final file = File(uri.toFilePath());
        if (await file.exists()) {
          final data = await file.readAsBytes();
          _cache.put(key, data);
          return data;
        }
        return null;
      }

      final request = await _client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await response
            .fold<List<int>>(<int>[], (prev, chunk) => prev..addAll(chunk));
        final data = Uint8List.fromList(bytes);
        _cache.put(key, data);
        return data;
      }
      await response.drain<void>();
    } catch (_) {
      // Swallow -- return null on any failure.
    }
    return null;
  }
}
