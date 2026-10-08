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
    // The stream builders must stay outside the lazy ListView: it disposes
    // off-screen children and rebuilding one would re-listen to the same
    // single-subscription stream.
    return PageTemplate(
      title: const Text('Add Friends'),
      child: AsyncBuilder<List<UserModel>>(
        stream: _sessionService.sessionMembersStream(sessionId),
        builder: (context, members) {
          return AsyncBuilder<List<UserModel>>(
            stream: _sessionService.availableFriendsForSessionStream(sessionId),
            builder: (context, friends) {
              return ListView(
                children: [
                  const SectionHeader(title: 'Current Members'),
                  ..._buildMembers(context, members),
                  const SectionHeader(title: 'Your Friends'),
                  ..._buildFriends(friends),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildMembers(BuildContext context, List<UserModel> members) {
    if (members.isEmpty) {
      return const [
        Padding(padding: EdgeInsets.all(16.0), child: Text('No members yet')),
      ];
    }

    final theme = Theme.of(context);
    return [
      for (final member in members)
        UserListTile(
          user: member,
          trailing: Icon(Icons.check_circle, color: theme.colorScheme.primary),
        ),
    ];
  }

  List<Widget> _buildFriends(List<UserModel> friends) {
    if (friends.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No friends available to add'),
        ),
      ];
    }

    return [
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
    ];
  }
}
