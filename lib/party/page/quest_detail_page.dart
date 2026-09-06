import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class QuestDetailPage extends StatelessWidget {
  const QuestDetailPage({super.key, required this.questId});

  final String questId;

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      title: Text('Quest'),
      child: Center(child: Text('Quest details will appear here.')),
    );
  }
}
