import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/model/session_with_members.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';

class SessionStatisticsCard extends StatelessWidget {
  final SessionWithMembers sessionWithMembers;

  const SessionStatisticsCard({super.key, required this.sessionWithMembers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = sessionWithMembers.session;
    final drinks = session.drinks;
    final memberCount = sessionWithMembers.memberCount;

    final totalDrinks = drinks.length;
    final totalAlcoholMl = session.totalAlcoholMl;
    final avgDrinksPerPerson = memberCount > 0 ? totalDrinks / memberCount : 0;
    final duration = formatDuration(session.startedAt, session.endedAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            const Gap(12),
            _buildStatRow(
              context,
              'Total Drinks',
              totalDrinks.toString(),
              Icons.local_bar,
            ),
            _buildStatRow(
              context,
              'Total Alcohol',
              '${totalAlcoholMl.toStringAsFixed(0)}ml',
              Icons.science,
            ),
            _buildStatRow(
              context,
              'Avg per Person',
              avgDrinksPerPerson.toStringAsFixed(1),
              Icons.person,
            ),
            _buildStatRow(context, 'Duration', duration, Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const Gap(12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
