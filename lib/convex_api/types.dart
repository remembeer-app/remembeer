// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import './runtime.dart';
import './schema.dart';

sealed class DrinkCategory {
  const DrinkCategory();
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

sealed class SessionMemberRole {
  const SessionMemberRole();
}

final class Member extends SessionMemberRole {
  const Member();
}

final class Admin extends SessionMemberRole {
  const Admin();
}

sealed class SessionMemberStatus {
  const SessionMemberStatus();
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
