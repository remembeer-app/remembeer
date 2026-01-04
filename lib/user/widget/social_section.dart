import 'package:flutter/material.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/page/friends_list_page.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';

class SocialSection extends StatelessWidget {
  final UserStats userStats;
  final UserModel user;
  final bool isCurrentUser;

  const SocialSection({
    super.key,
    required this.userStats,
    required this.user,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(width: 12),
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
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
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
