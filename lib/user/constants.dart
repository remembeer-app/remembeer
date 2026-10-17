import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/user/model/accent_color.dart';

const minUsernameLength = 3;
const maxUsernameLength = 20;
const maxBadgesShown = 6;
const profilePageHeading = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const defaultEndOfDayBoundary = TimeOfDay(hour: 6, minute: 0);
const defaultTimeZone = 'UTC';
const searchDebounceDuration = Duration(milliseconds: 500);
const accentColorPalette = <UserDocumentAccentColor, AccentColor>{
  UserDocumentAccentColor.amberValue: AccentColor(
    name: 'Amber',
    color: Color(0xFFF59E0B),
    softColor: Color(0xFFFEF3C7),
    textColor: Color(0xFF78350F),
  ),
  UserDocumentAccentColor.roseValue: AccentColor(
    name: 'Rose',
    color: Color(0xFFE11D48),
    softColor: Color(0xFFFFE4E6),
    textColor: Color(0xFF881337),
  ),
  UserDocumentAccentColor.violetValue: AccentColor(
    name: 'Violet',
    color: Color(0xFF7C3AED),
    softColor: Color(0xFFEDE9FE),
    textColor: Color(0xFF4C1D95),
  ),
  UserDocumentAccentColor.skyValue: AccentColor(
    name: 'Sky',
    color: Color(0xFF0284C7),
    softColor: Color(0xFFE0F2FE),
    textColor: Color(0xFF075985),
  ),
  UserDocumentAccentColor.emeraldValue: AccentColor(
    name: 'Emerald',
    color: Color(0xFF059669),
    softColor: Color(0xFFD1FAE5),
    textColor: Color(0xFF064E3B),
  ),
  UserDocumentAccentColor.limeValue: AccentColor(
    name: 'Lime',
    color: Color(0xFF65A30D),
    softColor: Color(0xFFECFCCB),
    textColor: Color(0xFF365314),
  ),
  UserDocumentAccentColor.orangeValue: AccentColor(
    name: 'Orange',
    color: Color(0xFFEA580C),
    softColor: Color(0xFFFFEDD5),
    textColor: Color(0xFF7C2D12),
  ),
  UserDocumentAccentColor.fuchsiaValue: AccentColor(
    name: 'Fuchsia',
    color: Color(0xFFC026D3),
    softColor: Color(0xFFFAE8FF),
    textColor: Color(0xFF701A75),
  ),
};

// TODO(ohtenkay): Load other users' friend counts from a public Convex query.
const unavailableProfileFriendCount = 0;
