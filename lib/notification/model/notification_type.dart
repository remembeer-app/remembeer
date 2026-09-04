enum NotificationType {
  addedToSession('added_to_session'),
  friendRequestAccepted('friend_request_accepted'),
  friendRequestReceived('friend_request_received'),
  partyActivated('party_activated'),
  partyQuestStarted('party_quest_started'),
  partyQuestCompleted('party_quest_completed'),
  partyChallengeStarted('party_challenge_started'),
  partyChallengeWinner('party_challenge_winner'),
  partyBeerpongEnrollment('party_beerpong_enrollment'),
  partyBeerpongMatchReady('party_beerpong_match_ready'),
  partyBeerpongMatchResult('party_beerpong_match_result'),
  partyBeerpongCompleted('party_beerpong_completed'),
  partyArchived('party_archived');

  final String type;

  const NotificationType(this.type);

  static NotificationType? fromString(String? value) {
    if (value == null) return null;

    for (final type in NotificationType.values) {
      if (type.type == value) {
        return type;
      }
    }
    return null;
  }

  bool get isParty => switch (this) {
    NotificationType.addedToSession ||
    NotificationType.friendRequestAccepted ||
    NotificationType.friendRequestReceived => false,
    _ => true,
  };
}
