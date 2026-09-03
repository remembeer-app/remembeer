import 'package:flutter/material.dart';
import 'package:remembeer/user/model/accent_color.dart';

const minUsernameLength = 3;
const maxUsernameLength = 20;
const maxBadgesShown = 6;
const profilePageHeading = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const globalUserId = 'global';
const defaultEndOfDayBoundary = TimeOfDay(hour: 6, minute: 0);
const searchDebounceDuration = Duration(milliseconds: 500);
const accentColorPalette = <AccentColorKey, AccentColor>{
  AccentColorKey.amber: AccentColor(
    key: AccentColorKey.amber,
    name: 'Amber',
    color: Color(0xFFF59E0B),
    softColor: Color(0xFFFEF3C7),
    textColor: Color(0xFF78350F),
  ),
  AccentColorKey.rose: AccentColor(
    key: AccentColorKey.rose,
    name: 'Rose',
    color: Color(0xFFE11D48),
    softColor: Color(0xFFFFE4E6),
    textColor: Color(0xFF881337),
  ),
  AccentColorKey.violet: AccentColor(
    key: AccentColorKey.violet,
    name: 'Violet',
    color: Color(0xFF7C3AED),
    softColor: Color(0xFFEDE9FE),
    textColor: Color(0xFF4C1D95),
  ),
  AccentColorKey.sky: AccentColor(
    key: AccentColorKey.sky,
    name: 'Sky',
    color: Color(0xFF0284C7),
    softColor: Color(0xFFE0F2FE),
    textColor: Color(0xFF075985),
  ),
  AccentColorKey.emerald: AccentColor(
    key: AccentColorKey.emerald,
    name: 'Emerald',
    color: Color(0xFF059669),
    softColor: Color(0xFFD1FAE5),
    textColor: Color(0xFF064E3B),
  ),
  AccentColorKey.lime: AccentColor(
    key: AccentColorKey.lime,
    name: 'Lime',
    color: Color(0xFF65A30D),
    softColor: Color(0xFFECFCCB),
    textColor: Color(0xFF365314),
  ),
  AccentColorKey.orange: AccentColor(
    key: AccentColorKey.orange,
    name: 'Orange',
    color: Color(0xFFEA580C),
    softColor: Color(0xFFFFEDD5),
    textColor: Color(0xFF7C2D12),
  ),
  AccentColorKey.fuchsia: AccentColor(
    key: AccentColorKey.fuchsia,
    name: 'Fuchsia',
    color: Color(0xFFC026D3),
    softColor: Color(0xFFFAE8FF),
    textColor: Color(0xFF701A75),
  ),
};

AccentColorKey defaultAccentColorFor(String stableSeed) {
  var hash = 0;
  for (final codeUnit in stableSeed.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0xFFFFFFFF;
  }

  return AccentColorKey.values[hash % AccentColorKey.values.length];
}
