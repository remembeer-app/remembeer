import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/date/widget/date_selector.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_group_list.dart';
import 'package:remembeer/drink_log/widget/streak_indicator.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/widget/session_menu_button.dart';

class DrinkLogPage extends StatelessWidget {
  DrinkLogPage({super.key});

  final _drinkLogService = get<DrinkLogService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [StreakIndicator(), const SessionMenuButton()],
      ),
      padding: EdgeInsets.zero,
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          // TODO(ohtenkay): Maybe make this react to the current date selection, add to the selected date, not now.
          await _drinkLogService.addDefaultDrinkLog();
        },
        child: FloatingActionButton(
          heroTag: 'add_drink_fab',
          onPressed: () => const AddDrinkLogRoute().push<void>(context),
          child: const Icon(Icons.add),
        ),
      ),
      child: Column(children: [DateSelector(), const DrinkLogGroupList()]),
    );
  }
}
