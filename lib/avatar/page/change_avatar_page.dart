import 'package:flutter/material.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
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
      hint: 'Choose a photo from your gallery.',
      child: AsyncBuilder(
        stream: _userService.currentUserStream,
        builder: (context, user) {
          return Column(
            children: [
              _buildAvatarPreview(user),
              gap24,
              if (_errorMessage != null) ...[
                _buildErrorMessage(context),
                gap16,
              ],
              _buildActionButtons(context, user),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarPreview(UserModel user) {
    return Stack(
      alignment: Alignment.center,
      children: [
        UserAvatar(user: user, size: 80),
        if (_isLoading)
          const Positioned.fill(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.black38,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: _isLoading ? null : _pickAvatar,
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Choose from Gallery'),
        ),
        gap12,
      ],
    );
  }

  Future<void> _pickAvatar() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _avatarService.changeAvatar(context: context);

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
}
