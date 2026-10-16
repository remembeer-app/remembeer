import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
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
  final _cursors = <activity.ActivityArgsCursor>[];
  final _kinds = <activity.ActivityArgsKindsItem>{};
  final _participants = <UserId>{};

  void _filter(VoidCallback change) => setState(() {
    change();
    _cursors.clear();
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Wrap(
        spacing: 8,
        children: [
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
        child: PartyActivityQuery(
          sessionId: SessionId(widget.sessionId),
          cursor: _cursors.isEmpty
              ? const Optional.absent()
              : Optional.of(_cursors.last),
          kinds: Optional.of(_kinds.toList()),
          participantIds: Optional.of(_participants.toList()),
          builder: (context, result) => Column(
            children: [
              Expanded(
                child: result.entries.isEmpty
                    ? const Center(child: Text('No matching party activity.'))
                    : ListView(
                        children: [
                          for (final entry in result.entries)
                            Card(
                              child: ListTile(
                                title: Text(_title(entry, result)),
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
                                  activity.BeerpongPlacement(
                                    :final tournamentId,
                                  ) =>
                                    () => PartyTournamentRoute(
                                      sessionId: widget.sessionId,
                                      tournamentId: tournamentId.value,
                                    ).push<void>(context),
                                  activity.DrinkLog() => null,
                                },
                              ),
                            ),
                        ],
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _cursors.isEmpty
                        ? null
                        : () => setState(_cursors.removeLast),
                    child: const Text('Previous'),
                  ),
                  Text('Page ${_cursors.length + 1}'),
                  TextButton(
                    onPressed: !result.hasMore || result.nextCursor == null
                        ? null
                        : () =>
                              setState(() => _cursors.add(result.nextCursor!)),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

  String _title(
    activity.ActivityResultEntriesItem entry,
    activity.ActivityResult result,
  ) {
    String name(UserId id) =>
        result.users.where((user) => user.id == id).firstOrNull?.username ??
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
