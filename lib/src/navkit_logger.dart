import 'package:flutter/foundation.dart';

/// Logger utility for NavKit package.
///
/// Used to print debug messages and errors related to navigation.
/// All output occurs only in debug mode (`kDebugMode`).
class NavkitLogger {
  /// Logs an error message with a 🚨 emoji prefix.
  ///
  /// [message]: The error message to print.
  /// [stack]: Optional callback to print additional debug info, like route stack.
  static void error(String message, {VoidCallback? stack}) {
    if (kDebugMode) {
      debugPrint("🚨 $message");
      stack?.call();
    }
  }

  /// Logs a general message with a custom emoji prefix.
  ///
  /// [emoji]: Emoji or symbol to prefix the message (e.g., "📚", "🔄", "🔀").
  /// [message]: The message to print.
  /// [stack]: Optional callback to print additional debug info.
  static void message(String emoji, String message, {VoidCallback? stack}) {
    if (kDebugMode) {
      debugPrint("$emoji $message");
      stack?.call();
    }
  }
}
