import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/widget/session_photo_viewer.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_picture_service.dart';
import 'package:remembeer/session/service/session_service.dart';

class SessionPhotosSection extends StatefulWidget {
  final String sessionId;

  const SessionPhotosSection({super.key, required this.sessionId});

  @override
  State<SessionPhotosSection> createState() => _SessionPhotosSectionState();
}

class _SessionPhotosSectionState extends State<SessionPhotosSection> {
  final _sessionService = get<SessionService>();
  final _pictureService = get<SessionPictureService>();

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<Session>(
      stream: _sessionService.sessionStream(widget.sessionId),
      builder: (context, session) {
        final isAdmin = session.isAdmin(_sessionService.currentUserId);

        if (session.pictureUrls.isEmpty && !isAdmin) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme, session),
            const Gap(8),
            if (session.pictureUrls.isNotEmpty)
              _buildGrid(context, theme, session, isAdmin),
            if (isAdmin) ...[const Gap(12), _buildAddButtons(session)],
            const Gap(16),
          ],
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme, Session session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'Photos (${session.pictureUrls.length})',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    ThemeData theme,
    Session session,
    bool isAdmin,
  ) {
    final urls = session.pictureUrls;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) =>
          _buildTile(context, theme, session, isAdmin, urls, index),
    );
  }

  Widget _buildTile(
    BuildContext context,
    ThemeData theme,
    Session session,
    bool isAdmin,
    List<String> urls,
    int index,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) =>
                    SessionPhotoViewer(pictureUrls: urls, initialIndex: index),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: urls[index],
              fit: BoxFit.cover,
              placeholder: (context, _) =>
                  ColoredBox(color: theme.colorScheme.surfaceContainerHighest),
              errorWidget: (context, _, _) => ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (isAdmin)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _isLoading
                      ? null
                      : () => _confirmRemove(context, session, urls[index]),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButtons(Session session) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _addFromGallery(session),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.photo_library_rounded),
                label: const Text('Gallery'),
              ),
            ),
            const Gap(12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _addFromCamera(session),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Camera'),
              ),
            ),
          ],
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Future<void> _addFromGallery(Session session) => _run(
    () => _pictureService.addPicturesFromGallery(session),
    'Failed to add photos',
  );

  Future<void> _addFromCamera(Session session) => _run(
    () => _pictureService.addPictureFromCamera(session),
    'Failed to add photo',
  );

  void _confirmRemove(BuildContext context, Session session, String url) {
    showConfirmationDialog(
      context: context,
      title: 'Remove Photo',
      text: 'Are you sure you want to remove this photo?',
      submitButtonText: 'Remove',
      isDestructive: true,
      onPressed: () => _run(
        () => _pictureService.deleteSessionPicture(session, url),
        'Failed to remove photo',
      ),
    );
  }

  Future<void> _run(Future<void> Function() action, String errorMessage) async {
    setState(() => _isLoading = true);

    try {
      await action();
    } on Exception catch (_) {
      showErrorNotification(errorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
