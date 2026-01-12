import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user/type/user_stats.dart';

class StreakIndicator extends StatelessWidget {
  StreakIndicator({super.key});

  final _userController = get<UserController>();
  final _userStatsService = get<UserStatsService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _userController.currentUserStream.map(_userStatsService.fromUser),
      builder: (context, userStats) => _buildStreak(userStats),
    );
  }

  Widget _buildStreak(UserStats userStats) {
    final color = userStats.isStreakActive
        ? Colors.orange.shade700
        : Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department, color: color, size: 32),
        hGap8,
        Text(
          '${userStats.streakDays}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
