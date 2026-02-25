import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/entity_with_members.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/session/constants.dart';

part 'session.freezed.dart';

part 'session.g.dart';

@freezed
abstract class Session with _$Session implements EntityWithMembers {
  const Session._();

  const factory Session({
    required String id,
    required String userId,
    @TimestampConverterOptimistic() required DateTime createdAt,
    @TimestampConverterOptimistic() required DateTime updatedAt,
    @TimestampConverter() DateTime? deletedAt,
    required Set<String> memberIds,
    required Set<String> bannedMemberIds,

    required String name,
    required DateTime startedAt,
    DateTime? endedAt,
    @Default([]) List<Drink> drinks,
    @Default(true) bool isSoloSession,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  int get drinksCount => drinks.length;

  bool get hasFreeSpace => drinksCount < maxSessionDrinks;

  bool isActiveAt(DateTime at) {
    final hasStarted = startedAt.isBefore(at);
    final stillRunning = endedAt == null || endedAt!.isAfter(at);
    return hasStarted && stillRunning;
  }
}
