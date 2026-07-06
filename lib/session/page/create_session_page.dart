import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/session_form.dart';

class CreateSessionPage extends StatelessWidget {
  CreateSessionPage({super.key});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Create Session'),
      child: SessionForm(
        initialName: '',
        initialDescription: '',
        initialStartedAt: DateTime.now(),
        submitButtonText: 'Create Session',
        onSubmit: (name, description, startedAt) async {
          await _sessionService.createSession(
            name: name,
            description: description,
            startedAt: startedAt,
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
