import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/common/formatter/uppercase_formatter.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/leaderboard/constants.dart';
import 'package:remembeer/leaderboard/widget/found_leaderboard_card.dart';

class JoinLeaderboardPage extends StatefulWidget {
  const JoinLeaderboardPage({super.key});

  @override
  State<JoinLeaderboardPage> createState() => _JoinLeaderboardPageState();
}

class _JoinLeaderboardPageState extends State<JoinLeaderboardPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  String? _searchedCode;
  var _searchVersion = 0;
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
          const Gap(16),
          _buildSearchButton(),
          const Gap(24),
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
        if (_searchedCode != null || _errorMessage != null) {
          setState(() {
            _searchedCode = null;
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
      return _buildErrorState(_errorMessage!);
    }

    if (_searchedCode case final code?) {
      return LeaderboardFindByInviteCodeQuery(
        key: ValueKey((code, _searchVersion)),
        inviteCode: code,
        errorBuilder: (context, error) => _buildErrorState(error.toString()),
        builder: (_, leaderboard) {
          if (leaderboard == null) {
            return _buildErrorState('No leaderboard found with this code.');
          }
          return LeaderboardJoinMutation(
            builder: (_, join, snapshot) {
              if (snapshot.error case final error?) {
                return _buildErrorState(error.toString());
              }
              return FoundLeaderboardCard(
                leaderboard: leaderboard,
                onJoin: snapshot.isLoading
                    ? null
                    : () => join.run(
                        id: leaderboard.id,
                        onSuccess: (result) {
                          if (!mounted) return;
                          switch (result) {
                            case JoinResult.successValue:
                            case JoinResult.alreadyMemberValue:
                              context.pop();
                            case JoinResult.fullValue:
                              setState(() {
                                _searchedCode = null;
                                _errorMessage = 'Leaderboard is full.';
                              });
                            case JoinResult.bannedValue:
                              setState(() {
                                _searchedCode = null;
                                _errorMessage =
                                    'You are banned from this leaderboard.';
                              });
                          }
                        },
                      ),
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(String message) {
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
          const Gap(12),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _searchLeaderboard() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _searchedCode = _codeController.text.trim().toUpperCase();
      _searchVersion++;
      _errorMessage = null;
    });
  }
}
