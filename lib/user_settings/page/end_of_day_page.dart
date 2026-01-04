import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/constants.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class EndOfDayPage extends StatefulWidget {
  const EndOfDayPage({super.key});

  @override
  State<EndOfDayPage> createState() => _EndOfDayPageState();
}

class _EndOfDayPageState extends State<EndOfDayPage> {
  final _userSettingsService = get<UserSettingsService>();

  TimeOfDay? _selectedEndOfDayBoundary;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('End of Day'),
      hint:
          'This time defines when a day ends. For example, if set to 6:00 AM '
          'and viewing the 10th, drinks from 10th 6:00 AM to 11th 6:00 AM '
          'will be shown. This also determines stats and streak calculations.',
      child: AsyncBuilder(
        future: _userSettingsService.currentUserSettings,
        builder: (context, userSettings) {
          _selectedEndOfDayBoundary ??= userSettings.endOfDayBoundary;

          return Column(
            children: [
              _buildTimeCard(context),
              gap24,
              _buildResetButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _pickTime,
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
              hGap20,
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
                    gap4,
                    Text(
                      _selectedEndOfDayBoundary!.format(context),
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

  Widget _buildResetButton(BuildContext context) {
    final isDefault = _selectedEndOfDayBoundary == defaultEndOfDayBoundary;

    return OutlinedButton.icon(
      onPressed: isDefault ? null : _resetToDefault,
      icon: const Icon(Icons.restore),
      label: Text(
        isDefault
            ? 'Already at default (6:00 AM)'
            : 'Reset to default (6:00 AM)',
      ),
    );
  }

  void _resetToDefault() {
    _onTimeChanged(defaultEndOfDayBoundary);
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndOfDayBoundary!,
    );
    if (pickedTime != null) {
      await _onTimeChanged(pickedTime);
    }
  }

  Future<void> _onTimeChanged(TimeOfDay value) async {
    setState(() {
      _selectedEndOfDayBoundary = value;
    });

    await _userSettingsService.updateEndOfDayBoundary(value);
  }
}
