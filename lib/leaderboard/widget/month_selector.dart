import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/selected_month.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';

class MonthSelector extends StatelessWidget {
  MonthSelector({super.key});

  final _monthService = get<MonthService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AsyncBuilder<SelectedMonth>(
      stream: _monthService.selectedMonthStream,
      builder: (context, selectedMonth) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) {
              return;
            }

            if (details.primaryVelocity! > 0) {
              _monthService.previousMonth();
            } else if (details.primaryVelocity! < 0) {
              _monthService.nextMonth();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _monthService.previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Container(
                width: 160,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Text(
                  selectedMonth.displayName,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: selectedMonth.isCurrentMonth
                    ? null
                    : _monthService.nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        );
      },
    );
  }
}
