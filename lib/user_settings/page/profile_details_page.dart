import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/gender.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/profile_details_form.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class ProfileDetailsPage extends StatelessWidget {
  ProfileDetailsPage({super.key});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Gender and accent'),
      hint: 'These details personalize Party Mode and can be changed anytime.',
      child: AsyncBuilder(
        future: _userService.currentUser,
        builder: (context, user) => ProfileDetailsForm(
          initialGender: user.gender,
          initialAccentColorKey: user.accentColorKey,
          submitText: 'Save changes',
          onSubmit: (gender, accentColorKey) =>
              _save(context, gender, accentColorKey),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    Gender gender,
    AccentColorKey accentColorKey,
  ) async {
    await _userService.updateProfile(
      gender: gender,
      accentColorKey: accentColorKey,
    );
    if (context.mounted) {
      showSuccessNotification('Profile updated.');
      context.pop();
    }
  }
}
