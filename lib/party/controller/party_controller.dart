import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';

class PartyController {
  PartyController({
    FirebaseFirestore? firestore,
    PartyCommandClient? commandClient,
  }) : _firestore = firestore,
       _commandClient = commandClient ?? PartyCommandClient();

  final FirebaseFirestore? _firestore;
  final PartyCommandClient _commandClient;

  FirebaseFirestore get _database => _firestore ?? FirebaseFirestore.instance;

  DocumentReference<Party> partyReference(String sessionId) => _database
      .collection(partiesCollection)
      .doc(sessionId)
      .withConverter(
        fromFirestore: (snapshot, _) => Party.fromJson(
          (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
        ),
        toFirestore: (_, _) =>
            throw UnsupportedError('Party references are read-only.'),
      );

  CollectionReference<PartyMember> membersReference(String sessionId) =>
      _database
          .collection(partiesCollection)
          .doc(sessionId)
          .collection(partyMembersCollection)
          .withConverter(
            fromFirestore: (snapshot, _) => PartyMember.fromJson(
              (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
            ),
            toFirestore: (_, _) => throw UnsupportedError(
              'Party member references are read-only.',
            ),
          );

  DocumentReference<PartyMember> memberReference(
    String sessionId,
    String userId,
  ) => membersReference(sessionId).doc(userId);

  Stream<Party> partyStream(String sessionId) =>
      partyReference(sessionId).snapshots().map((snapshot) {
        final party =
            snapshot.data() ??
            never('Party with session id $sessionId not found.');
        return party;
      });

  Stream<List<PartyMember>> membersStream(String sessionId) =>
      membersReference(sessionId)
          .orderBy('scoreUnits', descending: true)
          .orderBy('userId')
          .snapshots()
          .map(
            (snapshot) => List<PartyMember>.unmodifiable(
              snapshot.docs.map((document) => document.data()),
            ),
          );

  Stream<PartyMember?> memberStream(String sessionId, String userId) =>
      memberReference(
        sessionId,
        userId,
      ).snapshots().map((snapshot) => snapshot.data());

  String generateCommandId() =>
      _database.collection(partiesCollection).doc().id;

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

  Future<PartyCommandResult> activateParty({
    required String sessionId,
    required String commandId,
  }) => invokeCommand(
    commandName: 'activate_party',
    sessionId: sessionId,
    commandId: commandId,
  );

  Future<PartyCommandResult> syncMembership({
    required String sessionId,
    required String commandId,
    required String action,
    required String memberId,
  }) => invokeCommand(
    commandName: 'sync_party_membership',
    sessionId: sessionId,
    commandId: commandId,
    data: {'action': action, 'memberId': memberId},
  );

  Future<PartyCommandResult> setModuleSettings({
    required String sessionId,
    required String commandId,
    required PartyModuleSettings settings,
  }) => invokeCommand(
    commandName: 'set_party_module_settings',
    sessionId: sessionId,
    commandId: commandId,
    data: {'moduleSettings': settings.toJson()},
  );

  Future<PartyCommandResult> setQuestSchedule({
    required String sessionId,
    required String commandId,
    required PartyQuestSchedule schedule,
  }) => invokeCommand(
    commandName: 'set_party_quest_schedule',
    sessionId: sessionId,
    commandId: commandId,
    data: {'questSchedule': schedule.toJson()},
  );

  Future<PartyCommandResult> selectPartyClass({
    required String sessionId,
    required String commandId,
    required DrinkCategory selectedClass,
  }) => invokeCommand(
    commandName: 'select_party_class',
    sessionId: sessionId,
    commandId: commandId,
    data: {'selectedClass': selectedClass.name},
  );

  Future<PartyCommandResult> setPartyMemberClass({
    required String sessionId,
    required String commandId,
    required String memberId,
    required DrinkCategory selectedClass,
  }) => invokeCommand(
    commandName: 'set_party_member_class',
    sessionId: sessionId,
    commandId: commandId,
    data: {'memberId': memberId, 'selectedClass': selectedClass.name},
  );

  Future<PartyCommandResult> setBeerpongOptIn({
    required String sessionId,
    required String commandId,
    required String tournamentId,
    required int expectedRevision,
    required bool optedIn,
  }) => invokeCommand(
    commandName: 'set_beerpong_opt_in',
    sessionId: sessionId,
    commandId: commandId,
    data: {
      'tournamentId': tournamentId,
      'expectedRevision': expectedRevision,
      'optedIn': optedIn,
    },
  );

  Future<PartyCommandResult> createPartyDrink({
    required String sessionId,
    required String commandId,
    required String drinkTypeId,
    required Drink drink,
  }) => invokeCommand(
    commandName: 'create_party_drink',
    sessionId: sessionId,
    commandId: commandId,
    data: _drinkData(drinkTypeId: drinkTypeId, drink: drink),
  );

  Future<PartyCommandResult> updatePartyDrink({
    required String sessionId,
    required String commandId,
    required String drinkTypeId,
    required Drink drink,
  }) => invokeCommand(
    commandName: 'update_party_drink',
    sessionId: sessionId,
    commandId: commandId,
    data: _drinkData(drinkTypeId: drinkTypeId, drink: drink),
  );

  Future<PartyCommandResult> deletePartyDrink({
    required String sessionId,
    required String commandId,
    required String drinkId,
  }) => invokeCommand(
    commandName: 'delete_party_drink',
    sessionId: sessionId,
    commandId: commandId,
    data: {'drinkId': drinkId},
  );

  Future<PartyCommandResult> archiveParty({
    required String sessionId,
    required String commandId,
    required DateTime endedAt,
  }) => invokeCommand(
    commandName: 'archive_party',
    sessionId: sessionId,
    commandId: commandId,
    data: {'endedAt': endedAt.toIso8601String()},
  );

  Map<String, Object?> _drinkData({
    required String drinkTypeId,
    required Drink drink,
  }) => {
    'drinkId': drink.id,
    'drinkTypeId': drinkTypeId,
    'consumedAt': drink.consumedAt.toUtc().toIso8601String(),
    'volumeInMilliliters': drink.volumeInMilliliters,
    'location': switch (drink.location) {
      final location? => {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      null => null,
    },
  };
}
