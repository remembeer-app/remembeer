import 'dart:async';
import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/auth/widget/email_field.dart';
import 'package:remembeer/auth/widget/password_field.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/legal/widget/privacy_policy_notice.dart';
import 'package:remembeer/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _convexAuthService = get<ConvexAuthService>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _obscurePassword = true;
  var _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageTemplate(
      padding: const EdgeInsets.all(24),
      child: AppForm(
        isSubmitting: _isSubmitting,
        error: _error,
        submitLabel: 'Sign In',
        submitButtonLabel: 'Sign In',
        submittingLabel: 'Signing in...',
        onSubmit: () => unawaited(_login()),
        builder: (context, submit) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const Gap(48),
            EmailField(controller: _emailController, enabled: !_isSubmitting),
            const Gap(16),
            PasswordField.login(
              controller: _passwordController,
              enabled: !_isSubmitting,
              obscureText: _obscurePassword,
              onToggleVisibility: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onFieldSubmitted: (_) => submit(),
            ),
            const Gap(12),
            const PrivacyPolicyNotice(),
            const Gap(16),
            TextButton(
              onPressed: _isSubmitting
                  ? null
                  : () => const RegisterRoute().push<void>(context),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        DrinkIcon(
          category: const Beer(),
          size: 100,
          color: theme.colorScheme.primary,
        ),
        const Gap(8),
        Text(
          'Remembeer',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const Gap(8),
        Text(
          'Track your drinks, compete with friends',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _login() async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await _convexAuthService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) showSuccessNotification('Logged in with Better Auth.');
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
