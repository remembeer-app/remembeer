import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';

const _appFormButtonHeight = 56.0;
const _appFormButtonGap = 12.0;
const _appFormSubmitLabelFontSize = 16.0;

class AppFormAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;

  const AppFormAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });
}

class AppForm extends StatefulWidget {
  final bool isSubmitting;
  final Object? error;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;
  final String submitLabel;
  final String submittingLabel;

  /// Optional visible text in place of the arrow when the button submits.
  final String? submitButtonLabel;
  final List<AppFormAction> actions;

  /// Builds the fields with a callback that validates before submitting.
  final Widget Function(BuildContext context, VoidCallback submit) builder;

  const AppForm({
    super.key,
    required this.isSubmitting,
    this.error,
    required this.onSubmit,
    this.onBack,
    required this.submitLabel,
    this.submittingLabel = 'Submitting...',
    this.submitButtonLabel,
    this.actions = const [],
    required this.builder,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  final _fieldsKey = GlobalKey();
  final _backButtonFocusNode = FocusNode(canRequestFocus: false);
  final _moreButtonFocusNode = FocusNode(canRequestFocus: false);
  final _submitButtonFocusNode = FocusNode(canRequestFocus: false);
  List<FocusNode> _fieldFocusNodes = const [];
  FocusNode? _focusedField;

  int get _focusedFieldIndex =>
      _fieldFocusNodes.indexWhere((node) => node == _focusedField);

  bool get _canAdvance =>
      _focusedFieldIndex >= 0 &&
      _focusedFieldIndex < _fieldFocusNodes.length - 1;

  bool get _canGoBack => _focusedFieldIndex > 0;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_refreshFields);
  }

  void _refreshFields() {
    if (!mounted) return;
    final nodes = _findFieldFocusNodes(_fieldsKey.currentContext);
    final focused = nodes.where((node) => node.hasFocus).firstOrNull;
    if (!listEquals(nodes, _fieldFocusNodes) || focused != _focusedField) {
      setState(() {
        _fieldFocusNodes = nodes;
        _focusedField = focused;
      });
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_refreshFields);
    _backButtonFocusNode.dispose();
    _submitButtonFocusNode.dispose();
    _moreButtonFocusNode.dispose();
    super.dispose();
  }

  void _focusField(int index) {
    final node = _fieldFocusNodes[index]..requestFocus();
    final fieldContext = node.context;
    if (fieldContext != null) {
      Scrollable.ensureVisible(
        fieldContext,
        duration: kThemeAnimationDuration,
        alignmentPolicy: index > _focusedFieldIndex
            ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
            : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    }
  }

  Future<void> _showActions() async {
    if (widget.isSubmitting) return;
    final action = await showModalBottomSheet<AppFormAction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      requestFocus: false,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final action in widget.actions)
                  ListTile(
                    leading: Icon(action.icon),
                    title: Text(action.label),
                    iconColor: action.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : null,
                    textColor: action.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : null,
                    onTap: () => Navigator.of(context).pop(action),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted || widget.isSubmitting || action == null) return;
    action.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFields());
    return Form(
      child: Builder(
        builder: (context) {
          void submit() {
            if (widget.isSubmitting || !Form.of(context).validate()) return;
            widget.onSubmit();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KeyedSubtree(
                        key: _fieldsKey,
                        child: widget.builder(context, submit),
                      ),
                      if (widget.error case final error?) ...[
                        const Gap(16),
                        ErrorMessageBox(message: error.toString()),
                      ],
                    ],
                  ),
                ),
              ),
              const Gap(16),
              _FormActionBar(
                canGoBack: _canGoBack,
                canAdvance: _canAdvance,
                isSubmitting: widget.isSubmitting,
                actions: widget.actions,
                submitLabel: widget.submitLabel,
                submittingLabel: widget.submittingLabel,
                submitButtonLabel: widget.submitButtonLabel,
                focusNodes: (
                  back: _backButtonFocusNode,
                  more: _moreButtonFocusNode,
                  submit: _submitButtonFocusNode,
                ),
                onBack: _canGoBack
                    ? () => _focusField(_focusedFieldIndex - 1)
                    : widget.onBack,
                onForward: _canAdvance
                    ? () => _focusField(_focusedFieldIndex + 1)
                    : submit,
                onMore: () => unawaited(_showActions()),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FormActionBar extends StatelessWidget {
  final bool canGoBack;
  final bool canAdvance;
  final bool isSubmitting;
  final List<AppFormAction> actions;
  final String submitLabel;
  final String submittingLabel;
  final String? submitButtonLabel;
  final ({FocusNode back, FocusNode more, FocusNode submit}) focusNodes;
  final VoidCallback? onBack;
  final VoidCallback onForward;
  final VoidCallback onMore;

  const _FormActionBar({
    required this.canGoBack,
    required this.canAdvance,
    required this.isSubmitting,
    required this.actions,
    required this.submitLabel,
    required this.submittingLabel,
    required this.submitButtonLabel,
    required this.focusNodes,
    required this.onBack,
    required this.onForward,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final directAction = actions.length == 1 && actions.single.isDestructive
        ? actions.single
        : null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasActions = actions.isNotEmpty;
        final hasBack = onBack != null;
        final secondaryButtonCount = (hasBack ? 1 : 0) + (hasActions ? 1 : 0);
        final gapCount = secondaryButtonCount;
        final buttonSpace = constraints.maxWidth - _appFormButtonGap * gapCount;
        final normalWidth = buttonSpace / (secondaryButtonCount + 2);
        final submitWidth = secondaryButtonCount == 0
            ? constraints.maxWidth
            : canAdvance
            ? normalWidth
            : normalWidth * 2;
        final gap = gapCount == 0
            ? 0.0
            : (constraints.maxWidth -
                      normalWidth * secondaryButtonCount -
                      submitWidth) /
                  gapCount;
        return SizedBox(
          height: _appFormButtonHeight,
          child: Stack(
            children: [
              if (hasActions)
                _FormActionButton(
                  left: hasBack ? normalWidth + gap : 0,
                  width: normalWidth,
                  focusNode: focusNodes.more,
                  enabled: !isSubmitting,
                  onPressed: directAction?.onPressed ?? onMore,
                  tooltip: directAction?.label ?? 'More actions',
                  isDestructive: directAction != null,
                  child: Icon(directAction?.icon ?? Icons.more_horiz),
                ),
              if (hasBack)
                _FormActionButton(
                  left: 0,
                  width: normalWidth,
                  focusNode: focusNodes.back,
                  enabled: !isSubmitting,
                  onPressed: onBack!,
                  tooltip: canGoBack ? 'Previous field' : 'Back',
                  child: AnimatedRotation(
                    turns: canGoBack ? 0.25 : 0,
                    duration: kThemeAnimationDuration,
                    curve: Curves.easeInOutCubic,
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              _FormActionButton(
                left: constraints.maxWidth - submitWidth,
                width: submitWidth,
                focusNode: focusNodes.submit,
                enabled: !isSubmitting,
                onPressed: onForward,
                tooltip: isSubmitting
                    ? submittingLabel
                    : canAdvance
                    ? 'Next field'
                    : submitLabel,
                isPrimary: true,
                child: isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : AnimatedSwitcher(
                        duration: kThemeAnimationDuration,
                        child: !canAdvance && submitButtonLabel != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Builder(
                                  builder: (context) => Text(
                                    submitButtonLabel!,
                                    style: TextStyle(
                                      color: IconTheme.of(context).color,
                                      fontSize: _appFormSubmitLabelFontSize,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            : AnimatedRotation(
                                turns: canAdvance ? 0.25 : 0,
                                duration: kThemeAnimationDuration,
                                curve: Curves.easeInOutCubic,
                                child: const Icon(Icons.arrow_forward),
                              ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FormActionButton extends StatelessWidget {
  final double left;
  final double width;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onPressed;
  final String tooltip;
  final bool isPrimary;
  final bool isDestructive;
  final Widget child;

  const _FormActionButton({
    required this.left,
    required this.width,
    required this.focusNode,
    required this.enabled,
    required this.onPressed,
    required this.tooltip,
    this.isPrimary = false,
    this.isDestructive = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Theme.of(context).colorScheme.error : null;
    final buildButton = isPrimary ? IconButton.filled : IconButton.outlined;
    return AnimatedPositioned(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOutCubic,
      left: left,
      top: 0,
      height: _appFormButtonHeight,
      width: width,
      child: buildButton(
        focusNode: focusNode,
        onPressed: enabled ? onPressed : null,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          shape: const StadiumBorder(),
          foregroundColor: color,
          side: color == null ? null : BorderSide(color: color),
        ),
        icon: child,
      ),
    );
  }
}

List<FocusNode> _findFieldFocusNodes(BuildContext? fieldContext) {
  final nodes = <FocusNode>[];
  bool isTraversable(FocusNode node) =>
      node.canRequestFocus && !node.skipTraversal;

  void visitField(Element field) {
    var hasEditableText = false;
    final editableNodes = <FocusNode>[];
    final otherNodes = <FocusNode>[];
    void visit(Element element) {
      final descendant = element.widget;
      if (descendant is AppForm) return;
      if (descendant is EditableText) {
        hasEditableText = true;
        if (!descendant.readOnly && isTraversable(descendant.focusNode)) {
          editableNodes.add(descendant.focusNode);
        }
      } else if (descendant is Focus) {
        final node = descendant.focusNode;
        if (node != null && isTraversable(node)) otherNodes.add(node);
      }
      element.visitChildren(visit);
    }

    field.visitChildren(visit);
    final fieldNodes = hasEditableText ? editableNodes : otherNodes.take(1);
    for (final node in fieldNodes) {
      if (!nodes.contains(node)) nodes.add(node);
    }
  }

  void visit(Element element) {
    final descendant = element.widget;
    // Nested forms manage their own fields.
    if (descendant is AppForm) return;
    if (descendant is FormField<Object?>) {
      visitField(element);
      return;
    }
    if (descendant is EditableText &&
        !descendant.readOnly &&
        isTraversable(descendant.focusNode)) {
      nodes.add(descendant.focusNode);
    }
    element.visitChildren(visit);
  }

  fieldContext?.visitChildElements(visit);
  return nodes;
}
