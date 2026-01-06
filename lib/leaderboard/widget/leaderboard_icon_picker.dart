import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';

class LeaderboardIconPicker extends StatelessWidget {
  final LeaderboardIcon selectedIcon;
  final ValueChanged<LeaderboardIcon> onIconSelected;

  const LeaderboardIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Icon', style: theme.textTheme.titleMedium),
        gap8,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: LeaderboardIcon.values.map((icon) {
            final isSelected = icon == selectedIcon;

            return InkWell(
              onTap: () => onIconSelected(icon),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: theme.colorScheme.primary, width: 2)
                      : null,
                ),
                child: Icon(
                  icon.icon,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
