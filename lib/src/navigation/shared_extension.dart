import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/logger.dart';

/// Shared navigation utilities available on every [BuildContext].
///
/// These helpers provide quick access to route metadata and safe navigation
/// actions without throwing exceptions.
extension SharedExtension on BuildContext {
  /// Back the top-most route in the navigation stack.
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

  /// Pops all routes until the **first/root route** in the navigator stack is reached.
  ///
  /// Typically, this is the "/" route in your app.
  /// If an error occurs (e.g., the navigator cannot be found in this context),
  /// it will log an error via [Logger] instead of throwing.
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

  /// Pop multiple screens at once.
  ///
  /// [count] Number of screens to pop. Must be > 0.
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
  /// [predicate] Function that returns true when the desired route is reached.
  void backUntil({bool Function(Route<dynamic>)? predicate}) {
    try {
      Navigator.of(this).popUntil(predicate ?? (route) => false);
    } catch (e) {
      Logger.somethingWentWrongWhileBackingUntilConditionError();
    }
  }

  /// Returns `true` if the current route contains arguments of type [T].
  ///
  /// Useful for validating data before accessing it.
  bool hasArguments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    return args is T;
  }

  /// Safely returns the route arguments **typed as** [T].
  ///
  /// If the arguments don't match the provided type, `null` is returned
  /// instead of throwing a cast error.
  T? arguments<T>() {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args is T) return args;
    return null;
  }

  /// Show a modal bottom sheet and return its result.
  ///
  /// This is a wrapper around Flutter's [showModalBottomSheet] with added
  /// safety and error logging via [Logger]. It ensures that any unexpected
  /// errors do not crash the app.
  ///
  /// [builder] Required function that returns the content of the bottom sheet.
  /// [elevation] Optional elevation of the bottom sheet.
  /// [clipBehavior] Optional clipping behavior for the sheet.
  /// [requestFocus] Whether to request focus when the sheet is shown.
  /// [shape] Custom shape of the bottom sheet.
  /// [barrierColor] The color of the scrim/barrier behind the sheet.
  /// [anchorPoint] Position where the sheet is anchored (for iOS-style sheets).
  /// [barrierLabel] Accessibility label for the barrier.
  /// [showDragHandle] Whether to show a drag handle at the top of the sheet.
  /// [backgroundColor] Background color of the sheet.
  /// [enableDrag] Whether the sheet can be dragged down to dismiss.
  /// [useSafeArea] If true, positions the sheet inside the safe area.
  /// [isDismissible] Whether tapping outside dismisses the sheet.
  /// [constraints] Optional constraints to control the sheet size.
  /// [routeSettings] Route settings for the modal route.
  /// [useRootNavigator] Whether to push the sheet using the root navigator.
  /// [isScrollControlled] Whether the sheet height is controlled by its content.
  /// [sheetAnimationStyle] Optional animation style for the sheet.
  /// [transitionAnimationController] Optional controller for custom transitions.
  /// [scrollControlDisabledMaxHeightRatio] Max height ratio when scroll control is disabled.
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

  /// Show a customizable SnackBar safely on the current context.
  ///
  /// This is a wrapper around Flutter's [ScaffoldMessenger.showSnackBar]
  /// with added error handling via [Logger]. Any unexpected error will be
  /// caught and logged instead of crashing the app.
  ///
  /// [key] Optional key for the SnackBar widget.
  /// [width] Optional fixed width of the SnackBar.
  /// [elevation] Elevation of the SnackBar for shadow effect.
  /// [shape] Custom shape of the SnackBar.
  /// [padding] Internal padding for the content inside the SnackBar.
  /// [showCloseIcon] Whether to show a close icon (available in Flutter 3.7+).
  /// [closeIconColor] Color of the close icon.
  /// [backgroundColor] Background color of the SnackBar.
  /// [action] Optional SnackBarAction to show a button inside the SnackBar.
  /// [content] Required widget displayed as the main content of the SnackBar.
  /// [onVisible] Callback invoked when the SnackBar becomes visible.
  /// [margin] External margin around the SnackBar.
  /// [animation] Optional animation controlling SnackBar transitions.
  /// [actionOverflowThreshold] Threshold for action overflow handling.
  /// [hitTestBehavior] How the SnackBar handles pointer events.
  /// [clipBehavior] Clipping behavior for the SnackBar content.
  /// [dismissDirection] Direction in which the SnackBar can be dismissed.
  /// [duration] How long the SnackBar is displayed (default 4 seconds).
  /// [behavior] Controls the layout behavior, fixed or floating.
  Future<void> showSnackBar({
    Key? key,
    double? width,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsets? padding,
    bool? showCloseIcon,
    Color? closeIconColor,
    Color? backgroundColor,
    SnackBarAction? action,
    required Widget content,
    VoidCallback? onVisible,
    EdgeInsetsGeometry? margin,
    Animation<double>? animation,
    double? actionOverflowThreshold,
    HitTestBehavior? hitTestBehavior,
    Clip clipBehavior = Clip.hardEdge,
    DismissDirection? dismissDirection,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
  }) async {
    try {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          key: key,
          width: width,
          shape: shape,
          margin: margin,
          action: action,
          padding: padding,
          content: content,
          duration: duration,
          behavior: behavior,
          elevation: elevation,
          onVisible: onVisible,
          animation: animation,
          clipBehavior: clipBehavior,
          showCloseIcon: showCloseIcon,
          closeIconColor: closeIconColor,
          hitTestBehavior: hitTestBehavior,
          backgroundColor: backgroundColor,
          dismissDirection: dismissDirection,
          actionOverflowThreshold: actionOverflowThreshold,
        ),
      );
    } catch (e) {
      Logger.somethingWentWrongError();
    }
  }

  /// Show a dialog safely on the current [BuildContext].
  ///
  /// Wraps Flutter's [showDialog] with error handling and optional customization.
  /// Returns the dialog's result as a [Future<T?>], or `null` if an error occurs.
  ///
  /// [requestFocus] Whether the dialog should request focus automatically.
  /// [barrierColor] Color of the modal barrier behind the dialog.
  /// [anchorPoint] Optional point to anchor the dialog (like context menus).
  /// [barrierLabel] Semantic label for accessibility.
  /// [useSafeArea] If true, avoids system UI areas (default true).
  /// [useRootNavigator] If true, pushes the dialog on the root navigator.
  /// [routeSettings] Optional [RouteSettings] for the dialog.
  /// [barrierDismissible] Whether tapping outside dismisses the dialog (default true).
  /// [animationStyle] Optional custom animation style for the dialog.
  /// [transitionBuilder] Optional custom route transition builder.
  /// [traversalEdgeBehavior] Optional behavior for focus traversal inside the dialog.
  /// [builder] Required builder function that returns the dialog widget.
  Future<T?> showAppDialog<T>({
    bool? requestFocus,
    Color? barrierColor,
    Offset? anchorPoint,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    bool barrierDismissible = true,
    AnimationStyle? animationStyle,
    RouteTransitionsBuilder? transitionBuilder,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    required Widget Function(BuildContext) builder,
  }) async {
    try {
      return showDialog<T>(
        context: this,
        builder: builder,
        useSafeArea: useSafeArea,
        anchorPoint: anchorPoint,
        requestFocus: requestFocus,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        routeSettings: routeSettings,
        animationStyle: animationStyle,
        useRootNavigator: useRootNavigator,
        barrierDismissible: barrierDismissible,
        traversalEdgeBehavior: traversalEdgeBehavior,
      );
    } catch (e) {
      // Log error instead of letting the app crash
      Logger.somethingWentWrongError();
      return null;
    }
  }

  /// Check whether the current navigator stack can pop any routes.
  ///
  /// Returns `true` if there is at least one route to pop (i.e., not the first route),
  /// otherwise returns `false`.
  bool get canPop => Navigator.of(this).canPop();

}
