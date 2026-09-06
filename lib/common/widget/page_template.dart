import 'package:flutter/material.dart';

const _defaultPadding = EdgeInsets.all(8.0);

class PageTemplate extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;
  final Color? appBarBackgroundColor;
  final Color? appBarForegroundColor;
  final List<Widget>? actions;

  const PageTemplate({
    super.key,
    this.title,
    required this.child,
    this.floatingActionButton,
    this.padding = _defaultPadding,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              backgroundColor:
                  appBarBackgroundColor ??
                  Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: appBarForegroundColor,
              centerTitle: true,
              title: title,
              actions: actions,
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
