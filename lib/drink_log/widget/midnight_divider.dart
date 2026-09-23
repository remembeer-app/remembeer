import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';

class MidnightDivider extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;

  const MidnightDivider({
    super.key,
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowerDate = fromDate.isBefore(toDate) ? fromDate : toDate;
    final higherDate = fromDate.isBefore(toDate) ? toDate : fromDate;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.colorScheme.outline)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.dark_mode_outlined,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const Gap(6),
                Text(
                  '${formatDayMonth(lowerDate)} → ${formatDayMonth(higherDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Divider(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }
}
