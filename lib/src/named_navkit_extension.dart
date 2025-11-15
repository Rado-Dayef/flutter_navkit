import 'package:flutter/material.dart';
import 'package:flutter_navkit/src/navkit_observer.dart';

extension NamedNavKit on BuildContext {
  /// Pop until you reach a certain named route
  void popTo(String routeName) {
    Navigator.popUntil(this, ModalRoute.withName(routeName));
  }

  /// Push a named route
  Future<T?> pushRoute<T>(String route, {Object? args}) {
    return Navigator.pushNamed(this, route, arguments: args);
  }

  /// Push replacement with route name
  Future<T?> pushReplacementRoute<T>(String route, {Object? args}) {
    return Navigator.pushReplacementNamed(this, route, arguments: args);
  }

  /// Pop and push a new screen
  Future<T?> popAndPushRoute<T>(String routeName, {Object? args}) {
    return Navigator.of(this).popAndPushNamed(routeName, arguments: args);
  }

  /// Push route and remove all previous
  Future<T?> pushAndRemoveAllRoute<T>(String route, {Object? args, bool Function(Route<dynamic>)? predicate}) {
    return Navigator.pushNamedAndRemoveUntil(this, route, predicate ?? (route) => false, arguments: args);
  }

  /// Check routes & Push a named route
  void tryPushRoute<T>(String route, {Object? args}) async {
    if (NavkitObserver.hasRoute(route)) {
      Navigator.pushNamed<T>(this, route, arguments: args);
    }
    debugPrint("⚠️ Route '$route' not found.");
  }

  /// Check routes & Pop until you reach a certain named route
  void tryPopTo(String routeName) {
    bool exists = false;
    Navigator.popUntil(this, (route) {
      if (route.settings.name == routeName) exists = true;
      return true;
    });
    if (exists) {
      Navigator.popUntil(this, ModalRoute.withName(routeName));
    }
    debugPrint("⚠️ Route '$routeName' not found in stack.");
  }
}
