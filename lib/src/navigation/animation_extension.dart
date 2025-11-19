import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/logger.dart';

/// Extension on [BuildContext] providing **direct widget navigation**
///
/// Use these methods to push, replace, or remove screens without using
/// named routes. Ideal for simpler or one-off screens where you don't
/// need route names.
extension AnimationExtension on BuildContext {
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
        Offset begin = Offset(1.0, 0.0);
        Offset end = Offset.zero;
        Curve curve = Curves.easeInOut;
        Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        Animation<Offset> offsetAnimation = animation.drive(tween);
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
}
