import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';

class DrinkCategoryField extends FormField<DrinkCategory> {
  final ValueChanged<DrinkCategory>? onChanged;
  final VoidCallback? onFieldSubmitted;

  DrinkCategoryField({
    super.key,
    super.initialValue,
    super.enabled = true,
    super.autovalidateMode,
    FormFieldValidator<DrinkCategory>? validator,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(
         validator: validator ?? _validateCategory,
         builder: (state) => (state as _DrinkCategoryFieldState)._buildField(),
       );

  static String? _validateCategory(DrinkCategory? value) =>
      value == null ? 'Please select a category.' : null;

  @override
  FormFieldState<DrinkCategory> createState() => _DrinkCategoryFieldState();
}

class _DrinkCategoryFieldState extends FormFieldState<DrinkCategory> {
  final _focusNode = FocusNode();

  @override
  DrinkCategoryField get widget => super.widget as DrinkCategoryField;

  void _select(DrinkCategory category) {
    if (!widget.enabled) return;
    _focusNode.requestFocus();
    if (category.runtimeType == value.runtimeType) return;
    didChange(category);
    widget.onChanged?.call(category);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final direction = switch (key) {
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.arrowDown => 1,
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.arrowUp => -1,
      _ => 0,
    };
    if (direction != 0) {
      final index = convexDrinkCategories.indexWhere(
        (category) => category.runtimeType == value.runtimeType,
      );
      _select(
        convexDrinkCategories[index < 0
            ? 0
            : (index + direction) % convexDrinkCategories.length],
      );
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      if (value == null) {
        _select(convexDrinkCategories.first);
      } else {
        widget.onFieldSubmitted?.call();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildField() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Focus(
      focusNode: _focusNode,
      canRequestFocus: widget.enabled,
      onKeyEvent: _handleKey,
      onFocusChange: (_) => setState(() {}),
      child: InputDecorator(
        isFocused: _focusNode.hasFocus,
        decoration: InputDecoration(
          labelText: 'Category',
          enabled: widget.enabled,
          errorText: errorText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns =
                ((constraints.maxWidth + drinkCategoryTileGap) /
                        (drinkCategoryTileMinWidth + drinkCategoryTileGap))
                    .floor()
                    .clamp(1, convexDrinkCategories.length);
            final width =
                (constraints.maxWidth - drinkCategoryTileGap * (columns - 1)) /
                columns;
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: drinkCategoryTileGap,
              runSpacing: drinkCategoryTileGap,
              children: [
                for (final category in convexDrinkCategories)
                  _buildTile(category, width, theme, colors),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(
    DrinkCategory category,
    double width,
    ThemeData theme,
    ColorScheme colors,
  ) {
    final selected = category.runtimeType == value.runtimeType;
    final foreground = !widget.enabled
        ? colors.onSurface.withValues(alpha: 0.38)
        : selected
        ? colors.onPrimaryContainer
        : colors.onSurfaceVariant;
    const radius = BorderRadius.all(Radius.circular(drinkCategoryTileRadius));
    return SizedBox(
      width: width,
      child: Semantics(
        label: category.displayName,
        button: true,
        selected: selected,
        enabled: widget.enabled,
        inMutuallyExclusiveGroup: true,
        onTap: widget.enabled ? () => _select(category) : null,
        child: ExcludeSemantics(
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: selected
                  ? colors.primaryContainer
                  : colors.surfaceContainerLow,
              borderRadius: radius,
              border: Border.all(
                color: selected ? colors.primary : colors.outlineVariant,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                canRequestFocus: false,
                borderRadius: radius,
                onTap: widget.enabled ? () => _select(category) : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(drinkCategoryTilePadding),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            category.iconPath,
                            width: drinkCategoryTileIconSize,
                            height: drinkCategoryTileIconSize,
                            colorFilter: ColorFilter.mode(
                              foreground,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            category.displayName,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Icon(
                          Icons.check_circle,
                          size: 16,
                          color: foreground,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
