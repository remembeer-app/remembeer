enum NotificationType {
  addedToSession('added_to_session'),
  friendRequestAccepted('friend_request_accepted'),
  friendRequestReceived('friend_request_received');

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
}
