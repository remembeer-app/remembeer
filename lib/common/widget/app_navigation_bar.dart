import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

const _activeIconSize = 36.0;

class RemNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  RemNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        switch (index) {
          case 0:
            ProfileRoute(
              userId: _authService.authenticatedUser.uid,
            ).go(context);
          case 1:
            const LeaderboardsRoute().go(context);
          case 2:
            const DrinkRoute().go(context);
          case 3:
            const ActivityRoute().go(context);
          case 4:
            const SettingsRoute().go(context);
        }
        onTap(index);
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          activeIcon: Icon(Icons.person, size: _activeIconSize),
          label: 'Profile',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          activeIcon: Icon(Icons.emoji_events, size: _activeIconSize),
          label: 'Leaderboards',
        ),
        BottomNavigationBarItem(
          icon: const DrinkIcon(
            category: DrinkCategory.beer,
            color: Colors.grey,
            size: 28,
          ),
          activeIcon: DrinkIcon(
            category: DrinkCategory.beer,
            color: Theme.of(context).colorScheme.primary,
            size: _activeIconSize,
          ),
          label: 'Drink',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.group),
          activeIcon: Icon(Icons.group, size: _activeIconSize),
          label: 'Activity',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          activeIcon: Icon(Icons.settings, size: _activeIconSize),
          label: 'Settings',
        ),
      ],
    );
  }
}
