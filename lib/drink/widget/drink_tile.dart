import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/widgets.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/routes.dart';

class DrinkTile extends StatelessWidget {
  final ListCustomResultItem drink;

  const DrinkTile({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return DrinkSoftDeleteMutation(
      builder: (context, softDelete, snapshot) => ListTile(
        leading: DrinkIcon(category: drink.drinkCategory.legacyCategory),
        title: Text(drink.name),
        subtitle: Text(
          snapshot.error?.toString() ?? 'ABV: ${drink.alcoholPercentage}%',
          style: snapshot.hasError
              ? TextStyle(color: Theme.of(context).colorScheme.error)
              : null,
        ),
        trailing: Transform.translate(
          offset: const Offset(10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: snapshot.isLoading
                    ? null
                    : () => UpdateDrinkRoute(
                        drinkId: drink.id.value,
                      ).push<void>(context),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: snapshot.isLoading
                    ? null
                    : () => _showDeleteConfirmation(context, softDelete),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    DrinkSoftDeleteMutationExecutor softDelete,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink',
      text: 'Are you sure you want to delete "${drink.name}"?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async => softDelete(id: drink.id).ignore(),
    );
  }
}
