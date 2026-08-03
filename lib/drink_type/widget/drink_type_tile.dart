import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkTypeTile extends StatelessWidget {
  final DrinkType drinkType;

  DrinkTypeTile({super.key, required this.drinkType});

  final _drinkTypeController = get<DrinkTypeController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DrinkIcon(category: drinkType.category),
      title: Text(drinkType.name),
      subtitle: Text('ABV: ${drinkType.alcoholPercentage}%'),
      trailing: Transform.translate(
        offset: const Offset(10, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => UpdateDrinkTypeRoute(
                drinkTypeId: drinkType.id,
              ).push<void>(context),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink Type',
      text: 'Are you sure you want to delete "${drinkType.name}"?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async => _drinkTypeController.deleteSingle(drinkType),
    );
  }
}
