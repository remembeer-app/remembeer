import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/badge/model/badge_category.dart';

part 'badge_definition.freezed.dart';

// TODO(ohtenkay): This class could be typedef probably
@freezed
abstract class BadgeDefinition with _$BadgeDefinition {
  const factory BadgeDefinition({
    required String id,
    required String name,
    required String description,
    required String iconPath,
    required BadgeCategory category,
    int? goal,
  }) = _BadgeDefinition;
}
