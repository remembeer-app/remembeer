import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/widgets/drink.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/drink/widget/drink_picker.dart';
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
            builder: (context, mutate, snapshot) {
              final selectedDrink = drinks
                  .where((drink) => drink.id == user.defaultDrink)
                  .firstOrNull;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (drinks.isEmpty)
                      const Center(child: Text('No drinks available'))
                    else
                      DrinkPicker(
                        selectedDrink: selectedDrink,
                        enabled: !snapshot.isLoading,
                        onChanged: (drink) {
                          if (drink.id == user.defaultDrink) return;
                          mutate(defaultDrink: drink.id).ignore();
                        },
                      ),
                    if (snapshot.error case final error?) ...[
                      const Gap(16),
                      ErrorMessageBox(message: error.toString()),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
