import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';
import 'package:remembeer/party/widget/party_ranking.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('announces rank, points, drinks, and current user', (
    tester,
  ) async {
    final member = PartyMember(
      id: 'user-1',
      userId: 'user-1',
      scoreUnits: 5250,
      drinkCount: 2,
      joinedAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    const user = UserModel(
      id: 'user-1',
      email: 'user@example.com',
      username: 'User',
      searchableUsername: 'user',
    );
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PartyRanking(
            standings: [
              PartyStanding(
                rank: 1,
                member: member,
                user: user,
                username: user.username,
                isCurrentUser: true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('Rank 1, User, 5.25 points, 2 drinks, you'),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
