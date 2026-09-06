import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class BeerpongPage extends StatelessWidget {
  const BeerpongPage({super.key, required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      title: Text('Tournament'),
      child: Center(child: Text('Tournament details will appear here.')),
    );
  }
}
