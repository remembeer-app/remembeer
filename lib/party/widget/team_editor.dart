import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/beerpongTeam.dart';
import 'package:remembeer/party/widget/party_creation_forms.dart';

class TeamEditor extends StatelessWidget {
  const TeamEditor({
    super.key,
    required this.team,
    required this.teams,
    required this.members,
    required this.canEdit,
    this.placement,
  });
  final BeerpongTeamDocument team;
  final List<BeerpongTeamDocument> teams;
  final List<ListForSessionResultItem> members;
  final bool canEdit;
  final int? placement;

  @override
  Widget build(BuildContext context) => Card(
    child: ExpansionTile(
      title: Text(team.name),
      subtitle: placement == null ? null : Text('Place #$placement'),
      children: [
        if (canEdit)
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => _RenameTeam(team: team),
            ),
            child: const Text('Rename team'),
          ),
        BeerpongTeamRemoveMemberMutation(
          builder: (context, remove, removeState) =>
              BeerpongTeamMoveMemberMutation(
                builder: (context, move, moveState) => Column(
                  children: [
                    if (removeState.error ?? moveState.error case final error?)
                      ErrorMessageBox(message: error.toString()),
                    for (final userId in team.memberUserIds)
                      ListTile(
                        title: Text(
                          members
                                  .where(
                                    (entry) => entry.member.userId == userId,
                                  )
                                  .firstOrNull
                                  ?.username ??
                              'Unavailable user',
                        ),
                        trailing: !canEdit
                            ? null
                            : PopupMenuButton<BeerpongTeamId>(
                                enabled:
                                    !removeState.isLoading &&
                                    !moveState.isLoading,
                                onSelected: (target) {
                                  if (target == team.id) {
                                    showConfirmationDialog(
                                      context: context,
                                      title: 'Remove player?',
                                      text: 'The player will leave this team.',
                                      submitButtonText: 'Remove',
                                      isDestructive: true,
                                      onPressed: () async {
                                        await remove(
                                          id: team.id,
                                          userId: userId,
                                        );
                                      },
                                    );
                                  } else {
                                    move.run(
                                      id: team.id,
                                      targetTeamId: target,
                                      userId: userId,
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  for (final target in teams.where(
                                    (other) => other.id != team.id,
                                  ))
                                    PopupMenuItem(
                                      value: target.id,
                                      child: Text('Move to ${target.name}'),
                                    ),
                                  PopupMenuItem(
                                    value: team.id,
                                    child: const Text('Remove from team'),
                                  ),
                                ],
                              ),
                      ),
                  ],
                ),
              ),
        ),
        if (canEdit)
          BeerpongTeamAddMemberMutation(
            builder: (context, add, state) => Column(
              children: [
                if (state.error case final error?)
                  ErrorMessageBox(message: error.toString()),
                for (final entry in members.where(
                  (entry) =>
                      entry.member.sessionMemberStatus.isJoined &&
                      !teams.any(
                        (team) =>
                            team.memberUserIds.contains(entry.member.userId),
                      ),
                ))
                  ListTile(
                    title: Text(entry.username),
                    trailing: TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () => add.run(
                              id: team.id,
                              userId: entry.member.userId,
                            ),
                      child: const Text('Add to team'),
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}

class _RenameTeam extends StatefulWidget {
  const _RenameTeam({required this.team});
  final BeerpongTeamDocument team;
  @override
  State<_RenameTeam> createState() => _RenameTeamState();
}

class _RenameTeamState extends State<_RenameTeam> {
  late final _name = TextEditingController(text: widget.team.name);
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Rename team'),
    content: BeerpongTeamRenameMutation(
      builder: (context, rename, state) => LoadingForm(
        builder: (form) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            form.buildTextField(
              controller: _name,
              label: 'Name',
              validator: requiredText,
            ),
            const Gap(12),
            form.buildErrorMessage(),
            form.buildSubmitButton(
              text: 'Save',
              onSubmit: () async {
                await rename(id: widget.team.id, name: _name.text.trim());
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
