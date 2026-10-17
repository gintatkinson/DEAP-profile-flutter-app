var _coordinateMappingCache = Expando<Map<String, String>>();
var _labelsMappingCache = Expando<Map<String, String>>();

/// Clears all memoized layout configuration caches (`_coordinateMappingCache`,
/// `_labelsMappingCache`, and `_defaultRatioMemo`).
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides deterministic cache
///   invalidation across runtime layout reconfiguration or test isolation
///   boundaries so stale layout ratios or coordinate mappings cannot persist.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Total Cache Reset**: Post-invocation, $|\text{\_defaultRatioMemo}| = 0$
///   and both [Expando] caches are freshly allocated with zero retained entries.
///
/// ## 3. Preconditions
/// - May be invoked at any lifecycle point on the main UI isolate.
///
/// ## 4. Postconditions
/// - All subsequent calls to [getDefaultRatio], [resolveCoordinateMapping], and
///   [resolveLabelsMapping] recompute values from the supplied configuration map.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for [Expando] reallocation and map clear.
/// - **Space Complexity**: $\mathcal{O}(1)$ auxiliary memory.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Safe no-op when caches are already empty; never throws.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [ARCH-LAYOUT-001, REQ-LAYOUT-001, REQ-LAYOUT-002]
/// Realises: [Feat-10/LayoutConfigService]
void clearLayoutConfigCaches() {
  _coordinateMappingCache = Expando<Map<String, String>>();
  _labelsMappingCache = Expando<Map<String, String>>();
  _defaultRatioMemo.clear();
}

final _defaultRatioMemo = <({int configHash, String key}), double>{};

/// Resolves and memoizes a numeric split ratio from [layoutConfig] by dotted
/// path [key], returning [fallback] when the path is absent or non-numeric.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Guarantees deterministic initial
///   pane geometry in ARINC 661 split workspaces even when configuration tokens
///   are missing or malformed.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Idempotent Memoization**: For a fixed identity hash $h = \text{id}(\text{layoutConfig})$
///   and path key $k$, repeated lookups return the identical floating-point ratio $r$.
///
/// ## 3. Preconditions
/// - [layoutConfig] is a parsed JSON configuration map (may be empty).
/// - [key] is a dot-delimited lookup path (e.g. `'layout_properties.default_ratio'`).
/// - [fallback] is a finite default split ratio (typically $r \in (0, 1)$).
///
/// ## 4. Postconditions
/// - Returns the resolved `double` value at [key] or [fallback], and caches the
///   result in `_defaultRatioMemo`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ on cache hit; $\mathcal{O}(D)$ on cache
///   miss where $D$ is the dot-path depth.
/// - **Space Complexity**: $\mathcal{O}(K)$ where $K$ is the number of distinct
///   `(configHash, key)` pairs queried.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing keys, non-map intermediate nodes, or non-numeric leaf values safely
///   cache and return [fallback] without throwing exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [ARCH-LAYOUT-001, REQ-LAYOUT-001, REQ-LAYOUT-002]
/// Realises: [Feat-10/LayoutConfigService]
double getDefaultRatio(Map<String, dynamic> layoutConfig, String key, double fallback) {
  final memoKey = (configHash: identityHashCode(layoutConfig), key: key);
  final cached = _defaultRatioMemo[memoKey];
  if (cached != null) return cached;
  try {
    final parts = key.split('.');
    dynamic current = layoutConfig;
    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        _defaultRatioMemo[memoKey] = fallback;
        return fallback;
      }
    }
    if (current is num) {
      final result = current.toDouble();
      _defaultRatioMemo[memoKey] = result;
      return result;
    }
  } catch (_) {}
  _defaultRatioMemo[memoKey] = fallback;
  return fallback;
}

/// Resolves and memoizes the 4D spatial-temporal coordinate attribute mapping
/// (`x`, `y`, `z`, `t`, `trajectory`) from [layoutConfig].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Ensures deterministic binding
///   between schema-defined spatial/temporal attribute paths and 2D/3D viewport
///   coordinate axes without hardcoded domain assumptions.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Identity-Keyed Cache Consistency**: Each [layoutConfig] object reference
///   maps to at most one resolved `Map<String, String>` inside `_coordinateMappingCache`.
///
/// ## 3. Preconditions
/// - [layoutConfig] is a valid map object suitable as an [Expando] key.
///
/// ## 4. Postconditions
/// - Returns a non-null `Map<String, String>` containing either the configured
///   `layout_mappings.coordinate_mapping` entries or the canonical 5-axis default map.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ on [Expando] cache hit; $\mathcal{O}(M)$
///   on cache miss where $M$ is the number of coordinate mapping entries.
/// - **Space Complexity**: $\mathcal{O}(M)$ weakly referenced per [layoutConfig] instance.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If `layout_mappings.coordinate_mapping` is absent or malformed, falls back
///   deterministically to the canonical `position/dim_0..2`, `position/time_index`,
///   and `position/vector` mapping.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [ARCH-LAYOUT-001, REQ-LAYOUT-001, REQ-LAYOUT-002]
/// Realises: [Feat-10/LayoutConfigService]
Map<String, String> resolveCoordinateMapping(Map<String, dynamic> layoutConfig) {
  final cached = _coordinateMappingCache[layoutConfig];
  if (cached != null) return cached;
  try {
    if (layoutConfig['layout_mappings'] != null &&
        layoutConfig['layout_mappings']['coordinate_mapping'] != null) {
      final Map<String, dynamic> rawMap =
          layoutConfig['layout_mappings']['coordinate_mapping'] as Map<String, dynamic>;
      final result = rawMap.map((key, value) => MapEntry(key, value.toString()));
      _coordinateMappingCache[layoutConfig] = result;
      return result;
    }
  } catch (_) {}
  final fallback = const <String, String>{
    'x': 'position/dim_0',
    'y': 'position/dim_1',
    'z': 'position/dim_2',
    't': 'position/time_index',
    'trajectory': 'position/vector',
  };
  _coordinateMappingCache[layoutConfig] = fallback;
  return fallback;
}

/// Resolves and memoizes the human-readable tab and section label mapping from
/// [layoutConfig].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Decouples presentation display
///   labels from internal schema identifiers while guaranteeing deterministic
///   fallback behavior when label overrides are omitted.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Weak-Reference Memoization**: Cached mappings are attached to [layoutConfig]
///   via [Expando] so memory is reclaimed automatically when [layoutConfig] becomes
///   unreachable.
///
/// ## 3. Preconditions
/// - [layoutConfig] is a non-null map instance.
///
/// ## 4. Postconditions
/// - Returns a non-null `Map<String, String>` of label overrides, or an empty
///   constant map when no `layout_mappings.labels` section is present.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ on cache hit; $\mathcal{O}(L)$ on cache
///   miss where $L$ is the number of configured label entries.
/// - **Space Complexity**: $\mathcal{O}(L)$ weakly bound to [layoutConfig].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Malformed or missing `layout_mappings.labels` structures safely cache and
///   return an empty `const <String, String>{}` without throwing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [ARCH-LAYOUT-001, REQ-LAYOUT-001, REQ-LAYOUT-002]
/// Realises: [Feat-10/LayoutConfigService]
Map<String, String> resolveLabelsMapping(Map<String, dynamic> layoutConfig) {
  final cached = _labelsMappingCache[layoutConfig];
  if (cached != null) return cached;
  try {
    if (layoutConfig['layout_mappings'] != null &&
        layoutConfig['layout_mappings']['labels'] != null) {
      final Map<String, dynamic> rawLabels =
          layoutConfig['layout_mappings']['labels'] as Map<String, dynamic>;
      final result = rawLabels.map((key, value) => MapEntry(key, value.toString()));
      _labelsMappingCache[layoutConfig] = result;
      return result;
    }
  } catch (_) {}
  const fallback = <String, String>{};
  _labelsMappingCache[layoutConfig] = fallback;
  return fallback;
}
