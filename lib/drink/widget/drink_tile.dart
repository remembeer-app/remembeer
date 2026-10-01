import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkTile extends StatelessWidget {
  final ListCustomResultItem drink;

  DrinkTile({super.key, required this.drink});

  final _convexApi = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DrinkIcon(category: drink.drinkCategory.legacyCategory),
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
