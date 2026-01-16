import 'package:flutter/material.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double? size;

  const UserAvatar({super.key, required this.user, this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: AssetImage('assets/avatars/${user.avatarName}'),
    );
  }
}
