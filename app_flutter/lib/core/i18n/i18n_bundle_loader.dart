import 'dart:convert';
import 'package:flutter/services.dart';

/// Multi-language internationalisation string bundle loader and lookup service.
///
/// Loads locale-specific JSON string bundles (`assets/i18n/<locale>.json`) from
/// the application's asset bundle and exposes deterministic key-value string
/// resolution while retaining only a single active locale in memory.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides deterministic, non-throwing
///   label retrieval for cockpit display widgets and bounds memory consumption by
///   retaining at most one active locale dictionary at any time.
///
/// ## 2. Invariants & Mathematical Properties
/// - Lookup resolution is a total function:
///   $\text{getString}(k, f) = \text{strings}[k] \ ?? \ f \ ?? \ k$.
/// - Prior to any successful [loadBundle] or [loadBundleFromJson] call,
///   $\text{currentLocale} = \text{null} \land \text{length} = 0$.
///
/// ## 3. Preconditions
/// - [loadBundle] requires `assets/i18n/<locale>.json` to exist in [rootBundle]
///   and contain a flat JSON object of string key-value pairs.
/// - [loadBundleFromJson] requires a valid JSON object string and non-empty
///   `locale` tag.
///
/// ## 4. Postconditions
/// - Upon successful completion of [loadBundle] or [loadBundleFromJson],
///   [currentLocale] equals the loaded `locale` and `_strings` exclusively
///   contains that locale's entries.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ average-case lookup for [getString],
///   [containsKey], and [length]; $\mathcal{O}(N)$ deserialization time for $N$
///   entries during [loadBundle] or [loadBundleFromJson].
/// - **Space Complexity**: $\mathcal{O}(N)$ bounded to the single active locale's
///   $N$ key-value entries.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing translation keys in [getString] never throw; they return `fallback`
///   when provided or the raw `key` string.
/// - If [loadBundle] or [loadBundleFromJson] encounters a missing asset or
///   malformed JSON, an exception is thrown before mutating `_strings` or
///   `_currentLocale`, preserving the previously loaded locale state.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [string-externalization-plan.md/I18nBundleLoader]
class I18nBundleLoader {
  /// Internal string map for the currently loaded locale.
  Map<String, String> _strings = <String, String>{};

  /// The locale tag that is currently loaded, or `null` if no bundle has
  /// been loaded yet.
  String? _currentLocale;

  /// The locale tag that is currently loaded.
  ///
  /// Returns `null` when no bundle has been loaded yet.
  String? get currentLocale => _currentLocale;

  /// Loads the string bundle for [locale] from application assets.
  ///
  /// Reads `assets/i18n/<locale>.json` via [rootBundle], parses it as a
  /// flat JSON object, and caches the resulting key-value map. Any
  /// previously loaded strings are replaced.
  ///
  /// Throws a [FlutterError] if the asset cannot be found, or a
  /// [FormatException] if the JSON is malformed.
  Future<void> loadBundle(String locale) async {
    final String jsonString =
        await rootBundle.loadString('assets/i18n/$locale.json');
    _strings = Map<String, String>.from(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
    _currentLocale = locale;
  }

  /// Loads a bundle from a raw JSON string -- intended for testing.
  ///
  /// Replaces any previously cached strings and sets [currentLocale] to
  /// [locale]. Does **not** touch [rootBundle] or the filesystem.
  void loadBundleFromJson(String json, {required String locale}) {
    _strings = Map<String, String>.from(
      jsonDecode(json) as Map<String, dynamic>,
    );
    _currentLocale = locale;
  }

  /// Returns the translated string for [key].
  ///
  /// If [key] is not found in the currently loaded bundle, [fallback] is
  /// returned when provided; otherwise [key] itself is returned so that
  /// missing translations degrade gracefully instead of crashing.
  String getString(String key, {String? fallback}) =>
      _strings[key] ?? fallback ?? key;

  /// Returns `true` when a bundle is loaded and a value exists for [key].
  bool containsKey(String key) => _strings.containsKey(key);

  /// Returns the number of string entries in the currently loaded bundle.
  int get length => _strings.length;
}
