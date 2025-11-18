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

  /// Pop back to the first screen in the stack.
  void backToFirst() {
    try {
      Navigator.of(this).popUntil((route) => route.isFirst);
    } catch (e) {
      Logger.somethingWentWrongWhileBackingToTheFirstScreenError();
    }
  }

  /// Attempts to pop the current screen, returning `true` if successful.
  ///
  /// Optionally pass a [result] to return to the previous screen.
  Future<bool> maybeBack<T extends Object?>([T? result]) async {
    try {
      return Navigator.of(this).maybePop(result);
    } catch (e) {
      Logger.somethingWentWrongWhileTryingToBackFromTheScreenError();
      return false;
    }
  }

  /// Check if the current navigator can pop any screens.
  bool get canPop => Navigator.of(this).canPop();

  // ═══════════════════════════════════════════════════════════════════════
  // 🆕 SUGGESTED ADDITIONS
  // ═══════════════════════════════════════════════════════════════════════

  /// Push a screen with custom transition animation.
  ///
  /// [screen]: The widget to navigate to.
  /// [transitionDuration]: Duration of the transition animation.
  /// [transitionsBuilder]: Custom transition animation builder.
  Future<T?> toWithTransition<T>(Widget screen, {Duration transitionDuration = const Duration(milliseconds: 300), RouteTransitionsBuilder? transitionsBuilder}) async {
    try {
      return Navigator.of(this).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionDuration: transitionDuration,
          transitionsBuilder:
              transitionsBuilder ??
              (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
        ),
      );
    } catch (e) {
      Logger.somethingWentWrongWhenNavigatingToError(screen);
      return null;
    }
  }

  /// Push a screen with slide transition from right.
  Future<T?> toWithSlide<T>(Widget screen) async {
    return toWithTransition<T>(
      screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  /// Push a screen with fade transition.
  Future<T?> toWithFade<T>(Widget screen) async {
    return toWithTransition<T>(
      screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Push a screen with scale transition.
  Future<T?> toWithScale<T>(Widget screen) async {
    return toWithTransition<T>(
      screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(scale: animation, child: child);
      },
    );
  }

  /// Pop multiple screens at once.
  ///
  /// [count]: Number of screens to pop. Must be > 0.
  void backMultiple(int count) {
    if (count <= 0) {
      Logger.countMustBeGreaterThanZeroError();
      return;
    }
    try {
      int popped = 0;
      Navigator.of(this).popUntil((route) {
        if (popped >= count) return true;
        popped++;
        return false;
      });
    } catch (e) {
      Logger.somethingWentWrongWhileBackingCountScreensError(count);
    }
  }

  /// Pop until a certain condition is met.
  ///
  /// [predicate]: Function that returns true when the desired route is reached.
  void backUntil({bool Function(Route<dynamic>)? predicate}) {
    try {
      Navigator.of(this).popUntil(predicate ?? (route) => false);
    } catch (e) {
      Logger.somethingWentWrongWhileBackingUntilConditionError();
    }
  }

  /// Show a modal bottom sheet and return its result.
  ///
  /// [builder]: Builder function for the bottom sheet content.
  Future<T?> showSheet<T>({
    double? elevation,
    Clip? clipBehavior,
    bool? requestFocus,
    ShapeBorder? shape,
    Color? barrierColor,
    Offset? anchorPoint,
    String? barrierLabel,
    bool? showDragHandle,
    Color? backgroundColor,
    bool enableDrag = false,
    bool useSafeArea = false,
    bool isDismissible = true,
    BoxConstraints? constraints,
    RouteSettings? routeSettings,
    bool useRootNavigator = false,
    bool isScrollControlled = false,
    AnimationStyle? sheetAnimationStyle,
    required Widget Function(BuildContext) builder,
    AnimationController? transitionAnimationController,
    double scrollControlDisabledMaxHeightRatio = 9 / 16,
  }) async {
    try {
      return showModalBottomSheet<T>(
        context: this,
        shape: shape,
        builder: builder,
        elevation: elevation,
        enableDrag: enableDrag,
        anchorPoint: anchorPoint,
        constraints: constraints,
        useSafeArea: useSafeArea,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        clipBehavior: clipBehavior,
        requestFocus: requestFocus,
        routeSettings: routeSettings,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        useRootNavigator: useRootNavigator,
        isScrollControlled: isScrollControlled,
        sheetAnimationStyle: sheetAnimationStyle,
        transitionAnimationController: transitionAnimationController,
        scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      );
    } catch (e) {
      Logger.somethingWentWrongError();
      return null;
    }
  }
  //
  // /// Show a full-screen dialog.
  // ///
  // /// [screen]: The widget to display as a dialog.
  // Future<T?> showFullScreenDialog<T>(Widget screen) async {
  //   try {
  //     return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => screen, fullscreenDialog: true));
  //   } catch (e) {
  //     NavkitLogger.error("Something went wrong showing dialog.");
  //     return null;
  //   }
  // }

  // /// Remove a specific route from the stack.
  // ///
  // /// [routeName]: Name of the route to remove (if using named routes).
  // void removeRoute(String routeName) {
  //   try {
  //     Navigator.of(this).popUntil((route) {
  //       if (route.settings.name == routeName) {
  //         Navigator.of(this).removeRoute(route);
  //         return true;
  //       }
  //       return true;
  //     });
  //   } catch (e) {
  //     NavkitLogger.error("Something went wrong removing route '$routeName'.");
  //   }
  // }
}
