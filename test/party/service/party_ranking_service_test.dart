import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  const service = PartyRankingService();

  test('ranks aggregate totals with shared ranks and username ordering', () {
    final standings = service.rank(
      members: [
        _member('c', 2000),
        _member('b', 5000),
        _member('a', 5000),
        _member('d', 1000),
      ],
      users: [
        _user('a', 'Alice'),
        _user('b', 'bob'),
        _user('c', 'Cara'),
        _user('d', 'Dan'),
      ],
      currentUserId: 'b',
    );

    expect(standings.map((standing) => standing.username), [
      'Alice',
      'bob',
      'Cara',
      'Dan',
    ]);
    expect(standings.map((standing) => standing.rank), [1, 1, 3, 4]);
    expect(standings[1].isCurrentUser, isTrue);
    expect(standings[1].member.drinkCount, 2);
  });

  test('preserves an aggregate when its user profile is unavailable', () {
    final standings = service.rank(
      members: [_member('departed', 3000)],
      users: const [],
      currentUserId: 'current',
    );

    expect(standings.single.username, 'Former member');
    expect(standings.single.member.scoreUnits, 3000);
  });
}

PartyMember _member(String userId, int score) => PartyMember(
  id: userId,
  userId: userId,
  scoreUnits: score,
  drinkCount: 2,
  joinedAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

UserModel _user(String id, String username) => UserModel(
  id: id,
  email: '$id@example.com',
  username: username,
  searchableUsername: username.toLowerCase(),
);
