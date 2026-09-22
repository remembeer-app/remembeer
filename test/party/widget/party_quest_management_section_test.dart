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
                defaultDurationMinutes: 15,
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
    expect(find.text('Early quests'), findsOneWidget);
    expect(
      find.text('Available from the first quest attempt.'),
      findsOneWidget,
    );
    expect(find.textContaining('25 points each'), findsOneWidget);
    expect(find.textContaining('Choose a partner.'), findsOneWidget);
    expect(find.textContaining('10 minutes'), findsOneWidget);
    expect(find.text('Edit duration'), findsOneWidget);
    expect(find.byIcon(Icons.handshake_outlined), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_outlined), findsNothing);
    expect(find.text('Custom quest'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Delete'), findsNothing);
    expect(find.text('Create custom template'), findsNothing);

    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pump();

    expect(service.enabledTemplateId, 'built-in');
    expect(service.enabledValue, isFalse);
    expect(find.text('Quest template disabled.'), findsNothing);
  });

  testWidgets('shows the Party default and lets admins set an override', (
    tester,
  ) async {
    final service = _FakeQuestService([
      _template(
        id: 'built-in',
        source: PartyQuestTemplateSource.builtIn,
        now: DateTime.utc(2026),
        durationMinutes: null,
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
                defaultDurationMinutes: 3,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('3 minutes (default)'), findsOneWidget);
    expect(find.text('Set duration'), findsOneWidget);

    await tester.tap(find.text('Set duration'));
    await tester.pumpAndSettle();

    expect(find.text('Party default: 3 minutes'), findsOneWidget);
    expect(find.text('Use default'), findsNothing);

    await tester.enterText(find.byType(TextFormField), '99');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter 1-60 minutes.'), findsOneWidget);
    expect(service.durationTemplateId, isNull);

    await tester.enterText(find.byType(TextFormField), '7');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(service.durationTemplateId, 'built-in');
    expect(service.durationValue, 7);
  });

  testWidgets('lets admins clear an override back to the Party default', (
    tester,
  ) async {
    final service = _FakeQuestService([
      _template(
        id: 'built-in',
        source: PartyQuestTemplateSource.builtIn,
        now: DateTime.utc(2026),
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
                defaultDurationMinutes: 3,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Edit duration'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use default'));
    await tester.pumpAndSettle();

    expect(service.durationTemplateId, 'built-in');
    expect(service.durationValue, isNull);
    expect(service.durationCalls, 1);
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
                defaultDurationMinutes: 15,
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
  int? durationMinutes = 10,
}) => PartyQuestTemplate(
  id: id,
  source: source,
  builtInKey: source == PartyQuestTemplateSource.builtIn ? 'key' : null,
  title: source == PartyQuestTemplateSource.builtIn
      ? 'Built-in quest'
      : 'Custom quest',
  instructions: 'Choose a partner.',
  pointsUnits: 25000,
  durationMinutes: durationMinutes,
  eligibilityRule: 'allEligibleMembers',
  availability: PartyQuestAvailability.early,
  catalogVersion: 1,
  createdAt: now,
  updatedAt: now,
);

class _FakeQuestService implements PartyQuestService {
  _FakeQuestService(this.templates);

  final List<PartyQuestTemplate> templates;
  String? enabledTemplateId;
  bool? enabledValue;
  String? durationTemplateId;
  int? durationValue;
  var durationCalls = 0;

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
  Future<void> setTemplateDuration(
    String sessionId,
    String templateId,
    int? durationMinutes,
  ) async {
    durationTemplateId = templateId;
    durationValue = durationMinutes;
    durationCalls += 1;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
