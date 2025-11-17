import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/navkit_logger.dart';
import 'package:flutter_navkit/src/navkit_observer.dart';

/// Extension on [BuildContext] to provide **named route navigation helpers**
/// with built-in stack checking and debug logging via [NavkitLogger].
///
/// These methods simplify navigation tasks like pushing, replacing, or popping
/// to named routes safely, while logging errors in debug mode if routes are missing.
extension NamedNavKit on BuildContext {

  /// Push a **named route** onto the navigator stack.
  ///
  /// Returns the result of the route if it completes, or `null` if the route
  /// is not found (and logs an error in debug mode).
  Future<T?> toNamed<T>(String route, {Object? args}) async {
    try {
      return Navigator.pushNamed(this, route, arguments: args);
    } catch (e) {
      NavkitLogger.error("Route '$route' not found.");
      return null;
    }
  }

  /// Push a named route and **remove all previous routes** from the stack.
  ///
  /// Optionally accepts a [predicate] to control which routes to keep.
  Future<T?> toNamedAndRemoveAll<T>(
      String route, {
        Object? args,
        bool Function(Route<dynamic>)? predicate,
      }) async {
    try {
      return Navigator.pushNamedAndRemoveUntil(
        this,
        route,
        predicate ?? (route) => false,
        arguments: args,
      );
    } catch (e) {
      NavkitLogger.error("Route '$route' not found.");
      return null;
    }
  }

  /// Replace the current route with a **new named route**.
  ///
  /// Returns the result of the new route, or `null` if the route is not found.
  Future<T?> replaceWithNamed<T>(String route, {Object? args}) async {
    try {
      return Navigator.pushReplacementNamed(this, route, arguments: args);
    } catch (e) {
      NavkitLogger.error("Route '$route' not found.");
      return null;
    }
  }

  /// Pop the current route and **push a new named route** immediately after.
  ///
  /// Similar to `pushReplacement`, but explicitly pops first.
  Future<T?> backAndToNamed<T>(String route, {Object? args}) async {
    try {
      return Navigator.of(this).popAndPushNamed(route, arguments: args);
    } catch (e) {
      NavkitLogger.error("Route '$route' not found.");
      return null;
    }
  }

  /// Pop routes until you reach a **specific named route** in the stack.
  ///
  /// If the route does not exist, logs an error and optionally prints the stack.
  void backTo(String route) {
    if (NavkitObserver.hasRoute(route)) {
      Navigator.popUntil(this, ModalRoute.withName(route));
    } else {
      NavkitLogger.error(
          "Route '$route' not found in stack.",
          stack: NavkitObserver().observeStack
      );
    }
  }

  /// Pop the top-most route from the navigator stack.
  ///
  /// If the stack is empty, logs an error.
  void back<T>({T? result}) {
    try {
      Navigator.of(this).pop<T>(result);
    } catch (e) {
      NavkitLogger.error("No route to pop.");
    }
  }
}
