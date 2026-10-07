import 'package:dartvex/dartvex.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart' show MutationMode;
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
      autmaticallyImplyLeading: true,
      hint:
          'Your accent identifies you in Party Mode and can be changed anytime.',
      child: UserCurrentQuery(
        builder: (context, user) => UserUpdateAccentColorMutation(
          mode: MutationMode.latest,
          optimisticUpdate: _optimisticUpdateAccentColor,
          builder: (context, mutate, snapshot) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AccentColorSelector(
                  value: AccentColorKey.values.byName(
                    user.accentColor.value! as String,
                  ),
                  onChanged: (color) {
                    if (color.name == user.accentColor.value) return;
                    mutate.run(
                      accentColor: UpdateAccentColorArgsAccentColor.fromJson(
                        color.name,
                      ),
                    );
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
