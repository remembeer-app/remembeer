import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_form.dart';

class UpdateLeaderboardNamePage extends StatelessWidget {
  const UpdateLeaderboardNamePage({super.key, required this.leaderboardId});
  final String leaderboardId;

  @override
  Widget build(BuildContext context) => LeaderboardGetTypeQuery(
    id: LeaderboardId(leaderboardId),
    builder: (_, result) => PageTemplate(
      title: const Text('Update Leaderboard Name'),
      child: LeaderboardUpdateMutation(
        builder: (_, update, snapshot) => LeaderboardForm(
          initialName: result.leaderboard.name,
          initialIcon: LeaderboardIcon.fromName(result.leaderboard.iconName),
          submitButtonText: 'Save',
          isEditing: true,
          onSubmit: (name, _) async {
            await update(id: result.leaderboard.id, name: Optional.of(name));
            if (context.mounted) context.pop();
          },
        ),
      ),
    ),
  );
}
