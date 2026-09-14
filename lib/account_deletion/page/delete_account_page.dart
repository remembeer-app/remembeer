import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/account_deletion/service/account_deletion_service.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
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
  final _authService = get<AuthService>();
  final _accountDeletionService = get<AccountDeletionService>();

  final _passwordController = TextEditingController();
  var _obscurePassword = true;

  late final _hasPassword = _authService.hasPasswordProvider;

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
          FirebaseAuthException() => mapFirebaseAuthError(e.code),
          FirebaseException() =>
            'Could not delete everything. Check your connection and try again.',
          _ => e.toString(),
        },
        builder: (form) => ListView(
          children: [
            _buildSection(context, 'What will be deleted', [
              'Your profile, username, email and avatar',
              'Your drinks and their locations, except inside Party sessions',
              'Your solo sessions and their photos',
              'Custom drinks you created',
              'Friend links and friend requests',
              'Your settings and notification token',
            ]),
            const Gap(16),
            _buildSection(context, 'What happens to shared things', [
              'Your drinks are removed from shared sessions; the sessions stay for the other members',
              'Shared sessions and leaderboards you own pass to another member',
              'Party sessions keep your drinks, locations and scores, shown as "Deleted user"',
            ]),
            const Gap(24),
            if (_hasPassword) ...[_buildPasswordField(form), const Gap(8)],
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
          : Text(
              _hasPassword
                  ? 'Delete my account'
                  : 'Confirm with Google and delete',
              style: const TextStyle(fontSize: 16),
            ),
    );
  }

  Future<void> _onDeletePressed(
    BuildContext context,
    LoadingFormState form,
  ) async {
    if (_hasPassword && !form.validate()) {
      return;
    }

    await showConfirmationDialog(
      context: context,
      title: 'Delete account?',
      text:
          'This cannot be undone. Your profile, drinks, solo sessions and photos '
          'will be permanently removed.',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () => form.runAction(_deleteAccount),
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await _reauthenticate();
    if (!confirmed) {
      return;
    }

    await _accountDeletionService.deleteAccount();
    showSuccessNotification('Account deleted.');
  }

  Future<bool> _reauthenticate() async {
    if (_hasPassword) {
      await _authService.reauthenticateWithPassword(_passwordController.text);
      return true;
    }
    return _authService.reauthenticateWithGoogle();
  }
}
