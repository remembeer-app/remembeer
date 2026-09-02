import 'package:cloud_functions/cloud_functions.dart';
import 'package:remembeer/party/constants.dart';

typedef PartyCommandInvoker =
    Future<Object?> Function(String commandName, Map<String, Object?> data);

class PartyCommandResult {
  const PartyCommandResult(this.data);

  final Map<String, Object?> data;
}

class PartyCommandClient {
  PartyCommandClient({PartyCommandInvoker? invoker})
    : _invoker = invoker ?? _invokeFirebaseCommand;

  final PartyCommandInvoker _invoker;

  Future<PartyCommandResult> call({
    required String commandName,
    required String sessionId,
    required String commandId,
    Map<String, Object?> data = const {},
  }) async {
    final rawResult = await _invoker(commandName, {
      ...data,
      'sessionId': sessionId,
      'commandId': commandId,
    });
    if (rawResult == null) {
      return const PartyCommandResult({});
    }
    if (rawResult is! Map<Object?, Object?>) {
      throw StateError('Party command $commandName returned a non-map result.');
    }

    final result = <String, Object?>{};
    for (final entry in rawResult.entries) {
      final key = entry.key;
      if (key is! String) {
        throw StateError(
          'Party command $commandName returned a map with a non-string key.',
        );
      }
      result[key] = entry.value;
    }
    return PartyCommandResult(Map.unmodifiable(result));
  }

  static Future<Object?> _invokeFirebaseCommand(
    String commandName,
    Map<String, Object?> data,
  ) async {
    final functions = FirebaseFunctions.instanceFor(
      region: partyFunctionsRegion,
    );
    final result = await functions
        .httpsCallable(commandName)
        .call<Object?>(data);
    return result.data;
  }
}
