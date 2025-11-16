import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavkitObserver extends NavigatorObserver {
  bool withStack;

  NavkitObserver({this.withStack = false});

  static final List<Route<dynamic>> _routes = [];

  static bool hasRoute(String routeName) {
    return _routes.any((route) => route.settings.name == routeName);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _routes.add(route);

    if (kDebugMode) {
      debugPrint("➡️ Push → ${_fmt(route)}${previousRoute == null ? "" : " (from: ${_fmt(previousRoute)})"}");
      _printStack();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _routes.remove(route);

    if (kDebugMode) {
      debugPrint("⬅️ Pop → ${_fmt(route)} (back to: ${_fmt(previousRoute)})");
      _printStack();
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _routes.remove(route);

    if (kDebugMode) {
      debugPrint("🔄 Remove → ${_fmt(route)}");
      _printStack();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) _routes.remove(oldRoute);
    if (newRoute != null) _routes.add(newRoute);

    if (kDebugMode) {
      debugPrint("🔀 Replace → ${_fmt(oldRoute)} → ${_fmt(newRoute)}");
      _printStack();
    }
  }

  void _printStack() {
    if (withStack) {
      if (kDebugMode) {
        debugPrint("────────────────────────────────────");
        debugPrint("📚 Route Stack:");
        for (final route in _routes) {
          debugPrint("   • ${_fmt(route)}");
        }
        debugPrint("────────────────────────────────────");
      }
    }
  }

  String _fmt(Route? route) {
    final name = route?.settings.name;
    if (name == null) return "Unknown";
    if (name == "/") return "Initial";
    final cleaned = name.replaceAll("/", "");
    if (cleaned.isEmpty) return "Unnamed";
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }
}
