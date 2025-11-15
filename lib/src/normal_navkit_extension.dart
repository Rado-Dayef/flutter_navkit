import 'package:flutter/material.dart';

extension NormalNavKit on BuildContext {
  /// Push a new screen
  Future<T?> push<T>(Widget screen) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => screen));
  }

  /// Push and remove all previous screens
  Future<T?> pushReplacementTo<T>(Widget screen) {
    return Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  /// Push and clear entire stack
  Future<T?> pushAndRemoveAll<T>(Widget screen, {bool Function(Route<dynamic>)? predicate}) {
    return Navigator.of(this).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen), predicate ?? (route) => false);
  }

  /// Pop the current screen
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Pop until first screen
  void popToFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    return Navigator.of(this).maybePop(result);
  }

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();
}
