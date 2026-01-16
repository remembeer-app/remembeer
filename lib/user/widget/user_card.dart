import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/page/profile_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final bool replaceRoute;

  const UserCard({super.key, required this.user, this.replaceRoute = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: UserAvatar(user: user),
          title: Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            final route = MaterialPageRoute<void>(
              builder: (context) => ProfilePage(userId: user.id),
            );
            if (replaceRoute) {
              Navigator.of(context).pushReplacement(route);
            } else {
              Navigator.of(context).push(route);
            }
          },
        ),
      ),
    );
  }
}
