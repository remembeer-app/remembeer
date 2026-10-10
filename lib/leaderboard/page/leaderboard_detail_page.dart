import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/model/leaderboard_type.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_standings.dart';
import 'package:remembeer/leaderboard/widget/month_selector.dart';
import 'package:remembeer/leaderboard/widget/standing_card.dart';
import 'package:remembeer/routes.dart';

class LeaderboardDetailPage extends StatefulWidget {
  final String leaderboardId;

  const LeaderboardDetailPage({super.key, required this.leaderboardId});

  @override
  State<LeaderboardDetailPage> createState() => _LeaderboardDetailPageState();
}

class _LeaderboardDetailPageState extends State<LeaderboardDetailPage> {
  final _monthService = get<MonthService>();

  var _sortType = LeaderboardType.beers;

  @override
  void initState() {
    super.initState();
    _monthService.resetToCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    return UserCurrentQuery(
      builder: (_, user) => LeaderboardGetTypeQuery(
        id: LeaderboardId(widget.leaderboardId),
        builder: (_, result) =>
            _buildPage(context, result.leaderboard, user.id),
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    LeaderboardDocument leaderboard,
    UserId currentUserId,
  ) {
    final isOwner = leaderboard.ownerId == currentUserId;
    final icon = LeaderboardIcon.fromName(leaderboard.iconName);

    return PageTemplate(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon.icon, size: 24),
          const Gap(8),
          Text(leaderboard.name),
        ],
      ),
      child: Column(
        children: [
          _buildActionButtons(context, leaderboard, isOwner),
          MonthSelector(),
          const Gap(8),
          _buildSortToggle(),
          const Gap(16),
          Expanded(child: _buildStandingsList(leaderboard, currentUserId)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    LeaderboardDocument leaderboard,
    bool isOwner,
  ) {
    return LeaderboardLeaveMutation(
      builder: (_, leave, snapshot) => Column(
        children: [
          if (snapshot.error case final error?)
            ErrorMessageBox(message: error.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _showInviteCodeDialog(context, leaderboard),
                icon: const Icon(Icons.share),
              ),
              if (isOwner)
                IconButton(
                  onPressed: () => ManageLeaderboardRoute(
                    leaderboardId: leaderboard.id.value,
                  ).push<void>(context),
                  icon: const Icon(Icons.settings),
                )
              else
                IconButton(
                  onPressed: snapshot.isLoading
                      ? null
                      : () => _showLeaveConfirmationDialog(
                          context,
                          leaderboard,
                          leave,
                        ),
                  icon: const Icon(Icons.logout),
                  color: Theme.of(context).colorScheme.error,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLeaveConfirmationDialog(
    BuildContext context,
    LeaderboardDocument leaderboard,
    LeaderboardLeaveMutationExecutor leave,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Leave Leaderboard',
      text: 'Are you sure you want to leave "${leaderboard.name}"?',
      submitButtonText: 'Leave',
      onPressed: () async {
        leave.run(
          id: leaderboard.id,
          onSuccess: (_) {
            if (context.mounted) const LeaderboardsRoute().go(context);
          },
        );
      },
    );
  }

  void _showInviteCodeDialog(
    BuildContext context,
    LeaderboardDocument leaderboard,
  ) {
    final theme = Theme.of(context);
    final inviteCode = leaderboard.inviteCode;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share this code with friends to invite them:',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                inviteCode,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: inviteCode));
              if (context.mounted) {
                Navigator.of(context).pop();
                showSuccessNotification('Invitation code copied!');
              }
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  Widget _buildSortToggle() {
    return SegmentedButton<LeaderboardType>(
      segments: const [
        ButtonSegment(
          value: LeaderboardType.beers,
          label: Text('Beers'),
          icon: Icon(Icons.sports_bar),
        ),
        ButtonSegment(
          value: LeaderboardType.alcohol,
          label: Text('Alcohol'),
          icon: Icon(Icons.local_bar),
        ),
      ],
      selected: {_sortType},
      onSelectionChanged: (selection) {
        setState(() => _sortType = selection.first);
      },
    );
  }

  Widget _buildStandingsList(
    LeaderboardDocument leaderboard,
    UserId currentUserId,
  ) {
    return LeaderboardStandings(
      id: leaderboard.id,
      useSelectedMonth: true,
      builder: (context, standings) {
        final sortedStandings = List<StandingsResultEntriesItem>.from(
          standings.entries,
        );
        if (_sortType == LeaderboardType.beers) {
          sortedStandings.sort(
            (a, b) => a.rankByBeers.compareTo(b.rankByBeers),
          );
        } else {
          sortedStandings.sort(
            (a, b) => a.rankByAlcohol.compareTo(b.rankByAlcohol),
          );
        }

        return ListView.builder(
          itemCount: sortedStandings.length,
          itemBuilder: (context, index) {
            final entry = sortedStandings[index];
            return StandingCard(
              entry: entry,
              sortType: _sortType,
              isCurrentUser: entry.user.id == currentUserId,
            );
          },
        );
      },
    );
  }
}
