import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/constants.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';
import 'package:remembeer/party/widget/party_ranking.dart';

class PartyRankingPreview extends StatelessWidget {
  final List<PartyStanding> standings;
  final bool isFinal;
  final VoidCallback onTap;

  const PartyRankingPreview({
    super.key,
    required this.standings,
    required this.isFinal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (standings.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final podium = standings.where(
      (standing) => standing.rank <= partyRankingPreviewMaxRank,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isFinal ? 'Final ranking' : 'Ranking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              TextButton(onPressed: onTap, child: const Text('See all')),
            ],
          ),
        ),
        const Gap(8),
        for (final standing in podium) ...[
          PartyStandingCard(standing: standing, onTap: onTap),
          const Gap(8),
        ],
      ],
    );
  }
}
