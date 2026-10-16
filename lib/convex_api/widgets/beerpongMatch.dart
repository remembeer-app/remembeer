// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/beerpongMatch.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for beerpongMatch:correctResult.
class BeerpongMatchCorrectResultMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongMatchCorrectResultMutationExecutor(this._mutate);

  final Future<void> Function(CorrectResultArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    required BeerpongMatchId id,
    required BeerpongTeamId winnerTeamId,
  }) => _mutate((id: id, winnerTeamId: winnerTeamId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongMatchId id,
    required BeerpongTeamId winnerTeamId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id, winnerTeamId: winnerTeamId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongMatch:correctResult.
class BeerpongMatchCorrectResultMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongMatchCorrectResultMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongMatchCorrectResultMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<CorrectResultArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<CorrectResultArgs, void>(
    mutation: correctResultMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongMatchCorrectResultMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for beerpongMatch:recordResult.
class BeerpongMatchRecordResultMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const BeerpongMatchRecordResultMutationExecutor(this._mutate);

  final Future<void> Function(RecordResultArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    required BeerpongMatchId id,
    required BeerpongTeamId winnerTeamId,
  }) => _mutate((id: id, winnerTeamId: winnerTeamId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required BeerpongMatchId id,
    required BeerpongTeamId winnerTeamId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((id: id, winnerTeamId: winnerTeamId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for beerpongMatch:recordResult.
class BeerpongMatchRecordResultMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const BeerpongMatchRecordResultMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    BeerpongMatchRecordResultMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<RecordResultArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<RecordResultArgs, void>(
    mutation: recordResultMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      BeerpongMatchRecordResultMutationExecutor(mutate),
      snapshot,
    ),
  );
}
