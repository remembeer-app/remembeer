import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/constants.dart';

class PartyClassSelector extends StatefulWidget {
  const PartyClassSelector({
    super.key,
    required this.onSubmit,
    this.selectedClass,
    this.submitLabel = 'Choose class',
  });

  final DrinkCategory? selectedClass;
  final String submitLabel;
  final Future<void> Function(DrinkCategory selectedClass) onSubmit;

  @override
  State<PartyClassSelector> createState() => _PartyClassSelectorState();
}

class _PartyClassSelectorState extends State<PartyClassSelector> {
  late DrinkCategory? _selectedClass = widget.selectedClass;
  var _isLoading = false;
  String? _errorMessage;

  @override
  void didUpdateWidget(covariant PartyClassSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedClass != widget.selectedClass) {
      _selectedClass = widget.selectedClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canSubmit =
        _selectedClass != null &&
        !_isLoading &&
        (_selectedClass != widget.selectedClass ||
            widget.selectedClass == null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Choose your Party class',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(8),
        Text(
          'Matching drinks earn a 10% Party point bonus.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        const Gap(16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 120,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: partyClasses.map((metadata) {
            final category = metadata.category;
            final isSelected = category == _selectedClass;
            return Card(
              clipBehavior: Clip.hardEdge,
              color: isSelected ? colorScheme.primaryContainer : null,
              child: InkWell(
                onTap: _isLoading
                    ? null
                    : () => setState(() {
                        _selectedClass = category;
                        _errorMessage = null;
                      }),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DrinkIcon(category: category, size: 32),
                      const Gap(8),
                      Text(
                        metadata.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Gap(16),
        if (_errorMessage case final errorMessage?) ...[
          Text(errorMessage, style: TextStyle(color: colorScheme.error)),
          const Gap(8),
        ],
        FilledButton(
          onPressed: canSubmit ? _submit : null,
          child: _isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.submitLabel),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final selectedClass = _selectedClass;
    if (selectedClass == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await widget.onSubmit(selectedClass);
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
