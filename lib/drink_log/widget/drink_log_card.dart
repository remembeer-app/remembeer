import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/type/drink_log_with_session_id.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

class DrinkLogCard extends StatelessWidget {
  final DrinkLogWithSessionId drinkLogWithSessionId;

  DrinkLogCard({super.key, required this.drinkLogWithSessionId});

  final _drinkLogService = get<DrinkLogService>();

  DrinkLog get _drinkLog => drinkLogWithSessionId.drinkLog;

  @override
  Widget build(BuildContext context) {
    if (drinkLogWithSessionId.isParty) {
      return _buildCard(context);
    }
    return LongPressDraggable<DrinkLogWithSessionId>(
      data: drinkLogWithSessionId,
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
        leading: DrinkIcon(category: _drinkLog.drink.category),
        title: Text(
          _drinkLog.drink.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(4),
            _buildInfoRow(Icons.access_time, formatTime(_drinkLog.consumedAt)),
            const Gap(2),
            _buildInfoRow(
              Icons.local_drink,
              '${_drinkLog.volumeInMilliliters} ml',
            ),
          ],
        ),
        trailing: drinkLogWithSessionId.isReadOnly
            ? null
            : IconButton(
                onPressed: () => _showDeleteConfirmation(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
        onTap: drinkLogWithSessionId.isReadOnly
            ? null
            : () => UpdateDrinkLogRoute(
                sessionId: drinkLogWithSessionId.originalSessionId,
                drinkLogId: _drinkLog.id,
              ).push<void>(context),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink',
      text: 'Are you sure you want to delete this ${_drinkLog.drink.name}?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async {
        await _drinkLogService.deleteDrinkLog(
          drinkLogWithSessionId.originalSessionId,
          _drinkLog,
        );
        showSuccessNotification('Drink deleted!');
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        const Gap(4),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
