import 'dart:async';

import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/auth/widget/email_field.dart';
import 'package:remembeer/auth/widget/password_field.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/legal/widget/privacy_policy_notice.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user_settings/widget/username_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _convexAuthService = get<ConvexAuthService>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscurePassword = true;
  var _isSubmitting = false;
  String? _error;

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
      child: AppForm(
        isSubmitting: _isSubmitting,
        error: _error,
        submitLabel: 'Create Account',
        submitButtonLabel: 'Create Account',
        submittingLabel: 'Creating account...',
        onSubmit: () => unawaited(_register()),
        onBack: () => const LoginRoute().go(context),
        builder: (context, submit) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EmailField(controller: _emailController, enabled: !_isSubmitting),
            const Gap(16),
            UsernameField(
              controller: _usernameController,
              enabled: !_isSubmitting,
              textInputAction: TextInputAction.next,
            ),
            Text(
              'This is how other users will see you.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Gap(16),
            PasswordField.newPassword(
              controller: _passwordController,
              label: 'Password',
              enabled: !_isSubmitting,
              obscureText: _obscurePassword,
              onToggleVisibility: _togglePasswordVisibility,
              onChanged: (_) => setState(() {}),
            ),
            const Gap(8),
            PasswordRequirements(password: _passwordController.text),
            const Gap(16),
            PasswordField.confirmation(
              controller: _confirmPasswordController,
              passwordController: _passwordController,
              label: 'Confirm Password',
              enabled: !_isSubmitting,
              obscureText: _obscurePassword,
              onToggleVisibility: _togglePasswordVisibility,
              onFieldSubmitted: (_) => submit(),
            ),
            const Gap(16),
            OutlinedButton.icon(
              onPressed: _isSubmitting
                  ? null
                  : () => unawaited(_register(google: true)),
              icon: const Icon(Icons.account_circle_outlined),
              label: const Text('Continue with Google'),
            ),
            const Gap(8),
            TextButton(
              onPressed: _isSubmitting
                  ? null
                  : () => const LoginRoute().go(context),
              child: const Text('Already have an account? Sign In'),
            ),
            const Gap(8),
            const PrivacyPolicyNotice(),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _register({bool google = false}) async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      if (google) {
        if (!await _convexAuthService.signInWithGoogle()) return;
      } else {
        await _convexAuthService.signUp(
          name: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (mounted) {
        showSuccessNotification(google ? 'Logged in.' : 'Account created.');
      }
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _error = switch (error) {
          BetterAuthException(:final message) => message,
          _ => error.toString(),
        };
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
