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
