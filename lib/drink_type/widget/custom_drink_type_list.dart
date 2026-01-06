import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/widget/drink_type_tile.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class CustomDrinkTypeList extends StatelessWidget {
  CustomDrinkTypeList({super.key});

  final _drinkTypeController = get<DrinkTypeController>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _drinkTypeController.entitiesStreamForCurrentUser,
      builder: (builder, customDrinkTypes) {
        return ListView.separated(
          separatorBuilder: (_, _) => const Divider(),
          itemCount: customDrinkTypes.length,
          itemBuilder: (context, index) {
            final drinkType = customDrinkTypes[index];
            return DrinkTypeTile(drinkType: drinkType);
          },
        );
      },
    );
  }
}
