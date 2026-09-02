import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';

part 'beerpong_tournament.freezed.dart';
part 'beerpong_tournament.g.dart';

enum BeerpongTournamentStatus { enrollment, active, completed, cancelled }

@freezed
abstract class BeerpongTournament
    with _$BeerpongTournament
    implements Document {
  const factory BeerpongTournament({
    required String id,
    required BeerpongTournamentStatus status,
    @Default(<String>[]) List<String> participantIds,
    required int teamCount,
    @Default(false) bool thirdPlaceEnabled,
    required int firstPlacePointsUnits,
    required int secondPlacePointsUnits,
    required int thirdPlacePointsUnits,
    required String randomSeedHash,
    String? randomSeedReveal,
    required String createdByUserId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() DateTime? completedAt,
  }) = _BeerpongTournament;

  factory BeerpongTournament.fromJson(Map<String, dynamic> json) =>
      _$BeerpongTournamentFromJson(json);
}
