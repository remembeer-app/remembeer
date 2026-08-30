import 'package:flutter/material.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/accent_color.dart';

class AccentColorSelector extends StatelessWidget {
  final AccentColorKey? value;
  final ValueChanged<AccentColorKey> onChanged;
  final bool enabled;

  const AccentColorSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in accentColorPalette.entries)
          _AccentChoice(
            accent: entry.value,
            isSelected: entry.key == value,
            onPressed: enabled ? () => onChanged(entry.key) : null,
          ),
      ],
    );
  }
}

class _AccentChoice extends StatelessWidget {
  final AccentColor accent;
  final bool isSelected;
  final VoidCallback? onPressed;

  const _AccentChoice({
    required this.accent,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: accent.name,
      selected: isSelected,
      child: Tooltip(
        message: accent.name,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? accent.color
                    : Theme.of(context).colorScheme.outlineVariant,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.color,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: accent.textColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
