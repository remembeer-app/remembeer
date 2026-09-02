import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyEventCard extends StatelessWidget {
  const PartyEventCard({
    super.key,
    required this.group,
    required this.membersById,
  });

  final PartyEventGroup group;
  final Map<String, UserModel> membersById;

  @override
  Widget build(BuildContext context) {
    final event = group.events.first;
    final colorScheme = Theme.of(context).colorScheme;
    final isReversal = event.kind == PartyEventKind.reversal;
    final isReversed = group.isReversed;
    final names = group.events
        .map(
          (item) =>
              membersById[item.recipientUserId]?.username ?? 'Former member',
        )
        .toSet()
        .join(', ');
    final title = _title(event, names);
    final score = group.events.fold<int>(
      0,
      (total, item) => total + item.pointsUnits,
    );
    final status = isReversal
        ? 'Reversal'
        : isReversed
        ? 'Reversed award'
        : 'Award';

    return Semantics(
      container: true,
      label: '$status. $title. ${formatPartyScore(score.abs())} points.',
      child: Card(
        color: isReversal || isReversed ? colorScheme.errorContainer : null,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: isReversal || isReversed
                    ? colorScheme.error
                    : colorScheme.primaryContainer,
                foregroundColor: isReversal || isReversed
                    ? colorScheme.onError
                    : colorScheme.onPrimaryContainer,
                child: Icon(_icon(event.kind)),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: isReversed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      DateFormat.yMMMd().add_Hm().format(event.occurredAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (isReversed || isReversal) ...[
                      const Gap(6),
                      Text(
                        isReversal
                            ? _reversalReason(event)
                            : 'This award was reversed and remains visible for auditing.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(8),
              Text(
                '${score < 0 ? '-' : '+'}${formatPartyScore(score.abs())}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isReversal ? colorScheme.onErrorContainer : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(PartyEvent event, String names) => switch (event.kind) {
    PartyEventKind.drink =>
      '$names logged ${_payloadString(event, 'drinkName', 'a drink')}',
    PartyEventKind.socialQuest =>
      '$names completed ${_payloadString(event, 'title', 'a social quest')}',
    PartyEventKind.adminChallenge =>
      '$names won ${_payloadString(event, 'title', 'a challenge')}',
    PartyEventKind.beerpongPlacement =>
      '$names earned ${_placement(event)} in beerpong',
    PartyEventKind.reversal => 'Points for $names were reversed',
  };

  String _payloadString(PartyEvent event, String key, String fallback) {
    final value = event.payload[key];
    return value is String && value.isNotEmpty ? value : fallback;
  }

  String _placement(PartyEvent event) {
    final value = event.payload['placement'];
    return value is int ? 'place #$value' : 'a placement';
  }

  String _reversalReason(PartyEvent event) {
    final reason = event.payload['reason'];
    return reason is String && reason.isNotEmpty
        ? 'Reason: $reason'
        : 'This immutable entry reverses an earlier award.';
  }

  IconData _icon(PartyEventKind kind) => switch (kind) {
    PartyEventKind.drink => Icons.local_bar,
    PartyEventKind.socialQuest => Icons.groups,
    PartyEventKind.adminChallenge => Icons.flag,
    PartyEventKind.beerpongPlacement => Icons.emoji_events,
    PartyEventKind.reversal => Icons.undo,
  };
}
