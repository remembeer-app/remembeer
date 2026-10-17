import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/friendship.dart';
import 'package:remembeer/convex_api/widgets/friendship.dart';

class FriendshipActions extends StatelessWidget {
  const FriendshipActions({
    super.key,
    required this.userId,
    required this.username,
  });

  final UserId userId;
  final String username;

  @override
  Widget build(BuildContext context) => FriendshipGetStatusQuery(
    userId: userId,
    builder: (context, status) {
      final (mutation, label, icon) = switch (status) {
        GetStatusResult.friendsValue => (
          removeMutationReference,
          'Remove friend',
          Icons.person_remove,
        ),
        GetStatusResult.requestSentValue => (
          cancelMutationReference,
          'Revoke sent request',
          Icons.cancel_schedule_send,
        ),
        GetStatusResult.requestReceivedValue => (
          acceptMutationReference,
          'Accept request',
          Icons.check_circle,
        ),
        GetStatusResult.notFriendsValue => (
          sendRequestMutationReference,
          'Add as friend',
          Icons.person_add,
        ),
      };
      return ConvexMutation<SendRequestArgs, void>(
        key: ValueKey(status),
        mutation: mutation,
        builder: (context, mutate, state) {
          // The mutation widget displays failures through its snapshot.
          Future<void> perform() =>
              mutate((userId: userId)).onError((error, stackTrace) {});
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.error case final error?)
                ErrorMessageBox(message: error.toString()),
              ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (status == GetStatusResult.friendsValue) {
                          unawaited(
                            showConfirmationDialog(
                              context: context,
                              title: 'Remove Friend',
                              text:
                                  'Are you sure you want to remove "$username" from your friends?',
                              submitButtonText: 'Remove',
                              isDestructive: true,
                              onPressed: perform,
                            ),
                          );
                        } else {
                          unawaited(perform());
                        }
                      },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                icon: Icon(icon),
                label: Text(label),
              ),
            ],
          );
        },
      );
    },
  );
}
