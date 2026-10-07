import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart';
import 'package:remembeer/convex_api/widgets/drinkLog.dart';
import 'package:remembeer/date/widget/date_selector.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkLogPage extends StatefulWidget {
  const DrinkLogPage({super.key});

  @override
  State<DrinkLogPage> createState() => _DrinkLogPageState();
}

class _DrinkLogPageState extends State<DrinkLogPage> {
  final _api = get<ConvexApi>();
  final _logs = get<DrinkLogService>();
  late Future<DayContextResult> _dayContext;
  late final AppLifecycleListener _lifecycle;
  DateTime? _selectedDate;
  var _isActive = true;

  Future<DayContextResult> _loadDay() => _api.drinkLog.dayContext(
    at: DateTime.now().millisecondsSinceEpoch.toDouble(),
  );

  @override
  void initState() {
    super.initState();
    _dayContext = _loadDay();
    _lifecycle = AppLifecycleListener(onResume: _refreshDay);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The router keeps inactive tabs mounted and disables their TickerMode.
    // Refresh on returning to this tab to pick up day-boundary or time-zone changes.
    final isActive = TickerMode.valuesOf(context).enabled;
    if (isActive && !_isActive) _dayContext = _loadDay();
    _isActive = isActive;
  }

  void _refreshDay() {
    if (_isActive) {
      setState(() {
        _dayContext = _loadDay();
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
      padding: EdgeInsets.zero,
      floatingActionButton: GestureDetector(
        onLongPress: _quickAdd,
        child: FloatingActionButton(
          heroTag: 'add_drink_fab',
          onPressed: () => const AddDrinkLogRoute().push<void>(context),
          child: const Icon(Icons.add),
        ),
      ),
      child: AsyncBuilder<DayContextResult>(
        future: _dayContext,
        errorBuilder: (context, error) => Center(
          child: TextButton(
            onPressed: _refreshDay,
            child: const Text('Retry loading the day'),
          ),
        ),
        builder: (context, day) {
          final today = DateTime.parse('${day.today}T00:00:00Z');
          final selected = _selectedDate;
          final date = selected == null || selected.isAfter(today)
              ? today
              : selected;
          return Column(
            children: [
              DateSelector(
                dateState: (selectedDate: date, effectiveToday: today),
                onDateChanged: (value) => setState(() {
                  final selected = value == null
                      ? null
                      : DateTime.utc(value.year, value.month, value.day);
                  _selectedDate = selected == today ? null : selected;
                }),
              ),
              Expanded(
                child: DrinkLogListForDayQuery(
                  date: DateFormat('yyyy-MM-dd').format(date),
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
