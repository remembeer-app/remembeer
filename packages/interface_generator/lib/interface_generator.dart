/// Interface Generator for Freezed classes.
///
/// This package automatically generates abstract interface classes from
/// Freezed classes based on naming conventions configured in build.yaml.
///
/// Configuration (in your project's build.yaml):
/// ```yaml
/// targets:
///   $default:
///     builders:
///       interface_generator:interface_builder:
///         options:
///           class_suffix: "Core"        # Classes ending with this get interfaces
///           interface_suffix: "Fields"  # Generated interface suffix
/// ```
///
/// Example:
/// A Freezed class named `DrinkTypeCore` will generate:
/// ```dart
/// abstract interface class DrinkTypeFields {
///   String get name;
///   // ... other getters from constructor parameters
/// }
/// ```
library;
