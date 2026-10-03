import 'package:dartvex_flutter/dartvex_flutter.dart' show MutationMode;
import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/widgets/drink.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user_settings/widget/drink_picker.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class DefaultDrinkPage extends StatelessWidget {
  const DefaultDrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Default drink',
      autmaticallyImplyLeading: true,
      hint: 'Choose your preferred drink.',
      child: UserCurrentQuery(
        builder: (context, user) => DrinkListAvailableQuery(
          builder: (context, drinks) => UserUpdateDefaultDrinkMutation(
            mode: MutationMode.latest,
            builder: (context, mutate, snapshot) => DrinkPicker(
              key: ValueKey(user.id),
              value: user.defaultDrink,
              drinks: drinks,
              error: snapshot.error,
              onChanged: (drinkId) {
                if (!snapshot.isLoading && drinkId == user.defaultDrink) return;
                mutate(defaultDrink: drinkId).ignore();
              },
            ),
          ),
        ),
      ),
    );
  }
}
