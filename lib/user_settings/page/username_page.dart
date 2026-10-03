import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user_settings/widget/username_form.dart';

class UserNamePage extends StatelessWidget {
  const UserNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Change your username'),
      child: UserCurrentQuery(
        builder: (context, user) => UserUpdateUsernameMutation(
          builder: (context, mutate, snapshot) => UsernameForm(
            key: ValueKey(user.id),
            initialUsername: user.username,
            isSubmitting: snapshot.isLoading,
            error: snapshot.error,
            onBack: () => context.pop(),
            onSubmit: (username) {
              mutate(username: username).then((_) {
                if (context.mounted) context.pop();
              }).ignore();
            },
          ),
        ),
      ),
    );
  }
}
