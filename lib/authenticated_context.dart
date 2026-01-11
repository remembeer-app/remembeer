import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/badge/model/badge_definition.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/friend_request/page/friend_requests_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/notification/model/notification_type.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/page_navigation_service.dart';
import 'package:remembeer/page_switcher.dart';

class AuthenticatedContext extends StatefulWidget {
  const AuthenticatedContext({super.key});

  @override
  State<AuthenticatedContext> createState() => _AuthenticatedContextState();
}

class _AuthenticatedContextState extends State<AuthenticatedContext> {
  final _pageNavigationService = get<PageNavigationService>();
  final _drinkService = get<DrinkService>();
  final _badgeService = get<BadgeService>();
  final _notificationService = get<NotificationService>();

  late StreamSubscription<BadgeDefinition> _badgeSubscription;
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

      _pageNavigationService.setPageIndex(drinkPageIndex);
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
    return const PageSwitcher();
  }
}
