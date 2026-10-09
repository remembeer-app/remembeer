// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/session.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for session:create.
class SessionCreateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionCreateMutationExecutor(this._mutate);

  final Future<SessionId> Function(CreateArgs) _mutate;

  /// Runs the mutation.
  Future<SessionId> call({
    required String description,
    required String name,
    required double startedAt,
  }) => _mutate((description: description, name: name, startedAt: startedAt));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required String description,
    required String name,
    required double startedAt,
    void Function(SessionId result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        description: description,
        name: name,
        startedAt: startedAt,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for session:create.
class SessionCreateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionCreateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionCreateMutationExecutor,
    ConvexRequestSnapshot<SessionId>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CreateArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<CreateArgs, SessionId>(
    mutation: createMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, SessionCreateMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for session:promoteToParty.
class SessionPromoteToPartyMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionPromoteToPartyMutationExecutor(this._mutate);

  final Future<void> Function(PromoteToPartyArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required SessionId id, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for session:promoteToParty.
class SessionPromoteToPartyMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionPromoteToPartyMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionPromoteToPartyMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<PromoteToPartyArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<PromoteToPartyArgs, void>(
        mutation: promoteToPartyMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          SessionPromoteToPartyMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for session:softDelete.
class SessionSoftDeleteMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionSoftDeleteMutationExecutor(this._mutate);

  final Future<void> Function(SoftDeleteArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required SessionId id, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for session:softDelete.
class SessionSoftDeleteMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionSoftDeleteMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionSoftDeleteMutationExecutor,
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
        builder(context, SessionSoftDeleteMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for session:update.
class SessionUpdateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionUpdateMutationExecutor(this._mutate);

  final Future<void> Function(UpdateArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    Optional<String> description = const Optional.absent(),
    Optional<double?> endedAt = const Optional.absent(),
    required SessionId id,
    Optional<String> name = const Optional.absent(),
    Optional<double> startedAt = const Optional.absent(),
  }) => _mutate((
    description: description,
    endedAt: endedAt,
    id: id,
    name: name,
    startedAt: startedAt,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    Optional<String> description = const Optional.absent(),
    Optional<double?> endedAt = const Optional.absent(),
    required SessionId id,
    Optional<String> name = const Optional.absent(),
    Optional<double> startedAt = const Optional.absent(),
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        description: description,
        endedAt: endedAt,
        id: id,
        name: name,
        startedAt: startedAt,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for session:update.
class SessionUpdateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionUpdateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionUpdateMutationExecutor,
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
        builder(context, SessionUpdateMutationExecutor(mutate), snapshot),
  );
}

/// Flutter widget for session:get.
class SessionGetTypeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const SessionGetTypeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const SessionGetTypeQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.id,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, SessionDocument)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<SessionDocument>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final SessionId id;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<GetTypeArgs, SessionDocument>.snapshot(
        query: getValueQueryReference,
        args: (id: id),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<GetTypeArgs, SessionDocument>(
      query: getValueQueryReference,
      args: (id: id),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for session:listCurrent.
class SessionListCurrentQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const SessionListCurrentQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const SessionListCurrentQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<SessionDocument>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<SessionDocument>>,
  )?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<NoArgs, List<SessionDocument>>.snapshot(
        query: listCurrentQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<SessionDocument>>(
      query: listCurrentQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
