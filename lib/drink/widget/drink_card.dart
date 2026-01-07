import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/page/update_drink_page.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkCard extends StatelessWidget {
  final Drink drink;

  DrinkCard({super.key, required this.drink});

  final _drinkService = get<DrinkService>();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Drink>(
      data: drink,
      onDragStarted: () {
        DragStateProvider.of(context).setDragging(true);
      },
      onDragEnd: (_) {
        DragStateProvider.of(context).setDragging(false);
      },
      onDraggableCanceled: (_, _) {
        DragStateProvider.of(context).setDragging(false);
      },
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: Opacity(opacity: 0.9, child: _buildCard(context)),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildCard(context)),
      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: DrinkIcon(category: drink.drinkType.category),
        title: Text(
          drink.drinkType.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap4,
            _buildInfoRow(
              Icons.access_time,
              DateFormat('H:mm').format(drink.consumedAt),
            ),
            gap2,
            _buildInfoRow(Icons.local_drink, '${drink.volumeInMilliliters} ml'),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _showDeleteConfirmation(context),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => UpdateDrinkPage(drinkToUpdate: drink),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink',
      text: 'Are you sure you want to delete this ${drink.drinkType.name}?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async {
        await _drinkService.deleteDrink(drink);

        if (!context.mounted) return;
        showNotification(context, 'Drink deleted!');
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        hGap4,
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
