import 'dart:collection';
import 'dart:convert';

import 'package:remembeer/notification/model/notification_type.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/routes.dart';

class PartyNotificationPayload {
  const PartyNotificationPayload({
    required this.type,
    required this.sessionId,
    required this.tab,
    this.sourceId,
  });

  final NotificationType type;
  final String sessionId;
  final PartyTab tab;
  final String? sourceId;

  static PartyNotificationPayload? fromData(Map<String, dynamic> data) {
    final typeValue = data['type'];
    final sessionId = data['sessionId'];
    final tabValue = data['tab'];
    final sourceId = data['sourceId'];
    if (typeValue is! String ||
        sessionId is! String ||
        sessionId.isEmpty ||
        tabValue is! String ||
        (sourceId != null && (sourceId is! String || sourceId.isEmpty))) {
      return null;
    }

    final type = NotificationType.fromString(typeValue);
    final tab = PartyTab.tryFromString(tabValue);
    if (type == null || !type.isParty || tab == null) {
      return null;
    }
    final requiresSource = switch (type) {
      NotificationType.partyActivated ||
      NotificationType.partyArchived => false,
      _ => true,
    };
    if (requiresSource && sourceId == null) {
      return null;
    }
    return PartyNotificationPayload(
      type: type,
      sessionId: sessionId,
      tab: tab,
      sourceId: sourceId as String?,
    );
  }

  String get location => switch (type) {
    NotificationType.partyActivated || NotificationType.partyArchived =>
      PartyRoute(sessionId: sessionId, tab: tab).location,
    NotificationType.partyQuestStarted ||
    NotificationType.partyQuestCompleted => PartyQuestRoute(
      sessionId: sessionId,
      questId: sourceId!,
      tab: tab,
    ).location,
    NotificationType.partyChallengeStarted ||
    NotificationType.partyChallengeWinner => PartyChallengeRoute(
      sessionId: sessionId,
      challengeId: sourceId!,
      tab: tab,
    ).location,
    NotificationType.partyBeerpongEnrollment ||
    NotificationType.partyBeerpongMatchReady ||
    NotificationType.partyBeerpongMatchResult ||
    NotificationType.partyBeerpongCompleted => PartyTournamentRoute(
      sessionId: sessionId,
      tournamentId: sourceId!,
      tab: tab,
    ).location,
    _ => throw StateError('Not a Party notification.'),
  };
}

class PartyNotificationRouter {
  PartyNotificationRouter(this._navigate);

  final void Function(String location) _navigate;
  final _handledMessages = <String>{};

  bool handle(Map<String, dynamic> data, {String? messageId}) {
    final payload = PartyNotificationPayload.fromData(data);
    if (payload == null) return false;

    final key =
        messageId ?? jsonEncode(SplayTreeMap<String, dynamic>.from(data));
    if (_handledMessages.add(key)) {
      _navigate(payload.location);
    }
    return true;
  }
}
