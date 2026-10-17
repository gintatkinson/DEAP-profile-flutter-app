/// Central immutable registry for compile-time application configuration constants.
///
/// Every presentation and platform shell layer reads the application title,
/// window chrome identifier, and compile-time capability gates from this class
/// so that configuration remains deterministic across all runtime surfaces.
/// Alternative: [StringResources] for locale or asset-backed strings requiring
/// runtime reload.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces compile-time constant
///   canonicalization for display surface identity and outbound network tile
///   fetching gates, preventing unauthorized or unconfigured external I/O in
///   air-gapped cockpit display environments.
///
/// ## 2. Invariants & Mathematical Properties
/// - All configuration fields are compile-time `static const` bindings:
///   $\forall k \in \text{AppConfig},\ \text{mut}(k) = \varnothing$.
/// - Outbound map imagery fetching satisfies the boolean guard
///   $\text{allowHttpTileFetch} \iff \text{mapImageryEnabled} = \text{true}$.
///
/// ## 3. Preconditions
/// - Optional compile-time environment overrides (such as
///   `--dart-define=MAP_IMAGERY_ENABLED=false`) must be supplied to the Dart
///   compiler prior to application bootstrap.
///
/// ## 4. Postconditions
/// - Guarantees deterministic, allocation-free read access to application
///   identifiers and capability flags across the entire process lifetime.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ compile-time constant evaluation.
/// - **Space Complexity**: $\mathcal{O}(1)$ static read-only program segment storage.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing `--dart-define` flags safely resolve to deterministic compile-time
///   defaults (`mapImageryEnabled = true`, `title = 'Platform Console'`) with
///   zero runtime exception paths.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/AppConfig]
class AppConfig {
  AppConfig._();

  /// The human-readable application title shown in window chrome and
  /// branding surfaces.
  static const String title = 'Platform Console';

  /// The title used for platform window decoration (e.g. macOS title bar).
  static const String windowTitle = 'Platform Console';

  /// Whether HTTP map-imagery tile fetching is permitted at runtime.
  ///
  /// Disable with the compile-time flag
  /// `--dart-define=MAP_IMAGERY_ENABLED=false`. When `false`, tile fetchers
  /// treat themselves as disabled and never make outbound requests.
  static const bool mapImageryEnabled =
      bool.fromEnvironment('MAP_IMAGERY_ENABLED', defaultValue: true);
}
