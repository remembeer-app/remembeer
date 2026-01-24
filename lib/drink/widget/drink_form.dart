import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/drink_type/widget/drink_type_picker.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/location/page/location_page.dart';
import 'package:remembeer/location/service/location_service.dart';

const _defaultPosition = GeoPoint(49.2099, 16.5990);

class DrinkForm extends StatefulWidget {
  final DrinkTypeCore initialDrinkType;
  final DateTime initialConsumedAt;
  final int initialVolume;
  final GeoPoint? initialLocation;
  final Future<void> Function(
    DrinkTypeCore drinkType,
    DateTime consumedAt,
    int volumeInMilliliters,
    GeoPoint? location,
  )
  onSubmit;

  const DrinkForm({
    super.key,
    required this.initialDrinkType,
    required this.initialConsumedAt,
    required this.initialVolume,
    this.initialLocation,
    required this.onSubmit,
  });

  @override
  State<DrinkForm> createState() => _DrinkFormState();
}

class _DrinkFormState extends State<DrinkForm> {
  final _locationService = get<LocationService>();

  late DrinkTypeCore _selectedDrinkType = widget.initialDrinkType;
  late DateTime _selectedConsumedAt = widget.initialConsumedAt;
  final _volumeController = TextEditingController();
  final _consumedAtController = TextEditingController();
  final _locationController = TextEditingController();

  GeoPoint? _location;
  var _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _consumedAtController.text = _formatDateTime(_selectedConsumedAt);
    _volumeController.text = widget.initialVolume.toString();
    _volumeController.addListener(() => setState(() {}));
    _location = widget.initialLocation;
    _updateLocationText();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _consumedAtController.dispose();
    _locationController.dispose();
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
                _buildDrinkTypeDropdown(),
                gap16,
                _buildVolumeInput(form),
                gap8,
                _buildPredefinedVolumesRow(),
                gap16,
                _buildConsumedAtInput(form),
                gap16,
                _buildLocationInput(form),
              ],
            ),
          ),
          _buildSubmitButton(form),
        ],
      ),
    );
  }

  Widget _buildLocationInput(LoadingFormState form) {
    final isDisabled = form.isLoading || _isLoadingLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _locationController,
          readOnly: true,
          enabled: !form.isLoading,
          onTap: isDisabled ? null : _openLocationPicker,
          decoration: InputDecoration(
            labelText: 'Location (optional)',
            hintText: 'Tap to set location',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on),
            suffixIcon: _location != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _location = null;
                        _updateLocationText();
                      });
                    },
                  )
                : null,
          ),
        ),
        gap8,
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isDisabled ? null : _fetchCurrentLocation,
                icon: _isLoadingLocation
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: const Text('Current location'),
              ),
            ),
            hGap8,
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isDisabled ? null : _openLocationPicker,
                icon: const Icon(Icons.map),
                label: const Text('Pick on map'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openLocationPicker() async {
    var startLocation = _location;
    if (startLocation == null) {
      setState(() => _isLoadingLocation = true);
      final position = await _locationService.getCurrentPosition();
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
      if (position != null) {
        startLocation = GeoPoint(position.latitude, position.longitude);
      } else {
        startLocation = _defaultPosition;
      }
    }

    if (!mounted) return;

    final newLocation = await Navigator.of(context).push<GeoPoint>(
      MaterialPageRoute(
        builder: (context) => LocationPage(location: startLocation!),
      ),
    );

    if (newLocation != null && mounted) {
      setState(() {
        _location = newLocation;
        _updateLocationText();
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM. yyyy, H:mm').format(dateTime);
  }

  Future<void> _selectConsumedAt() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedConsumedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedConsumedAt),
    );
    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedConsumedAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
    _consumedAtController.text = _formatDateTime(_selectedConsumedAt);
  }

  Widget _buildDrinkTypeDropdown() {
    return DrinkTypePicker(
      selectedDrinkType: _selectedDrinkType,
      onChanged: (newValue) {
        setState(() {
          if (newValue.category != _selectedDrinkType.category) {
            _volumeController.text = newValue.category.defaultVolume.toString();
          }
          _selectedDrinkType = newValue;
        });
      },
    );
  }

  Widget _buildVolumeInput(LoadingFormState form) {
    return form.buildTextField(
      controller: _volumeController,
      label: 'Volume (ml)',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a volume.';
        }
        final volume = int.tryParse(value);
        if (volume == null || volume <= 0) {
          return 'Please enter a valid number.';
        }
        return null;
      },
    );
  }

  Widget _buildVolumeButton({required String name, required int volume}) {
    final currentVolume = int.tryParse(_volumeController.text);
    final isSelected = currentVolume == volume;

    return Expanded(
      child: isSelected
          ? FilledButton(
              onPressed: () => _volumeController.text = volume.toString(),
              child: Text(name),
            )
          : OutlinedButton(
              onPressed: () => _volumeController.text = volume.toString(),
              child: Text(name),
            ),
    );
  }

  Widget _buildPredefinedVolumesRow() {
    final volumes = _selectedDrinkType.category.predefinedVolumes;
    final buttons = <Widget>[];
    volumes.forEach((name, volume) {
      buttons
        ..add(_buildVolumeButton(name: name, volume: volume))
        ..add(hGap8);
    });

    if (buttons.isNotEmpty) {
      buttons.removeLast();
    }

    return Row(children: buttons);
  }

  Widget _buildConsumedAtInput(LoadingFormState form) {
    return TextFormField(
      controller: _consumedAtController,
      readOnly: true,
      enabled: !form.isLoading,
      onTap: _selectConsumedAt,
      decoration: const InputDecoration(
        labelText: 'Consumed at',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select when you consumed the drink.';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(LoadingFormState form) {
    return form.buildSubmitButton(
      text: 'Submit',
      margin: const EdgeInsets.only(bottom: 16),
      onSubmit: () => widget.onSubmit(
        _selectedDrinkType,
        _selectedConsumedAt,
        int.parse(_volumeController.text),
        _location,
      ),
    );
  }

  void _updateLocationText() {
    if (_location != null) {
      _locationController.text =
          '${_location!.latitude.toStringAsFixed(5)}, ${_location!.longitude.toStringAsFixed(5)}';
    } else {
      _locationController.text = '';
    }
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    final position = await _locationService.getCurrentPosition();
    if (mounted) {
      setState(() {
        _isLoadingLocation = false;
        if (position != null) {
          _location = GeoPoint(position.latitude, position.longitude);
          _updateLocationText();
        }
      });
    }
  }
}
