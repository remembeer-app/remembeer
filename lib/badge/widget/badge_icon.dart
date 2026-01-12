import 'package:flutter/material.dart';
import 'package:remembeer/badge/type/badge_definition.dart';

class BadgeIcon extends StatelessWidget {
  final BadgeDefinition badgeDefinition;
  final double size;
  final double padding;

  const BadgeIcon({
    super.key,
    required this.badgeDefinition,
    required this.size,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber.shade100,
        border: Border.all(color: Colors.amber.shade700, width: 2),
      ),
      child: Image.asset(badgeDefinition.iconPath, fit: BoxFit.contain),
    );
  }
}
