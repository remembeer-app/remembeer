import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_list_service.dart';
import 'package:remembeer/drink/type/drink_list_data.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/page/summary_card.dart';

class SummaryPage extends StatelessWidget {
  SummaryPage({super.key});

  final DrinkListService _drinkListService = get<DrinkListService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Summary'),
      child: AsyncBuilder<DrinkListData>(
        stream: _drinkListService.drinkListDataStream,
        builder: (context, data) {
          if (data.drinks.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildSections(data),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.summarize_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            gap16,
            Text(
              'No drinks to summarize',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            gap8,
            Text(
              'Log some drinks first',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(DrinkListData data) {
    final sections = <Widget>[];

    final drinksBySessionId = _groupDrinksBySessionId(data.drinks);

    for (final session in data.sessions) {
      final sessionDrinks = drinksBySessionId[session.id] ?? [];
      if (sessionDrinks.isNotEmpty) {
        sections
          ..add(_buildSessionSection(session, sessionDrinks))
          ..add(gap16);
      }
    }

    final drinksWithoutSession = drinksBySessionId[null] ?? [];
    if (drinksWithoutSession.isNotEmpty) {
      final noSessionGroups = _splitByTimeGap(drinksWithoutSession);
      for (final group in noSessionGroups) {
        sections
          ..add(_buildNoSessionSection(group))
          ..add(gap16);
      }
    }

    if (sections.isNotEmpty) {
      sections.removeLast();
    }

    return sections;
  }

  Map<String?, List<Drink>> _groupDrinksBySessionId(List<Drink> drinks) {
    final map = <String?, List<Drink>>{};
    for (final drink in drinks) {
      map.putIfAbsent(drink.sessionId, () => []).add(drink);
    }
    return map;
  }

  List<List<Drink>> _splitByTimeGap(List<Drink> drinks) {
    if (drinks.isEmpty) return [];

    final sorted = List<Drink>.from(drinks)
      ..sort((a, b) => a.consumedAt.compareTo(b.consumedAt));

    final groups = <List<Drink>>[];
    var currentGroup = <Drink>[sorted.first];

    for (var i = 1; i < sorted.length; i++) {
      final previous = sorted[i - 1];
      final current = sorted[i];
      final gap = current.consumedAt.difference(previous.consumedAt);

      if (gap.inHours >= 2) {
        groups.add(currentGroup);
        currentGroup = <Drink>[current];
      } else {
        currentGroup.add(current);
      }
    }

    groups.add(currentGroup);
    return groups;
  }

  Widget _buildSessionSection(Session session, List<Drink> drinks) {
    return SummaryCard(
      title: session.name,
      drinkCount: drinks.length,
      drinks: drinks,
    );
  }

  Widget _buildNoSessionSection(List<Drink> drinks) {
    final sorted = List<Drink>.from(drinks)
      ..sort((a, b) => a.consumedAt.compareTo(b.consumedAt));

    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(sorted.first.consumedAt);
    final endTime = timeFormat.format(sorted.last.consumedAt);

    final title = drinks.length == 1
        ? 'No Session ($startTime)'
        : 'No Session ($startTime - $endTime)';

    return SummaryCard(title: title, drinkCount: drinks.length, drinks: drinks);
  }
}
