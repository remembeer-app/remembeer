import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/drink_log/page/update_drink_log_page.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';
import 'package:remembeer/ioc/ioc_container.dart';

void main() {
  testWidgets('edit without a supplied log explains how to open it', (
    tester,
  ) async {
    get.registerSingleton(ConvexApi(_Caller()));
    addTearDown(get.reset);
    await tester.pumpWidget(
      const MaterialApp(home: UpdateDrinkLogPage(log: null)),
    );
    expect(
      find.text('Open a drink from the daily list to edit it.'),
      findsOneWidget,
    );
    expect(find.byType(DrinkLogForm), findsNothing);
  });
}

class _Caller implements ConvexFunctionCaller {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
