import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_navkit/annotations.dart';

/// Generator that creates NavkitRoutes class from @NavkitRoute annotations
class NavkitRoutesGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final annotatedWidgets = <String, String>{};

    // Find all classes annotated with @NavkitRoute
    for (var element in library.allElements) {
      if (element is ClassElement) {
        final annotation = const TypeChecker.fromRuntime(NavkitRoute)
            .firstAnnotationOf(element);

        if (annotation != null) {
          final className = element.name;
          final routeNameArg = annotation.getField('routeName')?.toStringValue();

          // Generate route name
          final routeName = routeNameArg ??
              '/${className[0].toLowerCase()}${className.substring(1)}Route';

          annotatedWidgets[className] = routeName;
        }
      }
    }

    if (annotatedWidgets.isEmpty) {
      return '';
    }

    // Generate the NavkitRoutes class
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// **************************************************************************');
    buffer.writeln('// NavkitRoutesGenerator');
    buffer.writeln('// **************************************************************************');
    buffer.writeln();
    buffer.writeln('class NavkitRoutes {');
    buffer.writeln('  NavkitRoutes._();');
    buffer.writeln();

    for (var entry in annotatedWidgets.entries) {
      final camelCase = _toCamelCase(entry.key);
      buffer.writeln('  /// Route name for ${entry.key}');
      buffer.writeln('  static const String $camelCase = \'${entry.value}\';');
      buffer.writeln();
    }

    buffer.writeln('  /// Map of all registered routes');
    buffer.writeln('  static const Map<String, String> all = {');
    for (var entry in annotatedWidgets.entries) {
      buffer.writeln('    \'${entry.key}\': \'${entry.value}\',');
    }
    buffer.writeln('  };');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _toCamelCase(String className) {
    if (className.isEmpty) return className;
    return className[0].toLowerCase() + className.substring(1);
  }
}

/// Builder factory
Builder navkitRoutesBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [NavkitRoutesGenerator()],
    'navkit_routes',
  );
}