import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/drink/widget/drink_picker_sheet.dart';
import 'package:remembeer/drink/widget/selected_drink_display.dart';

class DrinkPicker extends FormField<ListAvailableResultItem> {
  final ListAvailableResultItem? selectedDrink;
  final ValueChanged<ListAvailableResultItem> onChanged;

  DrinkPicker({
    super.key,
    required this.selectedDrink,
    required this.onChanged,
    super.enabled,
  }) : super(
         initialValue: selectedDrink,
         validator: (value) => value == null ? 'Please choose a drink.' : null,
         builder: (state) => (state as _DrinkPickerState)._buildField(),
       );

  @override
  FormFieldState<ListAvailableResultItem> createState() => _DrinkPickerState();
}

class _DrinkPickerState extends FormFieldState<ListAvailableResultItem> {
  final _focusNode = FocusNode();

  @override
  DrinkPicker get widget => super.widget as DrinkPicker;

  @override
  void didUpdateWidget(DrinkPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDrink != widget.selectedDrink) {
      setValue(widget.selectedDrink);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet<ListAvailableResultItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) =>
          DrinkPickerSheet(selectedDrink: widget.selectedDrink),
    ).then((drink) {
      if (context.mounted && drink != null) {
        didChange(drink);
        widget.onChanged(drink);
      }
    });
  }

  Widget _buildField() {
    return InkWell(
      focusNode: _focusNode,
      onFocusChange: (_) => setState(() {}),
      onTap: widget.enabled ? () => _openPicker(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        isFocused: widget.enabled && _focusNode.hasFocus,
        decoration: InputDecoration(
          enabled: widget.enabled,
          labelText: 'Drink',
          errorText: errorText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: widget.selectedDrink != null
            ? SelectedDrinkDisplay(drink: widget.selectedDrink!)
            : const Text('Choose a drink'),
      ),
    );
  }
}
