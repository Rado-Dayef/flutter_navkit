import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/navkit_logger.dart';

/// Extension on [BuildContext] providing **direct widget navigation**
///
/// Use these methods to push, replace, or remove screens without using
/// named routes. Ideal for simpler or one-off screens where you don't
/// need route names.
extension NormalNavKit on BuildContext {

  /// Push a new screen onto the navigation stack.
  ///
  /// [screen]: The widget to navigate to.
  /// Returns a [Future] that completes when the pushed screen is popped.
  Future<T?> to<T>(Widget screen) async {
    try {
      return Navigator.of(this).push(MaterialPageRoute(builder: (_) => screen));
    } catch (e) {
      NavkitLogger.error("Something went wrong when navigating to \"${screen.runtimeType}\".");
      return null;
    }
  }

  /// Replace the current screen with a new one.
  ///
  /// [screen]: The widget to navigate to.
  /// The previous screen is removed from the stack.
  Future<T?> replaceWith<T>(Widget screen) async {
    try {
      return Navigator.of(this).pushReplacement(
        MaterialPageRoute(builder: (_) => screen),
      );
    } catch (e) {
      NavkitLogger.error("Something went wrong when navigating to \"${screen.runtimeType}\".");
      return null;
    }
  }

  /// Push a new screen and remove all previous screens.
  ///
  /// [screen]: The widget to navigate to.
  /// [predicate]: Optional function to decide which routes to keep.
  /// By default, removes everything.
  Future<T?> toAndRemoveAll<T>(Widget screen, {bool Function(Route<dynamic>)? predicate}) async {
    try {
      return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen),
        predicate ?? (route) => false,
      );
    } catch (e) {
      NavkitLogger.error("Something went wrong when navigating to \"${screen.runtimeType}\".");
      return null;
    }
  }

  /// Pop back to the first screen in the stack.
  void backToFirst() {
    try {
      Navigator.of(this).popUntil((route) => route.isFirst);
    } catch (e) {
      NavkitLogger.error("Something went wrong while popping to the first screen.");
    }
  }

  /// Attempts to pop the current screen, returning `true` if successful.
  ///
  /// Optionally pass a [result] to return to the previous screen.
  Future<bool> maybeBack<T extends Object?>([T? result]) async {
    try {
      return Navigator.of(this).maybePop(result);
    } catch (e) {
      NavkitLogger.error("Something went wrong while trying to pop the screen.");
      return false;
    }
  }

  /// Check if the current navigator can pop any screens.
  bool get canPop => Navigator.of(this).canPop();
}
