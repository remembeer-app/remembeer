import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class DrinkListSortPage extends StatefulWidget {
  const DrinkListSortPage({super.key});

  @override
  State<DrinkListSortPage> createState() => _DrinkListSortPageState();
}

class _DrinkListSortPageState extends State<DrinkListSortPage> {
  final _userSettingsService = get<UserSettingsService>();

  DrinkListSortOrder? _selectedSort;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Drink List Order'),
      hint:
          'Choose how drinks and sessions are sorted in the list. '
          '"Newest first" shows your most recent drinks and sessions at the top, '
          'while "Oldest first" shows them at the bottom.',
      child: AsyncBuilder(
        future: _userSettingsService.currentUserSettings,
        builder: (context, userSettings) {
          _selectedSort ??= userSettings.drinkListSortOrder;

          return RadioGroup<DrinkListSortOrder>(
            groupValue: _selectedSort,
            onChanged: _onSortChanged,
            child: Column(
              children: DrinkListSortOrder.values
                  .map(_buildSortOption)
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(DrinkListSortOrder sort) {
    final isSelected = _selectedSort == sort;

    return Card(
      child: ListTile(
        leading: Radio<DrinkListSortOrder>(value: sort),
        title: Text(sort.displayName),
        subtitle: Text(sort.description),
        selected: isSelected,
        onTap: () => _onSortChanged(sort),
      ),
    );
  }

  Future<void> _onSortChanged(DrinkListSortOrder? value) async {
    if (value == null) return;
    setState(() {
      _selectedSort = value;
    });
    await _userSettingsService.updateDrinkListSort(value);
  }
}
