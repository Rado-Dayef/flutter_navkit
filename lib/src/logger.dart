import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_navkit/flutter_navkit.dart';

/// Logger utility for NavKit package.
///
/// Used internally to print debug messages and errors related to navigation.
/// All messages only appear in debug mode (`kDebugMode`).
class Logger {
  /// Logs an error message with a 🚨 emoji.
  ///
  /// [message] is the error text.
  /// If [withStack] is true, the current navigation stack will be printed.
  static void _error(String message, {bool withStack = false}) {
    if (kDebugMode) {
      debugPrint("🚨 $message");
      _stack(withStack: withStack);
    }
  }

  /// Logs a normal message with a provided emoji prefix.
  ///
  /// [emoji] represents the icon before the message.
  /// If [withStack] is enabled, the current stack will also be printed.
  static void _message(String emoji, String message, {bool withStack = false}) {
    if (kDebugMode) {
      debugPrint("$emoji $message");
      _stack(withStack: withStack);
    }
  }

  /// Prints the full navigator stack when [withStack] is true.
  ///
  /// This uses the tracked stack from [NavkitObserver].
  static void _stack({bool withStack = false}) {
    if (withStack) {
      debugPrint("────────────────────────────────────");
      debugPrint("📚 Route Stack:");
      for (Route route in NavkitObserver.routes) {
        debugPrint("   • ${_fmt(route)}");
      }
      debugPrint("────────────────────────────────────");
    }
  }

  /// Converts a [Route] object into a readable formatted name.
  ///
  /// - "/" becomes "Initial"
  /// - Empty or unnamed routes become "Unnamed"
  /// - Other names are capitalized (e.g., "/homeRoute" → "HomeRoute")
  static String _fmt(Route? route) {
    String? name = route?.settings.name;
    if (name == null) return "Unknown";
    if (name == "/") return "Initial";
    String cleaned = name.replaceAll("/", "");
    if (cleaned.isEmpty) return "Unnamed";
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }

  /// Logs an error for when no route exists to pop back to.
  static void noRouteToBackToError() => _error("No route to back to.");

  /// Logs an error for when something went wrong.
  static void somethingWentWrongError() => _error("Something went wrong.");

  /// Logs an error when a route name is not registered.
  static void routeNotFoundError(String route) => _error("Route \"$route\" not found.");

  /// Logs an error for when count less then or equal 0.
  static void countMustBeGreaterThanZeroError() => _error("Count must be greater than 0.");

  /// Logs an error when the route is not found in the stack.
  /// Shows full stack for debugging.
  static void routeNotFoundInStackError(String route) => _error("Route \"$route\" not found in stack.", withStack: true);

  /// Logs a message when a route is removed.
  static void removeMessage(Route route, bool withStack) => _message("🔄", "Remove → ${_fmt(route)}", withStack: withStack);

  /// Logs an error for when something went wrong while backing until condition.
  static void somethingWentWrongWhileBackingUntilConditionError() => _error("Something went wrong while backing until condition.");

  /// Logs an error for when something went wrong while backing with count.
  static void somethingWentWrongWhileBackingCountScreensError(int count) => _error("Something went wrong while backing $count screens.");

  /// Logs an error for failures when returning to the first route.
  static void somethingWentWrongWhileBackingToTheFirstScreenError() => _error("Something went wrong while backing to the first screen.");

  /// Logs an error for unexpected pop failures.
  static void somethingWentWrongWhileTryingToBackFromTheScreenError() => _error("Something went wrong while trying to back from the screen.");

  /// Logs an error when pushing a widget fails.
  static void somethingWentWrongWhenNavigatingToError(Widget screen) => _error("Something went wrong when navigating to \"${screen.runtimeType.toString()}\".");

  /// Logs a message when a route is replaced.
  static void replaceMessage(Route? route, Route? replacedRoute, bool withStack) => _message("🔀", "Replace → ${_fmt(replacedRoute)} → ${_fmt(route)}", withStack: withStack);

  /// Logs a message when a route is popped.
  static void backMessage(Route route, Route? previousRoute, bool withStack) => _message("⬅️", "Pop → ${_fmt(route)} (back to: ${_fmt(previousRoute)})", withStack: withStack);

  /// Logs a message when a new route is pushed.
  static void toMessage(Route route, Route? previousRoute, bool withStack) => _message("➡️", "Push → ${_fmt(route)}${previousRoute == null ? "" : " (from: ${_fmt(previousRoute)})"}", withStack: withStack);
}
