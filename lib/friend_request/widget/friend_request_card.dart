import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/friendship.dart';
import 'package:remembeer/convex_api/widgets/friendship.dart';
import 'package:remembeer/routes.dart';

class FriendRequestCard extends StatelessWidget {
  const FriendRequestCard({super.key, required this.request});

  final ListRequestsResultItem request;

  @override
  Widget build(BuildContext context) => FriendshipAcceptMutation(
    builder: (context, accept, acceptState) => FriendshipDeclineMutation(
      builder: (context, decline, declineState) {
        final busy = acceptState.isLoading || declineState.isLoading;
        return Column(
          children: [
            if (acceptState.error ?? declineState.error case final error?)
              ErrorMessageBox(message: error.toString()),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  onTap: () => UserProfileRoute(
                    userId: request.user.id.value,
                  ).go(context),
                  leading: UserAvatar(avatarUrl: request.user.avatarUrl),
                  title: Text(
                    request.user.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                        ),
                        onPressed: busy
                            ? null
                            : () => accept.run(userId: request.user.id),
                        tooltip: 'Accept',
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red.shade600),
                        onPressed: busy
                            ? null
                            : () => showConfirmationDialog(
                                context: context,
                                title: 'Deny Friend Request',
                                text:
                                    'Are you sure you want to deny the friend request from "${request.user.username}"?',
                                submitButtonText: 'Deny',
                                isDestructive: true,
                                onPressed: () async =>
                                    decline.run(userId: request.user.id),
                              ),
                        tooltip: 'Deny',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
