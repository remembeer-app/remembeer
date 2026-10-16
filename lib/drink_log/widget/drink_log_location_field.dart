import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:remembeer/drink_log/constants.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/routes.dart';

class DrinkLogLocationField extends FormField<LatLng> {
  final ValueChanged<LatLng?> onChanged;

  DrinkLogLocationField({
    super.key,
    LatLng? initialLocation,
    super.enabled,
    required this.onChanged,
  }) : super(
         initialValue: initialLocation,
         builder: (state) =>
             (state as _DrinkLogLocationFieldState)._buildField(),
       );

  @override
  FormFieldState<LatLng> createState() => _DrinkLogLocationFieldState();
}

class _DrinkLogLocationFieldState extends FormFieldState<LatLng> {
  final _focusNode = FocusNode();
  final _locationService = get<LocationService>();
  var _isLoadingLocation = false;
  String? _locationError;

  @override
  DrinkLogLocationField get widget => super.widget as DrinkLogLocationField;

  String get _locationText => value == null
      ? 'Tap to set location'
      : '${value!.latitude.toStringAsFixed(5)}, ${value!.longitude.toStringAsFixed(5)}';

  void _setLocation(LatLng? location) {
    didChange(location);
    widget.onChanged(location);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildField() {
    final isDisabled = !widget.enabled || _isLoadingLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          focusNode: _focusNode,
          onFocusChange: (_) => setState(() {}),
          borderRadius: BorderRadius.circular(12),
          onTap: isDisabled ? null : _openLocationPicker,
          child: InputDecorator(
            isFocused: widget.enabled && _focusNode.hasFocus,
            decoration: InputDecoration(
              labelText: 'Location (optional)',
              enabled: !isDisabled,
              errorText: _locationError,
              hintText: 'Tap to set location',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: const Icon(Icons.location_on),
              suffixIcon: value != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear location',
                      onPressed: isDisabled ? null : () => _setLocation(null),
                    )
                  : null,
            ),
            child: Text(_locationText),
          ),
        ),
        const Gap(8),
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
            const Gap(8),
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

  Future<LatLng?> _currentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });
    try {
      final position = await _locationService.getCurrentPosition();
      return position == null
          ? null
          : LatLng(position.latitude, position.longitude);
    } on Exception catch (error) {
      if (mounted) setState(() => _locationError = error.toString());
      return null;
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _openLocationPicker() async {
    final startLocation =
        value ?? await _currentLocation() ?? drinkLogDefaultLocation;
    if (!mounted || !widget.enabled) return;
    final newLocation = await LocationPickerRoute(
      latitude: startLocation.latitude,
      longitude: startLocation.longitude,
    ).push<LatLng>(context);
    if (newLocation != null && mounted && widget.enabled) {
      _setLocation(newLocation);
    }
  }

  Future<void> _fetchCurrentLocation() async {
    final location = await _currentLocation();
    if (location != null && mounted && widget.enabled) _setLocation(location);
  }
}
