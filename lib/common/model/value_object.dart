// Base class for create DTOs that can be serialized to JSON, needed for type safe generics.
// ignore_for_file: one_member_abstracts
abstract class ValueObject {
  Map<String, dynamic> toJson();
}
