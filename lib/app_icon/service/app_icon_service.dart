import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remembeer/app_icon/type/app_icon_phase.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/date/util/date_utils.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class AppIconService {
  final AuthService authService;
  final UserController userController;

  AppIconService({required this.authService, required this.userController});

  static const _channel = MethodChannel('app_icon');

  final _resumed = BehaviorSubject<void>.seeded(null);
  AppLifecycleListener? _lifecycleListener;
  StreamSubscription<AppIconPhase>? _subscription;

  void initialize() {
    _lifecycleListener ??= AppLifecycleListener(
      onResume: () => _resumed.add(null),
    );

    _subscription ??= authService.authStateChanges
        .switchMap(
          (user) => user == null
              ? Stream.value(AppIconPhase.initial)
              : Rx.combineLatest2<UserModel, void, AppIconPhase>(
                  userController.currentUserStream,
                  _resumed.stream,
                  (user, _) => phaseFor(user),
                ),
        )
        .distinct()
        .listen(_apply);
  }

  AppIconPhase phaseFor(UserModel user, {DateTime? now}) {
    final today = effectiveDate(now ?? DateTime.now(), user.endOfDayBoundary);
    final daily = user.getDailyStats(today.year, today.month, today.day);
    return AppIconPhase.forAlcoholMl(daily.alcoholConsumedMl);
  }

  Future<void> _apply(AppIconPhase phase) async {
    try {
      await _channel.invokeMethod<void>('setIcon', {'phase': phase.name});
    } on MissingPluginException {
      // Platform without dynamic icon support (tests, desktop, web).
    } on PlatformException catch (error) {
      debugPrint('Failed to change the app icon: ${error.message}');
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
    _resumed.close();
  }
}
