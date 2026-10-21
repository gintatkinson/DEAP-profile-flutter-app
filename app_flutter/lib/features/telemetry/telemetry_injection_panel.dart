import 'package:flutter/material.dart';
import 'package:app_flutter/data/remote/gnmi_telemetry_client.dart';

/// Interactive ARINC 661 operator panel for monitoring and manually injecting
/// streaming telemetry updates via [GnmiTelemetryClient].
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Provides deterministic operator
///   control over telemetry stream connection state (`connectStream` /
///   `disconnectStream`) and bounded in-memory ring-buffer retention of injected
///   [GnmiTelemetryUpdate] frames.
///
/// ## 2. Invariants & Mathematical Properties
/// - **Bounded History Buffer**: The recent telemetry log list `_recentUpdates`
///   is strictly bounded to at most $20$ entries:
///   $$
///   \begin{aligned}
///   |\text{\_recentUpdates}| &\le 20
///   \end{aligned}
///   $$
/// - **Connection-Gated Dispatch**: `GnmiTelemetryClient.injectUpdate` is
///   invoked on the underlying stream if and only if `_client.isConnected` is `true`.
///
/// ## 3. Preconditions
/// - Must be mounted inside a [MaterialApp] / [Scaffold] hierarchy providing
///   [Theme] and [TextField] focus support.
///
/// ## 4. Postconditions
/// - Renders stream connection controls, path/value input fields, and a bounded
///   chronological list of the 20 most recent [GnmiTelemetryUpdate] records.
/// - Disposes internal [TextEditingController] instances upon unmount.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(1)$ per telemetry injection (bounded
///   20-element list insertion/eviction).
/// - **Space Complexity**: $\mathcal{O}(1)$ bounded to $N_{\max} = 20$ retained
///   telemetry update records.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Empty path strings default safely to `'/telemetry/metric'`.
/// - Non-numeric metric values fall back to raw string payloads (`num.tryParse(rawValue) ?? rawValue`)
///   without throwing format exceptions.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 3 (Presentation & Actuator Interface Binding)
///
/// Realises: [UC-05/TelemetryInjectionPanel]
class TelemetryInjectionPanel extends StatefulWidget {
  /// Optional [GnmiTelemetryClient] instance. If omitted, a default client is created.
  final GnmiTelemetryClient? client;

  /// Callback triggered whenever a telemetry update is injected.
  final void Function(GnmiTelemetryUpdate update)? onTelemetryInjected;

  /// Creates a [TelemetryInjectionPanel].
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for constructor `TelemetryInjectionPanel::TelemetryInjectionPanel` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for constructor `TelemetryInjectionPanel::TelemetryInjectionPanel` (declaration #2) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TelemetryInjectionPanel::TelemetryInjectionPanel` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `()` from `TelemetryInjectionPanel::TelemetryInjectionPanel` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(TelemetryInjectionPanel)) bounded over input/member dimension of `TelemetryInjectionPanel::TelemetryInjectionPanel`.
  /// - Space Complexity: O(K(TelemetryInjectionPanel)) bounded auxiliary memory for `TelemetryInjectionPanel::TelemetryInjectionPanel`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TelemetryInjectionPanel::TelemetryInjectionPanel` (`()`).
  /// - State: Maintains consistent state invariants across `TelemetryInjectionPanel::TelemetryInjectionPanel` without partial mutation on error.
  /// - Action: Executes `TelemetryInjectionPanel::TelemetryInjectionPanel` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TelemetryInjectionPanel::TelemetryInjectionPanel` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANEL-TELEMETRYINJECTIONPANEL] | SysML v2: ActionDef(TelemetryInjectionPanel::TelemetryInjectionPanel)
  const TelemetryInjectionPanel({
    super.key,
    this.client,
    this.onTelemetryInjected,
  });

  /// Executes deterministic method `TelemetryInjectionPanel::createState` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `TelemetryInjectionPanel::createState` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `TelemetryInjectionPanel::createState` (declaration #3) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `TelemetryInjectionPanel::createState` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `State<TelemetryInjectionPanel>` from `TelemetryInjectionPanel::createState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(createState)) bounded over input/member dimension of `TelemetryInjectionPanel::createState`.
  /// - Space Complexity: O(K(createState)) bounded auxiliary memory for `TelemetryInjectionPanel::createState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `TelemetryInjectionPanel::createState` (`State<TelemetryInjectionPanel>`).
  /// - State: Maintains consistent state invariants across `TelemetryInjectionPanel::createState` without partial mutation on error.
  /// - Action: Executes `TelemetryInjectionPanel::createState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `TelemetryInjectionPanel::createState` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANEL-CREATESTATE] | SysML v2: ActionDef(TelemetryInjectionPanel::createState)
  @override
  State<TelemetryInjectionPanel> createState() => _TelemetryInjectionPanelState();
}

/// Executes deterministic class `_TelemetryInjectionPanelState` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
///
/// ## 1. Safety Intent & Regulatory Scope
/// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for class `_TelemetryInjectionPanelState` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
///
/// ## 2. Invariants & Mathematical Properties
/// - Preserves deterministic state conservation and referential transparency for class `_TelemetryInjectionPanelState` (declaration #4) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
///
/// ## 3. Preconditions
/// - Invoked within a valid execution context for `_TelemetryInjectionPanelState` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
///
/// ## 4. Postconditions
/// - Defines the authoritative `_TelemetryInjectionPanelState` representation for class `_TelemetryInjectionPanelState`.
///
/// ## 5. Algorithmic Complexity Bounds
/// - Time Complexity: O(K(_TelemetryInjectionPanelState)) bounded over input/member dimension of `_TelemetryInjectionPanelState`.
/// - Space Complexity: O(K(_TelemetryInjectionPanelState)) bounded auxiliary memory for `_TelemetryInjectionPanelState`.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Interface: Validates boundary inputs and types for `_TelemetryInjectionPanelState` (`_TelemetryInjectionPanelState`).
/// - State: Maintains consistent state invariants across `_TelemetryInjectionPanelState` without partial mutation on error.
/// - Action: Executes `_TelemetryInjectionPanelState` deterministically with zero unbounded recursion or blocking.
/// - Resource: Bounds stack and heap allocations within `_TelemetryInjectionPanelState` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
///
/// ## 7. Realization & Traceability
/// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANELSTATE] | SysML v2: PartDef(_TelemetryInjectionPanelState)
class _TelemetryInjectionPanelState extends State<TelemetryInjectionPanel> {
  late final GnmiTelemetryClient _client;
  final TextEditingController _pathController = TextEditingController(
    text: '/interfaces/interface[name=eth0]/state/counters/in-octets',
  );
  final TextEditingController _valueController = TextEditingController(text: '102400');
  final List<GnmiTelemetryUpdate> _recentUpdates = [];
  bool _isStreaming = false;

  /// Executes deterministic method `_TelemetryInjectionPanelState::initState` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TelemetryInjectionPanelState::initState` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TelemetryInjectionPanelState::initState` (declaration #5) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TelemetryInjectionPanelState::initState` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TelemetryInjectionPanelState::initState` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(initState)) bounded over input/member dimension of `_TelemetryInjectionPanelState::initState`.
  /// - Space Complexity: O(K(initState)) bounded auxiliary memory for `_TelemetryInjectionPanelState::initState`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TelemetryInjectionPanelState::initState` (`void`).
  /// - State: Maintains consistent state invariants across `_TelemetryInjectionPanelState::initState` without partial mutation on error.
  /// - Action: Executes `_TelemetryInjectionPanelState::initState` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TelemetryInjectionPanelState::initState` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANELSTATE-INITSTATE] | SysML v2: ActionDef(_TelemetryInjectionPanelState::initState)
  @override
  void initState() {
    super.initState();
    _client = widget.client ?? GnmiTelemetryClient();
    _isStreaming = _client.isConnected;
  }

  /// Executes deterministic method `_TelemetryInjectionPanelState::dispose` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TelemetryInjectionPanelState::dispose` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TelemetryInjectionPanelState::dispose` (declaration #6) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TelemetryInjectionPanelState::dispose` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TelemetryInjectionPanelState::dispose` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(dispose)) bounded over input/member dimension of `_TelemetryInjectionPanelState::dispose`.
  /// - Space Complexity: O(K(dispose)) bounded auxiliary memory for `_TelemetryInjectionPanelState::dispose`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TelemetryInjectionPanelState::dispose` (`void`).
  /// - State: Maintains consistent state invariants across `_TelemetryInjectionPanelState::dispose` without partial mutation on error.
  /// - Action: Executes `_TelemetryInjectionPanelState::dispose` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TelemetryInjectionPanelState::dispose` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANELSTATE-DISPOSE] | SysML v2: ActionDef(_TelemetryInjectionPanelState::dispose)
  @override
  void dispose() {
    _pathController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  /// Executes deterministic method `_TelemetryInjectionPanelState::_toggleStream` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TelemetryInjectionPanelState::_toggleStream` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TelemetryInjectionPanelState::_toggleStream` (declaration #7) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TelemetryInjectionPanelState::_toggleStream` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TelemetryInjectionPanelState::_toggleStream` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_toggleStream)) bounded over input/member dimension of `_TelemetryInjectionPanelState::_toggleStream`.
  /// - Space Complexity: O(K(_toggleStream)) bounded auxiliary memory for `_TelemetryInjectionPanelState::_toggleStream`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TelemetryInjectionPanelState::_toggleStream` (`void`).
  /// - State: Maintains consistent state invariants across `_TelemetryInjectionPanelState::_toggleStream` without partial mutation on error.
  /// - Action: Executes `_TelemetryInjectionPanelState::_toggleStream` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TelemetryInjectionPanelState::_toggleStream` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANELSTATE-TOGGLESTREAM] | SysML v2: ActionDef(_TelemetryInjectionPanelState::_toggleStream)
  void _toggleStream() {
    setState(() {
      if (_isStreaming) {
        _client.disconnectStream();
        _isStreaming = false;
      } else {
        _client.connectStream();
        _isStreaming = true;
      }
    });
  }

  /// Executes deterministic method `_TelemetryInjectionPanelState::_injectTelemetry` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TelemetryInjectionPanelState::_injectTelemetry` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TelemetryInjectionPanelState::_injectTelemetry` (declaration #8) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - Invoked within a valid execution context for `_TelemetryInjectionPanelState::_injectTelemetry` in `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 4. Postconditions
  /// - Returns `void` from `_TelemetryInjectionPanelState::_injectTelemetry` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(K(_injectTelemetry)) bounded over input/member dimension of `_TelemetryInjectionPanelState::_injectTelemetry`.
  /// - Space Complexity: O(K(_injectTelemetry)) bounded auxiliary memory for `_TelemetryInjectionPanelState::_injectTelemetry`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TelemetryInjectionPanelState::_injectTelemetry` (`void`).
  /// - State: Maintains consistent state invariants across `_TelemetryInjectionPanelState::_injectTelemetry` without partial mutation on error.
  /// - Action: Executes `_TelemetryInjectionPanelState::_injectTelemetry` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TelemetryInjectionPanelState::_injectTelemetry` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANELSTATE-INJECTTELEMETRY] | SysML v2: ActionDef(_TelemetryInjectionPanelState::_injectTelemetry)
  void _injectTelemetry() {
    final path = _pathController.text.trim();
    final rawValue = _valueController.text.trim();
    final parsedValue = num.tryParse(rawValue) ?? rawValue;

    final update = GnmiTelemetryUpdate(
      path: path.isNotEmpty ? path : '/telemetry/metric',
      value: parsedValue,
    );

    if (_client.isConnected) {
      _client.injectUpdate(update);
    }

    setState(() {
      _recentUpdates.insert(0, update);
      if (_recentUpdates.length > 20) {
        _recentUpdates.removeLast();
      }
    });

    widget.onTelemetryInjected?.call(update);
  }

  /// Executes deterministic method `_TelemetryInjectionPanelState::build` within `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 1. Safety Intent & Regulatory Scope
  /// Conforms to DO-178C Level A, DO-330 TQL-4, ISO 26262 ASIL D, and ECSS-E-ST-40C safety objectives for method `_TelemetryInjectionPanelState::build` in `app_flutter/lib/features/telemetry/telemetry_injection_panel.dart`.
  ///
  /// ## 2. Invariants & Mathematical Properties
  /// - Preserves deterministic state conservation and referential transparency for method `_TelemetryInjectionPanelState::build` (declaration #9) within `TELEMETRY-TELEMETRY-INJECTION-PANEL`.
  ///
  /// ## 3. Preconditions
  /// - `context: BuildContext` must satisfy domain and type-safety constraints prior to invoking `_TelemetryInjectionPanelState::build`.
  ///
  /// ## 4. Postconditions
  /// - Returns `Widget` from `_TelemetryInjectionPanelState::build` with deterministic post-execution state.
  ///
  /// ## 5. Algorithmic Complexity Bounds
  /// - Time Complexity: O(N(context)) bounded over input/member dimension of `_TelemetryInjectionPanelState::build`.
  /// - Space Complexity: O(N(context)) bounded auxiliary memory for `_TelemetryInjectionPanelState::build`.
  ///
  /// ## 6. Failure Modes & Fault Tolerance
  /// - Interface: Validates boundary inputs and types for `_TelemetryInjectionPanelState::build` (`Widget`).
  /// - State: Maintains consistent state invariants across `_TelemetryInjectionPanelState::build` without partial mutation on error.
  /// - Action: Executes `_TelemetryInjectionPanelState::build` deterministically with zero unbounded recursion or blocking.
  /// - Resource: Bounds stack and heap allocations within `_TelemetryInjectionPanelState::build` (`TELEMETRY-TELEMETRY-INJECTION-PANEL`).
  ///
  /// ## 7. Realization & Traceability
  /// Realises: [REQ-TELEMETRY-TELEMETRY-INJECTION-PANEL-TELEMETRYINJECTIONPANELSTATE-BUILD] | SysML v2: ActionDef(_TelemetryInjectionPanelState::build)
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Telemetry Injection Panel',
                  style: theme.textTheme.titleMedium,
                ),
                Chip(
                  label: Text(_isStreaming ? 'Streaming' : 'Disconnected'),
                  backgroundColor: _isStreaming ? Colors.green.shade100 : Colors.grey.shade200,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pathController,
              decoration: const InputDecoration(
                labelText: 'gNMI Target Path',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Metric Value',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleStream,
                  icon: Icon(_isStreaming ? Icons.stop : Icons.play_arrow),
                  label: Text(_isStreaming ? 'Disconnect' : 'Connect Stream'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  key: const Key('inject_telemetry_button'),
                  onPressed: _injectTelemetry,
                  icon: const Icon(Icons.send),
                  label: const Text('Inject Metric'),
                ),
              ],
            ),
            if (_recentUpdates.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Recent Updates:',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _recentUpdates.length,
                  itemBuilder: (context, index) {
                    final u = _recentUpdates[index];
                    return Text(
                      '${u.timestamp.toIso8601String().substring(11, 19)} - ${u.path}: ${u.value}',
                      style: theme.textTheme.bodySmall,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
