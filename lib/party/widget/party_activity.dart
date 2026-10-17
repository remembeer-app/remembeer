import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/party.dart' as activity;
import 'package:remembeer/convex_api/widgets/party.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/routes.dart';

class PartyActivity extends StatefulWidget {
  const PartyActivity({super.key, required this.sessionId});
  final String sessionId;
  @override
  State<PartyActivity> createState() => _PartyActivityState();
}

class _PartyActivityState extends State<PartyActivity> {
  var _generation = 0;
  final _kinds = <activity.ActivityArgsKindsItem>{};
  final _participants = <UserId>{};

  void _filter(VoidCallback change) => setState(change);

  void _restart() => setState(() => _generation++);

  void _loadIfNeeded(
    ScrollMetrics metrics,
    PaginationStatus status,
    VoidCallback loadMore,
  ) {
    if (metrics.axis == Axis.vertical &&
        metrics.extentAfter < partyActivityScrollThreshold &&
        status == PaginationStatus.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) loadMore();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Wrap(
        spacing: 8,
        children: [
          IconButton(
            tooltip: 'Refresh activity',
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
          ),
          for (final kind in activity.ActivityArgsKindsItem.values)
            FilterChip(
              label: Text(switch (kind) {
                activity.ActivityArgsKindsItem.drinkLogValue => 'Drinks',
                activity.ActivityArgsKindsItem.socialQuestValue => 'Quests',
                activity.ActivityArgsKindsItem.partyChallengeValue =>
                  'Challenges',
                activity.ActivityArgsKindsItem.beerpongPlacementValue =>
                  'Beerpong',
              }),
              selected: _kinds.contains(kind),
              onSelected: (value) => _filter(() {
                value ? _kinds.add(kind) : _kinds.remove(kind);
              }),
            ),
        ],
      ),
      SessionMemberListForSessionQuery(
        sessionId: SessionId(widget.sessionId),
        builder: (context, members) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final entry in members)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.username),
                    selected: _participants.contains(entry.member.userId),
                    onSelected: (value) => _filter(() {
                      value
                          ? _participants.add(entry.member.userId)
                          : _participants.remove(entry.member.userId);
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
      const Gap(12),
      Expanded(
        child: PartyActivityQuery.snapshot(
          key: ValueKey(_generation),
          sessionId: SessionId(widget.sessionId),
          pageSize: partyActivityPageSize,
          kinds: Optional.of(_kinds.toList()),
          participantIds: Optional.of(_participants.toList()),
          snapshotBuilder: (context, snapshot, loadMore) {
            if (snapshot.status == PaginationStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.items.isEmpty) {
              return snapshot.error == null
                  ? const Center(child: Text('No matching party activity.'))
                  : _error();
            }
            return NotificationListener<ScrollMetricsNotification>(
              onNotification: (notification) {
                _loadIfNeeded(notification.metrics, snapshot.status, loadMore);
                return false;
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  _loadIfNeeded(
                    notification.metrics,
                    snapshot.status,
                    loadMore,
                  );
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () async => _restart(),
                  child: ListView.builder(
                    key: ValueKey((
                      widget.sessionId,
                      _kinds.map((kind) => kind.value).join(','),
                      _participants.map((id) => id.value).join(','),
                    )),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        snapshot.items.length + (snapshot.isDone ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == snapshot.items.length) {
                        if (snapshot.error != null) return _error();
                        if (snapshot.status == PaginationStatus.idle) {
                          return const Gap(16);
                        }
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final item = snapshot.items[index];
                      final entry = item.entry;
                      return Card(
                        key: ValueKey(entry.id),
                        child: ListTile(
                          title: Text(_title(item)),
                          subtitle: Text(
                            DateFormat.yMMMd().add_Hm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                entry.occurredAt.toInt(),
                              ),
                            ),
                          ),
                          trailing: Text(
                            '+${formatPartyScore(entry.scoreUnits.toInt())}',
                          ),
                          onTap: switch (entry) {
                            activity.SocialQuest(:final questId) =>
                              () => PartyQuestRoute(
                                sessionId: widget.sessionId,
                                questId: questId.value,
                              ).push<void>(context),
                            activity.PartyChallenge(:final challengeId) =>
                              () => PartyChallengeRoute(
                                sessionId: widget.sessionId,
                                challengeId: challengeId.value,
                              ).push<void>(context),
                            activity.BeerpongPlacement(:final tournamentId) =>
                              () => PartyTournamentRoute(
                                sessionId: widget.sessionId,
                                tournamentId: tournamentId.value,
                              ).push<void>(context),
                            activity.DrinkLog() => null,
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );

  Widget _error() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const ErrorMessageBox(message: 'Could not load party activity.'),
      TextButton(onPressed: _restart, child: const Text('Retry')),
    ],
  );

  String _title(activity.ActivityPageItem item) {
    final entry = item.entry;
    String name(UserId id) =>
        item.users.where((user) => user.id == id).firstOrNull?.username ??
        'Unavailable user';
    return switch (entry) {
      activity.DrinkLog(:final userId, :final drinkName) =>
        '${name(userId)} logged $drinkName',
      activity.SocialQuest(
        :final firstUserId,
        :final secondUserId,
        :final questTitle,
      ) =>
        '${name(firstUserId)} & ${name(secondUserId)} completed $questTitle',
      activity.PartyChallenge(:final userId, :final challengeTitle) =>
        '${name(userId)} won $challengeTitle',
      activity.BeerpongPlacement(
        :final userId,
        :final teamName,
        :final placement,
      ) =>
        '${name(userId)} · $teamName · place #${placement.toInt()}',
    };
  }
}
