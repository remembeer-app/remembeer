import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remembeer/app_icon/type/app_icon_phase.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/user.dart';

class AppIconService {
  final ConvexAuthService authService;
  final ConvexApi api;

  AppIconService({required this.authService, required this.api});

  static const _channel = MethodChannel('app_icon');

  AppLifecycleListener? _lifecycleListener;
  TypedConvexSubscription<CurrentDayConsumptionResult>? _query;
  StreamSubscription<TypedQueryResult<CurrentDayConsumptionResult>>? _listener;
  Timer? _rollover;
  AppIconPhase? _lastPhase;
  var _refreshAt = 0;
  var _initialized = false;

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    authService.addListener(_refresh);
    _lifecycleListener = AppLifecycleListener(onResume: _refresh);
    _refresh();
  }

  void _refresh() {
    if (!_initialized) return;
    _cancelQuery();
    if (!authService.isAuthenticated) {
      unawaited(_apply(AppIconPhase.initial));
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    _refreshAt = now > _refreshAt ? now : _refreshAt + 1;
    final query = api.user.currentDayConsumptionSubscribe(
      refreshAt: Optional.of(_refreshAt.toDouble()),
    );
    _query = query;
    _listener = query.stream.listen(
      (result) {
        if (!_initialized || _query != query) return;
        switch (result) {
          case TypedQuerySuccess(:final value):
            unawaited(
              _apply(AppIconPhase.forAlcoholMl(value.alcoholConsumedMl)),
            );
            _rollover?.cancel();
            final delay =
                value.nextRefreshAt.toInt() -
                DateTime.now().millisecondsSinceEpoch;
            _rollover = Timer(
              Duration(milliseconds: delay > 0 ? delay : 0),
              _refresh,
            );
          case TypedQueryError(:final message):
            debugPrint('Could not load app icon consumption: $message');
          case TypedQueryLoading():
            break;
        }
      },
      onError: (Object error) {
        debugPrint('Could not load app icon consumption: $error');
      },
    );
  }

  void _cancelQuery() {
    _rollover?.cancel();
    _rollover = null;
    unawaited(_listener?.cancel());
    _listener = null;
    _query?.cancel();
    _query = null;
  }

  Future<void> _apply(AppIconPhase phase) async {
    if (phase == _lastPhase) return;
    _lastPhase = phase;
    try {
      await _channel.invokeMethod<void>('setIcon', {'phase': phase.name});
    } on MissingPluginException {
      // Platform without dynamic icon support (tests, desktop, web).
    } on PlatformException catch (error) {
      if (_lastPhase == phase) _lastPhase = null;
      debugPrint('Failed to change the app icon: ${error.message}');
    }
  }

  void dispose() {
    _initialized = false;
    authService.removeListener(_refresh);
    _cancelQuery();
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }
}
