import 'package:remembeer/badge/model/badge_category.dart';

typedef BadgeDefinition = ({
  String id,
  String name,
  String description,
  String iconPath,
  BadgeCategory category,
  int? goal,
});
