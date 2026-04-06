import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/activity/type/user_with_drinks.dart';
import 'package:remembeer/drink/model/drink.dart';
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

  List<UserWithDrinks> get drinksByUser {
    if (session.drinks.isEmpty) {
      return [];
    }

    final drinksByUserId = <String, List<Drink>>{};
    for (final drink in session.drinks) {
      drinksByUserId.putIfAbsent(drink.consumedByUserId, () => []).add(drink);
    }

    for (final userDrinks in drinksByUserId.values) {
      userDrinks.sort((a, b) => a.consumedAt.compareTo(b.consumedAt));
    }

    final result = <UserWithDrinks>[];
    for (final entry in drinksByUserId.entries) {
      final user = members[entry.key];
      if (user != null) {
        result.add((user: user, drinks: entry.value));
      }
    }

    return result;
  }
}
