enum PartyTab {
  ranking,
  activity,
  games;

  static PartyTab? tryFromString(String? value) {
    for (final tab in PartyTab.values) {
      if (tab.name == value) return tab;
    }
    return null;
  }
}
