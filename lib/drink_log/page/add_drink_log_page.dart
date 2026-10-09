import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/drink.dart';
import 'package:remembeer/convex_api/widgets/drinkLog.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';

class AddDrinkLogPage extends StatelessWidget {
  const AddDrinkLogPage({super.key, this.targetSessionId});

  final String? targetSessionId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Record a drink'),
    child: UserCurrentQuery(
      builder: (context, user) => DrinkListAvailableQuery(
        builder: (context, drinks) {
          final defaultDrink = drinks
              .where((drink) => drink.id == user.defaultDrink)
              .firstOrNull;
          return DrinkLogCreateMutation(
            builder: (context, create, snapshot) => DrinkLogForm(
              initialDrink: defaultDrink,
              initialSessionId: targetSessionId == null
                  ? null
                  : SessionId(targetSessionId!),
              initialConsumedAt: DateTime.now(),
              initialVolume:
                  (defaultDrink?.drinkCategory ?? const Beer()).defaultVolume,
              onSubmit: (drink, consumedAt, volume, location, sessionId) async {
                await create(
                  drinkId: drink.id,
                  consumedAt: consumedAt.millisecondsSinceEpoch.toDouble(),
                  volumeMl: volume.toDouble(),
                  location: location == null
                      ? null
                      : (
                          latitude: location.latitude,
                          longitude: location.longitude,
                          accuracy: null,
                        ),
                  sessionId: sessionId,
                );
                if (context.mounted) context.pop();
              },
            ),
          );
        },
      ),
    ),
  );
}
