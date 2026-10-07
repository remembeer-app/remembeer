import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/formatter/alcohol_percentage_formatter.dart';
import 'package:remembeer/drink/widget/alcohol_percentage_field.dart';
import 'package:remembeer/drink/widget/drink_category_field.dart';
import 'package:remembeer/drink/widget/drink_name_field.dart';

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
  late DrinkCategory? _selectedCategory = widget.initialDrinkCategory;
  final _nameController = TextEditingController();
  final _percentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _percentageController.text = AlcoholPercentageFormatter.formatPercentage(
      widget.initialAlcoholPercentage,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      isSubmitting: widget.isLoading,
      error: widget.error,
      submitLabel: widget.onDelete == null ? 'Create drink' : 'Save drink',
      submittingLabel: 'Saving...',
      onSubmit: _submit,
      onBack: () => context.pop(),
      actions: [
        if (widget.onDelete != null)
          AppFormAction(
            label: 'Delete drink',
            icon: Icons.delete_outline,
            isDestructive: true,
            onPressed: _confirmDelete,
          ),
      ],
      builder: (context, submit) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrinkNameField(
            controller: _nameController,
            enabled: !widget.isLoading,
          ),
          const Gap(16),
          AlcoholPercentageField(
            controller: _percentageController,
            enabled: !widget.isLoading,
          ),
          const Gap(16),
          DrinkCategoryField(
            initialValue: _selectedCategory,
            enabled: !widget.isLoading,
            onChanged: (category) =>
                setState(() => _selectedCategory = category),
            onFieldSubmitted: submit,
          ),
        ],
      ),
    );
  }

  void _submit() {
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
