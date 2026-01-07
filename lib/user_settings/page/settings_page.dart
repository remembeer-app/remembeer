import 'package:flutter/material.dart';
import 'package:remembeer/auth/page/change_password_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/page/custom_drink_types_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/page/badge_visibility_page.dart';
import 'package:remembeer/user_settings/page/default_drink_page.dart';
import 'package:remembeer/user_settings/page/drink_list_sort_page.dart';
import 'package:remembeer/user_settings/page/end_of_day_page.dart';
import 'package:remembeer/user_settings/page/username_page.dart';

const _divider = Divider(height: 1);

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading('Profile'),
          _buildProfileSettingsBox(context),
          _buildHeading('Drinks'),
          _buildDrinkSettingsBox(context),
          _buildHeading('Experience'),
          _buildExperienceSettingsBox(context),
          const Spacer(),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout, size: 20),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: _authService.signOut,
          label: const Text(
            'SIGN OUT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 4.0,
        left: 4.0,
        right: 4.0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required String title,
    required Widget destinationPage,
  }) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => destinationPage)),
    );
  }

  Widget _buildDrinkSettingsBox(BuildContext context) {
    return _buildSettingsBox(
      context: context,
      children: [
        _buildSettingsCard(
          context: context,
          title: 'Custom drinks',
          destinationPage: const CustomDrinkTypesPage(),
        ),
        _divider,
        _buildSettingsCard(
          context: context,
          title: 'Default drink',
          destinationPage: const DefaultDrinkPage(),
        ),
        _divider,
        _buildSettingsCard(
          context: context,
          title: 'Drink list order',
          destinationPage: const DrinkListSortPage(),
        ),
      ],
    );
  }

  Widget _buildProfileSettingsBox(BuildContext context) {
    final hasPassword = _authService.hasPasswordProvider;

    return _buildSettingsBox(
      context: context,
      children: [
        _buildSettingsCard(
          context: context,
          title: 'Change username',
          destinationPage: const UserNamePage(),
        ),
        if (hasPassword) ...[
          _divider,
          _buildSettingsCard(
            context: context,
            title: 'Change password',
            destinationPage: const ChangePasswordPage(),
          ),
        ],
        _divider,
        _buildSettingsCard(
          context: context,
          title: 'Badge visibility',
          destinationPage: const BadgeVisibilityPage(),
        ),
      ],
    );
  }

  Widget _buildExperienceSettingsBox(BuildContext context) {
    return _buildSettingsBox(
      context: context,
      children: [
        _buildSettingsCard(
          context: context,
          title: 'End of day boundary',
          destinationPage: const EndOfDayPage(),
        ),
      ],
    );
  }

  Widget _buildSettingsBox({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(children: children),
    );
  }
}
