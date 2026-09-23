import 'package:remembeer/convex_api/api.dart';

class DrinkService {
  final ConvexApi _api;

  DrinkService({required ConvexApi api}) : _api = api;

  late final customDrinks = _api.drinks.listCustomSubscribe();
}
