import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({super.key});

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  final _avatarService = get<AvatarService>();
  final _userService = get<UserService>();

  var _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Change Avatar'),
      hint:
          'Choose a photo from your gallery or take a new one to set as your avatar. '
          'You can also remove your current avatar to revert to the default one.',
      child: AsyncBuilder(
        stream: _userService.currentUserStream,
        builder: (context, user) {
          return Column(
            children: [
              _buildAvatarPreview(user),
              gap48,
              if (_errorMessage != null) ...[
                _buildErrorMessage(context),
                gap16,
              ],
              _buildActionGrid(context, user),
              const Spacer(),
              if (user.avatarUrl != null) _buildRemoveButton(context),
              gap24,
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarPreview(UserModel user) {
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
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: UserAvatar(user: user, size: 100),
        ),

        if (_isLoading)
          const Positioned.fill(
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.black38,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context, UserModel user) {
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
          hGap16,
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
                gap12,
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
        Navigator.of(context).pop();
      }
    } on Exception catch (_) {
      setState(() => _errorMessage = 'Failed to update avatar');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          hGap12,
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
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
            Navigator.of(context).pop();
          }
        } on Exception catch (_) {
          setState(() => _errorMessage = 'Failed to remove avatar');
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
    );
  }
}
