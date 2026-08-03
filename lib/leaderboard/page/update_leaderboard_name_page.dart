import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_form.dart';

class UpdateLeaderboardNamePage extends StatelessWidget {
  final String leaderboardId;

  UpdateLeaderboardNamePage({super.key, required this.leaderboardId});

  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<Leaderboard>(
      stream: _leaderboardService.streamById(leaderboardId),
      builder: _buildPage,
    );
  }

  Widget _buildPage(BuildContext context, Leaderboard leaderboard) {
    return PageTemplate(
      title: const Text('Update Leaderboard Name'),
      child: LeaderboardForm(
        initialName: leaderboard.name,
        initialIcon: LeaderboardIcon.fromName(leaderboard.iconName),
        submitButtonText: 'Save',
        isEditing: true,
        onSubmit: (name, _) async {
          await _leaderboardService.updateLeaderboardName(
            leaderboard: leaderboard,
            newName: name,
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
