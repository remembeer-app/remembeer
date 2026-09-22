import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinks.dart';
import 'package:remembeer/convex_api/types.dart' as convex;
import 'package:remembeer/drink_type/model/drink_category.dart' as legacy;
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkTypeTile extends StatelessWidget {
  final ListCustomResultItem drink;

  DrinkTypeTile({super.key, required this.drink});

  final _convexApi = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DrinkIcon(category: _legacyCategory(drink.drinkCategory)),
      title: Text(drink.name),
      subtitle: Text('ABV: ${drink.alcoholPercentage}%'),
      trailing: Transform.translate(
        offset: const Offset(10, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => UpdateDrinkTypeRoute(
                drinkTypeId: drink.id.value,
              ).push<void>(context),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  legacy.DrinkCategory _legacyCategory(convex.DrinkCategory drinkCategory) {
    return switch (drinkCategory) {
      convex.Beer() => legacy.DrinkCategory.beer,
      convex.Cider() => legacy.DrinkCategory.cider,
      convex.Cocktail() => legacy.DrinkCategory.cocktail,
      convex.Spirit() => legacy.DrinkCategory.spirit,
      convex.Wine() => legacy.DrinkCategory.wine,
    };
  }

  void _showDeleteConfirmation(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink Type',
      text: 'Are you sure you want to delete "${drink.name}"?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async => _convexApi.drinks.softDelete(id: drink.id),
    );
  }
}
