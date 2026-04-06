import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/model/session_with_members.dart';
import 'package:remembeer/activity/widget/session_user_drinks_card.dart';

class SessionDrinksSection extends StatelessWidget {
  final SessionWithMembers sessionWithMembers;

  const SessionDrinksSection({super.key, required this.sessionWithMembers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drinks = sessionWithMembers.session.drinks;

    if (drinks.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Drinks',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const Gap(8),
        ...sessionWithMembers.drinksByUser.map((userDrinks) {
          return SessionUserDrinksCard(
            user: userDrinks.user,
            drinks: userDrinks.drinks,
            isMultipleDaySession: sessionWithMembers.isMultipleDaySession(),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.no_drinks,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
              const Gap(8),
              Text(
                'No drinks in this session',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
