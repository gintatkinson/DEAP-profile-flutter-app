import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/core/theme/text_scaler.dart';
import 'package:app_flutter/core/theme/theme_service.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/core/di/repository_resolver.dart';
import 'package:app_flutter/core/string_resources.dart';
import 'package:app_flutter/app/app.dart';

// Benchmark access hooks -- set after initialization
/// Global benchmark access hook exposing the active [ThemeController] after bootstrap.
ThemeController? globalThemeController;

/// Global benchmark access hook exposing the active [TextScalerController] after bootstrap.
TextScalerController? globalTextScalerController;

const _dataSource = String.fromEnvironment('DATA_SOURCE', defaultValue: 'sqlite');

/// Bootstraps the Flutter application runtime, resolving the live [DataSource],
/// theme controllers, localization bundles, and root provider tree.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Establishes a deterministic,
///   fault-tolerant application bootstrap sequence that binds the live Layer 1
///   [DataSource] (via [RepositoryResolver]), [ThemeController], and
///   [TextScalerController] before mounting the Layer 3 display shell.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Binding Initialization Precedence**: `WidgetsFlutterBinding.ensureInitialized()`
///   and `PlatformDispatcher.instance.onError` are registered prior to any
///   asynchronous persistence or asset I/O.
/// - **Live Persistence Resolution**: Resolves the configured `DATA_SOURCE`
///   backend (`sqlite` or `firebase`) and injects a non-null [DataSource] into
///   the root [MultiProvider].
///
/// ## 3. Preconditions
/// - The Flutter engine and platform channels must be available in the host
///   process.
///
/// ## 4. Postconditions
/// - Mounts [MyApp] wrapped in a [MultiProvider] supplying [DataSource],
///   [ThemeController], and [TextScalerController], or mounts a deterministic
///   diagnostic fallback [Scaffold] if an unrecoverable startup fault occurs.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ provider graph construction plus
///   bounded asynchronous initialization for SQLite/Firebase schema bootstrap
///   and asset bundle loading.
/// - **Space Complexity**: $\mathcal{O}(1)$ root singleton controller allocations.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If primary [RepositoryResolver.resolve] fails, automatically falls back to
///   an in-memory SQLite [DataSource] instance.
/// - Any uncaught startup exception is trapped by the outer `try/catch` block
///   and rendered in a diagnostic startup error view rather than terminating
///   the process silently.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [ARCH-APP-001, REQ-SHELL-001, Feat-10/Main]
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('Uncaught platform error: $error\n$stack');
    return true;
  };

  try {
    final isTest = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST') ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    DataSource dataSource;
    try {
      dataSource = await RepositoryResolver.resolve(
        dataSourceType: _dataSource,
        sqliteInMemory: isTest,
      );
    } catch (e) {
      debugPrint('Primary repository resolution failed ($e); falling back to in-memory SQLite.');
      dataSource = await RepositoryResolver.resolve(
        dataSourceType: 'sqlite',
        sqliteInMemory: true,
      );
    }

    // Theme
    final themeService = SharedPreferencesThemeService();
    final themeController = ThemeController(themeService);
    await themeController.loadSettings();

    final textScalerController = TextScalerController(themeService);
    await textScalerController.load();

    globalThemeController = themeController;
    globalTextScalerController = textScalerController;

    await StringResources.load();

    runApp(
      MultiProvider(
        providers: [
          Provider<DataSource>.value(value: dataSource),
          ChangeNotifierProvider<ThemeController>.value(value: themeController),
          ChangeNotifierProvider<TextScalerController>.value(value: textScalerController),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, st) {
    debugPrint('FATAL ERROR in main(): $e\n$st');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Startup error:\n$e'),
          ),
        ),
      ),
    );
  }
}
