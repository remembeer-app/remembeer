import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/drink/widget/drink_picker.dart';
import 'package:remembeer/drink_log/widget/drink_log_consumed_at_field.dart';
import 'package:remembeer/drink_log/widget/drink_log_location_field.dart';
import 'package:remembeer/drink_log/widget/drink_log_volume_field.dart';

class DrinkLogForm extends StatefulWidget {
  final ListAvailableResultItem? initialDrink;
  final DateTime initialConsumedAt;
  final int initialVolume;
  final GeoPoint? initialLocation;
  final Future<void> Function(
    ListAvailableResultItem drink,
    DateTime consumedAt,
    int volumeInMilliliters,
    GeoPoint? location,
  )
  onSubmit;

  const DrinkLogForm({
    super.key,
    required this.initialDrink,
    required this.initialConsumedAt,
    required this.initialVolume,
    this.initialLocation,
    required this.onSubmit,
  });

  @override
  State<DrinkLogForm> createState() => _DrinkLogFormState();
}

class _DrinkLogFormState extends State<DrinkLogForm> {
  late ListAvailableResultItem? _selectedDrink = widget.initialDrink;
  late DateTime _selectedConsumedAt = widget.initialConsumedAt;
  late GeoPoint? _location = widget.initialLocation;
  late final _volumeController = TextEditingController(
    text: widget.initialVolume.toString(),
  );
  var _isSubmitting = false;
  Object? _error;

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppForm(
    isSubmitting: _isSubmitting,
    error: _error,
    submitLabel: 'Submit',
    submittingLabel: 'Saving...',
    onSubmit: () => unawaited(_submit()),
    onBack: () => context.pop(),
    builder: (context, submit) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrinkPicker(
          selectedDrink: _selectedDrink,
          enabled: !_isSubmitting,
          onChanged: (drink) => setState(() {
            if (drink.drinkCategory.kind !=
                _selectedDrink?.drinkCategory.kind) {
              _volumeController.text = drink.drinkCategory.defaultVolume
                  .toString();
            }
            _selectedDrink = drink;
          }),
        ),
        const Gap(16),
        DrinkLogVolumeField(
          controller: _volumeController,
          predefinedVolumes:
              _selectedDrink?.drinkCategory.predefinedVolumes ?? const {},
          enabled: !_isSubmitting,
        ),
        const Gap(16),
        DrinkLogConsumedAtField(
          initialValue: _selectedConsumedAt,
          enabled: !_isSubmitting,
          onChanged: (value) => _selectedConsumedAt = value,
        ),
        const Gap(16),
        DrinkLogLocationField(
          initialLocation: _location,
          enabled: !_isSubmitting,
          onChanged: (value) => _location = value,
        ),
      ],
    ),
  );

  Future<void> _submit() async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await widget.onSubmit(
        _selectedDrink!,
        _selectedConsumedAt,
        int.parse(_volumeController.text),
        _location,
      );
    } on Exception catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
