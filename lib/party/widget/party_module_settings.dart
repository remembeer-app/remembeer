import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party.dart';

class PartyModuleSettingsPanel extends StatefulWidget {
  const PartyModuleSettingsPanel({
    super.key,
    required this.settings,
    required this.schedule,
    required this.onSaveSettings,
    required this.onSaveSchedule,
  });

  final PartyModuleSettings settings;
  final PartyQuestSchedule schedule;
  final Future<void> Function(PartyModuleSettings settings) onSaveSettings;
  final Future<void> Function(PartyQuestSchedule schedule) onSaveSchedule;

  @override
  State<PartyModuleSettingsPanel> createState() =>
      _PartyModuleSettingsPanelState();
}

class _PartyModuleSettingsPanelState extends State<PartyModuleSettingsPanel> {
  late PartyModuleSettings _settings;
  late final TextEditingController _minIntervalController;
  late final TextEditingController _maxIntervalController;
  late final TextEditingController _durationController;
  var _savingSettings = false;
  var _savingSchedule = false;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _minIntervalController = TextEditingController(
      text: widget.schedule.minIntervalMinutes.toString(),
    );
    _maxIntervalController = TextEditingController(
      text: widget.schedule.maxIntervalMinutes.toString(),
    );
    _durationController = TextEditingController(
      text: widget.schedule.defaultDurationMinutes.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant PartyModuleSettingsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_savingSettings && oldWidget.settings != widget.settings) {
      _settings = widget.settings;
    }
    if (!_savingSchedule && oldWidget.schedule != widget.schedule) {
      _setScheduleText(widget.schedule);
    }
  }

  @override
  void dispose() {
    _minIntervalController.dispose();
    _maxIntervalController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Game modules', style: Theme.of(context).textTheme.titleLarge),
        const Gap(4),
        Text(
          'Each game can be enabled independently.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(8),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.group_work_outlined),
                title: const Text('Social quests'),
                subtitle: const Text('Scheduled partner quests'),
                value: _settings.socialQuestsEnabled,
                onChanged: _savingSettings
                    ? null
                    : (value) => setState(
                        () => _settings = _settings.copyWith(
                          socialQuestsEnabled: value,
                        ),
                      ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.flag_outlined),
                title: const Text('Admin challenges'),
                subtitle: const Text('Timed challenges with chosen winners'),
                value: _settings.adminChallengesEnabled,
                onChanged: _savingSettings
                    ? null
                    : (value) => setState(
                        () => _settings = _settings.copyWith(
                          adminChallengesEnabled: value,
                        ),
                      ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.sports_bar_outlined),
                title: const Text('Beerpong'),
                subtitle: const Text('Tournament enrollment and bracket'),
                value: _settings.beerpongEnabled,
                onChanged: _savingSettings
                    ? null
                    : (value) => setState(
                        () => _settings = _settings.copyWith(
                          beerpongEnabled: value,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _savingSettings ? null : _saveSettings,
                    child: Text(
                      _savingSettings ? 'Saving...' : 'Save module settings',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_settings.socialQuestsEnabled) ...[
          const Gap(20),
          Text(
            'Social quest schedule',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Quests start randomly between the minimum and maximum interval.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap(16),
                    _numberField(
                      controller: _minIntervalController,
                      label: 'Minimum interval (minutes)',
                    ),
                    const Gap(12),
                    _numberField(
                      controller: _maxIntervalController,
                      label: 'Maximum interval (minutes)',
                    ),
                    const Gap(12),
                    _numberField(
                      controller: _durationController,
                      label: 'Default duration (minutes)',
                    ),
                    const Gap(16),
                    FilledButton.tonal(
                      onPressed: _savingSchedule ? null : _saveSchedule,
                      child: Text(
                        _savingSchedule ? 'Saving...' : 'Save schedule',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
  }) => TextField(
    controller: controller,
    enabled: !_savingSchedule,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );

  Future<void> _saveSettings() async {
    setState(() => _savingSettings = true);
    try {
      await widget.onSaveSettings(_settings);
      showSuccessNotification('Party modules updated.');
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) {
        setState(() => _savingSettings = false);
      }
    }
  }

  Future<void> _saveSchedule() async {
    final minimum = int.tryParse(_minIntervalController.text);
    final maximum = int.tryParse(_maxIntervalController.text);
    final duration = int.tryParse(_durationController.text);
    final valid =
        minimum != null &&
        maximum != null &&
        duration != null &&
        minimum >= minPartyQuestIntervalMinutes &&
        maximum <= maxPartyQuestIntervalMinutes &&
        minimum <= maximum &&
        duration >= minPartyQuestDurationMinutes &&
        duration <= maxPartyQuestDurationMinutes;
    if (!valid) {
      showErrorNotification(
        'Use a $minPartyQuestIntervalMinutes-$maxPartyQuestIntervalMinutes minute interval and a '
        '$minPartyQuestDurationMinutes-$maxPartyQuestDurationMinutes minute duration.',
      );
      return;
    }

    setState(() => _savingSchedule = true);
    try {
      await widget.onSaveSchedule(
        PartyQuestSchedule(
          minIntervalMinutes: minimum,
          maxIntervalMinutes: maximum,
          defaultDurationMinutes: duration,
          nextQuestAt: widget.schedule.nextQuestAt,
        ),
      );
      showSuccessNotification('Quest schedule updated.');
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) {
        setState(() => _savingSchedule = false);
      }
    }
  }

  void _setScheduleText(PartyQuestSchedule schedule) {
    _minIntervalController.text = schedule.minIntervalMinutes.toString();
    _maxIntervalController.text = schedule.maxIntervalMinutes.toString();
    _durationController.text = schedule.defaultDurationMinutes.toString();
  }
}
