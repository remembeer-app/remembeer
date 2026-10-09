import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/session/widget/session_form.dart';

class CreateSessionPage extends StatelessWidget {
  const CreateSessionPage({super.key});

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Create Session'),
    child: SessionCreateMutation(
      builder: (context, create, snapshot) => SessionForm(
        initialName: '',
        initialDescription: '',
        initialStartedAt: DateTime.now(),
        submitButtonText: 'Create Session',
        enabled: !snapshot.isLoading,
        onSubmit: (name, description, startedAt) async {
          await create(
            name: name,
            description: description,
            startedAt: startedAt.millisecondsSinceEpoch.toDouble(),
          );
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    ),
  );
}
