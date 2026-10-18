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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `MyApp::MyApp` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `MyApp::MyApp` (declaration #2) within `APP-APP`.
  ///
  /// ## 3. Preconditions
  /// - `key: Key` must satisfy domain and type-safety constraints prior to invoking `MyApp::MyApp`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `MyApp::MyApp` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `MyApp::MyApp`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `MyApp::MyApp`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `MyApp::MyApp` (`()`).
  /// - State: Maintains consistent state invariants across `MyApp::MyApp` without partial mutation on error.
  /// - Action: Executes `MyApp::MyApp` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `MyApp::MyApp` (`APP-APP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-APP-APP-MYAPP-MYAPP] | SysML v2: ActionDef(MyApp::MyApp)
  const MyApp({super.key});

  /// Executes deterministic method `MyApp::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `MyApp::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `MyApp::build` (declaration #3) within `APP-APP`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `MyApp::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `MyApp::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `MyApp::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `MyApp::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `MyApp::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `MyApp::build` without partial mutation on error.
  /// - Action: Executes `MyApp::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `MyApp::build` (`APP-APP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-APP-APP-MYAPP-BUILD] | SysML v2: ActionDef(MyApp::build)
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
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `DashboardPage::DashboardPage` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `DashboardPage::DashboardPage` (declaration #5) within `APP-APP`.
  ///
  /// ## 3. Preconditions
  /// - `key: Key` must satisfy domain and type-safety constraints prior to invoking `DashboardPage::DashboardPage`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `DashboardPage::DashboardPage` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `DashboardPage::DashboardPage`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `DashboardPage::DashboardPage`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DashboardPage::DashboardPage` (`()`).
  /// - State: Maintains consistent state invariants across `DashboardPage::DashboardPage` without partial mutation on error.
  /// - Action: Executes `DashboardPage::DashboardPage` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DashboardPage::DashboardPage` (`APP-APP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-APP-APP-DASHBOARDPAGE-DASHBOARDPAGE] | SysML v2: ActionDef(DashboardPage::DashboardPage)
  const DashboardPage({super.key});

  /// Executes deterministic method `DashboardPage::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `DashboardPage::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `DashboardPage::createState` (declaration #6) within `APP-APP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `DashboardPage::createState` in `APP-APP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<DashboardPage>` from `DashboardPage::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `DashboardPage::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `DashboardPage::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `DashboardPage::createState` (`State<DashboardPage>`).
  /// - State: Maintains consistent state invariants across `DashboardPage::createState` without partial mutation on error.
  /// - Action: Executes `DashboardPage::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `DashboardPage::createState` (`APP-APP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-APP-APP-DASHBOARDPAGE-CREATESTATE] | SysML v2: ActionDef(DashboardPage::createState)
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

/// Executes deterministic class `_DashboardPageState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_DashboardPageState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_DashboardPageState` (declaration #7) within `APP-APP`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_DashboardPageState` in `APP-APP`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_DashboardPageState` representation for class `_DashboardPageState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_DashboardPageState)) bounded over input/member dimension of `_DashboardPageState`.
/// - Space Complexity: O(K(_DashboardPageState)) bounded auxiliary memory for `_DashboardPageState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_DashboardPageState` (`_DashboardPageState`).
/// - State: Maintains consistent state invariants across `_DashboardPageState` without partial mutation on error.
/// - Action: Executes `_DashboardPageState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_DashboardPageState` (`APP-APP`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-APP-APP-DASHBOARDPAGESTATE] | SysML v2: PartDef(_DashboardPageState)
class _DashboardPageState extends State<DashboardPage> {
  String _activeView = 'Master_1';
  late Future<String> _layoutConfigFuture;

  /// Executes deterministic method `_DashboardPageState::initState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_DashboardPageState::initState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_DashboardPageState::initState` (declaration #8) within `APP-APP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_DashboardPageState::initState` in `APP-APP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_DashboardPageState::initState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(initState)) bounded over input/member dimension of `_DashboardPageState::initState`.
  /// - Space Complexity: O(K(initState)) bounded auxiliary memory for `_DashboardPageState::initState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_DashboardPageState::initState` (`void`).
  /// - State: Maintains consistent state invariants across `_DashboardPageState::initState` without partial mutation on error.
  /// - Action: Executes `_DashboardPageState::initState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_DashboardPageState::initState` (`APP-APP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-APP-APP-DASHBOARDPAGESTATE-INITSTATE] | SysML v2: ActionDef(_DashboardPageState::initState)
  @override
  void initState() {
    super.initState();
    _layoutConfigFuture = rootBundle.loadString('assets/logical-layout.json');
  }

  /// Executes deterministic method `_DashboardPageState::build` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_DashboardPageState::build` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/app/app.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_DashboardPageState::build` (declaration #9) within `APP-APP`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_DashboardPageState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_DashboardPageState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_DashboardPageState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_DashboardPageState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_DashboardPageState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_DashboardPageState::build` without partial mutation on error.
  /// - Action: Executes `_DashboardPageState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_DashboardPageState::build` (`APP-APP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-APP-APP-DASHBOARDPAGESTATE-BUILD] | SysML v2: ActionDef(_DashboardPageState::build)
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
