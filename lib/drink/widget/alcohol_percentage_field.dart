import 'package:flutter/material.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/formatter/alcohol_percentage_formatter.dart';

class AlcoholPercentageField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AlcoholPercentageField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  State<AlcoholPercentageField> createState() => _AlcoholPercentageFieldState();
}

class _AlcoholPercentageFieldState extends State<AlcoholPercentageField> {
  final _focusNode = FocusNode();
  final _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_syncDisplay);
    _focusNode.addListener(_syncDisplay);
    _syncDisplay();
  }

  @override
  void didUpdateWidget(AlcoholPercentageField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncDisplay);
      widget.controller.addListener(_syncDisplay);
      _syncDisplay();
    }
  }

  void _syncDisplay() {
    final source = widget.controller.text;
    final hideZero =
        !_focusNode.hasFocus && RegExp(r'^0\d(?:\.\d{0,2})?$').hasMatch(source);
    final text = hideZero ? source.substring(1) : source;
    if (_displayController.text == text) return;
    final selection = _displayController.selection;
    final delta = text.length - _displayController.text.length;
    int offset(int value) =>
        value < 0 ? text.length : (value + delta).clamp(0, text.length);
    _displayController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: offset(selection.baseOffset),
        extentOffset: offset(selection.extentOffset),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncDisplay);
    _focusNode
      ..removeListener(_syncDisplay)
      ..dispose();
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: _displayController,
    focusNode: _focusNode,
    enabled: widget.enabled,
    keyboardType: TextInputType.number,
    textInputAction: widget.textInputAction,
    onChanged: (_) => widget.controller.value = _displayController.value,
    onFieldSubmitted: (_) =>
        widget.onFieldSubmitted?.call(widget.controller.text),
    inputFormatters: const [AlcoholPercentageFormatter()],
    validator: (_) => _validatePercentage(widget.controller.text),
    decoration: const InputDecoration(
      labelText: 'Alcohol Percentage',
      hintText: '00.00',
      suffixText: '%',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );

  static String? _validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an alcohol percentage.';
    }
    final percentage = double.tryParse(value);
    if (percentage == null ||
        !percentage.isFinite ||
        percentage < minAlcoholPercentage ||
        percentage > maxAlcoholPercentage) {
      return 'Enter a percentage between $minAlcoholPercentage and $maxAlcoholPercentage.';
    }
    if (!RegExp(r'^\d{2}(?:\.\d{0,2})?$').hasMatch(value)) {
      return 'Enter two whole-number digits, using a leading zero below 10%.';
    }
    return null;
  }
}
