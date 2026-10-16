import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) => const PageTemplate(
    title: Text('Summary'),
    // TODO(ohtenkay): Load session summary data from Convex when implemented.
    child: Center(child: Text('No summary yet.')),
  );
}
