import 'package:flutter/cupertino.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/type/drink_with_session_id.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkPage extends StatelessWidget {
  final DrinkWithSessionId drinkWithSessionId;

  UpdateDrinkPage({super.key, required this.drinkWithSessionId});

  final _drinkService = get<DrinkService>();

  Drink get _drink => drinkWithSessionId.drink;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Update Drink'),
      child: DrinkForm(
        initialDrinkType: _drink.drinkType,
        initialConsumedAt: _drink.consumedAt,
        initialVolume: _drink.volumeInMilliliters,
        initialLocation: _drink.location,
        onSubmit: (drinkType, consumedAt, volumeInMilliliters, location) async {
          await _drinkService.updateDrink(
            oldDrink: _drink,
            newDrink: _drink.copyWith(
              consumedAt: consumedAt,
              drinkType: drinkType,
              volumeInMilliliters: volumeInMilliliters,
              location: location,
            ),
            sessionId: drinkWithSessionId.originalSessionId,
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
