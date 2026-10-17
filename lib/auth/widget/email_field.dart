import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const EmailField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.email],
      onFieldSubmitted: onFieldSubmitted,
      validator: _validateEmail,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  static String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }
}
