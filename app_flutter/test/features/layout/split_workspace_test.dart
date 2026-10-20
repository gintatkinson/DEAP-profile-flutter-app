import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_flutter/features/layout/component_factory.dart';
import 'package:app_flutter/features/layout/split_workspace.dart';
import 'package:app_flutter/features/topology/topology_map.dart';
import 'package:app_flutter/core/theme/theme_controller.dart';
import 'package:app_flutter/core/theme/theme_service.dart' show SharedPreferencesThemeService;

void main() {
  testWidgets('SplitWorkspace deferred resizing sets state correctly', (WidgetTester tester) async {
    double draggedSize = 0.0;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>(create: (_) => ThemeController(SharedPreferencesThemeService())),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SplitWorkspace(
              direction: Axis.horizontal,
              minFirstPaneSize: 50.0,
              initialRatio: 0.5,
              splitterKey: const Key('splitter'),
              leading: const Text('Leading'),
              trailing: const Text('Trailing'),
              onDrag: (size) {
                draggedSize = size;
              },
            ),
          ),
        ),
      ),
    );
    
    final splitter = find.byKey(const Key('splitter'));
    expect(splitter, findsOneWidget);

    await tester.drag(splitter, const Offset(100.0, 0.0));
    await tester.pumpAndSettle();
    
    expect(draggedSize, greaterThan(400.0));
  });

  testWidgets('SplitWorkspace didUpdateWidget recalculates pane dimensions on direction or initialRatio change', (WidgetTester tester) async {
    Widget buildTestHost({required Axis direction, required double ratio}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>(
            create: (_) => ThemeController(SharedPreferencesThemeService()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 800.0,
                height: 400.0,
                child: SplitWorkspace(
                  direction: direction,
                  minFirstPaneSize: 50.0,
                  initialRatio: ratio,
                  splitterKey: const Key('test_splitter'),
                  leading: Container(key: const Key('leading_box')),
                  trailing: Container(key: const Key('trailing_box')),
                ),
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildTestHost(direction: Axis.horizontal, ratio: 0.5));
    expect(tester.getSize(find.byKey(const Key('leading_box'))).width, closeTo(400.0, 0.1));

    // Drag splitter horizontally by +100 px so _firstPaneSize becomes 500.0
    await tester.drag(find.byKey(const Key('test_splitter')), const Offset(100.0, 0.0));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const Key('leading_box'))).width, closeTo(500.0, 0.1));

    // Switch orientation to vertical: leading pane height should recalculate to 400 * 0.5 = 200.0
    // instead of clamping stale 500.0 to 350.0 from previous horizontal width.
    await tester.pumpWidget(buildTestHost(direction: Axis.vertical, ratio: 0.5));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('leading_box'))).height, closeTo(200.0, 0.1));

    // Change initialRatio to 0.25: leading pane height should recalculate to 400 * 0.25 = 100.0.
    await tester.pumpWidget(buildTestHost(direction: Axis.vertical, ratio: 0.25));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('leading_box'))).height, closeTo(100.0, 0.1));
  });

  testWidgets('ComponentFactory respects reconfigurable prop, assigns orientation ValueKey, and supports nested SplitWorkspace children', (WidgetTester tester) async {
    final nestedAst = <String, dynamic>{
      'type': 'SplitWorkspace',
      'id': 'workspace_split',
      'props': <String, dynamic>{
        'axis': 'vertical',
        'reconfigurable': true,
      },
      'children': <dynamic>[
        <String, dynamic>{
          'type': 'SplitWorkspace',
          'id': 'inner_vertical_stack',
          'props': <String, dynamic>{
            'axis': 'vertical',
            'reconfigurable': false,
          },
          'children': <dynamic>[
            <String, dynamic>{
              'type': 'PropertiesPanel',
              'id': 'child_a',
            },
            <String, dynamic>{
              'type': 'PropertiesPanel',
              'id': 'child_b',
            },
          ],
        },
        <String, dynamic>{
          'type': 'PropertiesPanel',
          'id': 'trailing_panel',
        },
      ],
    };

    final factory = ComponentFactory(
      currentView: 'node_1',
      workerResult: null,
      onViewSelected: (_) {},
      minPaneSize: 50.0,
      defaultRatio: () => 0.5,
      resolveTopologyData: () => const TopologyData(
        coordinateMapping: <String, String>{},
        nodes: [],
        links: [],
      ),
      resolveTabLabel: (id) => id,
      buildChildWidget: (_) => const SizedBox.shrink(),
      preferredSplitAxis: Axis.horizontal,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>(
            create: (_) => ThemeController(SharedPreferencesThemeService()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => factory.build(nestedAst, 1200.0, 800.0, context),
            ),
          ),
        ),
      ),
    );

    // Outer reconfigurable split uses preferredSplitAxis (horizontal) and gets ValueKey('split_workspace_split_horizontal')
    final outerFinder = find.byKey(const ValueKey('split_workspace_split_horizontal'));
    expect(outerFinder, findsOneWidget);
    final outerWidget = tester.widget<SplitWorkspace>(outerFinder);
    expect(outerWidget.direction, Axis.horizontal);
    expect(outerWidget.splitterKey, const Key('horizontal_splitter'));

    // Inner non-reconfigurable split preserves its own axis ('vertical') and is NOT stomped by preferredSplitAxis
    final innerFinder = find.byKey(const ValueKey('split_inner_vertical_stack_vertical'));
    expect(innerFinder, findsOneWidget);
    final innerWidget = tester.widget<SplitWorkspace>(innerFinder);
    expect(innerWidget.direction, Axis.vertical);
    expect(innerWidget.splitterKey, const Key('inner_vertical_stack_splitter'));
  });
}
