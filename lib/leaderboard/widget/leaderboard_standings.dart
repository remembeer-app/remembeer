import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';

class LeaderboardStandings extends StatefulWidget {
  const LeaderboardStandings({
    super.key,
    required this.id,
    required this.builder,
    this.month,
    this.waitingBuilder,
    this.errorBuilder,
  });
  final LeaderboardId id;
  final String? month;
  final Widget Function(BuildContext, StandingsResult) builder;
  final WidgetBuilder? waitingBuilder;
  final Widget Function(BuildContext, Object)? errorBuilder;

  @override
  State<LeaderboardStandings> createState() => _LeaderboardStandingsState();
}

class _LeaderboardStandingsState extends State<LeaderboardStandings> {
  var _refreshAt = DateTime.now().millisecondsSinceEpoch;
  int? _nextMonthAt;
  Timer? _rollover;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onResume: _refresh);
  }

  void _refresh() {
    if (!mounted) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    setState(() => _refreshAt = now > _refreshAt ? now : _refreshAt + 1);
  }

  @override
  void dispose() {
    _rollover?.cancel();
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LeaderboardStandingsQuery(
    id: widget.id,
    month: widget.month == null
        ? const Optional.absent()
        : Optional.of(widget.month!),
    refreshAt: Optional.of(_refreshAt.toDouble()),
    waitingBuilder: widget.waitingBuilder,
    errorBuilder: widget.errorBuilder,
    builder: (context, result) {
      final nextMonthAt = result.nextMonthAt.toInt();
      if (nextMonthAt != _nextMonthAt) {
        _nextMonthAt = nextMonthAt;
        _rollover?.cancel();
        final delay = nextMonthAt - DateTime.now().millisecondsSinceEpoch;
        _rollover = Timer(
          Duration(milliseconds: delay > 0 ? delay : 0),
          _refresh,
        );
      }
      return widget.builder(context, result);
    },
  );
}
