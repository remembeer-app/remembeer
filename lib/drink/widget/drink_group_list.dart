import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drag_auto_scroller.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_list_data.dart';
import 'package:remembeer/drink/service/drink_list_service.dart';
import 'package:remembeer/drink/widget/drink_group_section.dart';
import 'package:remembeer/ioc/ioc_container.dart';

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
      builder: (context, data) {
        if (data.drinks.isEmpty && data.sessions.isEmpty) {
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
                    child: _buildContent(data, constraints.maxHeight),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(DrinkListData data, double viewportHeight) {
    final drinksBySessionId = <String?, List<Drink>>{};
    for (final drink in data.drinks) {
      drinksBySessionId.putIfAbsent(drink.sessionId, () => []).add(drink);
    }

    final sessionSections = <Widget>[];
    for (final session in data.sessions) {
      final sessionDrinks = drinksBySessionId[session.id] ?? [];
      sessionSections.add(
        DrinkGroupSection(session: session, drinks: sessionDrinks),
      );
    }

    final drinksWithoutSession = drinksBySessionId[null] ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...sessionSections,
        DrinkGroupSection(
          session: null,
          drinks: drinksWithoutSession,
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
            gap16,
            Text(
              'No drinks logged',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            gap8,
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
