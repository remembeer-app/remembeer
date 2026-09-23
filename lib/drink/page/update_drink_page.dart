import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinks.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkPage extends StatelessWidget {
  final String drinkId;

  UpdateDrinkPage({super.key, required this.drinkId});

  final ConvexApi _convexApi = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<GetTypeResult>(
      future: _convexApi.drinks.getValue(id: DrinksId(drinkId)),
      builder: _buildPage,
    );
  }

  Widget _buildPage(BuildContext context, GetTypeResult drink) {
    return PageTemplate(
      title: const Text('Update Custom Drink'),
      child: DrinkForm(
        initialName: drink.name,
        initialAlcoholPercentage: drink.alcoholPercentage,
        initialDrinkCategory: drink.drinkCategory,
        onSubmit: (name, alcoholPercentage, drinkCategory) async {
          await _convexApi.drinks.update(
            id: drink.id,
            name: Optional.of(name),
            alcoholPercentage: Optional.of(alcoholPercentage),
            drinkCategory: Optional.of(drinkCategory),
          );
          if (context.mounted) {
            context.pop();
          }
        },
        onDelete: () async {
          await _convexApi.drinks.softDelete(id: drink.id);
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }
}
