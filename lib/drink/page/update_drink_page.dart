import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets.dart';
import 'package:remembeer/drink/widget/drink_form.dart';

class UpdateDrinkPage extends StatelessWidget {
  final String drinkId;

  const UpdateDrinkPage({super.key, required this.drinkId});

  @override
  Widget build(BuildContext context) {
    return DrinkGetTypeQuery(id: DrinkId(drinkId), builder: _buildPage);
  }

  Widget _buildPage(BuildContext context, DrinkDocument drink) {
    return PageTemplate(
      title: const Text('Update Custom Drink'),
      child: DrinkUpdateMutation(
        builder: (context, update, updateSnapshot) => DrinkSoftDeleteMutation(
          builder: (context, softDelete, deleteSnapshot) => DrinkForm(
            initialName: drink.name,
            initialAlcoholPercentage: drink.alcoholPercentage,
            initialDrinkCategory: drink.drinkCategory,
            isLoading: updateSnapshot.isLoading || deleteSnapshot.isLoading,
            error: updateSnapshot.error ?? deleteSnapshot.error,
            onSubmit: (name, alcoholPercentage, drinkCategory) {
              update.run(
                id: drink.id,
                name: Optional.of(name),
                alcoholPercentage: Optional.of(alcoholPercentage),
                drinkCategory: Optional.of(drinkCategory),
                onSuccess: (_) {
                  if (context.mounted) context.pop();
                },
              );
            },
            onDelete: () {
              softDelete.run(
                id: drink.id,
                onSuccess: (_) {
                  if (context.mounted) context.pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
