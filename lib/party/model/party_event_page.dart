import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/party/model/party_event.dart';

class PartyEventPage {
  const PartyEventPage({
    required this.events,
    required this.hasMore,
    this.cursor,
  });

  final List<PartyEvent> events;
  final bool hasMore;
  final DocumentSnapshot<PartyEvent>? cursor;
}
