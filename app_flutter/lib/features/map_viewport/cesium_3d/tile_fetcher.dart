import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_flutter/core/app_config.dart';

/// Enumeration of supported raster map-imagery tile providers.
///
/// Each provider maps to a configured URL template resolved by [TileFetcher.urlFor].
///
/// Realises: [Feat-10/ImageryProvider]
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
  /// The default maximum is 256 entries -- one PNG tile per entry.
  TileCache({int maxSize = 256}) : _maxSize = maxSize;

  /// Returns the byte buffer for [key], or `null` if not cached.
  ///
  /// Access moves [key] to the most-recently-used position so it is the last
  /// candidate for eviction.
  Uint8List? get(String key) {
    final value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  /// Inserts [value] under [key], evicting the LRU entry first if the cache
  /// is already at capacity.
  void put(String key, Uint8List value) {
    _map.remove(key);
    if (_map.length >= _maxSize) {
      _map.remove(_map.keys.first);
    }
    _map[key] = value;
  }

  /// Removes every cached entry.
  void clear() {
    _map.clear();
  }

  /// The current number of cached entries.
  int get length => _map.length;

  /// The maximum number of entries the cache can hold.
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
  bool isEnabled() => _enabled;

  /// Permanently disables the fetcher for the remainder of the process
  /// lifetime. After this call [isEnabled] returns `false` and [fetchTile]
  /// always returns `null`.
  void disable() {
    _enabled = false;
  }

  /// Disposes resources by closing the HTTP client and clearing the tile cache.
  void dispose() {
    _client.close(force: true);
    _cache.clear();
  }

  /// Empties the internal tile cache. Useful when switching providers so
  /// stale imagery is not displayed.
  void clearCache() {
    _cache.clear();
  }

  /// The number of entries currently held in the tile cache.
  int get cacheLength => _cache.length;

  /// Builds the HTTPS URL for a tile at the given [provider], zoom level
  /// [z], and tile coordinates ([x], [y]).
  ///
  /// This method is public so that integration tests can verify URL
  /// construction without making actual network calls.
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

  String _urlFor(ImageryProvider provider, int z, int x, int y) {
    return urlFor(provider, z, x, y);
  }

  /// Optional base URL override (such as a local directory file:// path) for loading tiles in testing or offline scenarios.
  static String? urlOverride;

  /// Fetches the tile image bytes for [provider] at zoom [z] and tile
  /// coordinates ([x], [y]).
  ///
  /// Returns `null` immediately when [isEnabled] is `false` or when any
  /// network error occurs (timeout, non-200 status, DNS failure, etc.).
  ///
  /// On success the raw PNG bytes are returned and also stored in the
  /// internal LRU cache. Subsequent calls for the same
  /// (provider, z, x, y) tuple will be served from cache.
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
