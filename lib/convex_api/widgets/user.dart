// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/user.dart';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for user:ensureCurrent.
class UserEnsureCurrentMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserEnsureCurrentMutationExecutor(this._mutate);

  final Future<UserId> Function(NoArgs) _mutate;

  /// Runs the mutation.
  Future<UserId> call() => _mutate(const NoArgs());
}

/// Flutter widget for user:ensureCurrent.
class UserEnsureCurrentMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserEnsureCurrentMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserEnsureCurrentMutationExecutor,
    ConvexRequestSnapshot<UserId>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<NoArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) => ConvexMutation<NoArgs, UserId>(
    mutation: ensureCurrentMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    builder: (context, mutate, snapshot) =>
        builder(context, UserEnsureCurrentMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for user:updateAccentColor.
class UserUpdateAccentColorMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateAccentColorMutationExecutor(this._mutate);

  final Future<void> Function(UpdateAccentColorArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required UpdateAccentColorArgsAccentColor accentColor}) =>
      _mutate((accentColor: accentColor));
}

/// Flutter widget for user:updateAccentColor.
class UserUpdateAccentColorMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateAccentColorMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateAccentColorMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateAccentColorArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateAccentColorArgs, void>(
        mutation: updateAccentColorMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateAccentColorMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateAvatarUrl.
class UserUpdateAvatarUrlMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateAvatarUrlMutationExecutor(this._mutate);

  final Future<void> Function(UpdateAvatarUrlArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required String? avatarUrl}) =>
      _mutate((avatarUrl: avatarUrl));
}

/// Flutter widget for user:updateAvatarUrl.
class UserUpdateAvatarUrlMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateAvatarUrlMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateAvatarUrlMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateAvatarUrlArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateAvatarUrlArgs, void>(
        mutation: updateAvatarUrlMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateAvatarUrlMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateDefaultDrink.
class UserUpdateDefaultDrinkMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateDefaultDrinkMutationExecutor(this._mutate);

  final Future<void> Function(UpdateDefaultDrinkArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required DrinkId? defaultDrink}) =>
      _mutate((defaultDrink: defaultDrink));
}

/// Flutter widget for user:updateDefaultDrink.
class UserUpdateDefaultDrinkMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateDefaultDrinkMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateDefaultDrinkMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateDefaultDrinkArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateDefaultDrinkArgs, void>(
        mutation: updateDefaultDrinkMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateDefaultDrinkMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateDrinkLogSortOrder.
class UserUpdateDrinkLogSortOrderMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateDrinkLogSortOrderMutationExecutor(this._mutate);

  final Future<void> Function(UpdateDrinkLogSortOrderArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    required UpdateDrinkLogSortOrderArgsDrinkLogSortOrder drinkLogSortOrder,
  }) => _mutate((drinkLogSortOrder: drinkLogSortOrder));
}

/// Flutter widget for user:updateDrinkLogSortOrder.
class UserUpdateDrinkLogSortOrderMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateDrinkLogSortOrderMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateDrinkLogSortOrderMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateDrinkLogSortOrderArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateDrinkLogSortOrderArgs, void>(
        mutation: updateDrinkLogSortOrderMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateDrinkLogSortOrderMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateEndOfDayBoundary.
class UserUpdateEndOfDayBoundaryMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateEndOfDayBoundaryMutationExecutor(this._mutate);

  final Future<void> Function(UpdateEndOfDayBoundaryArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required double endOfDayBoundary}) =>
      _mutate((endOfDayBoundary: endOfDayBoundary));
}

/// Flutter widget for user:updateEndOfDayBoundary.
class UserUpdateEndOfDayBoundaryMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateEndOfDayBoundaryMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateEndOfDayBoundaryMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateEndOfDayBoundaryArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateEndOfDayBoundaryArgs, void>(
        mutation: updateEndOfDayBoundaryMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateEndOfDayBoundaryMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateUsername.
class UserUpdateUsernameMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateUsernameMutationExecutor(this._mutate);

  final Future<void> Function(UpdateUsernameArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required String username}) =>
      _mutate((username: username));
}

/// Flutter widget for user:updateUsername.
class UserUpdateUsernameMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateUsernameMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateUsernameMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateUsernameArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateUsernameArgs, void>(
        mutation: updateUsernameMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateUsernameMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Flutter widget for user:current.
class UserCurrentQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const UserCurrentQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const UserCurrentQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, CurrentResult)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<CurrentResult>)?
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
      return ConvexTypedQuery<NoArgs, CurrentResult>.snapshot(
        query: currentQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, CurrentResult>(
      query: currentQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
