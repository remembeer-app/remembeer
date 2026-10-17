import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _authService = get<ConvexAuthService>();

  final _passwordController = TextEditingController();
  var _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Delete Account'),
      padding: const EdgeInsets.all(24),
      child: LoadingForm(
        errorMapper: (e) => switch (e) {
          ConvexException(:final message, :final data) =>
            data is String ? data : message,
          _ => e.toString(),
        },
        builder: (form) => ListView(
          children: [
            _buildSection(context, 'What will be deleted', [
              'Your account, email and sign-in sessions',
              'Your profile, username and avatar',
              'Custom drinks you created',
              'Your badges and settings',
            ]),
            const Gap(24),
            _buildPasswordField(form),
            const Gap(8),
            form.buildErrorMessage(),
            const Gap(24),
            _buildDeleteButton(context, form),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const Gap(8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  '),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _passwordController,
      label: 'Confirm your password',
      obscureText: _obscurePassword,
      onToggleVisibility: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      isLastField: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password.';
        }
        return null;
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context, LoadingFormState form) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: form.isLoading ? null : () => _onDeletePressed(context, form),
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: form.isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onError,
              ),
            )
          : const Text('Delete my account', style: TextStyle(fontSize: 16)),
    );
  }

  Future<void> _onDeletePressed(
    BuildContext context,
    LoadingFormState form,
  ) async {
    if (!form.validate()) {
      return;
    }

    await showConfirmationDialog(
      context: context,
      title: 'Delete account?',
      text:
          'This cannot be undone. Your account, profile, avatar, custom drinks, '
          'badges and settings will be permanently removed.',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () => form.runAction(_deleteAccount),
    );
  }

  Future<void> _deleteAccount() async {
    await _authService.deleteAccount(password: _passwordController.text);
    showSuccessNotification('Account deleted.');
  }
}
