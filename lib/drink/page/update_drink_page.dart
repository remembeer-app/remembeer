import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkPage extends StatelessWidget {
  final String drinkId;

  UpdateDrinkPage({super.key, required this.drinkId});

  final ConvexApi _convexApi = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<GetTypeResult>(
      future: _convexApi.drink.getValue(id: DrinkId(drinkId)),
      builder: _buildPage,
    );
  }

  Widget _buildPage(BuildContext context, GetTypeResult drink) {
    return PageTemplate(
      title: const Text('Update Custom Drink'),
      child: ConvexMutation<UpdateArgs, void>(
        mutation: _convexApi.drink.updateMutation,
        builder: (context, update, updateSnapshot) =>
            ConvexMutation<SoftDeleteArgs, void>(
              mutation: _convexApi.drink.softDeleteMutation,
              builder: (context, softDelete, deleteSnapshot) => DrinkForm(
                initialName: drink.name,
                initialAlcoholPercentage: drink.alcoholPercentage,
                initialDrinkCategory: drink.drinkCategory,
                isLoading: updateSnapshot.isLoading || deleteSnapshot.isLoading,
                error: updateSnapshot.error ?? deleteSnapshot.error,
                onSubmit: (name, alcoholPercentage, drinkCategory) {
                  update((
                    id: drink.id,
                    name: Optional.of(name),
                    alcoholPercentage: Optional.of(alcoholPercentage),
                    drinkCategory: Optional.of(drinkCategory),
                  )).then((_) {
                    if (context.mounted) context.pop();
                  }).ignore();
                },
                onDelete: () {
                  softDelete((id: drink.id)).then((_) {
                    if (context.mounted) context.pop();
                  }).ignore();
                },
              ),
            ),
      ),
    );
  }
}
