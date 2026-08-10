import 'package:flutter/material.dart';
import 'package:remembeer/drink_type/widget/custom_drink_type_list.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class CustomDrinkTypesPage extends StatelessWidget {
  const CustomDrinkTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Custom Drink Types'),
      hint:
          'Your custom drinks are available in addition to the default set '
          'when adding a drink.',
      fabIcon: Icons.add,
      onFabPressed: () => const AddDrinkTypeRoute().push<void>(context),
      child: CustomDrinkTypeList(),
    );
  }
}
