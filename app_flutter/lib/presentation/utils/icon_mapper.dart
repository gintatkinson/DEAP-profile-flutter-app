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
  /// Returns [Icons.insert_drive_file] as fallback if the name is unknown.
  /// An empty or null [name] also returns the fallback -- it does not throw.
  /// The lookup is case-sensitive; "DNS" does not match "dns".
  static IconData resolve(String? name) =>
      _icons[name] ?? Icons.insert_drive_file;
}

