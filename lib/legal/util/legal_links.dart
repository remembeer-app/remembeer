import 'package:remembeer/legal/constants.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openPrivacyPolicy() => launchUrl(
  Uri.parse(privacyPolicyUrl),
  mode: LaunchMode.externalApplication,
);

Future<void> contactSupport() => launchUrl(
  Uri(
    scheme: 'mailto',
    path: supportEmail,
    query: 'subject=${Uri.encodeComponent(supportEmailSubject)}',
  ),
);
