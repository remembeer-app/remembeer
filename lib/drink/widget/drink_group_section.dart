import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/type/drink_with_session_id.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/drink/widget/midnight_divider.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/widget/session_divider.dart';

const _sessionBackgroundColor = Color(0x1A4CAF50);
const _sessionDragOverColor = Color(0x334CAF50);
const _sessionBorderColor = Color(0x404CAF50);
const _noSessionMinHeight = 100.0;
const _borderRadius = 12.0;

/// A unified widget that displays a group of drinks.
///
/// When [isSharedSession] is true, displays drinks within a single shared
/// session with a background and a [SessionDivider] at the bottom. The
/// [sessions] list must contain exactly one session.
///
/// When [isSharedSession] is false, displays solo drinks (each in its own
/// session container) with a transparent background and a minimum height
/// for easy drag-and-drop.
class DrinkGroupSection extends StatefulWidget {
  final bool isSharedSession;
  final List<Session> sessions;
  final double? minHeight;

  DrinkGroupSection({
    super.key,
    required this.isSharedSession,
    required this.sessions,
    this.minHeight,
  }) {
    invariant(
      !isSharedSession || sessions.length == 1,
      'Shared session mode requires exactly one session',
    );
  }

  @override
  State<DrinkGroupSection> createState() => _DrinkGroupSectionState();
}

class _DrinkGroupSectionState extends State<DrinkGroupSection> {
  final _drinkService = get<DrinkService>();
  var _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final isDragging = DragStateProvider.maybeOf(context)?.isDragging ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DragTarget<DrinkWithSessionId>(
        onWillAcceptWithDetails: (details) {
          final willAccept = _shouldAcceptDrink(details.data);
          if (willAccept && !_isDragOver) {
            setState(() => _isDragOver = true);
          }
          return willAccept;
        },
        onLeave: (_) => setState(() => _isDragOver = false),
        onAcceptWithDetails: (details) async {
          setState(() => _isDragOver = false);

          await _drinkService.moveDrinkBetweenSessions(
            drink: details.data.drink,
            fromSessionId: details.data.originalSessionId,
            toSessionId: widget.isSharedSession
                ? widget.sessions.first.id
                : null,
          );
        },
        builder: (context, candidateData, rejectedData) {
          final content = widget.isSharedSession
              ? _buildSharedSessionContent()
              : _buildSoloSessionsContent();

          final decoration = widget.isSharedSession
              ? BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(color: _sessionBorderColor),
                )
              : BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(_borderRadius),
                );

          if (widget.isSharedSession) {
            return Container(
              width: double.infinity,
              decoration: decoration,
              child: content,
            );
          } else {
            final effectiveMinHeight = (isDragging && widget.minHeight != null)
                ? widget.minHeight!
                : _noSessionMinHeight;

            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: effectiveMinHeight),
              child: DecoratedBox(
                decoration: decoration,
                child: SizedBox(width: double.infinity, child: content),
              ),
            );
          }
        },
      ),
    );
  }

  bool _shouldAcceptDrink(DrinkWithSessionId dragData) {
    // Don't accept if the drink is already in one of our sessions
    for (final session in widget.sessions) {
      if (dragData.originalSessionId == session.id) {
        return false;
      }
    }

    // For solo sessions area, accept any drink not already here
    if (!widget.isSharedSession) {
      return true;
    }

    // For shared session, check if drink time fits within session bounds
    final session = widget.sessions.first;
    final drink = dragData.drink;

    final isAfterStart = drink.consumedAt.isAfter(session.startedAt);
    final sessionEnd = session.endedAt;
    final isBeforeEnd =
        sessionEnd == null || drink.consumedAt.isBefore(sessionEnd);

    return isAfterStart && isBeforeEnd;
  }

  Color get _backgroundColor {
    if (widget.isSharedSession) {
      return _isDragOver ? _sessionDragOverColor : _sessionBackgroundColor;
    } else {
      return _isDragOver
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Colors.transparent;
    }
  }

  Widget _buildSharedSessionContent() {
    return AsyncBuilder(
      stream: _drinkService.drinksWithIdToShowFromSessions(widget.sessions),
      builder: (context, drinks) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (drinks.isEmpty) const Gap(32) else ..._buildDrinkItems(drinks),
            SessionDivider(session: widget.sessions.first),
          ],
        );
      },
    );
  }

  Widget _buildSoloSessionsContent() {
    return AsyncBuilder(
      stream: _drinkService.drinksWithIdToShowFromSessions(widget.sessions),
      builder: (context, drinks) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildDrinkItems(drinks),
            // The floating add drink button overlaps last drink without this space.
            const Gap(_noSessionMinHeight),
          ],
        );
      },
    );
  }

  List<Widget> _buildDrinkItems(List<DrinkWithSessionId> drinks) {
    if (drinks.isEmpty) {
      return const [];
    }

    final items = <Widget>[];

    for (var i = 0; i < drinks.length; i++) {
      final dragData = drinks[i];
      items.add(DrinkCard(drinkWithSessionId: dragData));

      if (i < drinks.length - 1) {
        final nextDrink = drinks[i + 1].drink;
        if (_crossesMidnight(dragData.drink.consumedAt, nextDrink.consumedAt)) {
          items.add(
            MidnightDivider(
              fromDate: nextDrink.consumedAt,
              toDate: dragData.drink.consumedAt,
            ),
          );
        }
      }
    }

    return items;
  }

  bool _crossesMidnight(DateTime later, DateTime earlier) {
    return !DateUtils.isSameDay(later, earlier);
  }
}
