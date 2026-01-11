enum DrinkListSortOrder {
  descending,
  ascending;

  String get displayName {
    return switch (this) {
      DrinkListSortOrder.descending => 'Newest first',
      DrinkListSortOrder.ascending => 'Oldest first',
    };
  }

  String get description {
    return switch (this) {
      DrinkListSortOrder.descending =>
        'Most recent drinks and sessions appear at the top',
      DrinkListSortOrder.ascending =>
        'Oldest drinks and sessions appear at the top',
    };
  }
}
