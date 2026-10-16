import 'package:flutter/foundation.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/location/service/location_service.dart';

Future<void> addDefaultDrinkLog({
  required ConvexApi api,
  required LocationService locationService,
}) async {
  final user = await api.user.current();
  final drinks = await api.drink.listAvailable();
  final drink = drinks
      .where((drink) => drink.id == user.defaultDrink)
      .firstOrNull;
  if (drink == null) {
    throw StateError('Choose an available default drink in Settings first.');
  }
  ({double latitude, double longitude, double? accuracy})? location;
  try {
    final position = await locationService.getLastPositionIfAllowed();
    if (position != null) {
      location = (
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    }
  } on Object catch (error) {
    debugPrint('Could not read the quick-add location: $error');
  }
  await api.drinkLog.create(
    drinkId: drink.id,
    volumeMl: drink.drinkCategory.defaultVolume.toDouble(),
    sessionId: null,
    location: location,
  );
}
