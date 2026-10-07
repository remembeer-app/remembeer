import 'package:dartvex/dartvex.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart' show MutationMode;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/user.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user_settings/model/drink_log_list_sort.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class DrinkLogListSortPage extends StatelessWidget {
  const DrinkLogListSortPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Drink Log Order',
      autmaticallyImplyLeading: true,
      hint:
          'Choose how drink logs and sessions are sorted in the list. '
          '"Newest first" shows your most recent drink logs and sessions at the top, '
          'while "Oldest first" shows them at the bottom.',
      child: UserCurrentQuery(
        builder: (context, user) => UserUpdateDrinkLogSortOrderMutation(
          mode: MutationMode.latest,
          optimisticUpdate: _optimisticUpdateSortOrder,
          builder: (context, mutate, snapshot) {
            final selectedSort = switch (user.drinkLogSortOrder.value) {
              'asc' => DrinkLogListSortOrder.ascending,
              _ => DrinkLogListSortOrder.descending,
            };
            void onChanged(DrinkLogListSortOrder? value) {
              if (value == null || value == selectedSort) return;
              mutate.run(
                drinkLogSortOrder:
                    UpdateDrinkLogSortOrderArgsDrinkLogSortOrder.fromJson(
                      value == DrinkLogListSortOrder.ascending ? 'asc' : 'desc',
                    ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RadioGroup<DrinkLogListSortOrder>(
                    groupValue: selectedSort,
                    onChanged: onChanged,
                    child: Column(
                      children: [
                        for (final sort in DrinkLogListSortOrder.values)
                          Card(
                            child: ListTile(
                              leading: Radio<DrinkLogListSortOrder>(
                                value: sort,
                              ),
                              title: Text(sort.displayName),
                              subtitle: Text(sort.description),
                              selected: selectedSort == sort,
                              onTap: () => onChanged(sort),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (snapshot.error case final error?) ...[
                    const Gap(16),
                    ErrorMessageBox(message: error.toString()),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _optimisticUpdateSortOrder(
    TypedOptimisticLocalStore store,
    UpdateDrinkLogSortOrderArgs args,
    OptimisticMutationContext _,
  ) {
    store.updateQuery(
      currentQueryReference,
      const NoArgs(),
      (user) => (
        creationTime: user.creationTime,
        id: user.id,
        accentColor: user.accentColor,
        authUserId: user.authUserId,
        avatarUrl: user.avatarUrl,
        defaultDrink: user.defaultDrink,
        drinkLogSortOrder: CurrentResultDrinkLogSortOrder.fromJson(
          args.drinkLogSortOrder.value,
        ),
        endOfDayBoundary: user.endOfDayBoundary,
        normalizedUsername: user.normalizedUsername,
        username: user.username,
      ),
    );
  }
}
