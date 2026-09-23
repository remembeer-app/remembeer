import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/model/drink_category.dart';
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
      child: LoadingForm(
        errorMapper: (e) => switch (e) {
          BetterAuthException(:final message) => message,
          _ => e.toString(),
        },
        builder: (form) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(theme),
              const Gap(48),
              _buildFormContent(form),
              const Gap(12),
              const PrivacyPolicyNotice(),
              const Gap(16),
              _buildRegisterLink(context, form),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        DrinkIcon(
          category: DrinkCategory.beer,
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

  Widget _buildFormContent(LoadingFormState form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        form.buildTextField(
          controller: _emailController,
          label: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email.';
            }
            return null;
          },
        ),
        const Gap(16),
        _buildPasswordField(form),
        form.buildErrorMessage(),
        const Gap(16),
        form.buildSubmitButton(text: 'Login', onSubmit: _login),
      ],
    );
  }

  Widget _buildPasswordField(LoadingFormState form) {
    return form.buildPasswordField(
      controller: _passwordController,
      label: 'Password',
      obscureText: _obscurePassword,
      onToggleVisibility: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      isLastField: true,
      onFieldSubmitted: () => form.runAction(_login),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password.';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterLink(BuildContext context, LoadingFormState form) {
    return TextButton(
      onPressed: form.isLoading
          ? null
          : () => const RegisterRoute().push<void>(context),
      child: const Text("Don't have an account? Register"),
    );
  }

  Future<void> _login() async {
    await _convexAuthService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    showSuccessNotification('Logged in with Better Auth.');
  }
}
