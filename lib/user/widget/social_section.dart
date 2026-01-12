import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/page/friends_list_page.dart';
import 'package:remembeer/user/service/user_stats_service.dart';

class SocialSection extends StatelessWidget {
  final UserModel user;
  final bool isCurrentUser;

  SocialSection({super.key, required this.user, required this.isCurrentUser});

  final _userStatsService = get<UserStatsService>();

  @override
  Widget build(BuildContext context) {
    final userStats = _userStatsService.fromUser(user);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          icon: Icons.local_fire_department,
          color: userStats.isStreakActive
              ? Colors.orange.shade700
              : Colors.grey,
          value: userStats.streakDays.toString(),
          label: 'Day Streak',
        ),
        hGap12,
        _buildStatCard(
          icon: Icons.people_alt,
          color: Colors.blue.shade700,
          value: user.friends.length.toString(),
          label: 'Friends',
          onTap: () {
            final route = MaterialPageRoute<void>(
              builder: (context) => FriendsListPage(userId: user.id),
            );
            if (isCurrentUser) {
              Navigator.of(context).push(route);
            } else {
              Navigator.of(context).pushReplacement(route);
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 32),
                gap8,
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                gap4,
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
