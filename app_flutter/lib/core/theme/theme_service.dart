import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract persistence contract for operator theme, typography scale, split
/// axis, and overlay opacity preferences.
///
/// Decouples presentation controllers ([ThemeController],
/// [TextScalerController]) from platform-specific key-value storage engines.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces deterministic fallback
///   defaults across all display preference load operations so missing or
///   corrupted non-volatile storage never prevents cockpit display startup.
///
/// ## 2. Invariants & Mathematical Properties
/// - Default hydration mapping when storage keys are absent:
///   $\text{mode} \mapsto \text{ThemeMode.system}$,
///   $\text{scheme} \mapsto 0$,
///   $\text{scale} \mapsto 1.0$,
///   $\text{axis} \mapsto \text{Axis.vertical}$,
///   $\text{opacity} \mapsto 0.85$.
///
/// ## 3. Preconditions
/// - Concrete implementations must initialize their underlying storage handle
///   lazily or prior to servicing read/write futures.
///
/// ## 4. Postconditions
/// - Every `load*` method resolves to a valid, non-null domain value; every
///   `save*` method completes after committing or safely handling storage I/O.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ key-value lookup or write per
///   preference property.
/// - **Space Complexity**: $\mathcal{O}(1)$ fixed set of 5 preference keys.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Unrecognized enum strings or platform storage exceptions must resolve to
///   deterministic default values rather than propagating unhandled exceptions
///   to UI controllers.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/ThemeService]
abstract class ThemeService {
  /// Loads the persisted [ThemeMode]; defaults to [ThemeMode.system] when
  /// no value has been saved yet.
  Future<ThemeMode> loadThemeMode();

  /// Persists [themeMode] so it survives app restarts.
  Future<void> saveThemeMode(ThemeMode themeMode);

  /// Loads the persisted colour-scheme index; defaults to `0`.
  Future<int> loadThemeScheme();

  /// Persists the colour-scheme [index] so it survives app restarts.
  Future<void> saveThemeScheme(int index);

  /// Loads the persisted text scale factor; defaults to `1.0`.
  Future<double> loadTextScale();

  /// Persists the text [scale] factor so it survives app restarts.
  Future<void> saveTextScale(double scale);

  /// Loads the persisted workspace split axis orientation; defaults to
  /// [Axis.vertical] if the key is missing or invalid.
  Future<Axis> loadLayoutSplitAxis();

  /// Persists [axis] so it survives app restarts.
  Future<void> saveLayoutSplitAxis(Axis axis);

  /// Loads the persisted panel opacity; defaults to `0.85`.
  Future<double> loadPanelOpacity();

  /// Persists the panel [opacity] so it survives app restarts.
  Future<void> savePanelOpacity(double opacity);
}

/// Concrete [ThemeService] implementation backed by platform [SharedPreferences].
///
/// Persists each display preference under a dedicated key and caches the
/// resolved [SharedPreferences] instance for subsequent reads and writes.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Wraps all platform channel
///   preference reads and writes in defensive `try`/`catch` blocks with
///   deterministic default fallbacks so storage faults never disrupt cockpit
///   display initialization or runtime theme switching.
///
/// ## 2. Invariants & Mathematical Properties
/// - Cached handle invariant: once `_getPrefs()` resolves, `_cachedPrefs` is
///   reused for all subsequent operations ($\text{getInstance calls} \le 1$ per
///   service instance).
/// - Round-trip serialization bijection on valid domain inputs for
///   [ThemeMode], scheme index, text scale, [Axis], and panel opacity.
///
/// ## 3. Preconditions
/// - Flutter platform channel bindings must be initialized before invoking
///   preference persistence methods in non-test environments.
///
/// ## 4. Postconditions
/// - `load*` methods always complete with a valid domain value (persisted or
///   fallback default); `save*` methods persist the value to
///   [SharedPreferences] or log any platform exception via [debugPrint].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ amortized per `load*` / `save*` call
///   after initial [SharedPreferences] cache hydration.
/// - **Space Complexity**: $\mathcal{O}(1)$ instance state (`_cachedPrefs`
///   reference and static key constants).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing keys, corrupted string values, or [SharedPreferences] platform
///   exceptions are caught, logged via [debugPrint], and safely degraded to
///   `ThemeMode.system`, `0`, `1.0`, `Axis.vertical`, and `0.85`.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/SharedPreferencesThemeService]
class SharedPreferencesThemeService implements ThemeService {
  static const _modeKey = 'theme_mode';
  static const _schemeKey = 'theme_scheme';
  static const _textScaleKey = 'text_scale';
  static const _layoutSplitAxisKey = 'layout_split_axis';
  static const _panelOpacityKey = 'panel_opacity';

  SharedPreferences? _cachedPrefs;

  Future<SharedPreferences> _getPrefs() async {
    _cachedPrefs ??= await SharedPreferences.getInstance();
    return _cachedPrefs!;
  }

  /// Reads the theme-mode string; unknown values fall back to system.
  @override
  Future<ThemeMode> loadThemeMode() async {
    try {
      final prefs = await _getPrefs();
      final value = prefs.getString(_modeKey);
      switch (value) {
        case 'light': return ThemeMode.light;
        case 'dark': return ThemeMode.dark;
        default: return ThemeMode.system;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in loadThemeMode: $e\n$stackTrace');
      return ThemeMode.system;
    }
  }

  /// Writes a "light" / "dark" / "system" string.
  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await _getPrefs();
      final value = themeMode == ThemeMode.light ? 'light'
          : themeMode == ThemeMode.dark ? 'dark'
          : 'system';
      await prefs.setString(_modeKey, value);
    } catch (e, stackTrace) {
      debugPrint('Error in saveThemeMode: $e\n$stackTrace');
    }
  }

  /// Reads an integer index; returns `0` when absent.
  @override
  Future<int> loadThemeScheme() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getInt(_schemeKey) ?? 0;
    } catch (e, stackTrace) {
      debugPrint('Error in loadThemeScheme: $e\n$stackTrace');
      return 0;
    }
  }

  /// Persists the scheme [index] as an integer.
  @override
  Future<void> saveThemeScheme(int index) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setInt(_schemeKey, index);
    } catch (e, stackTrace) {
      debugPrint('Error in saveThemeScheme: $e\n$stackTrace');
    }
  }

  /// Reads a double; returns `1.0` when absent.
  @override
  Future<double> loadTextScale() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getDouble(_textScaleKey) ?? 1.0;
    } catch (e, stackTrace) {
      debugPrint('Error in loadTextScale: $e\n$stackTrace');
      return 1.0;
    }
  }

  /// Persists the [scale] as a double.
  @override
  Future<void> saveTextScale(double scale) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setDouble(_textScaleKey, scale);
    } catch (e, stackTrace) {
      debugPrint('Error in saveTextScale: $e\n$stackTrace');
    }
  }

  /// Reads the workspace split axis string; unknown/invalid values fall back to horizontal.
  @override
  Future<Axis> loadLayoutSplitAxis() async {
    try {
      final prefs = await _getPrefs();
      final value = prefs.getString(_layoutSplitAxisKey);
      switch (value) {
        case 'vertical':
          return Axis.vertical;
        case 'horizontal':
          return Axis.horizontal;
        default:
          return Axis.vertical;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in loadLayoutSplitAxis: $e\n$stackTrace');
      return Axis.vertical;
    }
  }

  /// Writes a "horizontal" or "vertical" string.
  @override
  Future<void> saveLayoutSplitAxis(Axis axis) async {
    try {
      final prefs = await _getPrefs();
      final value = axis == Axis.vertical ? 'vertical' : 'horizontal';
      await prefs.setString(_layoutSplitAxisKey, value);
    } catch (e, stackTrace) {
      debugPrint('Error in saveLayoutSplitAxis: $e\n$stackTrace');
    }
  }

  @override
  Future<double> loadPanelOpacity() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getDouble(_panelOpacityKey) ?? 0.85;
    } catch (e, stackTrace) {
      debugPrint('Error in loadPanelOpacity: $e\n$stackTrace');
      return 0.85;
    }
  }

  @override
  Future<void> savePanelOpacity(double opacity) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setDouble(_panelOpacityKey, opacity);
    } catch (e, stackTrace) {
      debugPrint('Error in savePanelOpacity: $e\n$stackTrace');
    }
  }
}
