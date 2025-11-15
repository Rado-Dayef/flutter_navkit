/// Annotation to mark widgets for automatic route generation
class NavkitRoute {
  /// Optional custom route name. If not provided, generates from class name
  final String? routeName;

  const NavkitRoute({this.routeName});
}