import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remembeer/activity/page/activity_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/app_navigation_bar.dart';
import 'package:remembeer/drink/page/drink_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/page_navigation_service.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => PageSwitcherState();
}

class PageSwitcherState extends State<PageSwitcher> {
  final _pageNavigationService = get<PageNavigationService>();
  final _authService = get<AuthService>();
  late StreamSubscription<int> _pageSubscription;
  late List<Widget> _pages;

  var _selectedPageIndex = drinkPageIndex;

  @override
  void initState() {
    super.initState();
    _pageSubscription = _pageNavigationService.pageIndexStream.listen((index) {
      setState(() => _selectedPageIndex = index);
    });
    _pages = [
      ProfilePage(userId: _authService.authenticatedUser.uid, showTitle: false),
      LeaderboardsPage(),
      const DrinkPage(),
      const ActivityPage(),
      SettingsPage(),
    ];
  }

  @override
  void dispose() {
    _pageSubscription.cancel();
    super.dispose();
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
            AppNavigationBar(
              currentIndex: _selectedPageIndex,
              onTap: _pageNavigationService.setPageIndex,
            ),
          ],
        ),
      ),
    );
  }
}
