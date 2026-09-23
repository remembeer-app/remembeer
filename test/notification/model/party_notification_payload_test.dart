import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/notification/model/notification_type.dart';
import 'package:remembeer/notification/model/party_notification_payload.dart';

void main() {
  test('quests and challenges use foreground system notifications', () {
    expect(
      NotificationType.values.where(
        (type) => type.showsAsForegroundSystemNotification,
      ),
      {
        NotificationType.partyQuestStarted,
        NotificationType.partyQuestCompleted,
        NotificationType.partyChallengeStarted,
        NotificationType.partyChallengeWinner,
      },
    );
  });

  test('routes every Party event to its typed destination', () {
    const cases = <NotificationType, String>{
      NotificationType.partyActivated: '/drink-logs/parties/party-1',
      NotificationType.partyQuestStarted:
          '/drink-logs/parties/party-1/quests/source-1?tab=games',
      NotificationType.partyQuestCompleted:
          '/drink-logs/parties/party-1/quests/source-1',
      NotificationType.partyChallengeStarted:
          '/drink-logs/parties/party-1/challenges/source-1?tab=games',
      NotificationType.partyChallengeWinner:
          '/drink-logs/parties/party-1/challenges/source-1',
      NotificationType.partyBeerpongEnrollment:
          '/drink-logs/parties/party-1/tournaments/source-1?tab=games',
      NotificationType.partyBeerpongMatchReady:
          '/drink-logs/parties/party-1/tournaments/source-1?tab=games',
      NotificationType.partyBeerpongMatchResult:
          '/drink-logs/parties/party-1/tournaments/source-1?tab=games',
      NotificationType.partyBeerpongCompleted:
          '/drink-logs/parties/party-1/tournaments/source-1?tab=ranking',
      NotificationType.partyArchived: '/drink-logs/parties/party-1',
    };

    for (final entry in cases.entries) {
      final sourceRequired = switch (entry.key) {
        NotificationType.partyActivated ||
        NotificationType.partyArchived => false,
        _ => true,
      };
      final payload = PartyNotificationPayload.fromData({
        'type': entry.key.type,
        'sessionId': 'party-1',
        'tab': switch (entry.key) {
          NotificationType.partyQuestStarted ||
          NotificationType.partyChallengeStarted ||
          NotificationType.partyBeerpongEnrollment ||
          NotificationType.partyBeerpongMatchReady ||
          NotificationType.partyBeerpongMatchResult => 'games',
          NotificationType.partyBeerpongCompleted => 'ranking',
          _ => 'activity',
        },
        if (sourceRequired) 'sourceId': 'source-1',
      });

      expect(payload?.location, entry.value, reason: entry.key.type);
    }
  });

  test('rejects malformed, incomplete, and non-Party payloads', () {
    expect(PartyNotificationPayload.fromData(const {}), isNull);
    expect(
      PartyNotificationPayload.fromData(const {
        'type': 'party_quest_started',
        'sessionId': 'party-1',
        'tab': 'games',
      }),
      isNull,
    );
    expect(
      PartyNotificationPayload.fromData(const {
        'type': 'party_activated',
        'sessionId': 'party-1',
        'tab': 'invalid',
      }),
      isNull,
    );
    expect(
      PartyNotificationPayload.fromData(const {
        'type': 'added_to_session',
        'sessionId': 'party-1',
        'tab': 'activity',
      }),
      isNull,
    );
  });

  test('handles repeated taps once', () {
    final locations = <String>[];
    final notificationRouter = PartyNotificationRouter(locations.add);
    const data = <String, dynamic>{
      'type': 'party_activated',
      'sessionId': 'party-1',
      'tab': 'activity',
    };

    expect(notificationRouter.handle(data, messageId: 'message-1'), isTrue);
    expect(notificationRouter.handle(data, messageId: 'message-1'), isTrue);
    expect(locations, ['/drink-logs/parties/party-1']);
  });
}
