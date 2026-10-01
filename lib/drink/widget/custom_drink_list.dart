import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/widgets.dart';
import 'package:remembeer/drink/widget/drink_tile.dart';

class CustomDrinkList extends StatelessWidget {
  const CustomDrinkList({super.key});

  @override
  Widget build(BuildContext context) {
    return DrinkListCustomQuery(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildList(snapshot.data!);
      },
    );
  }

  Widget _buildList(List<ListCustomResultItem> customDrinks) {
    if (customDrinks.isEmpty) {
      return const Center(child: Text('No custom drinks yet.'));
    }

    return ListView.separated(
      separatorBuilder: (_, _) => const Divider(),
      itemCount: customDrinks.length,
      itemBuilder: (context, index) {
        return DrinkTile(drink: customDrinks[index]);
      },
    );
  }
}
