import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/entity_with_members.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
abstract class Session with _$Session implements EntityWithMembers {
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
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
