import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class AddDrinkPage extends StatelessWidget {
  AddDrinkPage({super.key});

  final _convexApi = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Add Custom Drink'),
      child: ConvexMutation<CreateArgs, DrinkId>(
        mutation: _convexApi.drink.createMutation,
        builder: (context, mutate, snapshot) => DrinkForm(
          initialName: '',
          initialAlcoholPercentage: 6.9,
          initialDrinkCategory: const Beer(),
          isLoading: snapshot.isLoading,
          error: snapshot.error,
          onSubmit: (name, alcoholPercentage, drinkCategory) {
            mutate((
              name: name,
              drinkCategory: drinkCategory,
              alcoholPercentage: alcoholPercentage,
            )).then((_) {
              if (context.mounted) context.pop();
            }).ignore();
          },
        ),
      ),
    );
  }
}
