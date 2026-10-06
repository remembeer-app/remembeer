import 'package:flutter/material.dart';
import 'package:remembeer/auth/constants.dart';

enum _PasswordFieldType { current, newPassword, confirmation }

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final bool enabled;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final _PasswordFieldType _type;
  final TextEditingController? _comparisonController;

  const PasswordField.current({
    super.key,
    required this.controller,
    this.label = 'Current Password',
    required this.obscureText,
    required this.onToggleVisibility,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
  }) : _type = _PasswordFieldType.current,
       _comparisonController = null;

  const PasswordField.newPassword({
    super.key,
    required this.controller,
    this.label = 'New Password',
    required this.obscureText,
    required this.onToggleVisibility,
    TextEditingController? currentPasswordController,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
  }) : _type = _PasswordFieldType.newPassword,
       _comparisonController = currentPasswordController;

  const PasswordField.confirmation({
    super.key,
    required this.controller,
    this.label = 'Confirm New Password',
    required this.obscureText,
    required this.onToggleVisibility,
    required TextEditingController passwordController,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onFieldSubmitted,
  }) : _type = _PasswordFieldType.confirmation,
       _comparisonController = passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: _validate,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: enabled ? onToggleVisibility : null,
        ),
      ),
    );
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return switch (_type) {
        _PasswordFieldType.current => 'Please enter your current password.',
        _PasswordFieldType.newPassword => 'Please enter a new password.',
        _PasswordFieldType.confirmation => 'Please confirm your new password.',
      };
    }
    switch (_type) {
      case _PasswordFieldType.current:
        return null;
      case _PasswordFieldType.newPassword:
        if (!isPasswordValid(value)) {
          return 'Password does not meet requirements.';
        }
        if (value == _comparisonController?.text) {
          return 'New password must be different from current.';
        }
        return null;
      case _PasswordFieldType.confirmation:
        if (value != _comparisonController!.text) {
          return 'Passwords do not match.';
        }
        return null;
    }
  }
}
