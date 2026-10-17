import 'package:remembeer/convex_api/types.dart';

extension DrinkLogSortPresentation on UserDocumentDrinkLogSortOrder {
  String get displayName => switch (this) {
    UserDocumentDrinkLogSortOrder.descValue => 'Newest first',
    UserDocumentDrinkLogSortOrder.ascValue => 'Oldest first',
  };

  String get description => switch (this) {
    UserDocumentDrinkLogSortOrder.descValue =>
      'Most recent drinks and sessions appear at the top',
    UserDocumentDrinkLogSortOrder.ascValue =>
      'Oldest drinks and sessions appear at the top',
  };
}
