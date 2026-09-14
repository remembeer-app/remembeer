import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/legal/util/legal_links.dart';

class PrivacyPolicyNotice extends StatefulWidget {
  const PrivacyPolicyNotice({super.key, this.onOpen});

  final VoidCallback? onOpen;

  @override
  State<PrivacyPolicyNotice> createState() => _PrivacyPolicyNoticeState();
}

class _PrivacyPolicyNoticeState extends State<PrivacyPolicyNotice> {
  late final _recognizer = TapGestureRecognizer()..onTap = _handleTap;

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    final colorScheme = Theme.of(context).colorScheme;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          const TextSpan(text: 'By creating an account you agree to our '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: _recognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  void _handleTap() {
    (widget.onOpen ?? openPrivacyPolicy).call();
  }
}
