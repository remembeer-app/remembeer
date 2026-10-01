import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/convex_api/widgets.dart';
import 'package:remembeer/drink/widget/drink_form.dart';

class AddDrinkPage extends StatelessWidget {
  const AddDrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Add Custom Drink'),
      child: DrinkCreateMutation(
        builder: (context, mutate, snapshot) => DrinkForm(
          initialName: '',
          initialAlcoholPercentage: 6.9,
          initialDrinkCategory: const Beer(),
          isLoading: snapshot.isLoading,
          error: snapshot.error,
          onSubmit: (name, alcoholPercentage, drinkCategory) {
            mutate(
              name: name,
              drinkCategory: drinkCategory,
              alcoholPercentage: alcoholPercentage,
            ).then((_) {
              if (context.mounted) context.pop();
            }).ignore();
          },
        ),
      ),
    );
  }
}
