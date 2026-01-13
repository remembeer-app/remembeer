import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/formatter/uppercase_formatter.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/constants.dart';
import 'package:remembeer/leaderboard/model/join_leaderboard_result.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/widget/found_leaderboard_card.dart';

class JoinLeaderboardPage extends StatefulWidget {
  const JoinLeaderboardPage({super.key});

  @override
  State<JoinLeaderboardPage> createState() => _JoinLeaderboardPageState();
}

class _JoinLeaderboardPageState extends State<JoinLeaderboardPage> {
  final _leaderboardService = get<LeaderboardService>();

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  Leaderboard? _foundLeaderboard;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Join Leaderboard'),
      child: Column(
        children: [
          Form(key: _formKey, child: _buildCodeInput()),
          gap16,
          _buildSearchButton(),
          gap24,
          Expanded(child: _buildResult()),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return TextFormField(
      controller: _codeController,
      maxLength: inviteCodeLength,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(inviteCodeLength),
        UpperCaseTextFormatter(),
      ],
      decoration: const InputDecoration(
        labelText: 'Invite Code',
        hintText: 'Enter 8-character code',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.key),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an invite code.';
        }
        if (value.trim().length != inviteCodeLength) {
          return 'Invite code must be $inviteCodeLength characters.';
        }
        return null;
      },
      onChanged: (_) {
        if (_foundLeaderboard != null || _errorMessage != null) {
          setState(() {
            _foundLeaderboard = null;
            _errorMessage = null;
          });
        }
      },
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _searchLeaderboard,
        icon: const Icon(Icons.search),
        label: const Text('Find Leaderboard'),
      ),
    );
  }

  Widget _buildResult() {
    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_foundLeaderboard != null) {
      return FoundLeaderboardCard(
        leaderboard: _foundLeaderboard!,
        onJoin: _joinLeaderboard,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: theme.colorScheme.error.withValues(alpha: 0.7),
          ),
          gap12,
          Text(
            _errorMessage!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLeaderboard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _foundLeaderboard = null;
      _errorMessage = null;
    });

    final code = _codeController.text.trim().toUpperCase();
    final leaderboard = await _leaderboardService.findByInviteCode(code);

    setState(() {
      if (leaderboard == null) {
        _errorMessage = 'No leaderboard found with this code.';
      } else {
        _foundLeaderboard = leaderboard;
      }
    });
  }

  Future<void> _joinLeaderboard() async {
    if (_foundLeaderboard == null) return;

    final result = await _leaderboardService.joinLeaderboard(
      _foundLeaderboard!,
    );

    if (!mounted) return;

    switch (result) {
      case JoinLeaderboardResult.success:
      case JoinLeaderboardResult.alreadyMember:
        Navigator.of(context).pop();
      case JoinLeaderboardResult.full:
        setState(() {
          _foundLeaderboard = null;
          _errorMessage = 'Leaderboard is full.';
        });
      case JoinLeaderboardResult.banned:
        setState(() {
          _foundLeaderboard = null;
          _errorMessage = 'You are banned from this leaderboard.';
        });
    }
  }
}
