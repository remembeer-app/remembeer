import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/widget/party_ranking.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyPage extends StatelessWidget {
  final String sessionId;

  PartyPage({super.key, required this.sessionId});

  final _drinkService = get<DrinkService>();
  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<Session>(
      stream: _sessionService.sessionStream(sessionId),
      builder: (context, session) {
        if (!session.isParty) {
          return const PageTemplate(
            title: Text('Party'),
            child: Center(child: Text('This session is not a party.')),
          );
        }

        return AsyncBuilder<List<UserModel>>(
          stream: _sessionService.sessionMembersStream(session.id),
          builder: (context, members) => _buildPage(context, session, members),
        );
      },
    );
  }

  Widget _buildPage(
    BuildContext context,
    Session session,
    List<UserModel> members,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOngoing = session.endedAt == null;

    return PageTemplate(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.celebration),
          const Gap(8),
          Flexible(child: Text(session.name, overflow: TextOverflow.ellipsis)),
        ],
      ),
      appBarBackgroundColor: colorScheme.errorContainer,
      appBarForegroundColor: colorScheme.onErrorContainer,
      padding: const EdgeInsets.all(16),
      floatingActionButton: isOngoing && session.hasFreeSpace
          ? GestureDetector(
              onLongPress: () =>
                  _drinkService.addDefaultDrink(targetSessionId: session.id),
              child: FloatingActionButton(
                heroTag: 'party_add_drink_fab',
                onPressed: () => AddDrinkRoute(
                  targetSessionId: session.id,
                ).push<void>(context),
                child: const Icon(Icons.add),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: colorScheme.errorContainer,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isOngoing ? Icons.local_fire_department : Icons.flag,
                    color: colorScheme.onErrorContainer,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOngoing ? 'Party in progress' : 'Party ended',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${members.length} ${members.length == 1 ? 'participant' : 'participants'} · '
                          '${session.drinksCount} ${session.drinksCount == 1 ? 'drink' : 'drinks'}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onErrorContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(20),
          Text(
            'Live ranking',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(12),
          Expanded(
            child: PartyRanking(session: session, members: members),
          ),
        ],
      ),
    );
  }
}
