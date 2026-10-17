// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/badge.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for badge:setVisibility.
class BadgeSetVisibilityMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BadgeSetVisibilityMutationExecutor(this._mutate);

  final Future<void> Function(SetVisibilityArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required String badgeKey, required bool isShown}) =>
      _mutate((badgeKey: badgeKey, isShown: isShown));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required String badgeKey,
    required bool isShown,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((badgeKey: badgeKey, isShown: isShown)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for badge:setVisibility.
class BadgeSetVisibilityMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BadgeSetVisibilityMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BadgeSetVisibilityMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SetVisibilityArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SetVisibilityArgs, void>(
    mutation: setVisibilityMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) =>
        builder(context, BadgeSetVisibilityMutationExecutor(mutate), snapshot),
  );
}

/// Flutter widget for badge:listCurrent.
class BadgeListCurrentQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const BadgeListCurrentQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const BadgeListCurrentQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<BadgeDocument>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<List<BadgeDocument>>)?
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
      return ConvexTypedQuery<NoArgs, List<BadgeDocument>>.snapshot(
        query: listCurrentQueryReference,
        args: const NoArgs(),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<NoArgs, List<BadgeDocument>>(
      query: listCurrentQueryReference,
      args: const NoArgs(),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
