import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/constants.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _authService = get<AuthService>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscureCurrentPassword = true;
  var _obscureNewPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Change Password'),
      padding: const EdgeInsets.all(24),
      child: LoadingForm(
        errorMapper: (e) => e is FirebaseAuthException
            ? mapFirebaseAuthError(e.code)
            : e.toString(),
        builder: (form) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentPasswordField(form),
            gap16,
            _buildNewPasswordField(form),
            gap8,
            PasswordRequirements(password: _newPasswordController.text),
            gap16,
            _buildConfirmPasswordField(form),
            form.buildErrorMessage(),
            gap24,
            form.buildSubmitButton(
              text: 'Change Password',
              onSubmit: () => _changePassword(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _currentPasswordController,
      label: 'Current Password',
      obscureText: _obscureCurrentPassword,
      onToggleVisibility: () =>
          setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your current password.';
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _newPasswordController,
      label: 'New Password',
      obscureText: _obscureNewPassword,
      onToggleVisibility: () =>
          setState(() => _obscureNewPassword = !_obscureNewPassword),
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a new password.';
        }
        if (!isPasswordValid(value)) {
          return 'Password does not meet requirements.';
        }
        if (value == _currentPasswordController.text) {
          return 'New password must be different from current.';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _confirmPasswordController,
      label: 'Confirm New Password',
      obscureText: _obscureNewPassword,
      onToggleVisibility: () =>
          setState(() => _obscureNewPassword = !_obscureNewPassword),
      isLastField: true,
      onFieldSubmitted: () => _changePassword(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your new password.';
        }
        if (value != _newPasswordController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    await _authService.updatePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (context.mounted) {
      showSuccessNotification('Password changed successfully.');
      Navigator.of(context).pop();
    }
  }
}
