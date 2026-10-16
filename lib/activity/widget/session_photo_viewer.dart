import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SessionPhotoViewer extends StatelessWidget {
  final String sessionId;
  final int initialIndex;

  const SessionPhotoViewer({
    super.key,
    required this.sessionId,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) => const PageTemplate(
    title: Text('Photos'),
    // TODO(ohtenkay): Load session photos from Convex when implemented.
    child: Center(child: Text('No photos yet.')),
  );
}
