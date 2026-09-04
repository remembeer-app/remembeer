import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/document.dart';

part 'beerpong_team.freezed.dart';
part 'beerpong_team.g.dart';

@freezed
abstract class BeerpongTeam with _$BeerpongTeam implements Document {
  const factory BeerpongTeam({
    required String id,
    required String name,
    @Default(<String>[]) List<String> memberIds,
    required int seed,
    int? placement,
  }) = _BeerpongTeam;

  factory BeerpongTeam.fromJson(Map<String, dynamic> json) =>
      _$BeerpongTeamFromJson(json);
}
