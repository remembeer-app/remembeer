import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/model/party_event_page.dart';

class PartyEventController {
  PartyEventController({
    FirebaseFirestore? firestore,
    PartyCommandClient? commandClient,
  }) : _firestore = firestore,
       _commandClient = commandClient ?? PartyCommandClient();

  final FirebaseFirestore? _firestore;
  final PartyCommandClient _commandClient;

  FirebaseFirestore get _database => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<PartyEvent> eventsReference(String sessionId) => _database
      .collection(partiesCollection)
      .doc(sessionId)
      .collection(partyEventsCollection)
      .withConverter(
        fromFirestore: (snapshot, _) => PartyEvent.fromJson(
          (snapshot.data() ?? <String, dynamic>{}).withId(snapshot.id),
        ),
        toFirestore: (_, _) =>
            throw UnsupportedError('Party event references are read-only.'),
      );

  Query<PartyEvent> eventsQuery({
    required String sessionId,
    Set<PartyEventKind> kinds = const {},
    Set<String> participantIds = const {},
  }) {
    if (participantIds.length > partyEventParticipantFilterLimit) {
      throw ArgumentError.value(
        participantIds,
        'participantIds',
        'Firestore supports at most $partyEventParticipantFilterLimit values.',
      );
    }
    Query<PartyEvent> query = eventsReference(
      sessionId,
    ).orderBy('occurredAt', descending: true);
    if (kinds.length == 1) {
      query = query.where('kind', isEqualTo: kinds.single.name);
    } else if (kinds.length > 1) {
      query = query.where(
        'kind',
        whereIn: kinds.map((kind) => kind.name).toList(),
      );
    }
    if (participantIds.length == 1) {
      query = query.where(
        'participantIds',
        arrayContains: participantIds.single,
      );
    } else if (participantIds.length > 1) {
      query = query.where(
        'participantIds',
        arrayContainsAny: participantIds.toList(),
      );
    }
    return query;
  }

  Stream<List<PartyEvent>> eventsStream({
    required String sessionId,
    Set<PartyEventKind> kinds = const {},
    Set<String> participantIds = const {},
    int limit = partyEventPageSize,
  }) =>
      eventsQuery(
            sessionId: sessionId,
            kinds: kinds,
            participantIds: participantIds,
          )
          .limit(limit)
          .snapshots()
          .map(
            (snapshot) => List<PartyEvent>.unmodifiable(
              snapshot.docs.map((document) => document.data()),
            ),
          );

  Future<PartyEventPage> fetchEventPage({
    required String sessionId,
    Set<PartyEventKind> kinds = const {},
    Set<String> participantIds = const {},
    DocumentSnapshot<PartyEvent>? startAfter,
    int pageSize = partyEventPageSize,
  }) async {
    var query = eventsQuery(
      sessionId: sessionId,
      kinds: kinds,
      participantIds: participantIds,
    );
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.limit(pageSize + 1).get();
    final hasMore = snapshot.docs.length > pageSize;
    final pageDocuments = snapshot.docs.take(pageSize).toList();
    return PartyEventPage(
      events: List<PartyEvent>.unmodifiable(
        pageDocuments.map((document) => document.data()),
      ),
      cursor: pageDocuments.lastOrNull,
      hasMore: hasMore,
    );
  }

  Future<PartyCommandResult> reversePartyEvent({
    required String sessionId,
    required String commandId,
    required String eventId,
  }) => _commandClient.call(
    commandName: 'reverse_party_event',
    sessionId: sessionId,
    commandId: commandId,
    data: {'eventId': eventId},
  );
}
