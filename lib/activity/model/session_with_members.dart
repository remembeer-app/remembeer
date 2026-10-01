import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/activity/type/user_with_drink_logs.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/model/user_model.dart';

part 'session_with_members.freezed.dart';

@freezed
abstract class SessionWithMembers with _$SessionWithMembers {
  const SessionWithMembers._();

  const factory SessionWithMembers({
    required Session session,
    required Map<String, UserModel> members,
  }) = _SessionWithMembers;

  List<UserModel> get membersList => members.values.toList();

  int get memberCount => members.length;

  bool isMultipleDaySession() {
    return session.isMultipleDaySession;
  }

  List<UserWithDrinkLogs> get drinkLogsByUser {
    if (session.drinkLogs.isEmpty) {
      return [];
    }

    final drinkLogsByUserId = <String, List<DrinkLog>>{};
    for (final drinkLog in session.drinkLogs) {
      drinkLogsByUserId
          .putIfAbsent(drinkLog.consumedByUserId, () => [])
          .add(drinkLog);
    }

    for (final userDrinkLogs in drinkLogsByUserId.values) {
      userDrinkLogs.sort((a, b) => a.consumedAt.compareTo(b.consumedAt));
    }

    final result = <UserWithDrinkLogs>[];
    for (final entry in drinkLogsByUserId.entries) {
      final user = members[entry.key];
      if (user != null) {
        result.add((user: user, drinkLogs: entry.value));
      }
    }

    return result;
  }
}
