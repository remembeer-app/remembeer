import 'package:flutter/material.dart';
import 'package:remembeer/user/model/gender.dart';

class GenderSelector extends StatelessWidget {
  final Gender? value;
  final ValueChanged<Gender> onChanged;
  final bool enabled;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Gender>(
      segments: const [
        ButtonSegment(
          value: Gender.male,
          label: Text('Male'),
          icon: Icon(Icons.male),
        ),
        ButtonSegment(
          value: Gender.female,
          label: Text('Female'),
          icon: Icon(Icons.female),
        ),
      ],
      selected: value == null ? const {} : {value!},
      emptySelectionAllowed: true,
      onSelectionChanged: enabled
          ? (selection) {
              if (selection.isNotEmpty) {
                onChanged(selection.single);
              }
            }
          : null,
    );
  }
}
