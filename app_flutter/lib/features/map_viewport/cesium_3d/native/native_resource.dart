import 'dart:ffi';
import 'package:ffi/ffi.dart';

final _finalizer = NativeFinalizer(calloc.nativeFree);

/// RAII-style native heap memory wrapper implementing [Finalizable] with
/// deterministic manual release and automatic GC finalizer reclamation.
///
/// ## 1. Safety Intent & Regulatory Scope
/// - **DO-178C DAL-A / ARINC 661 Standard**: Prevents native heap memory leaks,
///   integer overflow during allocation sizing, and use-after-free pointer
///   dereferences across the Dart-to-C FFI boundary.
///
/// ## 2. Invariants & Mathematical Properties
/// - Allocation bounds invariant: `count > 0`, `elementSize > 0`, and
///   `count * elementSize <= 0x7FFFFFFFFFFFFFFF` (64-bit signed integer ceiling).
/// - Temporal safety invariant: once [release] is invoked, `isReleased == true`,
///   `_pointer == nullptr`, the `NativeFinalizer` is detached, and any subsequent
///   access to [pointer] throws [StateError].
///
/// ## 3. Preconditions
/// - [NativeResource.alloc] requires strictly positive `count` and `elementSize`
///   whose product does not overflow a 64-bit signed integer.
///
/// ## 4. Postconditions
/// - Returns a zero-initialized native memory block attached to `_finalizer`,
///   and guarantees exactly-once deallocation via either explicit [release] or
///   garbage collection.
///
/// ## 5. Algorithmic Complexity Bounds
/// - **Time Complexity**: $\mathcal{O}(B)$ where $B = \text{count} \times \text{elementSize}$
///   for zero-initialized `calloc`, and $\mathcal{O}(1)$ for [release].
/// - **Space Complexity**: $\mathcal{O}(B)$ native heap bytes.
///
/// ## 6. Failure Modes & Fault Tolerance
/// - Throws [ArgumentError] on non-positive dimensions or 64-bit multiplication
///   overflow; throws [OutOfMemoryError] if `calloc` returns `nullptr`; idempotent
///   on repeated [release] calls.
///
/// ## 7. Realization & Traceability
/// - **Layer**: Layer 2 (Logic & State Management)
///
/// Realises: [Feat-10/NativeResource]
final class NativeResource implements Finalizable {
  Pointer<Void> _pointer;
  /// Total size of the allocated native memory block in bytes.
  final int sizeBytes;
  bool _isReleased = false;

  /// Whether this native resource has already been freed.
  bool get isReleased => _isReleased;

  /// Returns the underlying native pointer, or throws [StateError] if released.
  Pointer<Void> get pointer {
    if (_isReleased) {
      throw StateError('Cannot access pointer after NativeResource has been released.');
    }
    return _pointer;
  }

  NativeResource._(this._pointer, this.sizeBytes) {
    _finalizer.attach(this, _pointer, detach: this, externalSize: sizeBytes);
  }

  /// Allocates a zero-initialized native buffer of [count] elements of [elementSize] bytes.
  factory NativeResource.alloc(int count, int elementSize) {
    if (count <= 0 || elementSize <= 0) {
      throw ArgumentError('Count and element size must be positive.');
    }
    if (count > 0x7FFFFFFFFFFFFFFF ~/ elementSize) {
      throw ArgumentError('Allocation size overflow.');
    }
    final totalSize = count * elementSize;
    final ptr = calloc<Int8>(totalSize);
    if (ptr == nullptr) {
      throw OutOfMemoryError();
    }
    return NativeResource._(ptr.cast(), totalSize);
  }

  /// Deterministically frees the native allocation and detaches the GC finalizer.
  void release() {
    if (_isReleased) return;
    _isReleased = true;
    _finalizer.detach(this);
    calloc.free(_pointer);
    _pointer = nullptr;
  }
}
