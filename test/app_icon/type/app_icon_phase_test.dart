import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/app_icon/constants.dart';
import 'package:remembeer/app_icon/type/app_icon_phase.dart';

void main() {
  group('AppIconPhase.forAlcoholMl', () {
    test('starts at the initial phase with nothing logged', () {
      expect(AppIconPhase.forAlcoholMl(0), AppIconPhase.a);
      expect(AppIconPhase.forAlcoholMl(-10), AppIconPhase.a);
      expect(AppIconPhase.forAlcoholMl(double.nan), AppIconPhase.a);
    });

    test('stays on the initial phase until one full step is reached', () {
      expect(
        AppIconPhase.forAlcoholMl(appIconPhaseStepMl - 0.01),
        AppIconPhase.a,
      );
      expect(AppIconPhase.forAlcoholMl(appIconPhaseStepMl), AppIconPhase.b);
    });

    test('advances one phase per step', () {
      for (var i = 0; i < AppIconPhase.values.length; i++) {
        expect(
          AppIconPhase.forAlcoholMl(appIconPhaseStepMl * i),
          AppIconPhase.values[i],
        );
      }
    });

    test('keeps the last phase once reached', () {
      final beyondLast = appIconPhaseStepMl * (AppIconPhase.values.length + 5);
      expect(AppIconPhase.forAlcoholMl(beyondLast), AppIconPhase.h);
      expect(AppIconPhase.forAlcoholMl(double.infinity), AppIconPhase.h);
    });
  });
}
