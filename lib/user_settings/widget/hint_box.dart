import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
