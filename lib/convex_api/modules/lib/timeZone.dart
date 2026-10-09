// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../../runtime.dart';
import '../../schema.dart';

import 'package:dartvex/dartvex.dart';

class LibTimeZoneApi {
  const LibTimeZoneApi(this._client);

  final ConvexFunctionCaller _client;

  Future<List<String>> searchTimeZones({required String search}) async {
    final raw$ = await _client.query(
      'lib/timeZone:searchTimeZones',
      _encodeSearchTimeZonesArgs((search: search)),
    );
    return expectList(raw$, label: 'SearchTimeZonesResult')
        .map((item) => expectString(item, label: 'SearchTimeZonesResultItem'))
        .toList();
  }

  TypedConvexSubscription<List<String>> searchTimeZonesSubscribe({
    required String search,
  }) {
    final subscription$ = _client.subscribe(
      'lib/timeZone:searchTimeZones',
      _encodeSearchTimeZonesArgs((search: search)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<String>>(
            expectList(value, label: 'SearchTimeZonesResult')
                .map(
                  (item) =>
                      expectString(item, label: 'SearchTimeZonesResultItem'),
                )
                .toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<String>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<String>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<String>>(subscription$, typedStream$);
  }

  ConvexQueryReference<SearchTimeZonesArgs, List<String>>
  get searchTimeZonesQuery => searchTimeZonesQueryReference;
}

typedef SearchTimeZonesArgs = ({String search});

Map<String, dynamic> _encodeSearchTimeZonesArgs(SearchTimeZonesArgs value$) {
  final (search: search) = value$;
  return <String, dynamic>{'search': search};
}

SearchTimeZonesArgs _decodeSearchTimeZonesArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SearchTimeZonesArgs');
  if (!map.containsKey('search')) {
    throw FormatException(
      'Missing required field "search" for SearchTimeZonesArgs',
    );
  }
  return (
    search: expectString(map['search'], label: 'SearchTimeZonesArgsSearch'),
  );
}

final ConvexQueryReference<SearchTimeZonesArgs, List<String>>
searchTimeZonesQueryReference = ConvexQueryReference(
  name: 'lib/timeZone:searchTimeZones',
  encode: (args) => _encodeSearchTimeZonesArgs(args),
  decodeArgs: (raw) => _decodeSearchTimeZonesArgs(raw),
  decode: (raw) => expectList(raw, label: 'SearchTimeZonesResult')
      .map((item) => expectString(item, label: 'SearchTimeZonesResultItem'))
      .toList(),
  encodeResult: (value) => value.map((item) => item).toList(),
);
