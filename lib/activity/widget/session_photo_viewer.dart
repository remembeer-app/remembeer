import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SessionPhotoViewer extends StatefulWidget {
  final List<String> pictureUrls;
  final int initialIndex;

  const SessionPhotoViewer({
    super.key,
    required this.pictureUrls,
    required this.initialIndex,
  });

  @override
  State<SessionPhotoViewer> createState() => _SessionPhotoViewerState();
}

class _SessionPhotoViewerState extends State<SessionPhotoViewer> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
