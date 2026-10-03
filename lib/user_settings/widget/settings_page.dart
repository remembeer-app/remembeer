import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/user_settings/widget/hint_box.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  final String? hint;
  final Widget child;

  const SettingsPage({
    super.key,
    required this.title,
    this.hint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(title),
      automaticallyImplyLeading: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hint case final hint?) ...[HintBox(hint: hint), const Gap(16)],
          Expanded(child: child),
        ],
      ),
    );
  }
}
