import 'package:dartvex/dartvex.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart' show MutationMode;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/user.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class EndOfDayPage extends StatelessWidget {
  const EndOfDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'End of Day',
      autmaticallyImplyLeading: true,
      hint:
          'This time defines when a day ends. For example, if set to 6:00 AM '
          'and viewing the 10th, drinks from 10th 6:00 AM to 11th 6:00 AM '
          'will be shown. This also determines stats and streak calculations.',
      child: UserCurrentQuery(
        builder: (context, user) => UserUpdateEndOfDayBoundaryMutation(
          mode: MutationMode.latest,
          optimisticUpdate: _optimisticUpdateBoundary,
          builder: (context, mutate, snapshot) {
            final boundary = TimeOfDay(
              hour: user.endOfDayBoundary.toInt() ~/ TimeOfDay.minutesPerHour,
              minute: user.endOfDayBoundary.toInt() % TimeOfDay.minutesPerHour,
            );
            void onChanged(TimeOfDay value) {
              final minutes =
                  value.hour * TimeOfDay.minutesPerHour + value.minute;
              if (minutes == user.endOfDayBoundary) return;
              mutate.run(endOfDayBoundary: minutes.toDouble());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildTimeCard(context, boundary, onChanged),
                  const Gap(24),
                  _buildResetButton(context, boundary, onChanged),
                  if (snapshot.error case final error?) ...[
                    const Gap(16),
                    ErrorMessageBox(message: error.toString()),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeCard(
    BuildContext context,
    TimeOfDay boundary,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    return Card(
      child: InkWell(
        onTap: () => _pickTime(context, boundary, onChanged),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.access_time,
                  size: 32,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ends at',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      boundary.format(context),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit, color: Theme.of(context).colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton(
    BuildContext context,
    TimeOfDay boundary,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    final isDefault = boundary == defaultEndOfDayBoundary;
    final defaultTime = defaultEndOfDayBoundary.format(context);

    return OutlinedButton.icon(
      onPressed: isDefault ? null : () => onChanged(defaultEndOfDayBoundary),
      icon: const Icon(Icons.restore),
      label: Text(
        isDefault
            ? 'Already at default ($defaultTime)'
            : 'Reset to default ($defaultTime)',
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay boundary,
    ValueChanged<TimeOfDay> onChanged,
  ) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: boundary,
    );
    if (context.mounted && pickedTime != null) onChanged(pickedTime);
  }

  void _optimisticUpdateBoundary(
    TypedOptimisticLocalStore store,
    UpdateEndOfDayBoundaryArgs args,
    OptimisticMutationContext _,
  ) {
    store.updateQuery(
      currentQueryReference,
      const NoArgs(),
      (user) => (
        creationTime: user.creationTime,
        id: user.id,
        accentColor: user.accentColor,
        authUserId: user.authUserId,
        avatarUrl: user.avatarUrl,
        defaultDrink: user.defaultDrink,
        drinkLogSortOrder: user.drinkLogSortOrder,
        endOfDayBoundary: args.endOfDayBoundary,
        normalizedUsername: user.normalizedUsername,
        timeZone: user.timeZone,
        username: user.username,
      ),
    );
  }
}
