import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/date/type/date_state.dart';
import 'package:rxdart/rxdart.dart';

class DateService {
  DateService({required ConvexApi api, required ConvexAuthService authService})
    : _api = api,
      _authService = authService {
    _authService.addListener(_reset);
    _lifecycle = AppLifecycleListener(onResume: refresh);
  }

  final ConvexApi _api;
  final ConvexAuthService _authService;
  final _context = BehaviorSubject<DayContextResult>();
  final _selected = BehaviorSubject<DateTime?>.seeded(null);
  late final AppLifecycleListener _lifecycle;
  Timer? _rollover;
  TypedConvexSubscription<DayContextResult>? _subscription;
  StreamSubscription<TypedQueryResult<DayContextResult>>? _listener;
  DateState? _state;

  late final Stream<DateState> selectedDateStateStream =
      Rx.combineLatest2(_context, _selected, (context, selected) {
            final today = DateTime.parse('${context.today}T00:00:00Z');
            return (
              selectedDate: selected == null || selected.isAfter(today)
                  ? today
                  : selected,
              effectiveToday: today,
            );
          })
          .doOnData((state) => _state = state)
          .doOnListen(() => scheduleMicrotask(refresh))
          .doOnCancel(_cancelContext)
          .shareReplay(maxSize: 1);

  void refresh() {
    if (_context.isClosed || !_context.hasListener) return;
    _cancelContext();
    final subscription = _api.drinkLog.dayContextSubscribe(
      at: DateTime.now().millisecondsSinceEpoch.toDouble(),
    );
    _subscription = subscription;
    _listener = subscription.stream.listen((event) {
      switch (event) {
        case TypedQuerySuccess<DayContextResult>(:final value):
          _rollover?.cancel();
          final remaining =
              value.nextBoundary.toInt() -
              DateTime.now().millisecondsSinceEpoch;
          _rollover = Timer(
            Duration(milliseconds: remaining < 0 ? 1 : remaining + 1),
            refresh,
          );
          _context.add(value);
        case TypedQueryError<DayContextResult>(:final message):
          _context.addError(Exception(message));
        case TypedQueryLoading<DayContextResult>():
          break;
      }
    }, onError: _context.addError);
  }

  void _cancelContext() {
    _rollover?.cancel();
    unawaited(_listener?.cancel());
    _listener = null;
    _subscription?.cancel();
    _subscription = null;
  }

  void _reset() {
    _selected.add(null);
    refresh();
  }

  void setDate(DateTime date) {
    final day = DateTime.utc(date.year, date.month, date.day);
    final today = _state?.effectiveToday;
    if (today == null || day.isAfter(today)) return;
    _selected.add(day == today ? null : day);
  }

  void previousDay() {
    final date = _state?.selectedDate;
    if (date != null) setDate(date.subtract(const Duration(days: 1)));
  }

  void nextDay() {
    final date = _state?.selectedDate;
    if (date != null) setDate(date.add(const Duration(days: 1)));
  }

  void goToToday() {
    _selected.add(null);
    refresh();
  }

  void dispose() {
    _authService.removeListener(_reset);
    _lifecycle.dispose();
    _cancelContext();
    unawaited(_selected.close());
    unawaited(_context.close());
  }
}
