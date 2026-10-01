import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/type/session_with_drink_logs.dart';
import 'package:remembeer/session/widget/summary_card.dart';
import 'package:rxdart/rxdart.dart';

class SummaryPage extends StatelessWidget {
  SummaryPage({super.key});

  final _sessionService = get<SessionService>();
  final _drinkLogService = get<DrinkLogService>();

  Stream<List<SessionWithDrinkLogs>> get _sessionsWithFilteredDrinksStream {
    return _sessionService.mySessionsForSelectedDateStream.switchMap((
      sessions,
    ) {
      if (sessions.isEmpty) {
        return Stream.value(<SessionWithDrinkLogs>[]);
      }

      final streams = sessions.map(
        (session) => _drinkLogService
            .drinkLogsToShowFromSessions(session)
            .map((drinkLogs) => (session: session, drinkLogs: drinkLogs)),
      );

      return Rx.combineLatestList(streams);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Summary'),
      child: AsyncBuilder<List<SessionWithDrinkLogs>>(
        stream: _sessionsWithFilteredDrinksStream,
        builder: (context, sessionsWithDrinks) {
          final allDrinkLogs = sessionsWithDrinks
              .expand((session) => session.drinkLogs)
              .toList();
          if (allDrinkLogs.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildSections(sessionsWithDrinks),
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

  List<Widget> _buildSections(List<SessionWithDrinkLogs> sessionsWithDrinks) {
    final sections = <Widget>[];

    // Separate shared sessions from solo sessions
    final sharedSessions = <SessionWithDrinkLogs>[];
    final soloDrinkLogs = <DrinkLog>[];

    for (final entry in sessionsWithDrinks) {
      if (entry.session.isSoloSession) {
        soloDrinkLogs.addAll(entry.drinkLogs);
      } else {
        sharedSessions.add(entry);
      }
    }

    // Build sections for shared sessions
    for (final entry in sharedSessions) {
      if (entry.drinkLogs.isNotEmpty) {
        sections
          ..add(_buildSessionSection(entry.session, entry.drinkLogs))
          ..add(const Gap(16));
      }
    }

    // Build sections for solo drinks (grouped by time gap)
    if (soloDrinkLogs.isNotEmpty) {
      final noSessionGroups = _splitByTimeGap(soloDrinkLogs);
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

  List<List<DrinkLog>> _splitByTimeGap(List<DrinkLog> drinkLogs) {
    if (drinkLogs.isEmpty) return [];

    final sorted = List<DrinkLog>.from(drinkLogs)
      ..sort((a, b) => a.consumedAt.compareTo(b.consumedAt));

    final groups = <List<DrinkLog>>[];
    var currentGroup = <DrinkLog>[sorted.first];

    for (var i = 1; i < sorted.length; i++) {
      final previous = sorted[i - 1];
      final current = sorted[i];
      final gap = current.consumedAt.difference(previous.consumedAt);

      if (gap.inHours >= 2) {
        groups.add(currentGroup);
        currentGroup = <DrinkLog>[current];
      } else {
        currentGroup.add(current);
      }
    }

    groups.add(currentGroup);
    return groups;
  }

  Widget _buildSessionSection(Session session, List<DrinkLog> drinkLogs) {
    return SummaryCard(
      title: session.name,
      drinkCount: drinkLogs.length,
      drinkLogs: drinkLogs,
    );
  }

  Widget _buildNoSessionSection(List<DrinkLog> drinkLogs) {
    final sorted = List<DrinkLog>.from(drinkLogs)
      ..sort((a, b) => a.consumedAt.compareTo(b.consumedAt));

    final startTime = formatTime(sorted.first.consumedAt);
    final endTime = formatTime(sorted.last.consumedAt);

    final title = drinkLogs.length == 1
        ? 'No Session ($startTime)'
        : 'No Session ($startTime – $endTime)';

    return SummaryCard(
      title: title,
      drinkCount: drinkLogs.length,
      drinkLogs: drinkLogs,
    );
  }
}
