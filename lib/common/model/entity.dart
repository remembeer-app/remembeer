import 'package:remembeer/common/model/document.dart';

abstract class Entity extends Document {
  String get userId;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;
}
