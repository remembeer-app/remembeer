import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/model/drink_type_create.dart';
import 'package:remembeer/user/constants.dart';

class DrinkTypeController extends CrudController<DrinkType, DrinkTypeCreate> {
  DrinkTypeController({required super.authService})
    : super(collectionPath: 'drink_types', fromJson: DrinkType.fromJson);

  @override
  Stream<List<DrinkType>> get entitiesStreamForCurrentUser => nonDeletedEntities
      .where(
        userIdField,
        whereIn: [authService.authenticatedUser.uid, globalUserId],
      )
      .orderBy('name')
      .mapToStreamList();
}
