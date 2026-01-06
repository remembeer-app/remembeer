import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      child: Column(
        children: [
          Expanded(
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
            ),
          ),
          if (session.endedAt == null) ...[
            gap16,
            _buildMarkAsDoneButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildMarkAsDoneButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showMarkAsDoneDialog(context),
      icon: const Icon(Icons.check_circle_outline),
      label: const Text('Mark Session as Done'),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
    );
  }

  Future<void> _showMarkAsDoneDialog(BuildContext context) async {
    var selectedEndTime = DateTime.now();
    final timeFormat = DateFormat('dd MMM. yyyy, H:mm');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Mark Session as Done'),
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
                          hGap12,
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
      await _sessionService.markSessionAsDone(
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
