import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/logger.dart';

/// Extension on [BuildContext] providing **direct widget navigation**
///
/// Use these methods to push, replace, or remove screens without using
/// named routes. Ideal for simpler or one-off screens where you don't
/// need route names.
extension NormalExtension on BuildContext {
  /// Push a new screen onto the navigation stack.
  ///
  /// [screen]: The widget to navigate to.
  /// Returns a [Future] that completes when the pushed screen is popped.
  Future<T?> to<T>(Widget screen) async {
    try {
      return Navigator.of(this).push(
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: "/${screen.runtimeType.toString()}"),
        ),
      );
    } catch (e) {
      Logger.somethingWentWrongWhenNavigatingToError(screen);
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
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: "/${screen.runtimeType.toString()}"),
        ),
      );
    } catch (e) {
      Logger.somethingWentWrongWhenNavigatingToError(screen);
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
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: "/${screen.runtimeType.toString()}"),
        ),
        predicate ?? (route) => false,
      );
    } catch (e) {
      Logger.somethingWentWrongWhenNavigatingToError(screen);
      return null;
    }
  }
}
