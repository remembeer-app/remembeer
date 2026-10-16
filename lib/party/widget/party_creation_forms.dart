import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/beerpongTournament.dart';
import 'package:remembeer/convex_api/widgets/partyChallenge.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/widget/quest_schedule_form.dart';
import 'package:remembeer/routes.dart';

class PartyChallengeForm extends StatefulWidget {
  const PartyChallengeForm({
    super.key,
    required this.sessionId,
    this.challenge,
  });
  final SessionId sessionId;
  final PartyChallengeDocument? challenge;
  @override
  State<PartyChallengeForm> createState() => _PartyChallengeFormState();
}

class _PartyChallengeFormState extends State<PartyChallengeForm> {
  late final _title = TextEditingController(
    text: widget.challenge?.title ?? '',
  );
  late final _instructions = TextEditingController(
    text: widget.challenge?.instructions ?? '',
  );
  late final _points = TextEditingController(
    text: widget.challenge == null
        ? '$defaultPartyChallengePoints'
        : formatPartyScore(widget.challenge!.pointsUnits.toInt()),
  );
  late final _duration = TextEditingController(
    text: widget.challenge == null
        ? '$defaultPartyQuestDurationMinutes'
        : '${((widget.challenge!.endsAt - widget.challenge!.startsAt) / Duration.millisecondsPerMinute).round()}',
  );

  @override
  void dispose() {
    _title.dispose();
    _instructions.dispose();
    _points.dispose();
    _duration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    if (challenge != null) {
      return PartyChallengeUpdateMutation(
        builder: (context, update, state) => _fields(() async {
          await update(
            id: challenge.id,
            title: Optional.of(_title.text.trim()),
            instructions: Optional.of(_instructions.text.trim()),
            pointsUnits: Optional.of(
              double.parse(_points.text) * partyScoreUnitsPerPoint,
            ),
            durationMinutes:
                _duration.text ==
                    '${((challenge.endsAt - challenge.startsAt) / Duration.millisecondsPerMinute).round()}'
                ? const Optional.absent()
                : Optional.of(double.parse(_duration.text)),
          );
        }),
      );
    }
    return PartyChallengeCreateMutation(
      builder: (context, create, state) => _fields(() async {
        final id = await create(
          sessionId: widget.sessionId,
          title: _title.text.trim(),
          instructions: _instructions.text.trim(),
          pointsUnits: double.parse(_points.text) * partyScoreUnitsPerPoint,
          durationMinutes: double.parse(_duration.text),
        );
        if (context.mounted) {
          unawaited(
            PartyChallengeRoute(
              sessionId: widget.sessionId.value,
              challengeId: id.value,
            ).push<void>(context),
          );
        }
      }),
    );
  }

  Widget _fields(Future<void> Function() submit) => LoadingForm(
    builder: (form) => Column(
      children: [
        form.buildTextField(
          controller: _title,
          label: 'Title',
          validator: requiredText,
        ),
        const Gap(12),
        form.buildTextField(
          controller: _instructions,
          label: 'Instructions',
          validator: requiredText,
        ),
        const Gap(12),
        form.buildTextField(
          controller: _points,
          label: 'Points per winner',
          keyboardType: TextInputType.number,
          validator: wholeMinutes,
        ),
        const Gap(12),
        form.buildTextField(
          controller: _duration,
          label: 'Duration (minutes)',
          keyboardType: TextInputType.number,
          validator: wholeMinutes,
          enabled:
              widget.challenge == null ||
              widget.challenge!.status ==
                  PartyChallengeDocumentStatus.activeValue,
        ),
        const Gap(12),
        form.buildErrorMessage(),
        form.buildSubmitButton(
          text: widget.challenge == null
              ? 'Create challenge'
              : 'Save challenge',
          onSubmit: submit,
        ),
      ],
    ),
  );
}

class PartyTournamentForm extends StatefulWidget {
  const PartyTournamentForm({super.key, required this.sessionId});
  final SessionId sessionId;
  @override
  State<PartyTournamentForm> createState() => _PartyTournamentFormState();
}

class _PartyTournamentFormState extends State<PartyTournamentForm> {
  final _name = TextEditingController();
  final _teams = TextEditingController(text: '$minBeerpongTeamCount');
  final _first = TextEditingController(
    text: '$defaultBeerpongFirstPlacePoints',
  );
  final _second = TextEditingController(
    text: '$defaultBeerpongSecondPlacePoints',
  );
  final _third = TextEditingController(
    text: '$defaultBeerpongThirdPlacePoints',
  );
  var _thirdPlace = true;
  @override
  void dispose() {
    _name.dispose();
    _teams.dispose();
    _first.dispose();
    _second.dispose();
    _third.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BeerpongTournamentCreateMutation(
    builder: (context, create, state) => LoadingForm(
      builder: (form) => Column(
        children: [
          form.buildTextField(
            controller: _name,
            label: 'Tournament name',
            validator: requiredText,
          ),
          const Gap(12),
          form.buildTextField(
            controller: _teams,
            label: 'Number of teams',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          const Gap(12),
          form.buildTextField(
            controller: _first,
            label: 'First place points',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          const Gap(12),
          form.buildTextField(
            controller: _second,
            label: 'Second place points',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          const Gap(12),
          form.buildTextField(
            controller: _third,
            label: 'Third place points',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          SwitchListTile(
            title: const Text('Play third-place match'),
            value: _thirdPlace,
            onChanged: (value) => setState(() => _thirdPlace = value),
          ),
          form.buildErrorMessage(),
          form.buildSubmitButton(
            text: 'Open enrollment',
            onSubmit: () async {
              final id = await create(
                sessionId: widget.sessionId,
                name: _name.text.trim(),
                teamCount: double.parse(_teams.text),
                thirdPlaceEnabled: _thirdPlace,
                firstPlacePointsUnits:
                    double.parse(_first.text) * partyScoreUnitsPerPoint,
                secondPlacePointsUnits:
                    double.parse(_second.text) * partyScoreUnitsPerPoint,
                thirdPlacePointsUnits:
                    double.parse(_third.text) * partyScoreUnitsPerPoint,
              );
              if (context.mounted) {
                unawaited(
                  PartyTournamentRoute(
                    sessionId: widget.sessionId.value,
                    tournamentId: id.value,
                  ).push<void>(context),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

String? requiredText(String? value) =>
    value == null || value.trim().isEmpty ? 'Required.' : null;
