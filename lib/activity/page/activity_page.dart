import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/service/activity_service.dart';
import 'package:remembeer/activity/widget/session_card.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _activityService = get<ActivityService>();
  final _userService = get<UserService>();
  final _scrollController = ScrollController();
  var _hasMore = false;
  var _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isNearBottom {
    final position = _scrollController.position;
    return position.pixels >= position.maxScrollExtent - 200;
  }

  void _onScroll() {
    if (_hasMore && !_isLoadingMore && _isNearBottom) {
      _isLoadingMore = true;
      _activityService.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: AsyncBuilder(
        stream: Rx.combineLatest2(
          _activityService.activityFeedStream,
          _userService.currentUserStream,
          (feed, user) => (
            sessions: feed.sessions,
            hasMore: feed.hasMore,
            endOfDayBoundary: user.endOfDayBoundary,
          ),
        ),
        builder: (context, data) {
          final sessions = data.sessions;
          final endOfDayBoundary = data.endOfDayBoundary;
          _hasMore = data.hasMore;
          _isLoadingMore = false;

          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              _activityService.resetLimit();
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length + (_hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const Gap(8),
              itemBuilder: (context, index) {
                if (index == sessions.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final sessionWithMembers = sessions[index];
                return SessionCard(
                  sessionWithMembers: sessionWithMembers,
                  endOfDayBoundary: endOfDayBoundary,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_bar_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              'No activity yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
            Text(
              'Sessions with friends will appear here',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
