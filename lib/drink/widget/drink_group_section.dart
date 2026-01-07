import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_service.dart';
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
/// When [session] is provided, displays drinks within that session with a
/// background and a [SessionDivider] at the bottom.
///
/// When [session] is null, displays drinks without a session with a
/// transparent background and a minimum height for easy drag-and-drop.
class DrinkGroupSection extends StatefulWidget {
  final Session? session;
  final List<Drink> drinks;
  final double? minHeight;

  const DrinkGroupSection({
    super.key,
    required this.session,
    required this.drinks,
    this.minHeight,
  });

  @override
  State<DrinkGroupSection> createState() => _DrinkGroupSectionState();
}

class _DrinkGroupSectionState extends State<DrinkGroupSection> {
  final _drinkService = get<DrinkService>();
  var _isDragOver = false;

  bool get _isSessionMode => widget.session != null;

  @override
  Widget build(BuildContext context) {
    final isDragging = DragStateProvider.maybeOf(context)?.isDragging ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DragTarget<Drink>(
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
          await _drinkService.updateDrinkSession(
            details.data,
            widget.session?.id,
          );
        },
        builder: (context, candidateData, rejectedData) {
          final content = _isSessionMode
              ? _buildSessionContent()
              : _buildNoSessionContent();

          final decoration = _isSessionMode
              ? BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(color: _sessionBorderColor),
                )
              : BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(_borderRadius),
                );

          if (_isSessionMode) {
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

  bool _shouldAcceptDrink(Drink drink) {
    if (_isSessionMode) {
      return drink.sessionId != widget.session!.id;
    } else {
      return drink.sessionId != null;
    }
  }

  Color get _backgroundColor {
    if (_isSessionMode) {
      return _isDragOver ? _sessionDragOverColor : _sessionBackgroundColor;
    } else {
      return _isDragOver
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Colors.transparent;
    }
  }

  Widget _buildSessionContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.drinks.isEmpty) gap32 else ..._buildDrinkItems(),
        SessionDivider(session: widget.session!),
      ],
    );
  }

  Widget _buildNoSessionContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._buildDrinkItems(),
        // The floating add drink button overlaps last drink without this space.
        const SizedBox(height: _noSessionMinHeight),
      ],
    );
  }

  List<Widget> _buildDrinkItems() {
    if (widget.drinks.isEmpty) {
      return const [];
    }

    final items = <Widget>[];

    for (var i = 0; i < widget.drinks.length; i++) {
      final drink = widget.drinks[i];
      items.add(DrinkCard(drink: drink));

      if (i < widget.drinks.length - 1) {
        final nextDrink = widget.drinks[i + 1];
        if (_crossesMidnight(drink.consumedAt, nextDrink.consumedAt)) {
          items.add(
            MidnightDivider(
              fromDate: nextDrink.consumedAt,
              toDate: drink.consumedAt,
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
