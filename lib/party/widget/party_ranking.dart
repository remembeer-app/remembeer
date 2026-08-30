import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyRanking extends StatelessWidget {
  final Session session;
  final List<UserModel> members;

  const PartyRanking({super.key, required this.session, required this.members});

  @override
  Widget build(BuildContext context) {
    final drinksByMember = <String, int>{};
    for (final drink in session.drinks) {
      drinksByMember.update(
        drink.consumedByUserId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final rankedMembers =
        members
            .map((user) => (user: user, drinks: drinksByMember[user.id] ?? 0))
            .toList()
          ..sort((a, b) {
            final drinksComparison = b.drinks.compareTo(a.drinks);
            if (drinksComparison != 0) {
              return drinksComparison;
            }
            return a.user.username.toLowerCase().compareTo(
              b.user.username.toLowerCase(),
            );
          });
    final standings = <({int drinks, int rank, UserModel user})>[];
    for (var index = 0; index < rankedMembers.length; index++) {
      final member = rankedMembers[index];
      final hasSharedRank =
          index > 0 && rankedMembers[index - 1].drinks == member.drinks;
      standings.add((
        user: member.user,
        drinks: member.drinks,
        rank: hasSharedRank ? standings.last.rank : index + 1,
      ));
    }

    return ListView.separated(
      itemCount: standings.length,
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        final standing = standings[index];

        return _PartyStandingCard(
          rank: standing.rank,
          user: standing.user,
          drinks: standing.drinks,
        );
      },
    );
  }
}

class _PartyStandingCard extends StatelessWidget {
  final int rank;
  final UserModel user;
  final int drinks;

  const _PartyStandingCard({
    required this.rank,
    required this.user,
    required this.drinks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLeader = rank == 1;

    return Card(
      color: isLeader ? theme.colorScheme.primaryContainer : null,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '#$rank',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isLeader ? theme.colorScheme.onPrimaryContainer : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            UserAvatar(user: user),
            const Gap(12),
            Expanded(
              child: Text(
                user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap(8),
            Text(
              '$drinks ${drinks == 1 ? 'drink' : 'drinks'}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
