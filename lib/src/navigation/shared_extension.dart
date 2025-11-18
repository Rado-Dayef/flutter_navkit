import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/logger.dart';

/// Shared navigation utilities available on every [BuildContext].
///
/// These helpers provide quick access to route metadata and safe navigation
/// actions without throwing exceptions.
extension SharedExtension on BuildContext {
  /// Pop the top-most route in the navigation stack.
  ///
  /// Optionally pass a [result] back to the previous screen.
  /// If popping is not possible (e.g., you're already on the first route),
  /// a safe error log is printed instead of throwing an exception.
  void back<T>({T? result}) {
    try {
      Navigator.of(this).pop<T>(result);
    } catch (e) {
      Logger.noRouteToBackToError();
    }
  }

  /// Returns `true` if the current route contains arguments of type [T].
  ///
  /// Useful for validating data before accessing it:
  /// ```dart
  /// if (context.hasArguments<MyArgs>()) {
  ///   final args = context.arguments<MyArgs>();
  /// }
  /// ```
  bool hasArguments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    return args is T;
  }

  /// Safely returns the route arguments **typed as** [T].
  ///
  /// If the arguments don't match the provided type, `null` is returned
  /// instead of throwing a cast error.
  ///
  /// Example:
  /// ```dart
  /// final user = context.arguments<UserModel>();
  /// ```
  T? arguments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args is T) return args;
    return null;
  }
}
