import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';

class AppForm extends StatelessWidget {
  final bool isSubmitting;
  final Object? error;
  final VoidCallback onSubmit;
  final String submitLabel;
  final String submittingLabel;

  /// Builds the fields with a callback that validates before submitting.
  final Widget Function(BuildContext context, VoidCallback submit) builder;

  const AppForm({
    super.key,
    required this.isSubmitting,
    this.error,
    required this.onSubmit,
    required this.submitLabel,
    this.submittingLabel = 'Submitting...',
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          void submit() {
            if (isSubmitting || !Form.of(context).validate()) return;
            onSubmit();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                builder(context, submit),
                if (error case final error?) ...[
                  const Gap(16),
                  ErrorMessageBox(message: error.toString()),
                ],
                const Gap(16),
                FilledButton(
                  onPressed: isSubmitting ? null : submit,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSubmitting) ...[
                        const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const Gap(8),
                      ],
                      Text(isSubmitting ? submittingLabel : submitLabel),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
