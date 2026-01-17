import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final Widget? trailing;
  final VoidCallback? onTap;

  const UserListTile({
    super.key,
    required this.user,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: UserAvatar(user: user),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
