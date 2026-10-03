import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  final String? hint;
  final Widget child;

  const SettingsPage({
    super.key,
    required this.title,
    this.hint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(title),
      automaticallyImplyLeading: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hint case final hint?) ...[HintBox(hint: hint), const Gap(16)],
          Expanded(child: child),
        ],
      ),
    );
  }
}

class HintBox extends StatelessWidget {
  const HintBox({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.onPrimaryContainer),
          const Gap(12),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
