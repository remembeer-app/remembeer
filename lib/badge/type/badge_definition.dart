import 'package:remembeer/badge/model/badge_category.dart';

typedef BadgeDefinition = ({
  String id,
  String name,
  String description,
  String iconPath,

  /// Whether the icon is a finished circular artwork that should fill the
  /// badge circle edge to edge, instead of sitting inside the default ring.
  bool iconFillsCircle,
  BadgeCategory category,
  int? goal,
});
