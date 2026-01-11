enum NotificationType {
  friendRequest('friend_request');

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
