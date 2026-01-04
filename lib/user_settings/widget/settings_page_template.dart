import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/page_template.dart';

const _fabBottomOffset = 40.0;

class SettingsPageTemplate extends StatelessWidget {
  final Widget title;
  final Widget child;
  final String? hint;
  final VoidCallback? onFabPressed;
  final IconData fabIcon;
  final EdgeInsetsGeometry padding;

  const SettingsPageTemplate({
    super.key,
    required this.title,
    required this.child,
    this.hint,
    this.onFabPressed,
    this.fabIcon = Icons.save,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return PageTemplate(
      title: title,
      padding: padding,
      floatingActionButton: onFabPressed != null
          ? Padding(
              padding: EdgeInsets.only(
                bottom: keyboardOpen ? 0 : _fabBottomOffset,
              ),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: onFabPressed,
                child: Icon(fabIcon),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hint != null) _buildHintBox(context),
          gap8,
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildHintBox(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          hGap12,
          Expanded(
            child: Text(
              hint!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
