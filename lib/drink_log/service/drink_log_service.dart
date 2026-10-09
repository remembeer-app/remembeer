import 'package:flutter/foundation.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/location/service/location_service.dart';

class DrinkLogService {
  DrinkLogService({
    required ConvexApi api,
    required LocationService locationService,
  }) : _api = api,
       _locationService = locationService;

  final ConvexApi _api;
  final LocationService _locationService;

  Future<void> addDefaultDrinkLog() async {
    final user = await _api.user.current();
    final drinks = await _api.drink.listAvailable();
    final drink = drinks
        .where((drink) => drink.id == user.defaultDrink)
        .firstOrNull;
    if (drink == null) {
      throw StateError('Choose an available default drink in Settings first.');
    }
    ({double latitude, double longitude, double? accuracy})? location;
    try {
      final position = await _locationService.getLastPositionIfAllowed();
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
    await _api.drinkLog.create(
      drinkId: drink.id,
      consumedAt: DateTime.now().millisecondsSinceEpoch.toDouble(),
      volumeMl: drink.drinkCategory.defaultVolume.toDouble(),
      sessionId: null,
      location: location,
    );
    showSuccessNotification('Default drink added!');
  }
}
