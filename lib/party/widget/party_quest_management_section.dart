import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_quest_template.dart';
import 'package:remembeer/party/service/party_quest_service.dart';

class PartyQuestManagementSection extends StatefulWidget {
  const PartyQuestManagementSection({
    super.key,
    required this.sessionId,
    required this.service,
    required this.defaultDurationMinutes,
  });

  final String sessionId;
  final PartyQuestService service;

  /// The Party-wide quest duration used by templates without an override.
  final int defaultDurationMinutes;

  @override
  State<PartyQuestManagementSection> createState() =>
      _PartyQuestManagementSectionState();
}

class _PartyQuestManagementSectionState
    extends State<PartyQuestManagementSection> {
  String? _pendingTemplateId;

  @override
  Widget build(BuildContext context) => AsyncBuilder<List<PartyQuestTemplate>>(
    stream: widget.service.templatesStream(widget.sessionId),
    builder: (context, templates) {
      final builtInTemplates = templates
          .where(
            (template) => template.source == PartyQuestTemplateSource.builtIn,
          )
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quest templates',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(4),
          Text(
            'Partners must choose each other before either member earns points.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          if (builtInTemplates.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.playlist_remove_outlined),
                title: Text('No built-in quest templates'),
              ),
            ),
          for (final availability in PartyQuestAvailability.values) ...[
            if (builtInTemplates.any(
              (template) => template.availability == availability,
            )) ...[
              const Gap(12),
              Text(
                _availabilityTitle(availability),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(2),
              Text(
                _availabilityDescription(availability),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(4),
              for (final template in builtInTemplates.where(
                (template) => template.availability == availability,
              ))
                _buildTemplate(template),
            ],
          ],
        ],
      );
    },
  );

  Widget _buildTemplate(PartyQuestTemplate template) {
    final isPending = _pendingTemplateId == template.id;
    final override = template.durationMinutes;
    final durationLabel = override == null
        ? '${widget.defaultDurationMinutes} minutes (default)'
        : '$override minutes';
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.handshake_outlined),
            title: Text(template.title),
            subtitle: Text(
              '${template.instructions}\n'
              '${formatPartyScore(template.pointsUnits)} points each · '
              '$durationLabel',
            ),
            value: template.enabled,
            onChanged: isPending
                ? null
                : (enabled) => _runTemplateAction(
                    template.id,
                    () => widget.service.setTemplateEnabled(
                      widget.sessionId,
                      template.id,
                      enabled,
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: TextButton.icon(
                onPressed: isPending ? null : () => _editDuration(template),
                icon: const Icon(Icons.timer_outlined),
                label: Text(
                  override == null ? 'Set duration' : 'Edit duration',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editDuration(PartyQuestTemplate template) async {
    final result = await showDialog<({int? minutes})>(
      context: context,
      builder: (context) => _QuestDurationDialog(
        title: template.title,
        currentMinutes: template.durationMinutes,
        defaultMinutes: widget.defaultDurationMinutes,
      ),
    );
    if (result == null || !mounted) {
      return;
    }
    await _runTemplateAction(
      template.id,
      () => widget.service.setTemplateDuration(
        widget.sessionId,
        template.id,
        result.minutes,
      ),
    );
  }

  Future<void> _runTemplateAction(
    String templateId,
    Future<void> Function() action,
  ) async {
    setState(() => _pendingTemplateId = templateId);
    try {
      await action();
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) {
        setState(() => _pendingTemplateId = null);
      }
    }
  }
}

/// Edits one template's duration override.
///
/// Pops `(minutes: value)` to set an override, `(minutes: null)` to fall back
/// to the Party default, or `null` when cancelled.
class _QuestDurationDialog extends StatefulWidget {
  const _QuestDurationDialog({
    required this.title,
    required this.currentMinutes,
    required this.defaultMinutes,
  });

  final String title;
  final int? currentMinutes;
  final int defaultMinutes;

  @override
  State<_QuestDurationDialog> createState() => _QuestDurationDialogState();
}

class _QuestDurationDialogState extends State<_QuestDurationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: (widget.currentMinutes ?? widget.defaultMinutes).toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Party default: ${widget.defaultMinutes} minutes',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(12),
          TextFormField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration',
              suffixText: 'minutes',
              helperText:
                  '$minPartyQuestDurationMinutes-'
                  '$maxPartyQuestDurationMinutes minutes',
            ),
            validator: _validate,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      if (widget.currentMinutes != null)
        TextButton(
          onPressed: () => Navigator.of(context).pop((minutes: null)),
          child: const Text('Use default'),
        ),
      FilledButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            Navigator.of(
              context,
            ).pop((minutes: int.parse(_controller.text.trim())));
          }
        },
        child: const Text('Save'),
      ),
    ],
  );

  String? _validate(String? value) {
    final minutes = int.tryParse(value?.trim() ?? '');
    if (minutes == null ||
        minutes < minPartyQuestDurationMinutes ||
        minutes > maxPartyQuestDurationMinutes) {
      return 'Enter $minPartyQuestDurationMinutes-'
          '$maxPartyQuestDurationMinutes minutes.';
    }
    return null;
  }
}

String _availabilityTitle(PartyQuestAvailability availability) =>
    switch (availability) {
      PartyQuestAvailability.early => 'Early quests',
      PartyQuestAvailability.regular => 'Regular quests',
      PartyQuestAvailability.finalStage => 'Final quests',
    };

String _availabilityDescription(PartyQuestAvailability availability) =>
    switch (availability) {
      PartyQuestAvailability.early => 'Available from the first quest attempt.',
      PartyQuestAvailability.regular => 'Unlocks after 5 quest attempts.',
      PartyQuestAvailability.finalStage => 'Unlocks after 10 quest attempts.',
    };
