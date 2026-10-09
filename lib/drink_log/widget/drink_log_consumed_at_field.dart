import 'package:flutter/material.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';

class DrinkLogConsumedAtField extends FormField<DateTime> {
  final ValueChanged<DateTime> onChanged;
  DrinkLogConsumedAtField({
    super.key,
    required DateTime super.initialValue,
    super.enabled,
    required this.onChanged,
  }) : super(
         validator: (value) => value == null
             ? 'Please select when you consumed the drink.'
             : null,
         builder: (state) =>
             (state as _DrinkLogConsumedAtFieldState)._buildField(),
       );

  @override
  FormFieldState<DateTime> createState() => _DrinkLogConsumedAtFieldState();
}

class _DrinkLogConsumedAtFieldState extends FormFieldState<DateTime> {
  final _focusNode = FocusNode();

  @override
  DrinkLogConsumedAtField get widget => super.widget as DrinkLogConsumedAtField;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildField() => InkWell(
    focusNode: _focusNode,
    onFocusChange: (_) => setState(() {}),
    borderRadius: BorderRadius.circular(12),
    onTap: widget.enabled ? _selectDateTime : null,
    child: InputDecorator(
      isFocused: widget.enabled && _focusNode.hasFocus,
      decoration: InputDecoration(
        labelText: 'Consumed at (device time)',
        enabled: widget.enabled,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
        errorText: errorText,
      ),
      child: Text(formatFullDateTime(value!)),
    ),
  );

  Future<void> _selectDateTime() async {
    final selected = value!;
    final date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted || !widget.enabled) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selected),
    );
    if (time == null || !mounted || !widget.enabled) return;
    final selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    didChange(selectedDate);
    widget.onChanged(selectedDate);
  }
}
