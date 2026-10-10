// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/leaderboard.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for leaderboard:ban.
class LeaderboardBanMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardBanMutationExecutor(this._mutate);

  final Future<void> Function(BanArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required LeaderboardId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required LeaderboardId id,
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

/// Flutter widget for leaderboard:ban.
class LeaderboardBanMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardBanMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardBanMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<BanArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<BanArgs, void>(
    mutation: banMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, LeaderboardBanMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for leaderboard:create.
class LeaderboardCreateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardCreateMutationExecutor(this._mutate);

  final Future<LeaderboardId> Function(CreateArgs) _mutate;

  /// Runs the mutation.
  Future<LeaderboardId> call({
    required CreateArgsIconName iconName,
    required String name,
  }) => _mutate((iconName: iconName, name: name));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required CreateArgsIconName iconName,
    required String name,
    void Function(LeaderboardId result)? onSuccess,
  }) {
    unawaited(
      _mutate((iconName: iconName, name: name)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for leaderboard:create.
class LeaderboardCreateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardCreateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardCreateMutationExecutor,
    ConvexRequestSnapshot<LeaderboardId>,
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
      ConvexMutation<CreateArgs, LeaderboardId>(
        mutation: createMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          LeaderboardCreateMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for leaderboard:join.
class LeaderboardJoinMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardJoinMutationExecutor(this._mutate);

  final Future<JoinResult> Function(JoinArgs) _mutate;

  /// Runs the mutation.
  Future<JoinResult> call({required LeaderboardId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required LeaderboardId id,
    void Function(JoinResult result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for leaderboard:join.
class LeaderboardJoinMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardJoinMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardJoinMutationExecutor,
    ConvexRequestSnapshot<JoinResult>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<JoinArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<JoinArgs, JoinResult>(
    mutation: joinMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, LeaderboardJoinMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for leaderboard:leave.
class LeaderboardLeaveMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardLeaveMutationExecutor(this._mutate);

  final Future<void> Function(LeaveArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required LeaderboardId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required LeaderboardId id, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for leaderboard:leave.
class LeaderboardLeaveMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardLeaveMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardLeaveMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<LeaveArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<LeaveArgs, void>(
    mutation: leaveMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, LeaderboardLeaveMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for leaderboard:remove.
class LeaderboardRemoveMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardRemoveMutationExecutor(this._mutate);

  final Future<void> Function(RemoveArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required LeaderboardId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required LeaderboardId id,
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

/// Flutter widget for leaderboard:remove.
class LeaderboardRemoveMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardRemoveMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardRemoveMutationExecutor,
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
        builder(context, LeaderboardRemoveMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for leaderboard:softDelete.
class LeaderboardSoftDeleteMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardSoftDeleteMutationExecutor(this._mutate);

  final Future<void> Function(SoftDeleteArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required LeaderboardId id}) => _mutate((id: id));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required LeaderboardId id, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((id: id)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for leaderboard:softDelete.
class LeaderboardSoftDeleteMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardSoftDeleteMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardSoftDeleteMutationExecutor,
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
    builder: (context, mutate, snapshot) => builder(
      context,
      LeaderboardSoftDeleteMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for leaderboard:unban.
class LeaderboardUnbanMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardUnbanMutationExecutor(this._mutate);

  final Future<void> Function(UnbanArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required LeaderboardId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required LeaderboardId id,
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

/// Flutter widget for leaderboard:unban.
class LeaderboardUnbanMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardUnbanMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardUnbanMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UnbanArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<UnbanArgs, void>(
    mutation: unbanMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, LeaderboardUnbanMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for leaderboard:update.
class LeaderboardUpdateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const LeaderboardUpdateMutationExecutor(this._mutate);

  final Future<void> Function(UpdateArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    Optional<UpdateArgsIconName> iconName = const Optional.absent(),
    required LeaderboardId id,
    Optional<String> name = const Optional.absent(),
  }) => _mutate((iconName: iconName, id: id, name: name));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    Optional<UpdateArgsIconName> iconName = const Optional.absent(),
    required LeaderboardId id,
    Optional<String> name = const Optional.absent(),
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((iconName: iconName, id: id, name: name)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for leaderboard:update.
class LeaderboardUpdateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const LeaderboardUpdateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    LeaderboardUpdateMutationExecutor,
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
        builder(context, LeaderboardUpdateMutationExecutor(mutate), snapshot),
  );
}

/// Flutter widget for leaderboard:findByInviteCode.
class LeaderboardFindByInviteCodeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const LeaderboardFindByInviteCodeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.inviteCode,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const LeaderboardFindByInviteCodeQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.inviteCode,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, FindByInviteCodeResult?)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<FindByInviteCodeResult?>,
  )?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final String inviteCode;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<
        FindByInviteCodeArgs,
        FindByInviteCodeResult?
      >.snapshot(
        query: findByInviteCodeQueryReference,
        args: (inviteCode: inviteCode),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<FindByInviteCodeArgs, FindByInviteCodeResult?>(
      query: findByInviteCodeQueryReference,
      args: (inviteCode: inviteCode),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for leaderboard:get.
class LeaderboardGetTypeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const LeaderboardGetTypeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const LeaderboardGetTypeQuery.snapshot({
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

  final LeaderboardId id;

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

/// Flutter widget for leaderboard:listCurrent.
class LeaderboardListCurrentQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const LeaderboardListCurrentQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const LeaderboardListCurrentQuery.snapshot({
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

/// Flutter widget for leaderboard:standings.
class LeaderboardStandingsQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const LeaderboardStandingsQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
    this.month = const Optional.absent(),
    this.refreshAt = const Optional.absent(),
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const LeaderboardStandingsQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.id,
    this.month = const Optional.absent(),
    this.refreshAt = const Optional.absent(),
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

  final LeaderboardId id;
  final Optional<String> month;
  final Optional<double> refreshAt;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<StandingsArgs, StandingsResult>.snapshot(
        query: standingsQueryReference,
        args: (id: id, month: month, refreshAt: refreshAt),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<StandingsArgs, StandingsResult>(
      query: standingsQueryReference,
      args: (id: id, month: month, refreshAt: refreshAt),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
