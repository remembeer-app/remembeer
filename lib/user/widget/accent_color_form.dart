import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/widget/accent_color_selector.dart';

class AccentColorForm extends StatefulWidget {
  final AccentColorKey? initialValue;
  final String submitText;
  final Future<void> Function(AccentColorKey accentColorKey) onSubmit;

  const AccentColorForm({
    super.key,
    required this.initialValue,
    required this.submitText,
    required this.onSubmit,
  });

  @override
  State<AccentColorForm> createState() => _AccentColorFormState();
}

class _AccentColorFormState extends State<AccentColorForm> {
  AccentColorKey? _accentColorKey;

  @override
  void initState() {
    super.initState();
    _accentColorKey = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingForm(
      builder: (form) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your accent',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(8),
            Text(
              'This color identifies you throughout Party Mode.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(20),
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
              onSubmit: () => widget.onSubmit(_accentColorKey!),
            ),
          ],
        ),
      ),
    );
  }
}
