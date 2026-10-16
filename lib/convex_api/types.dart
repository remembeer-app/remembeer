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

enum FriendshipDocumentStatus {
  pendingValue('pending'),
  acceptedValue('accepted');

  const FriendshipDocumentStatus(this.value);
  final Object? value;

  static FriendshipDocumentStatus fromJson(dynamic raw) {
    switch (raw) {
      case 'pending':
        return FriendshipDocumentStatus.pendingValue;
      case 'accepted':
        return FriendshipDocumentStatus.acceptedValue;
      default:
        throw FormatException(
          'Expected one of pending, accepted for FriendshipDocumentStatus',
        );
    }
  }
}

typedef FriendshipDocument = ({
  UserId userAId,
  UserId userBId,
  UserId requestedById,
  FriendshipDocumentStatus status,
  double updatedAt,
  FriendshipId id,
  double creationTime,
});

typedef LeaderboardDocument = ({
  UserId ownerId,
  String name,
  String iconName,
  String inviteCode,
  String timeZone,
  double endOfDayBoundary,
  double updatedAt,
  double? deletedAt,
  LeaderboardId id,
  double creationTime,
});

enum LeaderboardMemberDocumentStatus {
  joinedValue('joined'),
  bannedValue('banned');

  const LeaderboardMemberDocumentStatus(this.value);
  final Object? value;

  static LeaderboardMemberDocumentStatus fromJson(dynamic raw) {
    switch (raw) {
      case 'joined':
        return LeaderboardMemberDocumentStatus.joinedValue;
      case 'banned':
        return LeaderboardMemberDocumentStatus.bannedValue;
      default:
        throw FormatException(
          'Expected one of joined, banned for LeaderboardMemberDocumentStatus',
        );
    }
  }
}

typedef LeaderboardMemberDocument = ({
  LeaderboardId leaderboardId,
  UserId userId,
  LeaderboardMemberDocumentStatus status,
  double updatedAt,
  LeaderboardMemberId id,
  double creationTime,
});

enum PartyQuestDocumentStatus {
  activeValue('active'),
  expiredValue('expired'),
  cancelledValue('cancelled');

  const PartyQuestDocumentStatus(this.value);
  final Object? value;

  static PartyQuestDocumentStatus fromJson(dynamic raw) {
    switch (raw) {
      case 'active':
        return PartyQuestDocumentStatus.activeValue;
      case 'expired':
        return PartyQuestDocumentStatus.expiredValue;
      case 'cancelled':
        return PartyQuestDocumentStatus.cancelledValue;
      default:
        throw FormatException(
          'Expected one of active, expired, cancelled for PartyQuestDocumentStatus',
        );
    }
  }
}

typedef PartyQuestDocumentSelectionsItem = ({
  UserId userId,
  UserId selectedUserId,
  double selectedAt,
});

typedef PartyQuestDocumentResultsItem = ({
  UserId firstUserId,
  UserId secondUserId,
  double completedAt,
});

sealed class PartyQuestDocument {
  const PartyQuestDocument();
  SessionId get sessionId;
  String get title;
  String get instructions;
  double get pointsUnits;
  double get startsAt;
  double get endsAt;
  PartyQuestDocumentStatus get status;
  List<PartyQuestDocumentSelectionsItem> get selections;
  List<PartyQuestDocumentResultsItem> get results;
  double get updatedAt;
  PartyQuestId get id;
  double get creationTime;
  bool get isToastWithClass => this is ToastWithClass;
  bool get isSameAccent => this is SameAccent;
  bool get isDifferentAccent => this is DifferentAccent;
  bool get isNewAlly => this is NewAlly;
  bool get isSameClass => this is SameClass;
  bool get isDifferentClass => this is DifferentClass;
  bool get isBottomQuarter => this is BottomQuarter;
  bool get isLeader => this is Leader;
  bool get isTopThree => this is TopThree;
  bool get isOppositeRankingHalves => this is OppositeRankingHalves;
  bool get isNearbyRank => this is NearbyRank;
  bool get isDifferentBeerpongTeam => this is DifferentBeerpongTeam;
  bool get isSameBeerpongTeam => this is SameBeerpongTeam;
  bool get isFinalistTeam => this is FinalistTeam;
}

final class ToastWithClass extends PartyQuestDocument {
  const ToastWithClass({
    required this.drinkCategory,
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final DrinkCategory drinkCategory;

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class SameAccent extends PartyQuestDocument {
  const SameAccent({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class DifferentAccent extends PartyQuestDocument {
  const DifferentAccent({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class NewAlly extends PartyQuestDocument {
  const NewAlly({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class SameClass extends PartyQuestDocument {
  const SameClass({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class DifferentClass extends PartyQuestDocument {
  const DifferentClass({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class BottomQuarter extends PartyQuestDocument {
  const BottomQuarter({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class Leader extends PartyQuestDocument {
  const Leader({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class TopThree extends PartyQuestDocument {
  const TopThree({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class OppositeRankingHalves extends PartyQuestDocument {
  const OppositeRankingHalves({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class NearbyRank extends PartyQuestDocument {
  const NearbyRank({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class DifferentBeerpongTeam extends PartyQuestDocument {
  const DifferentBeerpongTeam({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class SameBeerpongTeam extends PartyQuestDocument {
  const SameBeerpongTeam({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

final class FinalistTeam extends PartyQuestDocument {
  const FinalistTeam({
    required this.sessionId,
    required this.title,
    required this.instructions,
    required this.pointsUnits,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.selections,
    required this.results,
    required this.updatedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final String title;

  final String instructions;

  final double pointsUnits;

  final double startsAt;

  final double endsAt;

  final PartyQuestDocumentStatus status;

  final List<PartyQuestDocumentSelectionsItem> selections;

  final List<PartyQuestDocumentResultsItem> results;

  final double updatedAt;

  final PartyQuestId id;

  final double creationTime;
}

typedef PartyModules = ({
  bool socialQuestsEnabled,
  bool adminChallengesEnabled,
  bool beerpongEnabled,
});

typedef PartyQuestSchedule = ({
  double minIntervalMinutes,
  double maxIntervalMinutes,
  double defaultDurationMinutes,
  double? nextQuestAt,
  ScheduledFunctionsId? scheduledFunctionId,
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
    required this.activatedAt,
    required this.activatedByUserId,
    required this.modules,
    required this.questSchedule,
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

  final double activatedAt;

  final UserId activatedByUserId;

  final PartyModules modules;

  final PartyQuestSchedule questSchedule;

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

sealed class SessionMemberDocument {
  const SessionMemberDocument();
  SessionId get sessionId;
  UserId get userId;
  SessionMemberStatus get sessionMemberStatus;
  SessionMemberRole get sessionMemberRole;
  double get updatedAt;
  double? get sessionEndedAt;
  double? get sessionDeletedAt;
  SessionMemberId get id;
  double get creationTime;
  bool get isSessionMember => this is SessionMember;
  bool get isPartyMember => this is PartyMember;
}

final class SessionMember extends SessionMemberDocument {
  const SessionMember({
    required this.sessionId,
    required this.userId,
    required this.sessionMemberStatus,
    required this.sessionMemberRole,
    required this.updatedAt,
    required this.sessionEndedAt,
    required this.sessionDeletedAt,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final UserId userId;

  final SessionMemberStatus sessionMemberStatus;

  final SessionMemberRole sessionMemberRole;

  final double updatedAt;

  final double? sessionEndedAt;

  final double? sessionDeletedAt;

  final SessionMemberId id;

  final double creationTime;
}

final class PartyMember extends SessionMemberDocument {
  const PartyMember({
    required this.sessionId,
    required this.userId,
    required this.sessionMemberStatus,
    required this.sessionMemberRole,
    required this.updatedAt,
    required this.sessionEndedAt,
    required this.sessionDeletedAt,
    required this.selectedClass,
    required this.classChangedAt,
    required this.beerpongOptIn,
    required this.id,
    required this.creationTime,
  });

  final SessionId sessionId;

  final UserId userId;

  final SessionMemberStatus sessionMemberStatus;

  final SessionMemberRole sessionMemberRole;

  final double updatedAt;

  final double? sessionEndedAt;

  final double? sessionDeletedAt;

  final DrinkCategory? selectedClass;

  final double? classChangedAt;

  final bool beerpongOptIn;

  final SessionMemberId id;

  final double creationTime;
}

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
