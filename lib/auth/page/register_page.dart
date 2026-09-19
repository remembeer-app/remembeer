import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/auth/constants.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/legal/widget/privacy_policy_notice.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _betterAuthClient = get<BetterAuthClient>();

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
        errorMapper: (e) => switch (e) {
          BetterAuthException(:final message) => message,
          _ => e.toString(),
        },
        builder: (form) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEmailField(form),
              const Gap(16),
              _buildUsernameField(form),
              const Gap(16),
              _buildPasswordField(form),
              const Gap(8),
              PasswordRequirements(password: _passwordController.text),
              const Gap(16),
              _buildConfirmPasswordField(form),
              form.buildErrorMessage(),
              const Gap(24),
              form.buildSubmitButton(
                text: 'Create Account',
                onSubmit: _register,
              ),
              const Gap(16),
              _buildLoginLink(context, form),
              const Gap(8),
              const PrivacyPolicyNotice(),
            ],
          ),
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
      onFieldSubmitted: _register,
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
      onPressed: form.isLoading ? null : () => const LoginRoute().go(context),
      child: const Text('Already have an account? Login'),
    );
  }

  Future<void> _register() async {
    await _betterAuthClient.signUp(
      name: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    showSuccessNotification('Account created with Better Auth.');
  }
}
