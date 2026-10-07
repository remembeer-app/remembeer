import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkLogCard extends StatelessWidget {
  DrinkLogCard({super.key, required this.log});

  final ListForDayResultItem log;
  final _api = get<ConvexApi>();

  @override
  Widget build(BuildContext context) {
    final drink = log.drink;
    final name = drink?.name ?? 'Unavailable drink';
    final time = DateFormat.Hm().format(
      DateTime.parse('${log.consumedAtLocal}Z'),
    );
    final volume = NumberFormat.decimalPattern().format(log.volumeMl);
    return Card(
      child: ListTile(
        leading: drink == null
            ? const Icon(Icons.help_outline)
            : DrinkIcon(category: drink.drinkCategory),
        title: Text(name),
        subtitle: Text(
          '$volume ml · $time${drink == null ? '' : ' · ${drink.alcoholPercentage}%'}',
        ),
        onTap: () => UpdateDrinkLogRoute(
          drinkLogId: log.id.value,
          $extra: log,
        ).push<void>(context),
        trailing: IconButton(
          tooltip: 'Delete drink',
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => showConfirmationDialog(
            context: context,
            title: 'Delete drink',
            text: 'Delete this $name?',
            submitButtonText: 'Delete',
            isDestructive: true,
            onPressed: () async {
              try {
                await _api.drinkLog.softDelete(id: log.id);
                showSuccessNotification('Drink deleted!');
              } on Object catch (error) {
                showNotification(error.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
