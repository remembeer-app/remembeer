import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/widget/badge_icon.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/badge.dart';
import 'package:remembeer/convex_api/widgets/badge.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class BadgeVisibilityPage extends StatelessWidget {
  const BadgeVisibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Badges Visibility',
      autmaticallyImplyLeading: true,
      hint:
          'Select which badges you want to display on your profile. '
          'You can show up to $maxBadgesShown badges at a time.',
      child: BadgeListCurrentQuery(
        builder: (context, badges) {
          if (badges.isEmpty) return _buildNoBadgesYet(context);
          final shownCount = badges.where((badge) => badge.isShown).length;
          return BadgeSetVisibilityMutation(
            optimisticUpdate: _optimisticUpdateVisibility,
            builder: (context, mutate, snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      final definition = getBadgeByIdOrNull(badge.badgeKey);
                      final canToggle =
                          !snapshot.isLoading &&
                          (badge.isShown
                              ? shownCount > 1
                              : shownCount < maxBadgesShown);
                      return Card(
                        key: ValueKey(badge.id),
                        child: CheckboxListTile(
                          value: badge.isShown,
                          onChanged: canToggle
                              ? (value) {
                                  if (value == null || value == badge.isShown) {
                                    return;
                                  }
                                  mutate.run(
                                    badgeKey: badge.badgeKey,
                                    isShown: value,
                                  );
                                }
                              : null,
                          title: Text(definition?.name ?? badge.badgeKey),
                          subtitle: definition == null
                              ? null
                              : Text(definition.description),
                          secondary: definition == null
                              ? const Icon(
                                  Icons.emoji_events_outlined,
                                  size: 48,
                                )
                              : BadgeIcon(
                                  badgeDefinition: definition,
                                  size: 48,
                                  padding: 8,
                                ),
                        ),
                      );
                    },
                  ),
                ),
                if (snapshot.error case final error?) ...[
                  const Gap(16),
                  ErrorMessageBox(message: error.toString()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _optimisticUpdateVisibility(
    TypedOptimisticLocalStore store,
    SetVisibilityArgs args,
    OptimisticMutationContext _,
  ) {
    store.updateQuery(
      listCurrentQueryReference,
      const NoArgs(),
      (badges) => [
        for (final badge in badges)
          (
            creationTime: badge.creationTime,
            id: badge.id,
            userId: badge.userId,
            badgeKey: badge.badgeKey,
            unlockedAt: badge.unlockedAt,
            isShown: badge.badgeKey == args.badgeKey
                ? args.isShown
                : badge.isShown,
          ),
      ],
    );
  }

  Widget _buildNoBadgesYet(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(16),
          Text(
            'No badges unlocked yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
