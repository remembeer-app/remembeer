import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/modules/drinks.dart';
import 'package:remembeer/drink_type/service/custom_drink_type_service.dart';
import 'package:remembeer/drink_type/widget/drink_type_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkTypePage extends StatelessWidget {
  final String drinkTypeId;

  UpdateDrinkTypePage({super.key, required this.drinkTypeId});

  final _customDrinkTypeService = get<CustomDrinkTypeService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<GetTypeResult>(
      future: _customDrinkTypeService.getById(drinkTypeId),
      builder: _buildPage,
    );
  }

  Widget _buildPage(BuildContext context, GetTypeResult drink) {
    return PageTemplate(
      title: const Text('Update Custom Drink Type'),
      child: DrinkTypeForm(
        initialName: drink.name,
        initialAlcoholPercentage: drink.alcoholPercentage,
        initialDrinkCategory: drink.drinkCategory,
        onSubmit: (name, alcoholPercentage, drinkCategory) async {
          await _customDrinkTypeService.update(
            id: drink.id,
            name: name,
            alcoholPercentage: alcoholPercentage,
            drinkCategory: drinkCategory,
          );
          if (context.mounted) {
            context.pop();
          }
        },
        onDelete: () async {
          await _customDrinkTypeService.delete(drink.id);
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }
}
