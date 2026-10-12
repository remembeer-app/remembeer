import 'package:flutter/material.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) {
          return;
        }

        if (details.primaryVelocity! > 0) {
          onPrevious?.call();
        } else if (details.primaryVelocity! < 0) {
          onNext?.call();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Text(
              formatMonthYear(month.year, month.month),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }
}
