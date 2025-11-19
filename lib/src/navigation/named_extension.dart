import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/logger.dart';
import 'package:flutter_navkit/src/navkit_observer.dart';

/// Extension on [BuildContext] to provide **named route navigation helpers**
/// with built-in stack checking and debug logging via [Logger].
///
/// These methods simplify navigation tasks like pushing, replacing, or popping
/// to named routes safely, while logging errors in debug mode if routes are missing.
extension NamedExtension on BuildContext {
  /// Push a **named route** onto the navigator stack.
  ///
  /// Returns the result of the route if it completes, or `null` if the route
  /// is not found (and logs an error in debug mode).
  Future<T?> toNamed<T>(String route, {Object? args}) async {
    try {
      return Navigator.pushNamed(this, route, arguments: args);
    } catch (e) {
      Logger.routeNotFoundError(route);
      return null;
    }
  }

  /// Push a named route and **remove all previous routes** from the stack.
  ///
  /// Optionally accepts a [predicate] to control which routes to keep.
  Future<T?> toNamedAndRemoveAll<T>(String route, {Object? args, bool Function(Route<dynamic>)? predicate}) async {
    try {
      return Navigator.pushNamedAndRemoveUntil(this, route, predicate ?? (route) => false, arguments: args);
    } catch (e) {
      Logger.routeNotFoundError(route);
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
      Logger.routeNotFoundError(route);
      return null;
    }
  }

  /// Pop the current route and **go to a new named route** immediately after.
  ///
  /// Similar to `pushReplacement`, but explicitly backs first.
  Future<T?> backAndToNamed<T>(String route, {Object? args}) async {
    try {
      return Navigator.of(this).popAndPushNamed(route, arguments: args);
    } catch (e) {
      Logger.routeNotFoundError(route);
      return null;
    }
  }

  /// Pop routes until you reach a **specific named route** in the stack.
  ///
  /// If the route does not exist, logs an error and optionally prints the stack.
  void backToNamed(String route) {
    if (NavkitObserver.hasRoute(route)) {
      Navigator.popUntil(this, ModalRoute.withName(route));
    } else {
      Logger.routeNotFoundInStackError(route);
    }
  }

  /// Ensure the app is currently displaying a given named route.
  ///
  /// - If the route exists in the stack → back to it.
  /// - If not → go to it.
  ///
  /// Safe wrapper that prevents crashes and logs unexpected issues.
  Future<void> ensureOnRoute(String route, {Object? args}) async {
    try {
      if (NavkitObserver.hasRoute(route)) {
        backToNamed(route);
      } else {
        await toNamed(route, args: args);
      }
    } catch (e) {
      Logger.somethingWentWrongError();
    }
  }

  /// Removes a specific route from the navigator stack by its name.
  ///
  /// This uses NavKit's [NavkitObserver.routes] to find the actual `Route` object
  /// corresponding to the given route name.
  ///
  /// [route]: The name of the route to remove. Only works for named routes.
  /// If the route is not found, an error is logged.
  void removeRouteByName(String route) {
    try {
      // Find the first route in the stack that matches the given name
      Route routeToRemove = NavkitObserver.routes.firstWhere((currentRoute) => currentRoute.settings.name == route);

      // Remove the found route from the navigator
      Navigator.of(this).removeRoute(routeToRemove);
    } catch (e) {
      // If something goes wrong (e.g., route not found), log a safe error
      Logger.somethingWentWrongError();
    }
  }

  /// Check whether a specific named route exists **anywhere** in the stack.
  ///
  /// This does *not* pop or mutate the stack — purely informational.
  bool canPopToNamed(String route) => NavkitObserver.hasRoute(route);

  /// Whether the **current** visible route matches the provided name.
  ///
  /// Useful when preventing duplicate pushes or guarding navigation flows.
  bool isCurrentRoute(String route) => ModalRoute.of(this)?.settings.name == route;

  /// Checks if a route with the given [routeName] exists in the navigator stack.
  ///
  /// Helpful when you want to avoid pushing the same route twice or want to
  /// back to it only if it exists.
  bool isRouteInStack(String routeName) => NavkitObserver.routes.any((r) => r.settings.name == routeName);

  /// The total number of routes currently tracked in the navigator stack.
  ///
  /// This uses NavKit's custom [NavkitObserver] to ensure full stack visibility,
  /// even for unnamed or generated routes.
  int get stackLength => NavkitObserver.routes.length;

  /// Returns `true` if the current route is the first/root route.
  ///
  /// Usually corresponds to the "/" route.
  bool get isFirstRoute => ModalRoute.of(this)?.isFirst ?? false;

  /// Returns whether the current route can be popped.
  ///
  /// Unlike `Navigator.canPop`, this version never throws if the navigator
  /// doesn't exist below this context.
  bool get canPopRoute => ModalRoute.of(this)?.canPop ?? false;

  /// Returns the name of the current route, or `null` if unnamed.
  ///
  /// Useful for:
  /// - analytics
  /// - logging
  /// - conditionally rendering UI depending on the screen
  String? get currentRouteName => ModalRoute.of(this)?.settings.name;
}
