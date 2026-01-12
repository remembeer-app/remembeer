import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/enum/swipe_direction.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/type/date_state.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DateSelector extends StatelessWidget {
  DateSelector({super.key});

  final DateService _dateService = get<DateService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<DateState>(
      stream: _dateService.selectedDateStateStream,
      builder: (context, dateState) {
        final isToday = DateUtils.isSameDay(
          dateState.selectedDate,
          dateState.effectiveToday,
        );

        final theme = Theme.of(context);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showDatePicker(context, dateState),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: GestureDetector(
                onHorizontalDragEnd: (details) =>
                    _handleSwipe(details, isToday),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildChevron(direction: SwipeDirection.left),
                    _buildDateDisplay(dateState, context, isToday),
                    _buildChevron(
                      direction: SwipeDirection.right,
                      enabled: !isToday,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateDisplay(
    DateState dateState,
    BuildContext context,
    bool isToday,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 16),
              hGap8,
              Text(
                _formatDate(dateState),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (!isToday) ...[gap4, _buildReturnToToday(context)],
        ],
      ),
    );
  }

  Widget _buildReturnToToday(BuildContext context) {
    return InkWell(
      onTap: _dateService.goToToday,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          'Return to today',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconButton _buildChevron({
    required SwipeDirection direction,
    bool enabled = true,
  }) {
    final (icon, moveFunction) = switch (direction) {
      SwipeDirection.left => (Icons.chevron_left, _dateService.previousDay),
      SwipeDirection.right => (Icons.chevron_right, _dateService.nextDay),
    };

    return IconButton(
      icon: Icon(icon),
      onPressed: enabled ? moveFunction : null,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    DateState dateState,
  ) async {
    // TODO(ohtenkay): Try out a package like https://pub.dev/packages/syncfusion_flutter_datepicker
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: dateState.selectedDate,
      firstDate: DateTime(2020),
      lastDate: dateState.effectiveToday,
      currentDate: dateState.selectedDate,
    );

    if (pickedDate != null) {
      _dateService.setDate(pickedDate);
    }
  }

  String _formatDate(DateState dateState) {
    final date = DateUtils.dateOnly(dateState.selectedDate);
    final nowDate = DateUtils.dateOnly(dateState.effectiveToday);

    return switch (date.difference(nowDate).inDays) {
      0 => 'Today',
      -1 => 'Yesterday',
      _ => DateFormat('EEE, d MMM yyyy').format(date),
    };
  }

  void _handleSwipe(DragEndDetails details, bool isToday) {
    if (details.primaryVelocity == null) {
      return;
    }

    if (details.primaryVelocity! > 0) {
      _dateService.previousDay();
    } else if (details.primaryVelocity! < 0 && !isToday) {
      _dateService.nextDay();
    }
  }
}
