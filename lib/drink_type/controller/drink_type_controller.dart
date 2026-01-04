import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/model/drink_type_create.dart';
import 'package:remembeer/user/constants.dart';

class DrinkTypeController extends Controller<DrinkType, DrinkTypeCreate> {
  DrinkTypeController({required super.authService})
    : super(collectionPath: 'drink_types', fromJson: DrinkType.fromJson);

  Stream<List<DrinkType>> get allAvailableDrinkTypesStream => readCollection
      .where(deletedAtField, isNull: true)
      .where(
        userIdField,
        whereIn: [authService.authenticatedUser.uid, globalUserId],
      )
      .orderBy('name')
      .snapshots()
      .map(
        (querySnapshot) => List.unmodifiable(
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        ),
      );
}
