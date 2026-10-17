import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/accent_color.dart';

extension AccentColorPresentation on UserDocumentAccentColor {
  AccentColor get presentation => accentColorPalette[this]!;
}
