import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/summary_card.dart';

class SummaryPage extends StatelessWidget {
  SummaryPage({super.key});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Summary'),
      child: AsyncBuilder<List<Session>>(
        stream: _sessionService.mySessionsForSelectedDateStream,
        builder: (context, sessions) {
          final allDrinks = sessions.expand((s) => s.drinks).toList();
          if (allDrinks.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildSections(sessions),
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
            const Gap(16),
            Text(
              'No drinks to summarize',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
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

  List<Widget> _buildSections(List<Session> sessions) {
    final sections = <Widget>[];

    // Separate shared sessions from solo sessions
    final sharedSessions = <Session>[];
    final soloDrinks = <Drink>[];

    for (final session in sessions) {
      if (session.isSoloSession) {
        // Solo sessions contain exactly one drink
        soloDrinks.addAll(session.drinks);
      } else {
        sharedSessions.add(session);
      }
    }

    // Build sections for shared sessions
    for (final session in sharedSessions) {
      if (session.drinks.isNotEmpty) {
        sections
          ..add(_buildSessionSection(session, session.drinks))
          ..add(const Gap(16));
      }
    }

    // Build sections for solo drinks (grouped by time gap)
    if (soloDrinks.isNotEmpty) {
      final noSessionGroups = _splitByTimeGap(soloDrinks);
      for (final group in noSessionGroups) {
        sections
          ..add(_buildNoSessionSection(group))
          ..add(const Gap(16));
      }
    }

    if (sections.isNotEmpty) {
      sections.removeLast();
    }

    return sections;
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
        : 'No Session ($startTime – $endTime)';

    return SummaryCard(title: title, drinkCount: drinks.length, drinks: drinks);
  }
}
