import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_quest_selection.dart';
import 'package:remembeer/party/model/party_quest_template.dart';

void main() {
  final now = DateTime(2026, 9, 2, 18, 30);

  test('party root round trips with nested defaults and optional fields', () {
    final party = Party(
      id: 'party-1',
      sessionId: 'party-1',
      status: PartyStatus.archived,
      activatedAt: now,
      activatedByUserId: 'user-1',
      archivedAt: now.add(const Duration(hours: 4)),
      questSchedule: PartyQuestSchedule(nextQuestAt: now),
      activeQuestId: 'quest-1',
      activeChallengeId: 'challenge-1',
      activeTournamentId: 'tournament-1',
      createdAt: now,
      updatedAt: now,
    );

    expect(Party.fromJson(party.toJson()), party);
    expect(party.moduleSettings, const PartyModuleSettings());
    expect(party.schemaVersion, partySchemaVersion);
    expect(party.toJson()['status'], 'archived');
    expect(party.toJson()['activatedAt'], isA<Timestamp>());
  });

  test('party member round trips with class and aggregate defaults', () {
    final member = PartyMember(
      id: 'user-1',
      userId: 'user-1',
      selectedClass: DrinkCategory.cider,
      classChangedAt: now,
      joinedAt: now,
      updatedAt: now,
    );

    expect(PartyMember.fromJson(member.toJson()), member);
    expect(member.classVersion, 0);
    expect(member.beerpongOptIn, isFalse);
    expect(member.scoreUnits, 0);
    expect(member.drinkCount, 0);
    expect(member.toJson()['selectedClass'], 'cider');
  });

  test('event round trips with audit payload and optional references', () {
    final event = PartyEvent(
      id: 'event-1',
      kind: PartyEventKind.reversal,
      recipientUserId: 'user-1',
      participantIds: const ['user-1', 'user-2'],
      pointsUnits: -12500,
      sourceCollection: PartyEventSourceCollection.drinks,
      sourceId: 'drink-1',
      reversesEventId: 'event-0',
      actorUserId: 'admin-1',
      occurredAt: now,
      createdAt: now,
      payload: const {'category': 'beer', 'alcoholMl': 12.5, 'classVersion': 2},
    );

    expect(PartyEvent.fromJson(event.toJson()), event);
    expect(event.toJson()['kind'], 'reversal');
    expect(event.toJson()['sourceCollection'], 'drinks');
  });

  test('quest documents round trip with every optional field', () {
    final template = PartyQuestTemplate(
      id: 'template-1',
      source: PartyQuestTemplateSource.custom,
      builtInKey: 'sameAccent',
      title: 'Find an ally',
      instructions: 'Choose a partner.',
      pointsUnits: 5000,
      durationMinutes: 10,
      eligibilityRule: 'allEligibleMembers',
      catalogVersion: 1,
      createdByUserId: 'admin-1',
      createdAt: now,
      updatedAt: now,
    );
    final quest = PartyQuest(
      id: 'quest-1',
      templateId: template.id,
      titleSnapshot: template.title,
      instructionsSnapshot: template.instructions,
      pointsUnits: template.pointsUnits,
      startsAt: now,
      endsAt: now.add(const Duration(minutes: 10)),
      status: PartyQuestStatus.active,
      eligibleMemberIds: const ['user-1', 'user-2'],
      completedPairKeys: const ['user-1:user-2'],
      createdAt: now,
    );
    final selection = PartyQuestSelection(
      id: 'user-1',
      selectorUserId: 'user-1',
      selectedUserId: 'user-2',
      selectedAt: now,
    );

    expect(PartyQuestTemplate.fromJson(template.toJson()), template);
    expect(PartyQuest.fromJson(quest.toJson()), quest);
    expect(PartyQuestSelection.fromJson(selection.toJson()), selection);
    expect(template.enabled, isTrue);
  });

  test('challenge round trips with multiple winners', () {
    final challenge = PartyChallenge(
      id: 'challenge-1',
      title: 'Challenge',
      instructions: 'Complete it.',
      pointsUnits: 10000,
      startsAt: now,
      endsAt: now.add(const Duration(minutes: 20)),
      status: PartyChallengeStatus.completed,
      winnerIds: const ['user-1', 'user-2'],
      createdByUserId: 'admin-1',
      createdAt: now,
      updatedAt: now,
    );

    expect(PartyChallenge.fromJson(challenge.toJson()), challenge);
    expect(challenge.toJson()['status'], 'completed');
  });

  test('beerpong documents round trip with every optional field', () {
    final tournament = BeerpongTournament(
      id: 'tournament-1',
      status: BeerpongTournamentStatus.completed,
      participantIds: const ['user-1', 'user-2'],
      teamCount: 2,
      thirdPlaceEnabled: true,
      firstPlacePointsUnits: 30000,
      secondPlacePointsUnits: 20000,
      thirdPlacePointsUnits: 10000,
      randomSeedHash: 'hash',
      randomSeedReveal: 'seed',
      createdByUserId: 'admin-1',
      createdAt: now,
      completedAt: now.add(const Duration(hours: 2)),
    );
    const team = BeerpongTeam(
      id: 'team-1',
      name: 'Team One',
      memberIds: ['user-1'],
      seed: 1,
      placement: 1,
    );
    const match = BeerpongMatch(
      id: 'match-1',
      round: 1,
      position: 0,
      kind: BeerpongMatchKind.thirdPlace,
      teamAId: 'team-1',
      teamBId: 'team-2',
      winnerTeamId: 'team-1',
      loserTeamId: 'team-2',
      status: BeerpongMatchStatus.completed,
      nextMatchId: 'match-2',
      nextSlot: BeerpongMatchSlot.a,
    );

    expect(BeerpongTournament.fromJson(tournament.toJson()), tournament);
    expect(BeerpongTeam.fromJson(team.toJson()), team);
    expect(BeerpongMatch.fromJson(match.toJson()), match);
    expect(match.toJson()['kind'], 'thirdPlace');
    expect(match.toJson()['nextSlot'], 'a');
  });

  test('invalid persisted enum values are rejected', () {
    expect(
      () => Party.fromJson({
        'id': 'party-1',
        'sessionId': 'party-1',
        'status': 'paused',
        'activatedAt': Timestamp.fromDate(now),
        'activatedByUserId': 'user-1',
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      }),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('class metadata covers every drink category once', () {
    expect(
      partyClasses.map((partyClass) => partyClass.category).toSet(),
      DrinkCategory.values.toSet(),
    );
    expect(partyClasses.length, DrinkCategory.values.length);
  });

  test('score units format as trimmed decimal points', () {
    expect(formatPartyScore(12000), '12');
    expect(formatPartyScore(12345), '12.345');
    expect(formatPartyScore(-1500), '-1.5');
    expect(formatPartyScore(0), '0');
  });
}
