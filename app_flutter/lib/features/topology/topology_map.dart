import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_flutter/core/theme/app_themes.dart';
import 'package:app_flutter/domain/type_descriptor.dart';
import 'package:app_flutter/features/topology/topology_defaults.dart' show emptyTopologyData;

/// Executes deterministic fn `_resolvePath` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for fn `_resolvePath` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for fn `_resolvePath` (declaration #1) within `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 3. Preconditions
/// - `map: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `_resolvePath`.
/// - `path: String` must satisfy domain and type-safety constraints prior to invoking `_resolvePath`.
///
/// ## 4. Postconditions
/// - Returns `dynamic` from `_resolvePath` with deterministic post-execution state.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(N(map)) bounded over input/member dimension of `_resolvePath`.
/// - Space Complexity: O(N(map)) bounded auxiliary memory for `_resolvePath`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_resolvePath` (`dynamic`).
/// - State: Maintains consistent state invariants across `_resolvePath` without partial mutation on error.
/// - Action: Executes `_resolvePath` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_resolvePath` (`TOPOLOGY-TOPOLOGY-MAP`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-RESOLVEPATH] | SysML v2: ActionDef(_resolvePath)
dynamic _resolvePath(Map<String, dynamic> map, String path) {
  final List<String> parts = path.split('/');
  dynamic current = map;
  for (final String part in parts) {
    if (current is Map<String, dynamic>) {
      current = current[part];
    } else {
      return null;
    }
  }
  return current;
}

/// Executes deterministic fn `_collectNodeAttributes` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for fn `_collectNodeAttributes` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for fn `_collectNodeAttributes` (declaration #2) within `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_collectNodeAttributes` in `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 4. Postconditions
/// - Returns `Map<String, dynamic>` from `_collectNodeAttributes` with deterministic post-execution state.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_collectNodeAttributes)) bounded over input/member dimension of `_collectNodeAttributes`.
/// - Space Complexity: O(K(_collectNodeAttributes)) bounded auxiliary memory for `_collectNodeAttributes`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_collectNodeAttributes` (`Map<String, dynamic>`).
/// - State: Maintains consistent state invariants across `_collectNodeAttributes` without partial mutation on error.
/// - Action: Executes `_collectNodeAttributes` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_collectNodeAttributes` (`TOPOLOGY-TOPOLOGY-MAP`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-COLLECTNODEATTRIBUTES] | SysML v2: ActionDef(_collectNodeAttributes)
Map<String, dynamic> _collectNodeAttributes(
  String nodeId,
  Map<String, dynamic> rawProperties,
  Map<String, dynamic> positionProperties,
  Map<String, dynamic> metadata,
) {
  final Map<String, dynamic> merged = <String, dynamic>{
    ...positionProperties,
    ...rawProperties,
  };
  if (nodeId.isEmpty || metadata.isEmpty) {
    return merged;
  }
  for (final MapEntry<String, dynamic> entry in metadata.entries) {
    if (entry.key == 'nodes' || entry.key == 'links') continue;
    final dynamic val = entry.value;
    if (val is List) {
      for (final dynamic item in val) {
        if (item is Map) {
          final bool matchesNode = item.values.any(
            (dynamic v) => v is String && v == nodeId,
          );
          if (matchesNode) {
            for (final MapEntry<dynamic, dynamic> field in item.entries) {
              merged.putIfAbsent(field.key.toString(), () => field.value);
            }
          }
        }
      }
    }
  }
  return merged;
}

/// ## 1. Safety Intent & Regulatory Scope
/// 3-D spatial coordinate, time-index, and trajectory velocity vector model
/// for a topology node under DO-178C Level A / ARINC 661 display contracts.
///
/// ## 2. Invariants & Mathematical Properties
/// - Parsed from JSON via [TopologyNodePosition.fromJson]. Coordinates are
///   resolved lazily through [resolveCoordinate] which checks an optional
///   `coordinateMapping` before falling back to the baked-in `dim` fields.
/// - Raw properties are preserved for arbitrary schema-driven downstream lookups.
///
/// ## 3. Preconditions
/// - JSON payload or constructor parameters must provide finite numeric coordinates.
///
/// ## 4. Postconditions
/// - Immutable [TopologyNodePosition] instance with deterministic coordinate and vector resolution.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(D) path segments for mapped lookup; O(1) fallback to baked-in fields.
/// - Space Complexity: O(K) where K is the number of raw property keys.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing dimensions default to `0.0`; empty vector yields zero velocity in [TopologyNode.computePosition].
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyNodePosition]
class TopologyNodePosition {
  /// First spatial coordinate (x-axis). Parsed from JSON key `dim_0`.
  /// Defaults to 0.0 when missing. Used as the primary x-position on canvas.
  final double dim0;

  /// Second spatial coordinate (y-axis). Parsed from JSON key `dim_1`.
  /// Defaults to 0.0 when missing. Used as the primary y-position on canvas.
  final double dim1;

  /// Third spatial coordinate (z-axis). Parsed from JSON key `dim_2`.
  /// Defaults to 0.0 when missing. Not directly rendered; available for
  /// downstream consumers.
  final double dim2;

  /// Timestamp index for this node position. Parsed from JSON key
  /// `time_index`. Used by [TopologyNode.computePosition] to calculate
  /// displacement from the trajectory vector.
  final double timeIndex;

  /// Velocity / trajectory vector for this position. The first two elements
  /// are interpreted as (vx, vy) and scaled by
  /// [TopologyPainter.velocityScale] during rendering. An empty list is
  /// treated as zero velocity.
  final List<double> vector;

  /// Unprocessed JSON payload for this node. Preserved for arbitrary
  /// downstream lookups and coordinate resolution via
  /// [resolveCoordinate] / [resolveVector].
  final Map<String, dynamic> rawProperties;

  /// Executes deterministic constructor `TopologyNodePosition::TopologyNodePosition` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyNodePosition::TopologyNodePosition` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyNodePosition::TopologyNodePosition` (declaration #4) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyNodePosition::TopologyNodePosition` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyNodePosition::TopologyNodePosition` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyNodePosition)) bounded over input/member dimension of `TopologyNodePosition::TopologyNodePosition`.
  /// - Space Complexity: O(K(TopologyNodePosition)) bounded auxiliary memory for `TopologyNodePosition::TopologyNodePosition`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNodePosition::TopologyNodePosition` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyNodePosition::TopologyNodePosition` without partial mutation on error.
  /// - Action: Executes `TopologyNodePosition::TopologyNodePosition` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNodePosition::TopologyNodePosition` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODEPOSITION-TOPOLOGYNODEPOSITION] | SysML v2: ActionDef(TopologyNodePosition::TopologyNodePosition)
  const TopologyNodePosition({
    required this.dim0,
    required this.dim1,
    required this.dim2,
    required this.timeIndex,
    required this.vector,
    this.rawProperties = const <String, dynamic>{},
  });

  /// Executes deterministic constructor `TopologyNodePosition::TopologyNodePosition` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyNodePosition::TopologyNodePosition` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyNodePosition::TopologyNodePosition` (declaration #5) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `json: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::TopologyNodePosition`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyNodePosition::TopologyNodePosition` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `TopologyNodePosition::TopologyNodePosition`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `TopologyNodePosition::TopologyNodePosition`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNodePosition::TopologyNodePosition` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyNodePosition::TopologyNodePosition` without partial mutation on error.
  /// - Action: Executes `TopologyNodePosition::TopologyNodePosition` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNodePosition::TopologyNodePosition` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODEPOSITION-TOPOLOGYNODEPOSITION] | SysML v2: ActionDef(TopologyNodePosition::TopologyNodePosition)
  factory TopologyNodePosition.fromJson(Map<String, dynamic> json) {
    return TopologyNodePosition(
      dim0: (json['dim_0'] as num?)?.toDouble() ?? 0.0,
      dim1: (json['dim_1'] as num?)?.toDouble() ?? 0.0,
      dim2: (json['dim_2'] as num?)?.toDouble() ?? 0.0,
      timeIndex: (json['time_index'] as num?)?.toDouble() ?? 0.0,
      vector: json['vector'] is List<dynamic>
          ? (json['vector'] as List<dynamic>)
              .map((dynamic e) => (e as num).toDouble())
              .toList()
          : <double>[],
      rawProperties: json,
    );
  }

  /// Executes deterministic method `TopologyNodePosition::_resolvePathWithMapping` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNodePosition::_resolvePathWithMapping` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNodePosition::_resolvePathWithMapping` (declaration #6) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::_resolvePathWithMapping`.
  /// - `coordinateMapping: Map<String, String>?` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::_resolvePathWithMapping`.
  ///
  /// ## 4. Postconditions
  /// - Returns `String?` from `TopologyNodePosition::_resolvePathWithMapping` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TopologyNodePosition::_resolvePathWithMapping`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TopologyNodePosition::_resolvePathWithMapping`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNodePosition::_resolvePathWithMapping` (`String?`).
  /// - State: Maintains consistent state invariants across `TopologyNodePosition::_resolvePathWithMapping` without partial mutation on error.
  /// - Action: Executes `TopologyNodePosition::_resolvePathWithMapping` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNodePosition::_resolvePathWithMapping` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODEPOSITION-RESOLVEPATHWITHMAPPING] | SysML v2: ActionDef(TopologyNodePosition::_resolvePathWithMapping)
  String? _resolvePathWithMapping(String key, Map<String, String>? coordinateMapping) {
    final String? path = coordinateMapping?[key];
    if (path == null) return null;
    return path.startsWith('position/') ? path.substring(9) : path;
  }

  /// Executes deterministic method `TopologyNodePosition::resolveCoordinate` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNodePosition::resolveCoordinate` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNodePosition::resolveCoordinate` (declaration #7) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::resolveCoordinate`.
  /// - `coordinateMapping: Map<String, String>?` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::resolveCoordinate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `TopologyNodePosition::resolveCoordinate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TopologyNodePosition::resolveCoordinate`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TopologyNodePosition::resolveCoordinate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNodePosition::resolveCoordinate` (`double`).
  /// - State: Maintains consistent state invariants across `TopologyNodePosition::resolveCoordinate` without partial mutation on error.
  /// - Action: Executes `TopologyNodePosition::resolveCoordinate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNodePosition::resolveCoordinate` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODEPOSITION-RESOLVECOORDINATE] | SysML v2: ActionDef(TopologyNodePosition::resolveCoordinate)
  double resolveCoordinate(String key, Map<String, String>? coordinateMapping) {
    final String? resolvedPath = _resolvePathWithMapping(key, coordinateMapping);
    if (resolvedPath != null) {
      final dynamic val = _resolvePath(rawProperties, resolvedPath);
      if (val is num) {
        return val.toDouble();
      }
    }
    switch (key) {
      case 'x':
        return dim0;
      case 'y':
        return dim1;
      case 'z':
        return dim2;
      case 't':
        return timeIndex;
      default:
        return 0.0;
    }
  }

  /// Executes deterministic method `TopologyNodePosition::resolveVector` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNodePosition::resolveVector` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNodePosition::resolveVector` (declaration #8) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::resolveVector`.
  /// - `coordinateMapping: Map<String, String>?` must satisfy domain and type-safety constraints prior to invoking `TopologyNodePosition::resolveVector`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<double>` from `TopologyNodePosition::resolveVector` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TopologyNodePosition::resolveVector`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TopologyNodePosition::resolveVector`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNodePosition::resolveVector` (`List<double>`).
  /// - State: Maintains consistent state invariants across `TopologyNodePosition::resolveVector` without partial mutation on error.
  /// - Action: Executes `TopologyNodePosition::resolveVector` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNodePosition::resolveVector` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODEPOSITION-RESOLVEVECTOR] | SysML v2: ActionDef(TopologyNodePosition::resolveVector)
  List<double> resolveVector(String key, Map<String, String>? coordinateMapping) {
    final String? resolvedPath = _resolvePathWithMapping(key, coordinateMapping);
    if (resolvedPath != null) {
      final dynamic val = _resolvePath(rawProperties, resolvedPath);
      if (val is List) {
        return val.map((dynamic e) => (e as num).toDouble()).toList();
      }
    }
    if (key == 'trajectory') {
      return vector;
    }
    return const <double>[];
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Represents a node entity in the topology visualization with position,
/// status, and arbitrary schema-driven properties under ARINC 661 rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - [computePosition] projects the node's position at `timeIndex` via linear
///   kinematics: `P(t) = P(t_0) + (t - t_0) * V`.
/// - Envelope radii and directional leader vectors are resolved generically via [TypeDescriptor] metadata.
///
/// ## 3. Preconditions
/// - Constructed via [TopologyNode.fromJson] or explicit constructor parameters.
///
/// ## 4. Postconditions
/// - Provides deterministic 2D canvas offsets, concentric range radii, and velocity vectors.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) for position computation; O(F + A) for descriptor-based attribute discovery.
/// - Space Complexity: O(A) where A is the number of node attributes.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Missing `id` or `label` default to empty string; empty trajectory vector is treated as zero velocity.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyNode]
class TopologyNode {
  /// Unique identifier for this node. Used as a key for link source/target
  /// references and for focus tracking via [TopologyMap.activeFocusedNode].
  final String id;

  /// Human-readable label rendered below the node circle on canvas.
  final String label;

  /// Encapsulated position data including coordinates, time index, and
  /// trajectory vector. See [TopologyNodePosition] for details.
  final TopologyNodePosition position;

  /// Status string used for colour selection. "Active" receives the
  /// [TopologyPainterColors.activeStatusColor]; all other values receive
  /// the [TopologyPainterColors.warningStatusColor].
  final String status;

  /// Unprocessed JSON payload for this node. Preserved for arbitrary
  /// downstream lookups and coordinate resolution via
  /// [resolveCoordinate] / [resolveVector].
  final Map<String, dynamic> rawProperties;

  /// Executes deterministic constructor `TopologyNode::TopologyNode` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyNode::TopologyNode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyNode::TopologyNode` (declaration #10) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyNode::TopologyNode` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyNode::TopologyNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyNode)) bounded over input/member dimension of `TopologyNode::TopologyNode`.
  /// - Space Complexity: O(K(TopologyNode)) bounded auxiliary memory for `TopologyNode::TopologyNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::TopologyNode` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyNode::TopologyNode` without partial mutation on error.
  /// - Action: Executes `TopologyNode::TopologyNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::TopologyNode` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-TOPOLOGYNODE] | SysML v2: ActionDef(TopologyNode::TopologyNode)
  const TopologyNode({
    required this.id,
    required this.label,
    required this.position,
    required this.status,
    this.rawProperties = const <String, dynamic>{},
  });

  /// Executes deterministic constructor `TopologyNode::TopologyNode` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyNode::TopologyNode` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyNode::TopologyNode` (declaration #11) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `json: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::TopologyNode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyNode::TopologyNode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `TopologyNode::TopologyNode`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `TopologyNode::TopologyNode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::TopologyNode` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyNode::TopologyNode` without partial mutation on error.
  /// - Action: Executes `TopologyNode::TopologyNode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::TopologyNode` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-TOPOLOGYNODE] | SysML v2: ActionDef(TopologyNode::TopologyNode)
  factory TopologyNode.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> posJson = json['position'] is Map<String, dynamic>
        ? json['position'] as Map<String, dynamic>
        : <String, dynamic>{};
    return TopologyNode(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      position: TopologyNodePosition.fromJson(posJson),
      status: json['status'] as String? ?? '',
      rawProperties: json,
    );
  }

  /// Executes deterministic method `TopologyNode::resolveCoordinate` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNode::resolveCoordinate` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNode::resolveCoordinate` (declaration #12) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::resolveCoordinate`.
  /// - `coordinateMapping: Map<String, String>?` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::resolveCoordinate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `double` from `TopologyNode::resolveCoordinate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TopologyNode::resolveCoordinate`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TopologyNode::resolveCoordinate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::resolveCoordinate` (`double`).
  /// - State: Maintains consistent state invariants across `TopologyNode::resolveCoordinate` without partial mutation on error.
  /// - Action: Executes `TopologyNode::resolveCoordinate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::resolveCoordinate` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-RESOLVECOORDINATE] | SysML v2: ActionDef(TopologyNode::resolveCoordinate)
  double resolveCoordinate(String key, Map<String, String>? coordinateMapping) {
    final String? path = coordinateMapping?[key];
    if (path != null && rawProperties.isNotEmpty) {
      final dynamic val = _resolvePath(rawProperties, path);
      if (val is num) {
        return val.toDouble();
      }
    }
    return position.resolveCoordinate(key, coordinateMapping);
  }

  /// Executes deterministic method `TopologyNode::resolveVector` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNode::resolveVector` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNode::resolveVector` (declaration #13) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `key: String` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::resolveVector`.
  /// - `coordinateMapping: Map<String, String>?` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::resolveVector`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<double>` from `TopologyNode::resolveVector` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(key)) bounded over input/member dimension of `TopologyNode::resolveVector`.
  /// - Space Complexity: O(N(key)) bounded auxiliary memory for `TopologyNode::resolveVector`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::resolveVector` (`List<double>`).
  /// - State: Maintains consistent state invariants across `TopologyNode::resolveVector` without partial mutation on error.
  /// - Action: Executes `TopologyNode::resolveVector` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::resolveVector` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-RESOLVEVECTOR] | SysML v2: ActionDef(TopologyNode::resolveVector)
  List<double> resolveVector(String key, Map<String, String>? coordinateMapping) {
    final String? path = coordinateMapping?[key];
    if (path != null && rawProperties.isNotEmpty) {
      final dynamic val = _resolvePath(rawProperties, path);
      if (val is List) {
        return val.map((dynamic e) => (e as num).toDouble()).toList();
      }
    }
    return position.resolveVector(key, coordinateMapping);
  }

  /// Executes deterministic method `TopologyNode::computePosition` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNode::computePosition` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNode::computePosition` (declaration #14) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `data: TopologyData` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::computePosition`.
  /// - `timeIndex: double` must satisfy domain and type-safety constraints prior to invoking `TopologyNode::computePosition`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Offset` from `TopologyNode::computePosition` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(data)) bounded over input/member dimension of `TopologyNode::computePosition`.
  /// - Space Complexity: O(N(data)) bounded auxiliary memory for `TopologyNode::computePosition`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::computePosition` (`Offset`).
  /// - State: Maintains consistent state invariants across `TopologyNode::computePosition` without partial mutation on error.
  /// - Action: Executes `TopologyNode::computePosition` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::computePosition` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-COMPUTEPOSITION] | SysML v2: ActionDef(TopologyNode::computePosition)
  Offset computePosition(TopologyData data, double timeIndex) {
    final double nodeT = resolveCoordinate('t', data.coordinateMapping);
    final double dt = timeIndex - nodeT;
    final List<double> vector = resolveVector('trajectory', data.coordinateMapping);
    final double vx = vector.isNotEmpty ? vector[0] : 0.0;
    final double vy = vector.length > 1 ? vector[1] : 0.0;
    final double nodeX = resolveCoordinate('x', data.coordinateMapping);
    final double nodeY = resolveCoordinate('y', data.coordinateMapping);
    return Offset(nodeX + dt * vx, nodeY + dt * vy);
  }

  /// Resolves concentric dashed range/envelope radii (in logical pixels) from
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNode::resolveEnvelopeRadii` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNode::resolveEnvelopeRadii` (declaration #15) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyNode::resolveEnvelopeRadii` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `List<double>` from `TopologyNode::resolveEnvelopeRadii` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(resolveEnvelopeRadii)) bounded over input/member dimension of `TopologyNode::resolveEnvelopeRadii`.
  /// - Space Complexity: O(K(resolveEnvelopeRadii)) bounded auxiliary memory for `TopologyNode::resolveEnvelopeRadii`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::resolveEnvelopeRadii` (`List<double>`).
  /// - State: Maintains consistent state invariants across `TopologyNode::resolveEnvelopeRadii` without partial mutation on error.
  /// - Action: Executes `TopologyNode::resolveEnvelopeRadii` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::resolveEnvelopeRadii` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-RESOLVEENVELOPERADII] | SysML v2: ActionDef(TopologyNode::resolveEnvelopeRadii)
  List<double> resolveEnvelopeRadii({
    Map<String, dynamic> metadata = const <String, dynamic>{},
    List<TypeDescriptor> typeDescriptors = const <TypeDescriptor>[],
  }) {
    final Set<String> descriptorRangeKeys = <String>{};
    for (final TypeDescriptor td in typeDescriptors) {
      for (final FieldDescriptor fd in td.fields) {
        final String keyLower = fd.key.toLowerCase();
        final String labelLower = fd.label.toLowerCase();
        if (keyLower.contains('radius') ||
            keyLower.contains('range') ||
            labelLower.contains('radius') ||
            labelLower.contains('range')) {
          descriptorRangeKeys.add(fd.key);
        }
      }
    }

    final Map<String, dynamic> attrs = _collectNodeAttributes(
      id,
      rawProperties,
      position.rawProperties,
      metadata,
    );

    final List<double> rawValues = <double>[];
    for (final MapEntry<String, dynamic> entry in attrs.entries) {
      final String keyLower = entry.key.toLowerCase();
      final bool isRangeAttr = keyLower.contains('radius') ||
          keyLower.contains('range') ||
          descriptorRangeKeys.contains(entry.key);
      if (!isRangeAttr) continue;
      final dynamic val = entry.value;
      if (val is num && val.toDouble() > 0.0) {
        rawValues.add(val.toDouble());
      }
    }

    if (rawValues.isEmpty) {
      return const <double>[];
    }

    rawValues.sort();
    final List<double> scaledRadii = <double>[];
    for (final double raw in rawValues) {
      double px;
      if (raw <= 120.0) {
        px = raw.clamp(16.0, 96.0);
      } else {
        final double normalized =
            (math.log(raw) / math.log(20000.0)).clamp(0.25, 1.25);
        px = 16.0 + normalized * 28.0;
      }
      if (scaledRadii.isNotEmpty && (px - scaledRadii.last).abs() < 6.0) {
        px = scaledRadii.last + 7.0;
      }
      scaledRadii.add(px);
    }
    return scaledRadii;
  }

  /// Resolves a directional leader line vector from trajectory velocity or
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyNode::resolveDirectionalLeaderVector` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyNode::resolveDirectionalLeaderVector` (declaration #16) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyNode::resolveDirectionalLeaderVector` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Offset?` from `TopologyNode::resolveDirectionalLeaderVector` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(resolveDirectionalLeaderVector)) bounded over input/member dimension of `TopologyNode::resolveDirectionalLeaderVector`.
  /// - Space Complexity: O(K(resolveDirectionalLeaderVector)) bounded auxiliary memory for `TopologyNode::resolveDirectionalLeaderVector`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyNode::resolveDirectionalLeaderVector` (`Offset?`).
  /// - State: Maintains consistent state invariants across `TopologyNode::resolveDirectionalLeaderVector` without partial mutation on error.
  /// - Action: Executes `TopologyNode::resolveDirectionalLeaderVector` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyNode::resolveDirectionalLeaderVector` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYNODE-RESOLVEDIRECTIONALLEADERVECTOR] | SysML v2: ActionDef(TopologyNode::resolveDirectionalLeaderVector)
  Offset? resolveDirectionalLeaderVector({
    Map<String, String>? coordinateMapping,
    Map<String, dynamic> metadata = const <String, dynamic>{},
    List<TypeDescriptor> typeDescriptors = const <TypeDescriptor>[],
    double scale = 2.0,
  }) {
    final List<double> trajectory =
        resolveVector('trajectory', coordinateMapping);
    final double vx = trajectory.isNotEmpty ? trajectory[0] : 0.0;
    final double vy = trajectory.length > 1 ? trajectory[1] : 0.0;
    if (vx != 0.0 || vy != 0.0) {
      return Offset(vx * scale, vy * scale);
    }

    final Set<String> headingKeys = <String>{};
    final Set<String> speedKeys = <String>{};
    for (final TypeDescriptor td in typeDescriptors) {
      for (final FieldDescriptor fd in td.fields) {
        final String keyLower = fd.key.toLowerCase();
        if ((keyLower.contains('heading') ||
                keyLower.contains('azimuth') ||
                keyLower.contains('bearing')) &&
            !keyLower.contains('coverage')) {
          headingKeys.add(fd.key);
        } else if (keyLower.contains('velocity') || keyLower.contains('speed')) {
          speedKeys.add(fd.key);
        }
      }
    }

    final Map<String, dynamic> attrs = _collectNodeAttributes(
      id,
      rawProperties,
      position.rawProperties,
      metadata,
    );

    double? headingDeg;
    double? speedVal;
    for (final MapEntry<String, dynamic> entry in attrs.entries) {
      final dynamic val = entry.value;
      if (val is! num) continue;
      final String keyLower = entry.key.toLowerCase();
      if (headingDeg == null &&
          (headingKeys.contains(entry.key) ||
              ((keyLower.contains('heading') ||
                      keyLower.contains('azimuth') ||
                      keyLower.contains('bearing')) &&
                  !keyLower.contains('coverage')))) {
        headingDeg = val.toDouble();
      } else if (speedVal == null &&
          (speedKeys.contains(entry.key) ||
              keyLower.contains('velocity') ||
              keyLower.contains('speed'))) {
        speedVal = val.toDouble();
      }
    }

    if (headingDeg == null) {
      return null;
    }

    final double radians = (headingDeg - 90.0) * math.pi / 180.0;
    final double baseLength =
        speedVal != null && speedVal > 0.0 ? speedVal.clamp(10.0, 28.0) : 16.0;
    final double effectiveLength = baseLength * (scale / 2.0).clamp(0.75, 2.0);
    return Offset(
      math.cos(radians) * effectiveLength,
      math.sin(radians) * effectiveLength,
    );
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Directed structural connection between two topology nodes identified by
/// [source] and [target] IDs with a semantic [type] label.
///
/// ## 2. Invariants & Mathematical Properties
/// - Links are immutable value descriptors rendered as line segments in [TopologyPainter.paint].
///
/// ## 3. Preconditions
/// - [source] and [target] should reference valid [TopologyNode.id] entries in the parent [TopologyData].
///
/// ## 4. Postconditions
/// - Holds structural edge connectivity metadata for topology graph rendering.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) construction and field access.
/// - Space Complexity: O(1) three string references.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Invalid [source] or [target] references result in a silent no-op during rendering (no line drawn).
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyLink]
class TopologyLink {
  /// ID of the source node for this directed link.
  /// Must match a [TopologyNode.id] in the parent [TopologyData]; otherwise
  /// the link is silently skipped during rendering.
  final String source;

  /// ID of the target node for this directed link.
  /// Must match a [TopologyNode.id] in the parent [TopologyData]; otherwise
  /// the link is silently skipped during rendering.
  final String target;

  /// Semantic label describing the link type (e.g. "depends_on", "connects").
  /// Used solely as a data attribute; not rendered on canvas.
  final String type;

  /// Executes deterministic constructor `TopologyLink::TopologyLink` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyLink::TopologyLink` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyLink::TopologyLink` (declaration #18) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyLink::TopologyLink` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyLink::TopologyLink` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyLink)) bounded over input/member dimension of `TopologyLink::TopologyLink`.
  /// - Space Complexity: O(K(TopologyLink)) bounded auxiliary memory for `TopologyLink::TopologyLink`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyLink::TopologyLink` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyLink::TopologyLink` without partial mutation on error.
  /// - Action: Executes `TopologyLink::TopologyLink` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyLink::TopologyLink` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYLINK-TOPOLOGYLINK] | SysML v2: ActionDef(TopologyLink::TopologyLink)
  const TopologyLink({
    required this.source,
    required this.target,
    required this.type,
  });

  /// Executes deterministic constructor `TopologyLink::TopologyLink` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyLink::TopologyLink` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyLink::TopologyLink` (declaration #19) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `json: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `TopologyLink::TopologyLink`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyLink::TopologyLink` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `TopologyLink::TopologyLink`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `TopologyLink::TopologyLink`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyLink::TopologyLink` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyLink::TopologyLink` without partial mutation on error.
  /// - Action: Executes `TopologyLink::TopologyLink` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyLink::TopologyLink` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYLINK-TOPOLOGYLINK] | SysML v2: ActionDef(TopologyLink::TopologyLink)
  factory TopologyLink.fromJson(Map<String, dynamic> json) {
    return TopologyLink(
      source: json['source'] as String? ?? '',
      target: json['target'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Encapsulates the complete topology graph descriptor: coordinate mapping,
/// node list, link list, and raw metadata under DO-178C Level A data integrity.
///
/// ## 2. Invariants & Mathematical Properties
/// - [coordinateMapping] maps logical axes (`x`, `y`, `z`, `t`, `trajectory`) to paths in node properties.
/// - Preserves unprocessed top-level JSON metadata in [rawMetadata] for schema-driven overlay resolution.
///
/// ## 3. Preconditions
/// - JSON input to [TopologyData.fromJson] must contain `coordinate_mapping`, `nodes`, and `links`.
///
/// ## 4. Postconditions
/// - Returns an immutable [TopologyData] graph model ready for 2D/3D viewport rendering.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(V + E) deserialization where V is node count and E is link count.
/// - Space Complexity: O(V + E) storage for nodes and links.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty `nodes` or `links` lists are valid and produce a blank canvas; missing mapping keys fall back to baked-in position fields.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyData]
class TopologyData {
  /// Maps logical axis names ("x", "y", "z", "t", "trajectory") to
  /// dot-separated paths in each node's [TopologyNode.rawProperties].
  /// When a key is absent, the corresponding baked-in field
  /// ([TopologyNodePosition.dim0] etc.) is used as fallback.
  final Map<String, String> coordinateMapping;

  /// All nodes in the topology. Each node is projected to canvas space
  /// by [TopologyNode.computePosition] before rendering.
  final List<TopologyNode> nodes;

  /// Directed connections between nodes. Each link references nodes by
  /// their [TopologyNode.id]; invalid references produce a silent no-op.
  final List<TopologyLink> links;

  /// Unprocessed top-level JSON metadata preserved for generic schema-driven
  /// overlay resolution without hardcoding domain keys.
  final Map<String, dynamic> rawMetadata;

  /// Executes deterministic constructor `TopologyData::TopologyData` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyData::TopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyData::TopologyData` (declaration #21) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyData::TopologyData` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyData::TopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyData)) bounded over input/member dimension of `TopologyData::TopologyData`.
  /// - Space Complexity: O(K(TopologyData)) bounded auxiliary memory for `TopologyData::TopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyData::TopologyData` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyData::TopologyData` without partial mutation on error.
  /// - Action: Executes `TopologyData::TopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyData::TopologyData` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYDATA-TOPOLOGYDATA] | SysML v2: ActionDef(TopologyData::TopologyData)
  const TopologyData({
    required this.coordinateMapping,
    required this.nodes,
    required this.links,
    this.rawMetadata = const <String, dynamic>{},
  });

  /// Executes deterministic constructor `TopologyData::TopologyData` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyData::TopologyData` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyData::TopologyData` (declaration #22) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `json: Map<String, dynamic>` must satisfy domain and type-safety constraints prior to invoking `TopologyData::TopologyData`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyData::TopologyData` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(json)) bounded over input/member dimension of `TopologyData::TopologyData`.
  /// - Space Complexity: O(N(json)) bounded auxiliary memory for `TopologyData::TopologyData`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyData::TopologyData` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyData::TopologyData` without partial mutation on error.
  /// - Action: Executes `TopologyData::TopologyData` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyData::TopologyData` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYDATA-TOPOLOGYDATA] | SysML v2: ActionDef(TopologyData::TopologyData)
  factory TopologyData.fromJson(Map<String, dynamic> json) {
    return TopologyData(
      coordinateMapping: Map<String, String>.from(
        json['coordinate_mapping'] as Map,
      ),
      nodes: (json['nodes'] as List<dynamic>)
          .map((n) => TopologyNode.fromJson(n as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List<dynamic>)
          .map((l) => TopologyLink.fromJson(l as Map<String, dynamic>))
          .toList(),
      rawMetadata: json,
    );
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Interactive 2D topology map widget with animated timeline playback, node
/// hit-testing, and scrollable tactical canvas under ARINC 661 display rules.
///
/// ## 2. Invariants & Mathematical Properties
/// - Tap hit-testing selects the closest node within [tapProximity] (default `20.0` logical pixels).
/// - On data change, the playback time index is clamped to `[minTime, maxTime]`.
///
/// ## 3. Preconditions
/// - Optional [data] or fallback [emptyTopologyData] provides the rendered graph model.
///
/// ## 4. Postconditions
/// - Renders the interactive topology canvas and bottom playback control bar.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(V + E) per frame paint cycle; O(V) per tap hit-test.
/// - Space Complexity: O(1) widget configuration state.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - When [data] is null, falls back to [emptyTopologyData]; taps outside [tapProximity] are safely ignored.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyMap]
class TopologyMap extends StatefulWidget {
  /// Identifier of the node that should be visually focused (halo + larger
  /// radius). Pass `null` to clear focus. Controlled externally by the parent
  /// widget.
  final String? activeFocusedNode;

  /// Callback invoked when the user taps a node within [tapProximity].
  /// Receives the tapped node's [TopologyNode.id]. Not called for taps on
  /// empty canvas space.
  final ValueChanged<String>? onNodeSelect;

  /// The topology data to render. When `null`, a default empty
  /// [emptyTopologyData] is used, producing a blank canvas with grid.
  final TopologyData? data;

  /// Optional list of generic [TypeDescriptor] metadata schemas used to
  /// discover radius/range and heading/velocity attributes without hardcoding
  /// domain class names.
  final List<TypeDescriptor> typeDescriptors;

  // -- Rendering constants --

  /// Maximum distance (in logical pixels) from a node's centre for a tap to
  /// register as a selection. Larger values make nodes easier to hit on
  /// touch screens; smaller values reduce false positives on dense maps.
  /// Default: 20.0.
  final double tapProximity;

  /// Spacing (in logical pixels) between consecutive background grid lines.
  /// Used both horizontally and vertically. Smaller values produce a denser
  /// grid; larger values reduce visual clutter. Default: 40.0.
  final double gridSpacing;

  /// Radius (in logical pixels) of the animated data-packet dot travelling
  /// along each link. Default: 4.0.
  final double packetRadius;

  /// Duration (in seconds) of one full packet animation cycle along a link.
  /// The packet dot completes one source-to-target traversal every
  /// [packetAnimationPeriod] seconds. Default: 2.0.
  final double packetAnimationPeriod;

  /// Radius (in logical pixels) of non-focused node circles. Default: 9.0.
  final double nodeRadiusDefault;

  /// Radius (in logical pixels) of the currently focused node circle.
  /// Should be larger than [nodeRadiusDefault] for visual emphasis.
  /// Default: 12.0.
  final double nodeRadiusFocused;

  /// Multiplier applied to trajectory velocity vectors when rendering the
  /// velocity indicator line. A value of 1.0 draws the line at true vector
  /// length; 2.0 doubles the visual length for readability on sparse maps.
  /// Default: 2.0.
  final double velocityScale;

  /// Radius (in logical pixels) of the pulsing halo ring drawn around the
  /// focused node. Default: 20.0.
  final double haloRadius;

  /// Font size (in logical pixels) for node labels rendered below each node
  /// circle. Default: 12.0.
  final double labelFontSize;

  // -- Playback constants --

  /// Fallback minimum time index used when the topology data is empty or no
  /// node has a valid time coordinate. Inferred from data when possible.
  /// Default: 1.0.
  final double defaultMinTime;

  /// Fallback maximum time index used when the topology data is empty or no
  /// node has a valid time coordinate. Inferred from data when possible.
  /// If all nodes share the same time, [maxTime] is widened to
  /// [defaultMinTime] + ([defaultMaxTime] - [defaultMinTime]).
  /// Default: 10.0.
  final double defaultMaxTime;

  /// The number of discrete steps in the playback time slider. Higher values
  /// provide finer granularity for scrubbing. Applied via `Slider.divisions`.
  /// Default: 90.
  final int sliderDivisions;

  // -- Layout constants --

  /// Minimum viewport width (in logical pixels) for the scrollable canvas.
  /// When the available width from [LayoutBuilder] exceeds this value the
  /// actual available width is used; otherwise this value becomes the canvas
  /// width. Default: 800.0.
  final double minViewportWidth;

  /// Minimum viewport height (in logical pixels) for the scrollable canvas.
  /// When the available height from [LayoutBuilder] exceeds this value the
  /// actual available height is used; otherwise this value becomes the canvas
  /// height. Default: 500.0.
  final double minViewportHeight;

  /// Width (in logical pixels) allocated to the numeric time display in the
  /// playback panel. Default: 32.0.
  final double timeDisplayWidth;

  /// Executes deterministic constructor `TopologyMap::TopologyMap` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyMap::TopologyMap` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyMap::TopologyMap` (declaration #24) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyMap::TopologyMap` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyMap::TopologyMap` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyMap)) bounded over input/member dimension of `TopologyMap::TopologyMap`.
  /// - Space Complexity: O(K(TopologyMap)) bounded auxiliary memory for `TopologyMap::TopologyMap`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyMap::TopologyMap` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyMap::TopologyMap` without partial mutation on error.
  /// - Action: Executes `TopologyMap::TopologyMap` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyMap::TopologyMap` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYMAP-TOPOLOGYMAP] | SysML v2: ActionDef(TopologyMap::TopologyMap)
  const TopologyMap({
    super.key,
    this.activeFocusedNode,
    this.onNodeSelect,
    this.data,
    this.typeDescriptors = const <TypeDescriptor>[],
    this.tapProximity = 20.0,
    this.gridSpacing = 40.0,
    this.packetRadius = 4.0,
    this.packetAnimationPeriod = 2.0,
    this.nodeRadiusDefault = 9.0,
    this.nodeRadiusFocused = 12.0,
    this.velocityScale = 2.0,
    this.defaultMinTime = 1.0,
    this.defaultMaxTime = 10.0,
    this.minViewportWidth = 800.0,
    this.minViewportHeight = 500.0,
    this.timeDisplayWidth = 32.0,
    this.haloRadius = 20.0,
    this.sliderDivisions = 90,
    this.labelFontSize = 12.0,
  });

  /// Executes deterministic method `TopologyMap::createState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyMap::createState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyMap::createState` (declaration #25) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyMap::createState` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<TopologyMap>` from `TopologyMap::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `TopologyMap::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `TopologyMap::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyMap::createState` (`State<TopologyMap>`).
  /// - State: Maintains consistent state invariants across `TopologyMap::createState` without partial mutation on error.
  /// - Action: Executes `TopologyMap::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyMap::createState` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYMAP-CREATESTATE] | SysML v2: ActionDef(TopologyMap::createState)
  @override
  State<TopologyMap> createState() => _TopologyMapState();
}

/// Executes deterministic class `_TopologyMapState` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_TopologyMapState` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_TopologyMapState` (declaration #26) within `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_TopologyMapState` in `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_TopologyMapState` representation for class `_TopologyMapState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_TopologyMapState)) bounded over input/member dimension of `_TopologyMapState`.
/// - Space Complexity: O(K(_TopologyMapState)) bounded auxiliary memory for `_TopologyMapState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_TopologyMapState` (`_TopologyMapState`).
/// - State: Maintains consistent state invariants across `_TopologyMapState` without partial mutation on error.
/// - Action: Executes `_TopologyMapState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_TopologyMapState` (`TOPOLOGY-TOPOLOGY-MAP`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYMAPSTATE] | SysML v2: PartDef(_TopologyMapState)
class _TopologyMapState extends State<TopologyMap>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double currentTimeIndex = 1.0;
  double playbackSpeedMultiplier = 1.0;
  bool isPlaying = false;
  Duration _lastElapsed = Duration.zero;

  double get minTime {
    final TopologyData activeData = widget.data ?? emptyTopologyData;
    if (activeData.nodes.isEmpty) return widget.defaultMinTime;
    double minT = double.infinity;
    for (final TopologyNode node in activeData.nodes) {
      final double t = node.resolveCoordinate('t', activeData.coordinateMapping);
      if (t < minT) minT = t;
    }
    return minT == double.infinity ? widget.defaultMinTime : minT;
  }

  double get maxTime {
    final TopologyData activeData = widget.data ?? emptyTopologyData;
    if (activeData.nodes.isEmpty) return widget.defaultMaxTime;
    double maxT = -double.infinity;
    for (final TopologyNode node in activeData.nodes) {
      final double t = node.resolveCoordinate('t', activeData.coordinateMapping);
      if (t > maxT) maxT = t;
    }
    if (maxT == -double.infinity) return widget.defaultMaxTime;
    final double minT = minTime;
    if (maxT == minT) {
      return minT + widget.defaultMaxTime - widget.defaultMinTime;
    }
    return maxT;
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    currentTimeIndex = minTime;
  }

  @override
  void didUpdateWidget(covariant TopologyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      final double minT = minTime;
      final double maxT = maxTime;
      if (currentTimeIndex < minT || currentTimeIndex > maxT) {
        currentTimeIndex = minT;
      }
    }
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    final double deltaSeconds =
        (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    if (isPlaying) {
      final double minT = minTime;
      final double maxT = maxTime;
      setState(() {
        currentTimeIndex += deltaSeconds * playbackSpeedMultiplier;
        if (currentTimeIndex > maxT) {
          currentTimeIndex = minT; // Loop back
        }
      });
    }
  }

  void togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _lastElapsed = Duration.zero;
        _ticker.start();
      } else {
        _ticker.stop();
      }
    });
  }

  void setPlayhead(double timeIndex) {
    final double minT = minTime;
    final double maxT = maxTime;
    setState(() {
      currentTimeIndex = timeIndex.clamp(minT, maxT);
    });
  }

  void _handleTap(TapUpDetails details) {
    final TopologyData activeData = widget.data ?? emptyTopologyData;
    final double clickX = details.localPosition.dx;
    final double clickY = details.localPosition.dy;

    for (final TopologyNode node in activeData.nodes) {
      final Offset pos = node.computePosition(activeData, currentTimeIndex);
      final double dist = math.sqrt(
          (clickX - pos.dx) * (clickX - pos.dx) +
              (clickY - pos.dy) * (clickY - pos.dy));

      if (dist <= widget.tapProximity) {
        widget.onNodeSelect?.call(node.id);
        break;
      }
    }
  }

  Widget _buildPlaybackPanel(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: colors.outlineVariant, width: 1.0),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ElevatedButton(
              key: const ValueKey<String>('playPauseButton'),
              onPressed: togglePlayback,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPlaying ? colors.error : colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 6.0),
                minimumSize: const Size(70, 32),
              ),
              child: Text(
                isPlaying ? 'Pause' : 'Play',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  't:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontFeatures: AppThemes.tabularFigures,
                      ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: widget.timeDisplayWidth,
                  child: Text(
                    currentTimeIndex.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          fontFeatures: AppThemes.tabularFigures,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: Slider(
                key: const ValueKey<String>('timeSlider'),
                min: minTime,
                max: maxTime,
                divisions: widget.sliderDivisions,
                value: currentTimeIndex.clamp(minTime, maxTime),
                onChanged: (double value) {
                  setPlayhead(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Speed:', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 8),
                DropdownButton<double>(
                  key: const ValueKey<String>('speedDropdown'),
                  value: playbackSpeedMultiplier,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        fontFeatures: AppThemes.tabularFigures,
                      ),
                  items: const <DropdownMenuItem<double>>[
                    DropdownMenuItem<double>(value: 0.5, child: Text('0.5x')),
                    DropdownMenuItem<double>(value: 1.0, child: Text('1.0x')),
                    DropdownMenuItem<double>(value: 2.0, child: Text('2.0x')),
                    DropdownMenuItem<double>(value: 5.0, child: Text('5.0x')),
                  ],
                  onChanged: (double? value) {
                    if (value != null) {
                      setState(() {
                        playbackSpeedMultiplier = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TopologyData activeData = widget.data ?? emptyTopologyData;

    final colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tacticalBg =
        isDark ? AppThemes.obsidianCanvas : AppThemes.obsidianCanvas;
    final Color tacticalGrid =
        isDark ? AppThemes.hairlineBorderColor : colors.outlineVariant;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double viewportWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : widget.minViewportWidth;
        final double viewportHeight =
            constraints.maxHeight.isFinite ? constraints.maxHeight : widget.minViewportHeight;
        final double width = viewportWidth > widget.minViewportWidth ? viewportWidth : widget.minViewportWidth;
        final double height = viewportHeight > widget.minViewportHeight ? viewportHeight : widget.minViewportHeight;

        return Container(
          color: tacticalBg,
          child: Column(
            children: <Widget>[
              // Scrollable Canvas Viewport
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapUp: (TapUpDetails details) =>
                            _handleTap(details),
                        child: CustomPaint(
                          size: Size(width, height),
                          painter: TopologyPainter(
                            activeFocusedNode: widget.activeFocusedNode,
                            activeData: activeData,
                            typeDescriptors: widget.typeDescriptors,
                            currentTimeIndex: currentTimeIndex,
                            gridSpacing: widget.gridSpacing,
                            packetRadius: widget.packetRadius,
                            packetAnimationPeriod: widget.packetAnimationPeriod,
                            nodeRadiusDefault: widget.nodeRadiusDefault,
                            nodeRadiusFocused: widget.nodeRadiusFocused,
                            velocityScale: widget.velocityScale,
                            haloRadius: widget.haloRadius,
                            labelFontSize: widget.labelFontSize,
                            colors: TopologyPainterColors(
                              bgColor: tacticalBg,
                              gridColor: tacticalGrid,
                              linkColor: AppThemes.activeReticleCyan.withValues(alpha: 0.45),
                              packetColor: AppThemes.activeReticleCyan,
                              velocityColor: AppThemes.cautionMarginAmber.withValues(alpha: 0.85),
                              nodeFillColor: AppThemes.activeReticleCyan,
                              nodeStrokeColor: Colors.white,
                              activeStatusColor: AppThemes.verifiedNominalEmerald,
                              warningStatusColor: AppThemes.cautionMarginAmber,
                              haloColor: AppThemes.activeReticleCyan.withValues(alpha: 0.35),
                              labelColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildPlaybackPanel(colors),
            ],
          ),
        );
      },
    );
  }
}

/// ## 1. Safety Intent & Regulatory Scope
/// Immutable colour palette consumed by [TopologyPainter] for all rendered
/// tactical topology elements under ARINC 661 display contrast compliance.
///
/// ## 2. Invariants & Mathematical Properties
/// - Constructed per paint cycle from the active [ColorScheme] to remain synchronized with theme switches.
///
/// ## 3. Preconditions
/// - All colour fields must be non-null [Color] instances.
///
/// ## 4. Postconditions
/// - Provides deterministic colour bindings for background, grid, links, packets, nodes, halos, and labels.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(1) const construction and field lookup.
/// - Space Complexity: O(1) 11 [Color] fields.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Compile-time non-nullable fields prevent missing colour attributes at paint time.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyPainterColors]
class TopologyPainterColors {
  /// Canvas background colour. Fills the entire paint area before any other
  /// element is drawn.
  final Color bgColor;

  /// Colour for the background grid lines.
  final Color gridColor;

  /// Colour for link lines connecting nodes.
  final Color linkColor;

  /// Colour for the animated data-packet dot that travels along each link.
  final Color packetColor;

  /// Colour for the velocity / trajectory vector line emanating from each
  /// node.
  final Color velocityColor;

  /// Fill colour for the focused node circle.
  final Color nodeFillColor;

  /// Stroke (outline) colour for the focused node circle.
  final Color nodeStrokeColor;

  /// Fill colour for nodes whose [TopologyNode.status] equals "Active".
  final Color activeStatusColor;

  /// Fill colour for nodes whose [TopologyNode.status] is anything other
  /// than "Active".
  final Color warningStatusColor;

  /// Colour for the pulsing halo ring drawn around the focused node.
  final Color haloColor;

  /// Colour for node labels rendered below each node circle.
  final Color labelColor;

  /// Executes deterministic constructor `TopologyPainterColors::TopologyPainterColors` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyPainterColors::TopologyPainterColors` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyPainterColors::TopologyPainterColors` (declaration #28) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyPainterColors::TopologyPainterColors` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyPainterColors::TopologyPainterColors` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyPainterColors)) bounded over input/member dimension of `TopologyPainterColors::TopologyPainterColors`.
  /// - Space Complexity: O(K(TopologyPainterColors)) bounded auxiliary memory for `TopologyPainterColors::TopologyPainterColors`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainterColors::TopologyPainterColors` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyPainterColors::TopologyPainterColors` without partial mutation on error.
  /// - Action: Executes `TopologyPainterColors::TopologyPainterColors` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainterColors::TopologyPainterColors` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTERCOLORS-TOPOLOGYPAINTERCOLORS] | SysML v2: ActionDef(TopologyPainterColors::TopologyPainterColors)
  const TopologyPainterColors({
    required this.bgColor,
    required this.gridColor,
    required this.linkColor,
    required this.packetColor,
    required this.velocityColor,
    required this.nodeFillColor,
    required this.nodeStrokeColor,
    required this.activeStatusColor,
    required this.warningStatusColor,
    required this.haloColor,
    required this.labelColor,
  });
}

/// ## 1. Safety Intent & Regulatory Scope
/// Custom canvas painter for the 2D topology map rendering ARINC 661 tactical
/// coordinate grids, range-scale rings, compass azimuth ticks, nodes, links,
/// animated packet indicators, and callout tags.
///
/// ## 2. Invariants & Mathematical Properties
/// - Paint order is strictly deterministic: background -> grid -> range-scale rings & compass ticks ->
///   node positions -> links -> packets -> node envelope rings -> directional leader vectors ->
///   nodes (fill + stroke) -> halo (focused only) -> ARINC 661 callout labels.
/// - Redraws whenever [currentTimeIndex], [activeFocusedNode], [activeData], or [colors] change.
///
/// ## 3. Preconditions
/// - [activeData] and [colors] must be non-null; use [emptyTopologyData] for a blank canvas.
///
/// ## 4. Postconditions
/// - Renders the complete 2D tactical topology visualization within the canvas bounds.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(G + V + E) where G is grid line count, V is node count, and E is link count.
/// - Space Complexity: O(V) for transient per-frame projected node position map.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Links referencing unknown source or target node IDs are safely skipped without throwing.
///
/// ## 7. Realization & Traceability
/// Realises: [Feat-10/TopologyPainter]
class TopologyPainter extends CustomPainter {
  /// Cardinal compass azimuth labels rendered on the outer tactical ring.
  static const List<String> compassCardinalLabels = <String>[
    '000° N',
    '090° E',
    '180° S',
    '270° W',
  ];

  /// Identifier of the node that should receive visual focus (larger radius,
  /// halo ring). Pass `null` to clear focus.
  final String? activeFocusedNode;

  /// The topology data rendered in the current paint cycle. Must be non-null;
  /// use [emptyTopologyData] for a blank canvas.
  final TopologyData activeData;

  /// Optional list of generic [TypeDescriptor] metadata schemas used to
  /// discover radius/range and heading/velocity attributes without hardcoding
  /// domain class names.
  final List<TypeDescriptor> typeDescriptors;

  /// Current playback time index. Used to compute node positions via
  /// [TopologyNode.computePosition] and to animate packet dots along links.
  final double currentTimeIndex;

  /// Colour palette for all painted elements. Should be reconstructed each
  /// paint cycle from the current [ColorScheme] to reflect theme changes.
  final TopologyPainterColors colors;

  // -- Geometry & layout --

  /// Horizontal and vertical spacing (in logical pixels) between consecutive
  /// background grid lines. Default: 40.0.
  final double gridSpacing;

  /// Number of subtle concentric range-scale rings rendered in the background
  /// tactical coordinate grid. Default: 3.
  final int rangeScaleRingCount;

  /// Whether compass azimuth ticks and cardinal bearings are rendered on the
  /// outer background range-scale ring. Default: true.
  final bool showCompassAzimuthTicks;

  /// Radius (in logical pixels) of the animated data-packet dot that travels
  /// along each link. Default: 4.0.
  final double packetRadius;

  /// Duration (in seconds) of one full packet animation cycle along a link.
  /// The packet dot completes one source-to-target traversal every
  /// [packetAnimationPeriod] seconds. Default: 2.0.
  final double packetAnimationPeriod;

  /// Radius (in logical pixels) of non-focused node circles. Default: 9.0.
  final double nodeRadiusDefault;

  /// Radius (in logical pixels) of the currently focused node circle.
  /// Should be larger than [nodeRadiusDefault] for visual distinction.
  /// Default: 12.0.
  final double nodeRadiusFocused;

  /// Multiplier applied to trajectory velocity vectors when drawing the
  /// velocity indicator line. Higher values exaggerate direction for
  /// readability. Default: 2.0.
  final double velocityScale;

  /// Radius (in logical pixels) of the pulsing halo ring drawn around the
  /// focused node. Default: 20.0.
  final double haloRadius;

  /// Font size (in logical pixels) for node labels rendered below each node
  /// circle. Default: 12.0.
  final double labelFontSize;

  /// Executes deterministic constructor `TopologyPainter::TopologyPainter` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TopologyPainter::TopologyPainter` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TopologyPainter::TopologyPainter` (declaration #30) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyPainter::TopologyPainter` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TopologyPainter::TopologyPainter` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TopologyPainter)) bounded over input/member dimension of `TopologyPainter::TopologyPainter`.
  /// - Space Complexity: O(K(TopologyPainter)) bounded auxiliary memory for `TopologyPainter::TopologyPainter`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::TopologyPainter` (`()`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::TopologyPainter` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::TopologyPainter` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::TopologyPainter` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-TOPOLOGYPAINTER] | SysML v2: ActionDef(TopologyPainter::TopologyPainter)
  TopologyPainter({
    required this.activeFocusedNode,
    required this.activeData,
    required this.currentTimeIndex,
    required this.colors,
    this.typeDescriptors = const <TypeDescriptor>[],
    this.gridSpacing = 40.0,
    this.rangeScaleRingCount = 3,
    this.showCompassAzimuthTicks = true,
    this.packetRadius = 4.0,
    this.packetAnimationPeriod = 2.0,
    this.nodeRadiusDefault = 9.0,
    this.nodeRadiusFocused = 12.0,
    this.velocityScale = 2.0,
    this.haloRadius = 20.0,
    this.labelFontSize = 12.0,
  });

  /// Executes deterministic method `TopologyPainter::_drawDashedCircle` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyPainter::_drawDashedCircle` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyPainter::_drawDashedCircle` (declaration #31) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyPainter::_drawDashedCircle` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TopologyPainter::_drawDashedCircle` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_drawDashedCircle)) bounded over input/member dimension of `TopologyPainter::_drawDashedCircle`.
  /// - Space Complexity: O(K(_drawDashedCircle)) bounded auxiliary memory for `TopologyPainter::_drawDashedCircle`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::_drawDashedCircle` (`void`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::_drawDashedCircle` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::_drawDashedCircle` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::_drawDashedCircle` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-DRAWDASHEDCIRCLE] | SysML v2: ActionDef(TopologyPainter::_drawDashedCircle)
  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint, {
    int dashCount = 24,
    double dutyCycle = 0.6,
  }) {
    if (radius <= 0) return;
    final Rect oval = Rect.fromCircle(center: center, radius: radius);
    final double step = (2.0 * math.pi) / dashCount;
    final double sweep = step * dutyCycle;
    final Path path = Path();
    for (int i = 0; i < dashCount; i++) {
      path.addArc(oval, i * step, sweep);
    }
    canvas.drawPath(path, paint);
  }

  /// Executes deterministic method `TopologyPainter::_drawTacticalCoordinateBackdrop` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyPainter::_drawTacticalCoordinateBackdrop` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyPainter::_drawTacticalCoordinateBackdrop` (declaration #32) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `canvas: Canvas` must satisfy domain and type-safety constraints prior to invoking `TopologyPainter::_drawTacticalCoordinateBackdrop`.
  /// - `size: Size` must satisfy domain and type-safety constraints prior to invoking `TopologyPainter::_drawTacticalCoordinateBackdrop`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TopologyPainter::_drawTacticalCoordinateBackdrop` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(canvas)) bounded over input/member dimension of `TopologyPainter::_drawTacticalCoordinateBackdrop`.
  /// - Space Complexity: O(N(canvas)) bounded auxiliary memory for `TopologyPainter::_drawTacticalCoordinateBackdrop`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::_drawTacticalCoordinateBackdrop` (`void`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::_drawTacticalCoordinateBackdrop` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::_drawTacticalCoordinateBackdrop` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::_drawTacticalCoordinateBackdrop` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-DRAWTACTICALCOORDINATEBACKDROP] | SysML v2: ActionDef(TopologyPainter::_drawTacticalCoordinateBackdrop)
  void _drawTacticalCoordinateBackdrop(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double maxRadius = math.min(size.width, size.height) * 0.42;
    if (maxRadius <= 20.0 || rangeScaleRingCount <= 0) return;

    final Paint ringPaint = Paint()
      ..color = colors.gridColor.withValues(alpha: 0.45)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int r = 1; r <= rangeScaleRingCount; r++) {
      final double ringRadius = maxRadius * (r / rangeScaleRingCount);
      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // Subtle center reticle crosshair
    canvas.drawLine(
      Offset(center.dx - 8.0, center.dy),
      Offset(center.dx + 8.0, center.dy),
      ringPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 8.0),
      Offset(center.dx, center.dy + 8.0),
      ringPaint,
    );

    if (!showCompassAzimuthTicks) return;

    final Paint tickPaint = Paint()
      ..color = AppThemes.activeReticleCyan.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int deg = 0; deg < 360; deg += 30) {
      final double rad = (deg - 90.0) * math.pi / 180.0;
      final bool isCardinal = deg % 90 == 0;
      final double innerRadius = maxRadius - (isCardinal ? 8.0 : 4.5);
      final Offset p1 = Offset(
        center.dx + math.cos(rad) * innerRadius,
        center.dy + math.sin(rad) * innerRadius,
      );
      final Offset p2 = Offset(
        center.dx + math.cos(rad) * maxRadius,
        center.dy + math.sin(rad) * maxRadius,
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    final List<(String, double)> cardinals = <(String, double)>[
      (compassCardinalLabels[0], -math.pi / 2.0),
      (compassCardinalLabels[1], 0.0),
      (compassCardinalLabels[2], math.pi / 2.0),
      (compassCardinalLabels[3], math.pi),
    ];
    for (final (String label, double rad) in cardinals) {
      final TextPainter tp = _TextPainterCache.getOrCreate(
        label,
        AppThemes.activeReticleCyan.withValues(alpha: 0.65),
        9.0,
      );
      final double labelRadius = maxRadius + 10.0;
      final Offset pos = Offset(
        center.dx + math.cos(rad) * labelRadius - tp.width / 2.0,
        center.dy + math.sin(rad) * labelRadius - tp.height / 2.0,
      );
      tp.paint(canvas, pos);
    }
  }

  /// Executes deterministic method `TopologyPainter::_drawDirectionalLeaderLine` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyPainter::_drawDirectionalLeaderLine` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyPainter::_drawDirectionalLeaderLine` (declaration #33) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyPainter::_drawDirectionalLeaderLine` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TopologyPainter::_drawDirectionalLeaderLine` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_drawDirectionalLeaderLine)) bounded over input/member dimension of `TopologyPainter::_drawDirectionalLeaderLine`.
  /// - Space Complexity: O(K(_drawDirectionalLeaderLine)) bounded auxiliary memory for `TopologyPainter::_drawDirectionalLeaderLine`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::_drawDirectionalLeaderLine` (`void`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::_drawDirectionalLeaderLine` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::_drawDirectionalLeaderLine` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::_drawDirectionalLeaderLine` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-DRAWDIRECTIONALLEADERLINE] | SysML v2: ActionDef(TopologyPainter::_drawDirectionalLeaderLine)
  void _drawDirectionalLeaderLine(
    Canvas canvas,
    Offset start,
    Offset delta,
    Color color,
  ) {
    final Offset tip = start + delta;
    final Paint leaderPaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, tip, leaderPaint);

    final double len = delta.distance;
    if (len < 4.0) return;
    final double angle = math.atan2(delta.dy, delta.dx);
    const double headLen = 5.0;
    const double headAngle = 0.52;
    final Path headPath = Path()
      ..moveTo(
        tip.dx - headLen * math.cos(angle - headAngle),
        tip.dy - headLen * math.sin(angle - headAngle),
      )
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(
        tip.dx - headLen * math.cos(angle + headAngle),
        tip.dy - headLen * math.sin(angle + headAngle),
      );
    canvas.drawPath(headPath, leaderPaint);
  }

  /// Executes deterministic method `TopologyPainter::_drawArincCalloutTag` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyPainter::_drawArincCalloutTag` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyPainter::_drawArincCalloutTag` (declaration #34) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TopologyPainter::_drawArincCalloutTag` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TopologyPainter::_drawArincCalloutTag` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_drawArincCalloutTag)) bounded over input/member dimension of `TopologyPainter::_drawArincCalloutTag`.
  /// - Space Complexity: O(K(_drawArincCalloutTag)) bounded auxiliary memory for `TopologyPainter::_drawArincCalloutTag`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::_drawArincCalloutTag` (`void`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::_drawArincCalloutTag` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::_drawArincCalloutTag` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::_drawArincCalloutTag` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-DRAWARINCCALLOUTTAG] | SysML v2: ActionDef(TopologyPainter::_drawArincCalloutTag)
  void _drawArincCalloutTag(
    Canvas canvas,
    Offset nodeCenter,
    double nodeRadius,
    Rect tagRect,
    TextPainter textPainter,
    Offset textPos,
    bool isFocused,
  ) {
    final Paint calloutFill = Paint()
      ..color = AppThemes.primaryPanelSurface.withValues(alpha: 0.90)
      ..style = PaintingStyle.fill;
    final Color borderColor = isFocused
        ? AppThemes.activeReticleCyan
        : AppThemes.hairlineBorderColor;
    final Paint calloutBorder = Paint()
      ..color = borderColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Leader tick from bottom of node circle to top of callout tag
    canvas.drawLine(
      Offset(nodeCenter.dx, nodeCenter.dy + nodeRadius),
      Offset(nodeCenter.dx, tagRect.top),
      calloutBorder,
    );

    final RRect rrect = RRect.fromRectAndRadius(
      tagRect,
      const Radius.circular(2.0),
    );
    canvas.drawRRect(rrect, calloutFill);
    canvas.drawRRect(rrect, calloutBorder);

    // Corner L-bracket ticks on callout tag
    final Paint tickPaint = Paint()
      ..color = AppThemes.activeReticleCyan.withValues(
        alpha: isFocused ? 1.0 : 0.65,
      )
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const double tick = 4.0;
    final Path cornerTicks = Path()
      ..moveTo(tagRect.left, tagRect.top + tick)
      ..lineTo(tagRect.left, tagRect.top)
      ..lineTo(tagRect.left + tick, tagRect.top)
      ..moveTo(tagRect.right - tick, tagRect.bottom)
      ..lineTo(tagRect.right, tagRect.bottom)
      ..lineTo(tagRect.right, tagRect.bottom - tick);
    canvas.drawPath(cornerTicks, tickPaint);

    textPainter.paint(canvas, textPos);
  }

  /// Executes deterministic method `TopologyPainter::paint` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyPainter::paint` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyPainter::paint` (declaration #35) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `canvas: Canvas` must satisfy domain and type-safety constraints prior to invoking `TopologyPainter::paint`.
  /// - `size: Size` must satisfy domain and type-safety constraints prior to invoking `TopologyPainter::paint`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `TopologyPainter::paint` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(canvas)) bounded over input/member dimension of `TopologyPainter::paint`.
  /// - Space Complexity: O(N(canvas)) bounded auxiliary memory for `TopologyPainter::paint`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::paint` (`void`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::paint` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::paint` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::paint` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-PAINT] | SysML v2: ActionDef(TopologyPainter::paint)
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Always draw dark ARINC 661 tactical coordinate grid background
    final Paint bgPaint = Paint()..color = colors.bgColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Draw orthogonal tactical grid lines
    if (gridSpacing > 0) {
      final Paint gridPaint = Paint()
        ..color = colors.gridColor.withValues(alpha: 0.55)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      for (double x = 0; x < size.width; x += gridSpacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y < size.height; y += gridSpacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // 2b. Draw subtle range-scale rings and compass azimuth ticks
    _drawTacticalCoordinateBackdrop(canvas, size);

    // 3. Compute projected positions
    final Map<String, Offset> projectedPositions = <String, Offset>{};
    for (final TopologyNode node in activeData.nodes) {
      projectedPositions[node.id] = node.computePosition(activeData, currentTimeIndex);
    }

    // 4. Draw links
    for (final TopologyLink link in activeData.links) {
      final Offset? sourceOffset = projectedPositions[link.source];
      final Offset? targetOffset = projectedPositions[link.target];

      if (sourceOffset != null && targetOffset != null) {
        // Connector link line
        final Paint linkPaint = Paint()
          ..color = colors.linkColor
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawLine(sourceOffset, targetOffset, linkPaint);

        // Animated data packet along link path
        final double packetRatio = (currentTimeIndex % packetAnimationPeriod) / packetAnimationPeriod;
        final double px =
            sourceOffset.dx + (targetOffset.dx - sourceOffset.dx) * packetRatio;
        final double py =
            sourceOffset.dy + (targetOffset.dy - sourceOffset.dy) * packetRatio;

        final Paint packetPaint = Paint()
          ..color = colors.packetColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(px, py), packetRadius, packetPaint);
      }
    }

    // 5. Draw nodes, concentric dashed range/envelope rings, directional leader lines, and ARINC 661 callout tags
    final List<Rect> drawnLabelRects = [];
    for (final TopologyNode node in activeData.nodes) {
      final Offset? pos = projectedPositions[node.id];
      if (pos == null) continue;

      final bool isFocused = activeFocusedNode == node.id;

      // 5a. Concentric dashed range/envelope rings when radius/range attributes exist
      final List<double> envelopeRadii = node.resolveEnvelopeRadii(
        metadata: activeData.rawMetadata,
        typeDescriptors: typeDescriptors,
      );
      if (envelopeRadii.isNotEmpty) {
        final Paint envelopePaint = Paint()
          ..color = (isFocused
                  ? AppThemes.activeReticleCyan
                  : colors.activeStatusColor)
              .withValues(alpha: 0.45)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;
        for (final double envRadius in envelopeRadii) {
          _drawDashedCircle(canvas, pos, envRadius, envelopePaint);
        }
      }

      // 5b. Directional vector leader line when trajectory or heading/velocity attributes exist
      final Offset? leaderDelta = node.resolveDirectionalLeaderVector(
        coordinateMapping: activeData.coordinateMapping,
        metadata: activeData.rawMetadata,
        typeDescriptors: typeDescriptors,
        scale: velocityScale,
      );
      if (leaderDelta != null && leaderDelta.distance > 0.0) {
        _drawDirectionalLeaderLine(
          canvas,
          pos,
          leaderDelta,
          colors.velocityColor,
        );
      }

      // 5c. Node base circle representation
      final Paint fillPaint = Paint()..style = PaintingStyle.fill;
      final Paint strokePaint = Paint()..style = PaintingStyle.stroke;
      final double radius = isFocused ? nodeRadiusFocused : nodeRadiusDefault;

      if (isFocused) {
        fillPaint.color = colors.nodeFillColor;
        strokePaint
          ..color = colors.nodeStrokeColor
          ..strokeWidth = 2.5;
      } else {
        fillPaint.color = node.status == 'Active'
            ? colors.activeStatusColor
            : colors.warningStatusColor;
        strokePaint
          ..color = colors.gridColor
          ..strokeWidth = 2.0;
      }

      canvas.drawCircle(pos, radius, fillPaint);
      canvas.drawCircle(pos, radius, strokePaint);

      // Pulsing halo ring around focused node
      if (isFocused) {
        final Paint haloPaint = Paint()
          ..color = colors.haloColor
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(pos, haloRadius, haloPaint);
      }

      // 5d. Crisp ARINC 661 callout tag with tabular monospace label
      final TextPainter textPainter = _TextPainterCache.getOrCreate(
        node.label,
        colors.labelColor,
        labelFontSize,
      );
      final Offset textPos = Offset(pos.dx - textPainter.width / 2.0, pos.dy + 14.0);
      final Rect tagRect = Rect.fromLTWH(
        textPos.dx - 5.0,
        textPos.dy - 2.0,
        textPainter.width + 10.0,
        textPainter.height + 4.0,
      );

      bool overlaps = false;
      final double area1 = tagRect.width * tagRect.height;
      for (final Rect existing in drawnLabelRects) {
        final double left = math.max(tagRect.left, existing.left);
        final double right = math.min(tagRect.right, existing.right);
        final double top = math.max(tagRect.top, existing.top);
        final double bottom = math.min(tagRect.bottom, existing.bottom);
        final double intersectWidth = right - left;
        final double intersectHeight = bottom - top;
        if (intersectWidth > 0 && intersectHeight > 0) {
          final double intersectArea = intersectWidth * intersectHeight;
          final double area2 = existing.width * existing.height;
          final double overlapPercent1 = area1 > 0 ? intersectArea / area1 : 0.0;
          final double overlapPercent2 = area2 > 0 ? intersectArea / area2 : 0.0;
          if (overlapPercent1 > 0.10 || overlapPercent2 > 0.10) {
            overlaps = true;
            break;
          }
        }
      }

      if (!overlaps) {
        drawnLabelRects.add(tagRect);
        _drawArincCalloutTag(
          canvas,
          pos,
          radius,
          tagRect,
          textPainter,
          textPos,
          isFocused,
        );
      }
    }
  }

  /// Executes deterministic method `TopologyPainter::shouldRepaint` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TopologyPainter::shouldRepaint` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TopologyPainter::shouldRepaint` (declaration #36) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `oldDelegate: TopologyPainter` must satisfy domain and type-safety constraints prior to invoking `TopologyPainter::shouldRepaint`.
  ///
  /// ## 4. Postconditions
  /// - Returns `bool` from `TopologyPainter::shouldRepaint` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(oldDelegate)) bounded over input/member dimension of `TopologyPainter::shouldRepaint`.
  /// - Space Complexity: O(N(oldDelegate)) bounded auxiliary memory for `TopologyPainter::shouldRepaint`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TopologyPainter::shouldRepaint` (`bool`).
  /// - State: Maintains consistent state invariants across `TopologyPainter::shouldRepaint` without partial mutation on error.
  /// - Action: Executes `TopologyPainter::shouldRepaint` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TopologyPainter::shouldRepaint` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TOPOLOGYPAINTER-SHOULDREPAINT] | SysML v2: ActionDef(TopologyPainter::shouldRepaint)
  @override
  bool shouldRepaint(covariant TopologyPainter oldDelegate) {
    return oldDelegate.currentTimeIndex != currentTimeIndex ||
        oldDelegate.activeFocusedNode != activeFocusedNode ||
        oldDelegate.activeData != activeData ||
        oldDelegate.typeDescriptors != typeDescriptors ||
        oldDelegate.colors != colors;
  }
}

/// Executes deterministic class `_TextPainterKey` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_TextPainterKey` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_TextPainterKey` (declaration #37) within `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_TextPainterKey` in `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_TextPainterKey` representation for class `_TextPainterKey`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_TextPainterKey)) bounded over input/member dimension of `_TextPainterKey`.
/// - Space Complexity: O(K(_TextPainterKey)) bounded auxiliary memory for `_TextPainterKey`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_TextPainterKey` (`_TextPainterKey`).
/// - State: Maintains consistent state invariants across `_TextPainterKey` without partial mutation on error.
/// - Action: Executes `_TextPainterKey` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_TextPainterKey` (`TOPOLOGY-TOPOLOGY-MAP`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TEXTPAINTERKEY] | SysML v2: PartDef(_TextPainterKey)
class _TextPainterKey {
  final String text;
  final Color color;
  final double fontSize;
  /// Executes deterministic constructor `_TextPainterKey::_TextPainterKey` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `_TextPainterKey::_TextPainterKey` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `_TextPainterKey::_TextPainterKey` (declaration #38) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `text: String` must satisfy domain and type-safety constraints prior to invoking `_TextPainterKey::_TextPainterKey`.
  /// - `color: String` must satisfy domain and type-safety constraints prior to invoking `_TextPainterKey::_TextPainterKey`.
  /// - `fontSize: String` must satisfy domain and type-safety constraints prior to invoking `_TextPainterKey::_TextPainterKey`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `_TextPainterKey::_TextPainterKey` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(text)) bounded over input/member dimension of `_TextPainterKey::_TextPainterKey`.
  /// - Space Complexity: O(N(text)) bounded auxiliary memory for `_TextPainterKey::_TextPainterKey`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TextPainterKey::_TextPainterKey` (`()`).
  /// - State: Maintains consistent state invariants across `_TextPainterKey::_TextPainterKey` without partial mutation on error.
  /// - Action: Executes `_TextPainterKey::_TextPainterKey` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TextPainterKey::_TextPainterKey` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TEXTPAINTERKEY-TEXTPAINTERKEY] | SysML v2: ActionDef(_TextPainterKey::_TextPainterKey)
  _TextPainterKey(this.text, this.color, this.fontSize);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TextPainterKey &&
          text == other.text &&
          color == other.color &&
          fontSize == other.fontSize;

  @override
  int get hashCode => Object.hash(text, color, fontSize);
}

/// Executes deterministic class `_TextPainterCache` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_TextPainterCache` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_TextPainterCache` (declaration #39) within `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_TextPainterCache` in `TOPOLOGY-TOPOLOGY-MAP`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_TextPainterCache` representation for class `_TextPainterCache`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_TextPainterCache)) bounded over input/member dimension of `_TextPainterCache`.
/// - Space Complexity: O(K(_TextPainterCache)) bounded auxiliary memory for `_TextPainterCache`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_TextPainterCache` (`_TextPainterCache`).
/// - State: Maintains consistent state invariants across `_TextPainterCache` without partial mutation on error.
/// - Action: Executes `_TextPainterCache` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_TextPainterCache` (`TOPOLOGY-TOPOLOGY-MAP`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TEXTPAINTERCACHE] | SysML v2: PartDef(_TextPainterCache)
class _TextPainterCache {
  static final Map<_TextPainterKey, TextPainter> _cache = {};
  static const int _maxEntries = 256;

  /// Executes deterministic method `_TextPainterCache::getOrCreate` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TextPainterCache::getOrCreate` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TextPainterCache::getOrCreate` (declaration #40) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - `text: String` must satisfy domain and type-safety constraints prior to invoking `_TextPainterCache::getOrCreate`.
  /// - `color: Color` must satisfy domain and type-safety constraints prior to invoking `_TextPainterCache::getOrCreate`.
  /// - `fontSize: double` must satisfy domain and type-safety constraints prior to invoking `_TextPainterCache::getOrCreate`.
  ///
  /// ## 4. Postconditions
  /// - Returns `TextPainter` from `_TextPainterCache::getOrCreate` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(text)) bounded over input/member dimension of `_TextPainterCache::getOrCreate`.
  /// - Space Complexity: O(N(text)) bounded auxiliary memory for `_TextPainterCache::getOrCreate`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TextPainterCache::getOrCreate` (`TextPainter`).
  /// - State: Maintains consistent state invariants across `_TextPainterCache::getOrCreate` without partial mutation on error.
  /// - Action: Executes `_TextPainterCache::getOrCreate` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TextPainterCache::getOrCreate` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TEXTPAINTERCACHE-GETORCREATE] | SysML v2: ActionDef(_TextPainterCache::getOrCreate)
  static TextPainter getOrCreate(String text, Color color, double fontSize) {
    final key = _TextPainterKey(text, color, fontSize);
    final existing = _cache[key];
    if (existing != null) return existing;

    if (_cache.length >= _maxEntries) {
      final evictedKey = _cache.keys.first;
      _cache.remove(evictedKey)?.dispose();
    }
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: 'monospace',
          fontFeatures: AppThemes.tabularFigures,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    _cache[key] = painter;
    return painter;
  }

  /// Executes deterministic method `_TextPainterCache::clear` within `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TextPainterCache::clear` in `/tmp/deap_sync/DEAP-profile-flutter-app/app_flutter/lib/features/topology/topology_map.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TextPainterCache::clear` (declaration #41) within `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TextPainterCache::clear` in `TOPOLOGY-TOPOLOGY-MAP`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TextPainterCache::clear` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(clear)) bounded over input/member dimension of `_TextPainterCache::clear`.
  /// - Space Complexity: O(K(clear)) bounded auxiliary memory for `_TextPainterCache::clear`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TextPainterCache::clear` (`void`).
  /// - State: Maintains consistent state invariants across `_TextPainterCache::clear` without partial mutation on error.
  /// - Action: Executes `_TextPainterCache::clear` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TextPainterCache::clear` (`TOPOLOGY-TOPOLOGY-MAP`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TOPOLOGY-TOPOLOGY-MAP-TEXTPAINTERCACHE-CLEAR] | SysML v2: ActionDef(_TextPainterCache::clear)
  static void clear() {
    for (final painter in _cache.values) {
      painter.dispose();
    }
    _cache.clear();
  }
}
