import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';

class PartyRanking extends StatelessWidget {
  const PartyRanking({super.key, required this.standings});

  final List<PartyStanding> standings;

  @override
  Widget build(BuildContext context) {
    if (standings.isEmpty) {
      return const Center(child: Text('No Party members to rank'));
    }
    return ListView.separated(
      itemCount: standings.length,
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) =>
          _PartyStandingCard(standing: standings[index]),
    );
  }
}

class _PartyStandingCard extends StatelessWidget {
  const _PartyStandingCard({required this.standing});

  final PartyStanding standing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPodium = standing.rank <= 3;
    final color = standing.isCurrentUser
        ? theme.colorScheme.secondaryContainer
        : isPodium
        ? theme.colorScheme.primaryContainer
        : null;
    final points = formatPartyScore(standing.member.scoreUnits);
    final drinks = standing.member.drinkCount;

    return Semantics(
      container: true,
      label:
          'Rank ${standing.rank}, ${standing.username}, $points points, '
          '$drinks ${drinks == 1 ? 'drink' : 'drinks'}'
          '${standing.isCurrentUser ? ', you' : ''}',
      child: Card(
        color: color,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPodium
              ? BorderSide(color: theme.colorScheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '#${standing.rank}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (standing.user case final user?) UserAvatar(user: user),
              if (standing.user == null)
                const CircleAvatar(child: Icon(Icons.person_outline)),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      standing.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('$drinks ${drinks == 1 ? 'drink' : 'drinks'}'),
                  ],
                ),
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    points,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('points'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
