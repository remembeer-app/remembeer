import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/schema.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink/widget/drink_picker_sheet.dart';
import 'package:remembeer/drink/widget/selected_drink_display.dart';

class DrinkPicker extends StatelessWidget {
  final DrinkSnapshot? selectedDrink;
  final DrinkId? selectedDrinkId;
  final bool enabled;
  final ValueChanged<ListAvailableResultItem> onChanged;

  const DrinkPicker({
    super.key,
    required this.selectedDrink,
    required this.onChanged,
    this.selectedDrinkId,
    this.enabled = true,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet<ListAvailableResultItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => DrinkPickerSheet(
        selectedDrink: selectedDrink,
        selectedDrinkId: selectedDrinkId,
      ),
    ).then((drink) {
      if (context.mounted && drink != null) {
        onChanged(drink);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _openPicker(context) : null,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          enabled: enabled,
          labelText: 'Drink',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: selectedDrink != null
            ? SelectedDrinkDisplay(drink: selectedDrink!)
            : const Text('Choose a drink'),
      ),
    );
  }
}
