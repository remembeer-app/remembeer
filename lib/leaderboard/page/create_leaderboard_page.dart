import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_form.dart';

class CreateLeaderboardPage extends StatelessWidget {
  const CreateLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Create Leaderboard'),
    child: LeaderboardCreateMutation(
      builder: (_, create, snapshot) => LeaderboardForm(
        initialName: '',
        initialIcon: CreateArgsIconName.trophyValue,
        submitButtonText: 'Create Leaderboard',
        isEditing: false,
        onSubmit: (name, icon) async {
          await create(name: name, iconName: icon);
          if (context.mounted) context.pop();
        },
      ),
    ),
  );
}
