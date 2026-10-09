import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/drinkLog.dart';
import 'package:remembeer/date/widget/date_selector.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_group_list.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/widget/session_menu_button.dart';

class DrinkLogPage extends StatefulWidget {
  const DrinkLogPage({super.key});

  @override
  State<DrinkLogPage> createState() => _DrinkLogPageState();
}

class _DrinkLogPageState extends State<DrinkLogPage> {
  final _logs = get<DrinkLogService>();
  double _at = DateTime.now().millisecondsSinceEpoch.toDouble();
  late final AppLifecycleListener _lifecycle;
  DateTime? _selectedDate;
  var _isActive = true;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refreshDay);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The router keeps inactive tabs mounted and disables their TickerMode.
    // Refresh on returning to this tab to pick up day-boundary or time-zone changes.
    final isActive = TickerMode.valuesOf(context).enabled;
    if (isActive && !_isActive) {
      _at = DateTime.now().millisecondsSinceEpoch.toDouble();
    }
    _isActive = isActive;
  }

  void _refreshDay() {
    if (_isActive) {
      setState(() {
        _at = DateTime.now().millisecondsSinceEpoch.toDouble();
      });
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Drinks'),
      actions: const [SessionMenuButton()],
      padding: EdgeInsets.zero,
      floatingActionButton: GestureDetector(
        onLongPress: _quickAdd,
        child: FloatingActionButton(
          heroTag: 'add_drink_fab',
          onPressed: () => const AddDrinkLogRoute().push<void>(context),
          child: const Icon(Icons.add),
        ),
      ),
      child: DrinkLogListForDayQuery(
        at: _at,
        date: _selectedDate == null
            ? const Optional.absent()
            : Optional.of(DateFormat('yyyy-MM-dd').format(_selectedDate!)),
        errorBuilder: (context, error) => Center(
          child: TextButton(
            onPressed: _refreshDay,
            child: const Text('Retry loading the day'),
          ),
        ),
        builder: (context, day) {
          final today = DateTime.parse('${day.today}T00:00:00Z');
          final date = DateTime.parse('${day.date}T00:00:00Z');
          return Column(
            children: [
              DateSelector(
                dateState: (selectedDate: date, effectiveToday: today),
                onDateChanged: (value) => setState(() {
                  _selectedDate =
                      value == null || DateUtils.isSameDay(value, today)
                      ? null
                      : value;
                }),
              ),
              Expanded(child: DrinkLogGroupList(day: day)),
            ],
          );
        },
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
