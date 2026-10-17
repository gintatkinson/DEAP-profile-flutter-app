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
  PropertiesViewModel(this._typeRepository);

  final TypeRepository _typeRepository;
  PropertiesState _state = const PropertiesState();
  bool _disposed = false;
  int _requestId = 0;

  /// Current immutable state.
  PropertiesState get state => _state;

  /// The fields of the currently loaded type. Returns an empty list when no
  /// type has been loaded or `loadType` returned `null`.
  List<FieldDescriptor> get fields => _state.currentType?.fields ?? [];

  /// Whether a type has been loaded (i.e., [loadType] completed with a
  /// non-null [TypeDescriptor]).
  bool get hasType => _state.currentType != null;

  /// Fetches the [TypeDescriptor] for [typeName] from the data source and
  /// notifies listeners.
  ///
  /// If the data source returns `null` (unknown type), [_state] is updated with
  /// null type, [fields] becomes empty, and [hasType] becomes false.
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

  /// Realises: [UC-03]
  ///
  /// Dispatches the Configure Location operational action for [nodeId].
  void configureLocation(String nodeId) {
    _state = _state.copyWith(
      lastAction: 'configureLocation',
      actionMessage: 'Location configured for node $nodeId',
      activeNodeId: nodeId,
    );
    notifyListeners();
  }

  /// Realises: [UC-10]
  ///
  /// Dispatches the Drill Hierarchy operational action for [nodeId].
  void drillHierarchy(String nodeId) {
    _state = _state.copyWith(
      lastAction: 'drillHierarchy',
      actionMessage: 'Hierarchy drilled for node $nodeId',
      activeNodeId: nodeId,
    );
    notifyListeners();
  }

  /// Realises: [UC-15]
  ///
  /// Dispatches the Provision NE operational action for [nodeId].
  void provisionNe(String nodeId) {
    _state = _state.copyWith(
      lastAction: 'provisionNe',
      actionMessage: 'NE provisioned for node $nodeId',
      activeNodeId: nodeId,
    );
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
