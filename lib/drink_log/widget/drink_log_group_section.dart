import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/session/widget/section_header.dart';

class DrinkLogGroupSection extends StatelessWidget {
  const DrinkLogGroupSection({super.key, this.session, required this.logs});

  final ListForDayResultSessionsItem? session;
  final List<ListForDayResultLogsItem> logs;

  @override
  Widget build(BuildContext context) {
    final session = this.session;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (session == null)
          const SectionHeader(title: 'Other drinks')
        else
          Card(
            child: ExpansionTile(
              leading: Icon(
                session.kind == ListForDayResultSessionsItemKind.partyValue
                    ? Icons.celebration
                    : Icons.table_bar,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                session.kind == ListForDayResultSessionsItemKind.partyValue
                    ? 'Party · ${session.name}'
                    : session.name,
              ),
              subtitle: Text(
                '${logs.length} ${logs.length == 1 ? 'drink' : 'drinks'} this day',
              ),
              children: [
                if (session.description.trim().isNotEmpty)
                  ListTile(title: Text(session.description)),
                ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text('Started ${_formatTime(session.startedAtLocal)}'),
                ),
                ListTile(
                  leading: const Icon(Icons.stop_circle_outlined),
                  title: Text(
                    session.endedAtLocal == null
                        ? 'Still going'
                        : 'Ended ${_formatTime(session.endedAtLocal!)}',
                  ),
                ),
              ],
            ),
          ),
        for (final log in logs) DrinkLogCard(key: ValueKey(log.id), log: log),
      ],
    );
  }

  String _formatTime(String localTime) =>
      DateFormat.yMMMd().add_Hm().format(DateTime.parse('${localTime}Z'));
}
