import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/routes.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Activity'),
    child: SessionListCurrentQuery(
      builder: (context, sessions) {
        final ended = sessions
            .where((session) => session.endedAt != null)
            .toList();
        if (ended.isEmpty) {
          return const Center(
            child: Text('Your ended sessions will appear here.'),
          );
        }
        return ListView(
          children: [
            for (final session in ended)
              Card(
                child: ListTile(
                  leading: Icon(
                    session.isParty ? Icons.celebration : Icons.table_bar,
                  ),
                  title: Text(session.name),
                  onTap: () => ActivitySessionRoute(
                    sessionId: session.id.value,
                  ).push<void>(context),
                ),
              ),
          ],
        );
      },
    ),
  );
}
