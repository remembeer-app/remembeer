import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/type/drink_log_with_session_id.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class UpdateDrinkLogPage extends StatelessWidget {
  final String sessionId;
  final String drinkLogId;
  final DrinkLogService _drinkLogService;

  UpdateDrinkLogPage({
    super.key,
    required this.sessionId,
    required this.drinkLogId,
    DrinkLogService? drinkLogService,
  }) : _drinkLogService = drinkLogService ?? get<DrinkLogService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<DrinkLogWithSessionId>(
      stream: _drinkLogService.drinkLogWithSessionIdStream(
        sessionId: sessionId,
        drinkLogId: drinkLogId,
      ),
      builder: _buildPage,
    );
  }

  Widget _buildPage(
    BuildContext context,
    DrinkLogWithSessionId drinkLogWithSessionId,
  ) {
    final drinkLog = drinkLogWithSessionId.drinkLog;

    if (drinkLogWithSessionId.isReadOnly) {
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
      child: DrinkLogForm(
        initialDrink: drinkLog.drink,
        initialConsumedAt: drinkLog.consumedAt,
        initialVolume: drinkLog.volumeInMilliliters,
        initialLocation: drinkLog.location,
        onSubmit:
            (catalogDrink, consumedAt, volumeInMilliliters, location) async {
              await _drinkLogService.updateDrinkLog(
                oldDrinkLog: drinkLog,
                newDrinkLog: drinkLog.copyWith(
                  consumedAt: consumedAt,
                  drink: catalogDrink,
                  volumeInMilliliters: volumeInMilliliters,
                  location: location,
                ),
                sessionId: drinkLogWithSessionId.originalSessionId,
              );
              if (context.mounted) {
                context.pop(true);
              }
            },
      ),
    );
  }
}
