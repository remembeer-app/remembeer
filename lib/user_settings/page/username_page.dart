import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final _userService = get<UserService>();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _userService.currentUser;
    if (mounted) {
      _usernameController.text = user.username;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingForm(
      builder: (form) => SettingsPageTemplate(
        title: const Text('Change your username'),
        hint:
            'This is your displayed username. Other users can find you by '
            'searching for this username or your email.',
        onFabPressed: form.isLoading ? null : () => _submitForm(form),
        child: Column(children: [_buildUsernameInput(form)]),
      ),
    );
  }

  Widget _buildUsernameInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _usernameController,
      label: 'Username',
      prefixIcon: Icons.person_outline,
      maxLength: maxUsernameLength,
      isLastField: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username cannot be empty.';
        }
        if (value.trim().length < minUsernameLength) {
          return 'Username must be at least $minUsernameLength characters long.';
        }
        return null;
      },
    );
  }

  Future<void> _submitForm(LoadingFormState form) async {
    if (!form.validate()) return;

    await form.runAction(() async {
      await _userService.updateUsername(newUsername: _usernameController.text);
      if (mounted) {
        context.pop();
      }
    });
  }
}
