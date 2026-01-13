import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';

part 'session_create.freezed.dart';
part 'session_create.g.dart';

@freezed
abstract class SessionCreate with _$SessionCreate implements ValueObject {
  const factory SessionCreate({
    required String name,
    required DateTime startedAt,
    DateTime? endedAt,
    required Set<String> memberIds,
    @Default({}) Set<String> bannedMemberIds,
  }) = _SessionCreate;

  factory SessionCreate.fromJson(Map<String, dynamic> json) =>
      _$SessionCreateFromJson(json);
}
