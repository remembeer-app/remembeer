import 'package:flutter/material.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink/widget/drink_picker_sheet.dart';
import 'package:remembeer/drink/widget/selected_drink_display.dart';

class DrinkPicker extends StatelessWidget {
  final DrinkSnapshot selectedDrink;
  final void Function(DrinkSnapshot) onChanged;

  const DrinkPicker({
    super.key,
    required this.selectedDrink,
    required this.onChanged,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet<DrinkSnapshot>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DrinkPickerSheet(selectedDrink: selectedDrink),
    ).then((drink) {
      if (drink != null) {
        onChanged(drink);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openPicker(context),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Drink',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: SelectedDrinkDisplay(drink: selectedDrink),
      ),
    );
  }
}
