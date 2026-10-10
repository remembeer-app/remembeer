import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/friendship.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/friend_request/widget/friend_request_card.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Friend Requests'),
    child: UserCurrentQuery(
      builder: (context, current) => FriendshipListRequestsQuery(
        builder: (context, requests) {
          final incoming = requests
              .where(
                (request) => request.friendship.requestedById != current.id,
              )
              .toList();
          return incoming.isEmpty
              ? const Center(
                  child: Text('You have no pending friend requests.'),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  children: [
                    for (final request in incoming)
                      FriendRequestCard(
                        key: ValueKey(request.friendship.id),
                        request: request,
                      ),
                  ],
                );
        },
      ),
    ),
  );
}
