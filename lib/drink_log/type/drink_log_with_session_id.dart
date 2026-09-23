import 'package:remembeer/drink_log/model/drink_log.dart';

typedef DrinkLogWithSessionId = ({
  String originalSessionId,
  DrinkLog drinkLog,
  bool isParty,
  bool isReadOnly,
});
