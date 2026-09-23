import 'package:flutter/material.dart';
import 'package:remembeer/drink/widget/custom_drink_list.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class CustomDrinksPage extends StatelessWidget {
  const CustomDrinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Custom Drinks'),
      hint:
          'Your custom drinks are available in addition to the default set '
          'when adding a drink.',
      fabIcon: Icons.add,
      onFabPressed: () => const AddDrinkRoute().push<void>(context),
      child: CustomDrinkList(),
    );
  }
}
