import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/widget/drink_type_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkTypePage extends StatelessWidget {
  final String drinkTypeId;

  UpdateDrinkTypePage({super.key, required this.drinkTypeId});

  final _drinkTypeController = get<DrinkTypeController>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<DrinkType>(
      stream: _drinkTypeController.streamById(drinkTypeId),
      builder: _buildPage,
    );
  }

  Widget _buildPage(BuildContext context, DrinkType drinkTypeToUpdate) {
    return PageTemplate(
      title: const Text('Update Custom Drink Type'),
      child: DrinkTypeForm(
        initialName: drinkTypeToUpdate.name,
        initialAlcoholPercentage: drinkTypeToUpdate.alcoholPercentage,
        initialDrinkCategory: drinkTypeToUpdate.category,
        onSubmit: (name, alcoholPercentage, drinkCategory) async {
          await _drinkTypeController.updateSingle(
            drinkTypeToUpdate.copyWith(
              name: name,
              alcoholPercentage: alcoholPercentage,
              category: drinkCategory,
            ),
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        onDelete: () async {
          await _drinkTypeController.deleteSingle(drinkTypeToUpdate);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
