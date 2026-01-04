import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/constants.dart';
import 'package:remembeer/common/constants.dart';

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalized = removeDiacritics(password);
    final hasMinLength = password.length >= minPasswordLength;
    final hasUppercase = normalized.contains(RegExp('[A-Z]'));
    final hasLowercase = normalized.contains(RegExp('[a-z]'));
    final hasNumber = normalized.contains(RegExp('[0-9]'));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          gap8,
          _RequirementRow(
            text: 'At least $minPasswordLength characters',
            isMet: hasMinLength,
          ),
          gap2,
          _RequirementRow(text: 'One uppercase letter', isMet: hasUppercase),
          gap2,
          _RequirementRow(text: 'One lowercase letter', isMet: hasLowercase),
          gap2,
          _RequirementRow(text: 'One number', isMet: hasNumber),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementRow({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isMet ? Colors.green : theme.colorScheme.onSurfaceVariant;
    final icon = isMet ? Icons.check_circle : Icons.circle_outlined;

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        hGap8,
        Text(text, style: theme.textTheme.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
