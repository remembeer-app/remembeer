import 'package:remembeer/party/controller/party_command_client.dart';

class PartyDrinkLogCommandResult {
  const PartyDrinkLogCommandResult({
    required this.sessionId,
    required this.drinkLogId,
    this.awardEventId,
    this.reversalEventId,
    this.baseScoreUnits,
    this.classBonusUnits,
    this.awardedScoreUnits,
    required this.unlockedBadgeIds,
  });

  final String sessionId;
  final String drinkLogId;
  final String? awardEventId;
  final String? reversalEventId;
  final int? baseScoreUnits;
  final int? classBonusUnits;
  final int? awardedScoreUnits;

  /// Badges the server unlocked while processing this command.
  final List<String> unlockedBadgeIds;

  factory PartyDrinkLogCommandResult.fromMutation(PartyCommandResult result) {
    final data = result.data;
    final drinkLog = data['drinkLog'];
    final drinkLogId = drinkLog is Map<Object?, Object?>
        ? drinkLog['id']
        : data['drinkLogId'];

    return PartyDrinkLogCommandResult(
      sessionId: _requiredString(data, 'sessionId'),
      drinkLogId: _requiredStringValue(drinkLogId, 'drinkLogId'),
      awardEventId: _optionalString(data, 'awardEventId'),
      reversalEventId: _optionalString(data, 'reversalEventId'),
      baseScoreUnits: _optionalInt(data, 'baseScoreUnits'),
      classBonusUnits: _optionalInt(data, 'classBonusUnits'),
      awardedScoreUnits: _optionalInt(data, 'awardedScoreUnits'),
      unlockedBadgeIds: _requiredStringList(data, 'unlockedBadgeIds'),
    );
  }

  static String _requiredString(Map<String, Object?> data, String key) =>
      _requiredStringValue(data[key], key);

  static String _requiredStringValue(Object? value, String key) {
    if (value is! String || value.isEmpty) {
      throw StateError('Party drink log command returned an invalid $key.');
    }
    return value;
  }

  static String? _optionalString(Map<String, Object?> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is! String || value.isEmpty) {
      throw StateError('Party drink log command returned an invalid $key.');
    }
    return value;
  }

  static List<String> _requiredStringList(
    Map<String, Object?> data,
    String key,
  ) {
    final value = data[key];
    if (value is! List<Object?>) {
      throw StateError('Party drink log command returned an invalid $key.');
    }
    return [
      for (final item in value)
        if (item is String && item.isNotEmpty)
          item
        else
          throw StateError('Party drink log command returned an invalid $key.'),
    ];
  }

  static int? _optionalInt(Map<String, Object?> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is! int) {
      throw StateError('Party drink log command returned an invalid $key.');
    }
    return value;
  }
}

class PartyDrinkLogException implements Exception {
  const PartyDrinkLogException(this.message);

  final String message;

  @override
  String toString() => message;
}
