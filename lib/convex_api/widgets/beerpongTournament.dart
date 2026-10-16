// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/beerpongTournament.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for beerpongTournament:create.
class BeerpongTournamentCreateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTournamentCreateMutationExecutor(this._mutate);

  final Future<BeerpongTournamentId> Function(CreateArgs) _mutate;

  /// Runs the mutation.
  Future<BeerpongTournamentId> call({
    required double firstPlacePointsUnits,
    required String name,
    required double secondPlacePointsUnits,
    required SessionId sessionId,
    required double teamCount,
    required bool thirdPlaceEnabled,
    required double thirdPlacePointsUnits,
  }) => _mutate((
    firstPlacePointsUnits: firstPlacePointsUnits,
    name: name,
    secondPlacePointsUnits: secondPlacePointsUnits,
    sessionId: sessionId,
    teamCount: teamCount,
    thirdPlaceEnabled: thirdPlaceEnabled,
    thirdPlacePointsUnits: thirdPlacePointsUnits,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required double firstPlacePointsUnits,
    required String name,
    required double secondPlacePointsUnits,
    required SessionId sessionId,
    required double teamCount,
    required bool thirdPlaceEnabled,
    required double thirdPlacePointsUnits,
    void Function(BeerpongTournamentId result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        firstPlacePointsUnits: firstPlacePointsUnits,
        name: name,
        secondPlacePointsUnits: secondPlacePointsUnits,
        sessionId: sessionId,
        teamCount: teamCount,
        thirdPlaceEnabled: thirdPlaceEnabled,
        thirdPlacePointsUnits: thirdPlacePointsUnits,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTournament:create.
class BeerpongTournamentCreateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTournamentCreateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTournamentCreateMutationExecutor,
    ConvexRequestSnapshot<BeerpongTournamentId>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CreateArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<CreateArgs, BeerpongTournamentId>(
        mutation: createMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          BeerpongTournamentCreateMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for beerpongTournament:draw.
class BeerpongTournamentDrawMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTournamentDrawMutationExecutor(this._mutate);

  final Future<void> Function(DrawArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required BeerpongTournamentId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTournamentId id,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTournament:draw.
class BeerpongTournamentDrawMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTournamentDrawMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTournamentDrawMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<DrawArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<DrawArgs, void>(
    mutation: drawMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTournamentDrawMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongTournament:finalize.
class BeerpongTournamentFinalizeMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTournamentFinalizeMutationExecutor(this._mutate);

  final Future<void> Function(FinalizeArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required BeerpongTournamentId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTournamentId id,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTournament:finalize.
class BeerpongTournamentFinalizeMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTournamentFinalizeMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTournamentFinalizeMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<FinalizeArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<FinalizeArgs, void>(
    mutation: finalizeMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTournamentFinalizeMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongTournament:setEnabled.
class BeerpongTournamentSetEnabledMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTournamentSetEnabledMutationExecutor(this._mutate);

  final Future<void> Function(SetEnabledArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required bool enabled, required SessionId sessionId}) =>
      _mutate((enabled: enabled, sessionId: sessionId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required bool enabled,
    required SessionId sessionId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((enabled: enabled, sessionId: sessionId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTournament:setEnabled.
class BeerpongTournamentSetEnabledMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTournamentSetEnabledMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTournamentSetEnabledMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SetEnabledArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SetEnabledArgs, void>(
    mutation: setEnabledMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTournamentSetEnabledMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongTournament:start.
class BeerpongTournamentStartMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTournamentStartMutationExecutor(this._mutate);

  final Future<void> Function(StartArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required BeerpongTournamentId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTournamentId id,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTournament:start.
class BeerpongTournamentStartMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTournamentStartMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTournamentStartMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<StartArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<StartArgs, void>(
    mutation: startMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTournamentStartMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Flutter widget for beerpongTournament:get.
class BeerpongTournamentGetTypeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const BeerpongTournamentGetTypeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const BeerpongTournamentGetTypeQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.id,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, GetTypeResult)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<GetTypeResult>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final BeerpongTournamentId id;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<GetTypeArgs, GetTypeResult>.snapshot(
        query: getValueQueryReference,
        args: (id: id),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<GetTypeArgs, GetTypeResult>(
      query: getValueQueryReference,
      args: (id: id),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for beerpongTournament:listForSession.
class BeerpongTournamentListForSessionQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const BeerpongTournamentListForSessionQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const BeerpongTournamentListForSessionQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.sessionId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<BeerpongTournamentDocument>)?
  builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<BeerpongTournamentDocument>>,
  )?
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
      return ConvexTypedQuery<
        ListForSessionArgs,
        List<BeerpongTournamentDocument>
      >.snapshot(
        query: listForSessionQueryReference,
        args: (sessionId: sessionId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<
      ListForSessionArgs,
      List<BeerpongTournamentDocument>
    >(
      query: listForSessionQueryReference,
      args: (sessionId: sessionId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
