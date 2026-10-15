import 'dart:async';
import 'package:flutter/material.dart';
import 'theme_service.dart';

/// Manages a clamped text scale factor and persists it via [ThemeService].
///
/// Exposes a [ChangeNotifier] interface for reactive UI updates. The
/// scale is clamped to the range [0.7, 1.5] on every write so that text
/// never becomes unreadable at either extreme.
///
/// **State**: caches the current scale in memory and persists through
/// [ThemeService] on every [setScale] call. Persistence failures are
/// logged via [debugPrint] but never thrown.
///
/// **Edge cases**: a null [ThemeService] skips persistence entirely;
/// values outside [0.7, 1.5] are silently clamped.
/// Controls text scale factor state.
/// Realises: [Feat-10/TextScalerController]
class TextScalerController extends ChangeNotifier {
  /// Member documentation.
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
