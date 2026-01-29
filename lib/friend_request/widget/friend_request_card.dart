import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';

class FriendRequestCard extends StatelessWidget {
  final FriendRequest request;

  FriendRequestCard({super.key, required this.request});

  final _userService = get<UserService>();

  void _showDenyRequestDialog(BuildContext context, UserModel sender) {
    showConfirmationDialog(
      context: context,
      title: 'Deny Friend Request',
      text:
          'Are you sure you want to deny the friend request from "${sender.username}"?',
      submitButtonText: 'Deny',
      isDestructive: true,
      onPressed: () => _userService.denyFriendRequest(request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: _userService.userById(request.userId),
      builder: (context, sender) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              onTap: () {
                UserProfileRoute(userId: sender.id).go(context);
              },
              leading: UserAvatar(user: sender),
              title: Text(
                sender.username,
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
                    onPressed: () =>
                        _userService.acceptFriendRequest(sender.id),
                    tooltip: 'Accept',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red.shade600),
                    onPressed: () => _showDenyRequestDialog(context, sender),
                    tooltip: 'Deny',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
