import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_create.dart';
import 'package:remembeer/drink_type/widget/drink_type_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class AddDrinkTypePage extends StatelessWidget {
  AddDrinkTypePage({super.key});

  final _drinkTypeController = get<DrinkTypeController>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Add Custom Drink Type'),
      child: DrinkTypeForm(
        initialName: '',
        initialAlcoholPercentage: 6.9,
        initialDrinkCategory: DrinkCategory.beer,
        onSubmit: (name, alcoholPercentage, drinkCategory) async {
          await _drinkTypeController.createSingle(
            DrinkTypeCreate(
              name: name,
              category: drinkCategory,
              alcoholPercentage: alcoholPercentage,
            ),
          );
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }
}
