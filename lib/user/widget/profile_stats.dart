import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/user.dart';
import 'package:remembeer/convex_api/widgets/user.dart';

class ProfileStats extends StatefulWidget {
  const ProfileStats({
    super.key,
    required this.userId,
    required this.builder,
    this.waitingBuilder,
    this.errorBuilder,
  });
  final UserId userId;
  final Widget Function(BuildContext, StatsResult) builder;
  final WidgetBuilder? waitingBuilder;
  final Widget Function(BuildContext, Object)? errorBuilder;

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  var _refreshAt = DateTime.now().millisecondsSinceEpoch;
  int? _nextRefreshAt;
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
  Widget build(BuildContext context) => UserStatsQuery(
    userId: widget.userId,
    refreshAt: Optional.of(_refreshAt.toDouble()),
    waitingBuilder: widget.waitingBuilder,
    errorBuilder: widget.errorBuilder,
    builder: (context, result) {
      final nextRefreshAt = result.nextRefreshAt.toInt();
      if (nextRefreshAt != _nextRefreshAt) {
        _nextRefreshAt = nextRefreshAt;
        _rollover?.cancel();
        final delay = nextRefreshAt - DateTime.now().millisecondsSinceEpoch;
        _rollover = Timer(
          Duration(milliseconds: delay > 0 ? delay : 0),
          _refresh,
        );
      }
      return widget.builder(context, result);
    },
  );
}
