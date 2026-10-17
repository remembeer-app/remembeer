import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/drink_log/constants.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/drink_log/widget/midnight_divider.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/widget/section_header.dart';

class DrinkLogGroupSection extends StatelessWidget {
  const DrinkLogGroupSection({super.key, this.session, required this.logs});

  final ListForDayResultSessionsItem? session;
  final List<ListForDayResultLogsItem> logs;

  @override
  Widget build(BuildContext context) {
    final session = this.session;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DragTarget<ListForDayResultLogsItem>(
        onWillAcceptWithDetails: (details) =>
            details.data.sessionId != session?.id,
        onAcceptWithDetails: (details) async {
          try {
            await get<ConvexApi>().drinkLog.update(
              id: details.data.id,
              sessionId: Optional.of(session?.id),
            );
          } on Object catch (error) {
            showNotification(error.toString());
          }
        },
        builder: (context, candidates, rejected) => Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: drinkLogDropAreaMinHeight,
          ),
          child: Material(
            color: candidates.isNotEmpty
                ? colors.primaryContainer
                : session == null
                ? Colors.transparent
                : colors.primary.withValues(alpha: 0.1),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: session == null
                  ? BorderSide.none
                  : BorderSide(color: colors.primary.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (session == null)
                  const SectionHeader(title: 'Other drinks')
                else
                  ExpansionTile(
                    leading: Icon(
                      session.kind ==
                              ListForDayResultSessionsItemKind.partyValue
                          ? Icons.celebration
                          : Icons.table_bar,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      session.kind ==
                              ListForDayResultSessionsItemKind.partyValue
                          ? 'Party · ${session.name}'
                          : session.name,
                    ),
                    subtitle: Text(
                      '${logs.length} ${logs.length == 1 ? 'drink' : 'drinks'} this day',
                    ),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.open_in_new),
                        title: const Text('Open session'),
                        onTap: () => ActivitySessionRoute(
                          sessionId: session.id.value,
                        ).push<void>(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add drink'),
                        onTap: () => AddDrinkLogRoute(
                          targetSessionId: session.id.value,
                        ).push<void>(context),
                      ),
                      if (session.description.trim().isNotEmpty)
                        ListTile(title: Text(session.description)),
                      ListTile(
                        leading: const Icon(Icons.play_circle_outline),
                        title: Text(
                          'Started ${_formatTime(session.startedAtLocal)}',
                        ),
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
                ..._buildDrinkLogs(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrinkLogs(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < logs.length; i++) {
      final log = logs[i];
      final card = DrinkLogCard(log: log);
      items.add(
        LongPressDraggable<ListForDayResultLogsItem>(
          key: ValueKey(log.id),
          data: log,
          maxSimultaneousDrags: 1,
          onDragStarted: () =>
              DragStateProvider.maybeOf(context)?.setDragging(true),
          onDragEnd: (_) =>
              DragStateProvider.maybeOf(context)?.setDragging(false),
          feedback: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 32,
              child: card,
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.3, child: card),
          child: card,
        ),
      );
      if (i < logs.length - 1) {
        final date = DateTime.parse('${log.consumedAtLocal}Z');
        final nextDate = DateTime.parse('${logs[i + 1].consumedAtLocal}Z');
        if (!DateUtils.isSameDay(date, nextDate)) {
          items.add(MidnightDivider(fromDate: date, toDate: nextDate));
        }
      }
    }
    return items;
  }

  String _formatTime(String localTime) =>
      DateFormat.yMMMd().add_Hm().format(DateTime.parse('${localTime}Z'));
}
