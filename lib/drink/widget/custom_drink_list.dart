import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/convex_api/widgets.dart';
import 'package:remembeer/drink/widget/drink_tile.dart';

class CustomDrinkList extends StatelessWidget {
  const CustomDrinkList({super.key});

  @override
  Widget build(BuildContext context) {
    return DrinkListCustomQuery(
      builder: (context, customDrinks) => _buildList(customDrinks),
    );
  }

  Widget _buildList(List<DrinkDocument> customDrinks) {
    if (customDrinks.isEmpty) {
      return const Center(child: Text('No custom drinks yet.'));
    }

    return ListView.separated(
      separatorBuilder: (_, _) => const Divider(),
      itemCount: customDrinks.length,
      itemBuilder: (context, index) {
        final drink = customDrinks[index];
        return DrinkTile(key: ValueKey(drink.id), drink: drink);
      },
    );
  }
}
