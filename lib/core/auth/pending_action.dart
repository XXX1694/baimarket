import 'package:flutter/foundation.dart';

/// Stores a single deferred action to run after successful authentication.
///
/// Lives only in process memory — cleared on logout, on consume, or whenever
/// the auth flow ends without success.
class PendingAuthAction {
  static VoidCallback? _action;

  static bool get hasPending => _action != null;

  static void set(VoidCallback action) {
    _action = action;
  }

  static void runAndClear() {
    final action = _action;
    _action = null;
    action?.call();
  }

  static void clear() {
    _action = null;
  }
}
