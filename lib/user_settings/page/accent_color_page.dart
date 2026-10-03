import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/modules/user.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/widget/accent_color_selector.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class AccentColorPage extends StatelessWidget {
  const AccentColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Accent Color',
      hint:
          'Your accent identifies you in Party Mode and can be changed anytime.',
      child: UserCurrentQuery(
        builder: (context, user) => UserUpdateAccentColorMutation(
          optimisticUpdate: _optimisticUpdateAccentColor,
          builder: (context, mutate, snapshot) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AccentColorSelector(
                  value: AccentColorKey.values.byName(
                    user.accentColor.value! as String,
                  ),
                  enabled: !snapshot.isLoading,
                  onChanged: (color) {
                    if (color.name == user.accentColor.value) return;
                    mutate(
                      accentColor: UpdateAccentColorArgsAccentColor.fromJson(
                        color.name,
                      ),
                    ).ignore();
                  },
                ),
                if (snapshot.error case final error?) ...[
                  const Gap(16),
                  ErrorMessageBox(message: error.toString()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _optimisticUpdateAccentColor(
    TypedOptimisticLocalStore store,
    UpdateAccentColorArgs args,
    OptimisticMutationContext _,
  ) {
    store.updateQuery(
      currentQueryReference,
      const NoArgs(),
      (user) => (
        creationTime: user.creationTime,
        id: user.id,
        accentColor: CurrentResultAccentColor.fromJson(args.accentColor.value),
        authUserId: user.authUserId,
        avatarUrl: user.avatarUrl,
        defaultDrink: user.defaultDrink,
        drinkLogSortOrder: user.drinkLogSortOrder,
        endOfDayBoundary: user.endOfDayBoundary,
        normalizedUsername: user.normalizedUsername,
        username: user.username,
      ),
    );
  }
}
