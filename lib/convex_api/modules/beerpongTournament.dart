// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class BeerpongTournamentApi {
  const BeerpongTournamentApi(this._client);

  final ConvexFunctionCaller _client;

  Future<BeerpongTournamentId> create({
    required double firstPlacePointsUnits,
    required String name,
    required double secondPlacePointsUnits,
    required SessionId sessionId,
    required double teamCount,
    required bool thirdPlaceEnabled,
    required double thirdPlacePointsUnits,
  }) async {
    final raw$ = await _client.mutate(
      'beerpongTournament:create',
      _encodeCreateArgs((
        firstPlacePointsUnits: firstPlacePointsUnits,
        name: name,
        secondPlacePointsUnits: secondPlacePointsUnits,
        sessionId: sessionId,
        teamCount: teamCount,
        thirdPlaceEnabled: thirdPlaceEnabled,
        thirdPlacePointsUnits: thirdPlacePointsUnits,
      )),
    );
    return BeerpongTournamentId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, BeerpongTournamentId>
  get createMutation => createMutationReference;

  Future<Null> draw({required BeerpongTournamentId id}) async {
    await _client.mutate('beerpongTournament:draw', _encodeDrawArgs((id: id)));
    return null;
  }

  ConvexMutationReference<DrawArgs, void> get drawMutation =>
      drawMutationReference;

  Future<Null> finalize({required BeerpongTournamentId id}) async {
    await _client.mutate(
      'beerpongTournament:finalize',
      _encodeFinalizeArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<FinalizeArgs, void> get finalizeMutation =>
      finalizeMutationReference;

  Future<Null> start({required BeerpongTournamentId id}) async {
    await _client.mutate(
      'beerpongTournament:start',
      _encodeStartArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<StartArgs, void> get startMutation =>
      startMutationReference;
}

typedef CreateArgs = ({
  double firstPlacePointsUnits,
  String name,
  double secondPlacePointsUnits,
  SessionId sessionId,
  double teamCount,
  bool thirdPlaceEnabled,
  double thirdPlacePointsUnits,
});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (
    firstPlacePointsUnits: firstPlacePointsUnits,
    name: name,
    secondPlacePointsUnits: secondPlacePointsUnits,
    sessionId: sessionId,
    teamCount: teamCount,
    thirdPlaceEnabled: thirdPlaceEnabled,
    thirdPlacePointsUnits: thirdPlacePointsUnits,
  ) = value$;
  return <String, dynamic>{
    'firstPlacePointsUnits': firstPlacePointsUnits,
    'name': name,
    'secondPlacePointsUnits': secondPlacePointsUnits,
    'sessionId': sessionId.value,
    'teamCount': teamCount,
    'thirdPlaceEnabled': thirdPlaceEnabled,
    'thirdPlacePointsUnits': thirdPlacePointsUnits,
  };
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('firstPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "firstPlacePointsUnits" for CreateArgs',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for CreateArgs');
  }
  if (!map.containsKey('secondPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "secondPlacePointsUnits" for CreateArgs',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for CreateArgs');
  }
  if (!map.containsKey('teamCount')) {
    throw FormatException('Missing required field "teamCount" for CreateArgs');
  }
  if (!map.containsKey('thirdPlaceEnabled')) {
    throw FormatException(
      'Missing required field "thirdPlaceEnabled" for CreateArgs',
    );
  }
  if (!map.containsKey('thirdPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "thirdPlacePointsUnits" for CreateArgs',
    );
  }
  return (
    firstPlacePointsUnits: expectDouble(
      map['firstPlacePointsUnits'],
      label: 'CreateArgsFirstPlacePointsUnits',
    ),
    name: expectString(map['name'], label: 'CreateArgsName'),
    secondPlacePointsUnits: expectDouble(
      map['secondPlacePointsUnits'],
      label: 'CreateArgsSecondPlacePointsUnits',
    ),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'CreateArgsSessionId'),
    ),
    teamCount: expectDouble(map['teamCount'], label: 'CreateArgsTeamCount'),
    thirdPlaceEnabled: expectBool(
      map['thirdPlaceEnabled'],
      label: 'CreateArgsThirdPlaceEnabled',
    ),
    thirdPlacePointsUnits: expectDouble(
      map['thirdPlacePointsUnits'],
      label: 'CreateArgsThirdPlacePointsUnits',
    ),
  );
}

typedef DrawArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeDrawArgs(DrawArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

DrawArgs _decodeDrawArgs(dynamic raw) {
  final map = expectMap(raw, label: 'DrawArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for DrawArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'DrawArgsId')),
  );
}

typedef FinalizeArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeFinalizeArgs(FinalizeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

FinalizeArgs _decodeFinalizeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'FinalizeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for FinalizeArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'FinalizeArgsId')),
  );
}

typedef StartArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeStartArgs(StartArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

StartArgs _decodeStartArgs(dynamic raw) {
  final map = expectMap(raw, label: 'StartArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for StartArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'StartArgsId')),
  );
}

final ConvexMutationReference<CreateArgs, BeerpongTournamentId>
createMutationReference = ConvexMutationReference(
  name: 'beerpongTournament:create',
  encode: (args) => _encodeCreateArgs(args),
  decode: (raw) =>
      BeerpongTournamentId(expectString(raw, label: 'CreateResult')),
);

final ConvexMutationReference<DrawArgs, void> drawMutationReference =
    ConvexMutationReference(
      name: 'beerpongTournament:draw',
      encode: (args) => _encodeDrawArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<FinalizeArgs, void> finalizeMutationReference =
    ConvexMutationReference(
      name: 'beerpongTournament:finalize',
      encode: (args) => _encodeFinalizeArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<StartArgs, void> startMutationReference =
    ConvexMutationReference(
      name: 'beerpongTournament:start',
      encode: (args) => _encodeStartArgs(args),
      decode: (raw) => null,
    );
