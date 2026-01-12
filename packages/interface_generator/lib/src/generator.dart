import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Generator that creates abstract interface classes and extension methods
/// from Freezed classes based on build.yaml configuration.
///
/// Configuration in build.yaml:
/// ```yaml
/// targets:
///   $default:
///     builders:
///       interface_generator:interface_builder:
///         options:
///           class_suffix: "Core"            # Classes ending with this get interfaces
///           interface_suffix: "Fields"      # Generated interface suffix
/// ```
///
/// Example:
/// - Input: `DrinkTypeCore` → Output: `DrinkTypeFields` interface + `toCore()` extension
class InterfaceGenerator extends Generator {
  final String classSuffix;
  final String interfaceSuffix;

  InterfaceGenerator({
    required this.classSuffix,
    required this.interfaceSuffix,
  });

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final output = StringBuffer();

    for (final classElement in library.classes) {
      final className = classElement.name;
      if (className == null) continue;

      // Only process classes ending with the configured suffix
      if (!className.endsWith(classSuffix)) {
        continue;
      }

      // Find the factory constructor (Freezed pattern)
      ConstructorElement? constructor;
      for (final c in classElement.constructors) {
        final name = c.name ?? '';
        // Look for: factory constructor, not fromJson, unnamed (name is empty or "new")
        final isUnnamed = name.isEmpty || name == 'new';
        if (c.isFactory && !name.contains('fromJson') && isUnnamed) {
          constructor = c;
          break;
        }
      }

      if (constructor == null) {
        // Not a Freezed class or no suitable constructor, skip
        continue;
      }

      // Generate interface name: DrinkTypeCore → DrinkTypeFields
      final baseName = className.substring(
        0,
        className.length - classSuffix.length,
      );
      final interfaceName = '$baseName$interfaceSuffix';

      // Extract parameters and build getters
      final getters = StringBuffer();
      final constructorArgs = StringBuffer();
      for (final param in constructor.formalParameters) {
        final paramName = param.name;
        final paramType = param.type.getDisplayString();
        getters.writeln('  $paramType get $paramName;');
        constructorArgs.writeln('      $paramName: $paramName,');
      }

      output.writeln('''
/// Generated interface for [$className].
/// 
/// This interface is automatically generated from the constructor parameters
/// of the Freezed class. Any class implementing this interface must provide
/// all the getters defined below.
abstract interface class $interfaceName {
$getters}

/// Extension that provides a `toCore()` method on any class implementing
/// [$interfaceName], converting it to a [$className] instance.
extension ${interfaceName}Extension on $interfaceName {
  $className toCore() => $className(
$constructorArgs    );
}
''');
    }

    final result = output.toString();
    return result.isEmpty ? null : result;
  }
}
