import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/user_settings/widget/username_field.dart';

class UsernameForm extends StatefulWidget {
  final String initialUsername;
  final bool isSubmitting;
  final Object? error;
  final ValueChanged<String> onSubmit;
  final VoidCallback onBack;

  const UsernameForm({
    super.key,
    required this.initialUsername,
    required this.isSubmitting,
    required this.error,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  State<UsernameForm> createState() => _UsernameFormState();
}

class _UsernameFormState extends State<UsernameForm> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      isSubmitting: widget.isSubmitting,
      error: widget.error,
      submitLabel: 'Save username',
      submittingLabel: 'Saving...',
      onSubmit: () => widget.onSubmit(_usernameController.text),
      onBack: widget.onBack,
      builder: (context, submit) => UsernameField(
        controller: _usernameController,
        enabled: !widget.isSubmitting,
        onFieldSubmitted: (_) => submit(),
      ),
    );
  }
}
