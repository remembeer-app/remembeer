import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/user/constants.dart';

class DrinkController extends CrudController<Drink, DrinkCreate> {
  DrinkController({required super.authService})
    : super(collectionPath: 'drinks', fromJson: Drink.fromJson);

  Stream<List<Drink>> get allAvailableDrinksStream => nonDeletedEntities
      .where(
        userIdField,
        whereIn: [authService.authenticatedUser.uid, globalUserId],
      )
      .orderBy('name')
      .mapToStreamList();
}
