import 'package:flutter/material.dart';
import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/model/badge_definition.dart';
import 'package:remembeer/badge/model/unlocked_badge.dart';
import 'package:remembeer/badge/widget/badge_icon.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class BadgeVisibilityPage extends StatefulWidget {
  const BadgeVisibilityPage({super.key});

  @override
  State<BadgeVisibilityPage> createState() => _BadgeVisibilityPageState();
}

class _BadgeVisibilityPageState extends State<BadgeVisibilityPage> {
  final _userService = get<UserService>();
  Set<String>? _localVisibleIds;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Badges Visibility'),
      hint:
          'Select which badges you want to display on your profile. '
          'You can show up to $maxBadgesShown badges at a time.',
      child: AsyncBuilder(
        stream: _userService.currentUserStream,
        builder: (context, user) {
          final unlockedBadges = user.allBadges;

          if (unlockedBadges.isEmpty) {
            return _buildNoBadgesYet();
          }

          _localVisibleIds = user.shownBadges.map((b) => b.badgeId).toSet();
          final currentVisibleCount = _localVisibleIds!.length;

          return ListView.builder(
            itemCount: unlockedBadges.length,
            itemBuilder: (context, index) {
              final unlockedBadge = unlockedBadges[index];
              final badgeDef = getBadgeById(unlockedBadge.badgeId);

              final isShown = _localVisibleIds!.contains(unlockedBadge.badgeId);

              final canToggle = _isToggleAllowed(
                isCurrentlyShown: isShown,
                totalShownCount: currentVisibleCount,
              );

              return _buildBadgeCard(
                isShown,
                canToggle,
                unlockedBadge,
                badgeDef,
              );
            },
          );
        },
      ),
    );
  }

  bool _isToggleAllowed({
    required bool isCurrentlyShown,
    required int totalShownCount,
  }) {
    if (isCurrentlyShown) {
      return totalShownCount > 1;
    } else {
      return totalShownCount < maxBadgesShown;
    }
  }

  Future<void> _onBadgeVisibilityChanged(String badgeId, bool isShown) async {
    setState(() {
      if (isShown) {
        _localVisibleIds?.add(badgeId);
      } else {
        _localVisibleIds?.remove(badgeId);
      }
    });

    await _userService.updateBadgeVisibility(badgeId, isShown);
  }

  Widget _buildBadgeCard(
    bool isShown,
    bool canToggle,
    UnlockedBadge unlockedBadge,
    BadgeDefinition badgeDef,
  ) {
    return Card(
      child: CheckboxListTile(
        value: isShown,
        onChanged: canToggle
            ? (value) => _onBadgeVisibilityChanged(
                unlockedBadge.badgeId,
                value ?? false,
              )
            : null,
        title: Text(badgeDef.name),
        subtitle: Text(badgeDef.description),
        secondary: BadgeIcon(badgeDefinition: badgeDef, size: 48, padding: 8),
      ),
    );
  }

  Widget _buildNoBadgesYet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          gap16,
          Text(
            'No badges unlocked yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
