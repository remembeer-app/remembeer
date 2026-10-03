import 'package:flutter/material.dart';
import 'package:remembeer/common/extension/searchable.dart';
import 'package:remembeer/user/constants.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onFieldSubmitted;

  const UsernameField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: Icon(Icons.person_outline),
      ),
      maxLength: maxUsernameLength,
      textInputAction: TextInputAction.done,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      validator: _validateUsername,
    );
  }

  static String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty.';
    }
    if (value.trim().length < minUsernameLength) {
      return 'Username must be at least $minUsernameLength characters long.';
    }
    if (value.replaceAll(RegExp(r'\s'), '').toSearchable().length <
        minUsernameLength) {
      return 'Username must contain at least $minUsernameLength searchable characters.';
    }
    return null;
  }
}
