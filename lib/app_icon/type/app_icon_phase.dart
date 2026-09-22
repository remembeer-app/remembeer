import 'package:remembeer/app_icon/constants.dart';

enum AppIconPhase {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h;

  static const initial = AppIconPhase.a;

  static AppIconPhase forAlcoholMl(double alcoholMl) {
    if (alcoholMl.isNaN || alcoholMl <= 0) {
      return initial;
    }

    final steps = alcoholMl / appIconPhaseStepMl;
    if (steps >= values.length) {
      return values.last;
    }

    return values[steps.floor()];
  }
}
