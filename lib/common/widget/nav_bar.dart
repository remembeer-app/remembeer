import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PersistentTabView.router(
      tabs: [
        _buildTab(Icons.person, 'Profile', colorScheme),
        _buildTab(Icons.emoji_events, 'Leaderboards', colorScheme),
        _buildTab(Icons.sports_bar, 'Drink', colorScheme),
        _buildTab(Icons.group, 'Activity', colorScheme),
        _buildTab(Icons.settings, 'Settings', colorScheme),
      ],
      navBarBuilder: (navBarConfig) => Style8BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
          ),
        ),
        height: 60,
      ),
      navigationShell: navigationShell,
    );
  }

  PersistentRouterTabConfig _buildTab(
    IconData icon,
    String title,
    ColorScheme colorScheme,
  ) {
    return PersistentRouterTabConfig(
      item: ItemConfig(
        icon: Icon(icon),
        title: title,
        activeForegroundColor: colorScheme.primary,
        inactiveForegroundColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
