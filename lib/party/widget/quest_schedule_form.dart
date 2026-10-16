import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/partyQuest.dart';

class QuestScheduleForm extends StatefulWidget {
  const QuestScheduleForm({super.key, required this.party});
  final Party party;

  @override
  State<QuestScheduleForm> createState() => _QuestScheduleFormState();
}

class _QuestScheduleFormState extends State<QuestScheduleForm> {
  late final _min = TextEditingController(
    text: '${widget.party.questSchedule.minIntervalMinutes.toInt()}',
  );
  late final _max = TextEditingController(
    text: '${widget.party.questSchedule.maxIntervalMinutes.toInt()}',
  );
  late final _duration = TextEditingController(
    text: '${widget.party.questSchedule.defaultDurationMinutes.toInt()}',
  );

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    _duration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PartyQuestSetScheduleMutation(
    builder: (context, save, state) => LoadingForm(
      builder: (form) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Quest schedule', style: Theme.of(context).textTheme.titleLarge),
          const Text(
            'Quests unlock in stages automatically. Team quests require eligible beerpong players.',
          ),
          const Gap(12),
          form.buildTextField(
            controller: _min,
            label: 'Minimum break (minutes)',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          const Gap(12),
          form.buildTextField(
            controller: _max,
            label: 'Maximum break (minutes)',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          const Gap(12),
          form.buildTextField(
            controller: _duration,
            label: 'Quest duration (minutes)',
            keyboardType: TextInputType.number,
            validator: wholeMinutes,
          ),
          const Gap(12),
          form.buildErrorMessage(),
          form.buildSubmitButton(
            text: 'Save schedule',
            onSubmit: () async {
              await save(
                sessionId: widget.party.id,
                minIntervalMinutes: double.parse(_min.text),
                maxIntervalMinutes: double.parse(_max.text),
                defaultDurationMinutes: double.parse(_duration.text),
              );
            },
          ),
        ],
      ),
    ),
  );
}

String? wholeMinutes(String? value) =>
    int.tryParse(value ?? '') == null ? 'Enter a whole number.' : null;
