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
  });

  final String sessionId;
  final PartyQuestService service;

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
          for (final template in builtInTemplates) _buildTemplate(template),
        ],
      );
    },
  );

  Widget _buildTemplate(PartyQuestTemplate template) {
    final isPending = _pendingTemplateId == template.id;
    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.handshake_outlined),
        title: Text(template.title),
        subtitle: Text(
          '${template.instructions}\n'
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
              ),
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
