import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/drag_auto_scroller.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/convex_api/schema.dart';
import 'package:remembeer/drink_log/constants.dart';
import 'package:remembeer/drink_log/widget/drink_log_group_section.dart';

class DrinkLogGroupList extends StatefulWidget {
  const DrinkLogGroupList({super.key, required this.day});

  final ListForDayResult day;

  @override
  State<DrinkLogGroupList> createState() => _DrinkLogGroupListState();
}

class _DrinkLogGroupListState extends State<DrinkLogGroupList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final groups = <SessionId?, List<ListForDayResultLogsItem>>{
      null: [],
      for (final session in day.sessions) session.id: [],
    };
    for (final log in day.logs) {
      (groups[log.sessionId] ?? groups[null]!).add(log);
    }
    final otherLogs = groups[null]!;
    return DragStateProvider(
      child: DragAutoScroller(
        scrollController: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(
            8,
            8,
            8,
            drinkLogDropAreaMinHeight,
          ),
          itemCount: day.sessions.length + 1 + (day.logs.isEmpty ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < day.sessions.length) {
              final session = day.sessions[index];
              return DrinkLogGroupSection(
                key: ValueKey(session.id),
                session: session,
                logs: groups[session.id]!,
              );
            }
            if (index == day.sessions.length) {
              return DrinkLogGroupSection(logs: otherLogs);
            }
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No drinks recorded for this day.')),
            );
          },
        ),
      ),
    );
  }
}
