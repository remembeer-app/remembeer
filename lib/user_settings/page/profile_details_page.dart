import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/accent_color_form.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class ProfileDetailsPage extends StatelessWidget {
  ProfileDetailsPage({super.key});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Accent color'),
      hint:
          'Your accent identifies you in Party Mode and can be changed anytime.',
      child: AsyncBuilder(
        future: _userService.currentUser,
        builder: (context, user) => AccentColorForm(
          initialValue: user.accentColorKey,
          submitText: 'Save changes',
          onSubmit: (accentColorKey) => _save(context, accentColorKey),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    AccentColorKey accentColorKey,
  ) async {
    await _userService.updateAccentColor(accentColorKey);
    if (context.mounted) {
      showSuccessNotification('Accent color updated.');
      context.pop();
    }
  }
}
