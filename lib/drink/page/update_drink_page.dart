import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/type/drink_with_session_id.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkPage extends StatelessWidget {
  final String sessionId;
  final String drinkId;
  final DrinkService _drinkService;

  UpdateDrinkPage({
    super.key,
    required this.sessionId,
    required this.drinkId,
    DrinkService? drinkService,
  }) : _drinkService = drinkService ?? get<DrinkService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<DrinkWithSessionId>(
      stream: _drinkService.drinkWithSessionIdStream(
        sessionId: sessionId,
        drinkId: drinkId,
      ),
      builder: _buildPage,
    );
  }

  Widget _buildPage(
    BuildContext context,
    DrinkWithSessionId drinkWithSessionId,
  ) {
    final drink = drinkWithSessionId.drink;

    if (drinkWithSessionId.isReadOnly) {
      return const PageTemplate(
        title: Text('Update Drink'),
        child: Center(
          child: Card(
            child: ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text('Archived Party'),
              subtitle: Text(
                'This drink is read-only because the Party has ended.',
              ),
            ),
          ),
        ),
      );
    }

    return PageTemplate(
      title: const Text('Update Drink'),
      child: DrinkForm(
        initialDrinkType: drink.drinkType,
        initialConsumedAt: drink.consumedAt,
        initialVolume: drink.volumeInMilliliters,
        initialLocation: drink.location,
        onSubmit: (drinkType, consumedAt, volumeInMilliliters, location) async {
          await _drinkService.updateDrink(
            oldDrink: drink,
            newDrink: drink.copyWith(
              consumedAt: consumedAt,
              drinkType: drinkType,
              volumeInMilliliters: volumeInMilliliters,
              location: location,
            ),
            sessionId: drinkWithSessionId.originalSessionId,
          );
          if (context.mounted) {
            context.pop(true);
          }
        },
      ),
    );
  }
}
