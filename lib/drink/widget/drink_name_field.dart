import 'package:flutter/material.dart';

class DrinkNameField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const DrinkNameField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    textInputAction: textInputAction,
    onFieldSubmitted: onFieldSubmitted,
    decoration: const InputDecoration(
      labelText: 'Name',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    validator: _validateName,
  );

  static String? _validateName(String? value) =>
      value == null || value.isEmpty ? 'Please enter a name.' : null;
}
