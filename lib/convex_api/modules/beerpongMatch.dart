// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class BeerpongMatchApi {
  const BeerpongMatchApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> correctResult({
    required BeerpongMatchId id,
    required BeerpongTeamId winnerTeamId,
  }) async {
    await _client.mutate(
      'beerpongMatch:correctResult',
      _encodeCorrectResultArgs((id: id, winnerTeamId: winnerTeamId)),
    );
    return null;
  }

  ConvexMutationReference<CorrectResultArgs, void> get correctResultMutation =>
      correctResultMutationReference;

  Future<Null> recordResult({
    required BeerpongMatchId id,
    required BeerpongTeamId winnerTeamId,
  }) async {
    await _client.mutate(
      'beerpongMatch:recordResult',
      _encodeRecordResultArgs((id: id, winnerTeamId: winnerTeamId)),
    );
    return null;
  }

  ConvexMutationReference<RecordResultArgs, void> get recordResultMutation =>
      recordResultMutationReference;
}

typedef CorrectResultArgs = ({BeerpongMatchId id, BeerpongTeamId winnerTeamId});

Map<String, dynamic> _encodeCorrectResultArgs(CorrectResultArgs value$) {
  final (id: id, winnerTeamId: winnerTeamId) = value$;
  return <String, dynamic>{'id': id.value, 'winnerTeamId': winnerTeamId.value};
}

CorrectResultArgs _decodeCorrectResultArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CorrectResultArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for CorrectResultArgs');
  }
  if (!map.containsKey('winnerTeamId')) {
    throw FormatException(
      'Missing required field "winnerTeamId" for CorrectResultArgs',
    );
  }
  return (
    id: BeerpongMatchId(expectString(map['id'], label: 'CorrectResultArgsId')),
    winnerTeamId: BeerpongTeamId(
      expectString(map['winnerTeamId'], label: 'CorrectResultArgsWinnerTeamId'),
    ),
  );
}

typedef RecordResultArgs = ({BeerpongMatchId id, BeerpongTeamId winnerTeamId});

Map<String, dynamic> _encodeRecordResultArgs(RecordResultArgs value$) {
  final (id: id, winnerTeamId: winnerTeamId) = value$;
  return <String, dynamic>{'id': id.value, 'winnerTeamId': winnerTeamId.value};
}

RecordResultArgs _decodeRecordResultArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RecordResultArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for RecordResultArgs');
  }
  if (!map.containsKey('winnerTeamId')) {
    throw FormatException(
      'Missing required field "winnerTeamId" for RecordResultArgs',
    );
  }
  return (
    id: BeerpongMatchId(expectString(map['id'], label: 'RecordResultArgsId')),
    winnerTeamId: BeerpongTeamId(
      expectString(map['winnerTeamId'], label: 'RecordResultArgsWinnerTeamId'),
    ),
  );
}

final ConvexMutationReference<CorrectResultArgs, void>
correctResultMutationReference = ConvexMutationReference(
  name: 'beerpongMatch:correctResult',
  encode: (args) => _encodeCorrectResultArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<RecordResultArgs, void>
recordResultMutationReference = ConvexMutationReference(
  name: 'beerpongMatch:recordResult',
  encode: (args) => _encodeRecordResultArgs(args),
  decode: (raw) => null,
);
