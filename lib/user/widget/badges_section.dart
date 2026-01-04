import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/model/badge_definition.dart';
import 'package:remembeer/badge/model/unlocked_badge.dart';
import 'package:remembeer/user/model/user_model.dart';

class BadgesSection extends StatelessWidget {
  final UserModel user;

  const BadgesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final shownBadges = user.shownBadges;

    if (shownBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Badges',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.white,
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),

            itemCount: shownBadges.length,
            itemBuilder: (context, index) {
              return Center(
                child: _buildBadgeItem(context, shownBadges[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(BuildContext context, UnlockedBadge unlockedBadge) {
    final definition = getBadgeById(unlockedBadge.badgeId);

    return InkWell(
      onTap: () => _showBadgeDetails(context, unlockedBadge, definition),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.shade100,
              border: Border.all(color: Colors.amber.shade700, width: 2),
            ),
            child: Image.asset(definition.iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            definition.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetails(
    BuildContext context,
    UnlockedBadge unlockedBadge,
    BadgeDefinition definition,
  ) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.shade100,
                    border: Border.all(color: Colors.amber.shade700, width: 2),
                  ),
                  child: Image.asset(definition.iconPath, fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),

                Text(
                  definition.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  definition.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                if (unlockedBadge.unlockedAt != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Unlocked on ${DateFormat.yMMMd().format(unlockedBadge.unlockedAt!)}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
