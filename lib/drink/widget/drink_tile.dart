import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/convex_api/widgets.dart';
import 'package:remembeer/routes.dart';

class DrinkTile extends StatelessWidget {
  final DrinkDocument drink;

  const DrinkTile({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return DrinkSoftDeleteMutation(
      optimisticUpdate: _optimisticDeleteDrink,
      builder: (context, softDelete, _) => ListTile(
        leading: DrinkIcon(category: drink.drinkCategory),
        title: Text(drink.name),
        subtitle: Text('ABV: ${drink.alcoholPercentage}%'),
        trailing: Transform.translate(
          offset: const Offset(10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => UpdateDrinkRoute(
                  drinkId: drink.id.value,
                ).push<void>(context),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context, softDelete),
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
      onPressed: () async {
        try {
          await softDelete(id: drink.id);
        } on Object catch (error) {
          showErrorNotification(error.toString());
        }
      },
    );
  }

  void _optimisticDeleteDrink(
    TypedOptimisticLocalStore store,
    SoftDeleteArgs args,
    OptimisticMutationContext _,
  ) {
    store.updateQuery(
      listCustomQueryReference,
      const NoArgs(),
      (drinks) => [
        for (final drink in drinks)
          if (drink.id != args.id) drink,
      ],
    );
  }
}
