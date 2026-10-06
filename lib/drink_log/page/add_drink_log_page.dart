import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/drink.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink_log/model/drink_log_create.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class AddDrinkLogPage extends StatelessWidget {
  final String? targetSessionId;

  AddDrinkLogPage({super.key, this.targetSessionId});

  final _drinkLogService = get<DrinkLogService>();
  final _userSettingsService = get<UserSettingsService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: _userSettingsService.currentUserSettings,
      builder: (context, userSettings) {
        return PageTemplate(
          title: Text(
            targetSessionId == null ? 'Record a Drink' : 'Add Party Drink',
          ),
          child: UserCurrentQuery(
            builder: (context, user) => DrinkListAvailableQuery(
              builder: (context, drinks) => DrinkLogForm(
                initialDrink: drinks
                    .where((drink) => drink.id == user.defaultDrink)
                    .firstOrNull,
                initialConsumedAt: DateTime.now(),
                initialVolume: userSettings.defaultDrinkSize,
                onSubmit:
                    (drink, consumedAt, volumeInMilliliters, location) async {
                      await _drinkLogService.createDrinkLog(
                        DrinkLogCreate(
                          consumedAt: consumedAt,
                          drink: DrinkSnapshot(
                            name: drink.name,
                            category: drink.drinkCategory,
                            alcoholPercentage: drink.alcoholPercentage,
                          ),
                          volumeInMilliliters: volumeInMilliliters,
                          location: location,
                        ),
                        targetSessionId: targetSessionId,
                      );
                      if (context.mounted) {
                        context.pop();
                      }
                    },
              ),
            ),
          ),
        );
      },
    );
  }
}
