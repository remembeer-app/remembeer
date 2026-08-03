import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';

class SessionPhotoViewer extends StatelessWidget {
  final String sessionId;
  final int initialIndex;

  SessionPhotoViewer({
    super.key,
    required this.sessionId,
    required this.initialIndex,
  });

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AsyncBuilder<Session>(
        stream: _sessionService.sessionStream(sessionId),
        builder: (context, session) => _PhotoPages(
          pictureUrls: session.pictureUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _PhotoPages extends StatefulWidget {
  final List<String> pictureUrls;
  final int initialIndex;

  const _PhotoPages({required this.pictureUrls, required this.initialIndex});

  @override
  State<_PhotoPages> createState() => _PhotoPagesState();
}

class _PhotoPagesState extends State<_PhotoPages> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    final initialPage = switch (widget.initialIndex) {
      < 0 => 0,
      final index when index >= widget.pictureUrls.length =>
        widget.pictureUrls.isEmpty ? 0 : widget.pictureUrls.length - 1,
      final index => index,
    };
    _controller = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.pictureUrls.length,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              maxScale: 4,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.pictureUrls[index],
                  fit: BoxFit.contain,
                  placeholder: (context, _) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, _, _) => const Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 48,
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
      ],
    );
  }
}
