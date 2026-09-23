import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/types.dart' as convex;
import 'package:remembeer/drink/model/drink_category.dart' as app;
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkTile extends StatelessWidget {
  final ListCustomResultItem drink;

  DrinkTile({super.key, required this.drink});

  final _convexApi = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DrinkIcon(category: _appCategory(drink.drinkCategory)),
      title: Text(drink.name),
      subtitle: Text('ABV: ${drink.alcoholPercentage}%'),
      trailing: Transform.translate(
        offset: const Offset(10, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                  UpdateDrinkRoute(drinkId: drink.id.value).push<void>(context),
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

  app.DrinkCategory _appCategory(convex.DrinkCategory category) {
    return switch (category) {
      convex.Beer() => app.DrinkCategory.beer,
      convex.Cider() => app.DrinkCategory.cider,
      convex.Cocktail() => app.DrinkCategory.cocktail,
      convex.Spirit() => app.DrinkCategory.spirit,
      convex.Wine() => app.DrinkCategory.wine,
    };
  }

  void _showDeleteConfirmation(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink',
      text: 'Are you sure you want to delete "${drink.name}"?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async => _convexApi.drink.softDelete(id: drink.id),
    );
  }
}
