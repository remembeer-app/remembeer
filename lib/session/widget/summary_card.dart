import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int drinkCount;
  final List<DrinkLog> drinkLogs;

  const SummaryCard({
    super.key,
    required this.title,
    required this.drinkCount,
    required this.drinkLogs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drinkLogsByCategory = _groupByCategory(drinkLogs);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Gap(12),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            const Gap(12),
            ..._buildCategorySections(context, drinkLogsByCategory),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final drinkLabel = drinkCount == 1 ? 'drink' : 'drinks';

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$drinkCount $drinkLabel',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Map<DrinkCategory, List<DrinkLog>> _groupByCategory(
    List<DrinkLog> drinkLogs,
  ) {
    final map = <DrinkCategory, List<DrinkLog>>{};
    for (final drinkLog in drinkLogs) {
      final category = drinkLog.drink.category;
      map.putIfAbsent(category, () => []).add(drinkLog);
    }
    return map;
  }

  List<Widget> _buildCategorySections(
    BuildContext context,
    Map<DrinkCategory, List<DrinkLog>> drinkLogsByCategory,
  ) {
    final widgets = <Widget>[];
    final sortedCategories = drinkLogsByCategory.keys.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    for (final category in sortedCategories) {
      final categoryDrinkLogs = drinkLogsByCategory[category]!;
      widgets
        ..add(_buildCategorySection(context, category, categoryDrinkLogs))
        ..add(const Gap(8));
    }

    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }

    return widgets;
  }

  Widget _buildCategorySection(
    BuildContext context,
    DrinkCategory category,
    List<DrinkLog> drinkLogs,
  ) {
    final theme = Theme.of(context);
    final aggregated = _aggregateDrinkLogsByName(drinkLogs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DrinkIcon(category: category, size: 24),
            const Gap(8),
            Text(
              category.displayName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: category.defaultColor,
              ),
            ),
          ],
        ),
        const Gap(4),
        ...aggregated.entries.map(
          (entry) => _buildDrinkEntry(context, entry.key, entry.value),
        ),
      ],
    );
  }

  Map<String, Map<int, int>> _aggregateDrinkLogsByName(
    List<DrinkLog> drinkLogs,
  ) {
    final result = <String, Map<int, int>>{};

    for (final drinkLog in drinkLogs) {
      final name = drinkLog.drink.name;
      final volume = drinkLog.volumeInMilliliters;

      result.putIfAbsent(name, () => {});
      result[name]![volume] = (result[name]![volume] ?? 0) + 1;
    }

    return result;
  }

  Widget _buildDrinkEntry(
    BuildContext context,
    String drinkName,
    Map<int, int> volumeCounts,
  ) {
    final theme = Theme.of(context);

    final sortedVolumes = volumeCounts.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    final volumeStrings = sortedVolumes.map((volume) {
      final count = volumeCounts[volume]!;
      return '$count× ${volume}ml';
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$drinkName: ',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: volumeStrings.join(', '),
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
