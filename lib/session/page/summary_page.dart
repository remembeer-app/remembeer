import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/date/model/date_state.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class SummaryPage extends StatelessWidget {
  SummaryPage({super.key});

  final DateService _dateService = get<DateService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Summary'),
      child: AsyncBuilder<DateState>(
        stream: _dateService.selectedDateStateStream,
        builder: (context, dateState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Date: ${dateState.selectedDate}'),
              Text('Effective Today: ${dateState.effectiveToday}'),
            ],
          );
        },
      ),
    );
  }
}
