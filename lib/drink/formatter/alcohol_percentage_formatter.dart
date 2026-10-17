import 'package:flutter/services.dart';
import 'package:remembeer/drink/constants.dart';

/// Enters two whole-number digits before moving to two decimal digits.
class AlcoholPercentageFormatter extends TextInputFormatter {
  const AlcoholPercentageFormatter();

  /// Formats an existing value without clamping values outside the valid range.
  static String formatPercentage(double value) => value
      .toStringAsFixed(alcoholPercentageDecimalDigits)
      .padLeft(alcoholPercentageInputDigits + 1, '0');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    if (oldValue.text == newValue.text) return newValue;
    if (newValue.text.isEmpty) return newValue;

    var prefix = 0;
    while (prefix < oldValue.text.length &&
        prefix < newValue.text.length &&
        oldValue.text[prefix] == newValue.text[prefix]) {
      prefix++;
    }
    var suffix = 0;
    while (suffix < oldValue.text.length - prefix &&
        suffix < newValue.text.length - prefix &&
        oldValue.text[oldValue.text.length - suffix - 1] ==
            newValue.text[newValue.text.length - suffix - 1]) {
      suffix++;
    }
    final inserted = newValue.text.substring(
      prefix,
      newValue.text.length - suffix,
    );
    final hasInsertedSeparator = inserted.contains(RegExp('[.,]'));
    final replacesAll =
        oldValue.selection.start == 0 &&
        oldValue.selection.end == oldValue.text.length;
    final hasSeparator = newValue.text.contains(RegExp('[.,]'));
    final hasUnformattedSeparator =
        hasSeparator && !RegExp(r'^\d{2}\.\d{0,2}$').hasMatch(newValue.text);
    final isDecimalPaste =
        hasSeparator &&
        (replacesAll ||
            (hasInsertedSeparator && inserted.length > 1) ||
            (hasUnformattedSeparator && inserted.isNotEmpty));
    if (isDecimalPaste) {
      // A decimal paste is a conventional value, not a sequence of masked digits.
      final pasted = newValue.text.trim().replaceAll(',', '.');
      if (!RegExp(r'^\d{1,2}\.\d{0,2}$').hasMatch(pasted)) {
        return oldValue;
      }
      final percentage = double.tryParse(pasted);
      if (percentage == null ||
          percentage < minAlcoholPercentage ||
          percentage > maxAlcoholPercentage) {
        return oldValue;
      }
      final text = formatPercentage(percentage);
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    if (hasInsertedSeparator) return oldValue;
    if (!RegExp(r'^\d*(?:\.\d*)?$').hasMatch(newValue.text)) return oldValue;

    var digits = newValue.text.replaceAll('.', '');
    var base = _digitOffset(newValue.text, newValue.selection.baseOffset);
    var extent = _digitOffset(newValue.text, newValue.selection.extentOffset);
    // Deleting the generated separator deletes the adjacent digit as well,
    // so Backspace and Delete never get stuck on the decimal point.
    if (inserted.isEmpty &&
        oldValue.text.substring(prefix, oldValue.text.length - suffix) == '.' &&
        oldValue.selection.isCollapsed) {
      final deletingBackward = oldValue.selection.baseOffset > prefix;
      final index = deletingBackward ? prefix - 1 : prefix;
      if (index >= 0 && index < digits.length) {
        digits = digits.substring(0, index) + digits.substring(index + 1);
        base = index;
        extent = index;
      }
    }
    if (digits.length > alcoholPercentageInputDigits) return oldValue;
    final text = digits.length < alcoholPercentageWholeDigits
        ? digits
        : '${digits.substring(0, alcoholPercentageWholeDigits)}.'
              '${digits.substring(alcoholPercentageWholeDigits)}';
    int textOffset(int offset) => offset < 0
        ? text.length
        : (offset >= alcoholPercentageWholeDigits ? offset + 1 : offset).clamp(
            0,
            text.length,
          );
    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: textOffset(base),
        extentOffset: textOffset(extent),
      ),
    );
  }

  static int _digitOffset(String text, int offset) => offset < 0
      ? -1
      : text
            .substring(0, offset.clamp(0, text.length))
            .replaceAll('.', '')
            .length;
}
