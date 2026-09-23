enum DrinkLogListSortOrder {
  descending,
  ascending;

  String get displayName {
    return switch (this) {
      DrinkLogListSortOrder.descending => 'Newest first',
      DrinkLogListSortOrder.ascending => 'Oldest first',
    };
  }

  String get description {
    return switch (this) {
      DrinkLogListSortOrder.descending =>
        'Most recent drinks and sessions appear at the top',
      DrinkLogListSortOrder.ascending =>
        'Oldest drinks and sessions appear at the top',
    };
  }
}
