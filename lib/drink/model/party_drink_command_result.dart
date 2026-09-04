import 'package:remembeer/party/controller/party_command_client.dart';

class PartyDrinkCommandResult {
  const PartyDrinkCommandResult({
    required this.sessionId,
    required this.drinkId,
    this.awardEventId,
    this.reversalEventId,
    this.baseScoreUnits,
    this.classBonusUnits,
    this.awardedScoreUnits,
  });

  final String sessionId;
  final String drinkId;
  final String? awardEventId;
  final String? reversalEventId;
  final int? baseScoreUnits;
  final int? classBonusUnits;
  final int? awardedScoreUnits;

  factory PartyDrinkCommandResult.fromMutation(PartyCommandResult result) {
    final data = result.data;
    final drink = data['drink'];
    final drinkId = drink is Map<Object?, Object?>
        ? drink['id']
        : data['drinkId'];

    return PartyDrinkCommandResult(
      sessionId: _requiredString(data, 'sessionId'),
      drinkId: _requiredStringValue(drinkId, 'drinkId'),
      awardEventId: _optionalString(data, 'awardEventId'),
      reversalEventId: _optionalString(data, 'reversalEventId'),
      baseScoreUnits: _optionalInt(data, 'baseScoreUnits'),
      classBonusUnits: _optionalInt(data, 'classBonusUnits'),
      awardedScoreUnits: _optionalInt(data, 'awardedScoreUnits'),
    );
  }

  static String _requiredString(Map<String, Object?> data, String key) =>
      _requiredStringValue(data[key], key);

  static String _requiredStringValue(Object? value, String key) {
    if (value is! String || value.isEmpty) {
      throw StateError('Party drink command returned an invalid $key.');
    }
    return value;
  }

  static String? _optionalString(Map<String, Object?> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is! String || value.isEmpty) {
      throw StateError('Party drink command returned an invalid $key.');
    }
    return value;
  }

  static int? _optionalInt(Map<String, Object?> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is! int) {
      throw StateError('Party drink command returned an invalid $key.');
    }
    return value;
  }
}

class PartyDrinkException implements Exception {
  const PartyDrinkException(this.message);

  final String message;

  @override
  String toString() => message;
}
