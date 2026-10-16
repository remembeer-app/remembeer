// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/beerpongTeam.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for beerpongTeam:addMember.
class BeerpongTeamAddMemberMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTeamAddMemberMutationExecutor(this._mutate);

  final Future<void> Function(AddMemberArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required BeerpongTeamId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTeamId id,
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

/// Flutter widget for beerpongTeam:addMember.
class BeerpongTeamAddMemberMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTeamAddMemberMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTeamAddMemberMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<AddMemberArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<AddMemberArgs, void>(
    mutation: addMemberMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTeamAddMemberMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongTeam:moveMember.
class BeerpongTeamMoveMemberMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTeamMoveMemberMutationExecutor(this._mutate);

  final Future<void> Function(MoveMemberArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    required BeerpongTeamId id,
    required BeerpongTeamId targetTeamId,
    required UserId userId,
  }) => _mutate((id: id, targetTeamId: targetTeamId, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTeamId id,
    required BeerpongTeamId targetTeamId,
    required UserId userId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id, targetTeamId: targetTeamId, userId: userId)).then<void>((
        result,
      ) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTeam:moveMember.
class BeerpongTeamMoveMemberMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTeamMoveMemberMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTeamMoveMemberMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<MoveMemberArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<MoveMemberArgs, void>(
    mutation: moveMemberMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTeamMoveMemberMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongTeam:removeMember.
class BeerpongTeamRemoveMemberMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTeamRemoveMemberMutationExecutor(this._mutate);

  final Future<void> Function(RemoveMemberArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required BeerpongTeamId id, required UserId userId}) =>
      _mutate((id: id, userId: userId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTeamId id,
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

/// Flutter widget for beerpongTeam:removeMember.
class BeerpongTeamRemoveMemberMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTeamRemoveMemberMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTeamRemoveMemberMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<RemoveMemberArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<RemoveMemberArgs, void>(
    mutation: removeMemberMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongTeamRemoveMemberMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongTeam:rename.
class BeerpongTeamRenameMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongTeamRenameMutationExecutor(this._mutate);

  final Future<void> Function(RenameArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required BeerpongTeamId id, required String name}) =>
      _mutate((id: id, name: name));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongTeamId id,
    required String name,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id, name: name)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongTeam:rename.
class BeerpongTeamRenameMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongTeamRenameMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongTeamRenameMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<RenameArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<RenameArgs, void>(
    mutation: renameMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, BeerpongTeamRenameMutationExecutor(mutate), snapshot),
  );
}
