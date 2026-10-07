// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/user.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for user:deleteCurrent.
class UserDeleteCurrentMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserDeleteCurrentMutationExecutor(this._mutate);

  final Future<void> Function(DeleteCurrentArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required String password}) =>
      _mutate((password: password));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required String password, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((password: password)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:deleteCurrent.
class UserDeleteCurrentMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserDeleteCurrentMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserDeleteCurrentMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<DeleteCurrentArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<DeleteCurrentArgs, void>(
    mutation: deleteCurrentMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, UserDeleteCurrentMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for user:ensureCurrent.
class UserEnsureCurrentMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserEnsureCurrentMutationExecutor(this._mutate);

  final Future<UserId> Function(EnsureCurrentArgs) _mutate;

  /// Runs the mutation.
  Future<UserId> call({Optional<String> timeZone = const Optional.absent()}) =>
      _mutate((timeZone: timeZone));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    Optional<String> timeZone = const Optional.absent(),
    void Function(UserId result)? onSuccess,
  }) {
    unawaited(
      _mutate((timeZone: timeZone)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:ensureCurrent.
class UserEnsureCurrentMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserEnsureCurrentMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
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
  final TypedOptimisticUpdate<EnsureCurrentArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<EnsureCurrentArgs, UserId>(
        mutation: ensureCurrentMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserEnsureCurrentMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:generateAvatarUploadUrl.
class UserGenerateAvatarUploadUrlMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserGenerateAvatarUploadUrlMutationExecutor(this._mutate);

  final Future<String> Function(NoArgs) _mutate;

  /// Runs the mutation.
  Future<String> call() => _mutate(const NoArgs());

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({void Function(String result)? onSuccess}) {
    unawaited(
      _mutate(const NoArgs()).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:generateAvatarUploadUrl.
class UserGenerateAvatarUploadUrlMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserGenerateAvatarUploadUrlMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserGenerateAvatarUploadUrlMutationExecutor,
    ConvexRequestSnapshot<String>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<NoArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<NoArgs, String>(
    mutation: generateAvatarUploadUrlMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      UserGenerateAvatarUploadUrlMutationExecutor(mutate),
      snapshot,
    ),
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

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required UpdateAccentColorArgsAccentColor accentColor,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((accentColor: accentColor)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateAccentColor.
class UserUpdateAccentColorMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateAccentColorMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
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

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateAccentColorArgs, void>(
        mutation: updateAccentColorMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateAccentColorMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateAvatar.
class UserUpdateAvatarMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateAvatarMutationExecutor(this._mutate);

  final Future<String?> Function(UpdateAvatarArgs) _mutate;

  /// Runs the mutation.
  Future<String?> call({required StorageId? storageId}) =>
      _mutate((storageId: storageId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required StorageId? storageId,
    void Function(String? result)? onSuccess,
  }) {
    unawaited(
      _mutate((storageId: storageId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateAvatar.
class UserUpdateAvatarMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateAvatarMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateAvatarMutationExecutor,
    ConvexRequestSnapshot<String?>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateAvatarArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateAvatarArgs, String?>(
        mutation: updateAvatarMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateAvatarMutationExecutor(mutate),
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

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required DrinkId? defaultDrink,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((defaultDrink: defaultDrink)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateDefaultDrink.
class UserUpdateDefaultDrinkMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateDefaultDrinkMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
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

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateDefaultDrinkArgs, void>(
        mutation: updateDefaultDrinkMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
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

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required UpdateDrinkLogSortOrderArgsDrinkLogSortOrder drinkLogSortOrder,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((drinkLogSortOrder: drinkLogSortOrder)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateDrinkLogSortOrder.
class UserUpdateDrinkLogSortOrderMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateDrinkLogSortOrderMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
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

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateDrinkLogSortOrderArgs, void>(
        mutation: updateDrinkLogSortOrderMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
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

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required double endOfDayBoundary,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((endOfDayBoundary: endOfDayBoundary)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateEndOfDayBoundary.
class UserUpdateEndOfDayBoundaryMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateEndOfDayBoundaryMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
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

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateEndOfDayBoundaryArgs, void>(
        mutation: updateEndOfDayBoundaryMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateEndOfDayBoundaryMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Callable typed mutation for user:updateTimeZone.
class UserUpdateTimeZoneMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const UserUpdateTimeZoneMutationExecutor(this._mutate);

  final Future<void> Function(UpdateTimeZoneArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required String timeZone}) =>
      _mutate((timeZone: timeZone));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required String timeZone, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((timeZone: timeZone)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateTimeZone.
class UserUpdateTimeZoneMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateTimeZoneMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    UserUpdateTimeZoneMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateTimeZoneArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateTimeZoneArgs, void>(
        mutation: updateTimeZoneMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          UserUpdateTimeZoneMutationExecutor(mutate),
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

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({required String username, void Function(void result)? onSuccess}) {
    unawaited(
      _mutate((username: username)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for user:updateUsername.
class UserUpdateUsernameMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const UserUpdateUsernameMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
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

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<UpdateUsernameArgs, void>(
        mutation: updateUsernameMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
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

/// Flutter widget for user:searchTimeZones.
class UserSearchTimeZonesQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const UserSearchTimeZonesQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.search,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const UserSearchTimeZonesQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.search,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<String>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<List<String>>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final String search;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<SearchTimeZonesArgs, List<String>>.snapshot(
        query: searchTimeZonesQueryReference,
        args: (search: search),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<SearchTimeZonesArgs, List<String>>(
      query: searchTimeZonesQueryReference,
      args: (search: search),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
