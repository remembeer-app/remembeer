import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkPickerSheet extends StatefulWidget {
  final DrinkSnapshot selectedDrink;

  const DrinkPickerSheet({super.key, required this.selectedDrink});

  @override
  State<DrinkPickerSheet> createState() => _DrinkPickerSheetState();
}

class _DrinkPickerSheetState extends State<DrinkPickerSheet> {
  final _drinkController = get<DrinkController>();

  final _searchController = TextEditingController();
  var _searchQuery = '';
  Set<DrinkCategory> _selectedCategories = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Iterable<DrinkSnapshot> _filterDrinks(Set<DrinkSnapshot> drinks) {
    return drinks.where((drink) {
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = drink.name.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        if (!matchesSearch) {
          return false;
        }
      }

      if (_selectedCategories.isNotEmpty) {
        if (!_selectedCategories.contains(drink.category)) {
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
              Expanded(child: _buildDrinkList(scrollController)),
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

  Widget _buildDrinkList(ScrollController scrollController) {
    return AsyncBuilder(
      stream: _drinkController.allAvailableDrinksStream.map(
        (drinks) => drinks
            .map(
              (drink) => DrinkSnapshot(
                name: drink.name,
                category: drink.category,
                alcoholPercentage: drink.alcoholPercentage,
              ),
            )
            .toSet(),
      ),
      builder: (context, drinks) {
        drinks.add(widget.selectedDrink);

        final filteredDrinks = _filterDrinks(drinks);

        if (filteredDrinks.isEmpty) {
          return _buildEmptyState();
        }

        final groupedDrinks = <DrinkCategory, List<DrinkSnapshot>>{};
        for (final drink in filteredDrinks) {
          groupedDrinks.putIfAbsent(drink.category, () => []).add(drink);
        }

        final sortedCategories = DrinkCategory.values
            .where(groupedDrinks.containsKey)
            .toList();

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: sortedCategories.length,
          itemBuilder: (context, index) {
            final category = sortedCategories[index];
            final drinks = groupedDrinks[category]!;

            return _buildCategorySection(category, drinks);
          },
        );
      },
    );
  }

  Widget _buildCategorySection(
    DrinkCategory category,
    List<DrinkSnapshot> drinks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              DrinkIcon(category: category, size: 20),
              const Gap(8),
              Text(
                category.displayName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: category.defaultColor,
                ),
              ),
              const Gap(8),
              Text(
                '(${drinks.length})',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ...drinks.map(_buildDrinkTile),
      ],
    );
  }

  Widget _buildDrinkTile(DrinkSnapshot drink) {
    final isSelected = widget.selectedDrink == drink;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: drink.category.defaultColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: DrinkIcon(category: drink.category, size: 26)),
      ),
      title: Text(
        drink.name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        'ABV: ${drink.alcoholPercentage}%',
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : Icon(Icons.circle_outlined, color: colorScheme.outlineVariant),
      selected: isSelected,
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () => Navigator.of(context).pop(drink),
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
            const Gap(16),
            Text(
              'No drinks found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
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
