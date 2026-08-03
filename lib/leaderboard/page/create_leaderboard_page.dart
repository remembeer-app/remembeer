import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_form.dart';

class CreateLeaderboardPage extends StatelessWidget {
  CreateLeaderboardPage({super.key});

  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Create Leaderboard'),
      child: LeaderboardForm(
        initialName: '',
        initialIcon: LeaderboardIcon.trophy,
        submitButtonText: 'Create Leaderboard',
        isEditing: false,
        onSubmit: (name, icon) async {
          await _leaderboardService.createLeaderboard(
            name: name,
            iconName: icon.name,
          );
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }
}
