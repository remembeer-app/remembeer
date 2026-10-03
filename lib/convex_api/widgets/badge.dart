// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/badge.dart';

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
