// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/sessionMember.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for sessionMember:accept.
class SessionMemberAcceptMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberAcceptMutationExecutor(this._mutate);

  final Future<void> Function(AcceptArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId}) =>
      _mutate((sessionId: sessionId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:accept.
class SessionMemberAcceptMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberAcceptMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberAcceptMutationExecutor,
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
        builder(context, SessionMemberAcceptMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for sessionMember:ban.
class SessionMemberBanMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberBanMutationExecutor(this._mutate);

  final Future<void> Function(BanArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId, required UserId userId}) =>
      _mutate((sessionId: sessionId, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId, userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:ban.
class SessionMemberBanMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberBanMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberBanMutationExecutor,
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
        builder(context, SessionMemberBanMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for sessionMember:decline.
class SessionMemberDeclineMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberDeclineMutationExecutor(this._mutate);

  final Future<void> Function(DeclineArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId}) =>
      _mutate((sessionId: sessionId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:decline.
class SessionMemberDeclineMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberDeclineMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberDeclineMutationExecutor,
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
    builder: (context, mutate, snapshot) => builder(
      context,
      SessionMemberDeclineMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for sessionMember:invite.
class SessionMemberInviteMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberInviteMutationExecutor(this._mutate);

  final Future<void> Function(InviteArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId, required UserId userId}) =>
      _mutate((sessionId: sessionId, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId, userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:invite.
class SessionMemberInviteMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberInviteMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberInviteMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<InviteArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<InviteArgs, void>(
    mutation: inviteMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, SessionMemberInviteMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for sessionMember:leave.
class SessionMemberLeaveMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberLeaveMutationExecutor(this._mutate);

  final Future<void> Function(LeaveArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId}) =>
      _mutate((sessionId: sessionId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:leave.
class SessionMemberLeaveMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberLeaveMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberLeaveMutationExecutor,
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
        builder(context, SessionMemberLeaveMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for sessionMember:remove.
class SessionMemberRemoveMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberRemoveMutationExecutor(this._mutate);

  final Future<void> Function(RemoveArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId, required UserId userId}) =>
      _mutate((sessionId: sessionId, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId, userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:remove.
class SessionMemberRemoveMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberRemoveMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberRemoveMutationExecutor,
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
        builder(context, SessionMemberRemoveMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for sessionMember:setRole.
class SessionMemberSetRoleMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberSetRoleMutationExecutor(this._mutate);

  final Future<void> Function(SetRoleArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    required SessionMemberRole role,
    required SessionId sessionId,
    required UserId userId,
  }) => _mutate((role: role, sessionId: sessionId, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionMemberRole role,
    required SessionId sessionId,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((role: role, sessionId: sessionId, userId: userId)).then<void>((
        result,
      ) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:setRole.
class SessionMemberSetRoleMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberSetRoleMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberSetRoleMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SetRoleArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SetRoleArgs, void>(
    mutation: setRoleMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      SessionMemberSetRoleMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for sessionMember:unban.
class SessionMemberUnbanMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const SessionMemberUnbanMutationExecutor(this._mutate);

  final Future<void> Function(UnbanArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required SessionId sessionId, required UserId userId}) =>
      _mutate((sessionId: sessionId, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId, userId: userId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for sessionMember:unban.
class SessionMemberUnbanMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const SessionMemberUnbanMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    SessionMemberUnbanMutationExecutor,
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
        builder(context, SessionMemberUnbanMutationExecutor(mutate), snapshot),
  );
}

/// Flutter widget for sessionMember:findInvitee.
class SessionMemberFindInviteeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const SessionMemberFindInviteeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.sessionId,
    required this.username,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const SessionMemberFindInviteeQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.sessionId,
    required this.username,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<FindInviteeResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<FindInviteeResultItem>>,
  )?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final SessionId sessionId;
  final String username;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<
        FindInviteeArgs,
        List<FindInviteeResultItem>
      >.snapshot(
        query: findInviteeQueryReference,
        args: (sessionId: sessionId, username: username),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<FindInviteeArgs, List<FindInviteeResultItem>>(
      query: findInviteeQueryReference,
      args: (sessionId: sessionId, username: username),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for sessionMember:listForSession.
class SessionMemberListForSessionQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const SessionMemberListForSessionQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const SessionMemberListForSessionQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.sessionId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<ListForSessionResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<ListForSessionResultItem>>,
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
        List<ListForSessionResultItem>
      >.snapshot(
        query: listForSessionQueryReference,
        args: (sessionId: sessionId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<ListForSessionArgs, List<ListForSessionResultItem>>(
      query: listForSessionQueryReference,
      args: (sessionId: sessionId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for sessionMember:listInvitations.
class SessionMemberListInvitationsQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const SessionMemberListInvitationsQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const SessionMemberListInvitationsQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<ListInvitationsResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<ListInvitationsResultItem>>,
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
      return ConvexTypedQuery<NoArgs, List<ListInvitationsResultItem>>.snapshot(
        query: listInvitationsQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<ListInvitationsResultItem>>(
      query: listInvitationsQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
