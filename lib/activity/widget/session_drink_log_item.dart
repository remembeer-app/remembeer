import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';

class SessionDrinkLogItem extends StatelessWidget {
  final DrinkLog drink;
  final bool showDate;

  const SessionDrinkLogItem({
    super.key,
    required this.drink,
    required this.showDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final consumedAtText = showDate
        ? formatDayMonthTime(drink.consumedAt)
        : formatTime(drink.consumedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          DrinkIcon(category: drink.drink.category, size: 24),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drink.drink.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${drink.volumeInMilliliters}ml | ${drink.drink.alcoholPercentage}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            consumedAtText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
