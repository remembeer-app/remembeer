// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import './runtime.dart';
import './schema.dart';

typedef BadgeDocument = ({
  UserId userId,
  String badgeKey,
  double unlockedAt,
  bool isShown,
  BadgeId id,
  double creationTime,
});

sealed class DrinkCategory {
  const DrinkCategory();
  bool get isBeer => this is Beer;
  bool get isCider => this is Cider;
  bool get isCocktail => this is Cocktail;
  bool get isSpirit => this is Spirit;
  bool get isWine => this is Wine;
}

final class Beer extends DrinkCategory {
  const Beer();
}

final class Cider extends DrinkCategory {
  const Cider();
}

final class Cocktail extends DrinkCategory {
  const Cocktail();
}

final class Spirit extends DrinkCategory {
  const Spirit();
}

final class Wine extends DrinkCategory {
  const Wine();
}

typedef DrinkDocument = ({
  UserId? ownerId,
  Optional<String> seedKey,
  String name,
  DrinkCategory drinkCategory,
  double alcoholPercentage,
  double updatedAt,
  double? deletedAt,
  DrinkId id,
  double creationTime,
});

typedef DrinkLogDocumentLocation = ({
  double latitude,
  double longitude,
  double? accuracy,
});

typedef DrinkLogDocument = ({
  UserId userId,
  SessionId? sessionId,
  DrinkId drinkId,
  double consumedAt,
  double volumeMl,
  DrinkLogDocumentLocation? location,
  double updatedAt,
  double? deletedAt,
  DrinkLogId id,
  double creationTime,
});

sealed class SessionDocument {
  const SessionDocument();
  UserId get ownerId;
  String get name;
  String get description;
  double get startedAt;
  double? get endedAt;
  double get updatedAt;
  double? get deletedAt;
  SessionId get id;
  double get creationTime;
  bool get isSession => this is Session;
  bool get isParty => this is Party;
}

final class Session extends SessionDocument {
  const Session({
    required this.ownerId,
    required this.name,
    required this.description,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.id,
    required this.creationTime,
  });

  final UserId ownerId;

  final String name;

  final String description;

  final double startedAt;

  final double? endedAt;

  final double updatedAt;

  final double? deletedAt;

  final SessionId id;

  final double creationTime;
}

final class Party extends SessionDocument {
  const Party({
    required this.ownerId,
    required this.name,
    required this.description,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.id,
    required this.creationTime,
  });

  final UserId ownerId;

  final String name;

  final String description;

  final double startedAt;

  final double? endedAt;

  final double updatedAt;

  final double? deletedAt;

  final SessionId id;

  final double creationTime;
}

sealed class SessionMemberStatus {
  const SessionMemberStatus();
  bool get isInvited => this is Invited;
  bool get isJoined => this is Joined;
  bool get isLeft => this is Left;
  bool get isBanned => this is Banned;
  bool get isDeclined => this is Declined;
}

final class Invited extends SessionMemberStatus {
  const Invited();
}

final class Joined extends SessionMemberStatus {
  const Joined();
}

final class Left extends SessionMemberStatus {
  const Left();
}

final class Banned extends SessionMemberStatus {
  const Banned();
}

final class Declined extends SessionMemberStatus {
  const Declined();
}

sealed class SessionMemberRole {
  const SessionMemberRole();
  bool get isMember => this is Member;
  bool get isAdmin => this is Admin;
}

final class Member extends SessionMemberRole {
  const Member();
}

final class Admin extends SessionMemberRole {
  const Admin();
}

typedef SessionMemberDocument = ({
  SessionId sessionId,
  UserId userId,
  SessionMemberStatus sessionMemberStatus,
  SessionMemberRole sessionMemberRole,
  double updatedAt,
  double? sessionEndedAt,
  double? sessionDeletedAt,
  SessionMemberId id,
  double creationTime,
});

enum UserDocumentAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const UserDocumentAccentColor(this.value);
  final Object? value;

  static UserDocumentAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return UserDocumentAccentColor.amberValue;
      case 'rose':
        return UserDocumentAccentColor.roseValue;
      case 'violet':
        return UserDocumentAccentColor.violetValue;
      case 'sky':
        return UserDocumentAccentColor.skyValue;
      case 'emerald':
        return UserDocumentAccentColor.emeraldValue;
      case 'lime':
        return UserDocumentAccentColor.limeValue;
      case 'orange':
        return UserDocumentAccentColor.orangeValue;
      case 'fuchsia':
        return UserDocumentAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for UserDocumentAccentColor',
        );
    }
  }
}

enum UserDocumentDrinkLogSortOrder {
  ascValue('asc'),
  descValue('desc');

  const UserDocumentDrinkLogSortOrder(this.value);
  final Object? value;

  static UserDocumentDrinkLogSortOrder fromJson(dynamic raw) {
    switch (raw) {
      case 'asc':
        return UserDocumentDrinkLogSortOrder.ascValue;
      case 'desc':
        return UserDocumentDrinkLogSortOrder.descValue;
      default:
        throw FormatException(
          'Expected one of asc, desc for UserDocumentDrinkLogSortOrder',
        );
    }
  }
}

typedef UserDocument = ({
  String authUserId,
  String username,
  String normalizedUsername,
  UserDocumentAccentColor accentColor,
  Optional<StorageId?> avatarStorageId,
  double endOfDayBoundary,
  String timeZone,
  DrinkId? defaultDrink,
  UserDocumentDrinkLogSortOrder drinkLogSortOrder,
  UserId id,
  double creationTime,
});
