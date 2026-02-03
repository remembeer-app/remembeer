import 'package:flutter/material.dart';

const _defaultPadding = EdgeInsets.all(8.0);

class PageTemplate extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;

  const PageTemplate({
    super.key,
    this.title,
    required this.child,
    this.floatingActionButton,
    this.padding = _defaultPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              centerTitle: true,
              title: title,
            )
          : null,
      body: SafeArea(
        top: title == null,
        child: Padding(padding: padding, child: child),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
