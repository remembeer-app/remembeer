import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_entry.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/model/leaderboard_type.dart';
import 'package:remembeer/leaderboard/page/manage_leaderboard_page.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/leaderboard/widget/month_selector.dart';
import 'package:remembeer/leaderboard/widget/standing_card.dart';

class LeaderboardDetailPage extends StatefulWidget {
  final Leaderboard leaderboard;

  const LeaderboardDetailPage({super.key, required this.leaderboard});

  @override
  State<LeaderboardDetailPage> createState() => _LeaderboardDetailPageState();
}

class _LeaderboardDetailPageState extends State<LeaderboardDetailPage> {
  final _leaderboardService = get<LeaderboardService>();
  final _monthService = get<MonthService>();

  var _sortType = LeaderboardType.beers;

  @override
  void initState() {
    super.initState();
    _monthService.resetToCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = _leaderboardService.isOwner(widget.leaderboard);
    final icon = LeaderboardIcon.fromName(widget.leaderboard.iconName);

    return PageTemplate(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon.icon, size: 24),
          hGap8,
          Text(widget.leaderboard.name),
        ],
      ),
      child: Column(
        children: [
          _buildActionButtons(context, isOwner),
          MonthSelector(),
          gap8,
          _buildSortToggle(),
          gap16,
          Expanded(child: _buildStandingsList()),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isOwner) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _showInviteCodeDialog(context),
          icon: const Icon(Icons.share),
        ),
        if (isOwner)
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) =>
                    ManageLeaderboardPage(leaderboard: widget.leaderboard),
              ),
            ),
            icon: const Icon(Icons.settings),
          )
        else
          IconButton(
            onPressed: () => _showLeaveConfirmationDialog(context),
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.error,
          ),
      ],
    );
  }

  void _showLeaveConfirmationDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Leave Leaderboard',
      text: 'Are you sure you want to leave "${widget.leaderboard.name}"?',
      submitButtonText: 'Leave',
      onPressed: () async {
        await _leaderboardService.leaveLeaderboard(widget.leaderboard.id);
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }

  void _showInviteCodeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final inviteCode = widget.leaderboard.inviteCode;

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
            gap16,
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
                showNotification(context, 'Invitation code copied!');
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

  Widget _buildStandingsList() {
    return AsyncBuilder<List<LeaderboardEntry>>(
      stream: _leaderboardService.standingsStreamFor(widget.leaderboard),
      builder: (context, standings) {
        final sortedStandings = List<LeaderboardEntry>.from(standings);
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
            return StandingCard(entry: entry, sortType: _sortType);
          },
        );
      },
    );
  }
}
