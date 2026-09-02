import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';

part 'party_challenge.freezed.dart';
part 'party_challenge.g.dart';

enum PartyChallengeStatus { active, completed, expired, cancelled }

@freezed
abstract class PartyChallenge with _$PartyChallenge implements Document {
  const factory PartyChallenge({
    required String id,
    required String title,
    required String instructions,
    required int pointsUnits,
    @TimestampConverter() required DateTime startsAt,
    @TimestampConverter() required DateTime endsAt,
    required PartyChallengeStatus status,
    @Default(<String>[]) List<String> winnerIds,
    required String createdByUserId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _PartyChallenge;

  factory PartyChallenge.fromJson(Map<String, dynamic> json) =>
      _$PartyChallengeFromJson(json);
}
