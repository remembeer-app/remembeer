import 'package:diacritic/diacritic.dart';

extension Serchable on String {
  String toSearchable() {
    return removeDiacritics(this).toLowerCase().replaceAll(' ', '');
  }
}
