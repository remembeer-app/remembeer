import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/activity/page/activity_page.dart';
import 'package:remembeer/badge/model/badge_definition.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/page/drink_page.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/friend_request/page/friend_requests_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/notification/model/notification_type.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';

const _drinkPageIndex = 2;
const _activeIconSize = 36.0;

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  var _selectedPageIndex = _drinkPageIndex;
  static final _pages = <Widget>[
    ProfilePage(),
    LeaderboardsPage(),
    const DrinkPage(),
    const ActivityPage(),
    SettingsPage(),
  ];

  final _drinkService = get<DrinkService>();

  final _badgeService = get<BadgeService>();
  late StreamSubscription<BadgeDefinition> _badgeSubscription;

  final _notificationService = get<NotificationService>();
  late StreamSubscription<RemoteMessage> _notificationTapSubscription;

  static const _platform = MethodChannel('quick_add_action');

  @override
  void initState() {
    super.initState();
    _platform.setMethodCallHandler(_handleQuickAddAction);

    _badgeSubscription = _badgeService.badgeUnlockedStream.listen((badge) {
      if (mounted) {
        showNotification(context, '${badge.name} badge unlocked!');
      }
    });

    _notificationTapSubscription = _notificationService.notificationTapStream
        .listen(_handleNotificationTap);
  }

  @override
  void dispose() {
    _platform.setMethodCallHandler(null);
    _badgeSubscription.cancel();
    _notificationTapSubscription.cancel();
    super.dispose();
  }

  Future<void> _handleQuickAddAction(MethodCall call) async {
    if (call.method == 'quickAddPressed') {
      await _drinkService.addDefaultDrink();
      if (!mounted) return;

      setState(() => _selectedPageIndex = _drinkPageIndex);
      showNotification(context, 'Default drink added!');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final type = NotificationType.fromString(message.data['type'] as String?);

    switch (type) {
      case NotificationType.friendRequest:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => FriendRequestsPage()),
        );
      case null:
        // TODO(metju-ac): Handle this when we add logging.
        debugPrint('Unknown notification type: ${message.data['type']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(index: _selectedPageIndex, children: _pages),
            ),
            _buildNavigationBar(context),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedPageIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) => setState(() => _selectedPageIndex = index),
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
