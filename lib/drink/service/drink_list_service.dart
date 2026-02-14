import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';

class DrinkListService {
  final DrinkService drinkService;
  final SessionService sessionService;

  DrinkListService({required this.drinkService, required this.sessionService});

  Stream<List<Session>> get drinkListDataStream {
    return sessionService.mySessionsForSelectedDateStream;
  }
}
