import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/constants.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = get<AuthService>();
  final _userService = get<UserService>();
  final _userSettingsService = get<UserSettingsService>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Create Account'),
      padding: const EdgeInsets.all(24),
      child: LoadingForm(
        errorMapper: (e) => e is FirebaseAuthException
            ? mapFirebaseAuthError(e.code)
            : e.toString(),
        builder: (form) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailField(form),
            gap16,
            _buildUsernameField(form),
            gap16,
            _buildPasswordField(form),
            gap8,
            PasswordRequirements(password: _passwordController.text),
            gap16,
            _buildConfirmPasswordField(form),
            form.buildErrorMessage(),
            gap24,
            form.buildSubmitButton(
              text: 'Create Account',
              onSubmit: () => _register(context),
            ),
            gap16,
            _buildLoginLink(context, form),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(LoadingFormState form) {
    return form.buildTextField(
      controller: _emailController,
      label: 'Email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email.';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _passwordController,
      label: 'Password',
      obscureText: _obscurePassword,
      onToggleVisibility: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password.';
        }
        if (!isPasswordValid(value)) {
          return 'Password does not meet requirements.';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _confirmPasswordController,
      label: 'Confirm Password',
      obscureText: _obscurePassword,
      onToggleVisibility: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      isLastField: true,
      onFieldSubmitted: () => _register(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password.';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }

  Widget _buildUsernameField(LoadingFormState form) {
    return form.buildTextField(
      controller: _usernameController,
      label: 'Username',
      prefixIcon: Icons.person_outline,
      helperText: 'This is how other users will see you.',
      maxLength: maxUsernameLength,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a username.';
        }
        if (value.trim().length < minUsernameLength) {
          return 'Username must be at least $minUsernameLength characters.';
        }
        return null;
      },
    );
  }

  Widget _buildLoginLink(BuildContext context, LoadingFormState form) {
    return TextButton(
      onPressed: form.isLoading ? null : () => Navigator.of(context).pop(),
      child: const Text('Already have an account? Login'),
    );
  }

  Future<void> _register(BuildContext context) async {
    await _authService.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    await _userSettingsService.createDefaultUserSettings();
    await _userService.createDefaultUser(
      username: _usernameController.text.trim(),
    );

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
