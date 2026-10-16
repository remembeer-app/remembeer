// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/partyChallenge.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for partyChallenge:addWinner.
class PartyChallengeAddWinnerMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeAddWinnerMutationExecutor(this._mutate);

  final Future<void> Function(AddWinnerArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required PartyChallengeId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required PartyChallengeId id,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id, userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyChallenge:addWinner.
class PartyChallengeAddWinnerMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeAddWinnerMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeAddWinnerMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<AddWinnerArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<AddWinnerArgs, void>(
    mutation: addWinnerMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyChallengeAddWinnerMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyChallenge:cancel.
class PartyChallengeCancelMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeCancelMutationExecutor(this._mutate);

  final Future<void> Function(CancelArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required PartyChallengeId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required PartyChallengeId id,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyChallenge:cancel.
class PartyChallengeCancelMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeCancelMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeCancelMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CancelArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<CancelArgs, void>(
    mutation: cancelMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyChallengeCancelMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyChallenge:complete.
class PartyChallengeCompleteMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeCompleteMutationExecutor(this._mutate);

  final Future<void> Function(CompleteArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required PartyChallengeId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required PartyChallengeId id,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyChallenge:complete.
class PartyChallengeCompleteMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeCompleteMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeCompleteMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CompleteArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<CompleteArgs, void>(
    mutation: completeMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyChallengeCompleteMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyChallenge:create.
class PartyChallengeCreateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeCreateMutationExecutor(this._mutate);

  final Future<PartyChallengeId> Function(CreateArgs) _mutate;

  /// Runs the mutation.
  Future<PartyChallengeId> call({
    required double durationMinutes,
    required String instructions,
    required double pointsUnits,
    required SessionId sessionId,
    required String title,
  }) => _mutate((
    durationMinutes: durationMinutes,
    instructions: instructions,
    pointsUnits: pointsUnits,
    sessionId: sessionId,
    title: title,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required double durationMinutes,
    required String instructions,
    required double pointsUnits,
    required SessionId sessionId,
    required String title,
    void Function(PartyChallengeId result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        durationMinutes: durationMinutes,
        instructions: instructions,
        pointsUnits: pointsUnits,
        sessionId: sessionId,
        title: title,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyChallenge:create.
class PartyChallengeCreateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeCreateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeCreateMutationExecutor,
    ConvexRequestSnapshot<PartyChallengeId>,
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
      ConvexMutation<CreateArgs, PartyChallengeId>(
        mutation: createMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          PartyChallengeCreateMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for partyChallenge:removeWinner.
class PartyChallengeRemoveWinnerMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeRemoveWinnerMutationExecutor(this._mutate);

  final Future<void> Function(RemoveWinnerArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required PartyChallengeId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required PartyChallengeId id,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id, userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyChallenge:removeWinner.
class PartyChallengeRemoveWinnerMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeRemoveWinnerMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeRemoveWinnerMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<RemoveWinnerArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<RemoveWinnerArgs, void>(
    mutation: removeWinnerMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyChallengeRemoveWinnerMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyChallenge:setEnabled.
class PartyChallengeSetEnabledMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeSetEnabledMutationExecutor(this._mutate);

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

/// Flutter widget for partyChallenge:setEnabled.
class PartyChallengeSetEnabledMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeSetEnabledMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeSetEnabledMutationExecutor,
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
      PartyChallengeSetEnabledMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyChallenge:update.
class PartyChallengeUpdateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyChallengeUpdateMutationExecutor(this._mutate);

  final Future<void> Function(UpdateArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    Optional<double> durationMinutes = const Optional.absent(),
    required PartyChallengeId id,
    Optional<String> instructions = const Optional.absent(),
    Optional<double> pointsUnits = const Optional.absent(),
    Optional<String> title = const Optional.absent(),
  }) => _mutate((
    durationMinutes: durationMinutes,
    id: id,
    instructions: instructions,
    pointsUnits: pointsUnits,
    title: title,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    Optional<double> durationMinutes = const Optional.absent(),
    required PartyChallengeId id,
    Optional<String> instructions = const Optional.absent(),
    Optional<double> pointsUnits = const Optional.absent(),
    Optional<String> title = const Optional.absent(),
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        durationMinutes: durationMinutes,
        id: id,
        instructions: instructions,
        pointsUnits: pointsUnits,
        title: title,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyChallenge:update.
class PartyChallengeUpdateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyChallengeUpdateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyChallengeUpdateMutationExecutor,
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
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyChallengeUpdateMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Flutter widget for partyChallenge:get.
class PartyChallengeGetTypeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyChallengeGetTypeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyChallengeGetTypeQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.id,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, PartyChallengeDocument)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<PartyChallengeDocument>,
  )?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final PartyChallengeId id;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<GetTypeArgs, PartyChallengeDocument>.snapshot(
        query: getValueQueryReference,
        args: (id: id),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<GetTypeArgs, PartyChallengeDocument>(
      query: getValueQueryReference,
      args: (id: id),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for partyChallenge:listForSession.
class PartyChallengeListForSessionQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyChallengeListForSessionQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyChallengeListForSessionQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.sessionId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<PartyChallengeDocument>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<PartyChallengeDocument>>,
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
        List<PartyChallengeDocument>
      >.snapshot(
        query: listForSessionQueryReference,
        args: (sessionId: sessionId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<ListForSessionArgs, List<PartyChallengeDocument>>(
      query: listForSessionQueryReference,
      args: (sessionId: sessionId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
