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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisExtent: 48,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            return _buildMemberCard(context, members[index]);
          },
        ),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, UserModel member) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ProfilePage(userId: member.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              UserAvatar(user: member, size: 16),
              const Gap(8),
              Expanded(
                child: Text(
                  member.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
