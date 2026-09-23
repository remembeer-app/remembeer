import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/convex_api/runtime.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_tile.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class CustomDrinkList extends StatelessWidget {
  CustomDrinkList({super.key});

  final _drinkService = get<DrinkService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<TypedQueryResult<List<ListCustomResultItem>>>(
      stream: _drinkService.customDrinks.stream,
      builder: (context, result) => _buildResult(result),
    );
  }

  Widget _buildResult(TypedQueryResult<List<ListCustomResultItem>> result) {
    return switch (result) {
      TypedQueryLoading<List<ListCustomResultItem>>() => const Center(
        child: CircularProgressIndicator(),
      ),
      TypedQueryError<List<ListCustomResultItem>>(:final message) => Center(
        child: Text('Error: $message'),
      ),
      TypedQuerySuccess<List<ListCustomResultItem>>(:final value) => _buildList(
        value,
      ),
    };
  }

  Widget _buildList(List<ListCustomResultItem> customDrinks) {
    if (customDrinks.isEmpty) {
      return const Center(child: Text('No custom drinks yet.'));
    }

    return ListView.separated(
      separatorBuilder: (_, _) => const Divider(),
      itemCount: customDrinks.length,
      itemBuilder: (context, index) {
        return DrinkTile(drink: customDrinks[index]);
      },
    );
  }
}
