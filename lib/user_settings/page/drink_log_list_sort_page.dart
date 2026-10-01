import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/model/drink_log_list_sort.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class DrinkLogListSortPage extends StatefulWidget {
  const DrinkLogListSortPage({super.key});

  @override
  State<DrinkLogListSortPage> createState() => _DrinkLogListSortPageState();
}

class _DrinkLogListSortPageState extends State<DrinkLogListSortPage> {
  final _userSettingsService = get<UserSettingsService>();

  DrinkLogListSortOrder? _selectedSort;

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
          _selectedSort ??= userSettings.drinkLogListSortOrder;

          return RadioGroup<DrinkLogListSortOrder>(
            groupValue: _selectedSort,
            onChanged: _onSortChanged,
            child: Column(
              children: DrinkLogListSortOrder.values
                  .map(_buildSortOption)
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(DrinkLogListSortOrder sort) {
    final isSelected = _selectedSort == sort;

    return Card(
      child: ListTile(
        leading: Radio<DrinkLogListSortOrder>(value: sort),
        title: Text(sort.displayName),
        subtitle: Text(sort.description),
        selected: isSelected,
        onTap: () => _onSortChanged(sort),
      ),
    );
  }

  Future<void> _onSortChanged(DrinkLogListSortOrder? value) async {
    if (value == null) return;
    setState(() {
      _selectedSort = value;
    });
    await _userSettingsService.updateDrinkLogListSort(value);
  }
}
