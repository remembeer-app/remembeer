// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../../api.dart';
import '../../modules/lib/timeZone.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Flutter widget for lib/timeZone:searchTimeZones.
class LibTimeZoneSearchTimeZonesQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const LibTimeZoneSearchTimeZonesQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.search,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const LibTimeZoneSearchTimeZonesQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.search,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<String>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<List<String>>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final String search;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<SearchTimeZonesArgs, List<String>>.snapshot(
        query: searchTimeZonesQueryReference,
        args: (search: search),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<SearchTimeZonesArgs, List<String>>(
      query: searchTimeZonesQueryReference,
      args: (search: search),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
