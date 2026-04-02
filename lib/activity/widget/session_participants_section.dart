import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/page/profile_page.dart';

class SessionParticipantsSection extends StatelessWidget {
  final List<UserModel> members;

  const SessionParticipantsSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Participants (${members.length})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: members.map((member) {
            return _buildMemberCard(context, member);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, UserModel member) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ProfilePage(userId: member.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(user: member, size: 16),
              const Gap(8),
              Text(
                member.username,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
