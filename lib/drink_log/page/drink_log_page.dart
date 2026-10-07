import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/drinkLog.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/type/date_state.dart';
import 'package:remembeer/date/widget/date_selector.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkLogPage extends StatelessWidget {
  DrinkLogPage({super.key});

  final _dates = get<DateService>();
  final _logs = get<DrinkLogService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Drinks'),
      padding: EdgeInsets.zero,
      floatingActionButton: GestureDetector(
        onLongPress: _quickAdd,
        child: FloatingActionButton(
          heroTag: 'add_drink_fab',
          onPressed: () => const AddDrinkLogRoute().push<void>(context),
          child: const Icon(Icons.add),
        ),
      ),
      child: Column(
        children: [
          DateSelector(),
          Expanded(
            child: AsyncBuilder<DateState>(
              stream: _dates.selectedDateStateStream,
              errorBuilder: (context, error) => Center(
                child: TextButton(
                  onPressed: _dates.refresh,
                  child: const Text('Retry loading the day'),
                ),
              ),
              builder: (context, state) => DrinkLogListForDayQuery(
                date: DateFormat('yyyy-MM-dd').format(state.selectedDate),
                builder: (context, logs) => logs.isEmpty
                    ? const Center(
                        child: Text('No drinks recorded for this day.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: logs.length,
                        itemBuilder: (context, index) => DrinkLogCard(
                          key: ValueKey(logs[index].id),
                          log: logs[index],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _quickAdd() async {
    try {
      await _logs.addDefaultDrinkLog();
    } on Object catch (error) {
      showNotification(error.toString());
    }
  }
}
