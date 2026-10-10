import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/widget/user_card.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final _searchController = TextEditingController();
  String? _query;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(searchDebounceDuration, () {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Search Users'),
    child: Column(
      children: [
        TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Search by username or email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const Gap(16),
        Expanded(child: _buildSearchResults()),
      ],
    ),
  );

  Widget _buildSearchResults() {
    final query = _query;
    if (query == null || query.isEmpty) {
      return const Center(
        child: Text('Enter a username or email to start searching.'),
      );
    }
    // TODO(ohtenkay): Replace empty email/short-query results and full-username matching with Convex prefix/email search.
    if (query.contains('@') ||
        query.length < minUsernameLength ||
        query.length > maxUsernameLength) {
      return const Center(child: Text('No users found.'));
    }
    return UserSearchQuery(
      username: query,
      builder: (context, users) => users.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  userId: user.id,
                  username: user.username,
                  avatarUrl: user.avatarUrl,
                );
              },
            ),
    );
  }
}
