import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/widget/drink_type_picker.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class DefaultDrinkPage extends StatefulWidget {
  const DefaultDrinkPage({super.key});

  @override
  State<DefaultDrinkPage> createState() => _DefaultDrinkPageState();
}

class _DefaultDrinkPageState extends State<DefaultDrinkPage> {
  final _userSettingsService = get<UserSettingsService>();
  final _formKey = GlobalKey<FormState>();

  DrinkType? _selectedDrinkType;
  int? _selectedVolume;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Default drink'),
      hint:
          'This drink is pre-filled when adding a drink. It is also added '
          'automatically when you long-press the plus button on the drink '
          'page or use the home screen widget.',
      onFabPressed: _saveSettings,
      child: AsyncBuilder(
        future: _userSettingsService.currentUserSettings,
        builder: (context, userSettings) {
          _selectedDrinkType ??= userSettings.defaultDrinkType;
          _selectedVolume ??= userSettings.defaultDrinkSize;

          return Form(
            key: _formKey,
            child: Column(
              children: [_buildDrinkTypeDropdown(), gap16, _buildVolumeInput()],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _userSettingsService.updateDefaultDrinkType(_selectedDrinkType!);
    await _userSettingsService.updateDefaultDrinkSize(_selectedVolume!);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildVolumeInput() {
    return TextFormField(
      initialValue: _selectedVolume?.toString(),
      decoration: const InputDecoration(
        labelText: 'Default Volume (ml)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a volume';
        }
        final volume = int.tryParse(value);
        if (volume == null || volume <= 0) {
          return 'Please enter a valid volume';
        }
        return null;
      },
      onChanged: (value) {
        _selectedVolume = int.tryParse(value);
      },
    );
  }

  Widget _buildDrinkTypeDropdown() {
    return DrinkTypePicker(
      selectedDrinkType: _selectedDrinkType!,
      onChanged: (newValue) {
        setState(() {
          _selectedDrinkType = newValue;
        });
      },
    );
  }
}
