import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/gender.dart';
import 'package:remembeer/user/widget/accent_color_selector.dart';
import 'package:remembeer/user/widget/gender_selector.dart';

class ProfileDetailsForm extends StatefulWidget {
  final Gender? initialGender;
  final AccentColorKey? initialAccentColorKey;
  final String submitText;
  final Future<void> Function(Gender gender, AccentColorKey accentColorKey)
  onSubmit;

  const ProfileDetailsForm({
    super.key,
    required this.initialGender,
    required this.initialAccentColorKey,
    required this.submitText,
    required this.onSubmit,
  });

  @override
  State<ProfileDetailsForm> createState() => _ProfileDetailsFormState();
}

class _ProfileDetailsFormState extends State<ProfileDetailsForm> {
  Gender? _gender;
  AccentColorKey? _accentColorKey;

  @override
  void initState() {
    super.initState();
    _gender = widget.initialGender;
    _accentColorKey = widget.initialAccentColorKey;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingForm(
      builder: (form) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Gender', style: Theme.of(context).textTheme.titleMedium),
            const Gap(8),
            FormField<Gender>(
              initialValue: _gender,
              validator: (value) =>
                  value == null ? 'Select your gender.' : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenderSelector(
                    value: _gender,
                    enabled: !form.isLoading,
                    onChanged: (value) {
                      setState(() => _gender = value);
                      field.didChange(value);
                    },
                  ),
                  if (field.hasError) ...[
                    const Gap(8),
                    Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Gap(24),
            Text(
              'Accent color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(8),
            FormField<AccentColorKey>(
              initialValue: _accentColorKey,
              validator: (value) =>
                  value == null ? 'Select an accent color.' : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccentColorSelector(
                    value: _accentColorKey,
                    enabled: !form.isLoading,
                    onChanged: (value) {
                      setState(() => _accentColorKey = value);
                      field.didChange(value);
                    },
                  ),
                  if (field.hasError) ...[
                    const Gap(8),
                    Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            form.buildErrorMessage(),
            const Gap(32),
            form.buildSubmitButton(
              text: widget.submitText,
              onSubmit: () => widget.onSubmit(_gender!, _accentColorKey!),
            ),
          ],
        ),
      ),
    );
  }
}
