import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/session_form.dart';

class EditSessionPage extends StatelessWidget {
  final Session session;

  EditSessionPage({super.key, required this.session});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Edit Session'),
      child: SessionForm(
        initialName: session.name,
        initialStartedAt: session.startedAt,
        submitButtonText: 'Save Changes',
        onSubmit: (name, startedAt) async {
          await _sessionService.updateSession(
            session: session,
            name: name,
            startedAt: startedAt,
          );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        additionalActions: _buildAdditionalActions(context),
      ),
    );
  }

  Widget _buildAdditionalActions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDeleteButton(context)),
        const SizedBox(width: 16),
        Expanded(child: _buildEndTimeButton(context)),
      ],
    );
  }

  Widget _buildEndTimeButton(BuildContext context) {
    final isOngoing = session.endedAt == null;
    final dateFormat = DateFormat('d MMM, H:mm');

    // TODO(ohtenkay): This button date formatting is different from the form field. This entire page needs a design review.
    return OutlinedButton.icon(
      onPressed: () => _showEndTimeDialog(context),
      icon: Icon(isOngoing ? Icons.check_circle_outline : Icons.event),
      label: Text(
        isOngoing
            ? 'Mark as Done'
            : 'Ended ${dateFormat.format(session.endedAt!)}',
      ),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () => _showDeleteConfirmationDialog(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error),
        padding: const EdgeInsets.all(16),
      ),
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Session',
      text:
          'Are you sure you want to delete "${session.name}"? '
          'This action cannot be undone.',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async {
        await _sessionService.deleteSession(session);
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }

  Future<void> _showEndTimeDialog(BuildContext context) async {
    final isOngoing = session.endedAt == null;
    var selectedEndTime = session.endedAt ?? DateTime.now();
    final timeFormat = DateFormat('dd MMM. yyyy, H:mm');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isOngoing ? 'Mark Session as Done' : 'Edit End Time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('When did the session end?'),
                  gap16,
                  InkWell(
                    onTap: () async {
                      final newTime = await _selectDateTime(
                        context,
                        selectedEndTime,
                      );
                      if (newTime != null) {
                        setState(() => selectedEndTime = newTime);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          gap12,
                          Text(timeFormat.format(selectedEndTime)),
                          const Spacer(),
                          const Icon(Icons.edit_outlined, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    if ((confirmed ?? false) && context.mounted) {
      await _sessionService.updateSession(
        session: session,
        endedAt: selectedEndTime,
      );
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<DateTime?> _selectDateTime(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: session.startedAt,
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !context.mounted) {
      return null;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
    );
    if (pickedTime == null) {
      return null;
    }

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
