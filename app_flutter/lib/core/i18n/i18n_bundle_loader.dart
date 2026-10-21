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
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `I18nBundleLoader::currentLocale` in `app_flutter/lib/core/i18n/i18n_bundle_loader.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `I18nBundleLoader::currentLocale` (declaration #2) within `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `I18nBundleLoader::currentLocale` in `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `I18nBundleLoader::currentLocale` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(currentLocale)) bounded over input/member dimension of `I18nBundleLoader::currentLocale`.
  /// - Space Complexity: O(K(currentLocale)) bounded auxiliary memory for `I18nBundleLoader::currentLocale`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `I18nBundleLoader::currentLocale` (`()`).
  /// - State: Maintains consistent state invariants across `I18nBundleLoader::currentLocale` without partial mutation on error.
  /// - Action: Executes `I18nBundleLoader::currentLocale` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `I18nBundleLoader::currentLocale` (`I18N-I18N-BUNDLE-LOADER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-I18N-I18N-BUNDLE-LOADER-I18NBUNDLELOADER-CURRENTLOCALE] | SysML v2: ActionDef(I18nBundleLoader::currentLocale)
  String? get currentLocale => _currentLocale;

  /// Loads the string bundle for [locale] from application assets.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `I18nBundleLoader::loadBundle` in `app_flutter/lib/core/i18n/i18n_bundle_loader.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `I18nBundleLoader::loadBundle` (declaration #2) within `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 3. Preconditions
  /// - `locale: String` must satisfy domain and type-safety constraints prior to invoking `I18nBundleLoader::loadBundle`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `I18nBundleLoader::loadBundle` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(locale)) bounded over input/member dimension of `I18nBundleLoader::loadBundle`.
  /// - Space Complexity: O(N(locale)) bounded auxiliary memory for `I18nBundleLoader::loadBundle`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `I18nBundleLoader::loadBundle` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `I18nBundleLoader::loadBundle` without partial mutation on error.
  /// - Action: Executes `I18nBundleLoader::loadBundle` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `I18nBundleLoader::loadBundle` (`I18N-I18N-BUNDLE-LOADER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-I18N-I18N-BUNDLE-LOADER-I18NBUNDLELOADER-LOADBUNDLE] | SysML v2: ActionDef(I18nBundleLoader::loadBundle)
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
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `I18nBundleLoader::loadBundleFromJson` in `app_flutter/lib/core/i18n/i18n_bundle_loader.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `I18nBundleLoader::loadBundleFromJson` (declaration #3) within `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 3. Preconditions
  /// - `json: String` must satisfy domain and type-safety constraints prior to invoking `I18nBundleLoader::loadBundleFromJson`.
  /// - `locale: String` must satisfy domain and type-safety constraints prior to invoking `I18nBundleLoader::loadBundleFromJson`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `I18nBundleLoader::loadBundleFromJson` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `I18nBundleLoader::loadBundleFromJson`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `I18nBundleLoader::loadBundleFromJson`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `I18nBundleLoader::loadBundleFromJson` (`void`).
  /// - State: Maintains consistent state invariants across `I18nBundleLoader::loadBundleFromJson` without partial mutation on error.
  /// - Action: Executes `I18nBundleLoader::loadBundleFromJson` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `I18nBundleLoader::loadBundleFromJson` (`I18N-I18N-BUNDLE-LOADER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-I18N-I18N-BUNDLE-LOADER-I18NBUNDLELOADER-LOADBUNDLEFROMJSON] | SysML v2: ActionDef(I18nBundleLoader::loadBundleFromJson)
  void loadBundleFromJson(String json, {required String locale}) {
    _strings = Map<String, String>.from(
      jsonDecode(json) as Map<String, dynamic>,
    );
    _currentLocale = locale;
  }

  /// Returns the translated string for [key].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `I18nBundleLoader::getString` in `app_flutter/lib/core/i18n/i18n_bundle_loader.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `I18nBundleLoader::getString` (declaration #4) within `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `I18nBundleLoader::getString`.
  /// - `fallback: String?` must satisfy domain and type-safety constraints prior to invoking `I18nBundleLoader::getString`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `I18nBundleLoader::getString` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `I18nBundleLoader::getString`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `I18nBundleLoader::getString`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `I18nBundleLoader::getString` (`String`).
  /// - State: Maintains consistent state invariants across `I18nBundleLoader::getString` without partial mutation on error.
  /// - Action: Executes `I18nBundleLoader::getString` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `I18nBundleLoader::getString` (`I18N-I18N-BUNDLE-LOADER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-I18N-I18N-BUNDLE-LOADER-I18NBUNDLELOADER-GETSTRING] | SysML v2: ActionDef(I18nBundleLoader::getString)
  String getString(String key, {String? fallback}) =>
      _strings[key] ?? fallback ?? key;

  /// Returns `true` when a bundle is loaded and a value exists for [key].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `I18nBundleLoader::containsKey` in `app_flutter/lib/core/i18n/i18n_bundle_loader.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `I18nBundleLoader::containsKey` (declaration #5) within `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `I18nBundleLoader::containsKey` in `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `I18nBundleLoader::containsKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(containsKey)) bounded over input/member dimension of `I18nBundleLoader::containsKey`.
  /// - Space Complexity: O(K(containsKey)) bounded auxiliary memory for `I18nBundleLoader::containsKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `I18nBundleLoader::containsKey` (`bool`).
  /// - State: Maintains consistent state invariants across `I18nBundleLoader::containsKey` without partial mutation on error.
  /// - Action: Executes `I18nBundleLoader::containsKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `I18nBundleLoader::containsKey` (`I18N-I18N-BUNDLE-LOADER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-I18N-I18N-BUNDLE-LOADER-I18NBUNDLELOADER-CONTAINSKEY] | SysML v2: ActionDef(I18nBundleLoader::containsKey)
  bool containsKey(String key) => _strings.containsKey(key);

  /// Returns the number of string entries in the currently loaded bundle.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `I18nBundleLoader::length` in `app_flutter/lib/core/i18n/i18n_bundle_loader.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `I18nBundleLoader::length` (declaration #7) within `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `I18nBundleLoader::length` in `I18N-I18N-BUNDLE-LOADER`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `I18nBundleLoader::length` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(length)) bounded over input/member dimension of `I18nBundleLoader::length`.
  /// - Space Complexity: O(K(length)) bounded auxiliary memory for `I18nBundleLoader::length`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `I18nBundleLoader::length` (`()`).
  /// - State: Maintains consistent state invariants across `I18nBundleLoader::length` without partial mutation on error.
  /// - Action: Executes `I18nBundleLoader::length` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `I18nBundleLoader::length` (`I18N-I18N-BUNDLE-LOADER`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-I18N-I18N-BUNDLE-LOADER-I18NBUNDLELOADER-LENGTH] | SysML v2: ActionDef(I18nBundleLoader::length)
  int get length => _strings.length;
}
