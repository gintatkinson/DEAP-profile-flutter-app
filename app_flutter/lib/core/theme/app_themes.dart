import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'text_scaler.dart';

/// Reusable ARINC 661 Cockpit Display System (CDS) outlined border that
/// renders a crisp `1px` slate hairline border with `6px` corner L-bracket
/// reticle ticks on active tactical panels and cards.
///
/// Realises: [Feat-10/Arinc661ReticleBorder]
@immutable
class Arinc661ReticleBorder extends OutlinedBorder {
  /// Creates an [Arinc661ReticleBorder] with a `1px` hairline and `6px`
  /// corner L-bracket reticle ticks.
  const Arinc661ReticleBorder({
    super.side = const BorderSide(
      color: AppThemes.hairlineBorderColor,
      width: AppThemes.borderWidth,
    ),
    this.hairlineColor = AppThemes.hairlineBorderColor,
    this.reticleColor = AppThemes.activeReticleCyan,
    this.hairlineWidth = AppThemes.borderWidth,
    this.reticleLength = AppThemes.reticleTickLength,
    this.reticleStrokeWidth = 1.5,
    this.borderRadius = AppThemes.borderRadius,
    this.isActive = true,
  });

  /// Colour of the continuous `1px` perimeter hairline (`#1E293B` by default).
  final Color hairlineColor;

  /// Colour of the `6px` corner L-bracket reticle ticks (`#00D4FF` by default).
  final Color reticleColor;

  /// Stroke width of the continuous perimeter hairline (`1.0` by default).
  final double hairlineWidth;

  /// Arm length of each corner L-bracket reticle tick (`6.0` by default).
  final double reticleLength;

  /// Stroke width of each corner L-bracket reticle tick (`1.5` by default).
  final double reticleStrokeWidth;

  /// Corner radius of the underlying panel border (`2.0` by default).
  final double borderRadius;

  /// Whether corner L-bracket reticle ticks are rendered for an active panel.
  final bool isActive;

  @override
  Arinc661ReticleBorder copyWith({
    BorderSide? side,
    Color? hairlineColor,
    Color? reticleColor,
    double? hairlineWidth,
    double? reticleLength,
    double? reticleStrokeWidth,
    double? borderRadius,
    bool? isActive,
  }) {
    return Arinc661ReticleBorder(
      side: side ?? this.side,
      hairlineColor: hairlineColor ?? this.hairlineColor,
      reticleColor: reticleColor ?? this.reticleColor,
      hairlineWidth: hairlineWidth ?? this.hairlineWidth,
      reticleLength: reticleLength ?? this.reticleLength,
      reticleStrokeWidth: reticleStrokeWidth ?? this.reticleStrokeWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return Arinc661ReticleBorder(
      side: side.scale(t),
      hairlineColor: hairlineColor,
      reticleColor: reticleColor,
      hairlineWidth: hairlineWidth * t,
      reticleLength: reticleLength * t,
      reticleStrokeWidth: reticleStrokeWidth * t,
      borderRadius: borderRadius * t,
      isActive: isActive,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    ).deflate(hairlineWidth);
    return Path()..addRRect(rrect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );
    return Path()..addRRect(rrect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;

    final effectiveHairlineWidth = hairlineWidth > 0 ? hairlineWidth : side.width;
    if (effectiveHairlineWidth > 0 && side.style != BorderStyle.none) {
      final hairlinePaint = Paint()
        ..color = hairlineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = effectiveHairlineWidth;
      final insetRect = rect.deflate(effectiveHairlineWidth / 2.0);
      final rrect = RRect.fromRectAndRadius(
        insetRect,
        Radius.circular(borderRadius),
      );
      canvas.drawRRect(rrect, hairlinePaint);
    }

    if (!isActive || reticleLength <= 0) return;

    final tickLen = math.min(
      reticleLength,
      math.min(rect.width, rect.height) / 2.0,
    );
    if (tickLen <= 0) return;

    final reticlePaint = Paint()
      ..color = reticleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = reticleStrokeWidth
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    final path = Path()
      // Top-left L-bracket
      ..moveTo(rect.left, rect.top + tickLen)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + tickLen, rect.top)
      // Top-right L-bracket
      ..moveTo(rect.right - tickLen, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + tickLen)
      // Bottom-left L-bracket
      ..moveTo(rect.left, rect.bottom - tickLen)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left + tickLen, rect.bottom)
      // Bottom-right L-bracket
      ..moveTo(rect.right - tickLen, rect.bottom)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right, rect.bottom - tickLen);

    canvas.drawPath(path, reticlePaint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Arinc661ReticleBorder) return false;
    return other.side == side &&
        other.hairlineColor == hairlineColor &&
        other.reticleColor == reticleColor &&
        other.hairlineWidth == hairlineWidth &&
        other.reticleLength == reticleLength &&
        other.reticleStrokeWidth == reticleStrokeWidth &&
        other.borderRadius == borderRadius &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(
        side,
        hairlineColor,
        reticleColor,
        hairlineWidth,
        reticleLength,
        reticleStrokeWidth,
        borderRadius,
        isActive,
      );
}

/// Central registry of colour schemes and [ThemeData] factories.
///
/// Keeps all Material/Cupertino theming in one place so that light/dark
/// variants stay consistent. Use [light] / [dark] to build themes; use
/// [customSchemes] to offer scheme selection in a settings UI. There is no
/// mutable state -- the class is a static namespace.
///
/// **Edge cases**: passing `null` for [custom] falls back to the first
/// Manages application themes and color palettes.
/// Realises: [Feat-10/AppThemes]
class AppThemes {
  AppThemes._();

  /// Deep cockpit obsidian canvas (`#070A0F`).
  static const Color obsidianCanvas = Color(0xFF070A0F);

  /// Primary panel surface (`#0C1118`).
  static const Color primaryPanelSurface = Color(0xFF0C1118);

  /// Elevated HUD surface (`#141D2B`).
  static const Color elevatedHudSurface = Color(0xFF141D2B);

  /// Slate hairline border (`#1E293B`).
  static const Color hairlineBorderColor = Color(0xFF1E293B);

  /// Active reticle cyan (`#00D4FF`).
  static const Color activeReticleCyan = Color(0xFF00D4FF);

  /// Hostile / warning crimson (`#FF334B`).
  static const Color hostileWarningCrimson = Color(0xFFFF334B);

  /// Caution / margin amber (`#FFB020`).
  static const Color cautionMarginAmber = Color(0xFFFFB020);

  /// Verified / nominal emerald (`#00E676`).
  static const Color verifiedNominalEmerald = Color(0xFF00E676);

  /// Default ARINC 661 CDS corner border radius (`2.0`).
  static const double borderRadius = 2.0;

  /// Default ARINC 661 CDS hairline border width (`1.0`).
  static const double borderWidth = 1.0;

  /// Default ARINC 661 CDS corner L-bracket reticle tick length (`6.0`).
  static const double reticleTickLength = 6.0;

  /// Tabular figures font feature list preventing horizontal pixel jitter.
  static const List<FontFeature> tabularFigures =
      TextScalerController.tabularFigures;

  /// Uppercase-tracked section group header style (`letterSpacing: 1.4`,
  /// `fontSize: 11.0`, `fontWeight: FontWeight.w600`).
  static const TextStyle sectionGroup = TextScalerController.sectionGroup;

  /// Numeric telemetry text style with mandatory tabular figures.
  static const TextStyle telemetryTextStyle =
      TextScalerController.numericTelemetry;

  /// Coordinate readout text style with mandatory tabular figures.
  static const TextStyle coordinateTextStyle = TextScalerController.coordinate;

  /// High-density table cell text style with mandatory tabular figures.
  static const TextStyle tableCellTextStyle = TextScalerController.tableCell;

  /// Tactical status badge text style with mandatory tabular figures.
  static const TextStyle badgeTextStyle = TextScalerController.badge;

  /// Builds a reusable [ShapeDecoration] using [Arinc661ReticleBorder] for
  /// active or inactive tactical panels and cards.
  static ShapeDecoration reticleDecoration({
    Color? backgroundColor,
    Color hairlineColor = hairlineBorderColor,
    Color reticleColor = activeReticleCyan,
    double hairlineWidth = borderWidth,
    double reticleLength = reticleTickLength,
    double borderRadius = AppThemes.borderRadius,
    bool isActive = true,
    List<BoxShadow>? shadows,
  }) {
    return ShapeDecoration(
      color: backgroundColor ?? primaryPanelSurface,
      shadows: shadows,
      shape: Arinc661ReticleBorder(
        side: BorderSide(color: hairlineColor, width: hairlineWidth),
        hairlineColor: hairlineColor,
        reticleColor: reticleColor,
        hairlineWidth: hairlineWidth,
        reticleLength: reticleLength,
        borderRadius: borderRadius,
        isActive: isActive,
      ),
    );
  }

  /// Built-in colour schemes exposed for user selection.
  ///
  /// Each entry defines light + dark palettes. The list is fixed at
  /// compile time. Index 0 (Greys) is the fallback when the persisted
  /// index is out of range. An empty list would cause a runtime bounds
  /// error -- but it is defined as a non-empty literal.
  static const List<FlexSchemeData> customSchemes = [
    FlexSchemeData(
      name: 'Greys',
      description: 'ARINC 661 CDS obsidian tactical theme',
      light: FlexSchemeColor(
        primary: Color(0xFF5C5C5C),
        secondary: Color(0xFF9E9E9E),
        tertiary: Color(0xFFBDBDBD),
        appBarColor: Color(0xFF424242),
        error: Color(0xFFB3261E),
      ),
      dark: FlexSchemeColor(
        primary: activeReticleCyan,
        secondary: verifiedNominalEmerald,
        tertiary: cautionMarginAmber,
        appBarColor: primaryPanelSurface,
        error: hostileWarningCrimson,
      ),
    ),
    FlexSchemeData(
      name: 'Blue Whale',
      description: 'Deep blue ocean theme',
      light: FlexSchemeColor(
        primary: Color(0xFF1A73E0 + 8),
        secondary: Color(0xFF4FC3F7),
        tertiary: Color(0xFF81D4FA),
        appBarColor: Color(0xFF1565C0),
        error: Color(0xFFB3261E),
      ),
      dark: FlexSchemeColor(
        primary: activeReticleCyan,
        secondary: Color(0xFF4FC3F7),
        tertiary: cautionMarginAmber,
        appBarColor: primaryPanelSurface,
        error: hostileWarningCrimson,
      ),
    ),
    FlexSchemeData(
      name: 'Mandy Red',
      description: 'Bold red accent theme',
      light: FlexSchemeColor(
        primary: Color(0xFFD32F2F),
        secondary: Color(0xFFE57373),
        tertiary: Color(0xFFFFCDD2),
        appBarColor: Color(0xFFB71C1C),
        error: Color(0xFFB3261E),
      ),
      dark: FlexSchemeColor(
        primary: hostileWarningCrimson,
        secondary: cautionMarginAmber,
        tertiary: activeReticleCyan,
        appBarColor: primaryPanelSurface,
        error: hostileWarningCrimson,
      ),
    ),
    FlexSchemeData(
      name: 'Wasabi',
      description: 'Fresh green theme',
      light: FlexSchemeColor(
        primary: Color(0xFF43A047),
        secondary: Color(0xFF81C784),
        tertiary: Color(0xFFA5D6A7),
        appBarColor: Color(0xFF2E7D32),
        error: Color(0xFFB3261E),
      ),
      dark: FlexSchemeColor(
        primary: verifiedNominalEmerald,
        secondary: activeReticleCyan,
        tertiary: cautionMarginAmber,
        appBarColor: primaryPanelSurface,
        error: hostileWarningCrimson,
      ),
    ),
    FlexSchemeData(
      name: 'Deep Purple',
      description: 'Rich purple theme',
      light: FlexSchemeColor(
        primary: Color(0xFF7B1FA2),
        secondary: Color(0xFFCE93D8),
        tertiary: Color(0xFFE1BEE7),
        appBarColor: Color(0xFF4A148C),
        error: Color(0xFFB3261E),
      ),
      dark: FlexSchemeColor(
        primary: Color(0xFFCE93D8),
        secondary: activeReticleCyan,
        tertiary: cautionMarginAmber,
        appBarColor: primaryPanelSurface,
        error: hostileWarningCrimson,
      ),
    ),
    FlexSchemeData(
      name: 'Material Baseline',
      description: 'Standard Material 3 baseline',
      light: FlexSchemeColor(
        primary: Color(0xFF6750A4),
        secondary: Color(0xFF625B71),
        tertiary: Color(0xFF7D5260),
        appBarColor: Color(0xFF6750A4),
        error: Color(0xFFB3261E),
      ),
      dark: FlexSchemeColor(
        primary: activeReticleCyan,
        secondary: verifiedNominalEmerald,
        tertiary: cautionMarginAmber,
        appBarColor: primaryPanelSurface,
        error: hostileWarningCrimson,
      ),
    ),
  ];

  static Map<String, dynamic> _tokens = {};

  static void _ensureLoaded() {
    if (_tokens.isNotEmpty) return;
    try {
      final file = File('assets/design-tokens.json');
      if (file.existsSync()) {
        final jsonStr = file.readAsStringSync();
        _tokens = jsonDecode(jsonStr) as Map<String, dynamic>;
        return;
      }
    } catch (_) {}
    try {
      final file = File('app_flutter/assets/design-tokens.json');
      if (file.existsSync()) {
        final jsonStr = file.readAsStringSync();
        _tokens = jsonDecode(jsonStr) as Map<String, dynamic>;
        return;
      }
    } catch (_) {}
  }

  /// Member documentation.
  static Future<void> load() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/design-tokens.json');
      _tokens = jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      _ensureLoaded();
    }
  }

  /// Member documentation.
  static void loadFromJson(String json) {
    _tokens = jsonDecode(json) as Map<String, dynamic>;
  }

  /// Member documentation.
  static dynamic resolveValue(dynamic value) {
    if (value is! String) return value;
    final match = RegExp(r'^\{(.+)\}$').firstMatch(value);
    if (match == null) return value;
    final path = match.group(1)!.split('.');
    dynamic current = _tokens;
    for (final part in path) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return value;
      }
    }
    if (current is Map && current.containsKey('\$value')) {
      return resolveValue(current['\$value']);
    }
    return current;
  }

  static dynamic _resolvePath(String path) {
    final parts = path.split('.');
    dynamic current = _tokens;
    for (final part in parts) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }
    if (current is Map && current.containsKey('\$value')) {
      return resolveValue(current['\$value']);
    }
    return current;
  }

  /// Member documentation.
  static double parseDimension(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    final s = value.toString().trim();
    if (s.endsWith('px')) {
      return double.tryParse(s.substring(0, s.length - 2)) ?? 0.0;
    }
    return double.tryParse(s) ?? 0.0;
  }

  /// Member documentation.
  static double getDimension(String path, [double defaultValue = 0.0]) {
    _ensureLoaded();
    final val = _resolvePath(path);
    if (val == null) return defaultValue;
    return parseDimension(val);
  }

  /// Member documentation.
  static String? getString(String path) {
    _ensureLoaded();
    final val = _resolvePath(path);
    return val?.toString();
  }

  /// Member documentation.
  static String? getFontFamily() {
    return getString('alias.typography.font-family') ?? getString('global.typography.font-family');
  }

  /// Member documentation.
  static VisualDensity getVisualDensity() {
    final scale = getString('alias.typography.scale') ?? getString('global.typography.scale');
    if (scale == 'high-density' || scale == 'compact') {
      return VisualDensity.compact;
    }
    return FlexColorScheme.comfortablePlatformDensity;
  }

  static TextStyle? _withTabular(TextStyle? style) {
    if (style == null) {
      return const TextStyle(fontFeatures: tabularFigures);
    }
    return style.copyWith(fontFeatures: tabularFigures);
  }

  static TextTheme _applyTacticalTypography(TextTheme base) {
    return base.copyWith(
      displayLarge: _withTabular(base.displayLarge),
      displayMedium: _withTabular(base.displayMedium),
      displaySmall: _withTabular(base.displaySmall),
      headlineLarge: _withTabular(base.headlineLarge),
      headlineMedium: _withTabular(base.headlineMedium),
      headlineSmall: _withTabular(base.headlineSmall),
      titleLarge: _withTabular(base.titleLarge),
      titleMedium: _withTabular(base.titleMedium),
      titleSmall: (base.titleSmall ?? const TextStyle()).copyWith(
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        fontFeatures: tabularFigures,
      ),
      bodyLarge: _withTabular(base.bodyLarge),
      bodyMedium: _withTabular(base.bodyMedium),
      bodySmall: _withTabular(base.bodySmall),
      labelLarge: _withTabular(base.labelLarge),
      labelMedium: _withTabular(base.labelMedium),
      labelSmall: (base.labelSmall ?? const TextStyle()).copyWith(
        fontSize: 10.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        fontFeatures: tabularFigures,
      ),
    );
  }

  /// Builds a light [ThemeData] from an optional custom scheme.
  ///
  /// When [custom] is null the first scheme (Greys) is used. Does not
  /// cache -- every call constructs a new [ThemeData].
  static ThemeData light({FlexSchemeData? custom}) {
    final data = custom ?? customSchemes[0];
    final base = FlexThemeData.light(
      colors: data.light,
      fontFamily: getFontFamily(),
      appBarStyle: FlexAppBarStyle.primary,
      appBarElevation: getDimension('alias.elevation.app-bar', 0.0),
      tabBarStyle: FlexTabBarStyle.forBackground,
      bottomAppBarElevation: getDimension('alias.elevation.bottom-app-bar', 0.0),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: _subThemes(inputAlpha: 13),
      visualDensity: getVisualDensity(),
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      useMaterial3: true,
    );
    return base.copyWith(
      textTheme: _applyTacticalTypography(base.textTheme),
      primaryTextTheme: _applyTacticalTypography(base.primaryTextTheme),
    );
  }

  /// Builds a dark [ThemeData] from an optional custom scheme.
  ///
  /// When [custom] is null the first scheme (Greys) is used. Does not
  /// cache -- every call constructs a new [ThemeData].
  static ThemeData dark({FlexSchemeData? custom}) {
    final data = custom ?? customSchemes[0];
    final base = FlexThemeData.dark(
      colors: data.dark,
      fontFamily: getFontFamily(),
      appBarStyle: FlexAppBarStyle.material,
      appBarElevation: getDimension('alias.elevation.app-bar', 0.0),
      tabBarStyle: FlexTabBarStyle.forBackground,
      bottomAppBarElevation: getDimension('alias.elevation.bottom-app-bar', 0.0),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 0,
      subThemesData: _subThemes(inputAlpha: 20),
      visualDensity: getVisualDensity(),
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: obsidianCanvas,
      canvasColor: obsidianCanvas,
      cardColor: primaryPanelSurface,
      dividerColor: hairlineBorderColor,
      colorScheme: base.colorScheme.copyWith(
        surface: primaryPanelSurface,
        surfaceContainerHighest: elevatedHudSurface,
        outline: hairlineBorderColor,
        outlineVariant: hairlineBorderColor,
        primary: data.dark.primary,
        secondary: data.dark.secondary,
        tertiary: data.dark.tertiary,
        error: hostileWarningCrimson,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: primaryPanelSurface,
        elevation: 0.0,
        shape: const Arinc661ReticleBorder(isActive: false),
      ),
      textTheme: _applyTacticalTypography(base.textTheme),
      primaryTextTheme: _applyTacticalTypography(base.primaryTextTheme),
    );
  }

  /// Shared sub-theme configuration used by both [light] and [dark].
  ///
  /// [inputAlpha] controls the background alpha of input decorators.
  /// Intended values: 13 for light, 20 for dark. Extreme values (e.g. 0
  /// or 255) may reduce readability but will not throw.
  static FlexSubThemesData _subThemes({required int inputAlpha}) => FlexSubThemesData(
    useM2StyleDividerInM3: true,
    adaptiveElevationShadowsBack: FlexAdaptive.all(),
    adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
    defaultRadius: getDimension('alias.radius.default', borderRadius),
    elevatedButtonSchemeColor: SchemeColor.onPrimary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    inputDecoratorSchemeColor: SchemeColor.onSurface,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: inputAlpha,
    inputDecoratorBorderSchemeColor: SchemeColor.primary,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    listTileContentPadding: EdgeInsetsDirectional.fromSTEB(
      getDimension('alias.padding.list-tile-horizontal', 16.0),
      0,
      getDimension('alias.padding.list-tile-horizontal', 16.0),
      0,
    ),
    listTileMinVerticalPadding: getDimension('alias.padding.list-tile-vertical', 4.0),
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.secondary,
    chipSchemeColor: SchemeColor.primary,
    chipRadius: getDimension('alias.radius.chip', borderRadius),
    popupMenuElevation: getDimension('alias.elevation.popup-menu', 4.0),
    alignedDropdown: true,
    tooltipRadius: getDimension('alias.radius.tooltip', borderRadius),
    dialogElevation: getDimension('alias.elevation.dialog', 8.0),
    datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    appBarScrolledUnderElevation: getDimension('alias.elevation.app-bar-scrolled-under', 0.0),
    tabBarIndicatorSize: TabBarIndicatorSize.tab,
    tabBarIndicatorWeight: 2,
    tabBarIndicatorTopRadius: 0,
    tabBarDividerColor: const Color(0x00000000),
    drawerElevation: getDimension('alias.elevation.drawer', 8.0),
    drawerWidth: 280.0,
    bottomSheetElevation: getDimension('alias.elevation.bottom-sheet', 8.0),
    bottomSheetModalElevation: getDimension('alias.elevation.bottom-sheet-modal', 12.0),
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: true,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedIcon: true,
    bottomNavigationBarElevation: getDimension('alias.elevation.bottom-navigation-bar', 0.0),
    menuElevation: getDimension('alias.elevation.menu', 4.0),
    menuBarRadius: getDimension('alias.radius.menu-bar', 0.0),
    menuBarElevation: getDimension('alias.elevation.menu-bar', 1.0),
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: true,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: true,
    navigationBarIndicatorSchemeColor: SchemeColor.secondary,
    navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
    navigationBarElevation: getDimension('alias.elevation.navigation-bar', 0.0),
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: true,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: true,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.secondary,
  );
}
