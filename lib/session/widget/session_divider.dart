import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/constants.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';

class SessionDivider extends StatefulWidget {
  final Session session;

  const SessionDivider({super.key, required this.session});

  @override
  State<SessionDivider> createState() => _SessionDividerState();
}

class _SessionDividerState extends State<SessionDivider> {
  final _sessionService = get<SessionService>();
  var _isExpanded = false;

  Session get _session => widget.session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [
                  _buildTitleRow(theme),
                  const Gap(6),
                  _buildSummaryRow(theme),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? _buildExpandedContent(context, theme)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.table_bar, size: 20, color: theme.colorScheme.primary),
        const Gap(8),
        Expanded(
          child: Text(
            _session.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Gap(8),
        AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(ThemeData theme) {
    final detailColor = theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(Icons.local_drink_outlined, size: 14, color: detailColor),
        const Gap(4),
        Text(
          '${_session.drinksCount} / $maxSessionDrinks',
          style: theme.textTheme.bodySmall?.copyWith(
            color: _session.hasFreeSpace
                ? detailColor
                : theme.colorScheme.error,
          ),
        ),
        const Spacer(),
        Icon(Icons.schedule, size: 14, color: detailColor),
        const Gap(4),
        Flexible(
          child: Text(
            _compactTimeRange,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: detailColor),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context, ThemeData theme) {
    final description = _session.description.trim();
    final memberCount = _session.memberIds.length;
    final isOwner = _sessionService.isSessionOwner(_session);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          if (description.isNotEmpty) ...[
            const Gap(12),
            Text(description, style: theme.textTheme.bodyMedium),
          ],
          const Gap(12),
          _buildDetailRow(
            theme,
            Icons.group_outlined,
            '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
          ),
          const Gap(8),
          _buildDetailRow(
            theme,
            Icons.play_circle_outline,
            'Started ${formatFullDateTime(_session.startedAt)}',
          ),
          const Gap(8),
          _buildDetailRow(
            theme,
            Icons.stop_circle_outlined,
            _session.endedAt == null
                ? 'Still going'
                : 'Ended ${formatFullDateTime(_session.endedAt!)}',
          ),
          const Gap(12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => AddSessionFriendsRoute(
                  sessionId: _session.id,
                ).push<void>(context),
                icon: const Icon(Icons.group_add_outlined),
                label: const Text('Add friends'),
              ),
              if (isOwner)
                OutlinedButton.icon(
                  onPressed: () => EditSessionRoute(
                    sessionId: _session.id,
                  ).push<void>(context),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit session'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, IconData icon, String text) {
    final detailColor = theme.colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: detailColor),
        const Gap(8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: detailColor),
          ),
        ),
      ],
    );
  }

  String get _compactTimeRange {
    final start = formatTime(_session.startedAt);
    final endedAt = _session.endedAt;

    return endedAt == null
        ? '$start - ongoing'
        : '$start - ${formatTime(endedAt)}';
  }
}
