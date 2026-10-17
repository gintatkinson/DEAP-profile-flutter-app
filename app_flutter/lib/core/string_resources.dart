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
  /// Must be called before any call to [get]. Calling this again replaces
  /// the entire string map. Throws on invalid JSON or missing asset.
  static Future<void> load() async {
    final json = await rootBundle.loadString('assets/strings.json');
    _strings = Map<String, String>.from(jsonDecode(json) as Map);
  }

  /// Returns the string for [key] or [fallback] (defaults to [key] itself).
  ///
  /// When [key] is missing and [fallback] is null the raw key is returned so
  /// that missing translations degrade gracefully instead of crashing.
  static String get(String key, {String? fallback}) =>
      _strings[key] ?? fallback ?? key;

  /// Loads strings from a raw JSON string -- intended for tests.
  ///
  /// Replaces any previously cached strings. Throws on invalid JSON input.
  /// Does **not** touch `rootBundle` or the filesystem.
  static void loadFromJson(String json) {
    _strings = Map<String, String>.from(jsonDecode(json) as Map);
  }
}
