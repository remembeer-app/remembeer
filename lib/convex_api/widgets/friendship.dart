// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/friendship.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for friendship:accept.
class FriendshipAcceptMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const FriendshipAcceptMutationExecutor(this._mutate);

  final Future<void> Function(AcceptArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required UserId userId}) => _mutate((userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required UserId userId, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for friendship:accept.
class FriendshipAcceptMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const FriendshipAcceptMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    FriendshipAcceptMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<AcceptArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<AcceptArgs, void>(
    mutation: acceptMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, FriendshipAcceptMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for friendship:cancel.
class FriendshipCancelMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const FriendshipCancelMutationExecutor(this._mutate);

  final Future<void> Function(CancelArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required UserId userId}) => _mutate((userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required UserId userId, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for friendship:cancel.
class FriendshipCancelMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const FriendshipCancelMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    FriendshipCancelMutationExecutor,
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
    builder: (context, mutate, snapshot) =>
        builder(context, FriendshipCancelMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for friendship:decline.
class FriendshipDeclineMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const FriendshipDeclineMutationExecutor(this._mutate);

  final Future<void> Function(DeclineArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required UserId userId}) => _mutate((userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required UserId userId, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for friendship:decline.
class FriendshipDeclineMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const FriendshipDeclineMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    FriendshipDeclineMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<DeclineArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<DeclineArgs, void>(
    mutation: declineMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, FriendshipDeclineMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for friendship:remove.
class FriendshipRemoveMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const FriendshipRemoveMutationExecutor(this._mutate);

  final Future<void> Function(RemoveArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required UserId userId}) => _mutate((userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required UserId userId, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for friendship:remove.
class FriendshipRemoveMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const FriendshipRemoveMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    FriendshipRemoveMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<RemoveArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<RemoveArgs, void>(
    mutation: removeMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, FriendshipRemoveMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for friendship:sendRequest.
class FriendshipSendRequestMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const FriendshipSendRequestMutationExecutor(this._mutate);

  final Future<void> Function(SendRequestArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required UserId userId}) => _mutate((userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required UserId userId, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for friendship:sendRequest.
class FriendshipSendRequestMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const FriendshipSendRequestMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    FriendshipSendRequestMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SendRequestArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SendRequestArgs, void>(
    mutation: sendRequestMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      FriendshipSendRequestMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Flutter widget for friendship:getStatus.
class FriendshipGetStatusQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const FriendshipGetStatusQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.userId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const FriendshipGetStatusQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.userId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, GetStatusResult)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<GetStatusResult>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final UserId userId;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<GetStatusArgs, GetStatusResult>.snapshot(
        query: getStatusQueryReference,
        args: (userId: userId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<GetStatusArgs, GetStatusResult>(
      query: getStatusQueryReference,
      args: (userId: userId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for friendship:listCurrent.
class FriendshipListCurrentQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const FriendshipListCurrentQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const FriendshipListCurrentQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<ListCurrentResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<ListCurrentResultItem>>,
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
      return ConvexTypedQuery<NoArgs, List<ListCurrentResultItem>>.snapshot(
        query: listCurrentQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<ListCurrentResultItem>>(
      query: listCurrentQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for friendship:listRequests.
class FriendshipListRequestsQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const FriendshipListRequestsQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const FriendshipListRequestsQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<ListRequestsResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<ListRequestsResultItem>>,
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
      return ConvexTypedQuery<NoArgs, List<ListRequestsResultItem>>.snapshot(
        query: listRequestsQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<ListRequestsResultItem>>(
      query: listRequestsQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
