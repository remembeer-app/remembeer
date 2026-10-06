import 'package:flutter/material.dart';
import 'package:remembeer/drink/widget/custom_drink_list.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class CustomDrinksPage extends StatelessWidget {
  const CustomDrinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Custom Drinks',
      autmaticallyImplyLeading: true,
      hint:
          'Your custom drinks are available in addition to the default set '
          'when adding a drink.',
      actions: [
        IconButton(
          tooltip: 'Add custom drink',
          icon: const Icon(Icons.add),
          onPressed: () => const AddDrinkRoute().push<void>(context),
        ),
      ],
      child: const CustomDrinkList(),
    );
  }
}
