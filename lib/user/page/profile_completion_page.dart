import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/gender.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/profile_details_form.dart';

class ProfileCompletionPage extends StatelessWidget {
  ProfileCompletionPage({super.key});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Complete your profile'),
      padding: const EdgeInsets.all(24),
      child: AsyncBuilder(
        future: _userService.currentUser,
        builder: (context, user) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'One last step',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Choose the profile details used for Party Mode. You can '
                'change both later in Settings.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(24),
              Expanded(
                child: ProfileDetailsForm(
                  initialGender: user.gender,
                  initialAccentColorKey:
                      user.accentColorKey ?? defaultAccentColorFor(user.id),
                  submitText: 'Continue',
                  onSubmit: (gender, accentColorKey) =>
                      _completeProfile(context, gender, accentColorKey),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _completeProfile(
    BuildContext context,
    Gender gender,
    AccentColorKey accentColorKey,
  ) async {
    await _userService.updateProfile(
      gender: gender,
      accentColorKey: accentColorKey,
    );
    if (context.mounted) {
      const DrinkRoute().go(context);
    }
  }
}
