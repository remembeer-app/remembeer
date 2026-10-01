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
  final OptimisticUpdate? optimisticUpdate;

  @override
  Widget build(BuildContext context) => ConvexMutation<NoArgs, UserId>(
    mutation: ensureCurrentMutationReference,
    client: client,
    optimisticUpdate: optimisticUpdate,
    builder: (context, mutate, snapshot) =>
        builder(context, UserEnsureCurrentMutationExecutor(mutate), snapshot),
  );
}
