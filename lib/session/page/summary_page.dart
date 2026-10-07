import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) => const PageTemplate(
    title: Text('Summary'),
    child: Center(child: Text('Session summaries are awaiting migration.')),
  );
}
