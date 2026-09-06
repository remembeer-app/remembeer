import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_quest_template.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/widget/party_quest_management_section.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('shows enable toggles for built-in templates only', (
    tester,
  ) async {
    final now = DateTime.utc(2026);
    final service = _FakeQuestService([
      _template(
        id: 'built-in',
        source: PartyQuestTemplateSource.builtIn,
        now: now,
      ),
      _template(
        id: 'custom',
        source: PartyQuestTemplateSource.custom,
        now: now,
      ),
    ]);

    await tester.pumpWidget(
      ToastificationWrapper(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PartyQuestManagementSection(
                sessionId: 'session-1',
                service: service,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.text(
        'Partners must choose each other before either member earns points.',
      ),
      findsOneWidget,
    );
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.text('Built-in quest'), findsOneWidget);
    expect(find.text('Custom quest'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Delete'), findsNothing);
    expect(find.text('Create custom template'), findsNothing);

    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pump();

    expect(service.enabledTemplateId, 'built-in');
    expect(service.enabledValue, isFalse);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('shows an empty state when no built-in templates exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      ToastificationWrapper(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PartyQuestManagementSection(
                sessionId: 'session-1',
                service: _FakeQuestService([
                  _template(
                    id: 'custom',
                    source: PartyQuestTemplateSource.custom,
                    now: DateTime.utc(2026),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('No built-in quest templates'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
  });
}

PartyQuestTemplate _template({
  required String id,
  required PartyQuestTemplateSource source,
  required DateTime now,
}) => PartyQuestTemplate(
  id: id,
  source: source,
  builtInKey: source == PartyQuestTemplateSource.builtIn ? 'key' : null,
  title: source == PartyQuestTemplateSource.builtIn
      ? 'Built-in quest'
      : 'Custom quest',
  instructions: 'Choose a partner.',
  pointsUnits: 25000,
  durationMinutes: 10,
  eligibilityRule: 'allEligibleMembers',
  catalogVersion: 1,
  createdAt: now,
  updatedAt: now,
);

class _FakeQuestService implements PartyQuestService {
  _FakeQuestService(this.templates);

  final List<PartyQuestTemplate> templates;
  String? enabledTemplateId;
  bool? enabledValue;

  @override
  Stream<List<PartyQuestTemplate>> templatesStream(String sessionId) =>
      Stream.value(templates);

  @override
  Future<void> setTemplateEnabled(
    String sessionId,
    String templateId,
    bool enabled,
  ) async {
    enabledTemplateId = templateId;
    enabledValue = enabled;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
