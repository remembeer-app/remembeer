import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drag_auto_scroller.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/drink/service/drink_list_service.dart';
import 'package:remembeer/drink/widget/drink_group_section.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';

class DrinkGroupList extends StatefulWidget {
  const DrinkGroupList({super.key});

  @override
  State<DrinkGroupList> createState() => _DrinkGroupListState();
}

class _DrinkGroupListState extends State<DrinkGroupList> {
  final _drinkListService = get<DrinkListService>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _drinkListService.drinkListDataStream,
      builder: (context, sessions) {
        final hasContent = sessions.any((s) => s.drinks.isNotEmpty);
        if (!hasContent) {
          return Expanded(child: _buildEmptyState(context));
        }

        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return DragStateProvider(
                child: DragAutoScroller(
                  scrollController: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: _buildContent(sessions, constraints.maxHeight),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(List<Session> sessions, double viewportHeight) {
    final sharedSessions = <Session>[];
    final soloSessions = <Session>[];

    for (final session in sessions) {
      if (session.isSoloSession) {
        soloSessions.add(session);
      } else {
        sharedSessions.add(session);
      }
    }

    final sessionSections = <Widget>[];
    for (final session in sharedSessions) {
      sessionSections.add(
        DrinkGroupSection(isSharedSession: true, sessions: [session]),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...sessionSections,
        DrinkGroupSection(
          isSharedSession: false,
          sessions: soloSessions,
          minHeight: viewportHeight / 2,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_drinks_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              'No drinks logged',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
            Text(
              'Tap + to add your first drink',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
