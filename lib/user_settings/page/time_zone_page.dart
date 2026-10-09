import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/widgets/lib/timeZone.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user_settings/widget/settings_page.dart';

class TimeZonePage extends StatelessWidget {
  TimeZonePage({super.key});

  final _deviceTimeZone = FlutterTimezone.getLocalTimezone();

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: 'Account timezone',
      autmaticallyImplyLeading: true,
      hint:
          'Your timezone stays fixed when you travel. It determines when your '
          'logical day begins. Changing it can move past drinks between days.',
      child: UserCurrentQuery(
        builder: (context, user) => UserUpdateTimeZoneMutation(
          builder: (context, mutate, snapshot) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: const Text('Current timezone'),
                  subtitle: Text(user.timeZone),
                  leading: const Icon(Icons.schedule),
                ),
                AsyncBuilder<TimezoneInfo>(
                  future: _deviceTimeZone,
                  waitingBuilder: (context) =>
                      const Text('Detecting device timezone…'),
                  errorBuilder: (context, error) =>
                      const Text('Device timezone unavailable. Search below.'),
                  builder: (context, zone) => OutlinedButton.icon(
                    icon: const Icon(Icons.my_location),
                    label: Text('Use device timezone (${zone.identifier})'),
                    onPressed:
                        snapshot.isLoading || zone.identifier == user.timeZone
                        ? null
                        : () => mutate.run(timeZone: zone.identifier),
                  ),
                ),
                const Gap(16),
                SearchAnchor.bar(
                  enabled: !snapshot.isLoading,
                  barHintText: 'Search city or region',
                  viewHintText: 'Search city or region',
                  suggestionsBuilder: (context, controller) {
                    final search = controller.text.trim();
                    if (search.isEmpty) {
                      return [
                        const ListTile(
                          title: Text('Type a city or region to search.'),
                        ),
                      ];
                    }
                    return [
                      LibTimeZoneSearchTimeZonesQuery(
                        key: ValueKey(search),
                        search: search,
                        builder: (context, timeZones) => Column(
                          children: [
                            if (timeZones.isEmpty)
                              const ListTile(
                                title: Text('No timezones found.'),
                              ),
                            for (final timeZone in timeZones)
                              ListTile(
                                title: Text(timeZone.replaceAll('_', ' ')),
                                onTap: () {
                                  controller.closeView(null);
                                  if (timeZone != user.timeZone) {
                                    mutate.run(timeZone: timeZone);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
                if (snapshot.isLoading) ...[
                  const Gap(16),
                  const LinearProgressIndicator(),
                ],
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
}
