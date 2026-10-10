import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:rxdart/rxdart.dart';

class LeaderboardStandings extends StatefulWidget {
  const LeaderboardStandings({
    super.key,
    required this.id,
    required this.builder,
    this.useSelectedMonth = false,
    this.waitingBuilder,
    this.errorBuilder,
  });
  final LeaderboardId id;
  final bool useSelectedMonth;
  final Widget Function(BuildContext, StandingsResult) builder;
  final WidgetBuilder? waitingBuilder;
  final Widget Function(BuildContext, Object)? errorBuilder;

  @override
  State<LeaderboardStandings> createState() => _LeaderboardStandingsState();
}

class _LeaderboardStandingsState extends State<LeaderboardStandings> {
  final _months = get<MonthService>();
  late final _requests = Rx.combineLatest2(
    widget.useSelectedMonth
        ? _months.requestedMonthStream
        : Stream<String?>.value(null),
    _months.refreshAtStream,
    (month, refreshAt) => (month: month, refreshAt: refreshAt),
  );
  (String, int)? _lastClock;

  @override
  Widget build(BuildContext context) => AsyncBuilder(
    stream: _requests,
    waitingBuilder: (context) =>
        widget.waitingBuilder?.call(context) ??
        const Center(child: CircularProgressIndicator()),
    builder: (context, request) => LeaderboardStandingsQuery(
      id: widget.id,
      month: request.month == null
          ? const Optional.absent()
          : Optional.of(request.month!),
      refreshAt: Optional.of(request.refreshAt.toDouble()),
      waitingBuilder: widget.waitingBuilder,
      errorBuilder: widget.errorBuilder,
      builder: (context, result) {
        final clock = (result.currentMonth, result.nextMonthAt.toInt());
        if (clock != _lastClock) {
          _lastClock = clock;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _months.updateReportingMonth(clock.$1, clock.$2);
          });
        }
        return widget.builder(context, result);
      },
    ),
  );
}
