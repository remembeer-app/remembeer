import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';

class DrinkForm extends StatefulWidget {
  final String initialName;
  final double initialAlcoholPercentage;
  final DrinkCategory initialDrinkCategory;
  final bool isLoading;
  final Object? error;
  final void Function(String, double, DrinkCategory) onSubmit;
  final VoidCallback? onDelete;

  const DrinkForm({
    super.key,
    required this.initialName,
    required this.initialAlcoholPercentage,
    required this.initialDrinkCategory,
    required this.isLoading,
    required this.error,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<DrinkForm> createState() => _DrinkFormState();
}

class _DrinkFormState extends State<DrinkForm> {
  final _formKey = GlobalKey<FormState>();
  late DrinkCategory? _selectedCategory = widget.initialDrinkCategory;
  final _nameController = TextEditingController();
  final _percentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _percentageController.text = widget.initialAlcoholPercentage.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  enabled: !widget.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a name.'
                      : null,
                ),
                const Gap(16),
                TextFormField(
                  controller: _percentageController,
                  enabled: !widget.isLoading,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Alcohol Percentage (%)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an alcohol percentage.';
                    }
                    final percentage = double.tryParse(value);
                    return percentage == null ||
                            percentage < 1 ||
                            percentage > 100
                        ? 'Please enter a valid number.'
                        : null;
                  },
                ),
                const Gap(16),
                DropdownButtonFormField<DrinkCategory>(
                  initialValue: _selectedCategory,
                  hint: const Text('Select Category'),
                  items: convexDrinkCategories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: widget.isLoading
                      ? null
                      : (value) => setState(() => _selectedCategory = value),
                  validator: (value) =>
                      value == null ? 'Please select a category.' : null,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          if (widget.error case final error?) ...[
            ErrorMessageBox(message: error.toString()),
            const Gap(16),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Submit'),
            ),
          ),
          if (widget.onDelete != null) ...[
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.isLoading ? null : _confirmDelete,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Delete'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final percentage = double.parse(_percentageController.text);
    widget.onSubmit(
      _nameController.text,
      (percentage * 100).round() / 100,
      _selectedCategory!,
    );
  }

  void _confirmDelete() {
    showConfirmationDialog(
      context: context,
      title: 'Delete Drink',
      text: 'Are you sure you want to delete "${_nameController.text}"?',
      submitButtonText: 'Delete',
      isDestructive: true,
      onPressed: () async => widget.onDelete!(),
    );
  }
}
