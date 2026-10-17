import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;

/// Periodic background computation worker executing off the UI thread via [Isolate].
///
/// Offloads intensive trigonometric synthesis cycles onto a separate isolate
/// every 3 seconds with a deterministic chunked cooperative fallback when isolate
/// spawning is unavailable, protecting the primary UI thread's frame budget.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Preserves deterministic 60 FPS
///   cockpit display responsiveness ($T_{\text{frame}} \le 16.67\text{ ms}$) by
///   isolating $N = 10^6$ periodic floating-point accumulations from the main
///   raster and UI event loop.
///
/// ## 2. Invariants & Mathematical Properties
/// - For each periodic tick $k \in \mathbb{N}^+$, computes:
///   $R_k = \text{round}\left(\sum_{i=0}^{10^6 - 1} \sin(k + i)\right)$.
/// - Stream emission is strictly guarded by lifecycle state:
///   $(\text{timer} = \text{null} \lor \text{isDisposed}) \implies \text{emit}(R_k) = \varnothing$.
///
/// ## 3. Preconditions
/// - Caller must invoke [start] on an undisposed [BackgroundWorker] instance to
///   arm the periodic 3-second execution schedule.
///
/// ## 4. Postconditions
/// - Emits rounded integer synthesis results on the broadcast [results] stream
///   and caches the latest value in [lastResult] until [stop] or [dispose] is
///   called.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(N)$ per periodic cycle where $N = 10^6$
///   iterations ($\mathcal{O}(1)$ main-isolate blocking time when [Isolate.run]
///   succeeds).
/// - **Space Complexity**: $\mathcal{O}(1)$ bounded state (single scalar
///   accumulator and broadcast stream controller).
///
/// ## 6. Failure Modes & Fault Tolerance
/// - If [Isolate.run] throws or is unsupported by the runtime platform, degrades
///   gracefully to cooperative time-sliced chunks of $10^4$ iterations yielding
///   via `Future.delayed(Duration.zero)` between slices, and aborts immediately
///   if [stop] or [dispose] occurs mid-calculation.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/BackgroundWorker]
class BackgroundWorker {
  Timer? _timer;
  int _counter = 0;
  int? _lastResult;
  final StreamController<int> _controller = StreamController<int>.broadcast();
  bool _isDisposed = false;

  /// Broadcast stream of rounded integer results emitted after each periodic calculation cycle.
  Stream<int> get results => _controller.stream;

  /// Most recently computed integer result, or `null` if no cycle has completed.
  int? get lastResult => _lastResult;

  /// Cancels any active schedule and starts a periodic 3-second background calculation timer.
  void start() {
    stop();
    _isDisposed = false;
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _counter++;
      _runCalculation(_counter.toDouble());
    });
  }

  Future<void> _runCalculation(double value) async {
    if (_timer == null || _isDisposed) return;
    try {
      final result = await Isolate.run(() {
        double sum = 0.0;
        for (int i = 0; i < 1000000; i++) {
          sum += math.sin(value + i);
        }
        return sum.round();
      });
      if (_timer == null || _isDisposed) return;
      _lastResult = result;
      if (!_controller.isClosed) {
        _controller.add(result);
      }
    } catch (e) {
      if (_timer == null || _isDisposed) return;
      double sum = 0.0;
      const chunkSize = 10000;
      for (int i = 0; i < 1000000; i += chunkSize) {
        if (_timer == null || _isDisposed) return;
        await Future.delayed(Duration.zero);
        for (int j = 0; j < chunkSize && (i + j) < 1000000; j++) {
          sum += math.sin(value + i + j);
        }
      }
      if (_timer == null || _isDisposed) return;
      _lastResult = sum.round();
      if (!_controller.isClosed) {
        _controller.add(sum.round());
      }
    }
  }

  /// Halts the periodic calculation timer without closing the [results] stream.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Permanently halts the periodic timer, marks the worker disposed, and closes [results].
  void dispose() {
    _isDisposed = true;
    stop();
    _controller.close();
  }
}
