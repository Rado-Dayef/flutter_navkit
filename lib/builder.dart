import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_navkit/annotations.dart';

/// A code generator that automatically creates a `NavkitRoutes` class
/// based on classes annotated with `@NavkitRoute`.
///
/// For every annotated widget:
/// - If `isInitial: true`, it generates a root route `/`.
/// - Otherwise, it generates a route based on the class name,
///   e.g., `MyScreen` → `/myScreenRoute`.
///
/// The generated `NavkitRoutes` class contains:
/// - Static constants for each route
/// - A map of all registered routes
class NavkitRoutesGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotatedWidgets = <String, String>{};

    // Find all classes annotated with @NavkitRoute
    for (var element in library.allElements) {
      if (element is ClassElement) {
        final annotation = const TypeChecker.typeNamed(NavkitRoute).firstAnnotationOf(element);

        if (annotation != null) {
          String className = element.name ?? "";
          final isInitialArg = annotation.getField("isInitial")?.toBoolValue();

          // Determine the route name
          final routeName = (isInitialArg ?? false)
              ? "/" // root route
              : "/${className[0].toLowerCase()}${className.substring(1)}Route";

          annotatedWidgets[className] = routeName;
        }
      }
    }

    // If no annotated widgets, generate nothing
    if (annotatedWidgets.isEmpty) {
      return "";
    }

    // Generate the NavkitRoutes class
    final buffer = StringBuffer();
    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
    buffer.writeln("// **************************************************************************");
    buffer.writeln("// NavkitRoutesGenerator");
    buffer.writeln("// **************************************************************************");
    buffer.writeln();
    buffer.writeln("class NavkitRoutes {");
    buffer.writeln("  NavkitRoutes._();"); // private constructor
    buffer.writeln();

    // Add static constants for each route
    for (var entry in annotatedWidgets.entries) {
      final camelCase = _toCamelCase(entry.key);
      final routeValue = entry.value;
      buffer.writeln("  /// Route name for ${entry.key}");
      buffer.writeln("  static const String $camelCase = '$routeValue';");
      buffer.writeln();
    }

    // Add a map of all routes
    buffer.writeln("  /// All registered routes");
    buffer.writeln("  static const Map<String, String> all = {");
    for (var entry in annotatedWidgets.entries) {
      final routeValue = entry.value;
      buffer.writeln("    \"${entry.key}\": \"$routeValue\",");
    }
    buffer.writeln("  };");
    buffer.writeln("}");

    return buffer.toString();
  }

  /// Converts a class name to camelCase (e.g., `MyScreen` → `myScreen`)
  String _toCamelCase(String className) {
    if (className.isEmpty) return className;
    return className[0].toLowerCase() + className.substring(1);
  }
}

/// Factory builder for `NavkitRoutesGenerator`
///
/// Registers the generator with `build_runner` and specifies the
/// file extension for the generated file (`.navkit.dart`).
Builder navkitRoutesBuilder(BuilderOptions options) {
  return LibraryBuilder(NavkitRoutesGenerator(), generatedExtension: ".navkit.dart");
}
