import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  const baseJson = <String, Object>{
    'id': 'user-1',
    'email': 'user@example.com',
    'username': 'User',
    'searchableUsername': 'user',
  };

  test('complete profile safely round trips through JSON', () {
    final user = UserModel.fromJson({...baseJson, 'accentColorKey': 'violet'});

    expect(user.accentColorKey, AccentColorKey.violet);
    expect(user.accentColor, accentColorPalette[AccentColorKey.violet]);
    expect(user.toJson(), containsPair('accentColorKey', 'violet'));
  });

  test('existing profile missing an accent remains readable', () {
    final user = UserModel.fromJson(baseJson);

    expect(user.accentColorKey, isNull);
    expect(user.accentColor, isNull);
  });

  test('unknown persisted accent key is rejected', () {
    expect(
      () => UserModel.fromJson({...baseJson, 'accentColorKey': 'blue'}),
      throwsArgumentError,
    );
  });

  test('default accent assignment is deterministic and in the palette', () {
    final first = defaultAccentColorFor('stable-user-id');
    final second = defaultAccentColorFor('stable-user-id');

    expect(second, first);
    expect(accentColorPalette, contains(first));
    expect(accentColorPalette.length, AccentColorKey.values.length);
  });
}
