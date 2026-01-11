import 'package:remembeer/drink/model/drink_list_data.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:rxdart/rxdart.dart';

class DrinkListService {
  final DrinkService drinkService;
  final SessionService sessionService;

  DrinkListService({required this.drinkService, required this.sessionService});

  Stream<DrinkListData> get drinkListDataStream {
    return Rx.combineLatest2(
      drinkService.drinksForSelectedDateStream,
      sessionService.mySessionsForSelectedDateStream,
      (drinks, sessions) => (drinks: drinks, sessions: sessions),
    );
  }
}
