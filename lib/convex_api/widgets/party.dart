// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/party.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Flutter widget for party:standings.
class PartyStandingsQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyStandingsQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    this.refreshAt = const Optional.absent(),
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyStandingsQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    this.refreshAt = const Optional.absent(),
    required this.sessionId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, StandingsResult)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<StandingsResult>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final Optional<double> refreshAt;
  final SessionId sessionId;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<StandingsArgs, StandingsResult>.snapshot(
        query: standingsQueryReference,
        args: (refreshAt: refreshAt, sessionId: sessionId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<StandingsArgs, StandingsResult>(
      query: standingsQueryReference,
      args: (refreshAt: refreshAt, sessionId: sessionId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
