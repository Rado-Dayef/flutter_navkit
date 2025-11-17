/// Annotation used to mark widgets for **automatic route generation**
///
/// When you annotate a widget class with [NavkitRoute], the code generator
/// will automatically create route names for it in the `NavkitRoutes` class.
///
/// Example:
/// ```dart
/// @NavkitRoute(isInitial: true)
/// class HomeScreen extends StatelessWidget { ... }
/// ```
/// This will generate a route named `/` for `HomeScreen`.
class NavkitRoute {
  /// Marks this widget as the **initial route** (root "/").
  ///
  /// Default is `false`. If `true`, the generated route will be `/`.
  final bool isInitial;

  /// Creates a [NavkitRoute] annotation.
  ///
  /// [isInitial]: set to `true` if this widget should be the root route.
  const NavkitRoute({this.isInitial = false});
}
