import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/widget/session_drink_item.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/user/model/user_model.dart';

class SessionUserDrinksCard extends StatelessWidget {
  final UserModel user;
  final List<Drink> drinks;
  final bool isMultipleDaySession;

  const SessionUserDrinksCard({
    super.key,
    required this.user,
    required this.drinks,
    required this.isMultipleDaySession,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(user: user, size: 16),
                const Gap(8),
                Text(
                  user.username,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${drinks.length} ${drinks.length == 1 ? 'drink' : 'drinks'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            const Gap(8),
            ...drinks.map(
              (drink) => SessionDrinkItem(
                drink: drink,
                showDate: isMultipleDaySession,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
