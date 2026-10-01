// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/drink.dart';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for drink:create.
class DrinkCreateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const DrinkCreateMutationExecutor(this._mutate);

  final Future<DrinkId> Function(CreateArgs) _mutate;

  /// Runs the mutation.
  Future<DrinkId> call({
    required double alcoholPercentage,
    required DrinkCategory drinkCategory,
    required String name,
  }) => _mutate((
    alcoholPercentage: alcoholPercentage,
    drinkCategory: drinkCategory,
    name: name,
  ));
}

/// Flutter widget for drink:create.
class DrinkCreateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const DrinkCreateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    DrinkCreateMutationExecutor,
    ConvexRequestSnapshot<DrinkId>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CreateArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) => ConvexMutation<CreateArgs, DrinkId>(
    mutation: createMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    builder: (context, mutate, snapshot) =>
        builder(context, DrinkCreateMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for drink:softDelete.
class DrinkSoftDeleteMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const DrinkSoftDeleteMutationExecutor(this._mutate);

  final Future<void> Function(SoftDeleteArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required DrinkId id}) => _mutate((id: id));
}

/// Flutter widget for drink:softDelete.
class DrinkSoftDeleteMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const DrinkSoftDeleteMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    DrinkSoftDeleteMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SoftDeleteArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) => ConvexMutation<SoftDeleteArgs, void>(
    mutation: softDeleteMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    builder: (context, mutate, snapshot) =>
        builder(context, DrinkSoftDeleteMutationExecutor(mutate), snapshot),
  );
}

/// Callable typed mutation for drink:update.
class DrinkUpdateMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const DrinkUpdateMutationExecutor(this._mutate);

  final Future<void> Function(UpdateArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    Optional<double> alcoholPercentage = const Optional.absent(),
    Optional<DrinkCategory> drinkCategory = const Optional.absent(),
    required DrinkId id,
    Optional<String> name = const Optional.absent(),
  }) => _mutate((
    alcoholPercentage: alcoholPercentage,
    drinkCategory: drinkCategory,
    id: id,
    name: name,
  ));
}

/// Flutter widget for drink:update.
class DrinkUpdateMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const DrinkUpdateMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    DrinkUpdateMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<UpdateArgs>? optimisticUpdate;

  @override
  Widget build(BuildContext context) => ConvexMutation<UpdateArgs, void>(
    mutation: updateMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    builder: (context, mutate, snapshot) =>
        builder(context, DrinkUpdateMutationExecutor(mutate), snapshot),
  );
}

/// Flutter widget for drink:get.
class DrinkGetTypeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const DrinkGetTypeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const DrinkGetTypeQuery.snapshot({
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

  final DrinkId id;

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

/// Flutter widget for drink:listAvailable.
class DrinkListAvailableQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const DrinkListAvailableQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const DrinkListAvailableQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<ListAvailableResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<ListAvailableResultItem>>,
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
      return ConvexTypedQuery<NoArgs, List<ListAvailableResultItem>>.snapshot(
        query: listAvailableQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<ListAvailableResultItem>>(
      query: listAvailableQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for drink:listCustom.
class DrinkListCustomQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const DrinkListCustomQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const DrinkListCustomQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<ListCustomResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<ListCustomResultItem>>,
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
      return ConvexTypedQuery<NoArgs, List<ListCustomResultItem>>.snapshot(
        query: listCustomQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<ListCustomResultItem>>(
      query: listCustomQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
