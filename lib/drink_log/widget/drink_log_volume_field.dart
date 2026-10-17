import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DrinkLogVolumeField extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, int> predefinedVolumes;
  final bool enabled;

  const DrinkLogVolumeField({
    super.key,
    required this.controller,
    required this.predefinedVolumes,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Volume (ml)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter a volume.';
          final volume = int.tryParse(value);
          return volume == null || volume <= 0
              ? 'Please enter a valid number.'
              : null;
        },
      ),
      if (predefinedVolumes.isNotEmpty) ...[
        const Gap(8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) => Row(
            spacing: 8,
            children: [
              for (final entry in predefinedVolumes.entries)
                Expanded(
                  child: int.tryParse(value.text) == entry.value
                      ? FilledButton(
                          onPressed: enabled
                              ? () => controller.text = entry.value.toString()
                              : null,
                          child: Text(entry.key),
                        )
                      : OutlinedButton(
                          onPressed: enabled
                              ? () => controller.text = entry.value.toString()
                              : null,
                          child: Text(entry.key),
                        ),
                ),
            ],
          ),
        ),
      ],
    ],
  );
}
