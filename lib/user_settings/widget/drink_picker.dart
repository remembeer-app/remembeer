import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/schema.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';

class DrinkPicker extends StatelessWidget {
  final DrinkId? value;
  final List<ListAvailableResultItem> drinks;
  final Object? error;
  final ValueChanged<DrinkId> onChanged;

  const DrinkPicker({
    super.key,
    required this.value,
    required this.drinks,
    required this.error,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (drinks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_bar_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const Gap(16),
            Text(
              'No drinks available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    final selectedDrinkId = drinks.any((drink) => drink.id == value)
        ? value
        : null;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<DrinkId>(
            key: ValueKey((selectedDrinkId, error)),
            initialValue: selectedDrinkId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Drink',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final drink in drinks)
                DropdownMenuItem(
                  value: drink.id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DrinkIcon(
                        category: drink.drinkCategory.legacyCategory,
                        size: 24,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          drink.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            onChanged: (drinkId) {
              if (drinkId != null) onChanged(drinkId);
            },
          ),
          if (error case final error?) ...[
            const Gap(16),
            ErrorMessageBox(message: error.toString()),
          ],
        ],
      ),
    );
  }
}
