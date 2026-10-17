import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:app_flutter/core/app_config.dart';
import 'package:app_flutter/core/theme/app_themes.dart';
import 'package:app_flutter/core/theme/text_scaler.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/features/layout/layout.dart';

/// Root application widget binding the Material theme, linear text scaler, and
/// primary [DashboardPage] shell.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Binds Tier 2 runtime design tokens
///   ([AppThemes]) and accessibility text scaling ([TextScalerController]) into
///   the top-level [MaterialApp] container without hardcoding presentation
///   colors or domain strings.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Linear Typography Scaling**: Applies `TextScaler.linear(textScaler.scale)`
///   monotonically across the entire descendant [MediaQuery] subtree.
/// - **Theme Mode Synchrony**: Rebuilds deterministically whenever
///   [ThemeController] or [TextScalerController] emits a change notification.
///
/// ## 3. Preconditions
/// - Ancestor widget tree must provide active [ThemeController] and
///   [TextScalerController] instances via `Provider`.
///
/// ## 4. Postconditions
/// - Renders a configured [MaterialApp] whose home route is [DashboardPage] and
///   whose light/dark themes track `themeController.currentTheme`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ widget configuration per build pass.
/// - **Space Complexity**: $\mathcal{O}(1)$ stateless widget allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Falls back to default light/dark token palettes inside [AppThemes] when
///   `themeController.currentTheme` is null.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/MyApp, ARCH-APP-001, REQ-SHELL-001]
class MyApp extends StatelessWidget {
  /// Creates a constant [MyApp] root widget instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final textScaler = context.watch<TextScalerController>();

    return MaterialApp(
      title: AppConfig.windowTitle,
      themeMode: themeController.themeMode,
      theme: AppThemes.light(custom: themeController.currentTheme),
      darkTheme: AppThemes.dark(custom: themeController.currentTheme),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaler.scale),
          ),
          child: child!,
        );
      },
      home: const DashboardPage(),
    );
  }
}

/// Primary dashboard page widget that loads `assets/logical-layout.json` and
/// mounts the schema-driven [Layout] workspace.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Resolves the declarative Tier 2
///   layout manifest (`assets/logical-layout.json`) asynchronously at state
///   initialization and delegates container composition to [Layout].
///
/// ## 2. Invariants & Mathematical Properties
/// - **Single Asset Load Lifecycle**: `_layoutConfigFuture` is initialized
///   once in `initState()` so subsequent view switches (`_activeView`) do not
///   re-read the asset bundle.
/// - **Default View Initialization**: Starts on the canonical `'Master_1'`
///   workspace view identifier.
///
/// ## 3. Preconditions
/// - `assets/logical-layout.json` must be registered in `pubspec.yaml` or
///   handled via the error branch of the [FutureBuilder].
///
/// ## 4. Postconditions
/// - Displays a progress indicator while loading, an explicit diagnostic error
///   message if asset loading fails, or the interactive [Layout] widget once
///   resolved.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ state transitions on `onViewChange`;
///   $\mathcal{O}(B)$ initial asset read for $B$ bytes in `logical-layout.json`.
/// - **Space Complexity**: $\mathcal{O}(B)$ to cache the layout JSON string.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Asset bundle read failures are caught by `snapshot.hasError` and rendered
///   inside a fallback [Scaffold] without crashing the UI thread.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [Feat-10/DashboardPage, ARCH-APP-001, REQ-SHELL-001]
class DashboardPage extends StatefulWidget {
  /// Creates a constant [DashboardPage] widget instance.
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _activeView = 'Master_1';
  late Future<String> _layoutConfigFuture;

  @override
  void initState() {
    super.initState();
    _layoutConfigFuture = rootBundle.loadString('assets/logical-layout.json');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _layoutConfigFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading layout configuration: ${snapshot.error}'),
            ),
          );
        }

        final layoutConfig = snapshot.data;

        return Layout(
          activeView: _activeView,
          onViewChange: (newView) {
            setState(() {
              _activeView = newView;
            });
          },
          layoutConfig: layoutConfig,
        );
      },
    );
  }
}
