import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/navkit_logger.dart';

/// A custom [NavigatorObserver] that tracks the navigation stack
/// and provides detailed debug logs for push, pop, replace, and remove events.
///
/// Integrates with [NavkitLogger] for printing logs and optionally
/// printing the full route stack.
class NavkitObserver extends NavigatorObserver {
  /// Whether to print the full route stack on every navigation event.
  final bool withStack;

  /// Constructor with optional [withStack] parameter.
  /// Defaults to `false`.
  NavkitObserver({this.withStack = false});

  /// Internal list of routes currently in the navigation stack.
  static final List<Route<dynamic>> _routes = [];

  /// Checks if a route with the given [routeName] exists in the stack.
  static bool hasRoute(String routeName) {
    return _routes.any((route) => route.settings.name == routeName);
  }

  /// Called when a route is removed from the navigator.
  @override
  void didRemove(Route route, Route? previousRoute) {
    _routes.remove(route);
    NavkitLogger.message("🔄", "Remove → ${_fmt(route)}", stack: observeStack);
  }

  /// Called when a route is replaced by another route.
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) _routes.remove(oldRoute);
    if (newRoute != null) _routes.add(newRoute);

    NavkitLogger.message("🔀", "Replace → ${_fmt(oldRoute)} → ${_fmt(newRoute)}", stack: observeStack);
  }

  /// Called when a route is popped from the navigator.
  @override
  void didPop(Route route, Route? previousRoute) {
    _routes.remove(route);
    NavkitLogger.message("⬅️", "Pop → ${_fmt(route)} (back to: ${_fmt(previousRoute)})", stack: observeStack);
  }

  /// Called when a new route is pushed onto the navigator.
  @override
  void didPush(Route route, Route? previousRoute) {
    _routes.add(route);
    NavkitLogger.message("➡️", "Push → ${_fmt(route)}${previousRoute == null ? "" : " (from: ${_fmt(previousRoute)})"}", stack: observeStack);
  }

  /// Prints the current route stack to the console if [withStack] is true.
  void observeStack() {
    if (withStack) {
      debugPrint("────────────────────────────────────");
      debugPrint("📚 Route Stack:");
      for (Route route in _routes) {
        debugPrint("   • ${_fmt(route)}");
      }
      debugPrint("────────────────────────────────────");
    }
  }

  /// Formats a [Route] to a readable name for logging.
  ///
  /// - "/" becomes "Initial"
  /// - Unnamed routes or empty names become "Unnamed"
  /// - All other names are converted to Capitalized format.
  String _fmt(Route? route) {
    String? name = route?.settings.name;
    if (name == null) return "Unknown";
    if (name == "/") return "Initial";
    String cleaned = name.replaceAll("/", "");
    if (cleaned.isEmpty) return "Unnamed";
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }
}
