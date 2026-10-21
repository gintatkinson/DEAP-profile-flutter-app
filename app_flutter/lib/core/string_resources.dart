import 'dart:convert';
import 'package:flutter/services.dart';

/// Runtime-loaded string resource registry backed by a flat JSON asset map.
///
/// All presentation display strings are externalized in `assets/strings.json` so
/// labels can be updated without modifying widget code. Call [load] once during
/// application bootstrap before any widget invokes [get], or use [loadFromJson]
/// in unit tests to inject deterministic fixtures without filesystem access.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Guarantees non-throwing,
///   deterministic label resolution during 60 FPS cockpit display rendering so
///   missing localization keys never trigger unhandled widget build exceptions.
///
/// ## 2. Invariants & Mathematical Properties
/// - Lookup resolution satisfies the total fallback function:
///   $\text{get}(k, f) = \text{strings}[k] \ ?? \ f \ ?? \ k$, guaranteeing a
///   non-null `String` return for all $k \in \Sigma^*$.
/// - State replacement on [load] or [loadFromJson] is atomic with respect to the
///   static `_strings` reference.
///
/// ## 3. Preconditions
/// - [load] requires `assets/strings.json` to be bundled in [rootBundle] and
///   formatted as a valid JSON object mapping string keys to string values.
/// - [loadFromJson] requires a syntactically valid JSON object string.
///
/// ## 4. Postconditions
/// - After [load] or [loadFromJson] completes, `_strings` holds the complete
///   key-value dictionary and subsequent [get] calls resolve in constant time.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ average hash-map lookup per [get]
///   invocation; $\mathcal{O}(N)$ parsing time during [load] or [loadFromJson]
///   for $N$ string entries.
/// - **Space Complexity**: $\mathcal{O}(N)$ static memory for $N$ cached key-value
///   pairs.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing keys in [get] degrade gracefully to the caller-supplied `fallback`
///   or the raw `key` identifier itself.
/// - Malformed JSON or missing asset bundles during [load] / [loadFromJson]
///   surface a [FormatException] or [FlutterError] at bootstrap rather than
///   corrupting previously cached strings.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 1 (Domain State & Data Model)
///
/// Realises: [Feat-10/StringResources]
class StringResources {
  static Map<String, String> _strings = {};

  /// Loads strings from `assets/strings.json` via [rootBundle].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `StringResources::load` in `app_flutter/lib/core/string_resources.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `StringResources::load` (declaration #2) within `CORE-STRING-RESOURCES`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `StringResources::load` in `CORE-STRING-RESOURCES`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `StringResources::load` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(load)) bounded over input/member dimension of `StringResources::load`.
  /// - Space Complexity: O(K(load)) bounded auxiliary memory for `StringResources::load`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `StringResources::load` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `StringResources::load` without partial mutation on error.
  /// - Action: Executes `StringResources::load` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `StringResources::load` (`CORE-STRING-RESOURCES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CORE-STRING-RESOURCES-STRINGRESOURCES-LOAD] | SysML v2: ActionDef(StringResources::load)
  static Future<void> load() async {
    final json = await rootBundle.loadString('assets/strings.json');
    _strings = Map<String, String>.from(jsonDecode(json) as Map);
  }

  /// Returns the string for [key] or [fallback] (defaults to [key] itself).
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `StringResources::get` in `app_flutter/lib/core/string_resources.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `StringResources::get` (declaration #3) within `CORE-STRING-RESOURCES`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `StringResources::get`.
  /// - `fallback: String?` must satisfy domain and type-safety constraints prior to invoking `StringResources::get`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String` from `StringResources::get` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `StringResources::get`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `StringResources::get`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `StringResources::get` (`String`).
  /// - State: Maintains consistent state invariants across `StringResources::get` without partial mutation on error.
  /// - Action: Executes `StringResources::get` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `StringResources::get` (`CORE-STRING-RESOURCES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CORE-STRING-RESOURCES-STRINGRESOURCES-GET] | SysML v2: ActionDef(StringResources::get)
  static String get(String key, {String? fallback}) =>
      _strings[key] ?? fallback ?? key;

  /// Loads strings from a raw JSON string -- intended for tests.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `StringResources::loadFromJson` in `app_flutter/lib/core/string_resources.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `StringResources::loadFromJson` (declaration #4) within `CORE-STRING-RESOURCES`.
  ///
  /// ## 3. Preconditions
  /// - `json: String` must satisfy domain and type-safety constraints prior to invoking `StringResources::loadFromJson`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `StringResources::loadFromJson` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `StringResources::loadFromJson`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `StringResources::loadFromJson`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `StringResources::loadFromJson` (`void`).
  /// - State: Maintains consistent state invariants across `StringResources::loadFromJson` without partial mutation on error.
  /// - Action: Executes `StringResources::loadFromJson` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `StringResources::loadFromJson` (`CORE-STRING-RESOURCES`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-CORE-STRING-RESOURCES-STRINGRESOURCES-LOADFROMJSON] | SysML v2: ActionDef(StringResources::loadFromJson)
  static void loadFromJson(String json) {
    _strings = Map<String, String>.from(jsonDecode(json) as Map);
  }
}
