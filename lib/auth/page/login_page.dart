import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remembeer/auth/page/register_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = get<AuthService>();
  final _userService = get<UserService>();
  final _userSettingsService = get<UserSettingsService>();

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
        errorMapper: (e) => e is FirebaseAuthException
            ? mapFirebaseAuthError(e.code)
            : e.toString(),
        builder: (form) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(theme),
            gap48,
            _buildFormContent(context, form),
            gap24,
            _buildDivider(theme),
            gap24,
            _buildGoogleSignIn(form),
            gap16,
            _buildRegisterLink(context, form),
          ],
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
        gap8,
        Text(
          'Remembeer',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        gap8,
        Text(
          'Track your drinks, compete with friends',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(BuildContext context, LoadingFormState form) {
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
        gap16,
        _buildPasswordField(form),
        form.buildErrorMessage(),
        gap8,
        _buildForgotPassword(context, form),
        gap16,
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

  Widget _buildForgotPassword(BuildContext context, LoadingFormState form) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: form.isLoading
              ? null
              : () => _showPasswordResetDialog(context),
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleSignIn(LoadingFormState form) {
    return OutlinedButton.icon(
      onPressed: form.isLoading
          ? null
          : () => form.runAction(_signInWithGoogle),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        minimumSize: const Size(300, 0),
      ),
      icon: SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
      label: const Text('Sign in with Google', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildRegisterLink(BuildContext context, LoadingFormState form) {
    return TextButton(
      onPressed: form.isLoading
          ? null
          : () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const RegisterPage(),
              ),
            ),
      child: const Text("Don't have an account? Register"),
    );
  }

  Future<void> _login() async {
    await _authService.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    if (result != null && result.isNewUser) {
      await _userSettingsService.createDefaultUserSettings();
      await _userService.createDefaultUser();
    }
  }

  Future<void> _showPasswordResetDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your email address and we'll send you a link to reset your password.",
              ),
              gap16,
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isEmpty) return;

                _authService.resetPassword(email: email);
                Navigator.of(context).pop();
                showNotification(
                  'Password reset email sent! Check your inbox (including spam).',
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
