import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/avatar/constants.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double? size;

  const UserAvatar({super.key, required this.avatarUrl, this.size});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null;

    return CircleAvatar(
      radius: size,
      backgroundImage: hasAvatar
          ? CachedNetworkImageProvider(avatarUrl!)
          : const AssetImage(defaultAvatarPath) as ImageProvider,
    );
  }
}
