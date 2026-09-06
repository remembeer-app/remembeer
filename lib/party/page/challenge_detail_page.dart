import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class ChallengeDetailPage extends StatelessWidget {
  const ChallengeDetailPage({super.key, required this.challengeId});

  final String challengeId;

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      title: Text('Challenge'),
      child: Center(child: Text('Challenge details will appear here.')),
    );
  }
}
