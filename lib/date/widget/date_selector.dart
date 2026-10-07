import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/enum/swipe_direction.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/date/type/date_state.dart';

class DateSelector extends StatelessWidget {
  final DateState dateState;
  final ValueChanged<DateTime?> onDateChanged;

  const DateSelector({
    super.key,
    required this.dateState,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            onHorizontalDragEnd: (details) => _handleSwipe(details, isToday),
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
              const Gap(8),
              Text(
                _formatDate(dateState),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (!isToday) ...[const Gap(4), _buildReturnToToday(context)],
        ],
      ),
    );
  }

  Widget _buildReturnToToday(BuildContext context) {
    return InkWell(
      onTap: () => onDateChanged(null),
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
      SwipeDirection.left => (Icons.chevron_left, () => _moveDate(-1)),
      SwipeDirection.right => (Icons.chevron_right, () => _moveDate(1)),
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
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: dateState.selectedDate,
      firstDate: DateTime(2020),
      lastDate: dateState.effectiveToday,
      currentDate: dateState.effectiveToday,
    );

    if (pickedDate != null) {
      onDateChanged(pickedDate);
    }
  }

  String _formatDate(DateState dateState) {
    return formatRelativeDay(dateState.selectedDate, dateState.effectiveToday);
  }

  void _moveDate(int days) =>
      onDateChanged(dateState.selectedDate.add(Duration(days: days)));

  void _handleSwipe(DragEndDetails details, bool isToday) {
    if (details.primaryVelocity == null) {
      return;
    }

    if (details.primaryVelocity! > 0) {
      _moveDate(-1);
    } else if (details.primaryVelocity! < 0 && !isToday) {
      _moveDate(1);
    }
  }
}
