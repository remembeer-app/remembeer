import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/session/page/create_session_page.dart';
import 'package:remembeer/session/page/session_management_page.dart';
import 'package:remembeer/session/page/summary_page.dart';

class SessionMenuButton extends StatelessWidget {
  const SessionMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'create':
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => CreateSessionPage(),
              ),
            );
          case 'summary':
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => SummaryPage()),
            );
          case 'signature':
            // TODO(ohtenkay): Implement signature drinks
            break;
          case 'manage':
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => SessionManagementPage(),
              ),
            );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'create',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Create Session'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'summary',
          child: ListTile(
            leading: Icon(Icons.summarize),
            title: Text('Generate Summary'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'signature',
          child: ListTile(
            leading: Icon(Icons.local_bar),
            title: Text('Signature Drinks'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'manage',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Manage Sessions'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sessions', style: TextStyle(fontSize: 18, color: color)),
          const Gap(4),
          Icon(Icons.table_bar, size: 28, color: color),
        ],
      ),
    );
  }
}
