import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';

const _divider = Divider(height: 1);

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Settings'),
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
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDrinkSettingsBox(BuildContext context) {
    return _buildSettingsBox(
      context: context,
      children: [
        _buildSettingsCard(
          title: 'Custom drinks',
          onTap: () => const CustomDrinkTypesRoute().push<void>(context),
        ),
        _divider,
        _buildSettingsCard(
          title: 'Default drink',
          onTap: () => const DefaultDrinkSettingsRoute().push<void>(context),
        ),
        _divider,
        _buildSettingsCard(
          title: 'Drink list order',
          onTap: () => const DrinkSortSettingsRoute().push<void>(context),
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
          title: 'Change username',
          onTap: () => const UsernameSettingsRoute().push<void>(context),
        ),
        _divider,
        _buildSettingsCard(
          title: 'Change avatar',
          onTap: () => const ChangeAvatarSettingsRoute().push<void>(context),
        ),
        _divider,
        _buildSettingsCard(
          title: 'Badge visibility',
          onTap: () => const BadgeVisibilityRoute().push<void>(context),
        ),
        if (hasPassword) ...[
          _divider,
          _buildSettingsCard(
            title: 'Change password',
            onTap: () => const ChangePasswordRoute().push<void>(context),
          ),
        ],
      ],
    );
  }

  Widget _buildExperienceSettingsBox(BuildContext context) {
    return _buildSettingsBox(
      context: context,
      children: [
        _buildSettingsCard(
          title: 'End of day boundary',
          onTap: () => const EndOfDaySettingsRoute().push<void>(context),
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
