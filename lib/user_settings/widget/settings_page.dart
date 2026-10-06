import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/user_settings/widget/hint_box.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  final String? hint;
  final bool autmaticallyImplyLeading;
  final EdgeInsetsGeometry padding;
  final List<Widget>? actions;
  final Widget child;

  const SettingsPage({
    super.key,
    required this.title,
    this.hint,
    this.autmaticallyImplyLeading = false,
    this.padding = const EdgeInsets.all(8),
    this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(title),
      automaticallyImplyLeading: autmaticallyImplyLeading,
      padding: padding,
      actions: actions,
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
