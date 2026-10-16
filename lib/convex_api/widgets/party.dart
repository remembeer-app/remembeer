// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/party.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Flutter widget for the paginated party:activity query.
class PartyActivityQuery extends StatelessWidget {
  /// Creates a typed paginated query with default initial loading/error UI.
  const PartyActivityQuery({
    super.key,
    required this.builder,
    this.client,
    this.pageSize = 20,
    this.waitingBuilder,
    this.errorBuilder,
    this.kinds = const Optional.absent(),
    this.participantIds = const Optional.absent(),
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a paginated query whose builder handles every snapshot state.
  const PartyActivityQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    this.pageSize = 20,
    this.kinds = const Optional.absent(),
    this.participantIds = const Optional.absent(),
    required this.sessionId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds accumulated items and controls for loading more pages.
  final PaginatedQueryWidgetBuilder<ActivityPageItem>? builder;

  /// Builds every state, including errors with their original details.
  final Widget Function(
    BuildContext,
    ConvexPaginatedQuerySnapshot<ActivityPageItem>,
    VoidCallback,
  )?
  snapshotBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Number of items requested per page.
  final int pageSize;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides error UI when no items are available.
  final Widget Function(BuildContext, Object)? errorBuilder;

  final Optional<List<ActivityArgsKindsItem>> kinds;
  final Optional<List<UserId>> participantIds;
  final SessionId sessionId;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot$ = snapshotBuilder;
    if (buildSnapshot$ != null) {
      return ConvexTypedPaginatedQuery<ActivityArgs, ActivityPageItem>.snapshot(
        query: activityPaginatedQueryReference,
        args: (
          kinds: kinds,
          participantIds: participantIds,
          sessionId: sessionId,
        ),
        pageSize: pageSize,
        client: client,
        snapshotBuilder: buildSnapshot$,
      );
    }
    return ConvexTypedPaginatedQuery<ActivityArgs, ActivityPageItem>(
      query: activityPaginatedQueryReference,
      args: (
        kinds: kinds,
        participantIds: participantIds,
        sessionId: sessionId,
      ),
      pageSize: pageSize,
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for party:standings.
class PartyStandingsQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyStandingsQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyStandingsQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
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

  final SessionId sessionId;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<StandingsArgs, StandingsResult>.snapshot(
        query: standingsQueryReference,
        args: (sessionId: sessionId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<StandingsArgs, StandingsResult>(
      query: standingsQueryReference,
      args: (sessionId: sessionId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
