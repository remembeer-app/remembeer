import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkTypePickerSheet extends StatefulWidget {
  final DrinkTypeCore selectedDrinkType;

  const DrinkTypePickerSheet({super.key, required this.selectedDrinkType});

  @override
  State<DrinkTypePickerSheet> createState() => _DrinkTypePickerSheetState();
}

class _DrinkTypePickerSheetState extends State<DrinkTypePickerSheet> {
  final _drinkTypeController = get<DrinkTypeController>();

  final _searchController = TextEditingController();
  var _searchQuery = '';
  Set<DrinkCategory> _selectedCategories = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Iterable<DrinkTypeCore> _filterDrinkTypes(Set<DrinkTypeCore> drinkTypes) {
    return drinkTypes.where((drinkType) {
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = drinkType.name.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        if (!matchesSearch) {
          return false;
        }
      }

      if (_selectedCategories.isNotEmpty) {
        if (!_selectedCategories.contains(drinkType.category)) {
          return false;
        }
      }

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              _buildHandle(colorScheme),
              _buildHeader(theme),
              _buildSearchBar(colorScheme),
              _buildCategoryFilters(colorScheme),
              const Divider(height: 1),
              Expanded(child: _buildDrinkTypeList(scrollController)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Select Drink',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search drinks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilters(ColorScheme colorScheme) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildAllCategoryChip(colorScheme),
          ...DrinkCategory.values.map(
            (category) => _buildCategoryChip(category, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCategoryChip(ColorScheme colorScheme) {
    final isSelected = _selectedCategories.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        label: const Text('All'),
        avatar: isSelected ? null : const Icon(Icons.local_drink, size: 18),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedCategories = {};
            });
          }
        },
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(
          color: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(DrinkCategory category, ColorScheme colorScheme) {
    final isSelected = _selectedCategories.contains(category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        label: Text(category.displayName),
        avatar: isSelected
            ? null
            : DrinkIcon(
                category: category,
                size: 18,
                color: category.defaultColor,
              ),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedCategories = {..._selectedCategories, category};
            } else {
              _selectedCategories = _selectedCategories
                  .where((c) => c != category)
                  .toSet();
            }
          });
        },
        selectedColor: category.defaultColor.withValues(alpha: 0.2),
        checkmarkColor: category.defaultColor,
        labelStyle: TextStyle(
          color: isSelected
              ? category.defaultColor
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: isSelected
            ? BorderSide(color: category.defaultColor.withValues(alpha: 0.5))
            : null,
      ),
    );
  }

  Widget _buildDrinkTypeList(ScrollController scrollController) {
    return AsyncBuilder(
      stream: _drinkTypeController.entitiesStreamForCurrentUser.map(
        (drinkTypes) => drinkTypes.map((e) => e.toEmbedded()).toSet(),
      ),
      builder: (context, drinkTypes) {
        drinkTypes.add(widget.selectedDrinkType);

        final filteredDrinkTypes = _filterDrinkTypes(drinkTypes);

        if (filteredDrinkTypes.isEmpty) {
          return _buildEmptyState();
        }

        final groupedDrinkTypes = <DrinkCategory, List<DrinkTypeCore>>{};
        for (final drinkType in filteredDrinkTypes) {
          groupedDrinkTypes
              .putIfAbsent(drinkType.category, () => [])
              .add(drinkType);
        }

        final sortedCategories = DrinkCategory.values
            .where(groupedDrinkTypes.containsKey)
            .toList();

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: sortedCategories.length,
          itemBuilder: (context, index) {
            final category = sortedCategories[index];
            final drinkTypes = groupedDrinkTypes[category]!;

            return _buildCategorySection(category, drinkTypes);
          },
        );
      },
    );
  }

  Widget _buildCategorySection(
    DrinkCategory category,
    List<DrinkTypeCore> drinkTypes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              DrinkIcon(category: category, size: 20),
              hGap8,
              Text(
                category.displayName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: category.defaultColor,
                ),
              ),
              hGap8,
              Text(
                '(${drinkTypes.length})',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ...drinkTypes.map(_buildDrinkTile),
      ],
    );
  }

  Widget _buildDrinkTile(DrinkTypeCore drinkType) {
    final isSelected = widget.selectedDrinkType == drinkType;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: drinkType.category.defaultColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: DrinkIcon(category: drinkType.category, size: 26)),
      ),
      title: Text(
        drinkType.name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        'ABV: ${drinkType.alcoholPercentage}%',
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : Icon(Icons.circle_outlined, color: colorScheme.outlineVariant),
      selected: isSelected,
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () => Navigator.of(context).pop(drinkType),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            gap16,
            Text(
              'No drinks found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            gap8,
            Text(
              'Try adjusting your search or filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
