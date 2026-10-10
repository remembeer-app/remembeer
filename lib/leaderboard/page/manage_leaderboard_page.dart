import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/widget/banned_member_card.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_icon_picker.dart';
import 'package:remembeer/leaderboard/widget/member_card.dart';
import 'package:remembeer/routes.dart';

class ManageLeaderboardPage extends StatelessWidget {
  final String leaderboardId;

  const ManageLeaderboardPage({super.key, required this.leaderboardId});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Manage Leaderboard'),
      child: UserCurrentQuery(
        builder: (_, user) => LeaderboardGetTypeQuery(
          id: LeaderboardId(leaderboardId),
          builder: (_, result) {
            if (result.leaderboard.ownerId != user.id) {
              return const Center(
                child: Text('Only the owner can manage this leaderboard.'),
              );
            }
            return Column(
              children: [
                _buildHeader(context, result.leaderboard),
                const Gap(24),
                _buildMembersSection(context, result),
                const Gap(16),
                _buildDeleteButton(context, result.leaderboard),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
  ) {
    final theme = Theme.of(context);
    final icon = LeaderboardIcon.fromName(currentLeaderboard.iconName);

    return Column(
      children: [
        const Gap(16),
        InkWell(
          onTap: () => _showIconPickerDialog(context, currentLeaderboard),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  icon.icon,
                  size: 48,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.surface,
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        InkWell(
          onTap: () => _navigateToUpdateName(context, currentLeaderboard),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLeaderboard.name,
                style: theme.textTheme.headlineSmall,
              ),
              const Gap(8),
              Icon(
                Icons.edit,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showIconPickerDialog(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
  ) {
    var selectedIcon = LeaderboardIcon.fromName(currentLeaderboard.iconName);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => LeaderboardUpdateMutation(
        builder: (_, update, snapshot) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Choose Icon'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LeaderboardIconPicker(
                  selectedIcon: selectedIcon,
                  onIconSelected: (icon) =>
                      setDialogState(() => selectedIcon = icon),
                ),
                if (snapshot.error case final error?)
                  ErrorMessageBox(message: error.toString()),
              ],
            ),
            scrollable: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: snapshot.isLoading
                    ? null
                    : () => update.run(
                        id: currentLeaderboard.id,
                        iconName: Optional.of(
                          UpdateArgsIconName.fromJson(selectedIcon.name),
                        ),
                        onSuccess: (_) {
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                      ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersSection(
    BuildContext context,
    GetTypeResult currentLeaderboard,
  ) {
    return Expanded(
      child: ListView(
        children: [
          _buildSectionHeader(
            context,
            'Members (${currentLeaderboard.members.length})',
          ),
          _buildMembersList(context, currentLeaderboard),
          if (currentLeaderboard.bannedMembers.isNotEmpty) ...[
            const Gap(24),
            _buildSectionHeader(
              context,
              'Banned (${currentLeaderboard.bannedMembers.length})',
            ),
            _buildBannedMembersList(context, currentLeaderboard),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateToUpdateName(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
  ) {
    UpdateLeaderboardNameRoute(
      leaderboardId: currentLeaderboard.id.value,
    ).push<void>(context);
  }

  Widget _buildMembersList(BuildContext context, GetTypeResult result) =>
      Column(
        children: result.members
            .map(
              (user) => LeaderboardRemoveMutation(
                key: ValueKey(user.id),
                builder: (_, remove, removeState) => LeaderboardBanMutation(
                  builder: (_, ban, banState) {
                    final busy = removeState.isLoading || banState.isLoading;
                    return Column(
                      children: [
                        MemberCard(
                          user: user,
                          isOwner: user.id == result.leaderboard.ownerId,
                          onRemove: busy
                              ? null
                              : () => _showRemoveConfirmationDialog(
                                  context,
                                  result.leaderboard,
                                  user,
                                  remove,
                                ),
                          onBan: busy
                              ? null
                              : () => _showBanConfirmationDialog(
                                  context,
                                  result.leaderboard,
                                  user,
                                  ban,
                                ),
                        ),
                        if (removeState.error ?? banState.error
                            case final error?)
                          ErrorMessageBox(message: error.toString()),
                      ],
                    );
                  },
                ),
              ),
            )
            .toList(),
      );

  Widget _buildBannedMembersList(BuildContext context, GetTypeResult result) =>
      Column(
        children: result.bannedMembers
            .map(
              (user) => LeaderboardUnbanMutation(
                key: ValueKey(user.id),
                builder: (_, unban, snapshot) => Column(
                  children: [
                    BannedMemberCard(
                      user: user,
                      onUnban: snapshot.isLoading
                          ? null
                          : () => _showUnbanConfirmationDialog(
                              context,
                              result.leaderboard,
                              user,
                              unban,
                            ),
                    ),
                    if (snapshot.error case final error?)
                      ErrorMessageBox(message: error.toString()),
                  ],
                ),
              ),
            )
            .toList(),
      );

  void _showRemoveConfirmationDialog(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
    GetTypeResultMembersItem user,
    LeaderboardRemoveMutationExecutor remove,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Remove Member',
      text:
          'Are you sure you want to remove "${user.username}" from the leaderboard?',
      submitButtonText: 'Remove',
      onPressed: () async {
        remove.run(id: currentLeaderboard.id, userId: user.id);
      },
    );
  }

  void _showBanConfirmationDialog(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
    GetTypeResultMembersItem user,
    LeaderboardBanMutationExecutor ban,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Ban Member',
      text:
          'Are you sure you want to ban "${user.username}" from the leaderboard?',
      submitButtonText: 'Ban',
      onPressed: () async {
        ban.run(id: currentLeaderboard.id, userId: user.id);
      },
    );
  }

  void _showUnbanConfirmationDialog(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
    GetTypeResultBannedMembersItem user,
    LeaderboardUnbanMutationExecutor unban,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Unban Member',
      text:
          'Are you sure you want to unban "${user.username}"? They will be able to rejoin the leaderboard.',
      submitButtonText: 'Unban',
      onPressed: () async {
        unban.run(id: currentLeaderboard.id, userId: user.id);
      },
    );
  }

  Widget _buildDeleteButton(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
  ) {
    final theme = Theme.of(context);

    return LeaderboardSoftDeleteMutation(
      builder: (_, remove, snapshot) => Column(
        children: [
          if (snapshot.error case final error?)
            ErrorMessageBox(message: error.toString()),
          OutlinedButton.icon(
            onPressed: snapshot.isLoading
                ? null
                : () => _showDeleteConfirmationDialog(
                    context,
                    currentLeaderboard,
                    remove,
                  ),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
            icon: const Icon(Icons.delete),
            label: const Text('Delete Leaderboard'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    LeaderboardDocument currentLeaderboard,
    LeaderboardSoftDeleteMutationExecutor remove,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Leaderboard',
      text:
          'Are you sure you want to delete "${currentLeaderboard.name}"? '
          'This action cannot be undone.',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async {
        remove.run(
          id: currentLeaderboard.id,
          onSuccess: (_) {
            if (context.mounted) const LeaderboardsRoute().go(context);
          },
        );
      },
    );
  }
}
