// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/drinkLog.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for drinkLog:create.
class DrinkLogCreateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const DrinkLogCreateMutationExecutor(this._mutate);

  final Future<DrinkLogId> Function(CreateArgs) _mutate;

  /// Runs the mutation.
  Future<DrinkLogId> call({
    required double consumedAt,
    required DrinkId drinkId,
    required CreateArgsLocation? location,
    required SessionId? sessionId,
    required double volumeMl,
  }) => _mutate((
    consumedAt: consumedAt,
    drinkId: drinkId,
    location: location,
    sessionId: sessionId,
    volumeMl: volumeMl,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required double consumedAt,
    required DrinkId drinkId,
    required CreateArgsLocation? location,
    required SessionId? sessionId,
    required double volumeMl,
    void Function(DrinkLogId result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        consumedAt: consumedAt,
        drinkId: drinkId,
        location: location,
        sessionId: sessionId,
        volumeMl: volumeMl,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for drinkLog:create.
class DrinkLogCreateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const DrinkLogCreateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    DrinkLogCreateMutationExecutor,
    ConvexRequestSnapshot<DrinkLogId>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CreateArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<CreateArgs, DrinkLogId>(
    mutation: createMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, DrinkLogCreateMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for drinkLog:softDelete.
class DrinkLogSoftDeleteMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const DrinkLogSoftDeleteMutationExecutor(this._mutate);

  final Future<void> Function(SoftDeleteArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required DrinkLogId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required DrinkLogId id, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for drinkLog:softDelete.
class DrinkLogSoftDeleteMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const DrinkLogSoftDeleteMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    DrinkLogSoftDeleteMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SoftDeleteArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SoftDeleteArgs, void>(
    mutation: softDeleteMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, DrinkLogSoftDeleteMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for drinkLog:update.
class DrinkLogUpdateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const DrinkLogUpdateMutationExecutor(this._mutate);

  final Future<void> Function(UpdateArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    Optional<double> consumedAt = const Optional.absent(),
    Optional<DrinkId> drinkId = const Optional.absent(),
    required DrinkLogId id,
    Optional<UpdateArgsLocation?> location = const Optional.absent(),
    Optional<SessionId?> sessionId = const Optional.absent(),
    Optional<double> volumeMl = const Optional.absent(),
  }) => _mutate((
    consumedAt: consumedAt,
    drinkId: drinkId,
    id: id,
    location: location,
    sessionId: sessionId,
    volumeMl: volumeMl,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    Optional<double> consumedAt = const Optional.absent(),
    Optional<DrinkId> drinkId = const Optional.absent(),
    required DrinkLogId id,
    Optional<UpdateArgsLocation?> location = const Optional.absent(),
    Optional<SessionId?> sessionId = const Optional.absent(),
    Optional<double> volumeMl = const Optional.absent(),
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        consumedAt: consumedAt,
        drinkId: drinkId,
        id: id,
        location: location,
        sessionId: sessionId,
        volumeMl: volumeMl,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for drinkLog:update.
class DrinkLogUpdateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const DrinkLogUpdateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    DrinkLogUpdateMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<UpdateArgs, void>(
    mutation: updateMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, DrinkLogUpdateMutationExecutor(mutate), snapshot),
  );
}

/// Flutter widget for drinkLog:listForDay.
class DrinkLogListForDayQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const DrinkLogListForDayQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.at,
    this.date = const Optional.absent(),
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const DrinkLogListForDayQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.at,
    this.date = const Optional.absent(),
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, ListForDayResult)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<ListForDayResult>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final double at;
  final Optional<String> date;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<ListForDayArgs, ListForDayResult>.snapshot(
        query: listForDayQueryReference,
        args: (at: at, date: date),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<ListForDayArgs, ListForDayResult>(
      query: listForDayQueryReference,
      args: (at: at, date: date),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
