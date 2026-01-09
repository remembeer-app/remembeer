import 'package:flutter/material.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/date/widget/date_selector.dart';
import 'package:remembeer/drink/page/add_drink_page.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_group_list.dart';
import 'package:remembeer/drink/widget/streak_indicator.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/page/create_session_page.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drinkService = get<DrinkService>();

    return PageTemplate(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreakIndicator(),
          IconButton(
            icon: const Icon(Icons.table_bar),
            tooltip: 'Create Session',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => CreateSessionPage(),
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          // TODO(ohtenkay): Maybe make this react to the current date selection, add to the selected date, not now.
          await drinkService.addDefaultDrink();
          if (context.mounted) {
            showNotification(context, 'Default drink added!');
          }
        },
        child: FloatingActionButton(
          heroTag: 'add_drink_fab',
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (context) => AddDrinkPage())),
          child: const Icon(Icons.add),
        ),
      ),
      child: Column(children: [DateSelector(), const DrinkGroupList()]),
    );
  }
}
