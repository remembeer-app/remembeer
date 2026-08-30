import 'package:flutter/material.dart';

enum AccentColorKey { amber, rose, violet, sky, emerald, lime, orange, fuchsia }

class AccentColor {
  final AccentColorKey key;
  final String name;
  final Color color;
  final Color softColor;
  final Color textColor;

  const AccentColor({
    required this.key,
    required this.name,
    required this.color,
    required this.softColor,
    required this.textColor,
  });
}
