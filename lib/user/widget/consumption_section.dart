import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';

const _iconSize = 30.0;

class ConsumptionSection extends StatelessWidget {
  final UserModel user;

  ConsumptionSection({super.key, required this.user});

  final _userStatsService = get<UserStatsService>();

  @override
  Widget build(BuildContext context) {
    final userStats = _userStatsService.fromUser(user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Consumption Stats', style: profilePageHeading),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatSection(
                  title: 'Last 30 Days',
                  beersConsumed: userStats.beersConsumedLast30Days,
                  alcoholConsumed: userStats.alcoholConsumedLast30Days,
                ),
                gap16,
                _buildStatSection(
                  title: 'Total Lifetime',
                  beersConsumed: userStats.totalBeersConsumed,
                  alcoholConsumed: userStats.totalAlcoholConsumed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatSection({
    required String title,
    required double beersConsumed,
    required double alcoholConsumed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const Divider(color: Colors.black26, height: 20, thickness: 1),
        _buildStatTile(
          label: 'Beers Consumed',
          value: beersConsumed.toStringAsFixed(1),
          icon: const DrinkIcon(category: DrinkCategory.beer, size: _iconSize),
        ),
        _buildStatTile(
          label: 'Alcohol Consumed (ml)',
          value: alcoholConsumed.toStringAsFixed(0),
          icon: const DrinkIcon(category: DrinkCategory.wine, size: _iconSize),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required String label,
    required String value,
    required Widget icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
