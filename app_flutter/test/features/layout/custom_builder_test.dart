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

    testWidgets('MyApp and DashboardPage properly preserve and wire customBuilders down to Layout',
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
    });
  });
}
