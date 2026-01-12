import 'package:diacritic/diacritic.dart';

extension Searchable on String {
  String toSearchable() {
    return removeDiacritics(this).toLowerCase().replaceAll(' ', '');
  }
}
