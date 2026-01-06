import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

class DrinkTypeForm extends StatefulWidget {
  final String initialName;
  final double initialAlcoholPercentage;
  final DrinkCategory initialDrinkCategory;
  final Future<void> Function(
    String name,
    double alcoholPercentage,
    DrinkCategory category,
  )
  onSubmit;
  final Future<void> Function()? onDelete;

  const DrinkTypeForm({
    super.key,
    required this.initialName,
    required this.initialAlcoholPercentage,
    required this.initialDrinkCategory,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<DrinkTypeForm> createState() => _DrinkTypeFormState();
}

class _DrinkTypeFormState extends State<DrinkTypeForm> {
  late DrinkCategory? _selectedDrinkCategory = widget.initialDrinkCategory;
  final _nameController = TextEditingController();
  final _alcoholPercentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _alcoholPercentageController.text = widget.initialAlcoholPercentage
        .toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _alcoholPercentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingForm(
      builder: (form) => Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildNameInput(form),
                gap16,
                _buildAlcoholPercentageInput(form),
                gap16,
                _buildDrinkCategoryDropdown(form),
              ],
            ),
          ),
          _buildActionButtons(form),
        ],
      ),
    );
  }

  Widget _buildNameInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _nameController,
      label: 'Name',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name.';
        }
        return null;
      },
    );
  }

  Widget _buildAlcoholPercentageInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _alcoholPercentageController,
      label: 'Alcohol Percentage (%)',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an alcohol percentage.';
        }
        final percentage = double.tryParse(value);
        if (percentage == null || percentage < 0 || percentage > 100) {
          return 'Please enter a valid number.';
        }
        if (percentage == 0) {
          return "You don't need our app for that";
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(LoadingFormState form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        form.buildSubmitButton(
          text: 'Submit',
          margin: const EdgeInsets.only(bottom: 16),
          onSubmit: _submitForm,
        ),
        if (widget.onDelete != null) ...[
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(vertical: 16),
            child: FilledButton(
              onPressed: form.isLoading
                  ? null
                  : () => form.runAction(widget.onDelete!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Delete', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDrinkCategoryDropdown(LoadingFormState form) {
    return DropdownButtonFormField<DrinkCategory>(
      initialValue: _selectedDrinkCategory,
      hint: const Text('Select Category'),
      items: DrinkCategory.values.map((drinkCategory) {
        return DropdownMenuItem(
          value: drinkCategory,
          child: Text(drinkCategory.displayName),
        );
      }).toList(),
      onChanged: form.isLoading
          ? null
          : (newValue) {
              setState(() {
                _selectedDrinkCategory = newValue;
              });
            },
      validator: (value) {
        if (value == null) {
          return 'Please select a category.';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _submitForm() async {
    final name = _nameController.text;
    final alcoholPercentage = double.parse(_alcoholPercentageController.text);
    final roundedAlcoholPercentage = (alcoholPercentage * 100).round() / 100;
    await widget.onSubmit(
      name,
      roundedAlcoholPercentage,
      _selectedDrinkCategory!,
    );
  }
}
