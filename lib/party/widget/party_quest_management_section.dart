import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_quest_template.dart';
import 'package:remembeer/party/service/party_quest_service.dart';

class PartyQuestManagementSection extends StatefulWidget {
  const PartyQuestManagementSection({
    super.key,
    required this.sessionId,
    required this.service,
  });

  final String sessionId;
  final PartyQuestService service;

  @override
  State<PartyQuestManagementSection> createState() =>
      _PartyQuestManagementSectionState();
}

class _PartyQuestManagementSectionState
    extends State<PartyQuestManagementSection> {
  PartyQuestTemplate? _editingTemplate;
  String? _pendingTemplateId;

  @override
  Widget build(BuildContext context) => AsyncBuilder<List<PartyQuestTemplate>>(
    stream: widget.service.templatesStream(widget.sessionId),
    builder: (context, templates) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Quest templates', style: Theme.of(context).textTheme.titleLarge),
        const Gap(4),
        Text(
          'Partners must choose each other before either member earns points.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(8),
        if (templates.isEmpty)
          const Card(
            child: ListTile(
              leading: Icon(Icons.playlist_remove_outlined),
              title: Text('No quest templates'),
              subtitle: Text('Create a custom template to schedule quests.'),
            ),
          )
        else
          for (final template in templates) _buildTemplate(context, template),
        const Gap(12),
        _QuestTemplateForm(
          key: ValueKey(_editingTemplate?.id ?? 'new-template'),
          template: _editingTemplate,
          onCancel: _editingTemplate == null
              ? null
              : () => setState(() => _editingTemplate = null),
          onSave:
              ({
                required title,
                required instructions,
                required points,
                required durationMinutes,
              }) async {
                final editing = _editingTemplate;
                if (editing == null) {
                  await widget.service.createTemplate(
                    sessionId: widget.sessionId,
                    title: title,
                    instructions: instructions,
                    points: points,
                    durationMinutes: durationMinutes,
                  );
                  showSuccessNotification('Quest template created.');
                } else {
                  await widget.service.updateTemplate(
                    sessionId: widget.sessionId,
                    templateId: editing.id,
                    title: title,
                    instructions: instructions,
                    points: points,
                    durationMinutes: durationMinutes,
                  );
                  if (mounted) {
                    setState(() => _editingTemplate = null);
                  }
                  showSuccessNotification('Quest template updated.');
                }
              },
        ),
      ],
    ),
  );

  Widget _buildTemplate(BuildContext context, PartyQuestTemplate template) {
    final isPending = _pendingTemplateId == template.id;
    final isCustom = template.source == PartyQuestTemplateSource.custom;
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              isCustom ? Icons.edit_note_outlined : Icons.auto_awesome_outlined,
            ),
            title: Text(template.title),
            subtitle: Text(
              '${isCustom ? 'Custom' : 'Built-in'} · '
              '${formatPartyScore(template.pointsUnits)} points · '
              '${template.durationMinutes} minutes',
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
                    enabled
                        ? 'Quest template enabled.'
                        : 'Quest template disabled.',
                  ),
          ),
          if (isCustom)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: isPending
                        ? null
                        : () => setState(() => _editingTemplate = template),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                  const Gap(8),
                  TextButton.icon(
                    onPressed: isPending
                        ? null
                        : () => _confirmDelete(context, template),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, PartyQuestTemplate template) {
    showConfirmationDialog(
      context: context,
      title: 'Delete quest template?',
      text:
          'Past quests remain readable, but this template cannot be restored.',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () => _runTemplateAction(
        template.id,
        () => widget.service.deleteTemplate(widget.sessionId, template.id),
        'Quest template deleted.',
      ),
    );
  }

  Future<void> _runTemplateAction(
    String templateId,
    Future<void> Function() action,
    String successMessage,
  ) async {
    setState(() => _pendingTemplateId = templateId);
    try {
      await action();
      showSuccessNotification(successMessage);
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) {
        setState(() => _pendingTemplateId = null);
      }
    }
  }
}

class _QuestTemplateForm extends StatefulWidget {
  const _QuestTemplateForm({
    super.key,
    required this.template,
    required this.onSave,
    this.onCancel,
  });

  final PartyQuestTemplate? template;
  final Future<void> Function({
    required String title,
    required String instructions,
    required int points,
    required int durationMinutes,
  })
  onSave;
  final VoidCallback? onCancel;

  @override
  State<_QuestTemplateForm> createState() => _QuestTemplateFormState();
}

class _QuestTemplateFormState extends State<_QuestTemplateForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _pointsController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    _titleController = TextEditingController(text: template?.title);
    _instructionsController = TextEditingController(
      text: template?.instructions,
    );
    _pointsController = TextEditingController(
      text: template == null ? '25' : formatPartyScore(template.pointsUnits),
    );
    _durationController = TextEditingController(
      text: (template?.durationMinutes ?? defaultPartyQuestDurationMinutes)
          .toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _pointsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: LoadingForm(
        builder: (form) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.template == null
                  ? 'Create custom template'
                  : 'Edit custom template',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(4),
            const Text(
              'Custom quests include every eligible member. A pair earns points only after mutual confirmation.',
            ),
            const Gap(16),
            form.buildTextField(
              controller: _titleController,
              label: 'Quest title',
              maxLength: maxPartyQuestTitleLength,
              validator: _required,
            ),
            const Gap(12),
            form.buildTextField(
              controller: _instructionsController,
              label: 'Instructions',
              maxLength: maxPartyQuestInstructionsLength,
              minLines: 3,
              validator: _required,
            ),
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: form.buildTextField(
                    controller: _pointsController,
                    label: 'Points',
                    keyboardType: TextInputType.number,
                    validator: (value) => _integerInRange(
                      value,
                      minPartyQuestPoints,
                      maxPartyQuestPoints,
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: form.buildTextField(
                    controller: _durationController,
                    label: 'Minutes',
                    keyboardType: TextInputType.number,
                    isLastField: true,
                    validator: (value) => _integerInRange(
                      value,
                      minPartyQuestDurationMinutes,
                      maxPartyQuestDurationMinutes,
                    ),
                  ),
                ),
              ],
            ),
            form.buildErrorMessage(),
            const Gap(16),
            form.buildSubmitButton(
              text: widget.template == null
                  ? 'Create template'
                  : 'Save template',
              onSubmit: () => widget.onSave(
                title: _titleController.text,
                instructions: _instructionsController.text,
                points: int.parse(_pointsController.text),
                durationMinutes: int.parse(_durationController.text),
              ),
            ),
            if (widget.onCancel != null)
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel editing'),
              ),
          ],
        ),
      ),
    ),
  );
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required.' : null;

String? _integerInRange(String? value, int minimum, int maximum) {
  final parsed = int.tryParse(value ?? '');
  return parsed == null || parsed < minimum || parsed > maximum
      ? 'Use $minimum-$maximum.'
      : null;
}
