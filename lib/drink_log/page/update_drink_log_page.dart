import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/convex_api/widgets/drink.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkLogPage extends StatelessWidget {
  UpdateDrinkLogPage({super.key, required this.log});

  final ListForDayResultItem? log;
  final _api = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    final log = this.log;
    if (log == null) {
      return const PageTemplate(
        title: Text('Update drink'),
        child: Center(
          child: Text('Open a drink from the daily list to edit it.'),
        ),
      );
    }
    final location = log.location;
    return PageTemplate(
      title: const Text('Update drink'),
      child: DrinkListAvailableQuery(
        builder: (context, drinks) => DrinkLogForm(
          initialDrink:
              drinks.where((drink) => drink.id == log.drinkId).firstOrNull ??
              log.drink,
          initialConsumedAt: DateTime.fromMillisecondsSinceEpoch(
            log.consumedAt.toInt(),
          ),
          initialVolume: log.volumeMl.toInt(),
          initialLocation: location == null
              ? null
              : GeoPoint(location.latitude, location.longitude),
          onSubmit: (drink, consumedAt, volume, location) async {
            await _api.drinkLog.update(
              id: log.id,
              drinkId: Optional.of(drink.id),
              consumedAt: Optional.of(
                consumedAt.millisecondsSinceEpoch.toDouble(),
              ),
              volumeMl: Optional.of(volume.toDouble()),
              location: Optional.of(
                location == null
                    ? null
                    : (
                        latitude: location.latitude,
                        longitude: location.longitude,
                        accuracy: null,
                      ),
              ),
            );
            if (context.mounted) context.pop();
          },
        ),
      ),
    );
  }
}
