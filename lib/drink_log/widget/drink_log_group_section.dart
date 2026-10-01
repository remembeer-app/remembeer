import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drag_state_provider.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/type/drink_log_with_session_id.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/drink_log/widget/midnight_divider.dart';
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
/// session with a background and a [SessionDivider] at the top. The
/// [sessions] list must contain exactly one session.
///
/// When [isSharedSession] is false, displays solo drinks (each in its own
/// session container) with a transparent background and a minimum height
/// for easy drag-and-drop.
class DrinkLogGroupSection extends StatefulWidget {
  final bool isSharedSession;
  final List<Session> sessions;
  final double? minHeight;

  DrinkLogGroupSection({
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
  State<DrinkLogGroupSection> createState() => _DrinkLogGroupSectionState();
}

class _DrinkLogGroupSectionState extends State<DrinkLogGroupSection> {
  final _drinkLogService = get<DrinkLogService>();
  var _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final isDragging = DragStateProvider.maybeOf(context)?.isDragging ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DragTarget<DrinkLogWithSessionId>(
        onWillAcceptWithDetails: (details) {
          final willAccept = _shouldAcceptDrinkLog(details.data);
          if (willAccept && !_isDragOver) {
            setState(() => _isDragOver = true);
          }
          return willAccept;
        },
        onLeave: (_) => setState(() => _isDragOver = false),
        onAcceptWithDetails: (details) async {
          setState(() => _isDragOver = false);

          await _drinkLogService.moveDrinkLogBetweenSessions(
            drinkLog: details.data.drinkLog,
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

  bool _shouldAcceptDrinkLog(DrinkLogWithSessionId dragData) {
    if (dragData.isParty ||
        (widget.isSharedSession && widget.sessions.first.isParty)) {
      return false;
    }

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
    // and that the session is not full
    final session = widget.sessions.first;

    if (!session.hasFreeSpace) {
      return false;
    }

    final drinkLog = dragData.drinkLog;

    final isAfterStart = drinkLog.consumedAt.isAfter(session.startedAt);
    final sessionEnd = session.endedAt;
    final isBeforeEnd =
        sessionEnd == null || drinkLog.consumedAt.isBefore(sessionEnd);

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
      stream: _drinkLogService.drinkLogsWithSessionIdToShowFromSessions(
        widget.sessions,
      ),
      builder: (context, drinkLogs) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SessionDivider(session: widget.sessions.first),
            if (drinkLogs.isEmpty)
              const Gap(32)
            else
              ..._buildDrinkLogItems(drinkLogs),
          ],
        );
      },
    );
  }

  Widget _buildSoloSessionsContent() {
    return AsyncBuilder(
      stream: _drinkLogService.drinkLogsWithSessionIdToShowFromSessions(
        widget.sessions,
      ),
      builder: (context, drinkLogs) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildDrinkLogItems(drinkLogs),
            // The floating add drink button overlaps last drink without this space.
            const Gap(_noSessionMinHeight),
          ],
        );
      },
    );
  }

  List<Widget> _buildDrinkLogItems(List<DrinkLogWithSessionId> drinkLogs) {
    if (drinkLogs.isEmpty) {
      return const [];
    }

    final items = <Widget>[];

    for (var i = 0; i < drinkLogs.length; i++) {
      final dragData = drinkLogs[i];
      items.add(DrinkLogCard(drinkLogWithSessionId: dragData));

      if (i < drinkLogs.length - 1) {
        final nextDrinkLog = drinkLogs[i + 1].drinkLog;
        if (_crossesMidnight(
          dragData.drinkLog.consumedAt,
          nextDrinkLog.consumedAt,
        )) {
          items.add(
            MidnightDivider(
              fromDate: nextDrinkLog.consumedAt,
              toDate: dragData.drinkLog.consumedAt,
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
