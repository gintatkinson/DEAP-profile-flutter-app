import 'package:flutter/foundation.dart';
import 'package:app_flutter/domain/data_source.dart';
import 'package:app_flutter/domain/result.dart';
import 'package:app_flutter/domain/type_descriptor.dart';

/// Immutable value state container holding the active [TypeDescriptor] and most
/// recent operational action status for the ARINC 661 properties panel.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Guarantees value-immutable state
///   snapshots across asynchronous schema type loads and operator use case
///   actuations (`UC-03`, `UC-10`, `UC-15`).
///
/// ## 2. Invariants & Mathematical Properties
/// - **Value Equality**: Two [PropertiesState] instances $s_1, s_2$ satisfy
///   $s_1 == s_2 \iff (s_1.\text{currentType}, s_1.\text{lastAction},
///   s_1.\text{actionMessage}, s_1.\text{activeNodeId}) = (s_2.\text{currentType},
///   s_2.\text{lastAction}, s_2.\text{actionMessage}, s_2.\text{activeNodeId})$.
/// - **Explicit Null Clearing**: [copyWith] only clears nullable fields when the
///   corresponding `clear*` boolean flag is explicitly set to `true`.
///
/// ## 3. Preconditions
/// - All parameters are optional and default to `null` representing an
///   unloaded initial state.
///
/// ## 4. Postconditions
/// - Produces a deeply immutable state snapshot with deterministic `==` and
///   `hashCode` semantics.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ for construction, [copyWith], and
///   hash calculation; $\mathcal{O}(|F|)$ for equality when comparing
///   [TypeDescriptor] field lists.
/// - **Space Complexity**: $\mathcal{O}(1)$ beyond the referenced [TypeDescriptor].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Null [currentType] safely indicates no loaded schema type without throwing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/PropertiesState]
/// Realises: [UC-03]
/// Realises: [UC-10]
/// Realises: [UC-15]
@immutable
class PropertiesState {
  /// Creates a [PropertiesState].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `PropertiesState::PropertiesState` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `PropertiesState::PropertiesState` (declaration #2) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesState::PropertiesState` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesState::PropertiesState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(PropertiesState)) bounded over input/member dimension of `PropertiesState::PropertiesState`.
  /// - Space Complexity: O(K(PropertiesState)) bounded auxiliary memory for `PropertiesState::PropertiesState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesState::PropertiesState` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesState::PropertiesState` without partial mutation on error.
  /// - Action: Executes `PropertiesState::PropertiesState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesState::PropertiesState` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESSTATE-PROPERTIESSTATE] | SysML v2: ActionDef(PropertiesState::PropertiesState)
  const PropertiesState({
    this.currentType,
    this.lastAction,
    this.actionMessage,
    this.activeNodeId,
  });

  /// The currently loaded [TypeDescriptor], or null.
  final TypeDescriptor? currentType;

  /// The identifier of the last executed operational action.
  final String? lastAction;

  /// Human-readable message associated with the last operational action.
  final String? actionMessage;

  /// Target node ID for the last operational action.
  final String? activeNodeId;

  /// Creates a copy of this state with updated fields.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesState::copyWith` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesState::copyWith` (declaration #3) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesState::copyWith` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `PropertiesState` from `PropertiesState::copyWith` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(copyWith)) bounded over input/member dimension of `PropertiesState::copyWith`.
  /// - Space Complexity: O(K(copyWith)) bounded auxiliary memory for `PropertiesState::copyWith`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesState::copyWith` (`PropertiesState`).
  /// - State: Maintains consistent state invariants across `PropertiesState::copyWith` without partial mutation on error.
  /// - Action: Executes `PropertiesState::copyWith` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesState::copyWith` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESSTATE-COPYWITH] | SysML v2: ActionDef(PropertiesState::copyWith)
  PropertiesState copyWith({
    TypeDescriptor? currentType,
    bool clearCurrentType = false,
    String? lastAction,
    bool clearLastAction = false,
    String? actionMessage,
    bool clearActionMessage = false,
    String? activeNodeId,
    bool clearActiveNodeId = false,
  }) {
    return PropertiesState(
      currentType: clearCurrentType ? null : (currentType ?? this.currentType),
      lastAction: clearLastAction ? null : (lastAction ?? this.lastAction),
      actionMessage: clearActionMessage ? null : (actionMessage ?? this.actionMessage),
      activeNodeId: clearActiveNodeId ? null : (activeNodeId ?? this.activeNodeId),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertiesState &&
          runtimeType == other.runtimeType &&
          currentType == other.currentType &&
          lastAction == other.lastAction &&
          actionMessage == other.actionMessage &&
          activeNodeId == other.activeNodeId;

  /// Executes deterministic method `PropertiesState::hashCode` within `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesState::hashCode` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesState::hashCode` (declaration #4) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `currentType: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesState::hashCode`.
  /// - `lastAction: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesState::hashCode`.
  /// - `actionMessage: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesState::hashCode`.
  /// - `activeNodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesState::hashCode`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesState::hashCode` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(currentType)) bounded over input/member dimension of `PropertiesState::hashCode`.
  /// - Space Complexity: O(N(currentType)) bounded auxiliary memory for `PropertiesState::hashCode`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesState::hashCode` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesState::hashCode` without partial mutation on error.
  /// - Action: Executes `PropertiesState::hashCode` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesState::hashCode` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESSTATE-HASHCODE] | SysML v2: ActionDef(PropertiesState::hashCode)
  @override
  int get hashCode => Object.hash(currentType, lastAction, actionMessage, activeNodeId);
}

/// ViewModel managing asynchronous [TypeDescriptor] resolution from [TypeRepository]
/// and operational use case state transitions for [PropertiesPanel].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Enforces monotonic request-ID
///   sequencing (`_requestId`) so out-of-order asynchronous repository responses
///   cannot overwrite the active node's schema field descriptors, and guards
///   listener notifications after disposal.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Monotonic Stale-Response Guard**: For concurrent `loadType` invocations
///   with sequence numbers $r_1 < r_2$, response $r_1$ is discarded whenever
///   $r_1 \ne \text{\_requestId}$ at completion time.
/// - **Post-Disposal Silence**: Once `dispose()` sets `_disposed = true`,
///   `notifyListeners()` is a strict no-op.
///
/// ## 3. Preconditions
/// - Must be constructed with a valid [TypeRepository] implementation.
///
/// ## 4. Postconditions
/// - Exposes current [state], resolved [fields] list (empty when unloaded), and
///   [hasType] indicator, notifying registered UI listeners on each valid transition.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ state transitions per repository
///   response or action dispatch.
/// - **Space Complexity**: $\mathcal{O}(|F|)$ where $|F|$ is the number of
///   [FieldDescriptor] entries in the loaded [TypeDescriptor].
///
/// ## 6. Failure Modes & Fault Tolerance
/// - When `_typeRepository.typeFor` returns a [Failure] or `Success(null)`,
///   clears `currentType` cleanly so [fields] returns `const []` without throwing.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/PropertiesViewModel]
/// Realises: [UC-03]
/// Realises: [UC-10]
/// Realises: [UC-15]
class PropertiesViewModel extends ChangeNotifier {
  /// Creates a [PropertiesViewModel] with injected [TypeRepository].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `PropertiesViewModel::PropertiesViewModel` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `PropertiesViewModel::PropertiesViewModel` (declaration #5) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `_typeRepository: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesViewModel::PropertiesViewModel`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesViewModel::PropertiesViewModel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(_typeRepository)) bounded over input/member dimension of `PropertiesViewModel::PropertiesViewModel`.
  /// - Space Complexity: O(N(_typeRepository)) bounded auxiliary memory for `PropertiesViewModel::PropertiesViewModel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::PropertiesViewModel` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::PropertiesViewModel` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::PropertiesViewModel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::PropertiesViewModel` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-PROPERTIESVIEWMODEL] | SysML v2: ActionDef(PropertiesViewModel::PropertiesViewModel)
  PropertiesViewModel(this._typeRepository);

  final TypeRepository _typeRepository;
  PropertiesState _state = const PropertiesState();
  bool _disposed = false;
  int _requestId = 0;

  /// Current immutable state.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::state` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::state` (declaration #7) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesViewModel::state` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesViewModel::state` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(state)) bounded over input/member dimension of `PropertiesViewModel::state`.
  /// - Space Complexity: O(K(state)) bounded auxiliary memory for `PropertiesViewModel::state`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::state` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::state` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::state` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::state` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-STATE] | SysML v2: ActionDef(PropertiesViewModel::state)
  PropertiesState get state => _state;

  /// The fields of the currently loaded type. Returns an empty list when no
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::fields` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::fields` (declaration #8) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesViewModel::fields` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesViewModel::fields` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(fields)) bounded over input/member dimension of `PropertiesViewModel::fields`.
  /// - Space Complexity: O(K(fields)) bounded auxiliary memory for `PropertiesViewModel::fields`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::fields` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::fields` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::fields` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::fields` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-FIELDS] | SysML v2: ActionDef(PropertiesViewModel::fields)
  List<FieldDescriptor> get fields => _state.currentType?.fields ?? [];

  /// Whether a type has been loaded (i.e., [loadType] completed with a
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::hasType` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::hasType` (declaration #9) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesViewModel::hasType` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `PropertiesViewModel::hasType` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(hasType)) bounded over input/member dimension of `PropertiesViewModel::hasType`.
  /// - Space Complexity: O(K(hasType)) bounded auxiliary memory for `PropertiesViewModel::hasType`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::hasType` (`()`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::hasType` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::hasType` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::hasType` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-HASTYPE] | SysML v2: ActionDef(PropertiesViewModel::hasType)
  bool get hasType => _state.currentType != null;

  /// Fetches the [TypeDescriptor] for [typeName] from the data source and
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::loadType` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::loadType` (declaration #6) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `typeName: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesViewModel::loadType`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Future<void>` from `PropertiesViewModel::loadType` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(typeName)) bounded over input/member dimension of `PropertiesViewModel::loadType`.
  /// - Space Complexity: O(N(typeName)) bounded auxiliary memory for `PropertiesViewModel::loadType`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::loadType` (`Future<void>`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::loadType` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::loadType` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::loadType` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-LOADTYPE] | SysML v2: ActionDef(PropertiesViewModel::loadType)
  Future<void> loadType(String typeName) async {
    final requestId = ++_requestId;
    final res = await _typeRepository.typeFor(typeName);
    if (_disposed) return;
    if (_requestId != requestId) return;

    switch (res) {
      case Success<TypeDescriptor?>(:final value):
        _state = _state.copyWith(currentType: value, clearCurrentType: value == null);
      case Failure<TypeDescriptor?>():
        _state = _state.copyWith(clearCurrentType: true);
    }
    notifyListeners();
  }

  /// Executes deterministic method `PropertiesViewModel::configureLocation` within `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::configureLocation` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::configureLocation` (declaration #7) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesViewModel::configureLocation`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesViewModel::configureLocation` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `PropertiesViewModel::configureLocation`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `PropertiesViewModel::configureLocation`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::configureLocation` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::configureLocation` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::configureLocation` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::configureLocation` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [UC-03] | SysML v2: ActionDef(PropertiesViewModel::configureLocation)
  void configureLocation(String nodeId) {
    _state = _state.copyWith(
      lastAction: 'configureLocation',
      actionMessage: 'Location configured for node $nodeId',
      activeNodeId: nodeId,
    );
    notifyListeners();
  }

  /// Executes deterministic method `PropertiesViewModel::drillHierarchy` within `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::drillHierarchy` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::drillHierarchy` (declaration #8) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesViewModel::drillHierarchy`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesViewModel::drillHierarchy` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `PropertiesViewModel::drillHierarchy`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `PropertiesViewModel::drillHierarchy`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::drillHierarchy` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::drillHierarchy` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::drillHierarchy` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::drillHierarchy` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [UC-10] | SysML v2: ActionDef(PropertiesViewModel::drillHierarchy)
  void drillHierarchy(String nodeId) {
    _state = _state.copyWith(
      lastAction: 'drillHierarchy',
      actionMessage: 'Hierarchy drilled for node $nodeId',
      activeNodeId: nodeId,
    );
    notifyListeners();
  }

  /// Executes deterministic method `PropertiesViewModel::provisionNe` within `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::provisionNe` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::provisionNe` (declaration #9) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - `nodeId: String` must satisfy domain and type-safety constraints prior to invoking `PropertiesViewModel::provisionNe`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesViewModel::provisionNe` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(nodeId)) bounded over input/member dimension of `PropertiesViewModel::provisionNe`.
  /// - Space Complexity: O(N(nodeId)) bounded auxiliary memory for `PropertiesViewModel::provisionNe`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::provisionNe` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::provisionNe` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::provisionNe` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::provisionNe` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [UC-15] | SysML v2: ActionDef(PropertiesViewModel::provisionNe)
  void provisionNe(String nodeId) {
    _state = _state.copyWith(
      lastAction: 'provisionNe',
      actionMessage: 'NE provisioned for node $nodeId',
      activeNodeId: nodeId,
    );
    notifyListeners();
  }

  /// Executes deterministic method `PropertiesViewModel::notifyListeners` within `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::notifyListeners` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::notifyListeners` (declaration #10) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesViewModel::notifyListeners` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesViewModel::notifyListeners` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(notifyListeners)) bounded over input/member dimension of `PropertiesViewModel::notifyListeners`.
  /// - Space Complexity: O(K(notifyListeners)) bounded auxiliary memory for `PropertiesViewModel::notifyListeners`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::notifyListeners` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::notifyListeners` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::notifyListeners` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::notifyListeners` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-NOTIFYLISTENERS] | SysML v2: ActionDef(PropertiesViewModel::notifyListeners)
  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  /// Executes deterministic method `PropertiesViewModel::dispose` within `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `PropertiesViewModel::dispose` in `app_flutter/lib/features/properties/view_models/properties_view_model.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `PropertiesViewModel::dispose` (declaration #11) within `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `PropertiesViewModel::dispose` in `VIEW-MODELS-PROPERTIES-VIEW-MODEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `PropertiesViewModel::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `PropertiesViewModel::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `PropertiesViewModel::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `PropertiesViewModel::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `PropertiesViewModel::dispose` without partial mutation on error.
  /// - Action: Executes `PropertiesViewModel::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `PropertiesViewModel::dispose` (`VIEW-MODELS-PROPERTIES-VIEW-MODEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-VIEW-MODELS-PROPERTIES-VIEW-MODEL-PROPERTIESVIEWMODEL-DISPOSE] | SysML v2: ActionDef(PropertiesViewModel::dispose)
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
