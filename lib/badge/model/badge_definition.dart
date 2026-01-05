import 'package:remembeer/badge/model/badge_category.dart';

class BadgeDefinition {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final BadgeCategory category;
  final int? goal;

  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    this.goal,
  });
}
