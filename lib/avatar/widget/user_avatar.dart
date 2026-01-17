import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/avatar/constants.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double? size;

  const UserAvatar({super.key, required this.user, this.size});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = user.avatarUrl != null;

    return CircleAvatar(
      radius: size,
      backgroundImage: hasAvatar
          ? CachedNetworkImageProvider(user.avatarUrl!)
          : const AssetImage(defaultAvatarPath) as ImageProvider,
    );
  }
}
