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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::loadThemeMode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::loadThemeMode` (declaration #2) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ThemeService::loadThemeMode` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<ThemeMode>` from `ThemeService::loadThemeMode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadThemeMode)) bounded over input/member dimension of `ThemeService::loadThemeMode`.
  /// - Space Complexity: O(K(loadThemeMode)) bounded auxiliary memory for `ThemeService::loadThemeMode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::loadThemeMode` (`Future<ThemeMode>`).
  /// - State: Maintains consistent state invariants across `ThemeService::loadThemeMode` without partial mutation on error.
  /// - Action: Executes `ThemeService::loadThemeMode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::loadThemeMode` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-LOADTHEMEMODE] | SysML v2: ActionDef(ThemeService::loadThemeMode)
  Future<ThemeMode> loadThemeMode();

  /// Persists [themeMode] so it survives app restarts.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::saveThemeMode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::saveThemeMode` (declaration #3) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `themeMode: ThemeMode` must satisfy domain and type-safety constraints prior to invoking `ThemeService::saveThemeMode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `ThemeService::saveThemeMode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(themeMode)) bounded over input/member dimension of `ThemeService::saveThemeMode`.
  /// - Space Complexity: O(N(themeMode)) bounded auxiliary memory for `ThemeService::saveThemeMode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::saveThemeMode` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `ThemeService::saveThemeMode` without partial mutation on error.
  /// - Action: Executes `ThemeService::saveThemeMode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::saveThemeMode` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-SAVETHEMEMODE] | SysML v2: ActionDef(ThemeService::saveThemeMode)
  Future<void> saveThemeMode(ThemeMode themeMode);

  /// Loads the persisted colour-scheme index; defaults to `0`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::loadThemeScheme` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::loadThemeScheme` (declaration #4) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ThemeService::loadThemeScheme` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<int>` from `ThemeService::loadThemeScheme` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadThemeScheme)) bounded over input/member dimension of `ThemeService::loadThemeScheme`.
  /// - Space Complexity: O(K(loadThemeScheme)) bounded auxiliary memory for `ThemeService::loadThemeScheme`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::loadThemeScheme` (`Future<int>`).
  /// - State: Maintains consistent state invariants across `ThemeService::loadThemeScheme` without partial mutation on error.
  /// - Action: Executes `ThemeService::loadThemeScheme` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::loadThemeScheme` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-LOADTHEMESCHEME] | SysML v2: ActionDef(ThemeService::loadThemeScheme)
  Future<int> loadThemeScheme();

  /// Persists the colour-scheme [index] so it survives app restarts.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::saveThemeScheme` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::saveThemeScheme` (declaration #5) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `index: int` must satisfy domain and type-safety constraints prior to invoking `ThemeService::saveThemeScheme`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `ThemeService::saveThemeScheme` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(index)) bounded over input/member dimension of `ThemeService::saveThemeScheme`.
  /// - Space Complexity: O(N(index)) bounded auxiliary memory for `ThemeService::saveThemeScheme`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::saveThemeScheme` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `ThemeService::saveThemeScheme` without partial mutation on error.
  /// - Action: Executes `ThemeService::saveThemeScheme` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::saveThemeScheme` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-SAVETHEMESCHEME] | SysML v2: ActionDef(ThemeService::saveThemeScheme)
  Future<void> saveThemeScheme(int index);

  /// Loads the persisted text scale factor; defaults to `1.0`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::loadTextScale` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::loadTextScale` (declaration #6) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ThemeService::loadTextScale` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<double>` from `ThemeService::loadTextScale` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadTextScale)) bounded over input/member dimension of `ThemeService::loadTextScale`.
  /// - Space Complexity: O(K(loadTextScale)) bounded auxiliary memory for `ThemeService::loadTextScale`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::loadTextScale` (`Future<double>`).
  /// - State: Maintains consistent state invariants across `ThemeService::loadTextScale` without partial mutation on error.
  /// - Action: Executes `ThemeService::loadTextScale` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::loadTextScale` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-LOADTEXTSCALE] | SysML v2: ActionDef(ThemeService::loadTextScale)
  Future<double> loadTextScale();

  /// Persists the text [scale] factor so it survives app restarts.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::saveTextScale` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::saveTextScale` (declaration #7) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `scale: double` must satisfy domain and type-safety constraints prior to invoking `ThemeService::saveTextScale`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `ThemeService::saveTextScale` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(scale)) bounded over input/member dimension of `ThemeService::saveTextScale`.
  /// - Space Complexity: O(N(scale)) bounded auxiliary memory for `ThemeService::saveTextScale`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::saveTextScale` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `ThemeService::saveTextScale` without partial mutation on error.
  /// - Action: Executes `ThemeService::saveTextScale` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::saveTextScale` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-SAVETEXTSCALE] | SysML v2: ActionDef(ThemeService::saveTextScale)
  Future<void> saveTextScale(double scale);

  /// Loads the persisted workspace split axis orientation; defaults to
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::loadLayoutSplitAxis` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::loadLayoutSplitAxis` (declaration #8) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ThemeService::loadLayoutSplitAxis` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Axis>` from `ThemeService::loadLayoutSplitAxis` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadLayoutSplitAxis)) bounded over input/member dimension of `ThemeService::loadLayoutSplitAxis`.
  /// - Space Complexity: O(K(loadLayoutSplitAxis)) bounded auxiliary memory for `ThemeService::loadLayoutSplitAxis`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::loadLayoutSplitAxis` (`Future<Axis>`).
  /// - State: Maintains consistent state invariants across `ThemeService::loadLayoutSplitAxis` without partial mutation on error.
  /// - Action: Executes `ThemeService::loadLayoutSplitAxis` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::loadLayoutSplitAxis` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-LOADLAYOUTSPLITAXIS] | SysML v2: ActionDef(ThemeService::loadLayoutSplitAxis)
  Future<Axis> loadLayoutSplitAxis();

  /// Persists [axis] so it survives app restarts.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::saveLayoutSplitAxis` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::saveLayoutSplitAxis` (declaration #9) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `axis: Axis` must satisfy domain and type-safety constraints prior to invoking `ThemeService::saveLayoutSplitAxis`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `ThemeService::saveLayoutSplitAxis` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(axis)) bounded over input/member dimension of `ThemeService::saveLayoutSplitAxis`.
  /// - Space Complexity: O(N(axis)) bounded auxiliary memory for `ThemeService::saveLayoutSplitAxis`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::saveLayoutSplitAxis` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `ThemeService::saveLayoutSplitAxis` without partial mutation on error.
  /// - Action: Executes `ThemeService::saveLayoutSplitAxis` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::saveLayoutSplitAxis` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-SAVELAYOUTSPLITAXIS] | SysML v2: ActionDef(ThemeService::saveLayoutSplitAxis)
  Future<void> saveLayoutSplitAxis(Axis axis);

  /// Loads the persisted panel opacity; defaults to `0.85`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::loadPanelOpacity` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::loadPanelOpacity` (declaration #10) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `ThemeService::loadPanelOpacity` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<double>` from `ThemeService::loadPanelOpacity` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadPanelOpacity)) bounded over input/member dimension of `ThemeService::loadPanelOpacity`.
  /// - Space Complexity: O(K(loadPanelOpacity)) bounded auxiliary memory for `ThemeService::loadPanelOpacity`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::loadPanelOpacity` (`Future<double>`).
  /// - State: Maintains consistent state invariants across `ThemeService::loadPanelOpacity` without partial mutation on error.
  /// - Action: Executes `ThemeService::loadPanelOpacity` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::loadPanelOpacity` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-LOADPANELOPACITY] | SysML v2: ActionDef(ThemeService::loadPanelOpacity)
  Future<double> loadPanelOpacity();

  /// Persists the panel [opacity] so it survives app restarts.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `ThemeService::savePanelOpacity` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `ThemeService::savePanelOpacity` (declaration #11) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `opacity: double` must satisfy domain and type-safety constraints prior to invoking `ThemeService::savePanelOpacity`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `ThemeService::savePanelOpacity` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(opacity)) bounded over input/member dimension of `ThemeService::savePanelOpacity`.
  /// - Space Complexity: O(N(opacity)) bounded auxiliary memory for `ThemeService::savePanelOpacity`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `ThemeService::savePanelOpacity` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `ThemeService::savePanelOpacity` without partial mutation on error.
  /// - Action: Executes `ThemeService::savePanelOpacity` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `ThemeService::savePanelOpacity` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-THEMESERVICE-SAVEPANELOPACITY] | SysML v2: ActionDef(ThemeService::savePanelOpacity)
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

  /// Executes deterministic method `SharedPreferencesThemeService::_getPrefs` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::_getPrefs` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::_getPrefs` (declaration #13) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SharedPreferencesThemeService::_getPrefs` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<SharedPreferences>` from `SharedPreferencesThemeService::_getPrefs` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_getPrefs)) bounded over input/member dimension of `SharedPreferencesThemeService::_getPrefs`.
  /// - Space Complexity: O(K(_getPrefs)) bounded auxiliary memory for `SharedPreferencesThemeService::_getPrefs`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::_getPrefs` (`Future<SharedPreferences>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::_getPrefs` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::_getPrefs` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::_getPrefs` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-GETPREFS] | SysML v2: ActionDef(SharedPreferencesThemeService::_getPrefs)
  Future<SharedPreferences> _getPrefs() async {
    _cachedPrefs ??= await SharedPreferences.getInstance();
    return _cachedPrefs!;
  }

  /// Reads the theme-mode string; unknown values fall back to system.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::loadThemeMode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::loadThemeMode` (declaration #14) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SharedPreferencesThemeService::loadThemeMode` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<ThemeMode>` from `SharedPreferencesThemeService::loadThemeMode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadThemeMode)) bounded over input/member dimension of `SharedPreferencesThemeService::loadThemeMode`.
  /// - Space Complexity: O(K(loadThemeMode)) bounded auxiliary memory for `SharedPreferencesThemeService::loadThemeMode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::loadThemeMode` (`Future<ThemeMode>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::loadThemeMode` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::loadThemeMode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::loadThemeMode` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-LOADTHEMEMODE] | SysML v2: ActionDef(SharedPreferencesThemeService::loadThemeMode)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::saveThemeMode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::saveThemeMode` (declaration #15) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `themeMode: ThemeMode` must satisfy domain and type-safety constraints prior to invoking `SharedPreferencesThemeService::saveThemeMode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `SharedPreferencesThemeService::saveThemeMode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(themeMode)) bounded over input/member dimension of `SharedPreferencesThemeService::saveThemeMode`.
  /// - Space Complexity: O(N(themeMode)) bounded auxiliary memory for `SharedPreferencesThemeService::saveThemeMode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::saveThemeMode` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::saveThemeMode` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::saveThemeMode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::saveThemeMode` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-SAVETHEMEMODE] | SysML v2: ActionDef(SharedPreferencesThemeService::saveThemeMode)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::loadThemeScheme` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::loadThemeScheme` (declaration #16) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SharedPreferencesThemeService::loadThemeScheme` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<int>` from `SharedPreferencesThemeService::loadThemeScheme` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadThemeScheme)) bounded over input/member dimension of `SharedPreferencesThemeService::loadThemeScheme`.
  /// - Space Complexity: O(K(loadThemeScheme)) bounded auxiliary memory for `SharedPreferencesThemeService::loadThemeScheme`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::loadThemeScheme` (`Future<int>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::loadThemeScheme` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::loadThemeScheme` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::loadThemeScheme` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-LOADTHEMESCHEME] | SysML v2: ActionDef(SharedPreferencesThemeService::loadThemeScheme)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::saveThemeScheme` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::saveThemeScheme` (declaration #17) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `index: int` must satisfy domain and type-safety constraints prior to invoking `SharedPreferencesThemeService::saveThemeScheme`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `SharedPreferencesThemeService::saveThemeScheme` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(index)) bounded over input/member dimension of `SharedPreferencesThemeService::saveThemeScheme`.
  /// - Space Complexity: O(N(index)) bounded auxiliary memory for `SharedPreferencesThemeService::saveThemeScheme`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::saveThemeScheme` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::saveThemeScheme` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::saveThemeScheme` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::saveThemeScheme` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-SAVETHEMESCHEME] | SysML v2: ActionDef(SharedPreferencesThemeService::saveThemeScheme)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::loadTextScale` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::loadTextScale` (declaration #18) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SharedPreferencesThemeService::loadTextScale` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<double>` from `SharedPreferencesThemeService::loadTextScale` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadTextScale)) bounded over input/member dimension of `SharedPreferencesThemeService::loadTextScale`.
  /// - Space Complexity: O(K(loadTextScale)) bounded auxiliary memory for `SharedPreferencesThemeService::loadTextScale`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::loadTextScale` (`Future<double>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::loadTextScale` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::loadTextScale` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::loadTextScale` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-LOADTEXTSCALE] | SysML v2: ActionDef(SharedPreferencesThemeService::loadTextScale)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::saveTextScale` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::saveTextScale` (declaration #19) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `scale: double` must satisfy domain and type-safety constraints prior to invoking `SharedPreferencesThemeService::saveTextScale`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `SharedPreferencesThemeService::saveTextScale` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(scale)) bounded over input/member dimension of `SharedPreferencesThemeService::saveTextScale`.
  /// - Space Complexity: O(N(scale)) bounded auxiliary memory for `SharedPreferencesThemeService::saveTextScale`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::saveTextScale` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::saveTextScale` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::saveTextScale` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::saveTextScale` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-SAVETEXTSCALE] | SysML v2: ActionDef(SharedPreferencesThemeService::saveTextScale)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::loadLayoutSplitAxis` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::loadLayoutSplitAxis` (declaration #20) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SharedPreferencesThemeService::loadLayoutSplitAxis` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<Axis>` from `SharedPreferencesThemeService::loadLayoutSplitAxis` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadLayoutSplitAxis)) bounded over input/member dimension of `SharedPreferencesThemeService::loadLayoutSplitAxis`.
  /// - Space Complexity: O(K(loadLayoutSplitAxis)) bounded auxiliary memory for `SharedPreferencesThemeService::loadLayoutSplitAxis`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::loadLayoutSplitAxis` (`Future<Axis>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::loadLayoutSplitAxis` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::loadLayoutSplitAxis` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::loadLayoutSplitAxis` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-LOADLAYOUTSPLITAXIS] | SysML v2: ActionDef(SharedPreferencesThemeService::loadLayoutSplitAxis)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::saveLayoutSplitAxis` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::saveLayoutSplitAxis` (declaration #21) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `axis: Axis` must satisfy domain and type-safety constraints prior to invoking `SharedPreferencesThemeService::saveLayoutSplitAxis`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `SharedPreferencesThemeService::saveLayoutSplitAxis` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(axis)) bounded over input/member dimension of `SharedPreferencesThemeService::saveLayoutSplitAxis`.
  /// - Space Complexity: O(N(axis)) bounded auxiliary memory for `SharedPreferencesThemeService::saveLayoutSplitAxis`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::saveLayoutSplitAxis` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::saveLayoutSplitAxis` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::saveLayoutSplitAxis` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::saveLayoutSplitAxis` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-SAVELAYOUTSPLITAXIS] | SysML v2: ActionDef(SharedPreferencesThemeService::saveLayoutSplitAxis)
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

  /// Executes deterministic method `SharedPreferencesThemeService::loadPanelOpacity` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::loadPanelOpacity` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::loadPanelOpacity` (declaration #22) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `SharedPreferencesThemeService::loadPanelOpacity` in `THEME-THEME-SERVICE`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<double>` from `SharedPreferencesThemeService::loadPanelOpacity` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(loadPanelOpacity)) bounded over input/member dimension of `SharedPreferencesThemeService::loadPanelOpacity`.
  /// - Space Complexity: O(K(loadPanelOpacity)) bounded auxiliary memory for `SharedPreferencesThemeService::loadPanelOpacity`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::loadPanelOpacity` (`Future<double>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::loadPanelOpacity` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::loadPanelOpacity` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::loadPanelOpacity` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-LOADPANELOPACITY] | SysML v2: ActionDef(SharedPreferencesThemeService::loadPanelOpacity)
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

  /// Executes deterministic method `SharedPreferencesThemeService::savePanelOpacity` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `SharedPreferencesThemeService::savePanelOpacity` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/core/theme/theme_service.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `SharedPreferencesThemeService::savePanelOpacity` (declaration #23) within `THEME-THEME-SERVICE`.
  ///
  /// ## 3. Preconditions
  /// - `opacity: double` must satisfy domain and type-safety constraints prior to invoking `SharedPreferencesThemeService::savePanelOpacity`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `SharedPreferencesThemeService::savePanelOpacity` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(opacity)) bounded over input/member dimension of `SharedPreferencesThemeService::savePanelOpacity`.
  /// - Space Complexity: O(N(opacity)) bounded auxiliary memory for `SharedPreferencesThemeService::savePanelOpacity`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `SharedPreferencesThemeService::savePanelOpacity` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `SharedPreferencesThemeService::savePanelOpacity` without partial mutation on error.
  /// - Action: Executes `SharedPreferencesThemeService::savePanelOpacity` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `SharedPreferencesThemeService::savePanelOpacity` (`THEME-THEME-SERVICE`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-THEME-THEME-SERVICE-SHAREDPREFERENCESTHEMESERVICE-SAVEPANELOPACITY] | SysML v2: ActionDef(SharedPreferencesThemeService::savePanelOpacity)
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
