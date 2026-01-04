import 'package:flutter/foundation.dart';

/// This behaves like an assertion in debug mode, but throws an exception in
/// release mode. Use this to enforce invariants that should never be violated,
/// even in production.
///
/// Example:
/// ```dart
/// invariant(user != null, 'User must not be null');
/// ```
void invariant(bool condition, String message) {
  assert(condition, message);

  if (!condition && kReleaseMode) {
    // TODO(ohtenkay): Integrate with error reporting service.
    throw StateError(message);
  }
}

/// A function that always fails when called.
/// Equivalent to `invariant(false, message)`, but with a `Never` return type.
/// Should be used in places where the code must not be reachable.
Never never(String message) {
  invariant(false, message);

  // This line is unreachable, but is necessary to satisfy the return type.
  throw StateError(message);
}
