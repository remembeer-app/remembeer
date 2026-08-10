import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class AddDrinkPage extends StatelessWidget {
  AddDrinkPage({super.key});

  final _drinkService = get<DrinkService>();
  final _userSettingsService = get<UserSettingsService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: _userSettingsService.currentUserSettings,
      builder: (context, userSettings) {
        return PageTemplate(
          title: const Text('Record a Drink'),
          child: DrinkForm(
            initialDrinkType: userSettings.defaultDrinkType,
            initialConsumedAt: DateTime.now(),
            initialVolume: userSettings.defaultDrinkSize,
            onSubmit:
                (drinkType, consumedAt, volumeInMilliliters, location) async {
                  await _drinkService.createDrink(
                    DrinkCreate(
                      consumedAt: consumedAt,
                      drinkType: drinkType,
                      volumeInMilliliters: volumeInMilliliters,
                      location: location,
                    ),
                  );
                  if (context.mounted) {
                    context.pop();
                  }
                },
          ),
        );
      },
    );
  }
}
