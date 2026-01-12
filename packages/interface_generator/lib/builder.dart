import 'package:build/build.dart';
import 'package:interface_generator/src/generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builder factory for generating interfaces from Freezed classes.
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
Builder interfaceBuilder(BuilderOptions options) {
  final classSuffix = options.config['class_suffix'] as String? ?? 'Core';
  final interfaceSuffix =
      options.config['interface_suffix'] as String? ?? 'Fields';

  return SharedPartBuilder([
    InterfaceGenerator(
      classSuffix: classSuffix,
      interfaceSuffix: interfaceSuffix,
    ),
  ], 'interface');
}
