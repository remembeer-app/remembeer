import 'package:flutter/material.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/drink_type/widget/drink_type_picker_sheet.dart';
import 'package:remembeer/drink_type/widget/selected_drink_display.dart';

class DrinkTypePicker extends StatelessWidget {
  final DrinkTypeCore selectedDrinkType;
  final void Function(DrinkTypeCore) onChanged;

  const DrinkTypePicker({
    super.key,
    required this.selectedDrinkType,
    required this.onChanged,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet<DrinkTypeCore>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          DrinkTypePickerSheet(selectedDrinkType: selectedDrinkType),
    ).then((selectedDrinkType) {
      if (selectedDrinkType != null) {
        onChanged(selectedDrinkType);
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
        child: SelectedDrinkDisplay(drinkType: selectedDrinkType),
      ),
    );
  }
}
