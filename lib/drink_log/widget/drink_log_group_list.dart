import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/convex_api/schema.dart';
import 'package:remembeer/drink_log/widget/drink_log_group_section.dart';

class DrinkLogGroupList extends StatelessWidget {
  const DrinkLogGroupList({super.key, required this.day});

  final ListForDayResult day;

  @override
  Widget build(BuildContext context) {
    final groups = <SessionId?, List<ListForDayResultLogsItem>>{
      null: [],
      for (final session in day.sessions) session.id: [],
    };
    for (final log in day.logs) {
      (groups[log.sessionId] ?? groups[null]!).add(log);
    }
    final otherLogs = groups[null]!;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount:
          day.sessions.length +
          (otherLogs.isEmpty ? 0 : 1) +
          (day.logs.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < day.sessions.length) {
          final session = day.sessions[index];
          return DrinkLogGroupSection(
            key: ValueKey(session.id),
            session: session,
            logs: groups[session.id]!,
          );
        }
        if (otherLogs.isNotEmpty) {
          return DrinkLogGroupSection(logs: otherLogs);
        }
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No drinks recorded for this day.')),
        );
      },
    );
  }
}
