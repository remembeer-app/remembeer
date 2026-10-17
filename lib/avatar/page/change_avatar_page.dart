import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remembeer/avatar/constants.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/user.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({super.key});

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  final _avatarService = get<AvatarService>();

  var _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Change Avatar',
      autmaticallyImplyLeading: true,
      hint:
          'Choose a photo from your gallery or take a new one to set as your avatar. '
          'You can also remove your current avatar to revert to the default one.',
      child: UserCurrentQuery(
        builder: (context, user) {
          return Column(
            children: [
              _buildAvatarPreview(user),
              const Gap(48),
              if (_errorMessage != null) ...[
                ErrorMessageBox(message: _errorMessage!),
                const Gap(16),
              ],
              _buildActionGrid(context),
              const Spacer(),
              if (user.avatarUrl != null) _buildRemoveButton(context),
              const Gap(24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarPreview(CurrentResult user) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 100,
            backgroundImage: user.avatarUrl != null
                ? CachedNetworkImageProvider(user.avatarUrl!)
                : const AssetImage(defaultAvatarPath) as ImageProvider,
          ),
        ),

        if (_isLoading)
          Positioned.fill(
            child: CircleAvatar(
              radius: 100,
              backgroundColor: theme.colorScheme.scrim.withValues(alpha: 0.38),
              child: const CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          _buildSelectionTile(
            context,
            icon: Icons.photo_library_rounded,
            label: 'Gallery',
            onTap: _isLoading ? null : () => _pickAvatar(ImageSource.gallery),
          ),
          const Gap(16),
          _buildSelectionTile(
            context,
            icon: Icons.camera_alt_rounded,
            label: 'Camera',
            onTap: _isLoading ? null : () => _pickAvatar(ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: theme.colorScheme.primary),
                const Gap(12),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _removeAvatar,
      icon: Icon(
        Icons.delete_forever,
        color: theme.colorScheme.error,
        size: 20,
      ),
      label: Text(
        'Remove Avatar',
        style: TextStyle(color: theme.colorScheme.error),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.colorScheme.error),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    );
  }

  Future<void> _pickAvatar(ImageSource source) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _avatarService.changeAvatar(context, source);

      if (result != null && mounted) {
        context.pop();
      }
    } on Exception catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Failed to update avatar');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _removeAvatar() {
    showConfirmationDialog(
      context: context,
      title: 'Remove Avatar',
      text: 'Are you sure you want to remove your custom avatar?',
      isDestructive: true,
      submitButtonText: 'Remove',
      onPressed: () async {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

        try {
          await _avatarService.deleteAvatar();
          if (mounted) {
            context.pop();
          }
        } on Exception catch (_) {
          if (mounted) {
            setState(() => _errorMessage = 'Failed to remove avatar');
          }
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
    );
  }
}
