// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable
// ignore_for_file: unnecessary_import

import '../api.dart';
import '../modules/partyQuest.dart';

import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/widgets.dart';

/// Callable typed mutation for partyQuest:selectPartner.
class PartyQuestSelectPartnerMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyQuestSelectPartnerMutationExecutor(this._mutate);

  final Future<bool> Function(SelectPartnerArgs) _mutate;

  /// Runs the mutation.
  Future<bool> call({
    required PartyQuestId questId,
    required UserId selectedUserId,
  }) => _mutate((questId: questId, selectedUserId: selectedUserId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required PartyQuestId questId,
    required UserId selectedUserId,
    void Function(bool result)? onSuccess,
  }) {
    unawaited(
      _mutate((questId: questId, selectedUserId: selectedUserId)).then<void>((
        result,
      ) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyQuest:selectPartner.
class PartyQuestSelectPartnerMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyQuestSelectPartnerMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyQuestSelectPartnerMutationExecutor,
    ConvexRequestSnapshot<bool>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SelectPartnerArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SelectPartnerArgs, bool>(
    mutation: selectPartnerMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyQuestSelectPartnerMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyQuest:setEnabled.
class PartyQuestSetEnabledMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyQuestSetEnabledMutationExecutor(this._mutate);

  final Future<void> Function(SetEnabledArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({required bool enabled, required SessionId sessionId}) =>
      _mutate((enabled: enabled, sessionId: sessionId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required bool enabled,
    required SessionId sessionId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((enabled: enabled, sessionId: sessionId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyQuest:setEnabled.
class PartyQuestSetEnabledMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyQuestSetEnabledMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyQuestSetEnabledMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SetEnabledArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SetEnabledArgs, void>(
    mutation: setEnabledMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyQuestSetEnabledMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyQuest:setSchedule.
class PartyQuestSetScheduleMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyQuestSetScheduleMutationExecutor(this._mutate);

  final Future<void> Function(SetScheduleArgs) _mutate;

  /// Runs the mutation.
  Future<void> call({
    required double defaultDurationMinutes,
    required double maxIntervalMinutes,
    required double minIntervalMinutes,
    required SessionId sessionId,
  }) => _mutate((
    defaultDurationMinutes: defaultDurationMinutes,
    maxIntervalMinutes: maxIntervalMinutes,
    minIntervalMinutes: minIntervalMinutes,
    sessionId: sessionId,
  ));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required double defaultDurationMinutes,
    required double maxIntervalMinutes,
    required double minIntervalMinutes,
    required SessionId sessionId,
    void Function(void result)? onSuccess,
  }) {
    unawaited(
      _mutate((
        defaultDurationMinutes: defaultDurationMinutes,
        maxIntervalMinutes: maxIntervalMinutes,
        minIntervalMinutes: minIntervalMinutes,
        sessionId: sessionId,
      )).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyQuest:setSchedule.
class PartyQuestSetScheduleMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyQuestSetScheduleMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyQuestSetScheduleMutationExecutor,
    ConvexRequestSnapshot<void>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<SetScheduleArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) => ConvexMutation<SetScheduleArgs, void>(
    mutation: setScheduleMutationReference,
    client: client,
    typedOptimisticUpdate: optimisticUpdate,
    mode: mode,
    builder: (context, mutate, snapshot) => builder(
      context,
      PartyQuestSetScheduleMutationExecutor(mutate),
      snapshot,
    ),
  );
}

/// Callable typed mutation for partyQuest:startNext.
class PartyQuestStartNextMutationExecutor {
  /// Creates an executor backed by the mutation widget.
  const PartyQuestStartNextMutationExecutor(this._mutate);

  final Future<PartyQuestId> Function(StartNextArgs) _mutate;

  /// Runs the mutation.
  Future<PartyQuestId> call({required SessionId sessionId}) =>
      _mutate((sessionId: sessionId));

  /// Starts the mutation, observing failures through the widget snapshot.
  ///
  /// [onSuccess] runs only on success. Errors from that callback are not
  /// suppressed. Use [call] when you need to await the result or handle errors.
  void run({
    required SessionId sessionId,
    void Function(PartyQuestId result)? onSuccess,
  }) {
    unawaited(
      _mutate((sessionId: sessionId)).then<void>((result) {
        onSuccess?.call(result);
      }, onError: (Object error, StackTrace stackTrace) {}),
    );
  }
}

/// Flutter widget for partyQuest:startNext.
class PartyQuestStartNextMutation extends StatelessWidget {
  /// Creates a typed mutation widget.
  const PartyQuestStartNextMutation({
    super.key,
    required this.builder,
    this.client,
    this.optimisticUpdate,
    this.mode = MutationMode.single,
  });

  /// Builds the UI with the callable mutation and current request state.
  final Widget Function(
    BuildContext,
    PartyQuestStartNextMutationExecutor,
    ConvexRequestSnapshot<PartyQuestId>,
  )
  builder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  /// Optional optimistic update for the mutation.
  final TypedOptimisticUpdate<StartNextArgs>? optimisticUpdate;

  /// Whether overlapping calls are rejected or coalesced to the latest value.
  final MutationMode mode;

  @override
  Widget build(BuildContext context) =>
      ConvexMutation<StartNextArgs, PartyQuestId>(
        mutation: startNextMutationReference,
        client: client,
        typedOptimisticUpdate: optimisticUpdate,
        mode: mode,
        builder: (context, mutate, snapshot) => builder(
          context,
          PartyQuestStartNextMutationExecutor(mutate),
          snapshot,
        ),
      );
}

/// Flutter widget for partyQuest:get.
class PartyQuestGetTypeQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyQuestGetTypeQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.id,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyQuestGetTypeQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.id,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, PartyQuestDocument)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(BuildContext, ConvexQuerySnapshot<PartyQuestDocument>)?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final PartyQuestId id;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<GetTypeArgs, PartyQuestDocument>.snapshot(
        query: getValueQueryReference,
        args: (id: id),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<GetTypeArgs, PartyQuestDocument>(
      query: getValueQueryReference,
      args: (id: id),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for partyQuest:listForSession.
class PartyQuestListForSessionQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyQuestListForSessionQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.sessionId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyQuestListForSessionQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.sessionId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<PartyQuestDocument>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<PartyQuestDocument>>,
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
        List<PartyQuestDocument>
      >.snapshot(
        query: listForSessionQueryReference,
        args: (sessionId: sessionId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<ListForSessionArgs, List<PartyQuestDocument>>(
      query: listForSessionQueryReference,
      args: (sessionId: sessionId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}

/// Flutter widget for partyQuest:partners.
class PartyQuestPartnersQuery extends StatelessWidget {
  /// Creates a typed query widget with default loading and error UI.
  const PartyQuestPartnersQuery({
    super.key,
    required this.builder,
    this.client,
    this.waitingBuilder,
    this.errorBuilder,
    required this.questId,
  }) : snapshotBuilder = null;

  /// Creates a query widget whose builder handles every snapshot state.
  const PartyQuestPartnersQuery.snapshot({
    super.key,
    required this.snapshotBuilder,
    this.client,
    required this.questId,
  }) : builder = null,
       waitingBuilder = null,
       errorBuilder = null;

  /// Builds the UI when query data is available.
  final Widget Function(BuildContext, List<PartnersResultItem>)? builder;

  /// Builds the UI from every query snapshot in snapshot mode.
  final Widget Function(
    BuildContext,
    ConvexQuerySnapshot<List<PartnersResultItem>>,
  )?
  snapshotBuilder;

  /// Overrides the initial loading UI.
  final WidgetBuilder? waitingBuilder;

  /// Overrides the error UI.
  final Widget Function(BuildContext, Object)? errorBuilder;

  /// Optional runtime client override.
  final ConvexRuntimeClient? client;

  final PartyQuestId questId;

  @override
  Widget build(BuildContext context) {
    final buildSnapshot = snapshotBuilder;
    if (buildSnapshot != null) {
      return ConvexTypedQuery<PartnersArgs, List<PartnersResultItem>>.snapshot(
        query: partnersQueryReference,
        args: (questId: questId),
        client: client,
        snapshotBuilder: buildSnapshot,
      );
    }
    return ConvexTypedQuery<PartnersArgs, List<PartnersResultItem>>(
      query: partnersQueryReference,
      args: (questId: questId),
      client: client,
      builder: builder!,
      waitingBuilder: waitingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
