import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/session_form.dart';

class EditSessionPage extends StatelessWidget {
  final String sessionId;

  EditSessionPage({super.key, required this.sessionId});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<Session>(
      stream: _sessionService.sessionStream(sessionId),
      builder: _buildPage,
    );
  }

  Widget _buildPage(BuildContext context, Session session) {
    final colorScheme = Theme.of(context).colorScheme;

    return PageTemplate(
      title: Text(session.isParty ? 'Edit Party' : 'Edit Session'),
      appBarBackgroundColor: session.isParty
          ? colorScheme.errorContainer
          : null,
      appBarForegroundColor: session.isParty
          ? colorScheme.onErrorContainer
          : null,
      child: Column(
        children: [
          _buildPartyButton(context, session),
          const Gap(16),
          Expanded(
            child: SessionForm(
              initialName: session.name,
              initialDescription: session.description,
              initialStartedAt: session.startedAt,
              submitButtonText: 'Save Changes',
              onSubmit: (name, description, startedAt) async {
                await _sessionService.updateSession(
                  session: session,
                  name: name,
                  description: description,
                  startedAt: startedAt,
                );
                if (context.mounted) {
                  context.pop();
                }
              },
              additionalActions: _buildAdditionalActions(context, session),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalActions(BuildContext context, Session session) {
    return Column(
      children: [
        _buildManageAdminsButton(context, session),
        const Gap(16),
        Row(
          children: [
            Expanded(child: _buildDeleteButton(context, session)),
            const Gap(16),
            Expanded(child: _buildEndTimeButton(context, session)),
          ],
        ),
      ],
    );
  }

  Widget _buildPartyButton(BuildContext context, Session session) {
    final isEligible = !session.isSoloSession && session.endedAt == null;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: session.isParty
            ? () => PartyRoute(sessionId: session.id).go(context)
            : !isEligible
            ? null
            : () => _showPartyConfirmationDialog(context, session),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
        icon: Icon(session.isParty ? Icons.open_in_full : Icons.celebration),
        label: Text(
          session.isParty
              ? 'Open Party'
              : isEligible
              ? 'Turn into Party'
              : 'Party Mode Unavailable',
        ),
      ),
    );
  }

  Widget _buildManageAdminsButton(BuildContext context, Session session) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            ManageSessionAdminsRoute(sessionId: session.id).push<void>(context),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text('Manage Admins'),
      ),
    );
  }

  Widget _buildEndTimeButton(BuildContext context, Session session) {
    final isOngoing = session.endedAt == null;

    // TODO(ohtenkay): This entire page needs a design review.
    return OutlinedButton.icon(
      onPressed: () => _showEndTimeDialog(context, session),
      icon: Icon(isOngoing ? Icons.check_circle_outline : Icons.event),
      label: Text(
        isOngoing
            ? 'Mark as Done'
            : 'Ended ${formatDayMonthTime(session.endedAt!)}',
      ),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
    );
  }

  Widget _buildDeleteButton(BuildContext context, Session session) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () => _showDeleteConfirmationDialog(context, session),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error),
        padding: const EdgeInsets.all(16),
      ),
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Session session) {
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
          const DrinkRoute().go(context);
        }
      },
    );
  }

  void _showPartyConfirmationDialog(BuildContext context, Session session) {
    showConfirmationDialog(
      context: context,
      title: 'Turn Session into Party',
      text:
          'This cannot be undone. All drinks already recorded in the session '
          'will count toward the party ranking, and session admins will also '
          'be party admins.',
      submitButtonText: 'Enable Party Mode',
      onPressed: () async {
        await _sessionService.turnSessionIntoParty(session);
        showSuccessNotification('Party mode enabled!');
        if (context.mounted) {
          PartyRoute(sessionId: session.id).go(context);
        }
      },
    );
  }

  Future<void> _showEndTimeDialog(BuildContext context, Session session) async {
    final isOngoing = session.endedAt == null;
    var selectedEndTime = session.endedAt ?? DateTime.now();

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
                  const Gap(16),
                  InkWell(
                    onTap: () async {
                      final newTime = await _selectDateTime(
                        context,
                        session,
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
                          const Gap(12),
                          Text(formatFullDateTime(selectedEndTime)),
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
        context.pop();
      }
    }
  }

  Future<DateTime?> _selectDateTime(
    BuildContext context,
    Session session,
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
