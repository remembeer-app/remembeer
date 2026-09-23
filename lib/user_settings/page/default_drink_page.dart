import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink/widget/drink_picker.dart';
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

  DrinkSnapshot? _selectedDrink;
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
          _selectedDrink ??= userSettings.defaultDrink;
          _selectedVolume ??= userSettings.defaultDrinkSize;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                _buildDrinkDropdown(),
                const Gap(16),
                _buildVolumeInput(),
              ],
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

    await _userSettingsService.updateDefaultDrink(_selectedDrink!);
    await _userSettingsService.updateDefaultDrinkSize(_selectedVolume!);

    if (mounted) {
      context.pop();
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

  Widget _buildDrinkDropdown() {
    return DrinkPicker(
      selectedDrink: _selectedDrink!,
      onChanged: (newValue) {
        setState(() {
          _selectedDrink = newValue;
        });
      },
    );
  }
}
