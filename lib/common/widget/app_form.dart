import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';

class AppForm extends StatelessWidget {
  final bool isSubmitting;
  final Object? error;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final String submitLabel;
  final String submittingLabel;

  /// Builds the fields with a callback that validates before submitting.
  final Widget Function(BuildContext context, VoidCallback submit) builder;

  const AppForm({
    super.key,
    required this.isSubmitting,
    this.error,
    required this.onSubmit,
    required this.onBack,
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      builder(context, submit),
                      if (error case final error?) ...[
                        const Gap(16),
                        ErrorMessageBox(message: error.toString()),
                      ],
                    ],
                  ),
                ),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    onPressed: isSubmitting ? null : onBack,
                    tooltip: 'Back',
                    style: IconButton.styleFrom(
                      fixedSize: const Size(104, 48),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Gap(12),
                  IconButton.filled(
                    onPressed: isSubmitting ? null : submit,
                    tooltip: isSubmitting ? submittingLabel : submitLabel,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(168, 48),
                      shape: const StadiumBorder(),
                    ),
                    icon: isSubmitting
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
