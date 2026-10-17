import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';

class DrinkIcon extends StatelessWidget {
  final DrinkCategory category;
  final Color? color;
  final double size;

  const DrinkIcon({
    super.key,
    required this.category,
    this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final iconPath = category.iconPath;
    final defaultColor = category.defaultColor;

    final color = this.color ?? defaultColor;

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
