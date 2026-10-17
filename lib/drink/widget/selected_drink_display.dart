import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/types.dart';

class SelectedDrinkDisplay extends StatelessWidget {
  final DrinkDocument drink;

  const SelectedDrinkDisplay({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DrinkIcon(category: drink.drinkCategory, size: 24),
        const Gap(12),
        Expanded(
          child: Text(
            drink.name,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
