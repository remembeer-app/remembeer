import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/convex_api/widgets/drink.dart';
import 'package:remembeer/convex_api/widgets/drinkLog.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';

class UpdateDrinkLogPage extends StatelessWidget {
  const UpdateDrinkLogPage({super.key, required this.log});

  final ListForDayResultLogsItem? log;

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
        builder: (context, drinks) => DrinkLogUpdateMutation(
          builder: (context, update, snapshot) => DrinkLogForm(
            initialSessionId: log.sessionId,
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
            onSubmit: (drink, consumedAt, volume, location, sessionId) async {
              await update(
                id: log.id,
                sessionId: sessionId == log.sessionId
                    ? const Optional.absent()
                    : Optional.of(sessionId),
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
      ),
    );
  }
}
