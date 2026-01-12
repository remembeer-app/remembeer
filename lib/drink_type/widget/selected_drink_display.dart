import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';

class SelectedDrinkDisplay extends StatelessWidget {
  final DrinkTypeCore drinkType;

  const SelectedDrinkDisplay({super.key, required this.drinkType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DrinkIcon(category: drinkType.category, size: 24),
        hGap12,
        Expanded(
          child: Text(
            drinkType.name,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
