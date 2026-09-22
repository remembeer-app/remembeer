import 'package:remembeer/convex_api/api.dart';

class DrinksService {
  final ConvexApi _api;

  DrinksService({required ConvexApi api}) : _api = api;

  late final customDrinks = _api.drinks.listCustomSubscribe();
}
