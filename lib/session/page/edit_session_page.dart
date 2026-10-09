import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/widget/session_form.dart';

class EditSessionPage extends StatelessWidget {
  const EditSessionPage({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Edit Session'),
    child: SessionGetTypeQuery(
      id: SessionId(sessionId),
      builder: (context, session) => UserCurrentQuery(
        builder: (context, user) => SessionMemberListForSessionQuery(
          sessionId: session.id,
          builder: (context, members) {
            final isOwner = session.ownerId == user.id;
            final isAdmin =
                isOwner ||
                members.any(
                  (member) =>
                      member.userId == user.id &&
                      member.sessionMemberStatus.isJoined &&
                      member.sessionMemberRole.isAdmin,
                );
            if (!isAdmin) {
              return const Center(
                child: Text('Only session admins can edit this session.'),
              );
            }
            return SessionUpdateMutation(
              builder: (context, update, updateState) => SessionSoftDeleteMutation(
                builder: (context, remove, deleteState) =>
                    SessionPromoteToPartyMutation(
                      builder: (context, promote, promoteState) {
                        final busy =
                            updateState.isLoading ||
                            deleteState.isLoading ||
                            promoteState.isLoading;
                        return SessionForm(
                          key: ValueKey((
                            session.name,
                            session.startedAt,
                            session.endedAt,
                          )),
                          initialName: session.name,
                          initialDescription: session.description,
                          initialStartedAt: DateTime.fromMillisecondsSinceEpoch(
                            session.startedAt.toInt(),
                          ),
                          submitButtonText: 'Save Changes',
                          enabled: !busy,
                          onSubmit: (name, description, startedAt) async {
                            await update(
                              id: session.id,
                              name: Optional.of(name),
                              description: Optional.of(description),
                              startedAt: Optional.of(
                                startedAt.millisecondsSinceEpoch.toDouble(),
                              ),
                            );
                            if (context.mounted) {
                              context.pop();
                            }
                          },
                          additionalActions: Column(
                            children: [
                              if (updateState.error ??
                                      deleteState.error ??
                                      promoteState.error
                                  case final error?)
                                ErrorMessageBox(message: error.toString()),
                              const Gap(8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (!session.isParty &&
                                      session.endedAt == null)
                                    OutlinedButton.icon(
                                      icon: const Icon(Icons.celebration),
                                      label: const Text('Turn into Party'),
                                      onPressed: busy
                                          ? null
                                          : () => showConfirmationDialog(
                                              context: context,
                                              title: 'Turn into Party',
                                              text:
                                                  'Turn this session into a party? This cannot be reversed.',
                                              submitButtonText:
                                                  'Turn into Party',
                                              onPressed: () async {
                                                promote.run(id: session.id);
                                              },
                                            ),
                                    ),
                                  if (isOwner)
                                    OutlinedButton.icon(
                                      icon: const Icon(
                                        Icons.admin_panel_settings,
                                      ),
                                      label: const Text('Manage Admins'),
                                      onPressed: busy
                                          ? null
                                          : () => ManageSessionAdminsRoute(
                                              sessionId: sessionId,
                                            ).push<void>(context),
                                    ),
                                  OutlinedButton.icon(
                                    icon: const Icon(
                                      Icons.check_circle_outline,
                                    ),
                                    label: Text(
                                      session.endedAt == null
                                          ? 'End session'
                                          : 'Reopen session',
                                    ),
                                    onPressed: busy
                                        ? null
                                        : () async {
                                            if (session.endedAt != null) {
                                              update.run(
                                                id: session.id,
                                                endedAt: const Optional.of(
                                                  null,
                                                ),
                                              );
                                              return;
                                            }
                                            final end = await _pickEndTime(
                                              context,
                                              session.startedAt,
                                            );
                                            if (end != null &&
                                                context.mounted) {
                                              update.run(
                                                id: session.id,
                                                endedAt: Optional.of(end),
                                              );
                                            }
                                          },
                                  ),
                                  if (isOwner)
                                    OutlinedButton.icon(
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Delete session'),
                                      onPressed: busy
                                          ? null
                                          : () => showConfirmationDialog(
                                              context: context,
                                              title: 'Delete session',
                                              text:
                                                  'Delete this session? Recorded drinks will be kept.',
                                              submitButtonText: 'Delete',
                                              isDestructive: true,
                                              onPressed: () async {
                                                remove.run(
                                                  id: session.id,
                                                  onSuccess: (_) {
                                                    if (context.mounted) {
                                                      const DrinkLogRoute().go(
                                                        context,
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),
      ),
    ),
  );

  Future<double?> _pickEndTime(BuildContext context, double startedAt) async {
    final start = DateTime.fromMillisecondsSinceEpoch(startedAt.toInt());
    final now = DateTime.now();
    final initial = start.isAfter(now) ? start : now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: start,
      lastDate: initial.add(const Duration(days: 1)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).millisecondsSinceEpoch.toDouble();
  }
}
