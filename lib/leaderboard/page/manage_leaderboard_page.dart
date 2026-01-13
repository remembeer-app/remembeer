import 'package:flutter/material.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/page/update_leaderboard_name_page.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/widget/banned_member_card.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_icon_picker.dart';
import 'package:remembeer/leaderboard/widget/member_card.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';

class ManageLeaderboardPage extends StatelessWidget {
  final Leaderboard leaderboard;

  ManageLeaderboardPage({super.key, required this.leaderboard});

  final _userController = get<UserController>();
  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Manage Leaderboard'),
      child: AsyncBuilder<Leaderboard>(
        stream: _leaderboardService.streamById(leaderboard.id),
        builder: (context, currentLeaderboard) {
          return Column(
            children: [
              _buildHeader(context, currentLeaderboard),
              gap24,
              _buildMembersSection(context, currentLeaderboard),
              gap16,
              _buildDeleteButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Leaderboard currentLeaderboard) {
    final theme = Theme.of(context);
    final icon = LeaderboardIcon.fromName(currentLeaderboard.iconName);

    return Column(
      children: [
        gap16,
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
        gap16,
        InkWell(
          onTap: () => _navigateToUpdateName(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLeaderboard.name,
                style: theme.textTheme.headlineSmall,
              ),
              hGap8,
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
    Leaderboard currentLeaderboard,
  ) {
    var selectedIcon = LeaderboardIcon.fromName(currentLeaderboard.iconName);

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Choose Icon'),
          content: LeaderboardIconPicker(
            selectedIcon: selectedIcon,
            onIconSelected: (icon) {
              setDialogState(() => selectedIcon = icon);
            },
          ),
          scrollable: true,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _leaderboardService.updateLeaderboardIcon(
                  leaderboard: leaderboard,
                  newIconName: selectedIcon.name,
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersSection(
    BuildContext context,
    Leaderboard currentLeaderboard,
  ) {
    return Expanded(
      child: ListView(
        children: [
          _buildSectionHeader(
            context,
            'Members (${currentLeaderboard.memberIds.length})',
          ),
          _buildMembersList(currentLeaderboard),
          if (currentLeaderboard.bannedMemberIds.isNotEmpty) ...[
            gap24,
            _buildSectionHeader(
              context,
              'Banned (${currentLeaderboard.bannedMemberIds.length})',
            ),
            _buildBannedMembersList(currentLeaderboard),
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

  void _navigateToUpdateName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            UpdateLeaderboardNamePage(leaderboard: leaderboard),
      ),
    );
  }

  Widget _buildMembersList(Leaderboard currentLeaderboard) {
    final memberIds = currentLeaderboard.memberIds.toList();
    final ownerId = currentLeaderboard.userId;

    return Column(
      children: memberIds.map((userId) {
        final isOwner = userId == ownerId;

        return AsyncBuilder<UserModel>(
          future: _userController.findById(userId),
          builder: (context, user) {
            return MemberCard(
              user: user,
              isOwner: isOwner,
              onRemove: () => _showRemoveConfirmationDialog(context, user),
              onBan: () => _showBanConfirmationDialog(context, user),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildBannedMembersList(Leaderboard currentLeaderboard) {
    final bannedMemberIds = currentLeaderboard.bannedMemberIds.toList();

    return Column(
      children: bannedMemberIds.map((userId) {
        return AsyncBuilder<UserModel>(
          future: _userController.findById(userId),
          builder: (context, user) {
            return BannedMemberCard(
              user: user,
              onUnban: () => _showUnbanConfirmationDialog(context, user),
            );
          },
        );
      }).toList(),
    );
  }

  void _showRemoveConfirmationDialog(BuildContext context, UserModel user) {
    showConfirmationDialog(
      context: context,
      title: 'Remove Member',
      text:
          'Are you sure you want to remove "${user.username}" from the leaderboard?',
      submitButtonText: 'Remove',
      onPressed: () => _leaderboardService.removeMember(
        leaderboard: leaderboard,
        memberId: user.id,
      ),
    );
  }

  void _showBanConfirmationDialog(BuildContext context, UserModel user) {
    showConfirmationDialog(
      context: context,
      title: 'Ban Member',
      text:
          'Are you sure you want to ban "${user.username}" from the leaderboard?',
      submitButtonText: 'Ban',
      onPressed: () => _leaderboardService.banMember(
        leaderboard: leaderboard,
        memberId: user.id,
      ),
    );
  }

  void _showUnbanConfirmationDialog(BuildContext context, UserModel user) {
    showConfirmationDialog(
      context: context,
      title: 'Unban Member',
      text:
          'Are you sure you want to unban "${user.username}"? They will be able to rejoin the leaderboard.',
      submitButtonText: 'Unban',
      onPressed: () => _leaderboardService.unbanMember(
        leaderboard: leaderboard,
        memberId: user.id,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () => _showDeleteConfirmationDialog(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error),
      ),
      icon: const Icon(Icons.delete),
      label: const Text('Delete Leaderboard'),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Delete Leaderboard',
      text:
          'Are you sure you want to delete "${leaderboard.name}"? '
          'This action cannot be undone.',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async {
        await _leaderboardService.deleteLeaderboard(leaderboard);
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }
}
