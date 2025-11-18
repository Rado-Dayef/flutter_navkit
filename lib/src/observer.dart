import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/logger.dart';

/// A custom [NavigatorObserver] that tracks the navigation stack
/// and provides detailed debug logs for push, pop, replace, and remove events.
///
/// Integrates with [Logger] for printing logs and optionally
/// printing the full route stack.
class Observer extends NavigatorObserver {
  /// Whether to print the full route stack on every navigation event.
  final bool withStack;

  /// Constructor with optional [withStack] parameter.
  /// Defaults to `false`.
  Observer({this.withStack = false});

  /// Internal list of routes currently in the navigation stack.
  static final List<Route<dynamic>> _routes = [];
  static List<Route<dynamic>> get routes => List.unmodifiable(_routes);

  /// Checks if a route with the given [routeName] exists in the stack.
  static bool hasRoute(String routeName) {
    return _routes.any((route) => route.settings.name == routeName);
  }

  /// Called when a route is removed from the navigator.
  @override
  void didRemove(Route route, Route? previousRoute) {
    _routes.remove(route);
    Logger.removeMessage(route, withStack);
  }

  /// Called when a route is replaced by another route.
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) _routes.remove(oldRoute);
    if (newRoute != null) _routes.add(newRoute);

    Logger.replaceMessage(newRoute, oldRoute, withStack);
  }

  /// Called when a route is popped from the navigator.
  @override
  void didPop(Route route, Route? previousRoute) {
    _routes.remove(route);
    Logger.backMessage(route, previousRoute, withStack);
  }

  /// Called when a new route is pushed onto the navigator.
  @override
  void didPush(Route route, Route? previousRoute) {
    _routes.add(route);
    Logger.toMessage(route, previousRoute, withStack);
  }
}
