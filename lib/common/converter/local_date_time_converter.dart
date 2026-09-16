import 'package:json_annotation/json_annotation.dart';

/// Converts between an ISO-8601 string and a [DateTime] in the local time zone.
///
/// The app writes local date-times without a UTC offset, while the backend
/// writes them with one. `DateTime.parse` returns a UTC value for the latter,
/// which would then be displayed and grouped by UTC hours. Normalising to the
/// local time zone keeps both forms consistent for the UI and for logical-day
/// calculations.
class LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toIso8601String();
}
