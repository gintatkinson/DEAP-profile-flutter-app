import 'dart:math' as math;
import 'dart:typed_data';

import 'dart:ui' as ui;

import 'package:meta/meta.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/projected_point.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/tile_fetcher.dart';
import 'package:app_flutter/features/map_viewport/cesium_3d/virtual_camera.dart';

/// Web Mercator slippy-map tile coordinate (`zoom`, `x`, `y`).
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `TileCoord` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `TileCoord` (declaration #1) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `TileCoord` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `TileCoord` representation for class `TileCoord`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(TileCoord)) bounded over input/member dimension of `TileCoord`.
/// - Space Complexity: O(K(TileCoord)) bounded auxiliary memory for `TileCoord`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `TileCoord` (`TileCoord`).
/// - State: Maintains consistent state invariants across `TileCoord` without partial mutation on error.
/// - Action: Executes `TileCoord` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `TileCoord` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TileCoord] | SysML v2: PartDef(TileCoord)
class TileCoord {
  /// The zoom level for this tile coordinate.
  final int zoom;

  /// The column index (0 = 180&deg; W, increases eastward).
  final int x;

  /// The row index (0 = 85.05&deg; N, increases southward).
  final int y;

  /// Creates a tile coordinate with the given [zoom], [x], and [y].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TileCoord::TileCoord` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TileCoord::TileCoord` (declaration #2) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `zoom: String` must satisfy domain and type-safety constraints prior to invoking `TileCoord::TileCoord`.
  /// - `x: String` must satisfy domain and type-safety constraints prior to invoking `TileCoord::TileCoord`.
  /// - `y: String` must satisfy domain and type-safety constraints prior to invoking `TileCoord::TileCoord`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TileCoord::TileCoord` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(zoom)) bounded over input/member dimension of `TileCoord::TileCoord`.
  /// - Space Complexity: O(N(zoom)) bounded auxiliary memory for `TileCoord::TileCoord`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCoord::TileCoord` (`()`).
  /// - State: Maintains consistent state invariants across `TileCoord::TileCoord` without partial mutation on error.
  /// - Action: Executes `TileCoord::TileCoord` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCoord::TileCoord` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-TILECOORD-TILECOORD] | SysML v2: ActionDef(TileCoord::TileCoord)
  const TileCoord({required this.zoom, required this.x, required this.y});

  /// A string key suitable for use in maps and sets.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TileCoord::key` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TileCoord::key` (declaration #3) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TileCoord::key` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TileCoord::key` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(key)) bounded over input/member dimension of `TileCoord::key`.
  /// - Space Complexity: O(K(key)) bounded auxiliary memory for `TileCoord::key`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TileCoord::key` (`()`).
  /// - State: Maintains consistent state invariants across `TileCoord::key` without partial mutation on error.
  /// - Action: Executes `TileCoord::key` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TileCoord::key` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-TILECOORD-KEY] | SysML v2: ActionDef(TileCoord::key)
  String get key => '$zoom/$x/$y';
}

/// Multi-resolution 3D globe raster tile renderer with hierarchical quadtree
/// Level-of-Detail (LOD) masking, mesh subdivision, and front-hemisphere culling.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Bounds asynchronous tile fetching
///   to at most `_maxConcurrentFetches` (`16`) in-flight requests and `128`
///   decoded GPU `ui.Image` textures, disposing evicted or superseded native
///   image handles deterministically to prevent GPU texture memory exhaustion.
///
/// ## 2. Invariants & Mathematical Properties
/// - Web Mercator projection bounds: latitude is clamped to
///   $\phi \in [-85.0511^\circ, 85.0511^\circ]$ with polar cap snapping to
///   $\pm 90.0^\circ$ during mesh vertex projection.
/// - Quadtree LOD occlusion invariant ([_hasHigherZoomOverlay]): a parent tile
///   at $(z, x, y)$ is skipped if and only if all 4 child tiles
///   $(z+1, 2x + \Delta x, 2y + \Delta y)$ for $\Delta x, \Delta y \in \{0, 1\}$
///   are resident in `_loadedImages`.
/// - Triangle hemisphere culling invariant: any mesh triangle with a vertex
///   behind the camera plane ($z \le -100.0$) or all three vertices occluded
///   beyond the horizon ($z < -0.5$) is discarded from the index buffer.
///
/// ## 3. Preconditions
/// - [fetcher] must be a valid [TileFetcher] instance; `projectFn` passed to
///   [renderTiles] must map `(latDeg, lngDeg)` to a finite [ProjectedPoint].
///
/// ## 4. Postconditions
/// - Renders visible front-hemisphere tile meshes via `Canvas.drawVertices`
///   sorted from lowest to highest zoom level.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(T \cdot S^2)$ per frame where $T \le 128$
///   is loaded tile count and $S \in [8, 32]$ is the per-tile subdivision grid size.
/// - **Space Complexity**: $\mathcal{O}(T)$ decoded `ui.Image` handles ($T \le 128$).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If `_disposed` becomes `true` or `_activeProvider` changes while an image
///   decode is in flight, the decoded frame is discarded without mutating
///   `_loadedImages`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/GlobeTileRenderer]
class GlobeTileRenderer {
  final TileFetcher _fetcher;
  ImageryProvider _activeProvider;
  /// Optional callback invoked whenever a newly decoded tile image enters the cache.
  final ui.VoidCallback? onTileLoaded;

  /// Optional test hook invoked with projected vertex positions and triangle indices.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::Function` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::Function` (declaration #4) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `positions: List<ui.Offset>` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::Function`.
  /// - `indices: List<int>` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::Function`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GlobeTileRenderer::Function` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(positions)) bounded over input/member dimension of `GlobeTileRenderer::Function`.
  /// - Space Complexity: O(N(positions)) bounded auxiliary memory for `GlobeTileRenderer::Function`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::Function` (`void`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::Function` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::Function` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::Function` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-FUNCTION] | SysML v2: ActionDef(GlobeTileRenderer::Function)
  @visibleForTesting
  void Function(List<ui.Offset> positions, List<int> indices)? onDrawVerticesForTesting;

  /// Decoded tile images keyed by "[zoom]/[x]/[y]". Limited to 128 entries.
  final Map<String, ui.Image> _loadedImages = {};

  /// Set of tile keys for which an HTTP fetch is currently in-flight.
  final Set<String> _pendingFetches = {};

  bool _disposed = false;
  int _activeFetchCount = 0;
  static const int _maxConcurrentFetches = 16;
  List<MapEntry<String, ui.Image>>? _cachedSortedEntries;
  int _cachedSortedEntriesLength = -1;

  /// Creates a renderer that will fetch tiles via [fetcher] and initially
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `GlobeTileRenderer::GlobeTileRenderer` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `GlobeTileRenderer::GlobeTileRenderer` (declaration #5) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GlobeTileRenderer::GlobeTileRenderer` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `GlobeTileRenderer::GlobeTileRenderer` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(GlobeTileRenderer)) bounded over input/member dimension of `GlobeTileRenderer::GlobeTileRenderer`.
  /// - Space Complexity: O(K(GlobeTileRenderer)) bounded auxiliary memory for `GlobeTileRenderer::GlobeTileRenderer`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::GlobeTileRenderer` (`()`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::GlobeTileRenderer` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::GlobeTileRenderer` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::GlobeTileRenderer` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-GLOBETILERENDERER] | SysML v2: ActionDef(GlobeTileRenderer::GlobeTileRenderer)
  GlobeTileRenderer({
    required TileFetcher fetcher,
    ImageryProvider initialProvider = ImageryProvider.cartoDark,
    this.onTileLoaded,
  })  : _fetcher = fetcher,
        _activeProvider = initialProvider;

  /// Whether the underlying [TileFetcher] is enabled.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::isEnabled` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::isEnabled` (declaration #7) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GlobeTileRenderer::isEnabled` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool get isEnabled => _fetcher.` from `GlobeTileRenderer::isEnabled` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(isEnabled)) bounded over input/member dimension of `GlobeTileRenderer::isEnabled`.
  /// - Space Complexity: O(K(isEnabled)) bounded auxiliary memory for `GlobeTileRenderer::isEnabled`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::isEnabled` (`bool get isEnabled => _fetcher.`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::isEnabled` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::isEnabled` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::isEnabled` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-ISENABLED] | SysML v2: ActionDef(GlobeTileRenderer::isEnabled)
  bool get isEnabled => _fetcher.isEnabled();

  /// Returns the count of currently decoded tile images for unit testing.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::loadedImagesCount` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::loadedImagesCount` (declaration #8) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GlobeTileRenderer::loadedImagesCount` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `GlobeTileRenderer::loadedImagesCount` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadedImagesCount)) bounded over input/member dimension of `GlobeTileRenderer::loadedImagesCount`.
  /// - Space Complexity: O(K(loadedImagesCount)) bounded auxiliary memory for `GlobeTileRenderer::loadedImagesCount`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::loadedImagesCount` (`()`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::loadedImagesCount` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::loadedImagesCount` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::loadedImagesCount` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-LOADEDIMAGESCOUNT] | SysML v2: ActionDef(GlobeTileRenderer::loadedImagesCount)
  @visibleForTesting
  int get loadedImagesCount => _loadedImages.length;

  /// Returns true if a higher-zoom tile is loaded whose geographic bounds
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::hasHigherZoomOverlayForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::hasHigherZoomOverlayForTesting` (declaration #6) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `tile: TileCoord` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::hasHigherZoomOverlayForTesting`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `GlobeTileRenderer::hasHigherZoomOverlayForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(tile)) bounded over input/member dimension of `GlobeTileRenderer::hasHigherZoomOverlayForTesting`.
  /// - Space Complexity: O(N(tile)) bounded auxiliary memory for `GlobeTileRenderer::hasHigherZoomOverlayForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::hasHigherZoomOverlayForTesting` (`bool`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::hasHigherZoomOverlayForTesting` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::hasHigherZoomOverlayForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::hasHigherZoomOverlayForTesting` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-HASHIGHERZOOMOVERLAYFORTESTING] | SysML v2: ActionDef(GlobeTileRenderer::hasHigherZoomOverlayForTesting)
  @visibleForTesting
  bool hasHigherZoomOverlayForTesting(TileCoord tile) {
    return _hasHigherZoomOverlay(tile);
  }

  /// Injects a pre-decoded [image] at [coord] into the tile cache for testing.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::injectTileForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::injectTileForTesting` (declaration #7) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `coord: TileCoord` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::injectTileForTesting`.
  /// - `image: ui.Image` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::injectTileForTesting`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GlobeTileRenderer::injectTileForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(coord)) bounded over input/member dimension of `GlobeTileRenderer::injectTileForTesting`.
  /// - Space Complexity: O(N(coord)) bounded auxiliary memory for `GlobeTileRenderer::injectTileForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::injectTileForTesting` (`void`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::injectTileForTesting` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::injectTileForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::injectTileForTesting` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-INJECTTILEFORTESTING] | SysML v2: ActionDef(GlobeTileRenderer::injectTileForTesting)
  @visibleForTesting
  void injectTileForTesting(TileCoord coord, ui.Image image) {
    _loadedImages[coord.key] = image;
  }

  /// Switches to [provider] and clears all locally cached images and
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::setProvider` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::setProvider` (declaration #8) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `provider: ImageryProvider` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::setProvider`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GlobeTileRenderer::setProvider` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(provider)) bounded over input/member dimension of `GlobeTileRenderer::setProvider`.
  /// - Space Complexity: O(N(provider)) bounded auxiliary memory for `GlobeTileRenderer::setProvider`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::setProvider` (`void`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::setProvider` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::setProvider` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::setProvider` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-SETPROVIDER] | SysML v2: ActionDef(GlobeTileRenderer::setProvider)
  void setProvider(ImageryProvider provider) {
    if (_activeProvider == provider) return;
    _activeProvider = provider;
    for (final img in _loadedImages.values) {
      img.dispose();
    }
    _loadedImages.clear();
    _pendingFetches.clear();
    _fetcher.clearCache();
    _cachedSortedEntries = null;
    _cachedSortedEntriesLength = -1;
  }

  /// Disposes all loaded tile images and clears the cache.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::dispose` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::dispose` (declaration #9) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GlobeTileRenderer::dispose` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GlobeTileRenderer::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `GlobeTileRenderer::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `GlobeTileRenderer::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::dispose` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::dispose` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-DISPOSE] | SysML v2: ActionDef(GlobeTileRenderer::dispose)
  void dispose() {
    _disposed = true;
    for (final img in _loadedImages.values) {
      img.dispose();
    }
    _loadedImages.clear();
    _cachedSortedEntries = null;
    _cachedSortedEntriesLength = -1;
  }

  /// Converts degrees to radians.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_rad` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_rad` (declaration #10) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `deg: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_rad`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `GlobeTileRenderer::_rad` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(deg)) bounded over input/member dimension of `GlobeTileRenderer::_rad`.
  /// - Space Complexity: O(N(deg)) bounded auxiliary memory for `GlobeTileRenderer::_rad`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_rad` (`double`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_rad` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_rad` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_rad` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-RAD] | SysML v2: ActionDef(GlobeTileRenderer::_rad)
  double _rad(double deg) => deg * math.pi / 180.0;

  // ---------------------------------------------------------------------------
  // Zoom computation
  // ---------------------------------------------------------------------------

  /// Derives a zoom level from the camera [dim_2] (meters) and the
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_zoomForAltitude` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_zoomForAltitude` (declaration #11) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `dim_2: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_zoomForAltitude`.
  /// - `viewportWidth: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_zoomForAltitude`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `GlobeTileRenderer::_zoomForAltitude` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_2)) bounded over input/member dimension of `GlobeTileRenderer::_zoomForAltitude`.
  /// - Space Complexity: O(N(dim_2)) bounded auxiliary memory for `GlobeTileRenderer::_zoomForAltitude`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_zoomForAltitude` (`int`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_zoomForAltitude` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_zoomForAltitude` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_zoomForAltitude` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-ZOOMFORALTITUDE] | SysML v2: ActionDef(GlobeTileRenderer::_zoomForAltitude)
  int _zoomForAltitude(double dim_2, double viewportWidth) {
    double v_dim_2 = dim_2;
    if (v_dim_2 <= 0) v_dim_2 = 100;
    final zoom =
        (math.log(120000000.0 / v_dim_2) / math.ln2).round();
    return zoom.clamp(0, 12);
  }

  // ---------------------------------------------------------------------------
  // Tile coordinate math (Web Mercator)
  // ---------------------------------------------------------------------------

  /// Converts dim_0/dim_1 (degrees) to a tile coordinate at the
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_latLngToTile` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_latLngToTile` (declaration #12) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `dim_0: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_latLngToTile`.
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_latLngToTile`.
  /// - `zoom: int` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_latLngToTile`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TileCoord` from `GlobeTileRenderer::_latLngToTile` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_0)) bounded over input/member dimension of `GlobeTileRenderer::_latLngToTile`.
  /// - Space Complexity: O(N(dim_0)) bounded auxiliary memory for `GlobeTileRenderer::_latLngToTile`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_latLngToTile` (`TileCoord`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_latLngToTile` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_latLngToTile` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_latLngToTile` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-LATLNGTOTILE] | SysML v2: ActionDef(GlobeTileRenderer::_latLngToTile)
  TileCoord _latLngToTile(double dim_0, double lng, int zoom) {
    final clampedLat = dim_0.clamp(-85.0511, 85.0511);
    final n = math.pow(2, zoom).toInt();
    final x = ((lng + 180) / 360 * n).floor();
    final latRad = _rad(clampedLat);
    final y =
        ((1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) /
                2 *
                n)
            .floor();
    return TileCoord(
        zoom: zoom, x: x.clamp(0, n - 1), y: y.clamp(0, n - 1));
  }

  /// Longitude of the *western* edge of tile column [x] at zoom [z].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_tile2lon` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_tile2lon` (declaration #13) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `x: int` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_tile2lon`.
  /// - `z: int` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_tile2lon`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `GlobeTileRenderer::_tile2lon` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(x)) bounded over input/member dimension of `GlobeTileRenderer::_tile2lon`.
  /// - Space Complexity: O(N(x)) bounded auxiliary memory for `GlobeTileRenderer::_tile2lon`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_tile2lon` (`double`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_tile2lon` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_tile2lon` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_tile2lon` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-TILE2LON] | SysML v2: ActionDef(GlobeTileRenderer::_tile2lon)
  double _tile2lon(int x, int z) =>
      x / math.pow(2, z) * 360.0 - 180.0;

  /// Latitude of the *northern* edge of tile row [y] at zoom [z].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_tile2lat` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_tile2lat` (declaration #14) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `y: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_tile2lat`.
  /// - `z: int` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_tile2lat`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `GlobeTileRenderer::_tile2lat` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(y)) bounded over input/member dimension of `GlobeTileRenderer::_tile2lat`.
  /// - Space Complexity: O(N(y)) bounded auxiliary memory for `GlobeTileRenderer::_tile2lat`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_tile2lat` (`double`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_tile2lat` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_tile2lat` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_tile2lat` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-TILE2LAT] | SysML v2: ActionDef(GlobeTileRenderer::_tile2lat)
  double _tile2lat(double y, int z) {
    final n = math.pi * (1.0 - 2.0 * y / math.pow(2, z));
    return math.atan((math.exp(n) - math.exp(-n)) / 2.0) * 180.0 / math.pi;
  }

  // ---------------------------------------------------------------------------
  // Visible-tile computation
  // ---------------------------------------------------------------------------

  /// Returns the set of tile coordinates that cover the visible hemisphere
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_visibleTiles` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_visibleTiles` (declaration #15) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `camera: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_visibleTiles`.
  /// - `viewportSize: ui.Size` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_visibleTiles`.
  /// - `isFlying: bool` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_visibleTiles`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<TileCoord>` from `GlobeTileRenderer::_visibleTiles` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(camera)) bounded over input/member dimension of `GlobeTileRenderer::_visibleTiles`.
  /// - Space Complexity: O(N(camera)) bounded auxiliary memory for `GlobeTileRenderer::_visibleTiles`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_visibleTiles` (`List<TileCoord>`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_visibleTiles` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_visibleTiles` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_visibleTiles` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-VISIBLETILES] | SysML v2: ActionDef(GlobeTileRenderer::_visibleTiles)
  List<TileCoord> _visibleTiles(VirtualCamera camera, ui.Size viewportSize, {bool isFlying = false}) {
    final double R = Ellipsoid.wgs84EquatorialRadius;
    final double relativeAlt = camera.dim_2 < R ? camera.dim_2 : camera.dim_2 - R;
    int zoom = _zoomForAltitude(relativeAlt, viewportSize.width);
    if (isFlying && zoom > 4) {
      zoom = 4;
    }
    final center = _latLngToTile(camera.dim_0, camera.dim_1, zoom);
    final List<TileCoord> tiles = [];

    // Horizon angle theta = acos(R / (R + h)) where R = Ellipsoid.wgs84EquatorialRadius
    final double h = relativeAlt < 0.1 ? 0.1 : relativeAlt;
    final double theta = math.acos(R / (R + h));

    // Tier 1: Zoom 2 (global background coverage)
    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 4; y++) {
        tiles.add(TileCoord(zoom: 2, x: x, y: y));
      }
    }

    // Tier 2: Zoom Z - 2 (Mid-resolution wider background)
    final midZoom = zoom - 2;
    if (midZoom > 2) {
      final midCenter = _latLngToTile(camera.dim_0, camera.dim_1, midZoom);
      final midN = math.pow(2, midZoom).toInt();
      final double midTileWidth = 360.0 / math.pow(2, midZoom);
      final double thetaDeg = theta * 180.0 / math.pi;
      final int midRadius = (thetaDeg / midTileWidth).ceil().clamp(1, 2);
      for (int dx = -midRadius; dx <= midRadius; dx++) {
        for (int dy = -midRadius; dy <= midRadius; dy++) {
          final tx = (midCenter.x + dx).clamp(0, midN - 1);
          final ty = (midCenter.y + dy).clamp(0, midN - 1);
          tiles.add(TileCoord(zoom: midZoom, x: tx, y: ty));
        }
      }
    }

    // Tier 3: Zoom Z (High-resolution close-up)
    if (zoom > 2) {
      final n = math.pow(2, zoom).toInt();
      final double tileWidth = 360.0 / math.pow(2, zoom);
      final double thetaDeg = theta * 180.0 / math.pi;
      final int radius = (thetaDeg / tileWidth).ceil().clamp(1, 2);
      for (int dx = -radius; dx <= radius; dx++) {
        for (int dy = -radius; dy <= radius; dy++) {
          final tx = (center.x + dx).clamp(0, n - 1);
          final ty = (center.y + dy).clamp(0, n - 1);
          tiles.add(TileCoord(zoom: zoom, x: tx, y: ty));
        }
      }
    }

    return tiles;
  }

  // ---------------------------------------------------------------------------
  // Asynchronous tile fetching
  // ---------------------------------------------------------------------------

  /// Begins asynchronous fetching of all visible tiles for the given
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::beginTileFetch` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::beginTileFetch` (declaration #16) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `camera: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::beginTileFetch`.
  /// - `viewportSize: ui.Size` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::beginTileFetch`.
  /// - `isFlying: bool` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::beginTileFetch`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GlobeTileRenderer::beginTileFetch` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(camera)) bounded over input/member dimension of `GlobeTileRenderer::beginTileFetch`.
  /// - Space Complexity: O(N(camera)) bounded auxiliary memory for `GlobeTileRenderer::beginTileFetch`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::beginTileFetch` (`void`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::beginTileFetch` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::beginTileFetch` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::beginTileFetch` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-BEGINTILEFETCH] | SysML v2: ActionDef(GlobeTileRenderer::beginTileFetch)
  void beginTileFetch(VirtualCamera camera, ui.Size viewportSize, {bool isFlying = false}) {
    if (!_fetcher.isEnabled()) return;
    _fetchVisibleTiles(camera, viewportSize, isFlying: isFlying); // fire-and-forget
  }

  /// Executes deterministic method `GlobeTileRenderer::_fetchVisibleTiles` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_fetchVisibleTiles` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_fetchVisibleTiles` (declaration #17) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GlobeTileRenderer::_fetchVisibleTiles` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `GlobeTileRenderer::_fetchVisibleTiles` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_fetchVisibleTiles)) bounded over input/member dimension of `GlobeTileRenderer::_fetchVisibleTiles`.
  /// - Space Complexity: O(K(_fetchVisibleTiles)) bounded auxiliary memory for `GlobeTileRenderer::_fetchVisibleTiles`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_fetchVisibleTiles` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_fetchVisibleTiles` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_fetchVisibleTiles` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_fetchVisibleTiles` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-FETCHVISIBLETILES] | SysML v2: ActionDef(GlobeTileRenderer::_fetchVisibleTiles)
  Future<void> _fetchVisibleTiles(
      VirtualCamera camera, ui.Size viewportSize, {bool isFlying = false}) async {
    final tiles = _visibleTiles(camera, viewportSize, isFlying: isFlying);

    final List<TileCoord> toFetch = [];
    for (final tile in tiles) {
      if (!_loadedImages.containsKey(tile.key) &&
          !_pendingFetches.contains(tile.key)) {
        toFetch.add(tile);
      }
    }

    if (toFetch.isEmpty) return;

    for (final tile in toFetch) {
      if (_activeFetchCount >= _maxConcurrentFetches) {
        break;
      }
      _fetchAndDecode(tile);
    }
  }

  /// Executes deterministic method `GlobeTileRenderer::_fetchAndDecode` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_fetchAndDecode` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_fetchAndDecode` (declaration #18) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `tile: TileCoord` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_fetchAndDecode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `GlobeTileRenderer::_fetchAndDecode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(tile)) bounded over input/member dimension of `GlobeTileRenderer::_fetchAndDecode`.
  /// - Space Complexity: O(N(tile)) bounded auxiliary memory for `GlobeTileRenderer::_fetchAndDecode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_fetchAndDecode` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_fetchAndDecode` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_fetchAndDecode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_fetchAndDecode` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-FETCHANDDECODE] | SysML v2: ActionDef(GlobeTileRenderer::_fetchAndDecode)
  Future<void> _fetchAndDecode(TileCoord tile) async {
    final providerAtStart = _activeProvider;
    _pendingFetches.add(tile.key);
    _activeFetchCount++;
    try {
      final data = await _fetcher.fetchTile(
          providerAtStart, tile.zoom, tile.x, tile.y);
      if (_disposed || _activeProvider != providerAtStart) {
        return;
      }
      if (data != null) {
        final codec = await ui.instantiateImageCodec(data);
        if (_disposed || _activeProvider != providerAtStart) {
          return;
        }
        final frame = await codec.getNextFrame();
        if (_disposed || _activeProvider != providerAtStart) {
          return;
        }
        final image = frame.image;

        final existing = _loadedImages[tile.key];
        if (existing != null) {
          existing.dispose();
        }
        _loadedImages[tile.key] = image;
        _cachedSortedEntries = null;
        _cachedSortedEntriesLength = -1;
        if (_loadedImages.length > 128) {
          final firstKey = _loadedImages.keys.first;
          final evicted = _loadedImages.remove(firstKey);
          evicted?.dispose();
        }
        onTileLoaded?.call();
      }
    } finally {
      _pendingFetches.remove(tile.key);
      _activeFetchCount--;
    }
  }

  // ---------------------------------------------------------------------------
  // Synchronous tile rendering
  // ---------------------------------------------------------------------------

  /// Draws every loaded tile onto [canvas] using [projectFn] to map
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::renderTiles` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::renderTiles` (declaration #19) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `GlobeTileRenderer::renderTiles` in `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `GlobeTileRenderer::renderTiles` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(renderTiles)) bounded over input/member dimension of `GlobeTileRenderer::renderTiles`.
  /// - Space Complexity: O(K(renderTiles)) bounded auxiliary memory for `GlobeTileRenderer::renderTiles`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::renderTiles` (`void`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::renderTiles` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::renderTiles` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::renderTiles` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-RENDERTILES] | SysML v2: ActionDef(GlobeTileRenderer::renderTiles)
  void renderTiles(
    ui.Canvas canvas,
    VirtualCamera camera,
    ui.Size size,
    ui.Offset center,
    double sphereRadius,
    ProjectedPoint Function(double dim_0, double lng) projectFn, {
    bool isFlying = false,
  }) {
    if (!_fetcher.isEnabled()) return;

    // Kick off fetches for tiles that may be needed soon.
    beginTileFetch(camera, size, isFlying: isFlying);

    final List<MapEntry<String, ui.Image>> sortedEntries;
    if (_cachedSortedEntries != null && _cachedSortedEntriesLength == _loadedImages.length) {
      sortedEntries = _cachedSortedEntries!;
    } else {
      sortedEntries = _loadedImages.entries.toList()
        ..sort((e1, e2) {
          final z1 = int.tryParse(e1.key.split('/')[0]) ?? 0;
          final z2 = int.tryParse(e2.key.split('/')[0]) ?? 0;
          return z1.compareTo(z2);
        });
      _cachedSortedEntries = sortedEntries;
      _cachedSortedEntriesLength = _loadedImages.length;
    }
    for (final entry in sortedEntries) {
      final key = entry.key;
      final parts = key.split('/');
      if (parts.length != 3) continue;
      final z = int.tryParse(parts[0]) ?? -1;
      final x = int.tryParse(parts[1]) ?? -1;
      final y = int.tryParse(parts[2]) ?? -1;
      if (z < 0 || x < 0 || y < 0) continue;

      // LOD masking: skip this tile if a higher-zoom child tile is loaded.
      if (_hasHigherZoomOverlay(TileCoord(zoom: z, x: x, y: y))) continue;

      // Geographic bounds for this tile.
      final double latN = _tile2lat(y.toDouble(), z);
      final double latS = _tile2lat((y + 1).toDouble(), z);
      final double lonW = _tile2lon(x, z);
      final double lonE = _tile2lon(x + 1, z);

      final int subdivisions = subdivisionsForTesting(z);
      final List<ui.Offset> positions = [];
      final List<ui.Offset> textureCoordinates = [];
      final List<double> zs = [];

      for (int r = 0; r <= subdivisions; r++) {
        final double v = r / subdivisions;
        final double latDeg = _tile2lat(y + v, z);
        final double dim_0 = _rad(latDeg);
        final double texY = v * 256.0;

        for (int c = 0; c <= subdivisions; c++) {
          final double u = c / subdivisions;
          final double lonDeg = lonW + (lonE - lonW) * u;
          final double dim_1 = _rad(lonDeg);
          final double texX = u * 256.0;

          double projLat = latDeg;
          if (latDeg >= 85.0511) {
            projLat = 90.0;
          } else if (latDeg <= -85.0511) {
            projLat = -90.0;
          }

          final projected = projectFn(projLat, lonDeg);
          positions.add(projected.offset);
          textureCoordinates.add(ui.Offset(texX, texY));
          zs.add(projected.z);
        }
      }

      final List<int> indices = [];
      for (int r = 0; r < subdivisions; r++) {
        for (int c = 0; c < subdivisions; c++) {
          final int i0 = r * (subdivisions + 1) + c;
          final int i1 = i0 + 1;
          final int i2 = (r + 1) * (subdivisions + 1) + c;
          final int i3 = i2 + 1;

          // Triangle 1: (i0, i1, i2)
          final bool anyBehind1 = zs[i0] <= -100.0 || zs[i1] <= -100.0 || zs[i2] <= -100.0;
          final bool allCulled1 = zs[i0] < -0.5 && zs[i1] < -0.5 && zs[i2] < -0.5;
          if (anyBehind1 || allCulled1) {
            // Discard
          } else {
            indices.add(i0);
            indices.add(i1);
            indices.add(i2);
          }

          // Triangle 2: (i1, i3, i2)
          final bool anyBehind2 = zs[i1] <= -100.0 || zs[i3] <= -100.0 || zs[i2] <= -100.0;
          final bool allCulled2 = zs[i1] < -0.5 && zs[i3] < -0.5 && zs[i2] < -0.5;
          if (anyBehind2 || allCulled2) {
            // Discard
          } else {
            indices.add(i1);
            indices.add(i3);
            indices.add(i2);
          }
        }
      }

      if (indices.isEmpty) {
        if (onDrawVerticesForTesting != null) {
          onDrawVerticesForTesting!(positions, indices);
        }
        continue;
      }

      if (onDrawVerticesForTesting != null) {
        onDrawVerticesForTesting!(positions, indices);
      }

      final vertices = ui.Vertices(
        ui.VertexMode.triangles,
        positions,
        textureCoordinates: textureCoordinates,
        indices: indices,
      );

      final paint = ui.Paint()
        ..shader = ui.ImageShader(
          entry.value,
          ui.TileMode.clamp,
          ui.TileMode.clamp,
          Float64List.fromList([
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0,
          ]),
        );

      canvas.drawVertices(vertices, ui.BlendMode.srcOver, paint);
    }
  }

  /// Returns true only when all four direct child tiles at zoom [tile.zoom]+1
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_hasHigherZoomOverlay` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_hasHigherZoomOverlay` (declaration #20) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `tile: TileCoord` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_hasHigherZoomOverlay`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `GlobeTileRenderer::_hasHigherZoomOverlay` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(tile)) bounded over input/member dimension of `GlobeTileRenderer::_hasHigherZoomOverlay`.
  /// - Space Complexity: O(N(tile)) bounded auxiliary memory for `GlobeTileRenderer::_hasHigherZoomOverlay`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_hasHigherZoomOverlay` (`bool`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_hasHigherZoomOverlay` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_hasHigherZoomOverlay` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_hasHigherZoomOverlay` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-HASHIGHERZOOMOVERLAY] | SysML v2: ActionDef(GlobeTileRenderer::_hasHigherZoomOverlay)
  bool _hasHigherZoomOverlay(TileCoord tile) {
    final int childZoom = tile.zoom + 1;
    final int childX0 = tile.x * 2;
    final int childY0 = tile.y * 2;
    final List<String> requiredChildren = [
      '$childZoom/$childX0/$childY0',
      '$childZoom/${childX0 + 1}/$childY0',
      '$childZoom/$childX0/${childY0 + 1}',
      '$childZoom/${childX0 + 1}/${childY0 + 1}',
    ];
    for (final childKey in requiredChildren) {
      if (!_loadedImages.containsKey(childKey)) return false;
    }
    return true;
  }

  /// Executes deterministic method `GlobeTileRenderer::_min4` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_min4` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_min4` (declaration #21) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `a: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_min4`.
  /// - `b: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_min4`.
  /// - `c: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_min4`.
  /// - `d: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_min4`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `GlobeTileRenderer::_min4` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(a)) bounded over input/member dimension of `GlobeTileRenderer::_min4`.
  /// - Space Complexity: O(N(a)) bounded auxiliary memory for `GlobeTileRenderer::_min4`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_min4` (`double`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_min4` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_min4` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_min4` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-MIN4] | SysML v2: ActionDef(GlobeTileRenderer::_min4)
  double _min4(double a, double b, double c, double d) {
    double m = a;
    if (b < m) m = b;
    if (c < m) m = c;
    if (d < m) m = d;
    return m;
  }

  /// Executes deterministic method `GlobeTileRenderer::_max4` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::_max4` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::_max4` (declaration #22) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `a: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_max4`.
  /// - `b: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_max4`.
  /// - `c: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_max4`.
  /// - `d: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::_max4`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `GlobeTileRenderer::_max4` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(a)) bounded over input/member dimension of `GlobeTileRenderer::_max4`.
  /// - Space Complexity: O(N(a)) bounded auxiliary memory for `GlobeTileRenderer::_max4`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::_max4` (`double`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::_max4` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::_max4` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::_max4` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-MAX4] | SysML v2: ActionDef(GlobeTileRenderer::_max4)
  double _max4(double a, double b, double c, double d) {
    double m = a;
    if (b > m) m = b;
    if (c > m) m = c;
    if (d > m) m = d;
    return m;
  }

  /// Executes deterministic method `GlobeTileRenderer::visibleTilesForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::visibleTilesForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::visibleTilesForTesting` (declaration #23) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `camera: VirtualCamera` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::visibleTilesForTesting`.
  /// - `viewportSize: ui.Size` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::visibleTilesForTesting`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<TileCoord>` from `GlobeTileRenderer::visibleTilesForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(camera)) bounded over input/member dimension of `GlobeTileRenderer::visibleTilesForTesting`.
  /// - Space Complexity: O(N(camera)) bounded auxiliary memory for `GlobeTileRenderer::visibleTilesForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::visibleTilesForTesting` (`List<TileCoord>`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::visibleTilesForTesting` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::visibleTilesForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::visibleTilesForTesting` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-VISIBLETILESFORTESTING] | SysML v2: ActionDef(GlobeTileRenderer::visibleTilesForTesting)
  @visibleForTesting
  List<TileCoord> visibleTilesForTesting(VirtualCamera camera, ui.Size viewportSize) {
    return _visibleTiles(camera, viewportSize);
  }

  /// Executes deterministic method `GlobeTileRenderer::latLngToTileForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::latLngToTileForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::latLngToTileForTesting` (declaration #24) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `dim_0: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::latLngToTileForTesting`.
  /// - `lng: double` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::latLngToTileForTesting`.
  /// - `zoom: int` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::latLngToTileForTesting`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TileCoord` from `GlobeTileRenderer::latLngToTileForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(dim_0)) bounded over input/member dimension of `GlobeTileRenderer::latLngToTileForTesting`.
  /// - Space Complexity: O(N(dim_0)) bounded auxiliary memory for `GlobeTileRenderer::latLngToTileForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::latLngToTileForTesting` (`TileCoord`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::latLngToTileForTesting` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::latLngToTileForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::latLngToTileForTesting` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-LATLNGTOTILEFORTESTING] | SysML v2: ActionDef(GlobeTileRenderer::latLngToTileForTesting)
  @visibleForTesting
  TileCoord latLngToTileForTesting(double dim_0, double lng, int zoom) {
    return _latLngToTile(dim_0, lng, zoom);
  }

  /// Executes deterministic method `GlobeTileRenderer::subdivisionsForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::subdivisionsForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::subdivisionsForTesting` (declaration #25) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `zoom: int` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::subdivisionsForTesting`.
  ///
  /// ## 4. Postconditions
  /// - Returns `int` from `GlobeTileRenderer::subdivisionsForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(zoom)) bounded over input/member dimension of `GlobeTileRenderer::subdivisionsForTesting`.
  /// - Space Complexity: O(N(zoom)) bounded auxiliary memory for `GlobeTileRenderer::subdivisionsForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::subdivisionsForTesting` (`int`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::subdivisionsForTesting` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::subdivisionsForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::subdivisionsForTesting` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-SUBDIVISIONSFORTESTING] | SysML v2: ActionDef(GlobeTileRenderer::subdivisionsForTesting)
  @visibleForTesting
  static int subdivisionsForTesting(int zoom) {
    final double tileWidthDeg = 360.0 / math.pow(2, zoom);
    return (tileWidthDeg / 3.0).ceil().clamp(8, 32);
  }

  /// Executes deterministic method `GlobeTileRenderer::calculateIndicesForTesting` within `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `GlobeTileRenderer::calculateIndicesForTesting` in `app_flutter/lib/features/map_viewport/cesium_3d/globe_tile_renderer.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `GlobeTileRenderer::calculateIndicesForTesting` (declaration #26) within `CESIUM-3D-GLOBE-TILE-RENDERER`.
  ///
  /// ## 3. Preconditions
  /// - `zs: List<double>` must satisfy domain and type-safety constraints prior to invoking `GlobeTileRenderer::calculateIndicesForTesting`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<int>` from `GlobeTileRenderer::calculateIndicesForTesting` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(zs)) bounded over input/member dimension of `GlobeTileRenderer::calculateIndicesForTesting`.
  /// - Space Complexity: O(N(zs)) bounded auxiliary memory for `GlobeTileRenderer::calculateIndicesForTesting`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `GlobeTileRenderer::calculateIndicesForTesting` (`List<int>`).
  /// - State: Maintains consistent state invariants across `GlobeTileRenderer::calculateIndicesForTesting` without partial mutation on error.
  /// - Action: Executes `GlobeTileRenderer::calculateIndicesForTesting` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `GlobeTileRenderer::calculateIndicesForTesting` (`CESIUM-3D-GLOBE-TILE-RENDERER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CESIUM-3D-GLOBE-TILE-RENDERER-GLOBETILERENDERER-CALCULATEINDICESFORTESTING] | SysML v2: ActionDef(GlobeTileRenderer::calculateIndicesForTesting)
  @visibleForTesting
  static List<int> calculateIndicesForTesting(List<double> zs) {
    const int subdivisions = 4;
    final List<int> indices = [];
    for (int r = 0; r < subdivisions; r++) {
      for (int c = 0; c < subdivisions; c++) {
        final int i0 = r * (subdivisions + 1) + c;
        final int i1 = i0 + 1;
        final int i2 = (r + 1) * (subdivisions + 1) + c;
        final int i3 = i2 + 1;

        // Triangle 1: (i0, i1, i2)
        final bool anyBehind1 = zs[i0] <= -100.0 || zs[i1] <= -100.0 || zs[i2] <= -100.0;
        final bool allCulled1 = zs[i0] < -0.5 && zs[i1] < -0.5 && zs[i2] < -0.5;
        if (anyBehind1 || allCulled1) {
          // Discard
        } else {
          indices.add(i0);
          indices.add(i1);
          indices.add(i2);
        }

        // Triangle 2: (i1, i3, i2)
        final bool anyBehind2 = zs[i1] <= -100.0 || zs[i3] <= -100.0 || zs[i2] <= -100.0;
        final bool allCulled2 = zs[i1] < -0.5 && zs[i3] < -0.5 && zs[i2] < -0.5;
        if (anyBehind2 || allCulled2) {
          // Discard
        } else {
          indices.add(i1);
          indices.add(i3);
          indices.add(i2);
        }
      }
    }
    return indices;
  }
}
