import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/common/widget/error_message_box.dart';

class LoadingForm extends StatefulWidget {
  final Widget Function(LoadingFormState state) builder;
  final String Function(Exception error)? errorMapper;

  const LoadingForm({super.key, required this.builder, this.errorMapper});

  @override
  State<LoadingForm> createState() => LoadingFormState();
}

class LoadingFormState extends State<LoadingForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;

  bool validate() => _formKey.currentState!.validate();

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: widget.builder(this));
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    String? helperText,
    int? maxLength,
    TextInputType? keyboardType,
    bool isLastField = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: isLastField
          ? TextInputAction.done
          : TextInputAction.next,
      enabled: !_isLoading,
      maxLength: maxLength,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        helperText: helperText,
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    bool isLastField = false,
    ValueChanged<String>? onChanged,
    VoidCallback? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: isLastField
          ? TextInputAction.done
          : TextInputAction.next,
      enabled: !_isLoading,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted != null
          ? (_) => onFieldSubmitted()
          : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator,
    );
  }

  Widget buildSubmitButton({
    required String text,
    required Future<void> Function() onSubmit,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _isLoading ? null : () => _submit(onSubmit),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(text, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ErrorMessageBox(message: _errorMessage!),
    );
  }

  Future<void> runAction(Future<void> Function() action) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await action();
    } on Exception catch (e) {
      final mapper = widget.errorMapper;
      setState(() => _errorMessage = mapper?.call(e) ?? e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submit(Future<void> Function() action) async {
    if (!_formKey.currentState!.validate()) return;
    await runAction(action);
  }
}
