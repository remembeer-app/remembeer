import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/notification/constants.dart';

void main() {
  test('androidNotificationIcon points to an existing Android resource', () {
    final match = RegExp(r'^@(\w+)/(\w+)$').firstMatch(androidNotificationIcon);
    expect(match, isNotNull, reason: 'expected the @type/name form');

    final type = match!.group(1)!;
    final name = match.group(2)!;
    final resDir = Directory('android/app/src/main/res');
    final found = resDir
        .listSync()
        .whereType<Directory>()
        .where(
          (dir) => dir.uri.pathSegments
              .lastWhere((s) => s.isNotEmpty)
              .startsWith(type),
        )
        .expand((dir) => dir.listSync().whereType<File>())
        .any(
          (file) => RegExp(
            '^$name\\.(png|xml|webp)\$',
          ).hasMatch(file.uri.pathSegments.last),
        );

    expect(
      found,
      isTrue,
      reason:
          '$androidNotificationIcon is missing from ${resDir.path}; '
          'the local notifications plugin throws at startup without it',
    );
  });
}
