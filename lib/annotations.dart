/// Annotation to mark widgets for automatic route generation
class NavkitRoute {
  /// Optional custom route name. If not provided, generates from class name
  final bool isInitial;

  const NavkitRoute({this.isInitial = false});
}