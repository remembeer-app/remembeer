import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/page/party_profile_page.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/challenge_card.dart';
import 'package:remembeer/party/widget/party_module_settings.dart';
import 'package:remembeer/party/widget/party_quest_management_section.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

typedef PartyManagementSectionBuilder =
    Widget Function(BuildContext context, PartyState state);

class PartyManagementPage extends StatelessWidget {
  PartyManagementPage({
    super.key,
    required this.sessionId,
    PartyService? partyService,
    SessionService? sessionService,
    PartyChallengeService? challengeService,
    PartyQuestService? questService,
    this.socialQuestSectionBuilder,
    this.beerpongSectionBuilder,
  }) : _partyService = partyService ?? get<PartyService>(),
       _sessionService = sessionService ?? get<SessionService>(),
       _challengeService =
           challengeService ??
           PartyChallengeService(
             partyController: get<PartyController>(),
             gameController: get<PartyGameController>(),
             eventController: get<PartyEventController>(),
           ),
       _questService =
           questService ??
           PartyQuestService(
             partyController: get<PartyController>(),
             gameController: get<PartyGameController>(),
           );

  final String sessionId;
  final PartyService _partyService;
  final SessionService _sessionService;
  final PartyChallengeService _challengeService;
  final PartyQuestService _questService;
  final PartyManagementSectionBuilder? socialQuestSectionBuilder;
  final PartyManagementSectionBuilder? beerpongSectionBuilder;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Manage Party'),
      hint: 'Module changes affect this Party only.',
      padding: const EdgeInsets.all(16),
      child: AsyncBuilder<PartyState>(
        stream: _partyService.stateStream(sessionId),
        builder: (context, state) {
          if (state.isArchived) {
            return const Center(
              child: Text('This Party is archived and read-only.'),
            );
          }
          if (!state.isAdmin) {
            return const Center(
              child: Text('Only Party admins can manage this Party.'),
            );
          }
          return AsyncBuilder<List<PartyMember>>(
            stream: _partyService.membersStream(sessionId),
            builder: (context, partyMembers) => AsyncBuilder<List<UserModel>>(
              stream: _sessionService.sessionMembersStream(sessionId),
              builder: (context, users) =>
                  _buildContent(context, state, partyMembers, users),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PartyState state,
    List<PartyMember> partyMembers,
    List<UserModel> users,
  ) => ListView(
    children: [
      PartyModuleSettingsPanel(
        settings: state.party.moduleSettings,
        schedule: state.party.questSchedule,
        onSaveSettings: (settings) =>
            _challengeService.setModuleSettings(sessionId, settings),
        onSaveSchedule: (schedule) =>
            _questService.setSchedule(sessionId, schedule),
      ),
      if (state.party.moduleSettings.socialQuestsEnabled) ...[
        const Gap(24),
        socialQuestSectionBuilder?.call(context, state) ??
            PartyQuestManagementSection(
              sessionId: sessionId,
              service: _questService,
            ),
      ],
      if (state.party.moduleSettings.adminChallengesEnabled) ...[
        const Gap(24),
        _ChallengeManagementSection(
          sessionId: sessionId,
          state: state,
          service: _challengeService,
        ),
      ],
      if (state.party.moduleSettings.beerpongEnabled &&
          beerpongSectionBuilder != null) ...[
        const Gap(24),
        beerpongSectionBuilder!(context, state),
      ],
      const Gap(24),
      _buildMembers(context, state, partyMembers, users),
    ],
  );

  Widget _buildMembers(
    BuildContext context,
    PartyState state,
    List<PartyMember> partyMembers,
    List<UserModel> users,
  ) {
    final activeMembers = partyMembers
        .where(
          (member) =>
              member.isActive &&
              state.session.memberIds.contains(member.userId),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Member classes', style: Theme.of(context).textTheme.titleLarge),
        const Gap(4),
        Text(
          'Class changes affect future drinks only.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(8),
        for (final member in activeMembers)
          if (users.where((user) => user.id == member.userId).firstOrNull
              case final user?)
            Card(
              child: ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: Text(user.username),
                subtitle: Text(
                  member.selectedClass?.displayName ?? 'No class selected',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) =>
                        PartyProfilePage(sessionId: sessionId, user: user),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class _ChallengeManagementSection extends StatelessWidget {
  const _ChallengeManagementSection({
    required this.sessionId,
    required this.state,
    required this.service,
  });

  final String sessionId;
  final PartyState state;
  final PartyChallengeService service;

  @override
  Widget build(BuildContext context) => AsyncBuilder<List<PartyChallenge>>(
    stream: service.challengesStream(sessionId),
    builder: (context, challenges) {
      final active = challenges
          .where((challenge) => challenge.id == state.party.activeChallengeId)
          .firstOrNull;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Admin challenges',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(4),
          Text(
            'Start one timed challenge and award any number of members.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          if (active != null)
            ChallengeCard(
              challenge: active,
              onTap: () => PartyChallengeRoute(
                sessionId: sessionId,
                challengeId: active.id,
                tab: PartyTab.games,
              ).push<void>(context),
            )
          else
            _ChallengeCreationForm(
              onCreate:
                  ({
                    required title,
                    required instructions,
                    required points,
                    required durationMinutes,
                  }) => service.createChallenge(
                    sessionId: sessionId,
                    title: title,
                    instructions: instructions,
                    points: points,
                    durationMinutes: durationMinutes,
                  ),
            ),
        ],
      );
    },
  );
}

class _ChallengeCreationForm extends StatefulWidget {
  const _ChallengeCreationForm({required this.onCreate});

  final Future<void> Function({
    required String title,
    required String instructions,
    required int points,
    required int durationMinutes,
  })
  onCreate;

  @override
  State<_ChallengeCreationForm> createState() => _ChallengeCreationFormState();
}

class _ChallengeCreationFormState extends State<_ChallengeCreationForm> {
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _pointsController = TextEditingController(text: '50');
  final _durationController = TextEditingController(text: '5');

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
            form.buildTextField(
              controller: _titleController,
              label: 'Challenge title',
              maxLength: maxPartyChallengeTitleLength,
              validator: _required,
            ),
            const Gap(12),
            form.buildTextField(
              controller: _instructionsController,
              label: 'Instructions',
              maxLength: maxPartyChallengeInstructionsLength,
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
                      minPartyChallengePoints,
                      maxPartyChallengePoints,
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
                      minPartyChallengeDurationMinutes,
                      maxPartyChallengeDurationMinutes,
                    ),
                  ),
                ),
              ],
            ),
            form.buildErrorMessage(),
            const Gap(16),
            form.buildSubmitButton(
              text: 'Start challenge',
              onSubmit: () async {
                await widget.onCreate(
                  title: _titleController.text,
                  instructions: _instructionsController.text,
                  points: int.parse(_pointsController.text),
                  durationMinutes: int.parse(_durationController.text),
                );
                showSuccessNotification('Challenge started.');
              },
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
