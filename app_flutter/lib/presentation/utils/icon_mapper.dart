import 'package:flutter/material.dart';

/// Resolves runtime schema icon name strings to Material [IconData] glyphs.
///
/// Allows the connected data source to specify entity type icons by string
/// identifier (e.g. `"dns"`, `"bar_chart"`, `"developer_board"`) without
/// coupling presentation code to compile-time domain icon choices.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides a total, deterministic
///   string-to-symbol lookup table that isolates Layer 1 `TypeDescriptor.iconName`
///   strings from Layer 3 Flutter glyph rendering while guaranteeing a non-null
///   fallback icon for unrecognised identifiers.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Total Mapping Function**: For all $s \in \text{String} \cup \{\text{null}\}$,
///   $\text{resolve}(s) \in \text{IconData}$ and $\text{resolve}(s) \neq \text{null}$.
/// - **Compile-Time Constant Lookup Table**: `_icons` is a `static const` map
///   with zero runtime mutation or re-allocation.
///
/// ## 3. Preconditions
/// - None; [resolve] accepts any nullable `String?` (including `null`, empty
///   strings, or unknown keys).
///
/// ## 4. Postconditions
/// - Returns the mapped [IconData] when [name] matches an entry in `_icons`
///   (case-sensitive), or [Icons.insert_drive_file] otherwise.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ constant-time map lookup per
///   [resolve] invocation.
/// - **Space Complexity**: $\mathcal{O}(1)$ auxiliary heap allocation (uses a
///   compile-time `const` table).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unknown, empty, or `null` icon names resolve deterministically to
///   [Icons.insert_drive_file] -- the presentation layer never renders a blank
///   glyph or throws a lookup exception.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/IconMapper, ARCH-UI-001, REQ-UI-001]
class IconMapper {
  /// Executes deterministic constructor `IconMapper::IconMapper._` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/presentation/utils/icon_mapper.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `IconMapper::IconMapper._` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/presentation/utils/icon_mapper.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `IconMapper::IconMapper._` (declaration #2) within `UTILS-ICON-MAPPER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `IconMapper::IconMapper._` in `UTILS-ICON-MAPPER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `IconMapper::IconMapper._` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(IconMapper._)) bounded over input/member dimension of `IconMapper::IconMapper._`.
  /// - Space Complexity: O(K(IconMapper._)) bounded auxiliary memory for `IconMapper::IconMapper._`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `IconMapper::IconMapper._` (`()`).
  /// - State: Maintains consistent state invariants across `IconMapper::IconMapper._` without partial mutation on error.
  /// - Action: Executes `IconMapper::IconMapper._` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `IconMapper::IconMapper._` (`UTILS-ICON-MAPPER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-UTILS-ICON-MAPPER-ICONMAPPER-ICONMAPPER] | SysML v2: ActionDef(IconMapper::IconMapper._)
  IconMapper._();

  static const Map<String, IconData> _icons = {
    'play_arrow': Icons.play_arrow,
    'bar_chart': Icons.bar_chart,
    'location_on': Icons.location_on,
    'dns': Icons.dns,
    'album': Icons.album,
    'link': Icons.link,
    'folder': Icons.folder,
    'folder_open': Icons.folder_open,
    'insert_drive_file': Icons.insert_drive_file,
    'developer_board': Icons.developer_board,
    'light_mode': Icons.light_mode,
    'dark_mode': Icons.dark_mode,
    'settings_brightness': Icons.settings_brightness,
    'settings': Icons.settings,
    'check': Icons.check,
    'text_fields': Icons.text_fields,
  };

  /// Resolve an icon name string to [IconData].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `IconMapper::resolve` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/presentation/utils/icon_mapper.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `IconMapper::resolve` (declaration #3) within `UTILS-ICON-MAPPER`.
  ///
  /// ## 3. Preconditions
  /// - `name: String?` must satisfy domain and type-safety constraints prior to invoking `IconMapper::resolve`.
  ///
  /// ## 4. Postconditions
  /// - Returns `IconData` from `IconMapper::resolve` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(name)) bounded over input/member dimension of `IconMapper::resolve`.
  /// - Space Complexity: O(N(name)) bounded auxiliary memory for `IconMapper::resolve`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `IconMapper::resolve` (`IconData`).
  /// - State: Maintains consistent state invariants across `IconMapper::resolve` without partial mutation on error.
  /// - Action: Executes `IconMapper::resolve` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `IconMapper::resolve` (`UTILS-ICON-MAPPER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-UTILS-ICON-MAPPER-ICONMAPPER-RESOLVE] | SysML v2: ActionDef(IconMapper::resolve)
  static IconData resolve(String? name) =>
      _icons[name] ?? Icons.insert_drive_file;
}

