import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/section_header.dart';
import 'package:remembeer/session/widget/user_list_tile.dart';
import 'package:remembeer/user/model/user_model.dart';

class AddFriendsToSessionPage extends StatelessWidget {
  final String sessionId;

  AddFriendsToSessionPage({super.key, required this.sessionId});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageTemplate(
      title: const Text('Add Friends'),
      child: ListView(
        children: [
          const SectionHeader(title: 'Current Members'),
          AsyncBuilder<List<UserModel>>(
            stream: _sessionService.sessionMembersStream(sessionId),
            builder: (context, members) {
              if (members.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No members yet'),
                );
              }
              return Column(
                children: [
                  for (final member in members)
                    UserListTile(
                      user: member,
                      trailing: Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              );
            },
          ),
          const SectionHeader(title: 'Your Friends'),
          AsyncBuilder<List<UserModel>>(
            stream: _sessionService.availableFriendsForSessionStream(sessionId),
            builder: (context, friends) {
              if (friends.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No friends available to add'),
                );
              }
              return Column(
                children: [
                  for (final friend in friends)
                    UserListTile(
                      user: friend,
                      trailing: IconButton(
                        icon: const Icon(Icons.person_add),
                        onPressed: () => _sessionService.addMemberToSession(
                          sessionId: sessionId,
                          memberId: friend.id,
                        ),
                        tooltip: 'Add to session',
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
