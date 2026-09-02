import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_quest_selection.dart';
import 'package:remembeer/party/model/party_quest_template.dart';

class PartyGameController {
  PartyGameController({
    FirebaseFirestore? firestore,
    PartyCommandClient? commandClient,
  }) : _firestore = firestore,
       _commandClient = commandClient ?? PartyCommandClient();

  final FirebaseFirestore? _firestore;
  final PartyCommandClient _commandClient;

  FirebaseFirestore get _database => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<PartyQuestTemplate> questTemplatesReference(
    String sessionId,
  ) => _collection(
    sessionId,
    partyQuestTemplatesCollection,
    PartyQuestTemplate.fromJson,
  );

  CollectionReference<PartyQuest> questsReference(String sessionId) =>
      _collection(sessionId, partyQuestsCollection, PartyQuest.fromJson);

  CollectionReference<PartyQuestSelection> questSelectionsReference(
    String sessionId,
    String questId,
  ) => questsReference(sessionId)
      .doc(questId)
      .collection(partyQuestSelectionsCollection)
      .withConverter(
        fromFirestore: (snapshot, _) => PartyQuestSelection.fromJson(
          (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
        ),
        toFirestore: (_, _) => throw UnsupportedError(
          'Party quest selection references are read-only.',
        ),
      );

  CollectionReference<PartyChallenge> challengesReference(String sessionId) =>
      _collection(
        sessionId,
        partyChallengesCollection,
        PartyChallenge.fromJson,
      );

  CollectionReference<BeerpongTournament> tournamentsReference(
    String sessionId,
  ) => _collection(
    sessionId,
    partyTournamentsCollection,
    BeerpongTournament.fromJson,
  );

  CollectionReference<BeerpongTeam> teamsReference(
    String sessionId,
    String tournamentId,
  ) => tournamentsReference(sessionId)
      .doc(tournamentId)
      .collection(partyTeamsCollection)
      .withConverter(
        fromFirestore: (snapshot, _) => BeerpongTeam.fromJson(
          (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
        ),
        toFirestore: (_, _) =>
            throw UnsupportedError('Beerpong team references are read-only.'),
      );

  CollectionReference<BeerpongMatch> matchesReference(
    String sessionId,
    String tournamentId,
  ) => tournamentsReference(sessionId)
      .doc(tournamentId)
      .collection(partyMatchesCollection)
      .withConverter(
        fromFirestore: (snapshot, _) => BeerpongMatch.fromJson(
          (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
        ),
        toFirestore: (_, _) =>
            throw UnsupportedError('Beerpong match references are read-only.'),
      );

  Stream<List<PartyQuestTemplate>> questTemplatesStream(String sessionId) =>
      _streamList(questTemplatesReference(sessionId).orderBy('title'));

  Stream<List<PartyQuest>> questsStream(String sessionId) => _streamList(
    questsReference(sessionId).orderBy('createdAt', descending: true),
  );

  Stream<PartyQuest?> questStream(String sessionId, String questId) =>
      questsReference(
        sessionId,
      ).doc(questId).snapshots().map((snapshot) => snapshot.data());

  Stream<List<PartyQuestSelection>> questSelectionsStream(
    String sessionId,
    String questId,
  ) => _streamList(questSelectionsReference(sessionId, questId));

  Stream<List<PartyChallenge>> challengesStream(String sessionId) =>
      _streamList(
        challengesReference(sessionId).orderBy('createdAt', descending: true),
      );

  Stream<PartyChallenge?> challengeStream(
    String sessionId,
    String challengeId,
  ) => challengesReference(
    sessionId,
  ).doc(challengeId).snapshots().map((snapshot) => snapshot.data());

  Stream<List<BeerpongTournament>> tournamentsStream(String sessionId) =>
      _streamList(
        tournamentsReference(sessionId).orderBy('createdAt', descending: true),
      );

  Stream<BeerpongTournament?> tournamentStream(
    String sessionId,
    String tournamentId,
  ) => tournamentsReference(
    sessionId,
  ).doc(tournamentId).snapshots().map((snapshot) => snapshot.data());

  Stream<List<BeerpongTeam>> teamsStream(
    String sessionId,
    String tournamentId,
  ) => _streamList(teamsReference(sessionId, tournamentId).orderBy('seed'));

  Stream<List<BeerpongMatch>> matchesStream(
    String sessionId,
    String tournamentId,
  ) => _streamList(
    matchesReference(
      sessionId,
      tournamentId,
    ).orderBy('round').orderBy('position'),
  );

  Future<PartyCommandResult> invokeCommand({
    required String commandName,
    required String sessionId,
    required String commandId,
    Map<String, Object?> data = const {},
  }) => _commandClient.call(
    commandName: commandName,
    sessionId: sessionId,
    commandId: commandId,
    data: data,
  );

  CollectionReference<T> _collection<T>(
    String sessionId,
    String collectionPath,
    T Function(Map<String, dynamic>) fromJson,
  ) => _database
      .collection(partiesCollection)
      .doc(sessionId)
      .collection(collectionPath)
      .withConverter(
        fromFirestore: (snapshot, _) => fromJson(
          (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
        ),
        toFirestore: (_, _) =>
            throw UnsupportedError('Party game references are read-only.'),
      );

  Stream<List<T>> _streamList<T>(Query<T> query) => query.snapshots().map(
    (snapshot) =>
        List<T>.unmodifiable(snapshot.docs.map((document) => document.data())),
  );
}
