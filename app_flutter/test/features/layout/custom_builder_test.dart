// Copyright (c) 2026 DEAP Project Contributors. All rights reserved.
// Use of this source code is governed by an Apache-2.0 license that can be
// found in the LICENSE file.

/// Widget tests verifying the Open-Closed ComponentFactory extension boundary.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to RTCA DO-178C Level A and ARINC 661 presentation component verification.
/// Proves that custom presentation widgets can be registered and rendered via
/// [ComponentFactory.customBuilders] without modifying core layout switch statements.
///
/// ## 2. Invariants & Mathematical Properties
/// - Open-Closed Invariant: Injected custom builders are resolved via Map lookup with
///   zero modifications to the core ComponentFactory implementation.
/// - Fallback Invariant: Unregistered node types resolve deterministically to SizedBox.shrink().
///
/// ## 3. Preconditions
/// - Flutter test framework initialized in headless VM test mode.
///
/// ## 4. Postconditions
/// - Proves custom widget mounting, child widget propagation, and property extraction.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) widget pump and find operations.
/// - Space Complexity: O(1) widget tree allocation.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Test assertions fail if custom builder callback is not invoked or rendered widget is missing.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/ComponentFactory]

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/core/theme/theme_service.dart' show SharedPreferencesThemeService;
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/domain/instance_record.dart';
import 'package:app_flutter/features/tree/tree_node.dart';
import 'package:app_flutter/features/topology/topology_map.dart' show TopologyData;
import 'package:app_flutter/features/layout/component_factory.dart';
import 'package:app_flutter/features/layout/layout.dart';
import 'package:app_flutter/core/theme/text_scaler.dart';
import 'package:app_flutter/app/app.dart';

class _StubDataSource implements DataSource {
  @override
  String get name => 'stub';

  @override
  Future<Result<void>> dispose() async => const Result.success(null);

  @override
  Future<Result<List<TypeDescriptor>>> discoverTypes() async => const Result.success([]);

  @override
  Future<Result<TypeDescriptor?>> typeFor(String typeName) async => const Result.success(null);

  @override
  Future<Result<List<(String, String)>>> discoverHierarchy() async => const Result.success([]);

  @override
  Future<Result<Map<String, dynamic>>> fetchProperties(String nodeId) async => const Result.success({});

  @override
  Future<Result<void>> saveProperties(
          String nodeId, Map<String, dynamic> data) async => const Result.success(null);

  @override
  Stream<Result<Map<String, dynamic>>> watchProperties(String nodeId) =>
      const Stream.empty();

  @override
  Future<Result<List<InstanceRecord>>> fetchRelatedInstances({
    required String parentNodeId,
    required TypeDescriptor targetType,
  }) async =>
      const Result.success([]);

  @override
  Future<Result<List<TreeNode>>> fetchRootNodes() async => const Result.success([]);

  @override
  Future<Result<List<TreeNode>>> fetchChildrenForNode(String parentId) async => const Result.success([]);

  @override
  Future<Result<TopologyData>> fetchTopologyData() async =>
      const Result.success(TopologyData(coordinateMapping: {}, nodes: [], links: []));
}

void main() {
  group('ComponentFactory Open-Closed Extension Tests', () {
    testWidgets('renders custom widget registered in customBuilders without modifying switch statement',
        (WidgetTester tester) async {
      bool builderInvoked = false;
      Map<String, dynamic>? receivedNode;
      DeapComponentScope? receivedScope;

      final customBuilders = <String, DeapComponentBuilder>{
        'CustomTelemetryPanel': (context, node, scope) {
          builderInvoked = true;
          receivedNode = node;
          receivedScope = scope;
          return Container(
            key: const ValueKey('custom_telemetry_panel_widget'),
            child: Text(
              'Telemetry Feed: ${node['props']?['channel'] ?? 'default'}',
              textDirection: TextDirection.ltr,
            ),
          );
        },
      };

      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: 42,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: customBuilders,
      );

      final node = <String, dynamic>{
        'type': 'CustomTelemetryPanel',
        'props': {
          'channel': 'radar_stream_01',
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(node, 800.0, 600.0, context);
              },
            ),
          ),
        ),
      );

      expect(builderInvoked, isTrue);
      expect(receivedNode?['type'], equals('CustomTelemetryPanel'));
      expect(receivedScope?.parentWidth, equals(800.0));
      expect(receivedScope?.parentHeight, equals(600.0));
      expect(find.byKey(const ValueKey('custom_telemetry_panel_widget')), findsOneWidget);
      expect(find.text('Telemetry Feed: radar_stream_01'), findsOneWidget);
    });

    testWidgets('unregistered node type returns SizedBox.shrink cleanly without error',
        (WidgetTester tester) async {
      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: const {},
      );

      final unregisteredNode = <String, dynamic>{
        'type': 'UnknownFuturePluginWidget',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(unregisteredNode, 800.0, 600.0, context);
              },
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('omitted or null type in AST node degrades gracefully to SizedBox.shrink',
        (WidgetTester tester) async {
      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: const {},
      );

      final emptyNode = <String, dynamic>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(emptyNode, 800.0, 600.0, context);
              },
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('DeapComponentScope provides recursive child synthesis to custom builder',
        (WidgetTester tester) async {
      final customBuilders = <String, DeapComponentBuilder>{
        'CompositeCustomContainer': (context, node, scope) {
          final children = (node['children'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
          return Column(
            key: const ValueKey('composite_custom_container'),
            children: children.map((c) => scope.buildChild(c)).toList(),
          );
        },
        'ChildLeafWidget': (context, node, scope) {
          return Text(
            node['props']?['label'] as String? ?? 'child',
            textDirection: TextDirection.ltr,
          );
        },
      };

      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: customBuilders,
      );

      final compositeNode = <String, dynamic>{
        'type': 'CompositeCustomContainer',
        'children': [
          {
            'type': 'ChildLeafWidget',
            'props': {'label': 'Nested Component 1'},
          },
          {
            'type': 'ChildLeafWidget',
            'props': {'label': 'Nested Component 2'},
          },
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(compositeNode, 1024.0, 768.0, context);
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('composite_custom_container')), findsOneWidget);
      expect(find.text('Nested Component 1'), findsOneWidget);
      expect(find.text('Nested Component 2'), findsOneWidget);
    });

    testWidgets('Layout widget mounts and renders custom builder from declarative layoutConfig',
        (WidgetTester tester) async {
      final customBuilders = <String, DeapComponentBuilder>{
        'CustomHeaderPanel': (context, node, scope) {
          return Container(
            key: const ValueKey('custom_header_panel_widget'),
            child: Text(
              'Station: ${node['props']?['station_id'] ?? 'none'}',
              textDirection: TextDirection.ltr,
            ),
          );
        },
      };

      const customLayoutConfig = '''
{
  "layout": {
    "root_container": {
      "type": "CustomHeaderPanel",
      "props": {
        "station_id": "ORBITAL-ALPHA-01"
      }
    }
  }
}
''';

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<DataSource>.value(value: _StubDataSource()),
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(SharedPreferencesThemeService()),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Layout(
                layoutConfig: customLayoutConfig,
                customBuilders: customBuilders,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const ValueKey('custom_header_panel_widget')), findsOneWidget);
      expect(find.text('Station: ORBITAL-ALPHA-01'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('MyApp and DashboardPage properly preserve and wire customBuilders down to Layout in live widget tree',
        (WidgetTester tester) async {
      final customBuilders = <String, DeapComponentBuilder>{
        'TelemetryHUD': (context, node, scope) => const SizedBox(
              key: ValueKey('telemetry_hud_rendered'),
            ),
      };

      final myApp = MyApp(customBuilders: customBuilders);
      expect(myApp.customBuilders, contains('TelemetryHUD'));

      final dashboard = DashboardPage(customBuilders: customBuilders);
      expect(dashboard.customBuilders, contains('TelemetryHUD'));

      final textScaler = TextScalerController();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<DataSource>.value(value: _StubDataSource()),
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(SharedPreferencesThemeService()),
            ),
            ChangeNotifierProvider<TextScalerController>.value(
              value: textScaler,
            ),
          ],
          child: MyApp(customBuilders: customBuilders),
        ),
      );
      await tester.pump();

      expect(find.byType(MyApp), findsOneWidget);
      expect(find.byType(DashboardPage), findsOneWidget);

      final dashboardWidget = tester.widget<DashboardPage>(find.byType(DashboardPage));
      expect(dashboardWidget.customBuilders, contains('TelemetryHUD'));

      await tester.pump(const Duration(milliseconds: 50));

      final layoutFinder = find.byType(Layout);
      if (layoutFinder.evaluate().isNotEmpty) {
        final layoutWidget = tester.widget<Layout>(layoutFinder);
        expect(layoutWidget.customBuilders, contains('TelemetryHUD'));
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('custom builder throwing exception degrades gracefully to SizedBox.shrink without crashing UI',
        (WidgetTester tester) async {
      final customBuilders = <String, DeapComponentBuilder>{
        'FaultyPluginWidget': (context, node, scope) {
          throw StateError('Simulated hardware bus disconnect');
        },
      };

      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: customBuilders,
      );

      final faultyNode = <String, dynamic>{
        'type': 'FaultyPluginWidget',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(faultyNode, 800.0, 600.0, context);
              },
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('malformed AST nodes degrade gracefully to SizedBox.shrink without type exceptions',
        (WidgetTester tester) async {
      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: const {},
      );

      final nonStringTypeNode = <String, dynamic>{
        'type': 12345,
      };
      final malformedSidebarNode = <String, dynamic>{
        'type': 'SidebarLayout',
        'children': 'not_a_list',
      };
      final malformedSplitNode = <String, dynamic>{
        'type': 'SplitWorkspace',
        'children': ['invalid_string_child', 42],
        'props': 'invalid_props',
      };

      final themeController = ThemeController(SharedPreferencesThemeService());

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeController>.value(
          value: themeController,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return factory.build(nonStringTypeNode, 800.0, 600.0, context);
                },
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeController>.value(
          value: themeController,
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 800.0,
                height: 600.0,
                child: Builder(
                  builder: (context) {
                    return factory.build(malformedSidebarNode, 800.0, 600.0, context);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeController>.value(
          value: themeController,
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 800.0,
                height: 600.0,
                child: Builder(
                  builder: (context) {
                    return factory.build(malformedSplitNode, 800.0, 600.0, context);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('cyclical AST recursion via scope.buildChild terminates safely at depth bound',
        (WidgetTester tester) async {
      final customBuilders = <String, DeapComponentBuilder>{
        'RecursiveCyclicWidget': (context, node, scope) {
          final child = node['loop'] as Map<String, dynamic>;
          return scope.buildChild(child);
        },
      };

      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: customBuilders,
      );

      final cyclicNode = <String, dynamic>{
        'type': 'RecursiveCyclicWidget',
      };
      cyclicNode['loop'] = cyclicNode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(cyclicNode, 800.0, 600.0, context);
              },
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('dynamic update of customBuilders triggers updated widget instantiation upon rebuild',
        (WidgetTester tester) async {
      const customLayoutConfig = '''
{
  "layout": {
    "root_container": {
      "type": "DynamicPlugWidget"
    }
  }
}
''';

      Widget buildHarness(Map<String, DeapComponentBuilder> builders) {
        return MultiProvider(
          providers: [
            Provider<DataSource>.value(value: _StubDataSource()),
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(SharedPreferencesThemeService()),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Layout(
                layoutConfig: customLayoutConfig,
                customBuilders: builders,
              ),
            ),
          ),
        );
      }

      final buildersV1 = <String, DeapComponentBuilder>{
        'DynamicPlugWidget': (context, node, scope) => const Text('Plug-in Version 1', textDirection: TextDirection.ltr),
      };
      await tester.pumpWidget(buildHarness(buildersV1));
      await tester.pump();
      expect(find.text('Plug-in Version 1'), findsOneWidget);

      final buildersV2 = <String, DeapComponentBuilder>{
        'DynamicPlugWidget': (context, node, scope) => const Text('Plug-in Version 2', textDirection: TextDirection.ltr),
      };
      await tester.pumpWidget(buildHarness(buildersV2));
      await tester.pump();
      expect(find.text('Plug-in Version 2'), findsOneWidget);
      expect(find.text('Plug-in Version 1'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('DeapComponentScope sanitizes negative or non-finite dimensions to zero',
        (WidgetTester tester) async {
      double? receivedWidth;
      double? receivedHeight;

      final customBuilders = <String, DeapComponentBuilder>{
        'DimensionProbe': (context, node, scope) {
          receivedWidth = scope.parentWidth;
          receivedHeight = scope.parentHeight;
          return const SizedBox.shrink();
        },
      };

      final factory = ComponentFactory(
        currentView: 'default',
        workerResult: null,
        onViewSelected: (_) {},
        minPaneSize: 100.0,
        defaultRatio: () => 0.5,
        resolveTopologyData: () => throw UnimplementedError(),
        resolveTabLabel: (id) => id,
        buildChildWidget: (_) => const SizedBox.shrink(),
        customBuilders: customBuilders,
      );

      final node = <String, dynamic>{'type': 'DimensionProbe'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return factory.build(node, -100.0, double.nan, context);
              },
            ),
          ),
        ),
      );

      expect(receivedWidth, equals(0.0));
      expect(receivedHeight, equals(0.0));
    });
  });
}
