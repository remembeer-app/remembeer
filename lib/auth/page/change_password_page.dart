import 'dart:async';

import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/auth/widget/password_field.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _authService = get<ConvexAuthService>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscureCurrentPassword = true;
  var _obscureNewPassword = true;
  var _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Change Password',
      hint:
          'Enter your current password, then choose and confirm a new password. '
          'Your new password must be different from your current password.',
      child: AppForm(
        isSubmitting: _isSubmitting,
        error: _error,
        submitLabel: 'Change Password',
        submittingLabel: 'Changing password...',
        onSubmit: () => unawaited(_changePassword()),
        onBack: () => context.pop(),
        builder: (context, submit) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PasswordField.current(
              enabled: !_isSubmitting,
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              onToggleVisibility: () => setState(
                () => _obscureCurrentPassword = !_obscureCurrentPassword,
              ),
            ),
            const Gap(16),
            PasswordField.newPassword(
              currentPasswordController: _currentPasswordController,
              enabled: !_isSubmitting,
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              onToggleVisibility: () =>
                  setState(() => _obscureNewPassword = !_obscureNewPassword),
              onChanged: (_) => setState(() {}),
            ),
            const Gap(8),
            PasswordRequirements(password: _newPasswordController.text),
            const Gap(16),
            PasswordField.confirmation(
              passwordController: _newPasswordController,
              enabled: !_isSubmitting,
              controller: _confirmPasswordController,
              obscureText: _obscureNewPassword,
              onToggleVisibility: () =>
                  setState(() => _obscureNewPassword = !_obscureNewPassword),
              onFieldSubmitted: (_) => submit(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await _authService.updatePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        showSuccessNotification('Password changed successfully.');
        context.pop();
      }
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _error = switch (error) {
          BetterAuthException(:final message) => message,
          _ => error.toString(),
        };
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
