import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}

/// A JsonConverter that converts between DateTime and Timestamp,
/// providing a fallback to the current time if the Timestamp is null.
///
/// This is useful for fields that use FieldValue.serverTimestamp() in Firestore,
/// which may result in null values when the document is still being created and
/// the server timestamp has not yet been set.
/// Once Firestore sets the timestamp, the data class using this converter
/// will be automatically updated with the correct DateTime value.
class TimestampConverterOptimistic
    implements JsonConverter<DateTime, Timestamp?> {
  const TimestampConverterOptimistic();

  @override
  DateTime fromJson(Timestamp? timestamp) {
    if (timestamp == null) {
      return DateTime.now();
    }
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
