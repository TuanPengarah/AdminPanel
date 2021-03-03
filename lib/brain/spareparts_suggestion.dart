class PartsSuggestion {
  static final List<String> parts = [
    'LCD',
    'Battery',
    'Charging pin',
    'Sub Board',
    'Speaker',
    'Power Button',
    'Power Button Ribbon',
    'Back Camera',
    'Front Camera',
    'Back Glass',
    'Housing',
    'Main Ribbon',
    'Vibrate',
    'Front Speaker',
    'Home Button Ribbon',
    'Fingerprint',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(parts);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
