import 'dart:async';
import 'package:flutter/material.dart';
import 'theme_service.dart';

/// Reactive typography scale controller that enforces bounded text scaling and
/// tabular numeral metrics across cockpit display surfaces.
///
/// Exposes a [ChangeNotifier] state container that clamps the active text scale
/// factor to $[0.7, 1.5]$, applies mandatory `tabularFigures` font features to
/// prevent horizontal layout jitter during numeric telemetry updates, and
/// persists user scale changes asynchronously through [ThemeService].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Prevents unreadable extreme font
///   scaling (clamping strictly to $[0.7, 1.5]$) and enforces fixed-width
///   tabular glyph metrics (`tnum`) so rapidly changing numeric readouts never
///   induce horizontal pixel jitter on 60 FPS cockpit displays.
///
/// ## 2. Invariants & Mathematical Properties
/// - Scale clamping invariant:
///   $\forall v \in \mathbb{R},\ \text{setScale}(v) \implies \text{scale} = \min(1.5, \max(0.7, v)) \in [0.7, 1.5]$.
/// - Affine font size scaling:
///   $\text{scaleStyle}(s).\text{fontSize} = (s.\text{fontSize} \ ?? \ 12.0) \times \text{scale}$.
/// - Monotonic write counter (`_writeCount`) prevents stale asynchronous [load]
///   completions from overwriting a newer explicit [setScale] mutation.
///
/// ## 3. Preconditions
/// - Optional [ThemeService] may be injected at construction for persistence;
///   when `null`, scale state operates purely in memory.
///
/// ## 4. Postconditions
/// - [setScale] clamps `_scale`, increments `_writeCount`, notifies active
///   listeners synchronously if undisposed, and schedules non-blocking
///   persistence via [ThemeService.saveTextScale].
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(L)$ per [setScale] or [load] notification
///   for $L$ registered listeners; $\mathcal{O}(1)$ for [scaleStyle] and preset
///   style getters.
/// - **Space Complexity**: $\mathcal{O}(1)$ scalar controller fields and static
///   [TextStyle] constants.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Out-of-range inputs to [setScale] are deterministically clamped to
///   $[0.7, 1.5]$.
/// - Asynchronous persistence failures in [ThemeService.saveTextScale] are
///   caught and logged via [debugPrint] without propagating unhandled futures.
/// - Calling [notifyListeners] after [dispose] is safely ignored.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/TextScalerController]
class TextScalerController extends ChangeNotifier {
  /// Creates a [TextScalerController] optionally backed by [_themeService] for persistence.
  TextScalerController([this._themeService]);
  final ThemeService? _themeService;
  double _scale = 1.0;
  bool _disposed = false;
  bool _explicitlySet = false;
  int _writeCount = 0;

  /// Enforces fixed-width tabular glyphs so high-frequency numeric updates
  /// render with zero horizontal pixel jitter.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  /// Uppercase-tracked section group header style (`letterSpacing: 1.4`,
  /// `fontSize: 11.0`, `fontWeight: FontWeight.w600`).
  static const TextStyle sectionGroup = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
    fontFeatures: tabularFigures,
  );

  /// Numeric telemetry readout style with mandatory tabular figures.
  static const TextStyle numericTelemetry = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    fontFeatures: tabularFigures,
  );

  /// Spatial and geodetic coordinate readout style with mandatory tabular figures.
  static const TextStyle coordinate = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    fontFeatures: tabularFigures,
  );

  /// High-density table cell style with mandatory tabular figures.
  static const TextStyle tableCell = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFeatures: tabularFigures,
  );

  /// Compact tactical status badge style with mandatory tabular figures.
  static const TextStyle badge = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    fontFeatures: tabularFigures,
  );

  /// Formats a section header label in uppercase for `sectionGroup` rendering.
  static String formatSectionGroup(String label) => label.toUpperCase();

  /// The current text scale factor, always in [0.7, 1.5].
  double get scale => _scale;

  /// Scales [style] by the current [scale] factor while enforcing
  /// [tabularFigures] to prevent horizontal pixel jitter.
  TextStyle scaleStyle(TextStyle style) {
    final baseFontSize = style.fontSize ?? 12.0;
    return style.copyWith(
      fontSize: baseFontSize * _scale,
      fontFeatures: tabularFigures,
    );
  }

  /// Scaled `sectionGroup` header text style.
  TextStyle get scaledSectionGroup => scaleStyle(sectionGroup);

  /// Scaled numeric telemetry text style.
  TextStyle get scaledNumericTelemetry => scaleStyle(numericTelemetry);

  /// Scaled coordinate readout text style.
  TextStyle get scaledCoordinate => scaleStyle(coordinate);

  /// Scaled table cell text style.
  TextStyle get scaledTableCell => scaleStyle(tableCell);

  /// Scaled status badge text style.
  TextStyle get scaledBadge => scaleStyle(badge);

  /// Loads the persisted scale factor from [ThemeService].
  ///
  /// Returns `1.0` when no value has been saved or when the service is
  /// null. Fires `notifyListeners()` after loading so the UI refreshes.
  Future<void> load() async {
    if (_explicitlySet) return;
    final currentWrite = _writeCount;
    final val = await _themeService?.loadTextScale() ?? 1.0;
    if (_disposed) return;
    if (_explicitlySet || _writeCount != currentWrite) return;
    _scale = val;
    notifyListeners();
  }

  /// Sets the scale factor (clamped to [0.7, 1.5]) and persists it.
  ///
  /// Notifies listeners immediately and schedules persistence
  /// asynchronously. Persistence errors are caught and logged via
  /// [debugPrint] -- they never propagate to the caller.
  void setScale(double value) {
    _explicitlySet = true;
    _writeCount++;
    _scale = value.clamp(0.7, 1.5);
    notifyListeners();
    unawaited(_themeService?.saveTextScale(_scale).catchError((Object e) {
      debugPrint('Failed to save text scale: $e');
    }));
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
