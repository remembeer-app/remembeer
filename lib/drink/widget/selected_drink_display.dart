import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';

class SelectedDrinkDisplay extends StatelessWidget {
  final DrinkSnapshot drink;

  const SelectedDrinkDisplay({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DrinkIcon(category: drink.category, size: 24),
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
