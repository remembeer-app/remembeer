import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/modules/user.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class DefaultDrinkPage extends StatefulWidget {
  const DefaultDrinkPage({super.key});

  @override
  State<DefaultDrinkPage> createState() => _DefaultDrinkPageState();
}

class _DefaultDrinkPageState extends State<DefaultDrinkPage> {
  final _api = get<ConvexApi>();

  late final Future<CurrentResult> _userFuture;
  late final Future<List<ListAvailableResultItem>> _drinksFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _api.user.current();
    _drinksFuture = _api.drink.listAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: _userFuture,
      builder: (context, user) => AsyncBuilder(
        future: _drinksFuture,
        builder: (context, drinks) => _DefaultDrinkForm(
          key: ValueKey(user.id),
          user: user,
          drinks: drinks,
          api: _api,
        ),
      ),
    );
  }
}

class _DefaultDrinkForm extends StatefulWidget {
  final CurrentResult user;
  final List<ListAvailableResultItem> drinks;
  final ConvexApi api;

  const _DefaultDrinkForm({
    super.key,
    required this.user,
    required this.drinks,
    required this.api,
  });

  @override
  State<_DefaultDrinkForm> createState() => _DefaultDrinkFormState();
}

class _DefaultDrinkFormState extends State<_DefaultDrinkForm> {
  late final TextEditingController _volumeController;
  late DrinkId? _selectedDrinkId;

  @override
  void initState() {
    super.initState();
    _selectedDrinkId =
        widget.drinks.any((drink) => drink.id == widget.user.defaultDrink)
        ? widget.user.defaultDrink
        : null;
    _volumeController = TextEditingController(
      text: widget.user.defaultDrinkVolumeMl.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingForm(
      builder: (form) => SettingsPageTemplate(
        title: const Text('Default drink'),
        hint: 'Choose your preferred drink and serving volume.',
        onFabPressed: form.isLoading ? null : () => _save(form),
        child: Column(
          children: [
            DropdownButtonFormField<DrinkId>(
              initialValue: _selectedDrinkId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Drink',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final drink in widget.drinks)
                  DropdownMenuItem(
                    value: drink.id,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DrinkIcon(
                          category: drink.drinkCategory.legacyCategory,
                          size: 24,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            drink.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: widget.drinks.isEmpty
                  ? null
                  : (drinkId) => _selectedDrinkId = drinkId,
              validator: (drinkId) =>
                  drinkId == null ? 'Please select a drink' : null,
            ),
            const Gap(16),
            form.buildTextField(
              controller: _volumeController,
              label: 'Default Volume (ml)',
              keyboardType: TextInputType.number,
              isLastField: true,
              validator: (value) {
                final volume = int.tryParse(value?.trim() ?? '');
                if (volume == null || volume <= 0) {
                  return 'Please enter a positive whole number';
                }
                return null;
              },
            ),
            form.buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Future<void> _save(LoadingFormState form) async {
    if (!form.validate()) return;

    await form.runAction(() async {
      await widget.api.user.updateDefaultDrink(
        defaultDrink: _selectedDrinkId,
        defaultDrinkVolumeMl: int.parse(
          _volumeController.text.trim(),
        ).toDouble(),
      );
      if (mounted) context.pop();
    });
  }
}
